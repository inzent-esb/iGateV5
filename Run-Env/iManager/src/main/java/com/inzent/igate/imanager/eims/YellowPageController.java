package com.inzent.igate.imanager.eims;

import java.sql.Timestamp ;
import java.text.ParseException ;
import java.text.SimpleDateFormat ;
import java.util.ArrayList ;
import java.util.Collection ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.Properties ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.InterfaceProperty ;
import com.inzent.igate.repository.meta.InterfacePropertyPK ;
import com.inzent.igate.repository.meta.InterfaceResponse ;
import com.inzent.igate.repository.meta.InterfaceResponsePK ;
import com.inzent.igate.repository.meta.InterfaceService ;
import com.inzent.igate.repository.meta.InterfaceServicePK ;
import com.inzent.igate.repository.meta.Mapping ;
import com.inzent.igate.repository.meta.MappingDetail ;
import com.inzent.igate.repository.meta.MappingDetailPK ;
import com.inzent.igate.repository.meta.MappingRule ;
import com.inzent.igate.repository.meta.MappingRuleDetail ;
import com.inzent.igate.repository.meta.MappingRuleDetailPK ;
import com.inzent.igate.repository.meta.MappingRuleSource ;
import com.inzent.igate.repository.meta.MappingRuleSourcePK ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.igate.repository.meta.ServiceProperty ;
import com.inzent.igate.repository.meta.ServicePropertyPK ;
import com.inzent.igate.util.PropertyUtils ;
import com.inzent.yellowpage.marshaller.Format ;
import com.inzent.yellowpage.marshaller.Link ;
import com.inzent.yellowpage.marshaller.MetaProperties ;
import com.inzent.yellowpage.marshaller.PublishingFormat ;
import com.inzent.yellowpage.marshaller.Receiver ;
import com.inzent.yellowpage.marshaller.Sender ;
import com.inzent.yellowpage.marshaller.YellowPageMarshaller ;

@Controller
@RequestMapping(YellowPageController.URI)
public class YellowPageController extends AbstractEimsController
{
  public static final String URI = "/igate/yellowPage" ;

  public static final String RESULTCODE_OK = "0" ;
  public static final String RESULTCODE_FAIL = "1" ;

  public static final String PROPERTY_TYPE = "Type" ;
  public static final String PROPERTY_SYSTEM = "System" ;
  public static final String PROPERTY_BIZ = "Biz" ;
  public static final String PROPERTY_SERVER = "Server" ;
  public static final String PROPERTY_INTERFACECLASS = "InterfaceClass" ;

  protected static final Map<String, Character> NAME_TYPE_MAP ;     // Field 의 type 맵
  protected static final Map<String, Character> NAME_ARRYTYPE_MAP ; // Field 의 array Type 맵

  static
  {
    NAME_TYPE_MAP = new HashMap<String, Character>() ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_BYTE, Field.TYPE_BYTE) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_SHORT, Field.TYPE_SHORT) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_INT, Field.TYPE_INT) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_LONG, Field.TYPE_LONG) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_FLOAT, Field.TYPE_FLOAT) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_DOUBLE, Field.TYPE_DOUBLE) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_STRING, Field.TYPE_STRING) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_NUMERIC, Field.TYPE_NUMERIC) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_RAW, Field.TYPE_RAW) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_TIMESTAMP, Field.TYPE_TIMESTAMP) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_BOOLEAN, Field.TYPE_BOOLEAN) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_GROUP, Field.TYPE_RECORD) ;
    NAME_TYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.TYPE_INCLUDE, Field.TYPE_INDIVIDUAL) ;

    NAME_ARRYTYPE_MAP = new HashMap<String, Character>() ;
    NAME_ARRYTYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.ARRAY_NOT, Field.ARRAY_NOT) ;
    NAME_ARRYTYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.ARRAY_FIXED, Field.ARRAY_FIXED) ;
    NAME_ARRYTYPE_MAP.put(com.inzent.yellowpage.marshaller.Field.ARRAY_VARIABLE, Field.ARRAY_VARIABLE) ;
  }


  @Override
  protected void makeErrorResponse(HttpServletResponse response, HttpServletRequest request, Throwable throwable) throws Exception
  {
    PublishingFormat publishingFormat = new PublishingFormat() ;

    publishingFormat.setResultCode(throwable.getClass().getName()) ;
    publishingFormat.setResultMessage(throwable.getMessage()) ;

    YellowPageMarshaller.marshal(response.getOutputStream(), publishingFormat) ;
  }

  @Override
  protected Collection<Object> parseGetRequest(HttpServletRequest request) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  protected void makeGetResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
  }

  @Override
  protected Collection<Object> parsePostRequest(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    PublishingFormat publishingFormat = YellowPageMarshaller.unmarshal(request.getInputStream()) ;

    for (Format format : publishingFormat.getFormats())
      objects.add(unmarshalRecord(format, null)) ;

    for (Receiver receiver : publishingFormat.getReceivers())
      objects.add(unmarshalService(receiver)) ;

    for (Sender sender : publishingFormat.getSenders())
      objects.add(unmarshalInterface(sender)) ;

    return objects ;
  }

  @Override
  protected void makePostResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    PublishingFormat publishingFormat = new PublishingFormat() ;

    publishingFormat.setResultCode(RESULTCODE_OK) ;

    YellowPageMarshaller.marshal(response.getOutputStream(), publishingFormat) ;
  }

  @Override
  protected Collection<Object> parseDeleteRequest(HttpServletRequest request) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  protected void makeDeleteResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
  }

  protected Properties unmarshalOption(MetaProperties metaProperties)
  {
    Properties properties = new Properties() ;

    for (String key : metaProperties.getPropertyKeySet())
      properties.setProperty(key, metaProperties.getProperty(key)) ;

    return properties ;
  }

  protected Interface unmarshalInterface(Sender sender) throws Exception
  {
    Interface interfaceMeta = new Interface() ;

    interfaceMeta.setInterfaceId(sender.getId()) ;
    interfaceMeta.setInterfaceName(sender.getName()) ;
    interfaceMeta.setPrivilegeId(sender.getPrivilege()) ;
    interfaceMeta.setPrivateYn(sender.isPrivate() ? 'Y' : 'N') ;
    interfaceMeta.setMetaDomain(sender.getMetaDomain()) ;
    interfaceMeta.setInterfaceDesc(sender.getDescription()) ;
    interfaceMeta.setUpdateVersion(sender.getVersion()) ;
    interfaceMeta.setUpdateUserId(sender.getLastUpdateUser()) ;
    try
    {
      interfaceMeta.setUpdateTimestamp(new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(sender.getLastUpdateTimeStamp()).getTime())) ;
    }
    catch (ParseException e)
    {
    }

    interfaceMeta.setInterfaceResponses(new LinkedList<>()) ;
    interfaceMeta.setInterfaceServices(new LinkedList<>()) ;
    interfaceMeta.setInterfaceProperty(new HashMap<>()) ;
    interfaceMeta.setInterfaceRecognizes(new LinkedList<>()) ;

    Properties properties = unmarshalOption(sender) ;

    // TODO InterfaceGroup 변환 로직 필요
    interfaceMeta.setInterfaceGroup((String) properties.remove(PROPERTY_BIZ)) ;

    // TODO AdapterID 변환 및 검사 로직 필요
    interfaceMeta.setAdapterId((String) properties.remove(PROPERTY_SYSTEM)) ;

    // TODO InterfaceType 변환 및 검사 로직 필요
    switch ((String) properties.remove(PROPERTY_TYPE))
    {
    case "DB_MD" :
      interfaceMeta.setInterfaceType("DB") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_BATCHED) ;
      break ;
    case "DB_MM" :
      interfaceMeta.setInterfaceType("DB") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_TRIGGERED) ;
      break ;
    case "FILE_DB" :
      interfaceMeta.setInterfaceType("File") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_BATCHED) ;
      break ;
    case "FILE_FILE" :
      interfaceMeta.setInterfaceType("File") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_TRIGGERED) ;
      break ;
    case "REQ_RES" :
      interfaceMeta.setInterfaceType("Online") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_ONLINE) ;
      break ;

    default :
      interfaceMeta.setInterfaceType("Online") ;
      interfaceMeta.setScheduleType(Interface.SCHEDULE_ONLINE) ;
      // interfaceMeta.setCronExpression(cronExpression) ;
      // interfaceMeta.setCalendarId(calendarId) ;
      break ;
    }

    // TODO InterfaceOperation 변환 및 검사 로직 필요
    properties.remove(PROPERTY_INTERFACECLASS) ;
    // interfaceMeta.setInterfaceOperation(interfaceOperation) ;

    // TODO 확장 속성 처리
    properties.remove(PROPERTY_SERVER) ;

    for (Map.Entry<Object, Object> entry : properties.entrySet())
    {
      InterfaceProperty interfaceProperty = new InterfaceProperty() ;
      interfaceProperty.setPk(new InterfacePropertyPK()) ;
      interfaceProperty.setInterfaceObject(interfaceMeta) ;

      interfaceProperty.getPk().setInterfaceId(interfaceMeta.getInterfaceId()) ;
      interfaceProperty.getPk().setPropertyKey((String) entry.getKey()) ;
      interfaceProperty.setPropertyValue((String) entry.getValue()) ;

      interfaceMeta.getInterfaceProperty().put(interfaceProperty.getPk(), interfaceProperty) ;
    }

    if (null != sender.getRequestFormat())
    {
      interfaceMeta.setRequestRecordObject(unmarshalRecord(sender.getRequestFormat(), interfaceMeta)) ;
      interfaceMeta.setRequestRecordId(interfaceMeta.getRequestRecordObject().getRecordId()) ;
    }

    for (com.inzent.yellowpage.marshaller.Format format : sender.getResponseFormats())
    {
      Record responseRecord = unmarshalRecord(format, interfaceMeta) ;

      InterfaceResponsePK interfaceResponsePK = new InterfaceResponsePK() ;
      interfaceResponsePK.setInterfaceId(interfaceMeta.getInterfaceId()) ;
      interfaceResponsePK.setRecordId(responseRecord.getRecordId()) ;

      InterfaceResponse interfaceResponse = new InterfaceResponse() ;
      interfaceResponse.setPk(interfaceResponsePK) ;
      interfaceResponse.setInterfaceObject(interfaceMeta) ;

      interfaceMeta.getInterfaceResponses().add(interfaceResponse) ;
      interfaceResponse.setRecordObject(responseRecord) ;
    }

    int order = 0 ;
    for (com.inzent.yellowpage.marshaller.Route route : sender.getRoutes())
    {
      InterfaceService interfaceServiceMeta = new InterfaceService() ;
      interfaceServiceMeta.setPk(new InterfaceServicePK()) ;
      interfaceServiceMeta.setInterfaceObject(interfaceMeta) ;

      interfaceServiceMeta.getPk().setInterfaceId(interfaceMeta.getInterfaceId()) ;
      interfaceServiceMeta.getPk().setServiceId(route.getReceiver().getId()) ;
      interfaceServiceMeta.setServiceOrder(order++) ;

      if (null != route.getRequestMapping())
      {
        interfaceServiceMeta.setRequestMappingObject(unmarshalMapping(route.getRequestMapping(), interfaceMeta)) ;
        interfaceServiceMeta.setRequestMappingId(interfaceServiceMeta.getRequestMappingObject().getMappingId()) ;
      }

      if (null != route.getResponseMapping())
      {
        interfaceServiceMeta.setResponseMappingObject(unmarshalMapping(route.getResponseMapping(), interfaceMeta)) ;
        interfaceServiceMeta.setResponseMappingId(interfaceServiceMeta.getResponseMappingObject().getMappingId()) ;
      }

      interfaceMeta.getInterfaceServices().add(interfaceServiceMeta) ;
    }
    
    return interfaceMeta ;
  }

  protected Mapping unmarshalMapping(com.inzent.yellowpage.marshaller.Mapping mappingElement, Interface interfaceMeta)
  {
    Mapping mapping = new Mapping() ;

    mapping.setMappingId(mappingElement.getId()) ;
    mapping.setMappingName(mappingElement.getName()) ;
    mapping.setPrivilegeId(interfaceMeta.getPrivilegeId()) ;
    mapping.setPrivateYn(interfaceMeta.getPrivateYn()) ;
    mapping.setMappingType(Mapping.TYPE_INDI) ;
    mapping.setMappingGroup(interfaceMeta.getInterfaceGroup()) ;
    mapping.setMappingDetails(new LinkedList<>()) ;

    int order = 0 ;
    for (com.inzent.yellowpage.marshaller.MappingRule eMappingRule : mappingElement.getMappingRules())
    {
      MappingRule mappingRule = new MappingRule() ;
      mappingRule.setMappingRuleSources(new LinkedList<>()) ;
      mappingRule.setMappingRuleDetails(new LinkedList<>()) ;

      mappingRule.setPk(new MappingDetailPK(mapping.getMappingId(), order++)) ;
      mappingRule.setRecordId(eMappingRule.getTo()) ;

      int parameterOrder = 0 ;
      for (String from : eMappingRule.getFroms())
      {
        MappingRuleSource mappingRuleSource = new MappingRuleSource() ;
        mappingRuleSource.setPk(new MappingRuleSourcePK()) ;
        mappingRuleSource.setMappingRule(mappingRule) ;

        mappingRuleSource.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
        mappingRuleSource.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
        mappingRuleSource.getPk().setParameterOrder(parameterOrder++) ;

        mappingRuleSource.setRecordId(from) ;

        mappingRule.getMappingRuleSources().add(mappingRuleSource) ;
      }

      int mappingDetailNo = 0 ;
      for (Link link : eMappingRule.getLinks())
        mappingRule.getMappingRuleDetails().add(unmarshalMappingRuleDetail(link, mappingRule.getPk(), mappingDetailNo++)) ;

      MappingDetail mappingDetail = new MappingDetail() ;
      mappingDetail.setMapping(mapping) ;

      mappingDetail.setPk(new MappingDetailPK(mappingRule.getPk().getMappingId(), mappingRule.getPk().getMappingOrder())) ;
      mappingDetail.setTargetForm(eMappingRule.getFormId()) ;
      mappingDetail.setMappingRuleObject(mappingRule) ;

      mapping.getMappingDetails().add(mappingDetail) ;
    }

    return mapping ;
  }

  protected MappingRuleDetail unmarshalMappingRuleDetail(com.inzent.yellowpage.marshaller.Link childElement, MappingDetailPK mappingDetailPK, int detailNo)
  {
    MappingRuleDetail mappingRuleDetail = new MappingRuleDetail() ;
    mappingRuleDetail.setPk(new MappingRuleDetailPK()) ;

    mappingRuleDetail.getPk().setMappingId(mappingDetailPK.getMappingId()) ;
    mappingRuleDetail.getPk().setMappingOrder(mappingDetailPK.getMappingOrder()) ;
    mappingRuleDetail.getPk().setMappingDetailNo(detailNo++) ;

    mappingRuleDetail.setTargetFieldPath(childElement.getTargetField()) ;
    mappingRuleDetail.setMappingExpression(childElement.getMappingExpression()) ;
    mappingRuleDetail.setSimpleMappingYn(childElement.isSimpleMapping() ? 'Y' : 'N') ;
    mappingRuleDetail.setArraySizeParameter(childElement.getArraySize()) ;

    return mappingRuleDetail ;
  }

  protected Service unmarshalService(Receiver receiver) throws Exception
  {
    Service service = new Service() ;
    service.setServiceProperty(new HashMap<>()) ;

    service.setServiceId(receiver.getId()) ;
    service.setServiceName(receiver.getName()) ;
    service.setPrivilegeId(receiver.getPrivilege()) ;
    service.setPrivateYn(receiver.isPrivate() ? 'Y': 'N') ;
    service.setMetaDomain(receiver.getMetaDomain()) ;
    service.setServiceDesc(receiver.getDescription()) ;
    service.setUpdateVersion(receiver.getVersion()) ;
    service.setUpdateUserId(receiver.getLastUpdateUser()) ;
    try
    {
      service.setUpdateTimestamp(new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(receiver.getLastUpdateTimeStamp()).getTime())) ;
    }
    catch (ParseException e)
    {
    }

    Properties properties = unmarshalOption(receiver) ;

    // TODO SeriveGroup 변환 로직 필요
    service.setServiceGroup((String) properties.remove(PROPERTY_BIZ)) ;

    // TODO AdapterID 변환 및 검사 로직 필요
    service.setAdapterId((String) properties.remove(PROPERTY_SYSTEM)) ;

    // TODO SeriveType 변환 및 검사 로직 필요
    switch ((String) properties.remove(PROPERTY_TYPE))
    {
    case "DB_MD" :
      service.setServiceType("DB") ;
//      service.setServiceActivity("CompositeReplyServiceActivity") ;
      break ;
    case "DB_MM" :
      service.setServiceType("DB") ;
//      service.setServiceActivity("CompositeReplyServiceActivity") ;
      break ;
    case "FILE_DB" :
      service.setServiceType("File") ;
//      service.setServiceActivity("NoReplyServiceActivity") ;
      break ;
    case "FILE_FILE" :
      service.setServiceType("File") ;
//      service.setServiceActivity("NoReplyServiceActivity") ;
      break ;
    case "REQ_RES" :
      service.setServiceType("Online") ;
//      service.setServiceActivity("CompositeReplyServiceActivity") ;
      break ;

    default :
      service.setServiceType("File") ;
      break ;
    }

    // TODO 확장 속성 처리
    properties.remove(PROPERTY_SERVER) ;

    for (Map.Entry<Object, Object> entry : properties.entrySet())
    {
      ServiceProperty serviceProperty = new ServiceProperty() ;
      serviceProperty.setPk(new ServicePropertyPK()) ;
      serviceProperty.setService(service) ;

      serviceProperty.getPk().setServiceId(service.getServiceId()) ;
      serviceProperty.getPk().setPropertyKey((String) entry.getKey()) ;
      serviceProperty.setPropertyValue((String) entry.getValue()) ;

      service.getServiceProperty().put(serviceProperty.getPk(), serviceProperty) ;
    }

    if (null != receiver.getRequestFormat())
    {
      service.setRequestRecordObject(unmarshalRecord(receiver.getRequestFormat(), service)) ;
      service.setRequestRecordId(service.getRequestRecordObject().getRecordId()) ;
    }

    if (null != receiver.getResponseFormat())
    {
      service.setResponseRecordObject(unmarshalRecord(receiver.getResponseFormat(), service)) ;
      service.setResponseRecordId(service.getResponseRecordObject().getRecordId()) ;
    }

    return service ;
  }

  protected Record unmarshalRecord(com.inzent.yellowpage.marshaller.Format format, Object parent)
  {
    Record record = new Record() ;

    record.setRecordId(format.getId()) ;
    record.setRecordName(format.getName()) ;
    record.setPrivilegeId(format.getPrivilege()) ;
    record.setPrivateYn(format.isPrivate() ? 'Y' : 'N') ;
    record.setMetaDomain(format.getMetaDomain()) ;
    record.setRecordDesc(format.getDescription()) ;
    record.setUpdateVersion(format.getVersion()) ;
    record.setUpdateUserId(format.getLastUpdateUser()) ;

    try
    {
      record.setUpdateTimestamp(new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(format.getLastUpdateTimeStamp()).getTime())) ;
    }
    catch (ParseException e)
    {
    }

    if (parent instanceof Interface)
    {
      Interface interfaceMeta = (Interface) parent ;

      record.setRecordType(Record.TYPE_INDIVI) ;
      record.setRecordGroup(interfaceMeta.getInterfaceGroup()) ;
    }
    else if (parent instanceof Service)
    {
      Service service = (Service) parent ;

      record.setRecordType(Record.TYPE_INDIVI) ;
      record.setRecordGroup(service.getServiceGroup()) ;
    }
    else
    {
      record.setRecordType(Record.TYPE_HEADER) ;

      // TODO Record Group 지정
      record.setRecordGroup(format.getPrivilege()) ;
    }

    Properties properties = unmarshalOption(format) ;
    // TODO 확장 속성 처리

    record.setRecordOptions(PropertyUtils.encode(properties)) ;

    unmarshalGroup(record, format) ;

    return record ;
  }

  protected void unmarshalGroup(Record record, com.inzent.yellowpage.marshaller.Group group)
  {
    record.setFields(new ArrayList<>(group.getFieldList().size())) ;

    for (com.inzent.yellowpage.marshaller.Field fieldMeta : group.getFieldList())
      record.getFields().add(unmarshalField(record, fieldMeta)) ;
  }

  protected Field unmarshalField(Record record, com.inzent.yellowpage.marshaller.Field childElement)
  {
    Field field = new Field() ;
    field.setRecord(record) ;
    field.setPk(new FieldPK()) ;

    field.getPk().setRecordId(record.getRecordId()) ;
    field.getPk().setFieldId(childElement.getId()) ;
    field.setFieldName(childElement.getName()) ;
    field.setFieldOrder(childElement.getSeq()) ;
    field.setFieldIndex(childElement.getIndex()) ;

    // 논리유형명 : "CHAR" - 문자형, "NUMBER" - 숫자형, "BINARY" - 바이너리형
    field.setFieldType(NAME_TYPE_MAP.get(childElement.getType())) ;
    // Not, Fixed, Variable
    field.setArrayType(NAME_ARRYTYPE_MAP.get(childElement.getArrayType())) ;
    // 필드 길이 및 정밀도
    field.setFieldLength(childElement.getLength()) ;
    field.setFieldScale(childElement.getScale()) ;

    field.setFieldRequireYn(childElement.isRequired() ? 'Y' : 'N') ;
    field.setFieldHiddenYn(childElement.isMasking() ? 'Y' : 'N') ;
    field.setReferenceFieldId(childElement.getCount()) ;
    field.setFieldDefaultValue(childElement.getDefaultValue()) ;

    Properties properties = unmarshalOption(childElement) ;
    // TODO 확장 속성 처리

    field.setFieldOptions(PropertyUtils.encode(properties)) ;

    if (Field.TYPE_RECORD == field.getFieldType())
    {
      Record subRecord = new Record() ;

      subRecord.setPrivilegeId(field.getRecord().getPrivilegeId()) ;
      subRecord.setPrivateYn(field.getRecord().getPrivateYn()) ;
      subRecord.setMetaDomain(field.getRecord().getMetaDomain()) ;
      subRecord.setRecordGroup(field.getRecord().getRecordGroup()) ;

      if (null != childElement.getGroupName())
      {
        subRecord.setRecordId(childElement.getGroupName()) ;
        subRecord.setRecordType(Record.TYPE_HEADER) ;

        unmarshalGroup(subRecord, childElement.getSubFields()) ;

        field.setFieldType(Field.TYPE_RECORD) ;
        field.setSubRecordId(childElement.getGroupName()) ;
      }
      else
      {
        subRecord.setRecordId(field.getRecord().getRecordId() + "@" + field.getPk().getFieldId()) ;
        subRecord.setRecordType(Record.TYPE_EMBED) ;

        unmarshalGroup(subRecord, childElement.getSubFields()) ;

        field.setSubRecordId(subRecord.getRecordId()) ;
      }
      field.setRecordObject(subRecord) ;
    }

    return field ;
  }
}
