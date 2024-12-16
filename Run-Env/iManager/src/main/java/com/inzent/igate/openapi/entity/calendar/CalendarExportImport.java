package com.inzent.igate.openapi.entity.calendar ;

import java.io.FileInputStream ;
import java.io.IOException ;
import java.io.OutputStream ;
import java.text.DecimalFormat ;
import java.util.Iterator ;
import java.util.LinkedList ;
import java.util.List ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.io.FilenameUtils ;
import org.apache.poi.hssf.usermodel.HSSFWorkbook ;
import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.CellStyle ;
import org.apache.poi.ss.usermodel.CellType ;
import org.apache.poi.ss.usermodel.Font ;
import org.apache.poi.ss.usermodel.HorizontalAlignment ;
import org.apache.poi.ss.usermodel.IndexedColors ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.VerticalAlignment ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.apache.poi.xssf.usermodel.XSSFCellStyle ;
import org.apache.poi.xssf.usermodel.XSSFWorkbook ;
import org.springframework.stereotype.Component ;
import org.springframework.web.multipart.MultipartFile ;

import com.inzent.igate.imanager.EntityListExportImportBean ;
import com.inzent.igate.repository.meta.Calendar ;
import com.inzent.igate.repository.meta.CalendarHoliday ;
import com.inzent.igate.repository.meta.CalendarHolidayPK ;

@Component
public class CalendarExportImport implements EntityListExportImportBean<Calendar> 
{
  static String regex = "^[a-zA-Z0-9_]*$" ; // ID 체크 정규식 
  static String pattern = "^[0-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$" ; // 휴일 일자 체크 정규식

  @Override
  public void exportList(HttpServletRequest request, HttpServletResponse response, Calendar entity, List<Calendar> list) throws Exception
  {
    // 사용할 엑셀 템플릿 지정
    generateDownload(response, request.getServletContext().getRealPath("/template/List_Calendar.xlsx"), entity, list) ;
    
    response.flushBuffer() ;
  }

  @Override
  public void exportObject(HttpServletRequest request, HttpServletResponse response, Calendar entity) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public Calendar importObject(MultipartFile multipartFile) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public List<Calendar> importObjects(MultipartFile multipartFile) throws Exception
  {
    List<Calendar> result = new LinkedList<Calendar>() ;

    String extension = FilenameUtils.getExtension(multipartFile.getOriginalFilename()) ;
    if (!extension.equals("xlsx") && !extension.equals("xls"))
    {
      throw new IOException("!!" + extension) ;
    }

    Workbook workbook = null ;

    // 확장자가 xlsx 인지 xls 인지 구분
    if (extension.equals("xlsx"))
    {
      workbook = new XSSFWorkbook(multipartFile.getInputStream()) ;
    }
    else if (extension.equals("xls"))
    {
      workbook = new HSSFWorkbook(multipartFile.getInputStream()) ;
    }

    Sheet worksheet = workbook.getSheetAt(0) ;

    int rows = worksheet.getPhysicalNumberOfRows() ;

    for (int rowindex = 2 ; rowindex < rows ; rowindex++)
    {
      Boolean flag = true ;

      Row row = worksheet.getRow(rowindex) ;
      
      Cell cell ;
      cell = row.getCell(0) ;
      
      if(cell.getCellType() == CellType.BLANK) // cell의 Type 이 BLANK 라면 값이 없는 것으로 판단 
        return result ;

      Calendar calendar = null ;
      String calendarId = "" ;
      List<CalendarHoliday> holidayList = null ;
      
      // 휴일 ID
      cell = row.getCell(0) ;
      calendarId = getCellvalue(cell) ;
      if(calendarId.matches(regex) == false ) // ID 체크 정규식
        throw new Exception() ;

      Iterator<Calendar> it = result.iterator() ;
      while (it.hasNext())
      {
        Calendar resultCalendar = it.next() ;
        if (resultCalendar.getCalendarId().equals(calendarId))
        {
          calendar = resultCalendar ;
          holidayList = calendar.getCalendarHoliday() ;
          flag = false ;
          break ;
        }
      }

      if (flag)
      {
        calendar = new Calendar() ;
        calendar.setCalendarId(calendarId) ;
        holidayList = new LinkedList<>() ;

        // 휴일 이름
        calendar.setCalendarName(getCellvalue(row.getCell(1))) ;

        // 휴일 비고
        calendar.setCalendarDesc(getCellvalue(row.getCell(2))) ;

        // 토요일 휴일 유무
        calendar.setSaturdayYn(row.getCell(3).getStringCellValue().toUpperCase().charAt(0)) ; // 대소문자 구분하지 않고 받은후 대문자로 모두 바꾼후 저장 

        // 일요일 휴일 유무
        calendar.setSundayYn(row.getCell(4).getStringCellValue().toUpperCase().charAt(0)) ;
      }

      // 휴일 일자
      CalendarHoliday holiday = getHoliday(row.getCell(5)) ;

      if (holiday != null )
      {
        // 휴일 일자 설명
        holiday.setHolidayDesc(getCellvalue(row.getCell(6))) ;
        holiday.getPk().setCalendarId(calendar.getCalendarId()) ;
        holidayList.add(holiday) ;
      }


      if (flag)
      {
        calendar.setCalendarHoliday(holidayList) ;
        result.add(calendar) ;
      }
    }
    return result ;
  }
  
  public static String getCellvalue(Cell cell) {
    if(cell == null)
      return "" ;

    switch (cell.getCellType())
    {
    case STRING :
    case BLANK :
      return cell.getStringCellValue() ;
    case NUMERIC :
      return new DecimalFormat("###.#####").format(cell.getNumericCellValue()) ;
    default:
      break ;
    }
    return "";
  }

  public static CalendarHoliday getHoliday(Cell cell ) throws Exception {
    CalendarHolidayPK holidayPk = new CalendarHolidayPK() ;
    CalendarHoliday holiday = new CalendarHoliday() ;

    if(cell == null)
      return null ;
    
    switch (cell.getCellType()) {
    case STRING :
      if(cell.getStringCellValue().matches(pattern) == false ) // 휴일 일자 체크 정규식 
          throw new Exception() ;
      holidayPk.setHolidayDate(cell.getStringCellValue()) ;
      holiday.setPk(holidayPk) ;
      return holiday ;

    case NUMERIC :
      if(new DecimalFormat("###.#####").format(cell.getNumericCellValue()).matches(pattern) == false)
        throw new Exception() ;
      holidayPk.setHolidayDate(new DecimalFormat("###.#####").format(cell.getNumericCellValue())) ;
      holiday.setPk(holidayPk) ;
      return holiday ;
    default :
      break ;
    }
    return null ;
  }

  public void generateDownload(HttpServletResponse response, String templateFile, Calendar entity, List<Calendar> entityList) throws Exception 
  {
      
      try(OutputStream outputStream = response.getOutputStream() ;
          FileInputStream fileInputStream = new FileInputStream(templateFile) ;
          Workbook workbook = WorkbookFactory.create(fileInputStream) ; )
      {
          Sheet writeSheet = workbook.getSheetAt(0) ;
          Row row = null ;
          Cell cell = null ;
          String calendarId = null ;
          String calendarName = null ;
          String calendarDesc = null ;
          String saturday = null ;
          String sunday = null ;
          String holidayDate = null ;
          String holidayDesc = null ;
          
          // Cell 스타일 지정.
          CellStyle cellStyle_Base = getBaseCellStyle(workbook) ;
          
          // 조회리스트 입력
          int i = 2 ; // 현재 템플릿에서는 3번째 row 부터 값이 있으므로 2로 지정 ( 해당 부분은 템플릿 디자인 수정시 수정해야할 필요가 있음 )
          List<CalendarHoliday> holidayList = new LinkedList() ;
          for (Calendar calendarInfo : entityList) 
          {
              row = writeSheet.createRow(i) ;
              int c = 0 ;
              int removeRow = 0 ; 
              
              holidayList = new LinkedList() ;
              holidayList = calendarInfo.getCalendarHoliday() ;
              
              // 휴일 ID
              calendarId = calendarInfo.getCalendarId() ;
              cell = row.createCell(c) ;
              cell.setCellStyle(cellStyle_Base) ;
              cell.setCellValue(calendarId) ;
              
              // 휴일 이름
              calendarName = calendarInfo.getCalendarName() ;
              cell = row.createCell(++c) ;
              cell.setCellStyle(cellStyle_Base) ;
              cell.setCellValue(calendarName) ;
              
              // 휴일 비고
              calendarDesc = calendarInfo.getCalendarDesc() ;
              cell = row.createCell(++c) ;
              cell.setCellStyle(cellStyle_Base) ;
              cell.setCellValue(calendarDesc) ;
              
              // 토요일 휴일
              switch (String.valueOf(calendarInfo.getSaturdayYn())) {
                  case "Y" :
                      saturday = "Yes" ;
                      break ;
                  case "N" :
                      saturday = "No" ;
                      break ;
                      
                  default:
                      break ;
              }
              
              cell = row.createCell(++c) ;
              cell.setCellStyle(cellStyle_Base) ;
              cell.setCellValue(saturday) ;
              
              // 일요일 휴일
              switch (String.valueOf(calendarInfo.getSundayYn())) {
                  case "Y" :
                      sunday = "Yes" ;
                      break ;
                  case "N" :
                      sunday = "No" ;
                      break ;
                  default :
                      break ;
              }
              
              cell = row.createCell(++c) ;
              cell.setCellStyle(cellStyle_Base) ;
              cell.setCellValue(sunday) ;
              
              // 휴일 일자 & 설명
              for (CalendarHoliday holiday : holidayList)
              {   
                  holidayDate = holiday.getPk().getHolidayDate() ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(holidayDate) ;
                  holidayDesc = holiday.getHolidayDesc() ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(holidayDesc) ;
                  
                  // 휴일 일자와 설명을 cell에 작성한후 이전에 있던 cell정보를 다시한번 입력
                  i++ ;
                  row = writeSheet.createRow(i) ;
                  c = 0 ;
                  cell = row.createCell(c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(calendarId) ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(calendarName) ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(calendarDesc) ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(saturday) ;
                  cell = row.createCell(++c) ;
                  cell.setCellStyle(cellStyle_Base) ;
                  cell.setCellValue(sunday) ;
                  
                  removeRow = 1 ; // 마지막에 cell cell 휴일 일자와 설명이 없는데 cell정보가 입력되니 해당 Row를 삭제하기 위해 1로 만듬 
              }
              
              if(removeRow != 0) // 휴일 일자와 설명이 없는 Row 를 삭제
              {
                  writeSheet.removeRow(row) ;
                  i-- ;
              }
              
              i++ ;
          }
          entityList = null ;
          workbook.write(outputStream) ;
      }
      catch (Exception e)
      {
          throw e ;
      }
  }

  public XSSFCellStyle getBaseCellStyle(Workbook workbook) {
    // Cell 스타일 지정
    XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle() ;
    
    // 텍스트 맞춤 (세로 가운데)
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;
    
    // 텍스트 맞춤 (가로 가운데)
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;
    
    // 폰트 지정 사이즈 10
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex())) ;
    
    // Cell 잠금
    cellStyle.setLocked(true) ;
    
    // Cell 에서 Text 줄바꿈 활성화
    cellStyle.setWrapText(true) ;
    
    return cellStyle ;
  }

  public Font getBaseFont(Workbook workbook, int size, short color) {
    // 폰트
    Font font = workbook.createFont() ;
    font.setFontHeight((short) (20 * size)) ;
    font.setFontName("굴림") ;
    font.setColor(color) ;
    
    return font ;
  }

}
