package com.inzent.igate.imanager.calendar;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.inzent.igate.repository.meta.Calendar;
import com.inzent.igate.repository.meta.CalendarHoliday;
import com.inzent.igate.repository.meta.CalendarHolidayPK;

@Service
public class CalendarUploadBeanImpl implements CalendarUploadBean
{
	@Override
	public ArrayList<Calendar> getExcelUpload(MultipartFile uploadFile) 
	{	
		ArrayList<Calendar> result = new ArrayList<Calendar>() ;
		
		try
		{
			String extension = FilenameUtils.getExtension(uploadFile.getOriginalFilename()) ;
			if(!extension.equals("xlsx") && !extension.equals("xls"))
			{
				throw new IOException("!!") ;
			}
			
			Workbook workbook = null ;
			
			// 확장자가 xlsx 인지 xls 인지 구분
			if (extension.equals("xlsx"))
			{
				workbook = new XSSFWorkbook(uploadFile.getInputStream()) ;
			} 
			else if (extension.equals("xls"))
			{
				workbook = new HSSFWorkbook(uploadFile.getInputStream()) ;
			}
			
			Sheet worksheet = workbook.getSheetAt(0) ;
			
			int rows = worksheet.getPhysicalNumberOfRows() ;
			
			// 현재 템플릿에서는 3번째 row 부터 값을 입력하므로 2로 지정 ( 해당 부분은 템플릿 디자인 수정시 수정해야할 필요가 있음 )
			for (int rowindex = 2 ; rowindex < rows ; rowindex++)
			{
				Calendar calendar = new Calendar() ;
				CalendarHoliday holiday = new CalendarHoliday() ;
				CalendarHolidayPK holidayPk = new CalendarHolidayPK() ;
				List<CalendarHoliday> holidayList = new ArrayList<>() ;
				String regex = "^[a-zA-Z0-9_]*$" ; // ID 체크 정규식 
				String pattern = "^[0-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$" ; // 휴일 일자 체크 정규식
				
				Row row = worksheet.getRow(rowindex) ;
				
				Cell cell ;
				cell = row.getCell(0) ;
				
				if(cell.getCellType() == CellType.BLANK) // cell의 Type 이 BLANK 라면 값이 없는 것으로 판단 
					return result ;
				
				try
				{
					// 휴일 ID
					cell = row.getCell(0) ;
					switch (cell.getCellType())
					{
					case STRING :
						if(cell.getStringCellValue().matches(regex) == false ) // ID 체크 정규식
							return result ;
						calendar.setCalendarId(cell.getStringCellValue()) ;
						break ;
					case NUMERIC :
						calendar.setCalendarId(new DecimalFormat("###.#####").format(cell.getNumericCellValue())) ; // Numeric을 String으로 변환 
						break ;
					default:
						return result ;
					}

					// 휴일 이름
					cell = row.getCell(1) ;
					switch (cell.getCellType())
					{
					case STRING :
						calendar.setCalendarName(cell.getStringCellValue()) ;
						break ;
					case NUMERIC :
						calendar.setCalendarName(new DecimalFormat("###.#####").format(cell.getNumericCellValue())) ;
						break ;
					default:
						return result ;
					}

					// 휴일 비고
					cell = row.getCell(2) ;
					switch (cell.getCellType())
					{
					case STRING :
						calendar.setCalendarDesc(cell.getStringCellValue()) ;
						break ;
					case NUMERIC :
						calendar.setCalendarDesc(new DecimalFormat("###.#####").format(cell.getNumericCellValue())) ;
						break ;
					default:
						return result ;
					}

					// 토요일 휴일
					cell = row.getCell(3) ;
					calendar.setSaturdayYn(cell.getStringCellValue().toUpperCase().charAt(0)) ; // 대소문자 구분하지 않고 받은후 대문자로 모두 바꾼후 저장 

					// 일요일 휴일
					cell = row.getCell(4) ;
					calendar.setSundayYn(cell.getStringCellValue().toUpperCase().charAt(0)) ;

					// 휴일 일자
					cell = row.getCell(5) ;
					switch (cell.getCellType()) {
					case STRING :
						if(cell.getStringCellValue().matches(pattern) == false ) // 휴일 일자 체크 정규식 
							return result ;
						holidayPk.setCalendarId(calendar.getCalendarId()) ;
						holidayPk.setHolidayDate(cell.getStringCellValue()) ;
						holiday.setPk(holidayPk) ;
						break ;
					case NUMERIC :
						holidayPk.setCalendarId(calendar.getCalendarId()) ;
						if(new DecimalFormat("###.#####").format(cell.getNumericCellValue()).matches(pattern) == false)
							return result ;
						holidayPk.setHolidayDate(new DecimalFormat("###.#####").format(cell.getNumericCellValue())) ;
						holiday.setPk(holidayPk) ;
						break ;
					default:
						return result ;
					}

					// 휴일 일자 설명
					cell = row.getCell(6) ;
					switch (cell.getCellType()) {
					case STRING :
						holiday.setHolidayDesc(cell.getStringCellValue()) ;
						break ;
					case NUMERIC :
						holiday.setHolidayDesc(new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
						break ;
					default:
						return result ;
					}
				}
				
				catch(Throwable th)
				{
					
				}
				if(holiday.getPk() == null) {
					holidayList.add(null) ;
				}else {
					holidayList.add(holiday) ;
				}
				calendar.setCalendarHoliday(holidayList) ;
				
				result.add(calendar) ;
			}
		}
		catch (IOException e)
		{
			e.printStackTrace() ;
		}
		
		return result ;
	}
	
}
			
