package com.inzent.igate.itools.ui.handlers ;

import java.awt.Desktop ;
import java.io.BufferedWriter ;
import java.io.ByteArrayInputStream ;
import java.io.File ;
import java.io.FileOutputStream ;
import java.io.IOException ;
import java.io.InputStream ;
import java.io.OutputStreamWriter ;
import java.io.StringWriter ;
import java.io.Writer ;
import java.text.SimpleDateFormat ;
import java.util.ArrayList ;
import java.util.HashMap ;
import java.util.List ;
import java.util.Set ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.poi.ss.usermodel.BorderStyle ;
import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.CellStyle ;
import org.apache.poi.ss.usermodel.Font ;
import org.apache.poi.ss.usermodel.HorizontalAlignment ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.VerticalAlignment ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.dom4j.Document ;
import org.dom4j.Element ;
import org.dom4j.io.OutputFormat ;
import org.dom4j.io.SAXReader ;
import org.dom4j.io.XMLWriter ;
import org.eclipse.core.commands.ExecutionException ;
import org.eclipse.ui.PlatformUI ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.itools.handlers.AbstractExportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiActivator ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.dialog.BatchExportDialog ;
import com.inzent.igate.itools.utils.Configuration ;
import com.inzent.igate.itools.views.MenuViewPart ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.rule.operation.OperationNode ;
import com.inzent.imanager.api.ResponseObject ;
import com.inzent.imanager.marshaller.JsonMarshaller ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;
import com.inzent.itools.views.AbstractMenuViewPart ;
import com.inzent.itools.views.MenuContentItem ;

public class ExportHandler extends AbstractExportHandler
{
  public int importTotalRecordCount = 0, importSuccessRecordCount = 0;
  public int importTotalOperationCount = 0, importSuccessOperationCount = 0;
  
  @Override
  protected void exportSelected(Set<MenuContentItem> items) throws ExecutionException
  {
    // �������� Dialog ���� view������ ����Ű Ctrl + c, Ctrl + v�� ������ ȸ���ϱ� ���� 
    ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(items.iterator()) ;

    //======= �������� ���� ���� üũ =======
    List<String> possibleTypeList = new ArrayList<String>();
    List<String> impossibleTypeList = new ArrayList<String>();
    for (MenuContentItem menuContentItem : items )
    {
      if((menuContentItem.getValue() instanceof Record) || (menuContentItem.getValue() instanceof Operation))      
      {        
        if(possibleTypeList.contains(menuContentItem.getValue().getClass().getSimpleName())==false)
          possibleTypeList.add(menuContentItem.getValue().getClass().getSimpleName());
      }
      else
      {
        if(impossibleTypeList.contains(menuContentItem.getValue().getClass().getSimpleName())==false)
          impossibleTypeList.add(menuContentItem.getValue().getClass().getSimpleName());
      }
    }
    
    // export �õ� �׸�� ����  Ÿ�Ժ� 1 �Ұ���/����  Ȯ�� �޽���
    String message = StringUtils.EMPTY;
    if(impossibleTypeList.size()>0)
      message += impossibleTypeList.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE3;
    if((impossibleTypeList.size()>0) && (possibleTypeList.size()>0))
      message += "\n\n";
    if(possibleTypeList.size()>0)
    {
      message += possibleTypeList.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE6 ;
      message += "\n\n";
      message += UiMessage.INFORMATION_IO_MESSAGE7;
    }

    //export ������ Ÿ���� ���� ��� �޽�ġ ��� �� ���� 
    if(possibleTypeList.size()==0)
    {
      LogHandler.openInformation( message ); 
      return;
    }
    //export ������ Ÿ���� ���� �ϴ� ��� export �������� ���� Ȯ�� �޽���â 
    else
    {
      if( !LogHandler.openConfirm(message  +"\n\n"+ UiMessage.INFORMATION_IO_MESSAGE11) )
        return;      
    }

    //======= �������� ���� ���� üũ  =======

    //======= �������� ó�� ���� Ÿ�� ���� ó��  =======     
    // ��ƼƼ Ÿ�Ժ� export �� ���
    HashMap<String, String> exportTypePathMap =  new HashMap<String, String>();
    // ��Ƽ�� Ÿ�Ժ� export �� ������ Ÿ�� ( [ ex ] Record : (1)json/ (2)excel , Operation : (1)xml ) 
    HashMap<String, Integer> exportFileTypeMap =  new HashMap<String, Integer>();

    for(String entityType : possibleTypeList)
    {
      // Browse(������)
      BatchExportDialog dialog = new BatchExportDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell()) ;
      // entity Ÿ�� ���� �ѱ�
      dialog.setEntityType(entityType);
      dialog.open() ;
      int fileTpye = dialog.getFileType() ;
      String selectedPath = dialog.getDirectoryPath() ;

      if(selectedPath != null)
      {
        exportTypePathMap.put(entityType, selectedPath);
        exportFileTypeMap.put(entityType, fileTpye);
      }
    }

    //��θ� �������� ���� ��� ���� 
    if(exportTypePathMap.size()==0)
      return;

    String resulTotaltMessage = StringUtils.EMPTY ;
    String resulRecordtMessage = StringUtils.EMPTY ;
    String resulOperationtMessage = StringUtils.EMPTY ;
    
    importTotalRecordCount = 0;
    importSuccessRecordCount = 0;
    
    importTotalOperationCount = 0;
    importSuccessOperationCount = 0;
    
    boolean recordTitlePath = false, operationTitlePath = false;
    
    for (MenuContentItem menuContentItem : items )
    {
      String selectedPath = null;
      int fileTpye = 1;
      
      // Record �� ���,
      if (menuContentItem.getValue() instanceof Record)
      {
        importTotalRecordCount ++ ;
        selectedPath = exportTypePathMap.get(Record.class.getSimpleName());
        if(selectedPath!=null)
        {
          fileTpye =exportFileTypeMap.get(Record.class.getSimpleName());

          if(!recordTitlePath)
          {
            resulRecordtMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE , Record.class.getSimpleName());
            resulRecordtMessage += String.format(MetaConstants.MESSAGE_EXPORT_PATH, selectedPath);
            recordTitlePath = true;
          }

          Record record = (Record) menuContentItem.getValue() ;
          ResponseObject<Record> responseObject = null ;

          Record currentRecord = null ;
          try
          {
            responseObject = ClientManager.getInstance().getIManagerClient().get(record) ;
            currentRecord = responseObject.getObject() ;
          }
          catch (Exception e)
          { 
            LogHandler.openInformation(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE7) ;
          }

          // JSON �� ���,
          if (fileTpye == 1)
            resulRecordtMessage += exportJson(selectedPath, currentRecord) ;

          // Excel �� ���,
          else if (fileTpye == 2)
            resulRecordtMessage += exportExcel(selectedPath, currentRecord) ;
        }
      }

      //Operation �� ��� ,
      else if (menuContentItem.getValue() instanceof Operation)
      {
        importTotalOperationCount ++ ;
        selectedPath = exportTypePathMap.get(Operation.class.getSimpleName());
        if(selectedPath!=null)
        {
          fileTpye = exportFileTypeMap.get(Operation.class.getSimpleName());

          if(!operationTitlePath)
          {
            resulOperationtMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE , Operation.class.getSimpleName());
            resulOperationtMessage += String.format(MetaConstants.MESSAGE_EXPORT_PATH, selectedPath);
            operationTitlePath = true;
          }

          Operation operation = (Operation) menuContentItem.getValue() ;
          ResponseObject<Operation> responseObject = null ;

          Operation currentOperation= null ;
          try
          {
            responseObject = ClientManager.getInstance().getIManagerClient().get(operation) ;
            currentOperation = responseObject.getObject() ;
          }
          catch (Exception e)
          { 
            LogHandler.openInformation(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE7) ;
          }

          // xml �� ���,
          if (fileTpye == 1)
            resulOperationtMessage += exportXml(selectedPath, currentOperation) ;
        }
      }
    }

    //��� �޽��� ����
    resulTotaltMessage = StringUtils.EMPTY ;
    if(!resulRecordtMessage.equals(StringUtils.EMPTY))
    {
      //export ���� 
      if(importTotalRecordCount >0) 
        resulRecordtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, importTotalRecordCount, importSuccessRecordCount, importTotalRecordCount-importSuccessRecordCount );
      
      resulTotaltMessage += resulRecordtMessage;
    }
    
    if(!resulOperationtMessage.equals(StringUtils.EMPTY))
    {
      //export ����
      if(importTotalOperationCount >0) 
        resulOperationtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, importTotalOperationCount, importSuccessOperationCount, importTotalOperationCount-importSuccessOperationCount );
      
      resulTotaltMessage += resulOperationtMessage;
    }
    
    //�������� ��� ��� Ȯ�� â 
    //LogHandler.openInformation(UiMessage.INFORMATION_IO_MESSAGE1 + resulTotaltMessage) ;
    
    //�������� ��� ��� & ��������� ������ ������ ���� ������ ���ڽ��ϱ�? Ȯ�� �޽��� â 
    //if(StringUtils.contains(System.getProperty("os.name").toLowerCase(), "windows"))  //������ Ȯ��
    if(!resulTotaltMessage.equals(StringUtils.EMPTY))
    {
      if( LogHandler.openConfirm(UiMessage.INFORMATION_IO_MESSAGE1 + resulTotaltMessage          
          +"\n\n"+ UiMessage.INFORMATION_IO_MESSAGE8) )
      {
        for(String exportPath : exportTypePathMap.values())
        {
          try
          {
            Desktop.getDesktop().open(new File(exportPath));
          }
          catch (IOException e) {;}
        }
      }
    }
    
  }

  //===[Excel]========================================================================================================
  /**
   * Export Excel
   * @param String path     ���� ��ġ
   * @param Record record   view ���� ������ record
   * @return
   * @author jkh, 2020. 3. 9.
   */
  public String exportExcel(String path, Record record)
  {
    String resultMessage = "" ;

    if (record instanceof Record)
    {
      path += String.format("\\%s.%s", record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL) ;
      return resultMessage = createExcel(path, record) ;
    }
    else
    {
      return resultMessage ;
    }
  }
  
  /**
   * ���� ���ø� �ε� �� �� �ʵ� ���� ����
   * @param String path     ������� ���ϸ�
   * @param Record record   ������ Record
   * @return
   * @author jkh, 2020. 3. 3.
   * @throws Exception 
   */
  public String createExcel(String path, Record record)
  {
    Row row = null ;
    Cell cell = null ;

    Workbook workbook = null ;
    Sheet writeSheet = null ;

    try (InputStream is = Configuration.getTemplate("Model_Define.xlsx"))
    {
      workbook = WorkbookFactory.create(is) ;
      writeSheet = workbook.getSheetAt(0) ;

      String value = null ;
      // Cell ��Ÿ�� ����.
      CellStyle cellStyle = workbook.createCellStyle() ;
      cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;// �ؽ�Ʈ ����(���ΰ��)
      cellStyle.setAlignment(HorizontalAlignment.LEFT) ;// �ؽ�Ʈ ���� (���� ����)

      Font font = workbook.createFont() ;// ��Ʈ
      font.setFontHeight((short) 180) ;
      font.setFontName("����") ;
      cellStyle.setFont(font) ;

      cellStyle.setBorderBottom(BorderStyle.HAIR) ;// Cell �׵θ� (����)
      cellStyle.setBorderLeft(BorderStyle.HAIR) ;
      cellStyle.setBorderRight(BorderStyle.HAIR) ;
      cellStyle.setBorderTop(BorderStyle.HAIR) ;
      
      cellStyle.setLocked(true) ; // Cell ���
      cellStyle.setWrapText(true) ; // Cell ���� Text �ٹٲ� Ȱ��ȭ
      
      // ���� 2��° �� �� ����
      // ��ID
      value = record.getRecordId() ;
      row = writeSheet.getRow(1) ;
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // ����
      value = record.getRecordDesc() ;
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // ��/���
      value = record.getRecordId() ;
      if (value.endsWith("_I")) 
        value = "�Է�" ; 
      else if (value.endsWith("_O")) 
        value = "���" ; 
      else
        value = "" ; 

      cell = row.getCell(8) ;
      cell.setCellValue(value) ;

      // ������
      if (record.getRecordType() == Record.TYPE_HEADER)
        value = MetaConstants.EXCEL_HEADER ;
      else if (record.getRecordType() == Record.TYPE_REFER)
        value = MetaConstants.EXCEL_REFER ;
      else
        value = MetaConstants.EXCEL_INDIVI ;

      cell = row.getCell(10) ;
      cell.setCellValue(value) ;
      
      //�� �̸�
      value = record.getRecordName() ;
      cell = row.getCell(12) ;
      cell.setCellValue(value) ;
      
      // ���� 3��° �� �� ����
      // �׷�
      value = record.getRecordGroup() ;
      row = writeSheet.getRow(2) ;
      
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // ����
      value = record.getPrivilegeId() ;
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // �ɼ�
      value = record.getRecordOptions() ;
      cell = row.getCell(5) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // ������ ���
//      value = record.getIndividualPath() ;
//      cell = row.getCell(8) ;
//      cell.setCellStyle(cellStyle) ;
//      cell.setCellValue(value) ;

      // ��������
      if (record.getPrivateYn() == 'Y')
        value = "Y" ; 
      else
        value = "N" ; 

      cell = row.getCell(10) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // �ۼ���
      value = record.getUpdateUserId() ;
      cell = row.getCell(14) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // �ۼ���
      SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:MM:ss") ; 
      value = formatter.format(record.getUpdateTimestamp()) ;
      cell = row.getCell(17) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      exportExcelFields(workbook, writeSheet, record, 4, 0) ;

      try (FileOutputStream fileOutputStream = new FileOutputStream(path))
      {
        workbook.write(fileOutputStream) ;
      }
      
      importSuccessRecordCount++;
      return String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_SUCCESS);
    }
    catch (Throwable t)
    {
      LogHandler.openError(UiActivator.PLUGIN_ID, t) ;
      return String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_FAIL, t.getMessage());
    }
  }
  // 
  /**
   * �� �ʵ� ���� ����
   * @param Workbook workbook   �������� �� ���� workbook
   * @param Sheet writeSheet    �������� �� ���� ��Ʈ
   * @param Record record       �������� �� record
   * @param int index           �� �ʵ������� �Էµ� ������ row ��ȣ (4)
   * @param int depth           Level (������ 0)
   * @return
   * @author jkh, 2020. 3. 4.
   */
  public int exportExcelFields(Workbook workbook, Sheet writeSheet, Record record, int index, int depth)
  {
    int count = record.getFields().size() ;

    Field currentField = null ;
    FieldPK fieldPK = null ;
    Row row = null ;
    Cell cell = null ;
    String value = null ;

    // Cell ��Ÿ�� ����.
    CellStyle cellStyle = workbook.createCellStyle() ;
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;// �ؽ�Ʈ ����(���� ���)
    cellStyle.setAlignment(HorizontalAlignment.LEFT) ;// �ؽ�Ʈ ���� (���� ����)

    Font font = workbook.createFont() ;// ��Ʈ
    font.setFontHeight((short) 180) ;
    font.setFontName("����") ;
    font.setBold(false) ;
    cellStyle.setFont(font) ;

    cellStyle.setBorderBottom(BorderStyle.HAIR) ;// Cell �׵θ� (����)
    cellStyle.setBorderLeft(BorderStyle.HAIR) ;
    cellStyle.setBorderRight(BorderStyle.HAIR) ;
    cellStyle.setBorderTop(BorderStyle.HAIR) ;

    cellStyle.setLocked(true) ;// Cell ���

    char chVal ;
    int nVal ;

    for (int i = 0 ; i < count ; i++)
    {
      currentField = record.getFields().get(i) ;
      fieldPK = currentField.getPk() ;

      // FIELD_LEVEL
      row = writeSheet.createRow(index) ;
      cell = row.createCell(0) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Integer.toString(depth)) ;

      // �ʵ� ID
      value = fieldPK.getFieldId() ;
      for (int j = 0 ; j < depth ; j++)
        value = "   " + value ; 
      cell = row.createCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // FIELD_NAME
      value = currentField.getFieldName() ;
      cell = row.createCell(2) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // INDEX_FIELD_ID
      value = currentField.getFieldIndex() ;
      cell = row.createCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
     
      // FIELD_TYPE
      value = MetaConstants.FIELD_TYPES.get(currentField.getFieldType()) ;
      cell = row.createCell(4) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // FIELD_LENGTH
      nVal = currentField.getFieldLength() ;
      value = Integer.toString(nVal) ;
      cell = row.createCell(5) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // FIELD_SCALE
      nVal = currentField.getFieldScale() ;
      value = Integer.toString(nVal) ;
      cell = row.createCell(6) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // ARRAY_TYPE
      value = MetaConstants.FIELD_ARRAYTYPES.get(currentField.getArrayType()) ;
      cell = row.createCell(7) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // Reference_FIELD_ID
      value = currentField.getReferenceFieldId() ;
      cell = row.createCell(8) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // FIELD_DEFAULT_VALUE
      value = currentField.getFieldDefaultValue() ;
      cell = row.createCell(9) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
     // FIELD_HIDDEN_YN
      chVal = currentField.getFieldHiddenYn() ;
      value = Character.toString(chVal) ;
      cell = row.createCell(10) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

     // FIELD_REQUIRE YN
      chVal = currentField.getFieldRequireYn() ;
      value = Character.toString(chVal);
      cell = row.createCell(11) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // FIELD_VALID_VALUE
      value = currentField.getFieldValidValue() ;
      cell = row.createCell(12) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // FIELD_CODEC_ID
      value = currentField.getCodecId();
      cell = row.createCell(13) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // Options
      value = currentField.getFieldOptions();
      cell = row.createCell(14) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      Record subRecord = currentField.getRecordObject() ;

      if (currentField.getFieldType() == Field.TYPE_RECORD && currentField.getSubRecordId() != null)
      {
        if (subRecord == null)
          subRecord = getSubRecord(currentField) ;

        if (subRecord.getRecordType() != Record.TYPE_EMBED)
        {
          value = "Y" ; 
          cell = row.createCell(15) ;
          cell.setCellStyle(cellStyle) ;
          cell.setCellValue(value) ;

          // SUB_RECORD_ID
          value = currentField.getSubRecordId() ;
          cell = row.createCell(16) ;
          cell.setCellStyle(cellStyle) ;
          cell.setCellValue(value) ;
        }
      }
      // REFERANCE_YN
      else if (currentField.getFieldType() == Field.TYPE_RECORD && currentField.getSubRecordId() != null)
      {
        if (subRecord == null)
          subRecord = getSubRecord(currentField) ;
      }
      
      index++ ;

      if (subRecord != null && subRecord.getRecordType() == Record.TYPE_EMBED)
      {
        // RECORD_OPTION
        value = subRecord.getRecordOptions() ;
        row = writeSheet.getRow(index - 1) ;
        cell = row.getCell(14) ;
        cell.setCellStyle(cellStyle) ;
        cell.setCellValue(value) ;

        index = exportExcelFields(workbook, writeSheet, subRecord, index, depth + 1) ;
      }

    }

    return index ;
  }
  
  private Record getSubRecord(Field field)
  {
    Record subRecord = field.getRecordObject() ;

    if (subRecord == null)
      try
      {
        ClientManager.getInstance().getIManagerClient().get(subRecord) ;
        field.setRecordObject(subRecord) ;
      }
      catch (Exception e)
      {
        LogHandler.error(UiActivator.PLUGIN_ID, e.getCause()) ;
      }
    return subRecord ;
  }
  
  
  //===[Json]========================================================================================================
  /**
   * Export Json
   * @param String path     ���� ��ġ
   * @param Record record   view ���� ������ record
   * @return
   * @author jkh, 2020. 3. 4.
   */
  public String exportJson(String path, Record record)
  {
    String resultMessage = "" ;

    if (record instanceof Record)
    {
      path += String.format("\\%s.%s", record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON) ;
      return resultMessage = createJson(path, record) ;
    }
    else
    {
      return resultMessage ;
    }
  }

  /**
   * json ���� ����
   * @param String path     ��� ���� ���ϸ�
   * @param Record record   ������ Record
   * @return
   * @author jkh, 2020. 3. 9.
   */
  public String createJson(String path, Record record )
  {
    try
    { 
      //String jsonRecord = new String(JsonMarshaller.marshalToBytes(record), JsonEncoding.UTF8.getJavaName()) ;      
      String jsonRecord = new String(JsonMarshaller.marshalToJsonNode(record).toPrettyString().getBytes());      
      Writer outFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), JsonEncoding.UTF8.getJavaName())) ;
      outFile.write(jsonRecord) ;
      outFile.flush() ;
      outFile.close() ;
    }
    catch (IOException e)
    {
      return String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_FAIL, e.getMessage());
    }
    importSuccessRecordCount++;
    return String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_SUCCESS);
  }
  
  //===[Xml]========================================================================================================

  /**
   * Export exportXml
   * @param String path ���� ��ġ
   * @param Operation operation   view ���� ������ Operation
   * @return
   */
  public String exportXml(String path, Operation operation)
  {
    String resultMessage = "" ;

    if (operation instanceof Operation)
    {
      path += String.format("\\%s.%s", operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML) ;
      return resultMessage = createXml(path, operation) ;
    }
    else
    {
      return resultMessage ;
    }
  }


  /**
   * Xml ���� ����
   * @param String path ��� ���� ���ϸ�
   * @param Operation operation  ������ Operation
   * @return
   */
  public String createXml(String path, Operation operation )
  {
    String content = null;
    final byte[] roleDocument = operation.getOperationRule() ;
    if (roleDocument == null)
      return String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE10);

    try
    {
      Document doc =  new SAXReader().read(new ByteArrayInputStream(operation.getOperationRule()));
      Element root = doc.getRootElement();
      root.addAttribute(OperationNode.XML_ATTRIBUTE_ID, operation.getOperationId());                            //operationId           
      root.addAttribute(OperationNode.XML_ATTRIBUTE_TYPE, Character.toString(operation.getOperationType()));    //operationType         
      root.addAttribute(OperationNode.XML_ATTRIBUTE_NAME, operation.getOperationName());                        //operationName         
      root.addAttribute(OperationNode.XML_ATTRIBUTE_DESC, operation.getOperationDesc());                        //operationDesc         
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP,operation.getOperationGroup());                                        //operationGroup        
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID,operation.getPrivilegeId());                                              //privilegeId           
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN, Character.toString(operation.getPrivateYn()));                             //privateYn             
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL,operation.getOperationLogLevel());                                  //operationLogLevel     
      root.addAttribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE,Character.toString(operation.getXaTransactionAttribute()));    //xaTransactionAttribute

      operation.setOperationDocument(doc);
    }
    catch (Exception e)
    {
      return String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, e.getMessage());
    }

    try (StringWriter out = new StringWriter())
    {
      XMLWriter writer = new XMLWriter(out, OutputFormat.createPrettyPrint()) ;
      writer.write(operation.getOperationDocument()) ;
      writer.flush() ;

      content = out.toString() ;
      String xmlOperation = content;

      Writer outFile = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), JsonEncoding.UTF8.getJavaName())) ;
      outFile.write(xmlOperation) ;
      outFile.flush() ;
      outFile.close() ;
    }
    catch (Exception e)
    {
      return String.format(MetaConstants.MESSAGE_EXPORT_FAIL, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_FAIL, e.getMessage());
    }
    importSuccessOperationCount ++ ;
    return String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, operation.getOperationId(), MetaConstants.FILE_EXTENDER_XML, UiMessage.LABEL_SUCCESS);
  }
}
