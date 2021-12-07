package com.inzent.igate.imanager.exceptionlog;

import java.io.FileInputStream;
import java.io.IOException ;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.FastDateFormat;
import org.apache.poi.EncryptedDocumentException ;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.repository.log.ExceptionLog;
import com.inzent.imanager.message.MessageGenerator;

@Service
public class ExceptionLogDownloadExcel implements ExceptionLogDownloadBean<ExceptionLog> {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, ExceptionLog entity,
			List<ExceptionLog> entityList) throws Exception {
		
		String fileName = "ExceptionLog_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
				+ URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		generateDownload(response.getOutputStream(), request.getServletContext().getRealPath("/template/List_ExceptionLog.xlsx"), entity, entityList);

		response.flushBuffer();
	}
	
	public void generateDownload(OutputStream outputStream, String templateFile, ExceptionLog entity,
			List<ExceptionLog> entityList) throws Exception {
		
        Workbook workbook ;
        Sheet writeSheet ;
        Row row = null ;
        Cell cell = null ;
        String values = null ;
        Object[] objects = null ;
		
		try {
			FileInputStream fileInputStream = new FileInputStream(templateFile);
			workbook = WorkbookFactory.create(fileInputStream);
			writeSheet = workbook.getSheetAt(0);
		}
        catch (EncryptedDocumentException | IOException e)
        {
          objects = generateTemplete() ;
          workbook = (Workbook)objects[0] ;
          writeSheet = (Sheet)objects[1] ;
          row = (Row)objects[2] ;
          cell = (Cell)objects[3] ;
        }
		
		// Cell 스타일 지정.
		CellStyle cellStyle_Base = getBaseCellStyle(workbook);
		CellStyle cellStyle_Info = getInfoCellStyle(workbook);
		
		// From
		values = entity.getFromExceptionDateTime().toString();
		row = writeSheet.getRow(3);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// To
		values = entity.getToExceptionDateTime().toString();
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 인스턴스 ID
		values = entity.getInstanceId();
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 거래 ID
		values = entity.getTransactionId();
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 에러 코드
		values = entity.getExceptionCode();
		cell = row.createCell(9);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 인터페이스 ID
		values = entity.getInterfaceId();
		row = writeSheet.getRow(4);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 서비스 ID
		values = entity.getServiceId();
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 어댑터 ID
		values = entity.getAdapterId();
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 커넥터 ID
		values = entity.getConnectorId();
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 에러로그 ID		
		values = (null != entity.getPk())? entity.getPk().getExceptionId() : null;
		cell = row.createCell(9);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 조회리스트 입력
		long sum = 0;
		int i = 7;
		for(ExceptionLog data : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;
			
			//날짜/시간
			values = data.getPk().getExceptionDateTime().toString();
			cell = row.createCell(c);
			cell.setCellValue(values);

			//에러로그 ID
			values = data.getPk().getExceptionId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//에러 코드
			values = data.getExceptionCode();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);

			//거래 ID
			values = data.getTransactionId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);

			//메시지 ID
			values = data.getMessageId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//인터페이스 ID
			values = data.getInterfaceId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//서비스 ID
			values = data.getServiceId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//인스턴스 ID
			values = data.getInstanceId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//어댑터 ID
			values = data.getAdapterId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);

			//커넥터 ID
			values = data.getConnectorId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//액티비티 ID
			values = data.getActivityId();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//Exception Text
			values = data.getExceptionText();
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			//Exception Stack
			values = data.getExceptionStack();
			
			/* ===Excel의 한 field에 들어갈 수 있는 글자수는 32,767이므로 이가 넘어가는 값이 있다면 사용=== */
			//뒤에서 32000자 자르기 (Caused by 보기 용)
			if(values.length() > 32000) values = values.substring(values.length()-32000, values.length());
			// 앞에서 32000자 자르기
			//if(values.length() > 32000) values = values.substring(0, 32000);
			/* ====================================================================== */
			
			cell = row.createCell(c += 1);
			cell.setCellValue(values);
			
			sum++;
			i++;
		}
		
		// 합계
		row = writeSheet.createRow(i);

		values = MessageGenerator.getMessage("head.total", "Total");
		cell = row.createCell(0);
		cell.setCellStyle(cellStyle_Info);
		cell.setCellValue(values);

		// sum
		values = CommonTools.numberWithComma(Long.toString(sum));
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		entityList = null ;
		workbook.write(outputStream);
	}

    public Object[] generateTemplete()
    {
      /* Template Load Error */
      /* Create Base Excel Template */
      Workbook workbook = new XSSFWorkbook();
      Sheet writeSheet = workbook.createSheet();
      Row row = writeSheet.createRow(3);
      Cell cell ;

      row = writeSheet.createRow(3);
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("head.from", "From"));
      
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("head.to", "To"));
      
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.instance.id", "Instance ID"));
      
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.transactionId", "Transaction ID"));
      
      cell = row.createCell(8);
      cell.setCellValue(MessageGenerator.getMessage("head.exception.code", "Exception Code"));
      
      row = writeSheet.createRow(4);
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));

      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));

      
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.adapter.id", "Adapter ID"));
      
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.connector", "Connector") + " " + MessageGenerator.getMessage("head.id", "ID") );

      int rc = 0;
      row = writeSheet.createRow(6);
      cell = row.createCell(rc);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.exceptionDateTime", "DateTime"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog", "ExceptionLog") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("head.exception.code", "Exception Code"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.transactionId", "Transaction ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("apim.requestmngr.requestMessage", "Message") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.instance.id", "Instance ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.adapter.id", "Adapter ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.connector", "Connector") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.activity.id", "Activity ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.exceptionText", "Exception Text"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.exceptionStack", "Exception Stack"));

      return new Object[] {
          workbook, writeSheet, row, cell
      } ;
    }

	public XSSFCellStyle getBaseCellStyle(Workbook workbook) {
		// Cell 스타일 지정.
		XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
		// 텍스트 맞춤(세로가운데)
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		// 텍스트 맞춤 (가로 가운데)
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// 폰트 지정 사이즈 10
		cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()));

		// Cell 잠금
		cellStyle.setLocked(true);
		// Cell 에서 Text 줄바꿈 활성화
		cellStyle.setWrapText(true);

		return cellStyle;
	}

	public XSSFCellStyle getInfoCellStyle(Workbook workbook) {
		XSSFCellStyle cellStyle = getBaseCellStyle(workbook);
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// 폰트 지정 사이즈 (굵게)
		Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex());
		font.setBold(true);
		cellStyle.setFont(font);

		cellStyle.setFillForegroundColor(new XSSFColor(new byte[] { (byte) 242, (byte) 242, (byte) 242 }, null));
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		return cellStyle;
	}

	public Font getBaseFont(Workbook workbook, int size, short color) {
		// 폰트
		Font font = workbook.createFont();
		font.setFontHeight((short) (20 * size));
		font.setFontName("굴림");
		font.setColor(color);
		return font;
	}
}
