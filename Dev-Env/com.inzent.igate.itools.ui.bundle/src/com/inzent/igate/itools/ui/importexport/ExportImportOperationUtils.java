package com.inzent.igate.itools.ui.importexport ;

import java.io.ByteArrayInputStream ;
import java.io.ByteArrayOutputStream ;
import java.io.File ;
import java.io.FileInputStream ;
import java.io.FileOutputStream ;
import java.util.Collection ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.lang3.StringUtils ;
import org.dom4j.Document ;
import org.dom4j.Element ;
import org.dom4j.io.OutputFormat ;
import org.dom4j.io.SAXReader ;
import org.dom4j.io.XMLWriter ;

import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.rule.operation.OperationNode ;
import com.inzent.imanager.api.IManagerException ;
import com.inzent.imanager.api.ResponseObject ;
import com.inzent.itools.util.ClientManager ;

public class ExportImportOperationUtils implements Exporter<Operation>, Importer<Operation>
{
  public static final String MESSAGE = "Message" ;
  
  //Export
  public static final String RESULT_COUNT = "ResultCount" ;
  
  //Import
  public static final String RESULT_List = "ResultList" ;

  // ==[Export]========================================================================================================
  @Override
  public Map<String, Object> exportJson(String path, Operation object)
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public Map<String, Object> exportExcel(String path, Operation object)
  {
    throw new UnsupportedOperationException() ;
  }

  // ===[Xml]========================================================================================================
  /**
   * Export exportXml
   * 
   * @param String
   *          path 저장 위치
   * @param Operation
   *          operation view 에서 선택한 Operation
   * @return
   */
  public Map<String, Object> exportXml(String path, Operation operation)
  {
    Map<String, Object> resultMap = new HashMap<String, Object>() ;

    if (null == operation.getOperationRule())
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE10)) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    try
    {	
    	  
      /* Kiuwan - XML entity injection 처리 */
      SAXReader saxReader = new SAXReader();
      saxReader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
      saxReader.setFeature("http://xml.org/sax/features/external-general-entities", false);
      saxReader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);      
      Document doc = saxReader.read(new ByteArrayInputStream(operation.getOperationRule()));

      Element root = doc.getRootElement();
      root.addAttribute(OperationNode.XML_ATTRIBUTE_ID, operation.getOperationId()) ; // operationId
      root.addAttribute(OperationNode.XML_ATTRIBUTE_TYPE, Character.toString(operation.getOperationType())) ; // operationType
      root.addAttribute(OperationNode.XML_ATTRIBUTE_NAME, operation.getOperationName()) ; // operationName
      root.addAttribute(OperationNode.XML_ATTRIBUTE_DESC, operation.getOperationDesc()) ; // operationDesc
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP, operation.getOperationGroup()) ; // operationGroup
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID, operation.getPrivilegeId()) ; // privilegeId
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN, Character.toString(operation.getPrivateYn())) ; // privateYn
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL, operation.getOperationLogLevel()) ; // operationLogLevel
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE, Character.toString(operation.getXaTransactionAttribute())) ; // xaTransactionAttribute

      operation.setOperationDocument(doc) ;
    }
    catch (Exception e)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, e.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    String fileName = path + String.format(File.separator + "%s.%s", operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML) ;
    XMLWriter xMLWriter = null ;
    try (FileOutputStream fos = new FileOutputStream(fileName))
    {
      xMLWriter = new XMLWriter(fos) ;
      xMLWriter.write(operation.getOperationDocument()) ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }
    finally
    {
      if (null != xMLWriter)
        try
        {
          xMLWriter.close() ;
        }
        catch (Throwable th)
        {
          // dummy
        }
    }

    try
    {
      encryption(fileName) ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_COUNT, 1) ;
    return resultMap ;
  }

  // ==[Import]========================================================================================================
  @Override
  public Map<String, Object> importJson(String path, String[] fileList, Operation object)
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public Map<String, Object> importExcel(String path, String[] fileList, Operation object)
  {
    throw new UnsupportedOperationException() ;
  }

  // ===[Xml]========================================================================================================
  @Override
  public Map<String, Object> importXml(String path, String[] fileList, Operation object)
  {
    String resultMessage = StringUtils.EMPTY ;
    List<Operation> importSuccessList = new LinkedList<>() ;

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      Map<String, Object> resultMap = importXml(path + File.separator + fileList[fileListLength]) ;
      resultMessage += resultMap.get(MESSAGE) ;
      if (null != resultMap.get(RESULT_List))
        importSuccessList.add((Operation) resultMap.get(RESULT_List)) ;
    }

    Map<String, Object> resultMap = new HashMap<String, Object>() ;
    resultMap.put(MESSAGE, resultMessage) ;
    resultMap.put(RESULT_List, importSuccessList) ;

    return resultMap ;
  }

  protected Map<String, Object> importXml(String filePath)
  {
    Map<String, Object> resultMap = new HashMap<String, Object>() ;

    String readFileName = StringUtils.substringAfterLast(filePath, File.separator) ;
    String path ;
    try
    {
      path = decryption(filePath, true) ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE4)) ;
      return resultMap ;
    }

    Operation operation = new Operation() ;
    
    try
    {
      Document document ;
      try (FileInputStream fis = new FileInputStream(path))
      {        
        /* Kiuwan - XML entity injection 처리 */
        SAXReader saxReader = new SAXReader();
        saxReader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        saxReader.setFeature("http://xml.org/sax/features/external-general-entities", false);
        saxReader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);     
       
        document = saxReader.read(fis) ;
      }

      Element element = document.getRootElement() ;
      
      operation.setOperationId(StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_ID))) ;  // operationId
      operation.setOperationType(StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_TYPE, operation.getOperationId())).charAt(0)) ; // operationType
      operation.setOperationName(StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_NAME))) ; // operationName
      operation.setOperationDesc(StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_DESC))) ; // operationDesc
      operation.setOperationGroup(StringUtils.defaultString(element.attributeValue(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP))) ; // operationGroup
      operation.setPrivilegeId(StringUtils.defaultString(element.attributeValue(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID))) ; // privilegeId
      operation.setPrivateYn(StringUtils.defaultString(element.attributeValue(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN), "N").charAt(0)) ; // privateYn
      operation.setOperationLogLevel(StringUtils.defaultString(element.attributeValue(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL), "N/A")) ; // operationLogLevel
      operation.setXaTransactionAttribute(StringUtils.defaultString(element.attributeValue(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE), new Character(Operation.XA_TRAN_SUPPORTS).toString()).charAt(0)) ; // xaTransactionAttribute

      // operationId
      if (null != element.attribute(OperationNode.XML_ATTRIBUTE_ID))
        element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_ID)) ;

      // operationType
      if (null != element.attribute(OperationNode.XML_ATTRIBUTE_TYPE))
        element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_TYPE)) ;

      // operationName
      if (null != element.attribute(OperationNode.XML_ATTRIBUTE_NAME))
        element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_NAME)) ;

      // operationDesc
      if (null != element.attribute(OperationNode.XML_ATTRIBUTE_DESC))
        element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_DESC)) ;

      // operationGroup
      if (null != element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP))
        element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP)) ;

      // privilegeId
      if (null != element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID))
        element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID)) ;

      // privateYn
      if (null != element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN))
        element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN)) ;

      // operationLogLevel
      if (null != element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL))
        element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL)) ;

      // xaTransactionAttribute
      if (null != element.attribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE))
        element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE)) ;

      operation.setOperationDocument(document) ;

      // xml data update
      try (ByteArrayOutputStream out = new ByteArrayOutputStream())
      {
        XMLWriter writer = new XMLWriter(out, OutputFormat.createPrettyPrint()) ;
        writer.write(operation.getOperationDocument()) ;
        writer.flush() ;

        operation.setOperationRule(out.toByteArray()) ;
        operation.setOperationRuleDirty(true) ;
      }

      // ======================================================================================================
      // 21.05.27 사용자가 소유한 권한 정보 체크 하여 재설정
      Collection<String> userBusinessPrivileges ;
      try
      {
        userBusinessPrivileges = ClientManager.getInstance().getIManagerClient().getBusinessPrivileges() ;
      }
      catch (Throwable th)
      {
        userBusinessPrivileges = new LinkedList<>() ;
      }

      if (!userBusinessPrivileges.isEmpty() && !userBusinessPrivileges.contains(operation.getPrivilegeId()))
        operation.setPrivilegeId(userBusinessPrivileges.iterator().next()) ;

      // 모델 존재 유무에 따라 update / insert 로 나눠서 처리
      ResponseObject<Operation> responseObject ;
      try
      {
        responseObject = ClientManager.getInstance().getIManagerClient().update(operation) ;
      }
      catch (IManagerException e)
      {
        responseObject = ClientManager.getInstance().getIManagerClient().insert(operation) ;
      }

      if (null != responseObject.getIManagerException())
        throw responseObject.getIManagerException() ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, t.getMessage())) ;

      return resultMap ;
    }
    finally
    {
      try
      {
        decryption(path, false) ;
      }
      catch (Throwable t)
      {
        // dummy
      }
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_List, operation) ;

    return resultMap ;
  }
}
