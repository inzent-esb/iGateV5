package com.custom.message ;

import java.util.LinkedList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;
import org.dom4j.DocumentException ;
import org.dom4j.Element ;

import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.IMessageBuilder ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.message.xml.XmlMessageConverter ;
import com.inzent.igate.repository.meta.Adapter ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Service ;

public class CustomXmlMessageConverter extends XmlMessageConverter implements CustomMessageConstants
{
  protected Position individual ;

  public CustomXmlMessageConverter(Adapter adapter, Object data) throws DocumentException
  {
    super(adapter, data) ;
  }

  @Override
  protected Element getIndividualPosition(Record record)
  {
    if (null == individual)
      individual = new Position(getRootElement().elements(BODY_ROOT)) ;

    return individual.iterator.next() ;
  }

  @Override
  protected Element addIndividualPosition(Record record)
  {
    if (null == individual)
      individual = new Position(getRootElement()) ;

    return individual.element.addElement(BODY_ROOT) ;
  }

  @Override
  protected void removeIndividualPosition(Record record, Element current)
  {
    current.getParent().remove(current) ;
  }

  @Override
  public Record parseInterfaceRequest(Interface interfaceMeta, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getRequestStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != document)
    {
      if (0 < getRootElement().elements(BODY_ROOT).size())
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

    if (null != document)
    {
      int index = 0 ;

      for (Element element : getRootElement().elements(BODY_ROOT))
      {
        Element header = element.element(DATA_HEADER_ID) ;
        switch (header.elementText(DATA_TYPE_FIELD))
        {
        case DATA_TYPE_DATA :
          String outServiceId = header.elementText(SERVICE_ID_FIELD) ;
          String outputFormId = 0 < Integer.parseInt(header.elementText(FORM_COUNT_FIELD)) ? header.elements(FORM_ID_FIELD).get(0).getText() : null ;

          Service outService ;
          Interface outInterface ;
          if (StringUtils.isBlank(outServiceId))
          {
            outService = MessageBeans.SINGLETON.serviceManager.get(interfaceMeta.getInterfaceServices().get(0).getPk().getServiceId()) ;
            outInterface = interfaceMeta ;
          }
          else
          {
            outService = MessageBeans.SINGLETON.serviceManager.get(outServiceId.trim()) ;
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
          throw new IllegalArgumentException(header.elementText(DATA_TYPE_FIELD)) ;
        }
      }

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addInterfaceResponseIndividual(record, this, interfaceMeta, MessageBeans.SINGLETON.serviceManager.get(interfaceMeta.getInterfaceServices().get(0).getPk().getServiceId()), -1, null, log) ;

    return record ;
  }

  @Override
  public Record parseServiceRequest(Service service, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getRequestStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != document)
    {
      if (0 < getRootElement().elements(BODY_ROOT).size())
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

    if (null != document)
    {
      int index = 0 ;

      for (Element element : getRootElement().elements(BODY_ROOT))
      {
        Element header = element.element(DATA_HEADER_ID) ;
        switch (header.elementText(DATA_TYPE_FIELD))
        {
        case DATA_TYPE_DATA :
          String outServiceId = header.elementText(SERVICE_ID_FIELD) ;
          Service outService = StringUtils.isBlank(outServiceId) ? service : MessageBeans.SINGLETON.serviceManager.get(outServiceId.trim()) ;
          List<String> targetForms ;
          if (0 < Integer.parseInt(header.elementText(FORM_COUNT_FIELD)))
          {
            targetForms = new LinkedList<>() ;

            for (Element elementForm : header.elements((FORM_ID_FIELD)))
              targetForms.add(elementForm.getText()) ;
          }
          else
            targetForms = null ;

          record = MessageBeans.SINGLETON.messageBuilder.addServiceResponseIndividual(record, this, outService, index++, targetForms, log) ;
          break ;

        case DATA_TYPE_MSG_NORMAL :
        case DATA_TYPE_MSG_ERROR :
          Record addRecord = ((RecordImpl) record).addIndividualRecord(IMessageBuilder.EMPTY_RECORD, MESSAGE_ID + "_" + index++) ;
          addRecord.addRecord(DATA_HEADER_RECORD, DATA_HEADER_ID) ;
          addRecord.addRecord(MESSAGE_RECORD, DATA_BODY_ID) ;
          break ;

        default :
          throw new IllegalArgumentException(header.elementText(DATA_TYPE_FIELD)) ;
        }
      }

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addServiceResponseIndividual(record, this, service, -1, null, log) ;

    return record ;
  }
}
