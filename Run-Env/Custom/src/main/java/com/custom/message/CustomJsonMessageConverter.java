package com.custom.message ;

import java.io.IOException ;
import java.util.Iterator ;
import java.util.LinkedList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.node.ArrayNode ;
import com.fasterxml.jackson.databind.node.ObjectNode ;
import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.message.Field ;
import com.inzent.igate.message.IMessageBuilder ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.Record ;
import com.inzent.igate.message.RecordImpl ;
import com.inzent.igate.message.json.JsonMessageConverter ;
import com.inzent.igate.repository.meta.Adapter ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.util.Numeric ;

public class CustomJsonMessageConverter extends JsonMessageConverter implements CustomMessageConstants
{
  protected Position individual ;

  public CustomJsonMessageConverter(Adapter adapter, Object data) throws IOException
  {
    super(adapter, data) ;
  }

  @Override
  public void parse(Record record, Log log) throws IGateException
  {
    super.parse(record, log) ;
  }

  @Override
  protected Object encodingNumeric(Field field, Numeric source) throws IGateException
  {
    return null != source ? source.toNumber() : null ;
  }

  @Override
  protected ObjectNode getIndividualPosition(Record record)
  {
    if (null == individual)
      individual = new Position((ArrayNode) root.get(BODY_ROOT)) ;

    return (ObjectNode) individual.iterator.next() ;
  }

  @Override
  protected ObjectNode addIndividualPosition(Record record)
  {
    if (null == individual)
      individual = new Position(((ObjectNode)root).putArray(BODY_ROOT)) ;

    return individual.arrayNode.addObject() ;
  }

  @Override
  protected void removeIndividualPosition(Record record, Position parent, ObjectNode current)
  {
    individual.arrayNode.remove(individual.arrayNode.size() - 1) ;
  }

  @Override
  public Record parseInterfaceRequest(Interface interfaceMeta, Log log) throws IGateException
  {
    record = createRecord(getAdapter().getRequestStructure(), com.inzent.igate.repository.meta.Field.TYPE_RECORD) ;

    if (null != root)
    {
      ArrayNode arrNode = (ArrayNode) root.get(BODY_ROOT) ;
      if (null != arrNode && 0 < arrNode.size())
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

    if (null != root)
    {
      ArrayNode arrNode = (ArrayNode) root.get(BODY_ROOT) ;
      if (null != arrNode)
      {
        int index = 0 ;

        for (JsonNode node : arrNode)
        {
          JsonNode header = node.path(DATA_HEADER_ID) ;
          switch (header.path(DATA_TYPE_FIELD).textValue())
          {
          case DATA_TYPE_DATA :
            String outServiceId = header.path(SERVICE_ID_FIELD).textValue() ;
            String outputFormId = 0 < header.path(FORM_COUNT_FIELD).intValue() ? header.path(FORM_ID_FIELD).get(0).textValue() : null ;

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
            throw new IllegalArgumentException(header.path(DATA_TYPE_FIELD).textValue()) ;
          }
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

    if (null != root)
    {
      ArrayNode arrNode = (ArrayNode) root.get(BODY_ROOT) ;
      if (null != arrNode && 0 < arrNode.size())
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

    if (null != root)
    {
      ArrayNode arrNode = (ArrayNode) root.get(BODY_ROOT) ;
      if (null != arrNode)
      {
        int index = 0 ;

        for (JsonNode node : arrNode)
        {
          JsonNode header = node.path(DATA_HEADER_ID) ;
          switch (header.path(DATA_TYPE_FIELD).textValue())
          {
          case DATA_TYPE_DATA :
            String outServiceId = header.path(SERVICE_ID_FIELD).textValue() ;
            Service outService = StringUtils.isBlank(outServiceId) ? service : MessageBeans.SINGLETON.serviceManager.get(outServiceId.trim()) ;
            List<String> targetForms ;
            if (0 < header.path(FORM_COUNT_FIELD).intValue())
            {
              targetForms = new LinkedList<>() ;

              Iterator<JsonNode> it = ((ArrayNode) header.path(FORM_ID_FIELD)).iterator() ; ;
              while (it.hasNext())
                targetForms.add(it.next().asText()) ;
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
            throw new IllegalArgumentException(header.path(DATA_TYPE_FIELD).textValue()) ;
          }
        }
      }

      parse(record, log) ;
    }
    else
      record = MessageBeans.SINGLETON.messageBuilder.addServiceResponseIndividual(record, this, service, -1, null, log) ;

    return record ;
  }
}