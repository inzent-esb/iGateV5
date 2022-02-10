package com.inzent.igate.imanager.eims ;

import java.io.IOException ;
import java.util.Collection ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.Properties ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.dom4j.Document ;
import org.dom4j.DocumentFactory ;
import org.dom4j.Element ;
import org.dom4j.io.OutputFormat ;
import org.dom4j.io.XMLWriter ;
import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.imanager.adapter.AdapterService ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.InterfaceProperty ;
import com.inzent.igate.repository.meta.InterfacePropertyPK ;
import com.inzent.igate.repository.meta.InterfaceRecognize ;
import com.inzent.igate.repository.meta.InterfaceResponse ;
import com.inzent.igate.repository.meta.InterfaceResponsePK ;
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
import com.inzent.imanager.common.property.PropertyService ;
import com.inzent.yellowpage.marshaller.Format ;
import com.inzent.yellowpage.marshaller.PublishingFormat ;
import com.inzent.yellowpage.marshaller.Receiver ;
import com.inzent.yellowpage.marshaller.Sender ;
import com.inzent.yellowpage.marshaller.YellowPageMarshaller ;

/**
 * <code>XmlYellowEimsController</code>
 * 
 * @author 
 * @version 1.0
 * @since 2021.04.26 Release Date User Desc
 * 
 */
@Controller
@RequestMapping(XmlYellowEimsController.URI)
public class XmlYellowEimsController extends AbstractEimsController
{
  public static final String URI = "/igate/yellowEimsXml" ;

  public static final String RESULTCODE_OK = "0" ;
  public static final String RESULTCODE_FAIL = "1" ;

  public static final String VALUE_META_DOMAIN = "internal" ;
  public static final String VALUE_TYPE_ONLINE_EIMS = "REQ_RES" ;
  public static final String VALUE_TYPE_ONLINE_IGATE = "Online" ;
  public static final String VALUE_TYPE_FILE = "FILE" ;
 
  public static final String PROPERTY_SERVER = "Server" ;
  public static final String PROPERTY_INTERFACECLASS = "InterfaceClass" ;
  public static final String PROPERTY_TYPE = "Type" ;
  public static final String PROPERTY_SYSTEM = "System" ;
  public static final String PROPERTY_BIZ = "Biz" ;

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

  @Autowired
  protected PropertyService propertyService ;

  @Autowired
  protected AdapterService adpaterService ;

  @Override
  protected void makeErrorResponse(HttpServletResponse response, HttpServletRequest request, Throwable throwable)
  {
    if (logger.isWarnEnabled())
      logger.warn(throwable.getMessage(), throwable) ;

    try
    {
      sendResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, RESULTCODE_FAIL, throwable.toString()) ;
    }
    catch (Throwable t)
    {
      if (logger.isWarnEnabled())
        logger.warn(t.getMessage(), t) ;
    }
  }

  @Override
  protected Collection<Object> parseGetRequest(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    // TODO Auto-generated method stub

    return objects ;
  }

  @Override
  protected void makeGetResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    sendResponse(response, HttpServletResponse.SC_OK, RESULTCODE_OK, "Success to export") ;
  }

  @Override
  protected Collection<Object> parsePostRequest(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;
    
    javax.servlet.ServletInputStream inputstream = request.getInputStream() ;

//    받은 xml 확인용
//    Document document = new SAXReader(DOMDocumentFactory.getInstance()).read(inputstream) ;
//    System.out.println(document.asXML()) ;

    PublishingFormat publishingFormat = YellowPageMarshaller.unmarshal(inputstream) ;

    for (Format format : publishingFormat.getFormats())
      objects.addAll(unmarshalRecord(new Record(), format, format.getFieldList(), null, true)) ;
    
    if(null == publishingFormat.getSenders()) // 인터페이스 처리 로직에 서비스로직 포함 되어있으로 중복처리를 막기위한 확인
      for (Receiver receiver : publishingFormat.getReceivers())
        objects.addAll(unmarshalService(new Service(), receiver)) ;
    
    for (Sender sender : publishingFormat.getSenders())
      objects.addAll(unmarshalInterface(sender, publishingFormat)) ;
    
    return objects ;
  }

  @Override
  protected void makePostResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    sendResponse(response, HttpServletResponse.SC_OK, RESULTCODE_OK, "Success to import") ; 
  }

  @Override
  protected Collection<Object> parseDeleteRequest(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    // TODO Auto-generated method stub

    return objects ;
  }

  @Override
  protected void makeDeleteResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    sendResponse(response, HttpServletResponse.SC_OK, RESULTCODE_OK, "Success to delete") ;
  }

  protected Collection<Object> unmarshalInterface(Sender sender, PublishingFormat publishingFormat) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;
    
    Interface interfaceMeta = new Interface() ;
    objects.add(interfaceMeta) ;
    
    interfaceMeta.setInterfaceId(sender.getId()) ;
    interfaceMeta.setInterfaceName(sender.getName()) ;
    interfaceMeta.setPrivilegeId(sender.getPrivilege()) ;
    interfaceMeta.setPrivateYn(sender.isPrivate() ? 'Y' : 'N') ;
    interfaceMeta.setMetaDomain(VALUE_META_DOMAIN) ;
    interfaceMeta.setScheduleType(Interface.SCHEDULE_ONLINE) ;
    interfaceMeta.setDisabledYn('N') ;
    interfaceMeta.setInterfaceResponses(new LinkedList<>()) ;
    interfaceMeta.setInterfaceServices(new LinkedList<>()) ;
    interfaceMeta.setInterfaceProperty(new HashMap<>()) ;

    // ### 받는 값 REQ_RES => Online 변환 값 
    interfaceMeta.setInterfaceType(VALUE_TYPE_ONLINE_EIMS.equals(sender.getProperty(PROPERTY_TYPE)) ? VALUE_TYPE_ONLINE_IGATE : VALUE_TYPE_FILE) ; // File , DB 인 경우 추가 로직 필요
    
    String interfaceAdapterId  = sender.getProperty(PROPERTY_SYSTEM) ;  
    if (null == interfaceAdapterId)
      throw new Exception("어댑터 정보를 가져오는데 실패했습니다. INTERFACE.REGIST.BASE CP_CCD = CONSUMER's SYS_CD") ;
    if (null == adpaterService.get(interfaceAdapterId))
      throw new Exception("MCI시스템에 존재하지 않는 시스템코드입니다. 시스템코드 :[" + interfaceAdapterId + "]") ;

    interfaceMeta.setAdapterId(interfaceAdapterId) ;
    interfaceMeta.setInterfaceGroup(interfaceAdapterId ) ;

    Service service = new Service() ;
    for (Receiver receiver : publishingFormat.getReceivers())
      objects.addAll(unmarshalService(service, receiver)) ;

    com.inzent.igate.repository.meta.InterfaceService interfaceService = new com.inzent.igate.repository.meta.InterfaceService() ;
    interfaceService.setPk(new InterfaceServicePK()) ;

    interfaceService.getPk().setInterfaceId(interfaceMeta.getInterfaceId()) ;
    interfaceService.getPk().setServiceId(service.getServiceId()) ;
    interfaceService.setServiceOrder(0) ;
    interfaceService.setInterfaceObject(interfaceMeta) ;

    interfaceMeta.getInterfaceServices().add(interfaceService) ;

    Record record = new Record() ;
    objects.addAll(unmarshalRecord(record, sender.getRequestFormat(), sender.getRequestFormat().getFieldList(), interfaceMeta, true)) ;

    interfaceMeta.setRequestRecordId(record.getRecordId()) ;
    interfaceMeta.setRequestRecordObject(record) ;

    for(com.inzent.yellowpage.marshaller.Format format : sender.getResponseFormats()) 
    {
      Record responseRecord = new Record() ;
      objects.addAll(unmarshalRecord(responseRecord, format, format.getFieldList(), interfaceMeta, true)) ;
    
      InterfaceResponsePK interfaceResponsePK = new InterfaceResponsePK() ;
      interfaceResponsePK.setInterfaceId(interfaceMeta.getInterfaceId()) ;
      interfaceResponsePK.setRecordId(responseRecord.getRecordId()) ;

      InterfaceResponse interfaceResponse = new InterfaceResponse() ;
      interfaceResponse.setPk(interfaceResponsePK) ;
      interfaceResponse.setInterfaceObject(interfaceMeta) ;

      interfaceMeta.getInterfaceResponses().add(interfaceResponse) ;
      interfaceResponse.setRecordObject(responseRecord) ;
    }

    Mapping mapping ;
    for (com.inzent.yellowpage.marshaller.Route route : sender.getRoutes())
    {
      if(null != route.getRequestMapping())
      {
        mapping = unmarshalMapping(route.getRequestMapping(), interfaceMeta, service, true) ;
        interfaceService.setRequestMappingId(mapping.getMappingId()) ;
        interfaceService.setRequestMappingObject(mapping) ;
      }
      if(null != route.getResponseMapping())
      {
        mapping = unmarshalMapping(route.getRequestMapping(), interfaceMeta, service, false) ;
        interfaceService.setResponseMappingId(mapping.getMappingId()) ;
        interfaceService.setResponseMappingObject(mapping) ;
      }
    }

    interfaceMeta.setInterfaceRecognizes(new LinkedList<InterfaceRecognize>());
    return objects ;
  }

  protected void addInterfaceProperty(Interface interfaceMeta, String key, String value)
  {
    InterfaceProperty interfaceProperty = new InterfaceProperty() ;
    interfaceProperty.setPk(new InterfacePropertyPK()) ;

    interfaceProperty.setInterfaceObject(interfaceMeta) ;
    interfaceProperty.getPk().setInterfaceId(interfaceMeta.getInterfaceId()) ;
    interfaceProperty.getPk().setPropertyKey(key) ;
    interfaceProperty.setPropertyValue(value) ;

    interfaceMeta.getInterfaceProperty().put(interfaceProperty.getPk(), interfaceProperty) ;
  }

  protected Collection<Object> unmarshalService(Service service, Receiver receiver) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    objects.add(service) ;
    service.setServiceName(receiver.getName()) ;
    service.setPrivilegeId(receiver.getPrivilege()) ;
    service.setPrivateYn(receiver.isPrivate() ? 'Y': 'N') ;
    service.setServiceType(VALUE_TYPE_ONLINE_EIMS.equals(receiver.getProperty(PROPERTY_TYPE)) ? VALUE_TYPE_ONLINE_IGATE : VALUE_TYPE_FILE) ; // File , DB 인 경우 추가 로직 필요
    service.setMetaDomain(VALUE_META_DOMAIN) ;
    service.setServiceProperty(new HashMap<>()) ;

    service.setServiceId(receiver.getId()) ;

    // 프로젝트에 맞는 엑티비티 사용
    service.setServiceActivity("CompositeReplyServiceActivity") ;

    String serviceAdapter = receiver.getProperty(PROPERTY_SYSTEM) ;
    service.setAdapterId(serviceAdapter) ;
    service.setServiceGroup(serviceAdapter) ;

    Record record = new Record() ;
    objects.addAll(unmarshalRecord(record, receiver.getRequestFormat(), receiver.getRequestFormat().getFieldList(), service, true)) ;

    service.setRequestRecordId(record.getRecordId()) ;
    service.setRequestRecordObject(record) ;
    
    for(com.inzent.yellowpage.marshaller.Format format : receiver.getResponseFormats()) 
    {
      Record responseRecord = new Record() ;
      objects.addAll(unmarshalRecord(responseRecord, format, format.getFieldList(), service, true)) ;
    
      service.setResponseRecordId(responseRecord.getRecordId()) ;
      service.setResponseRecordObject(responseRecord) ;
    }
    
    return objects ;
  }

  protected void addServiceProperty(Service service, String key, String value)
  {
    ServiceProperty serviceProperty = new ServiceProperty() ;
    serviceProperty.setPk(new ServicePropertyPK()) ;
    serviceProperty.setService(service) ;
    serviceProperty.getPk().setServiceId(service.getServiceId()) ;
    serviceProperty.getPk().setPropertyKey(key) ;
    serviceProperty.setPropertyValue(value) ;

    service.getServiceProperty().put(serviceProperty.getPk(), serviceProperty) ;
  }

  protected Collection<Object> unmarshalRecord(Record record, com.inzent.yellowpage.marshaller.Format format ,List<com.inzent.yellowpage.marshaller.Field> fieldList, Object parent, boolean isRequest)
  {
    List<Object> objects = new LinkedList<>() ;

    if (parent instanceof Service)
    {
      Service service = (Service) parent ;

      record.setRecordId(format.getId()) ;
      record.setRecordName(format.getName()) ;
      record.setPrivilegeId(service.getPrivilegeId()) ;
      record.setPrivateYn(service.getPrivateYn()) ;
      record.setRecordType(Record.TYPE_INDIVI) ;
      record.setMetaDomain(VALUE_META_DOMAIN) ;
      record.setRecordGroup(service.getServiceGroup()) ;
    }
    else if (parent instanceof Interface)
    {
      Interface interfaceMeta = (Interface) parent ;

      record.setRecordId(format.getId()) ;
      record.setRecordName(format.getName()) ;
      record.setPrivilegeId(interfaceMeta.getPrivilegeId()) ;
      record.setPrivateYn(interfaceMeta.getPrivateYn()) ;
      record.setRecordType(Record.TYPE_INDIVI) ;
      record.setMetaDomain(VALUE_META_DOMAIN) ;
      record.setRecordGroup(interfaceMeta.getInterfaceGroup()) ;
    }
    else if (parent instanceof Field)
    {
      Field field = (Field) parent ;

      record.setRecordId(field.getRecord().getRecordId() + "@" + field.getPk().getFieldId()) ;
      record.setPrivilegeId(field.getRecord().getPrivilegeId()) ;
      record.setPrivateYn(field.getRecord().getPrivateYn()) ;
      record.setRecordType(Record.TYPE_EMBED) ;
      record.setMetaDomain(field.getRecord().getMetaDomain()) ;
      record.setRecordGroup(field.getRecord().getRecordGroup()) ;
    }
    else
    {
      record.setRecordId(format.getId()) ;
      record.setRecordName(format.getName()) ;
      
      record.setPrivilegeId(format.getPrivilege()) ;
      record.setPrivateYn(format.isPrivate() ? 'Y' : 'N') ;
      record.setRecordType(Record.TYPE_HEADER) ;
      record.setMetaDomain(format.getMetaDomain()) ;
      record.setRecordGroup("Publish") ;
    }

//    record.setRecordOptions(unmarshalOption(modelElement)) ;
    record.setFields(new LinkedList<>()) ;

    int order = 0 ;

    for(com.inzent.yellowpage.marshaller.Field field : fieldList)
    {
      if(null == field.getSubFields())
        unmarshalField(record, order++, field) ;
      else
        unmarshalGroup(record, order++, field) ;
    }
    
    objects.add(record) ;
    
    return objects ;

  }

  protected String unmarshalOption(Element format)
  {
    Properties properties = new Properties() ;

//    if (null != format.attributeValue(ATTRIBUTE_ECR_MCD))
//      properties.setProperty(ATTRIBUTE_ECR_MCD, format.attributeValue(ATTRIBUTE_ECR_MCD)) ;

    return PropertyUtils.encode(properties) ;
  }

  protected void unmarshalField(Record record, int order, com.inzent.yellowpage.marshaller.Field childElement)
  {
    Field field = new Field() ;
    field.setPk(new FieldPK()) ;
    field.setRecord(record) ;

    field.getPk().setRecordId(record.getRecordId()) ;
    field.getPk().setFieldId(childElement.getId()) ;
    field.setFieldName(childElement.getName()) ;
    field.setFieldOrder(order) ;
    // 논리유형명 : "CHAR" - 문자형, "NUMBER" - 숫자형, "BINARY" - 바이너리형, ※ 구분문자가 있는 경우에는
    // 생략(최대자리수, 소수점자리수도 동일 적용)
    field.setFieldType(NAME_TYPE_MAP.get(childElement.getType())) ;
    // Not, Fixed, Variable
    field.setArrayType(NAME_ARRYTYPE_MAP.get(childElement.getArrayType())) ;
    field.setFieldLength(childElement.getLength()) ;
    field.setFieldScale(childElement.getScale()) ;
    field.setFieldRequireYn(childElement.isRequired() ? 'Y' : 'N') ;
    // ### 필드 옵션이 넘어오지 않음. 프로퍼티로 할지 확인 필요
//    field.setFieldOptions(unmarshalOption(childElement)) ;

    record.getFields().add(field) ;
  }

  protected Collection<Object> unmarshalGroup(Record record, int order, com.inzent.yellowpage.marshaller.Field childElement)
  {
    Field field = new Field() ;
    field.setPk(new FieldPK()) ;
    field.setRecord(record) ;

    field.getPk().setRecordId(record.getRecordId()) ;
    field.getPk().setFieldId(childElement.getId()) ;
    field.setFieldName(childElement.getName()) ;
    field.setFieldOrder(order) ;
    field.setFieldType(NAME_TYPE_MAP.get(childElement.getType())) ;
    // Not, Fixed, Variable
    field.setArrayType(NAME_ARRYTYPE_MAP.get(childElement.getArrayType())) ;
    field.setFieldRequireYn(childElement.isRequired() ? 'Y' : 'N') ;

    Record subRecord = new Record() ;
    Collection<Object> list = unmarshalRecord(subRecord, null, childElement.getSubFields().getFieldList(), field, false) ;
    field.setRecordObject(subRecord) ;

    field.setSubRecordId(subRecord.getRecordId()) ;
    // ### 모델 만들어서 확인 필요
//    field.setReferenceFieldId(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_PEA_TN))) ;

    // ### 필드 옵션이 넘어오지 않음.
//    field.setFieldOptions(unmarshalOption(childElement)) ;

    record.getFields().add(field) ;

    return list ;
  }

  protected Mapping unmarshalMapping(com.inzent.yellowpage.marshaller.Mapping mappingElement, Interface interfaceMeta, Service service, boolean isRequest) throws Exception
  {
    Mapping mapping = new Mapping() ;
    mapping.setPrivilegeId(interfaceMeta.getPrivilegeId()) ;
    mapping.setPrivateYn(interfaceMeta.getPrivateYn()) ;
    mapping.setMappingType(Mapping.TYPE_INDI) ;
    mapping.setMappingGroup(interfaceMeta.getInterfaceGroup()) ;
    mapping.setMappingDetails(new LinkedList<>()) ;

    String recordId = null ;

    if (isRequest)
    {
      mapping.setMappingId(mappingElement.getId()) ;
      mapping.setMappingName(mappingElement.getName()) ;
      recordId = service.getRequestRecordId() ;
    }
    else
    {
      mapping.setMappingId(mappingElement.getId()) ;
      mapping.setMappingName(mappingElement.getName()) ;
      recordId = interfaceMeta.getInterfaceResponses().get(0).getPk().getRecordId() ;
    }

    MappingDetail mappingDetail = new MappingDetail() ;
    mappingDetail.setPk(new MappingDetailPK(mapping.getMappingId(), 0)) ;
    mappingDetail.setMapping(mapping) ;

    mapping.getMappingDetails().add(mappingDetail) ;

    MappingRule mappingRule = new MappingRule() ;
    mappingRule.setPk(new MappingDetailPK(mapping.getMappingId(), 0)) ;
    mappingRule.setRecordId(recordId) ;
    mappingRule.setMappingRuleSources(new LinkedList<>()) ;

    if (isRequest)
    {
      MappingRuleSource mappingRuleSource = new MappingRuleSource() ;
      mappingRuleSource.setPk(new MappingRuleSourcePK()) ;

      mappingRuleSource.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleSource.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleSource.getPk().setParameterOrder(0) ;

      mappingRuleSource.setRecordId(interfaceMeta.getRequestRecordId()) ;
      mappingRuleSource.setMappingRule(mappingRule) ;
      mappingRule.getMappingRuleSources().add(mappingRuleSource) ;
    }
    else
    {
      MappingRuleSource mappingRuleSource = new MappingRuleSource() ;
      mappingRuleSource.setPk(new MappingRuleSourcePK()) ;

      mappingRuleSource.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleSource.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleSource.getPk().setParameterOrder(0) ;

      mappingRuleSource.setRecordId(service.getResponseRecordId()) ;
      mappingRuleSource.setMappingRule(mappingRule) ;
      mappingRule.getMappingRuleSources().add(mappingRuleSource) ;

      mappingRuleSource = new MappingRuleSource() ;
      mappingRuleSource.setPk(new MappingRuleSourcePK()) ;

      mappingRuleSource.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleSource.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleSource.getPk().setParameterOrder(1) ;

      mappingRuleSource.setRecordId(service.getRequestRecordId()) ;
      mappingRuleSource.setMappingRule(mappingRule) ;
      mappingRule.getMappingRuleSources().add(mappingRuleSource) ;

      mappingRuleSource = new MappingRuleSource() ;
      mappingRuleSource.setPk(new MappingRuleSourcePK()) ;

      mappingRuleSource.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleSource.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleSource.getPk().setParameterOrder(2) ;

      mappingRuleSource.setRecordId(interfaceMeta.getInterfaceResponses().get(0).getPk().getRecordId()) ;
      mappingRuleSource.setMappingRule(mappingRule) ;
      mappingRule.getMappingRuleSources().add(mappingRuleSource) ;
    }

    
    for (com.inzent.yellowpage.marshaller.MappingRule eMappingRule : mappingElement.getMappingRules())
    {
      unmarshalMappingRuleDetail(mappingRule, eMappingRule.getLinks()) ;
      mappingDetail.setMappingRuleObject(mappingRule) ;
      break ;
    }
    

    return mapping ;
  }

  protected void unmarshalMappingRuleDetail(MappingRule mappingRule, List<com.inzent.yellowpage.marshaller.Link> element)
  {
    mappingRule.setMappingRuleDetails(new LinkedList<>()) ;

    int detailNo = 0 ;
    for (com.inzent.yellowpage.marshaller.Link childElement : element)
    {
      MappingRuleDetail mappingRuleDetail = new MappingRuleDetail() ;
      mappingRuleDetail.setPk(new MappingRuleDetailPK()) ;

      mappingRuleDetail.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleDetail.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleDetail.getPk().setMappingDetailNo(detailNo++) ;

      mappingRuleDetail.setTargetFieldPath(childElement.getTargetField()) ;
      mappingRuleDetail.setMappingExpression(childElement.getMappingExpression()) ;
      mappingRuleDetail.setSimpleMappingYn('Y') ;

      mappingRuleDetail.setMappingRule(mappingRule) ;

      mappingRule.getMappingRuleDetails().add(mappingRuleDetail) ;
    }
  }

  protected void sendResponse(HttpServletResponse response, int sc, String returnCode, String returnMsg) throws IOException
  {
    Document responseDoc = DocumentFactory.getInstance().createDocument("UTF-8") ;

    Element shareResult = responseDoc.addElement("Result") ;
    shareResult.addElement("ResultCode").addEntity("code", returnCode) ;
    shareResult.addElement("ResultMessage").addEntity("message", returnMsg) ;

    response.setStatus(sc) ;
    response.setContentType("text/xml") ;
    response.setCharacterEncoding(responseDoc.getXMLEncoding()) ;

    new XMLWriter(response.getWriter(), new OutputFormat(null, false, responseDoc.getXMLEncoding())).write(responseDoc) ;
  }
}