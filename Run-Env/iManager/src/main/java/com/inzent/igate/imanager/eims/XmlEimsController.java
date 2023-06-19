package com.inzent.igate.imanager.eims ;

import java.io.IOException ;
import java.text.MessageFormat ;
import java.util.Collection ;
import java.util.HashMap ;
import java.util.Iterator ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.Objects ;
import java.util.Properties ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.lang3.StringUtils ;
import org.dom4j.Document ;
import org.dom4j.DocumentFactory ;
import org.dom4j.Element ;
import org.dom4j.io.OutputFormat ;
import org.dom4j.io.SAXReader ;
import org.dom4j.io.XMLWriter ;
import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.openapi.entity.adapter.AdapterService ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.InterfaceProperty ;
import com.inzent.igate.repository.meta.InterfacePropertyPK ;
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
import com.inzent.imanager.openapi.property.PropertyService ;

/**
 * <code>XmlEimsController</code>
 * 
 * @author DSKO
 * @version 1.0
 * @since 2021.04.26 Release Date User Desc
 * 
 */
@Controller
@RequestMapping(XmlEimsController.URI)
public class XmlEimsController extends AbstractEimsController
{
  public static final String URI = "/igate/eimsXml" ;

  public static final String ELEMENT_IF = "INTERFACE" ;
  public static final String ELEMENT_REGIST = "REGIST" ;
  public static final String ELEMENT_BASE = "BASE" ;
  public static final String ELEMENT_DEFINE = "DEFINE" ;
  public static final String ELEMENT_ITEMS = "ITEMS" ;
  public static final String ELEMENT_MP = "MAPPING" ;
  public static final String ELEMENT_ITEM = "ITEM" ;

  public static final String ATTRIBUTE_ITF_DPM_BLI_VER_NM = "ITF_DPM_BLI_VER_NM" ;
  public static final String ATTRIBUTE_ITF_ID = "ITF_ID" ;
  public static final String ATTRIBUTE_ITF_NM = "ITF_NM" ;
  public static final String ATTRIBUTE_ITF_REL_F = "ITF_REL_F" ;
  public static final String ATTRIBUTE_TS_TCD = "TS_TCD" ;
  public static final String ATTRIBUTE_ITF_MPG_F = "ITF_MPG_F" ;
  public static final String ATTRIBUTE_TI_AUE_F = "TI_AUE_F" ;
  public static final String ATTRIBUTE_CP_CCD = "CP_CCD" ;
  public static final String ATTRIBUTE_SYS_CD = "SYS_CD" ;
  public static final String ATTRIBUTE_BNE_CCD = "BNE_CCD" ;
  public static final String ATTRIBUTE_PRVD_SV_CD = "PRVD_SV_CD" ;
  public static final String ATTRIBUTE_EAI_ITF_ID = "EAI_ITF_ID" ;
  public static final String ATTRIBUTE_TIO_F = "TIO_F" ;
  public static final String ATTRIBUTE_TIO_TM = "TIO_TM" ;
  public static final String ATTRIBUTE_IO_CCD = "IO_CCD" ;
  public static final String ATTRIBUTE_ECR_MCD = "ECR_MCD" ;
  public static final String ATTRIBUTE_TER_ENG_NM = "TER_ENG_NM" ;
  public static final String ATTRIBUTE_TER_NM = "TER_NM" ;
  public static final String ATTRIBUTE_LCL_TP_NM = "LCL_TP_NM" ;
  public static final String ATTRIBUTE_MAX_LEN = "MAX_LEN" ;
  public static final String ATTRIBUTE_EPT_LEN = "EPT_LEN" ;
  public static final String ATTRIBUTE_COL_REQ_F = "COL_REQ_F" ;
  public static final String ATTRIBUTE_PEA_TN = "PEA_TN" ;
  public static final String ATTRIBUTE_MP_TAR = "ID";
  public static final String ATTRIBUTE_MP_SRC = "REF";

  public static final String RESULTCODE_OK = "0" ;
  public static final String RESULTCODE_FAIL = "1" ;

  public static final String VALUE_PRIVILEGE = "ESB" ;
  public static final String VALUE_META_DOMAIN = "internal" ;
  public static final String VALUE_CONSUMER = "CONSUMER" ;
  public static final String VALUE_PROVIDER = "PROVIDER" ;
  public static final String VALUE_INBOUND = "INBOUND" ;
  public static final String VALUE_OUTBOUND = "OUTBOUND" ;
 
  public static final String NAMING_RULE = "ImgOption.NamingRules" ;
  public static final String SERVICE_REQ_RECORD_ID = "ServiceRequestRecordID" ;
  public static final String SERVICE_REQ_RECORD_NAME = "ServiceRequestRecordName" ;
  public static final String SERVICE_RES_RECORD_ID = "ServiceResponseRecordID" ;
  public static final String SERVICE_RES_RECORD_NAME = "ServiceResponseRecordName" ;

  public static final String INTERFACE_REQ_RECORD_ID = "InterfaceRequestRecordID" ;
  public static final String INTERFACE_REQ_RECORD_NAME = "InterfaceRequestRecordName" ;
  public static final String INTERFACE_RES_RECORD_ID = "InterfaceResponseRecordID" ;
  public static final String INTERFACE_RES_RECORD_NAME = "InterfaceResponseRecordName" ;

  public static final String INTERFACE_REQ_MAPPING_ID = "InterfaceRequestMappingID" ;
  public static final String INTERFACE_REQ_MAPPING_NAME = "InterfaceRequestMappingName" ;
  public static final String INTERFACE_RES_MAPPING_ID = "InterfaceResponseMappingID" ;
  public static final String INTERFACE_RES_MAPPING_NAME = "InterfaceResponseMappingName" ;

  protected static final Map<String, Character> NAME_TYPE_MAP ;
  protected static final Map<String, Character> NAME_ARRYTYPE_MAP ;

  static
  {
    NAME_TYPE_MAP = new HashMap<String, Character>() ;
    NAME_TYPE_MAP.put("String", Field.TYPE_STRING) ;
    NAME_TYPE_MAP.put("Numeric", Field.TYPE_NUMERIC) ;
    NAME_TYPE_MAP.put("Date", Field.TYPE_STRING) ;
    NAME_TYPE_MAP.put("Group", Field.TYPE_RECORD) ;

    NAME_ARRYTYPE_MAP = new HashMap<String, Character>() ;
    NAME_ARRYTYPE_MAP.put("Not", Field.ARRAY_NOT) ;
    NAME_ARRYTYPE_MAP.put("Fixed", Field.ARRAY_FIXED) ;
    NAME_ARRYTYPE_MAP.put("Variable", Field.ARRAY_VARIABLE) ;
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

    Document document = SAXReader.createDefault().read(request.getInputStream()) ;
    Element root = document.getRootElement() ;

    for (Element interfaceElement : root.elements(ELEMENT_IF))
      objects.addAll(unmarshalInterface(interfaceElement)) ;

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

  protected Collection<Object> unmarshalInterface(Element itf) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    Interface interfaceMeta = new Interface() ;
    objects.add(interfaceMeta) ;

    interfaceMeta.setInterfaceId(itf.attributeValue(ATTRIBUTE_ITF_ID)) ;
    interfaceMeta.setInterfaceName(itf.attributeValue(ATTRIBUTE_ITF_NM)) ;
    interfaceMeta.setPrivilegeId(VALUE_PRIVILEGE) ;
    interfaceMeta.setPrivateYn('N') ;
    interfaceMeta.setMetaDomain(VALUE_META_DOMAIN) ;
    interfaceMeta.setScheduleType(Interface.SCHEDULE_ONLINE) ;
    interfaceMeta.setDisabledYn('N') ;
    interfaceMeta.setInterfaceResponses(new LinkedList<>()) ;
    interfaceMeta.setInterfaceServices(new LinkedList<>()) ;
    interfaceMeta.setInterfaceProperty(new HashMap<>()) ;

    addInterfaceProperty(interfaceMeta, ATTRIBUTE_ITF_DPM_BLI_VER_NM, StringUtils.defaultString(itf.getDocument().getRootElement().attributeValue(ATTRIBUTE_ITF_DPM_BLI_VER_NM), "0")) ;

    Element regist = itf.element(ELEMENT_REGIST) ;
    Element define = itf.element(ELEMENT_DEFINE) ;

    // 인터페이스 REPLY여부(Y) (인터페이스 REPLY여부 : Y, N)
    boolean replyYn = Objects.equals("Y", regist.attributeValue(ATTRIBUTE_ITF_REL_F)) ;

    // 거래타입 동기(S), 비동기(A), 무응답 (N)
    String tranType = replyYn ? regist.attributeValue(ATTRIBUTE_TS_TCD) : "N" ;
    interfaceMeta.setInterfaceType(Objects.equals("N", tranType) ? "OnlineNoReply" : "OnlineReply") ;

    String interfaceAdapterId = null, serviceAdapterId = null ;
    for (Element baseElement : regist.elements(ELEMENT_BASE))
      switch (baseElement.attributeValue(ATTRIBUTE_CP_CCD))
      {
      case VALUE_CONSUMER :
        interfaceAdapterId = baseElement.attributeValue(ATTRIBUTE_SYS_CD) ;
        break ;

      case VALUE_PROVIDER :
        serviceAdapterId = baseElement.attributeValue(ATTRIBUTE_SYS_CD) ;
        break ;
        
      default:
       	break;
      }

    if (null == interfaceAdapterId)
      throw new IOException("어댑터 정보를 가져오는데 실패했습니다. INTERFACE.REGIST.BASE CP_CCD = CONSUMER's SYS_CD") ;
    if (null == adpaterService.get(interfaceAdapterId))
      throw new IOException("MCI시스템에 존재하지 않는 시스템코드입니다. 시스템코드 :[" + interfaceAdapterId + "]") ;

    interfaceMeta.setAdapterId(interfaceAdapterId) ;
    interfaceMeta.setInterfaceGroup(interfaceAdapterId + "." + serviceAdapterId) ;

    if (null == serviceAdapterId)
      throw new IOException("어댑터 정보를 가져오는데 실패했습니다. INTERFACE.REGIST.BASE CP_CCD = PROVIDER's SYS_CD") ;
    if (null == adpaterService.get(serviceAdapterId))
      throw new IOException("MCI시스템에 존재하지 않는 시스템코드입니다. 시스템코드 :[" + serviceAdapterId + "]") ;

    String serviceId = define.attributeValue(ATTRIBUTE_PRVD_SV_CD) ;
    if (StringUtils.isBlank(serviceId))
      throw new IOException("인터페이스에 매핑될 서비스ID은 필수 값입니다. Service Id : [" + serviceId + "]") ;

    if (!StringUtils.isBlank(define.attributeValue(ATTRIBUTE_EAI_ITF_ID)))
      addInterfaceProperty(interfaceMeta, ATTRIBUTE_EAI_ITF_ID, define.attributeValue(ATTRIBUTE_EAI_ITF_ID)) ;

    Service service = new Service() ;
    objects.addAll(unmarshalService(service, itf)) ;

    com.inzent.igate.repository.meta.InterfaceService interfaceService = new com.inzent.igate.repository.meta.InterfaceService() ;
    interfaceService.setPk(new InterfaceServicePK()) ;

    interfaceService.getPk().setInterfaceId(interfaceMeta.getInterfaceId()) ;
    interfaceService.getPk().setServiceId(service.getServiceId()) ;
    interfaceService.setServiceOrder(0) ;
    interfaceService.setInterfaceObject(interfaceMeta) ;

    interfaceMeta.getInterfaceServices().add(interfaceService) ;

    // 맵핑여부에 따른 BYPASS처리 -> 모델을 등록하지 않음
    if (Objects.equals("Y", regist.attributeValue(ATTRIBUTE_ITF_MPG_F)))
    {
      Record record = new Record() ;
      InterfaceResponsePK interfaceResponsePK = new InterfaceResponsePK() ;
      InterfaceResponse interfaceResponse = new InterfaceResponse() ;
      for (Element modelElement : define.elements(ELEMENT_ITEMS))
        if (Objects.equals(VALUE_CONSUMER, modelElement.attributeValue(ATTRIBUTE_CP_CCD)) && Objects.equals(VALUE_OUTBOUND, modelElement.attributeValue(ATTRIBUTE_IO_CCD)))
        {
          record = new Record() ;
          objects.addAll(unmarshalRecord(record, modelElement, interfaceMeta, true)) ;

          interfaceMeta.setRequestRecordId(record.getRecordId()) ;
          interfaceMeta.setRequestRecordObject(record) ;
        }
        else if (Objects.equals(VALUE_CONSUMER, modelElement.attributeValue(ATTRIBUTE_CP_CCD)) && Objects.equals(VALUE_INBOUND, modelElement.attributeValue(ATTRIBUTE_IO_CCD)))
        {
          record = new Record() ;
          objects.addAll(unmarshalRecord(record, modelElement, interfaceMeta, false)) ;

          interfaceResponsePK = new InterfaceResponsePK() ;
          interfaceResponsePK.setInterfaceId(interfaceMeta.getInterfaceId()) ;
          interfaceResponsePK.setRecordId(record.getRecordId()) ;

          interfaceResponse = new InterfaceResponse() ;
          interfaceResponse.setPk(interfaceResponsePK) ;
          interfaceResponse.setInterfaceObject(interfaceMeta) ;

          interfaceMeta.getInterfaceResponses().add(interfaceResponse) ;
          interfaceResponse.setRecordObject(record) ;
        }

      Mapping mapping ;
      for (Element mappingElement : (List<Element>) define.elements(ELEMENT_MP))
        switch (mappingElement.attributeValue(ATTRIBUTE_IO_CCD))
        {
        case VALUE_OUTBOUND :
          // Request Mapping
          mapping = unmarshalMapping(mappingElement, interfaceMeta, service, true) ;
          interfaceService.setRequestMappingId(mapping.getMappingId()) ;
          interfaceService.setRequestMappingObject(mapping) ;
          break ;

        case VALUE_INBOUND :
          // Response Mapping
          mapping = unmarshalMapping(mappingElement, interfaceMeta, service, false) ;
          interfaceService.setResponseMappingId(mapping.getMappingId()) ;
          interfaceService.setResponseMappingObject(mapping) ;
          break ;
     
        default:
           	break;
        }
    }

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

  protected Collection<Object> unmarshalService(Service service, Element itf) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    service.setServiceName(itf.attributeValue(ATTRIBUTE_ITF_NM)) ;
    service.setPrivilegeId(VALUE_PRIVILEGE) ;
    service.setPrivateYn('N') ;
    service.setServiceType("Online") ;
    service.setMetaDomain(VALUE_META_DOMAIN) ;
    service.setServiceProperty(new HashMap<>()) ;

    addServiceProperty(service, ATTRIBUTE_ITF_DPM_BLI_VER_NM, StringUtils.defaultString(itf.getDocument().getRootElement().attributeValue(ATTRIBUTE_ITF_DPM_BLI_VER_NM), "0")) ;

    Element define = itf.element(ELEMENT_DEFINE) ;
    Element regist = itf.element(ELEMENT_REGIST) ;

    service.setServiceId(define.attributeValue(ATTRIBUTE_PRVD_SV_CD)) ;

    // 인터페이스 REPLY여부(Y) (인터페이스 REPLY여부 : Y, N)
    boolean replyYn = Objects.equals("Y", regist.attributeValue(ATTRIBUTE_ITF_REL_F)) ;

    // 거래타입 동기(S), 비동기(A), 무응답 (N)
    String tranType = replyYn ? regist.attributeValue(ATTRIBUTE_TS_TCD) : "N" ;
    switch (tranType)
    {
    case "S" :
      service.setServiceActivity("CompositeReplyServiceActivity") ;
      break ;

    case "A" :
      service.setServiceActivity("CompositeReplyServiceActivity") ;
      break ;

    case "N" :
      service.setServiceActivity("NoReplyServiceActivity") ;
      break ;
      
    default:
       	break;
    }

    for (Element baseElement : regist.elements(ELEMENT_BASE))
      if (Objects.equals(VALUE_PROVIDER, baseElement.attributeValue(ATTRIBUTE_CP_CCD)))
      {
        service.setAdapterId(baseElement.attributeValue(ATTRIBUTE_SYS_CD)) ;
        service.setServiceGroup(baseElement.attributeValue(ATTRIBUTE_BNE_CCD)) ;
      }

    addServiceProperty(service, ATTRIBUTE_TS_TCD, tranType) ;

    // 전송보장여부(N) (I/F 전송보장 여부 : - 처리유형이 Real Time 이고 거래유형이 Async 인 경우에만 Y/N, -
    // 처리유형이 Deferred인 경우에만 Y/N : "Y" - YES, "N" - NO)
    addServiceProperty(service, ATTRIBUTE_TI_AUE_F, StringUtils.defaultString(regist.attributeValue(ATTRIBUTE_TI_AUE_F), "N")) ;

    // TIO_F 타임아웃여부() (타임아웃여부 : 처리유형이 Real TimeN인경우, "Y" - YES, "N" - NO)
    if (Objects.equals("Y", define.attributeValue(ATTRIBUTE_TIO_F)))
    {
      // TIO_TM 타임아웃시간(60) (타임아웃시간 : 타임아웃여부가 "Y"인 경우 1~60초 사이값)
      int tmout = Integer.parseInt(StringUtils.defaultString(define.attributeValue(ATTRIBUTE_TIO_TM), "0")) ;
      addServiceProperty(service, "response.timeout", Integer.toString(tmout * 1000)) ;
    }

    // 인터페이스매핑여부(Y) (EAI 또는 MCI에서 매핑을 해야하는 요건이 있는지 유무 : "Y" - YES, "N" - NO)
    if (Objects.equals("Y", regist.attributeValue(ATTRIBUTE_ITF_MPG_F)))
    {
     
     // 정상 맵핑처리
 	  Record record = new Record() ;
      for (Element modelElement : define.elements(ELEMENT_ITEMS))
        if (Objects.equals(VALUE_PROVIDER, modelElement.attributeValue(ATTRIBUTE_CP_CCD)) && Objects.equals(VALUE_INBOUND, modelElement.attributeValue(ATTRIBUTE_IO_CCD)))
        {
          record = new Record() ;
          objects.addAll(unmarshalRecord(record, modelElement, service, true)) ;

          service.setRequestRecordId(record.getRecordId()) ;
          service.setRequestRecordObject(record) ;
        }
        else if (Objects.equals(VALUE_PROVIDER, modelElement.attributeValue(ATTRIBUTE_CP_CCD)) && Objects.equals(VALUE_OUTBOUND, modelElement.attributeValue(ATTRIBUTE_IO_CCD)))
        {
          record = new Record() ;
          objects.addAll(unmarshalRecord(record, modelElement, service, false)) ;

          service.setResponseRecordId(record.getRecordId()) ;
          service.setResponseRecordObject(record) ;
        }
    }
    else
    {
      // BYPASS
      // 요청모델 지정
      service.setRequestRecordId("BYPASS") ;
      // 응답모델 지정
      service.setResponseRecordId("BYPASS") ;
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

  protected Collection<Object> unmarshalRecord(Record record, Element modelElement, Object parent, boolean isRequest)
  {
    List<Object> objects = new LinkedList<>() ;

    if (parent instanceof Service)
    {
      Service service = (Service) parent ;

      if (isRequest)
      {
        record.setRecordId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, SERVICE_REQ_RECORD_ID, "SFD_{0}_I"), service.getServiceId())) ;
        record.setRecordName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, SERVICE_REQ_RECORD_NAME, "{0} 요청"), service.getServiceName())) ;
      }
      else
      {
        record.setRecordId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, SERVICE_RES_RECORD_ID, "SFD_{0}_O"), service.getServiceId())) ;
        record.setRecordName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, SERVICE_RES_RECORD_NAME, "{0} 응답"), service.getServiceName())) ;
      }

      record.setPrivilegeId(service.getPrivilegeId()) ;
      record.setPrivateYn(service.getPrivateYn()) ;
      record.setRecordType(Record.TYPE_INDIVI) ;
      record.setMetaDomain(VALUE_META_DOMAIN) ;
      record.setRecordGroup(service.getServiceGroup()) ;
    }
    else if (parent instanceof Interface)
    {
      Interface interfaceMeta = (Interface) parent ;

      if (isRequest)
      {
        record.setRecordId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_REQ_RECORD_ID, "IFD_{0}_I"), interfaceMeta.getInterfaceId())) ;
        record.setRecordName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_REQ_RECORD_NAME, "{0} 요청"), interfaceMeta.getInterfaceName())) ;
      }
      else
      {
        record.setRecordId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_RES_RECORD_ID, "IFD_{0}_O"), interfaceMeta.getInterfaceId())) ;
        record.setRecordName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_RES_RECORD_NAME, "{0} 응답"), interfaceMeta.getInterfaceName())) ;
      }

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

    record.setRecordOptions(unmarshalOption(modelElement)) ;
    record.setFields(new LinkedList<>()) ;

    int order = 0 ;
    for (Iterator<Element> it = modelElement.elementIterator() ; it.hasNext() ;)
    {
      Element childElement = it.next() ;
      switch (childElement.getName())
      {
      case "FILED" :
      case "COLUMN" :
        unmarshalField(record, order++, childElement) ;
        break ;

      case "GROUP" :
        objects.addAll(unmarshalGroup(record, order++, childElement)) ;
        break ;
        
      default:
         	break;
         	
      }
    }

    return objects ;
  }

  protected String unmarshalOption(Element format)
  {
    Properties properties = new Properties() ;

    if (null != format.attributeValue(ATTRIBUTE_ECR_MCD))
      properties.setProperty(ATTRIBUTE_ECR_MCD, format.attributeValue(ATTRIBUTE_ECR_MCD)) ;

    return PropertyUtils.encode(properties) ;
  }

  protected void unmarshalField(Record record, int order, Element childElement)
  {
    Field field = new Field() ;
    field.setPk(new FieldPK()) ;
    field.setRecord(record) ;

    field.getPk().setRecordId(record.getRecordId()) ;
    field.getPk().setFieldId(childElement.attributeValue(ATTRIBUTE_TER_ENG_NM)) ;
    field.setFieldName(childElement.attributeValue(ATTRIBUTE_TER_NM)) ;
    field.setFieldOrder(order) ;
    // 논리유형명 : "CHAR" - 문자형, "NUMBER" - 숫자형, "BINARY" - 바이너리형, ※ 구분문자가 있는 경우에는
    // 생략(최대자리수, 소수점자리수도 동일 적용)
    field.setFieldType(NAME_TYPE_MAP.get(childElement.attributeValue(ATTRIBUTE_LCL_TP_NM))) ;
    // Not, Fixed, Variable
    field.setArrayType(NAME_ARRYTYPE_MAP.get("Not")) ;
    field.setFieldLength(Integer.parseInt(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_MAX_LEN), "0"))) ;
    field.setFieldScale(Integer.parseInt(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_EPT_LEN), "0"))) ;
    field.setFieldRequireYn(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_COL_REQ_F), "N").charAt(0)) ;
    field.setFieldOptions(unmarshalOption(childElement)) ;

    record.getFields().add(field) ;
  }

  protected Collection<Object> unmarshalGroup(Record record, int order, Element childElement)
  {
    Field field = new Field() ;
    field.setPk(new FieldPK()) ;
    field.setRecord(record) ;

    field.getPk().setRecordId(record.getRecordId()) ;
    field.getPk().setFieldId(childElement.attributeValue(ATTRIBUTE_TER_ENG_NM)) ;
    field.setFieldName(childElement.attributeValue(ATTRIBUTE_TER_NM)) ;
    field.setFieldOrder(order) ;
    field.setFieldType(NAME_TYPE_MAP.get("Group")) ;
    // Not, Fixed, Variable
    field.setArrayType(NAME_ARRYTYPE_MAP.get("Variable")) ;
    field.setFieldRequireYn(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_COL_REQ_F), "N").charAt(0)) ;

    Record subRecord = new Record() ;
    Collection<Object> list = unmarshalRecord(subRecord, childElement, field, false) ;
    field.setRecordObject(subRecord) ;

    field.setSubRecordId(subRecord.getRecordId()) ;
    field.setReferenceFieldId(StringUtils.defaultString(childElement.attributeValue(ATTRIBUTE_PEA_TN))) ;

    field.setFieldOptions(unmarshalOption(childElement)) ;

    record.getFields().add(field) ;

    return list ;
  }

  protected Mapping unmarshalMapping(Element mappingElement, Interface interfaceMeta, Service service, boolean isRequest) throws Exception
  {
    Mapping mapping = new Mapping() ;
    mapping.setPrivilegeId(interfaceMeta.getPrivilegeId()) ;
    mapping.setPrivateYn('N') ;
    mapping.setMappingType(Mapping.TYPE_INDI) ;
    mapping.setMappingGroup(interfaceMeta.getInterfaceGroup()) ;
    mapping.setMappingDetails(new LinkedList<>()) ;

    String recordId = null ;

    if (isRequest)
    {
      mapping.setMappingId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_REQ_MAPPING_ID, "IMP_{0}_{1}_I"), interfaceMeta.getInterfaceId(), service.getServiceId())) ;
      mapping.setMappingName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_REQ_MAPPING_NAME, "{0}-{1} 요청 맵핑"), interfaceMeta.getInterfaceId(), service.getServiceName())) ;
      recordId = service.getRequestRecordId() ;
    }
    else
    {
      mapping.setMappingId(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_RES_MAPPING_ID, "IMP_{0}_{1}_O"), interfaceMeta.getInterfaceId(), service.getServiceId())) ;
      mapping.setMappingName(MessageFormat.format(propertyService.getProperty(NAMING_RULE, INTERFACE_RES_MAPPING_NAME, "{0}-{1} 응답 맵핑"), interfaceMeta.getInterfaceId(), service.getServiceName())) ;
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

    unmarshalMappingRuleDetail(mappingRule, mappingElement) ;
    mappingDetail.setMappingRuleObject(mappingRule) ;

    return mapping ;
  }

  protected void unmarshalMappingRuleDetail(MappingRule mappingRule, Element element)
  {
    mappingRule.setMappingRuleDetails(new LinkedList<>()) ;

    int detailNo = 0 ;
    for (Element childElement : element.elements(ELEMENT_ITEM))
    {
      MappingRuleDetail mappingRuleDetail = new MappingRuleDetail() ;
      mappingRuleDetail.setPk(new MappingRuleDetailPK()) ;

      mappingRuleDetail.getPk().setMappingId(mappingRule.getPk().getMappingId()) ;
      mappingRuleDetail.getPk().setMappingOrder(mappingRule.getPk().getMappingOrder()) ;
      mappingRuleDetail.getPk().setMappingDetailNo(detailNo++) ;

      mappingRuleDetail.setTargetFieldPath(childElement.attributeValue(ATTRIBUTE_MP_TAR)) ;
      mappingRuleDetail.setMappingExpression(childElement.attributeValue(ATTRIBUTE_MP_SRC)) ;
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