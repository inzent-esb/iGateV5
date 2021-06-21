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
 * <code>RecordExportHandlerImpl</code> 이곳에 클래스 설명을 기술하세요
 *
 * @since 2021. 2. 8.
 * @version 5.0
 * @author Jaesuk Byon
 * @see 참조 대상 클래스를 입력하시고 없을경우 지워주세요
 */
public class RecordExportHandlerImpl implements RecordExportHandler
{
  public int importSuccessRecordCount, importTotalRecordCount ;
  /**
   * 생성자에 대한 설명을 기술하세요
   */
  public RecordExportHandlerImpl()
  {
    // TODO Auto-generated constructor stub
  }

  /**
   * 이곳에 메소드 설명을 기술하세요
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
    
    //======= 내보내기 처리 가능 타입 별로 처리  =======     
    // 엔티티 타입별 export 할 경로
    HashMap<String, String> exportTypePathMap =  new HashMap<String, String>();
    // 엔티이 타입별 export 할 파일의 타입 ( [ ex ] Record : (1)json/ (2)excel , Operation : (1)xml ) 
    HashMap<String, Integer> exportFileTypeMap =  new HashMap<String, Integer>();
    // Browse(저장경로)
    BatchExportDialog dialog = new BatchExportDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell()) ;
    // entity 타입 정보 넘김
    
    dialog.setEntityType(entityType);
    dialog.open() ;
    int fileTpye = dialog.getFileType() ;
    String selectedPath = dialog.getDirectoryPath() ;

    
    if(selectedPath != null)
    {
      exportTypePathMap.put(entityType, selectedPath);
      exportFileTypeMap.put(entityType, fileTpye);
    }
    
    //경로를 지정하지 않은 경우 종료 
    if(exportTypePathMap.size()==0)
      return;
    
    String resulTotaltMessage = StringUtils.EMPTY ;
    String resulRecordtMessage = StringUtils.EMPTY ;
    
    boolean recordTitlePath = false ;
    
    // Record 인 경우,
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

        // JSON 인 경우,
        if (fileTpye == 1)
          resulRecordtMessage += exportJson(selectedPath, record) ;

        // Excel 인 경우,
        else if (fileTpye == 2)
          resulRecordtMessage += exportExcel(selectedPath, record) ;
      }
      
      //결과 메시지 조립
      resulTotaltMessage = StringUtils.EMPTY ;
      if(!resulRecordtMessage.equals(StringUtils.EMPTY))
      {
        //export 갯수 
        if(importTotalRecordCount >0) 
          resulRecordtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, importTotalRecordCount, importSuccessRecordCount, importTotalRecordCount-importSuccessRecordCount );
        
        resulTotaltMessage += resulRecordtMessage;
      }
      
      //내보내기 결과 목록 & 내보내기로 저장한 파일의 상위 폴더를 열겠습니까? 확인 메시지 창 
      //if(StringUtils.contains(System.getProperty("os.name").toLowerCase(), "windows"))  //윈도우 확인
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
   * @param String path     저장 위치
   * @param Record record   view 에서 선택한 record
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
   * json 파일 생성
   * @param String path     경로 포함 파일명
   * @param Record record   내보낼 Record
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
   * @param String path     저장 위치
   * @param Record record   view 에서 선택한 record
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
   * 엑셀 템플릿 로드 후 모델 필드 내용 생성
   * @param String path     경로포함 파일명
   * @param Record record   내보낼 Record
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
      // 모델ID
      value = record.getRecordId() ;
      row = writeSheet.getRow(1) ;
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // 설명
      value = record.getRecordDesc() ;
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      // 입/출력
      value = record.getRecordId() ;
      if (value.endsWith("_I")) 
        value = "입력" ; 
      else if (value.endsWith("_O")) 
        value = "출력" ; 
      else
        value = "" ; 

      cell = row.getCell(8) ;
      cell.setCellValue(value) ;

      // 모델유형
      if (record.getRecordType() == Record.TYPE_HEADER)
        value = MetaConstants.EXCEL_HEADER ;
      else if (record.getRecordType() == Record.TYPE_REFER)
        value = MetaConstants.EXCEL_REFER ;
      else
        value = MetaConstants.EXCEL_INDIVI ;

      cell = row.getCell(10) ;
      cell.setCellValue(value) ;
      
      //모델 이름
      value = record.getRecordName() ;
      cell = row.getCell(12) ;
      cell.setCellValue(value) ;
      
      // 엑셀 3번째 줄 값 설정
      // 그룹
      value = record.getRecordGroup() ;
      row = writeSheet.getRow(2) ;
      
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // 권한
      value = record.getPrivilegeId() ;
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // 옵션
      value = record.getRecordOptions() ;
      cell = row.getCell(5) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // 개별부 경로
//      value = record.getIndividualPath() ;
//      cell = row.getCell(8) ;
//      cell.setCellStyle(cellStyle) ;
//      cell.setCellValue(value) ;

      // 전문공유
      if (record.getPrivateYn() == 'Y')
        value = "Y" ; 
      else
        value = "N" ; 

      cell = row.getCell(10) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // 작성자
      value = record.getUpdateUserId() ;
      cell = row.getCell(14) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;

      // 작성일
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
   * 모델 필드 정보 생성
   * @param Workbook workbook   내보내기 할 엑셀 workbook
   * @param Sheet writeSheet    내보내기 할 엑셀 시트
   * @param Record record       내보내기 할 record
   * @param int index           모델 필드정보가 입력될 엑셀의 row 번호 (4)
   * @param int depth           Level (시작은 0)
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

      // 필드 ID
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
