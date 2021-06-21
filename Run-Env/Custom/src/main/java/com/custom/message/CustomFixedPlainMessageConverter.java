package com.custom.message ;

import java.nio.charset.StandardCharsets ;
import java.util.ArrayList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;

import com.custom.CustomMessage ;
import com.inzent.igate.common.CommonMessage ;
import com.inzent.igate.exception.IGateAdapterException ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.exception.IGateMessageException ;
import com.inzent.igate.message.Field ;
import com.inzent.igate.message.IMessageBuilder ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.message.plain.FixedPlainMessageConverter ;
import com.inzent.igate.repository.meta.Adapter ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.Numeric ;
import com.inzent.igate.util.StringCodec ;

public class CustomFixedPlainMessageConverter extends FixedPlainMessageConverter implements CustomMessageConstants
{
  public static final byte[] END_BYTES = "ZZ".getBytes(StandardCharsets.US_ASCII) ;

  public CustomFixedPlainMessageConverter(Adapter adapter, Object data) throws Exception
  {
    super(adapter, (byte[]) data, 0, null != data ? ((byte[]) data).length - END_BYTES.length : 0) ;

    if (null != data)
      for (int idx = length, idx2 = 0 ; buffer.length > idx ; idx++, idx2++)
        if (buffer[idx] != END_BYTES[idx2])
          throw new IGateAdapterException(adapter,
              CustomMessage.INVALID_END_DELIM, CustomMessage.INVALID_END_DELIM_MESSAGE,
              adapter.getAdapterId()) ;
  }

  @Override
  public void compose(Record record, Log log) throws IGateException
  {
    int dataHeaderPos = -1 ;
    int dataSize = 0 ;
    if (com.inzent.igate.repository.meta.Field.TYPE_INDIVIDUAL == record.getType())
    {
      dataHeaderPos = getComposeDataCount() ;
      dataSize = getComposeDataLength() ;
    }

    super.compose(record, log) ;

    if (0 <= dataHeaderPos) // �����ͼ��� ���̸� ���
    {
      try
      {
        byte[] buf = getComposeData(dataHeaderPos + 1) ;
        byte[] len = String.format("%0" + DATA_LEN_LENGTH + "d", getComposeDataLength() - dataSize - DATA_TYPE_LENGTH - DATA_LEN_LENGTH).getBytes(StandardCharsets.US_ASCII) ;

        System.arraycopy(len, 0, buf, 0, len.length) ;
      }
      catch (Throwable th)
      {
        throw new IGateMessageException(th,
            CommonMessage.COMPOSE_ERROR_FIELD, CommonMessage.COMPOSE_ERROR_FIELD_MESSAGE,
            record.getPath(), th.getMessage()) ;
      }
    }
    else if (null == record.getParent()) // ǥ�������� ���̸� ���
    {
      try
      {
        addComposeData(END_BYTES) ;

        byte[] buf = getComposeData(0) ;
        byte[] len = String.format("%0" + DATA_LEN_LENGTH + "d", getComposeDataLength() - DATA_LEN_LENGTH).getBytes(StandardCharsets.US_ASCII) ;

        System.arraycopy(len, 0, buf, 0, len.length) ;
      }
      catch (Throwable th)
      {
        throw new IGateMessageException(th,
            CommonMessage.COMPOSE_ERROR_FIELD, CommonMessage.COMPOSE_ERROR_FIELD_MESSAGE,
            record.getPath(), th.getMessage()) ;
      }
    }
  }

  /**
   * �ʵ尡 null�̰�(���δ���� �ƴ� ���) �ʵ�Ӽ��� �⺻���� ���� ��� Numeric Ÿ���� �⺻���� ' ' �̴�. ���� ��
   * ��쿡�� '0'���� �е��ϱ����� overriding
   **/
  @Override
  protected Object encodingNumeric(Field field, Numeric source) throws IGateException
  {
    return super.encodingNumeric(field, (source == null) ? new Numeric("0", null, field.getLength(), field.getScale()) : source) ;
  }

  @Override
  public Record parseInterfaceRequest(Interface interfaceMeta, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getRequestStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != buffer)
    {
      // ��������ο� ������ RecordSet�� �����Ѵ�.
      if (STD_HEADER_LENGTH < length)
        record = MessageBeans.SINGLETON.messageBuilder.addInterfaceRequestIndividual(record, this, interfaceMeta, log) ;

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addInterfaceRequestIndividual(record, this, interfaceMeta, log) ;

    return record ;
  }

  @Override
  public Record parseInterfaceResponse(Interface interfaceMeta, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getResponseStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != buffer)
    {
      int pos1 = STD_HEADER_LENGTH, pos2, len, outputFormCount, index = 0 ;
      String typeCode, outServiceId, outputFormId ;
      Service outService ;
      Interface outInterface ;

      while (length > pos1)
      {
        typeCode = StringCodec.decode(buffer, pos1, DATA_TYPE_LENGTH, adapter.getCharset()) ;
        pos1 += DATA_TYPE_LENGTH ;

        len = Integer.parseInt(StringCodec.decode(buffer, pos1, DATA_LEN_LENGTH, adapter.getCharset())) ;
        pos1 += DATA_LEN_LENGTH ;

        switch (typeCode)
        {
        case DATA_TYPE_DATA :
          pos2 = pos1 ;

          outServiceId = StringUtils.stripEnd(StringCodec.decode(buffer, pos2, SERVICE_ID_LENGTH, adapter.getCharset()), null) ;
          pos2 += SERVICE_ID_LENGTH + SCREEN_ID_LENGTH ;

          outputFormCount = Integer.parseInt(StringCodec.decode(buffer, pos2, FORM_COUNT_LENGTH, adapter.getCharset())) ;
          pos2 += FORM_COUNT_LENGTH ;

          outputFormId = 0 < outputFormCount ? StringUtils.stripEnd(StringCodec.decode(buffer, pos2, SCREEN_ID_LENGTH, adapter.getCharset()), null) : null ;

          if (StringUtils.isBlank(outServiceId))
          {
            outService = MessageBeans.SINGLETON.serviceManager.get(interfaceMeta.getInterfaceServices().get(0).getPk().getServiceId()) ;
            outInterface = interfaceMeta ;
          }
          else
          {
            outService = MessageBeans.SINGLETON.serviceManager.get(outServiceId) ;
            outInterface = MessageBeans.SINGLETON.messageBuilder.findInterface(this, interfaceMeta, outService) ;
          }

          record = MessageBeans.SINGLETON.messageBuilder.addInterfaceResponseIndividual(record, this, outInterface, outService, index++, outputFormId, log) ;
          break ;

        case DATA_TYPE_MSG_NORMAL :
        case DATA_TYPE_MSG_ERROR :
          Record addRecord = ((RecordImpl) record).addIndividualRecord(IMessageBuilder.EMPTY_RECORD, MESSAGE_ID + "_" + index++) ;
          addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
          addRecord.addRecord(MESSAGE_RECORD, DATA_BODY_ID) ;
          break ;

        default :
          throw new IllegalArgumentException(typeCode) ;
        }

        pos1 += len ;
      }

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addInterfaceResponseIndividual(record, this, interfaceMeta,
          MessageBeans.SINGLETON.serviceManager.get(interfaceMeta.getInterfaceServices().get(0).getPk().getServiceId()), -1, null, log) ;

    return record ;
  }

  @Override
  public Record parseServiceRequest(Service service, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getRequestStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != buffer)
    {
      // ��������ο� ������ RecordSet�� �����Ѵ�.
      if (STD_HEADER_LENGTH < length)
        record = MessageBeans.SINGLETON.messageBuilder.addServiceRequestIndividual(record, this, service, log) ;

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addServiceRequestIndividual(record, this, service, log) ;

    return record ;
  }

  @Override
  public Record parseServiceResponse(Service service, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getResponseStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != buffer)
    {
      int pos1 = STD_HEADER_LENGTH, pos2, len, outputFormCount, index = 0 ;
      String typeCode, outServiceId ;
      Service outService ;
      while (length > pos1)
      {
        typeCode = StringCodec.decode(buffer, pos1, DATA_TYPE_LENGTH, adapter.getCharset()) ;
        pos1 += DATA_TYPE_LENGTH ;

        len = Integer.parseInt(StringCodec.decode(buffer, pos1, DATA_LEN_LENGTH, adapter.getCharset())) ;
        pos1 += DATA_LEN_LENGTH ;

        switch (typeCode)
        {
        case DATA_TYPE_DATA :
          pos2 = pos1 ;

          outServiceId = StringUtils.stripEnd(StringCodec.decode(buffer, pos2, SERVICE_ID_LENGTH, adapter.getCharset()), null) ;
          pos2 += SERVICE_ID_LENGTH + SCREEN_ID_LENGTH ;

          outputFormCount = Integer.parseInt(StringCodec.decode(buffer, pos2, FORM_COUNT_LENGTH, adapter.getCharset())) ;
          pos2 += FORM_COUNT_LENGTH ;

          // ��� �� ID ���
          List<String> outputFormIds ;
          if (outputFormCount > 0)
          {
            outputFormIds = new ArrayList<String>(outputFormCount) ;
            for (int idx = 0 ; outputFormCount > idx ; idx++) // ��� �� ID ���
            {
              outputFormIds.add(StringUtils.stripEnd(StringCodec.decode(buffer, pos2, SCREEN_ID_LENGTH, adapter.getCharset()), null)) ;
              pos2 += SCREEN_ID_LENGTH ;
            }
          }
          else
            outputFormIds = null ;

          outService = StringUtils.isBlank(outServiceId) ? service : MessageBeans.SINGLETON.serviceManager.get(outServiceId.trim()) ;
          record = MessageBeans.SINGLETON.messageBuilder.addServiceResponseIndividual(record, this, outService, index++, outputFormIds, log) ;
          break ;

        case DATA_TYPE_MSG_NORMAL :
        case DATA_TYPE_MSG_ERROR :
          Record addRecord = ((RecordImpl) record).addIndividualRecord(IMessageBuilder.EMPTY_RECORD, MESSAGE_ID + "_" + index++) ;
          addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
          addRecord.addRecord(MESSAGE_RECORD, DATA_BODY_ID) ;
          break ;

        default :
          throw new IllegalArgumentException(typeCode) ;
        }

        pos1 += len ;
      }

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addServiceResponseIndividual(record, this, service, -1, null, log) ;

    return record ;
  }
}
