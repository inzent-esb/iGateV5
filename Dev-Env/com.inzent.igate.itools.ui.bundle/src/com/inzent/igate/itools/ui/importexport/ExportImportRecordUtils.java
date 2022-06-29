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
   *          path 저장 위치
   * @param Record
   *          record view 에서 선택한 record
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
   *          path 저장 위치
   * @param Record
   *          record view 에서 선택한 record
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
   * json 파일 가져오기
   * 
   * @param String
   *          filePath 가져올 파일 경로
   * @param String[]
   *          fileList 가져올 파일 목록
   * @return String 결과 메시지
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
   * 엑셀파일을 가져오기
   * 
   * @param String
   *          filePath 파일 경로
   * @param String
   *          fileList 가져올 파일 목록
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
    // Cell 스타일 지정.
    CellStyle cellStyle = workbook.createCellStyle() ;
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;// 텍스트 맞춤(세로가운데)
    cellStyle.setAlignment(HorizontalAlignment.LEFT) ;// 텍스트 맞춤 (가로 왼쪽)

    Font font = workbook.createFont() ;// 폰트
    font.setFontHeight((short) 180) ;
    font.setFontName("굴림") ;
    cellStyle.setFont(font) ;

    cellStyle.setBorderBottom(BorderStyle.HAIR) ;// Cell 테두리 (점선)
    cellStyle.setBorderLeft(BorderStyle.HAIR) ;
    cellStyle.setBorderRight(BorderStyle.HAIR) ;
    cellStyle.setBorderTop(BorderStyle.HAIR) ;

    cellStyle.setLocked(true) ; // Cell 잠금
    cellStyle.setWrapText(true) ; // Cell 에서 Text 줄바꿈 활성화

    // 엑셀 2번째 줄 값 설정
    Row row = writeSheet.getRow(1) ;

    // 모델ID
    Cell cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordId()) ;

    // 설명
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordDesc()) ;

    // 입/출력
    cell = row.getCell(8) ;

    String value = record.getRecordId() ;
    if (value.endsWith("_I"))
      value = "입력" ;
    else if (value.endsWith("_O"))
      value = "출력" ;
    else
      value = StringUtils.EMPTY ;

    cell.setCellValue(value) ;

    // 모델유형
    cell = row.getCell(10) ;

    if (record.getRecordType() == Record.TYPE_HEADER)
      value = MetaConstants.EXCEL_HEADER ;
    else if (record.getRecordType() == Record.TYPE_REFER)
      value = MetaConstants.EXCEL_REFER ;
    else
      value = MetaConstants.EXCEL_INDIVI ;

    cell.setCellValue(value) ;

    // 모델 이름
    cell = row.getCell(12) ;
    cell.setCellValue(record.getRecordName()) ;

    // 엑셀 3번째 줄 값 설정
    row = writeSheet.getRow(2) ;

    // 그룹
    cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordGroup()) ;

    // 권한
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getPrivilegeId()) ;

    // 옵션
    cell = row.getCell(5) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getRecordOptions()) ;

    // 전문공유
    cell = row.getCell(10) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(new Character(record.getPrivateYn()).toString()) ;

    // 작성자
    cell = row.getCell(14) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(record.getUpdateUserId()) ;

    // 작성일
    cell = row.getCell(17) ;
    cell.setCellStyle(cellStyle) ;
    cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(null != record.getUpdateTimestamp() ? record.getUpdateTimestamp() : new Date(System.currentTimeMillis()) )) ;

    exportExcelSheetRows(workbook, writeSheet, record, 4, 0) ;
  }

  //
  /**
   * 모델 필드 정보 생성
   * 
   * @param Workbook
   *          workbook 내보내기 할 엑셀 workbook
   * @param Sheet
   *          writeSheet 내보내기 할 엑셀 시트
   * @param Record
   *          record 내보내기 할 record
   * @param int
   *          index 모델 필드정보가 입력될 엑셀의 row 번호 (4)
   * @param int
   *          depth Level (시작은 0)
   * @return
   * @author jkh, 2020. 3. 4.
   */
  protected int exportExcelSheetRows(Workbook workbook, Sheet writeSheet, Record record, int index, int depth)
  {
    Row row ;
    Cell cell ;

    // Cell 스타일 지정.
    CellStyle cellStyle = workbook.createCellStyle() ;
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;// 텍스트 맞춤(세로 가운데)
    cellStyle.setAlignment(HorizontalAlignment.LEFT) ;// 텍스트 맞춤 (가로 왼쪽)

    Font font = workbook.createFont() ;// 폰트
    font.setFontHeight((short) 180) ;
    font.setFontName("굴림") ;
    font.setBold(false) ;
    cellStyle.setFont(font) ;

    cellStyle.setBorderBottom(BorderStyle.HAIR) ;// Cell 테두리 (점선)
    cellStyle.setBorderLeft(BorderStyle.HAIR) ;
    cellStyle.setBorderRight(BorderStyle.HAIR) ;
    cellStyle.setBorderTop(BorderStyle.HAIR) ;

    cellStyle.setLocked(true) ;// Cell 잠금

    for (Field currentField : record.getFields())
    {
      // FIELD_LEVEL
      row = writeSheet.createRow(index) ;
      cell = row.createCell(0) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(Integer.toString(depth)) ;

      // 필드 ID
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
   * json 파일 가져오기
   * 
   * @param String
   *          path 경로 포함 파일명
   * @return String 결과 메시지
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
          // 모델 존재 유무에 따라 update / insert 로 나눠서 처리
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
   * 모델 기본 정보 설정
   * 
   * @param String
   *          path 경로를 포함한 파일 명
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
          // 모델 존재 유무에 따라 update / insert 로 나눠서 처리
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

      // 엑셀 2번째 줄 값 가져오기
      row = readSheet.getRow(1) ;

      // ID
      cell = row.getCell(1) ;
      record.setRecordId(getStringNumericValue(cell)) ;

      // 설명
      cell = row.getCell(3) ;
      record.setRecordDesc(getStringNumericValue(cell)) ;

      // 모델유형
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

      // 모델이름
      cell = row.getCell(12) ;
      record.setRecordName(getStringNumericValue(cell)) ;

      // 엑셀 3번째 줄 값 가져오기
      row = readSheet.getRow(2) ;

      // 그룹
      cell = row.getCell(1) ;
      record.setRecordGroup(getStringNumericValue(cell)) ;

      // 권한ID
      cell = row.getCell(3) ;
      record.setPrivilegeId(getStringNumericValue(cell)) ;

      // 옵션
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;

      // 전문공유
      cell = row.getCell(10) ;
      record.setPrivateYn(getStringNumericValue(cell).charAt(0)) ;

      // 작성자
      cell = row.getCell(14) ;
      record.setUpdateUserId(getStringNumericValue(cell)) ;

      importExcelSheetRows(readSheet, record, 4, 0) ;
    }
    else
    {
      row = readSheet.getRow(2) ;

      // 옵션
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;

      importExcelSheetRows(readSheet, record, 4, 0) ;
    }

    return record ;
  }

  /**
   * 모델 필드정보 설정
   * 
   * @param Sheet
   *          readSheet 엑셀 Data_Model 시트
   * @param Record
   *          record 엑셀 내용을 담을 Record
   * @param int
   *          index 엑셀 모델 필드정보가 시작하는 줄 번호 (4)
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

      // 필드가 있는 경우, Level 가져오기
      cell = row.getCell(0) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;

      if (depth < nVal) // 윗줄 필드의 Level < 현재 필드의 Level
      {
        index = importExcelSheetRows(readSheet, filedList.getLast().getRecordObject(), index, nVal) ;

        continue ;
      }
      else if (depth > nVal) // 앞선 필드의 Level > 현재 필드의 Level
        break ;

      field = new Field() ;
      field.setPk(new FieldPK()) ;
      field.setRecord(record) ;

      // 필드 ID
      cell = row.getCell(1) ;
      field.getPk().setFieldId(getStringNumericValue(cell).trim()) ;

      if (idList.contains(field.getPk().getFieldId()))
        throw new Exception(NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8, field.getPk().getFieldId())) ;
      else
        idList.add(field.getPk().getFieldId()) ;

      // 필드 명
      cell = row.getCell(2) ;
      field.setFieldName(getStringNumericValue(cell)) ;

      // 필드 Index
      cell = row.getCell(3) ;
      field.setFieldIndex(getStringNumericValue(cell)) ;

      // 필드 타입 (오브젝트명)
      cell = row.getCell(4) ;
      field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

      // 필드 길이
      cell = row.getCell(5) ;
      field.setFieldLength(Integer.parseInt(getStringNumericValue(cell))) ;

      // 필드 소수
      cell = row.getCell(6) ;
      field.setFieldScale(Integer.parseInt(getStringNumericValue(cell))) ;

      // 반복타입 (배열형태)
      cell = row.getCell(7) ;
      field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

      // 참조 필드 ID (반복횟수)
      cell = row.getCell(8) ;
      field.setReferenceFieldId(getStringNumericValue(cell)) ;

      // 필드 기본값
      cell = row.getCell(9) ;
      field.setFieldDefaultValue(getStringNumericValue(cell)) ;

      // 비공개여부 (마스킹여부)
      cell = row.getCell(10) ;
      field.setFieldHiddenYn(getStringNumericValue(cell).charAt(0)) ;

      // 필수여부
      cell = row.getCell(11) ;
      field.setFieldRequireYn(getStringNumericValue(cell).charAt(0)) ;

      // 유효값
      cell = row.getCell(12) ;
      field.setFieldValidValue(getStringNumericValue(cell)) ;

      // 변환
      cell = row.getCell(13) ;
      field.setCodecId(getStringNumericValue(cell)) ;

      // 기타속성
      cell = row.getCell(14) ;
      field.setFieldOptions(getStringNumericValue(cell)) ;

      if (field.getFieldType() == Field.TYPE_RECORD)
      {
        Record subRecord = new Record() ;

        // 참조여부
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
   * 순자적 형변환 String > Numeric
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
