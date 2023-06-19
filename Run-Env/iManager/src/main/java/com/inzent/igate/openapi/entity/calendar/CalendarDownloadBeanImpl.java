package com.inzent.igate.openapi.entity.calendar ;

import java.io.FileInputStream ;
import java.io.OutputStream ;
import java.util.LinkedList ;
import java.util.List ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.CellStyle ;
import org.apache.poi.ss.usermodel.FillPatternType ;
import org.apache.poi.ss.usermodel.Font ;
import org.apache.poi.ss.usermodel.HorizontalAlignment ;
import org.apache.poi.ss.usermodel.IndexedColors ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.VerticalAlignment ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.apache.poi.xssf.usermodel.XSSFCellStyle ;
import org.apache.poi.xssf.usermodel.XSSFColor ;
import org.apache.poi.xssf.usermodel.XSSFWorkbook ;
import org.springframework.stereotype.Component ;

import com.inzent.igate.repository.meta.Calendar ;
import com.inzent.igate.repository.meta.CalendarHoliday ;
import com.inzent.imanager.message.MessageGenerator ;

@Component
public class CalendarDownloadBeanImpl implements CalendarDownloadBean{

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, Calendar entity, List<Calendar> entityList) throws Exception 
	{
		// 사용할 엑셀 템플릿 지정
		generateDownload(response, request.getServletContext().getRealPath("/template/List_Calendar.xlsx"), entity, entityList) ;
		
		response.flushBuffer() ;
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
	
	public Object[] generateTemplete()
	{
		/* 템플릿을 불러오지 못할 경우
		 * 임시로 사용할 엑셀 구성 */
		Workbook workbook = new XSSFWorkbook() ;
		Sheet writeSheet = workbook.createSheet() ;
		Row row = writeSheet.createRow(3) ;
		Cell cell ;
		
		cell = row.createCell(1) ;
		cell.setCellValue(MessageGenerator.getMessage("head.id", "Id")) ;
		cell.getRow().createCell(1) ;
		cell.setCellValue(MessageGenerator.getMessage("head.name", "Name")) ;
		cell = row.createCell(2) ;
		cell.setCellValue(MessageGenerator.getMessage("common.desc", "Description")) ;
		cell = row.createCell(3) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.saturday", "Saturday YN")) ;
		cell = row.createCell(4) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.sunday", "Sunday YN")) ;
		cell = row.createCell(5) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.date", "Calendar Date")) ;
		cell = row.createCell(6) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.date.desc", "Calendar Date Description")) ;
		
		row = writeSheet.createRow(2) ;
		cell = row.createCell(0) ;
		cell.setCellValue(MessageGenerator.getMessage("head.id", "Id")) ;
		cell.getRow().createCell(1) ;
		cell.setCellValue(MessageGenerator.getMessage("head.name", "Name")) ;
		cell.getRow().createCell(2) ;
		cell.setCellValue(MessageGenerator.getMessage("common.desc", "Description")) ;
		cell.getRow().createCell(3) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.saturday", "Saturday YN")) ;
		cell.getRow().createCell(4) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.sunday", "Sunday YN")) ;
		cell.getRow().createCell(5) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.date", "Calendar Date")) ;
		cell.getRow().createCell(6) ;
		cell.setCellValue(MessageGenerator.getMessage("igate.calendar.date.desc", "Calendar Date Description")) ;


		/* Create Base Excel Template */
		
		return new Object[] {
				workbook, writeSheet, row, cell
		} ;
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
	
	public XSSFCellStyle getInfoCellStyle(Workbook workbook) {
		XSSFCellStyle cellStyle = getBaseCellStyle(workbook) ;
		cellStyle.setAlignment(HorizontalAlignment.CENTER) ;
		
		// 폰트 지정 사이즈 (굵게)
		Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()) ;
		font.setBold(true) ;
		cellStyle.setFont(font) ;
		
		cellStyle.setFillForegroundColor(new XSSFColor(new byte[] { (byte) 242, (byte) 242, (byte) 242 }, null)) ;
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND) ;
		
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
