package com.inzent.igate.itools.ui.importexport ;

import java.io.File ;
import java.io.FileInputStream ;
import java.io.FileOutputStream ;
import java.io.IOException ;
import java.io.InputStream ;
import java.io.OutputStreamWriter ;
import java.text.SimpleDateFormat ;
import java.util.Date;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.Objects ;
import java.util.Set ;
import java.util.TreeSet ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.poi.EncryptedDocumentException ;
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
import org.apache.poi.util.IOUtils ;
import org.eclipse.osgi.util.NLS ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiActivator ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.utils.Configuration ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.imanager.api.ResponseObject ;
import com.inzent.imanager.marshaller.JsonMarshaller ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;

public class ExportImportRecordUtils implements Exporter<Record>, Importer<Record>
{
  public static final String MESSAGE = "Message" ;

  // Export
  public static final String RESULT_COUNT = "ResultCount" ;

  // Import
  public static final String RESULT_List = "ResultList" ;

  // ==[Export]========================================================================================================
  // ===[Json]========================================================================================================
  /**
   * Export Json
   * 
   * @param String
   *          path ���� ��ġ
   * @param Record
   *          record view ���� ������ record
   * @return
   * @author jkh, 2020. 3. 4.
   */
  @Override
  public Map<String, Object> exportJson(String path, Record record)
  {
    Map<String, Object> resultMap = new HashMap<String, Object>() ;

    String fileName = path + File.separator + String.format("%s.%s", record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON) ;
    try (OutputStreamWriter fos = new OutputStreamWriter(new FileOutputStream(fileName), JsonEncoding.UTF8.getJavaName()))
    {
      fos.write(JsonMarshaller.marshalToJsonNode(record).toPrettyString()) ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    try
    {
      encryption(fileName) ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_COUNT, 1) ;

    return resultMap ;
  }

  // ===[Excel]========================================================================================================
  /**
   * Export Excel
   * 
   * @param String
   *          path ���� ��ġ
   * @param Record
   *          record view ���� ������ record
   * @return
   * @author jkh, 2020. 3. 9.
   */
  @Override
  public Map<String, Object> exportExcel(String path, Record record)
  {
    Map<String, Object> resultMap = new HashMap<String, Object>() ;

    String fileName = path + File.separator + String.format("%s.%s", record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL) ;
    try (InputStream is = Configuration.getTemplate("Model_Define.xlsx"))
    {
      Workbook workbook = WorkbookFactory.create(is) ;

      exportExcelSheet(workbook, workbook.getSheetAt(0), record) ;

      try (FileOutputStream fileOutputStream = new FileOutputStream(fileName))
      {
        workbook.write(fileOutputStream) ;
      }
      catch (IOException e) 
      {
        LogHandler.openError(UiActivator.PLUGIN_ID, e) ;
        
        resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_FAIL, e.getMessage())) ;
        resultMap.put(RESULT_COUNT, 0) ;
        return resultMap ;
      }
    }
    catch (EncryptedDocumentException e)
    {
      LogHandler.openError(UiActivator.PLUGIN_ID, e) ;
      
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_FAIL, e.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }
    catch (IOException e)
    {
      LogHandler.openError(UiActivator.PLUGIN_ID, e) ;
      
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_FAIL, e.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }
    catch (Throwable t)
    {
      LogHandler.openError(UiActivator.PLUGIN_ID, t) ;

      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    try
    {
      encryption(fileName) ;
    }
    catch (IOException e)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_FAIL, e.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_FAIL, record.getRecordId(), MetaConstants.FILE_EXTENDER_JSON, UiMessage.LABEL_FAIL, t.getMessage())) ;
      resultMap.put(RESULT_COUNT, 0) ;
      return resultMap ;
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_EXPORT_SUCCESS, record.getRecordId(), MetaConstants.FILE_EXTENDER_EXCEL, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_COUNT, 1) ;
    return resultMap ;
  }

  @Override
  public Map<String, Object> exportXml(String path, Record object)
  {
    throw new UnsupportedOperationException() ;
  }

  // ==[Import]========================================================================================================
  // ===[Json]========================================================================================================
  /**
   * json ���� ��������
   * 
   * @param String
   *          filePath ������ ���� ���
   * @param String[]
   *          fileList ������ ���� ���
   * @return String ��� �޽���
   * @author jkh, 2020. 3. 6.
   */
  @Override
  public Map<String, Object> importJson(String filePath, String[] fileList, Record record)
  {
    String resultMessage = StringUtils.EMPTY ;
    List<Record> importSuccessList = new LinkedList<>() ;

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      Map<String, Object> resultMap = importJson(filePath + File.separator + fileList[fileListLength], record) ;

      resultMessage += resultMap.get(MESSAGE) ;
      if (null != resultMap.get(RESULT_List))
        importSuccessList.add((Record) resultMap.get(RESULT_List)) ;
    }

    Map<String, Object> resultMap = new HashMap<String, Object>() ;
    resultMap.put(MESSAGE, resultMessage) ;
    resultMap.put(RESULT_List, importSuccessList) ;

    return resultMap ;
  }

  // ===[Excel]========================================================================================================
  /**
   * ���������� ��������
   * 
   * @param String
   *          filePath ���� ���
   * @param String
   *          fileList ������ ���� ���
   * @return
   * @author jkh, 2020. 3. 6.
   */
  @Override
  public Map<String, Object> importExcel(String filePath, String[] fileList, Record record)
  {
    String resultMessage = StringUtils.EMPTY ;
    List<Record> importSuccessList = new LinkedList<>() ;

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      Map<String, Object> resultMap = importExcel(filePath + File.separator + fileList[fileListLength], record) ;

      resultMessage += resultMap.get(MESSAGE) ;
      if (null != resultMap.get(RESULT_List))
        importSuccessList.add((Record) resultMap.get(RESULT_List)) ;
    }

    Map<String, Object> resultMap = new HashMap<String, Object>() ;
    resultMap.put(MESSAGE, resultMessage) ;
    resultMap.put(RESULT_List, importSuccessList) ;

    return resultMap ;
  }

  @Override
  public Map<String, Object> importXml(String path, String[] fileList, Record object)
  {
    throw new UnsupportedOperationException() ;
  }

  protected void exportExcelSheet(Workbook workbook, Sheet writeSheet, Record record)
  {
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
    Row row = writeSheet.getRow(1) ;

    // ��ID
    Cell cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordId()) ;

    // ����
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordDesc()) ;

    // ��/���
    cell = row.getCell(8) ;

    String value = record.getRecordId() ;
    if (value.endsWith("_I"))
      value = "�Է�" ;
    else if (value.endsWith("_O"))
      value = "���" ;
    else
      value = StringUtils.EMPTY ;

    cell.setCellValue(value) ;

    // ������
    cell = row.getCell(10) ;

    if (record.getRecordType() == Record.TYPE_HEADER)
      value = MetaConstants.EXCEL_HEADER ;
    else if (record.getRecordType() == Record.TYPE_REFER)
      value = MetaConstants.EXCEL_REFER ;
    else
      value = MetaConstants.EXCEL_INDIVI ;

    cell.setCellValue(value) ;

    // �� �̸�
    cell = row.getCell(12) ;
    cell.setCellValue(record.getRecordName()) ;

    // ���� 3��° �� �� ����
    row = writeSheet.getRow(2) ;

    // �׷�
    cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordGroup()) ;

    // ����
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getPrivilegeId()) ;

    // �ɼ�
    cell = row.getCell(5) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordOptions()) ;

    // ��������
    cell = row.getCell(10) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(new Character(record.getPrivateYn()).toString()) ;

    // �ۼ���
    cell = row.getCell(14) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getUpdateUserId()) ;

    // �ۼ���
    cell = row.getCell(17) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(null != record.getUpdateTimestamp() ? record.getUpdateTimestamp() : new Date(System.currentTimeMillis()) )) ;

    exportExcelSheetRows(workbook, writeSheet, record, 4, 0) ;
  }

  //
  /**
   * �� �ʵ� ���� ����
   * 
   * @param Workbook
   *          workbook �������� �� ���� workbook
   * @param Sheet
   *          writeSheet �������� �� ���� ��Ʈ
   * @param Record
   *          record �������� �� record
   * @param int
   *          index �� �ʵ������� �Էµ� ������ row ��ȣ (4)
   * @param int
   *          depth Level (������ 0)
   * @return
   * @author jkh, 2020. 3. 4.
   */
  protected int exportExcelSheetRows(Workbook workbook, Sheet writeSheet, Record record, int index, int depth)
  {
    Row row ;
    Cell cell ;

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

    for (Field currentField : record.getFields())
    {
      // FIELD_LEVEL
      row = writeSheet.createRow(index) ;
      cell = row.createCell(0) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Integer.toString(depth)) ;

      // �ʵ� ID
      String value = currentField.getPk().getFieldId() ;
      for (int j = 0 ; j < depth ; j++)
        value = "   " + value ;
      cell = row.createCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // FIELD_NAME
      cell = row.createCell(2) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getFieldName()) ;

      // INDEX_FIELD_ID
      cell = row.createCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getFieldIndex()) ;

      // FIELD_TYPE
      cell = row.createCell(4) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(MetaConstants.FIELD_TYPES.get(currentField.getFieldType())) ;

      // FIELD_LENGTH
      cell = row.createCell(5) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Integer.toString(currentField.getFieldLength())) ;

      // FIELD_SCALE
      cell = row.createCell(6) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Integer.toString(currentField.getFieldScale())) ;

      // ARRAY_TYPE
      cell = row.createCell(7) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(MetaConstants.FIELD_ARRAYTYPES.get(currentField.getArrayType())) ;

      // Reference_FIELD_ID
      cell = row.createCell(8) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getReferenceFieldId()) ;

      // FIELD_DEFAULT_VALUE
      cell = row.createCell(9) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getFieldDefaultValue()) ;

      // FIELD_HIDDEN_YN
      cell = row.createCell(10) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Character.toString(currentField.getFieldHiddenYn())) ;

      // FIELD_REQUIRE YN
      cell = row.createCell(11) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Character.toString(currentField.getFieldRequireYn())) ;

      // FIELD_VALID_VALUE
      cell = row.createCell(12) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getFieldValidValue()) ;

      // FIELD_CODEC_ID
      cell = row.createCell(13) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getCodecId()) ;

      // Options
      cell = row.createCell(14) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(currentField.getFieldOptions()) ;

      if (currentField.getFieldType() == Field.TYPE_RECORD && currentField.getSubRecordId() != null)
      {
        Record subRecord = currentField.getRecordObject() ;

        // RECORD_OPTION
        cell.setCellValue(subRecord.getRecordOptions()) ;

        index++ ;

        if (subRecord.getRecordType() == Record.TYPE_EMBED)
          index = exportExcelSheetRows(workbook, writeSheet, subRecord, index, depth + 1) ;
        else
        {
          cell = row.createCell(15) ;
          cell.setCellStyle(cellStyle) ;
          cell.setCellValue("Y") ;

          // SUB_RECORD_ID
          cell = row.createCell(16) ;
          cell.setCellStyle(cellStyle) ;
          cell.setCellValue(currentField.getSubRecordId()) ;
        }
      }
      else
        index++ ;
    }

    return index ;
  }

  /**
   * json ���� ��������
   * 
   * @param String
   *          path ��� ���� ���ϸ�
   * @return String ��� �޽���
   * @author jkh, 2020. 3. 6.
   */
  protected Map<String, Object> importJson(String filePath, Record record)
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

    try
    {
      Record jsonRecord ;
      try (FileInputStream fileInputStream = new FileInputStream(path))
      {
        jsonRecord = JsonMarshaller.unmarshal(IOUtils.toByteArray(fileInputStream), Record.class) ;
      }

      if (record == null)
      {
        ResponseObject<Record> responseObject ;
        try
        {
          // �� ���� ������ ���� update / insert �� ������ ó��
          responseObject = ClientManager.getInstance().getIManagerClient().update(jsonRecord) ;
        }
        catch (Exception e)
        {
          responseObject = ClientManager.getInstance().getIManagerClient().insert(jsonRecord) ;
        }

        if (null != responseObject.getIManagerException())
        {
          String errorMessage = StringUtils.EMPTY ;

          for (Field field : responseObject.getObject().getFields())
          {
            if (null == field.getValidateMessage())
              continue ;

            errorMessage = errorMessage + field.getValidateMessage() + "\n" ;
          }

          throw new Exception(errorMessage) ;
        }

        record = jsonRecord ;
      }
      else
      {
        record.setFields(jsonRecord.getFields()) ;
        record.setOptions(jsonRecord.getOptions()) ;
      }
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
        resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, t.getMessage())) ;
        return resultMap ;
      }
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_List, record) ;

    return resultMap ;
  }

  /**
   * �� �⺻ ���� ����
   * 
   * @param String
   *          path ��θ� ������ ���� ��
   * @return
   * @author jkh, 2020. 3. 6.
   */
  protected Map<String, Object> importExcel(String filePath, Record record)
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

    Workbook readBook = null ;
    try
    {
      readBook = WorkbookFactory.create(new File(path), null, true) ;

      Record excelRecord = importExcelSheet(readBook, readBook.getSheetAt(0), record) ;
      if (record == null)
      {
        ResponseObject<Record> responseObject ;
        try
        {
          // �� ���� ������ ���� update / insert �� ������ ó��
          responseObject = ClientManager.getInstance().getIManagerClient().update(excelRecord) ;
        }
        catch (Exception e)
        {
          responseObject = ClientManager.getInstance().getIManagerClient().insert(excelRecord) ;
        }

        if (null != responseObject.getIManagerException())
        {
          String errorMessage = StringUtils.EMPTY ;

          for (Field field : responseObject.getObject().getFields())
          {
            if (null == field.getValidateMessage())
              continue ;

            errorMessage = errorMessage + field.getValidateMessage() + "\n" ;
          }

          throw new Exception(errorMessage) ;
        }

        record = excelRecord ;
      }
    }
    catch (Throwable t)
    {
      resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, t.getMessage())) ;

      return resultMap ;
    }
    finally
    {
      if (null != readBook)
        try
        {
          readBook.close() ;
        }
        catch (Throwable t)
        {
          resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, t.getMessage())) ;
          return resultMap ;
        }

      try
      {
        decryption(path, false) ;
      }
      catch (Throwable t)
      {
        resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, t.getMessage())) ;
        return resultMap ;
      }
    }

    resultMap.put(MESSAGE, String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS)) ;
    resultMap.put(RESULT_List, record) ;

    return resultMap ;
  }

  protected Record importExcelSheet(Workbook readBook, Sheet readSheet, Record record) throws Exception
  {
    if (!Objects.equals("Data_Model", readSheet.getSheetName()))
      throw new Exception(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE1) ;

    Row row ;
    Cell cell ;

    if (record == null)
    {
      record = new Record() ;

      // ���� 2��° �� �� ��������
      row = readSheet.getRow(1) ;

      // ID
      cell = row.getCell(1) ;
      record.setRecordId(getStringNumericValue(cell)) ;

      // ����
      cell = row.getCell(3) ;
      record.setRecordDesc(getStringNumericValue(cell)) ;

      // ������
      cell = row.getCell(10) ;
      switch (getStringNumericValue(cell))
      {
      case MetaConstants.EXCEL_HEADER :
        record.setRecordType(Record.TYPE_HEADER) ;
        break ;

      case MetaConstants.EXCEL_REFER :
        record.setRecordType(Record.TYPE_REFER) ;
        break ;

      default :
        record.setRecordType(Record.TYPE_INDIVI) ;
      }

      // ���̸�
      cell = row.getCell(12) ;
      record.setRecordName(getStringNumericValue(cell)) ;

      // ���� 3��° �� �� ��������
      row = readSheet.getRow(2) ;

      // �׷�
      cell = row.getCell(1) ;
      record.setRecordGroup(getStringNumericValue(cell)) ;

      // ����ID
      cell = row.getCell(3) ;
      record.setPrivilegeId(getStringNumericValue(cell)) ;

      // �ɼ�
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;

      // ��������
      cell = row.getCell(10) ;
      record.setPrivateYn(getStringNumericValue(cell).charAt(0)) ;

      // �ۼ���
      cell = row.getCell(14) ;
      record.setUpdateUserId(getStringNumericValue(cell)) ;

      importExcelSheetRows(readSheet, record, 4, 0) ;
    }
    else
    {
      row = readSheet.getRow(2) ;

      // �ɼ�
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;

      importExcelSheetRows(readSheet, record, 4, 0) ;
    }

    return record ;
  }

  /**
   * �� �ʵ����� ����
   * 
   * @param Sheet
   *          readSheet ���� Data_Model ��Ʈ
   * @param Record
   *          record ���� ������ ���� Record
   * @param int
   *          index ���� �� �ʵ������� �����ϴ� �� ��ȣ (4)
   * @return
   * @throws Exception
   * @author jkh, 2020. 3. 6.
   */
  protected int importExcelSheetRows(Sheet readSheet, Record record, int index, int depth) throws Exception
  {
    Row row ;
    Cell cell ;
    Field field ;
    LinkedList<Field> filedList = new LinkedList<>() ;
    Set<String> idList = new TreeSet<>() ;
    int nVal ;

    while (true)
    {
      row = readSheet.getRow(index) ;
      if (null == row || getStringNumericValue(row.getCell(1)).isEmpty())
        break ;

      // �ʵ尡 �ִ� ���, Level ��������
      cell = row.getCell(0) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;

      if (depth < nVal) // ���� �ʵ��� Level < ���� �ʵ��� Level
      {
        index = importExcelSheetRows(readSheet, filedList.getLast().getRecordObject(), index, nVal) ;

        continue ;
      }
      else if (depth > nVal) // �ռ� �ʵ��� Level > ���� �ʵ��� Level
        break ;

      field = new Field() ;
      field.setPk(new FieldPK()) ;
      field.setRecord(record) ;

      // �ʵ� ID
      cell = row.getCell(1) ;
      field.getPk().setFieldId(getStringNumericValue(cell).trim()) ;

      if (idList.contains(field.getPk().getFieldId()))
        throw new Exception(NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8, field.getPk().getFieldId())) ;
      else
        idList.add(field.getPk().getFieldId()) ;

      // �ʵ� ��
      cell = row.getCell(2) ;
      field.setFieldName(getStringNumericValue(cell)) ;

      // �ʵ� Index
      cell = row.getCell(3) ;
      field.setFieldIndex(getStringNumericValue(cell)) ;

      // �ʵ� Ÿ�� (������Ʈ��)
      cell = row.getCell(4) ;
      field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

      // �ʵ� ����
      cell = row.getCell(5) ;
      field.setFieldLength(Integer.parseInt(getStringNumericValue(cell))) ;

      // �ʵ� �Ҽ�
      cell = row.getCell(6) ;
      field.setFieldScale(Integer.parseInt(getStringNumericValue(cell))) ;

      // �ݺ�Ÿ�� (�迭����)
      cell = row.getCell(7) ;
      field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

      // ���� �ʵ� ID (�ݺ�Ƚ��)
      cell = row.getCell(8) ;
      field.setReferenceFieldId(getStringNumericValue(cell)) ;

      // �ʵ� �⺻��
      cell = row.getCell(9) ;
      field.setFieldDefaultValue(getStringNumericValue(cell)) ;

      // ��������� (����ŷ����)
      cell = row.getCell(10) ;
      field.setFieldHiddenYn(getStringNumericValue(cell).charAt(0)) ;

      // �ʼ�����
      cell = row.getCell(11) ;
      field.setFieldRequireYn(getStringNumericValue(cell).charAt(0)) ;

      // ��ȿ��
      cell = row.getCell(12) ;
      field.setFieldValidValue(getStringNumericValue(cell)) ;

      // ��ȯ
      cell = row.getCell(13) ;
      field.setCodecId(getStringNumericValue(cell)) ;

      // ��Ÿ�Ӽ�
      cell = row.getCell(14) ;
      field.setFieldOptions(getStringNumericValue(cell)) ;

      if (field.getFieldType() == Field.TYPE_RECORD)
      {
        Record subRecord = new Record() ;

        // ��������
        cell = row.getCell(15) ;
        if (Objects.equals("Y", getStringNumericValue(cell)))
        {
          String recordID = getStringNumericValue(row.getCell(16)) ;
          subRecord.setRecordId(recordID) ;

          try
          {
            subRecord = ClientManager.getInstance().getIManagerClient().get(subRecord).getObject() ;
          }
          catch (Exception e)
          {
            throw new Exception(NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE9, subRecord.getRecordId())) ;
          }

          subRecord.setRecordType(Record.TYPE_REFER) ;
          field.setSubRecordId(recordID) ;
        }
        else
          subRecord.setRecordType(Record.TYPE_EMBED) ;

        field.setRecordObject(subRecord) ;
      }

      filedList.add(field) ;

      index++ ;
    }

    record.setFields(filedList) ;

    return index ;
  }

  /**
   * ������ ����ȯ String > Numeric
   * 
   * @param cell
   * @return
   * @author jkh, 2021. 1. 27.
   */
  protected String getStringNumericValue(Cell cell)
  {
    if (cell != null)
      try
      {
        return cell.getStringCellValue() ;
      }
      catch (IllegalStateException e)
      {
        return Integer.toString((int) cell.getNumericCellValue()) ;
      }

    return StringUtils.EMPTY ;
  }
}
