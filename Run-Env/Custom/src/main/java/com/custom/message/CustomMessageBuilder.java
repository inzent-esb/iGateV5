package com.custom.message ;

import java.text.MessageFormat ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;

import com.inzent.igate.context.TransactionContext ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.mapping.MappingEngine ;
import com.inzent.igate.message.Array ;
import com.inzent.igate.message.ArrayImpl ;
import com.inzent.igate.message.Field ;
import com.inzent.igate.message.IMessageBuilder ;
import com.inzent.igate.message.Individual ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageBuilder ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.MappingRule ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.message.MessageTranslator ;

public class CustomMessageBuilder extends MessageBuilder implements CustomMessageConstants
{
  @Override
  public Record mappingResponseHeader(Record target, Record[] source, Interface interfaceMeta, Service serviceMeta, Log log) throws IGateException
  {
    return mappingMessagePart(super.mappingResponseHeader(target, source, interfaceMeta, serviceMeta, log), source, log) ;
  }

  @Override
  public Record mappingResponseHeader(Record target, Record[] source, Service serviceMeta, Log log) throws IGateException
  {
    return mappingMessagePart(super.mappingResponseHeader(target, source, serviceMeta, log), source, log) ;
  }

  @Override
  public Record mappingReplyHeader(Record target, Record[] source, Service serviceMeta, Log log) throws IGateException
  {
    return mappingMessagePart(super.mappingReplyHeader(target, source, serviceMeta, log), source, log) ;
  }

  @Override
  public void copyInterfaceResponse(Record target, Individual targetIndividual, Record[] sources, Individual[] sourceIndividuals, Interface interfaceMeta, Service service, int serviceIndex, String targetFormId, Log log) throws IGateException
  {
    mappingIndividualHeader(target, targetIndividual, sources, sourceIndividuals, serviceIndex, targetFormId, log) ;

    super.copyInterfaceResponse(target, targetIndividual, sources, sourceIndividuals, interfaceMeta, service, serviceIndex, targetFormId, log) ;
  }

  @Override
  public boolean mappingInterfaceResponse(Record target, Individual targetIndividual, Record[] sources, Individual[] sourceIndividuals, MappingRule mappingRule, Interface interfaceMeta, Service service, int serviceIndex, String targetFormId, Log log) throws IGateException
  {
    mappingIndividualHeader(target, targetIndividual, sources, sourceIndividuals, serviceIndex, targetFormId, log) ;

    return super.mappingInterfaceResponse(target, targetIndividual, sources, sourceIndividuals, mappingRule, interfaceMeta, service, serviceIndex, targetFormId, log) ;
  }

  @Override
  public void copyServiceRequest(Record target, Individual targetIndividual, Record[] sources, Individual[] sourceIndividuals, Interface interfaceMeta, Service service, Log log) throws IGateException
  {
    mappingIndividualHeader(target, targetIndividual, sources, sourceIndividuals, -1, null, log) ;

    super.copyServiceRequest(target, targetIndividual, sources, sourceIndividuals, interfaceMeta, service, log) ;
  }

  @Override
  public void mappingServiceRequest(Record target, Individual targetIndividual, Record[] sources, Individual[] sourceIndividuals, String mappingId, Interface interfaceMeta, Service service, Log log) throws IGateException
  {
    mappingIndividualHeader(target, targetIndividual, sources, sourceIndividuals, -1, null, log) ;

    super.mappingServiceRequest(target, targetIndividual, sources, sourceIndividuals, mappingId, interfaceMeta, service, log) ;
  }

  @Override
  public void mappingServiceRequest(Record target, Individual targetIndividual, Record[] sources, String mappingId, Service operationService, Service service, Log log) throws IGateException
  {
    mappingIndividualHeader(target, targetIndividual, sources, new Individual[] { ((RecordImpl) sources[0]).getIndividuals().iterator().next() }, -1, null, log) ;

    super.mappingServiceRequest(target, targetIndividual, sources, mappingId, operationService, service, log) ;
  }

  @Override
  public void mappingServiceResponse(Record target, Individual targetIndividual, Record[] sources, String mappingId, Service service, Log log) throws IGateException
  {
    Record dataHeader = (Record) target.getField(StringUtils.substringBeforeLast(targetIndividual.individualPath, DATA_BODY_ID) + DATA_HEADER_ID) ;
    dataHeader.setFieldValue(SERVICE_ID_FIELD, TransactionContext.getValue(TransactionContext.SERVICE, (String) null)) ;

    super.mappingServiceResponse(target, targetIndividual, sources, mappingId, service, log) ;
  }

  @Override
  protected void addIndividualRecord(RecordImpl record, String individualId, String recordId, String serviceId, List<String> targetForms, Log log) throws IGateException
  {
    if (record.getAdapterId().startsWith(PRE_FIX_STD))
    {
      Individual individual = record.addIndividual(individualId, individualId + Field.NAME_SEPARATOR_STRING + DATA_BODY_ID, recordId, serviceId, targetForms) ;
      RecordImpl addRecord = (RecordImpl) record.addIndividualRecord(EMPTY_RECORD, individual.individualId) ;

      addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
      addRecord.addRecord(individual.recordId, DATA_BODY_ID) ;
    }
    else
      super.addIndividualRecord(record, individualId, recordId, serviceId, targetForms, log) ;
  }

  protected Record mappingMessagePart(Record target, Record[] sources, Log log) throws IGateException
  {
    RecordImpl targetIndividualRoot = (RecordImpl) target ;
    RecordImpl sourceIndividualRoot = (RecordImpl) sources[0] ;
    for (int index = 0, count = sourceIndividualRoot.getSize() ; count > index ; index++)
    {
      Field field = sourceIndividualRoot.getField(index) ;
      if (!field.getId().startsWith(MESSAGE_ID))
        continue ;

      Record addRecord = targetIndividualRoot.addIndividualRecord(IMessageBuilder.EMPTY_RECORD, MESSAGE_ID + "_" + index) ;
      addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
      Record targetMessage = addRecord.addRecord(MESSAGE_RECORD, DATA_BODY_ID) ;
      Field targetMessageCode = null;
     
      ArrayImpl targetMessageContent = (ArrayImpl) targetMessage.getField(MESSAGE_CONTENT_FIELD) ;

      String targetPrefix = addRecord.getPath() + Field.NAME_SEPARATOR_STRING + DATA_HEADER_ID ;
      String[] sourcePrefix = new String[sources.length] ;
      sourcePrefix[0] = field.getPath() + Field.NAME_SEPARATOR_STRING + DATA_HEADER_ID ;

      MappingEngine.mapping(DATA_HEADER_MAPPING, log, target, targetPrefix, sources, sourcePrefix) ;

      Array sourceMessageContent = (Array) ((Record) field).getField(DATA_BODY_ID + Field.NAME_SEPARATOR_STRING + MESSAGE_CONTENT_FIELD) ;
      String errorCode = ((String) sourceMessageContent.getField(0).getValue()).trim() ;
    

      //==============================
      Field messageCodeField =((Record) field).getField(DATA_BODY_ID + Field.NAME_SEPARATOR_STRING + MESSAGE_CODE_FIELD) ;
      String messageCodeValue = null;
      if( messageCodeField !=null)
        messageCodeValue = ((String)(messageCodeField.getValue())).trim();
      
      log.info(">>> messageCodeValue :" + messageCodeValue);
      int idx1 = 0 ;
      for (String message : MessageTranslator.getStandardMessage(messageCodeValue,
          targetIndividualRoot.getAdapterId(), (String) target.getFieldValue(LANG_CD_PATH)))
      {
        log.info(" ¦¦ StandardMessage" + message);
        if (StringUtils.isBlank(message))
          break ;

        if (0 == idx1)
        {
          Object[] arguments = new Object[sourceMessageContent.getSize()] ;
          for (int idy = 0 ; arguments.length > idy ; idy++)
            arguments[idy] = sourceMessageContent.getField(idy).getValue() ;

          message = MessageFormat.format(message, arguments) ; 
        }
        log.info(" ¦¦ message " + idx1 + " : " + message);
        
      }
      //==============================
      if(targetMessage.hasField(MESSAGE_CODE_FIELD))
      {
        targetMessageCode = (Field) targetMessage.getField(MESSAGE_CODE_FIELD) ;
        targetMessageCode.setValue(messageCodeValue);
      }
      
      log.info(">>> errorCode :" + errorCode);
      int idx = 0 ;
      for (String message : MessageTranslator.getStandardMessage(errorCode,
          targetIndividualRoot.getAdapterId(), (String) target.getFieldValue(LANG_CD_PATH)))
      {
        log.info("¦¦ StandardMessage" + message);        
        if (StringUtils.isBlank(message))
          break ;

        if (0 == idx)
        {
          Object[] arguments = new Object[sourceMessageContent.getSize() - 1] ;
          for (int idy = 0 ; arguments.length > idy ; idy++)
            arguments[idy] = sourceMessageContent.getField(idy + 1).getValue() ;

          message = MessageFormat.format(message, arguments) ; 
        }
        log.info(" ¦¦ message " + idx + " : " + message);

        targetMessageContent.getField(idx++).setValue(message) ;
      }

      targetMessageContent.offAddMode() ;
    }

    return target ;
  }

  protected void mappingIndividualHeader(Record target, Individual targetIndividual, Record[] sources, Individual[] individuals, int serviceIndex, String targetFormId, Log log) throws IGateException
  {
    if (((RecordImpl) target).getAdapterId().startsWith(PRE_FIX_STD))
    {
      String targetPrefix = StringUtils.substringBeforeLast(targetIndividual.individualPath, DATA_BODY_ID) + DATA_HEADER_ID ;

      if (((RecordImpl) sources[0]).getAdapterId().startsWith(PRE_FIX_STD))
      {
        String[] sourcePrefix = new String[sources.length] ;
        sourcePrefix[0] = StringUtils.substringBeforeLast(individuals[0].individualPath, DATA_BODY_ID) + DATA_HEADER_ID ;

        MappingEngine.mapping(DATA_HEADER_MAPPING, log, target, targetPrefix, sources, sourcePrefix) ;
      }

      if (null != targetFormId)
      {
        target.getField(targetPrefix + Field.NAME_SEPARATOR_STRING + FORM_ID_FIELD + "[0]").setValue(targetFormId) ;
        ((ArrayImpl) target.getField(targetPrefix + Field.NAME_SEPARATOR_STRING + FORM_ID_FIELD)).offAddMode() ;
      }
    }
  }

  @Override
  public Interface findInterface(MessageConverter messageConverter, Interface interfaceMeta, Service service) throws IGateException
  {
    if (null != interfaceMeta.getInterfaceService(service.getServiceId()))
      return interfaceMeta ;
    else
      return MessageBeans.SINGLETON.interfaceManager.get(
          "IF" + interfaceMeta.getAdapterId().substring(1, 5) + service.getServiceId().substring(2)) ;
  }
}
