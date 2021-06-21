/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.record ;

import java.awt.Desktop ;
import java.io.BufferedWriter ;
import java.io.File ;
import java.io.FileOutputStream ;
import java.io.IOException ;
import java.io.InputStream ;
import java.io.OutputStreamWriter ;
import java.io.Writer ;
import java.text.SimpleDateFormat ;
import java.util.HashMap ;

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
import org.eclipse.ui.PlatformUI ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.itools.record.utils.RecordExportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiActivator ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.dialog.BatchExportDialog ;
import com.inzent.igate.itools.utils.Configuration ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.imanager.marshaller.JsonMarshaller ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;

/**
 * <code>RecordExportHandlerImpl</code> �̰��� Ŭ���� ������ ����ϼ���
 *
 * @since 2021. 2. 8.
 * @version 5.0
 * @author Jaesuk Byon
 * @see ���� ��� Ŭ������ �Է��Ͻð� ������� �����ּ���
 */
public class RecordExportHandlerImpl implements RecordExportHandler
{
  public int importSuccessRecordCount, importTotalRecordCount ;
  /**
   * �����ڿ� ���� ������ ����ϼ���
   */
  public RecordExportHandlerImpl()
  {
    // TODO Auto-generated constructor stub
  }

  /**
   * �̰��� �޼ҵ� ������ ����ϼ���
   * 
   * @param record
   * @author Jaesuk Byon, 2021. 2. 8.
   * @see com.inzent.igate.itools.record.utils.RecordExportHandler#exportRecord(com.inzent.igate.repository.meta.Record)
   */
  @Override
  public void exportRecord(Record record)
  {
    importSuccessRecordCount = 0;
    importTotalRecordCount = 0;

    String entityType = "Record" ;
    
    //======= �������� ó�� ���� Ÿ�� ���� ó��  =======     
    // ��ƼƼ Ÿ�Ժ� export �� ���
    HashMap<String, String> exportTypePathMap =  new HashMap<String, String>();
    // ��Ƽ�� Ÿ�Ժ� export �� ������ Ÿ�� ( [ ex ] Record : (1)json/ (2)excel , Operation : (1)xml ) 
    HashMap<String, Integer> exportFileTypeMap =  new HashMap<String, Integer>();
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
    
    //��θ� �������� ���� ��� ���� 
    if(exportTypePathMap.size()==0)
      return;
    
    String resulTotaltMessage = StringUtils.EMPTY ;
    String resulRecordtMessage = StringUtils.EMPTY ;
    
    boolean recordTitlePath = false ;
    
    // Record �� ���,
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

        // JSON �� ���,
        if (fileTpye == 1)
          resulRecordtMessage += exportJson(selectedPath, record) ;

        // Excel �� ���,
        else if (fileTpye == 2)
          resulRecordtMessage += exportExcel(selectedPath, record) ;
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

}
