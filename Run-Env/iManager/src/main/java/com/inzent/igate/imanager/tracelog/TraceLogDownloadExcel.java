package com.inzent.igate.imanager.tracelog;

import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.FastDateFormat;
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
import com.inzent.igate.repository.log.TraceLog;
import com.inzent.imanager.message.MessageGenerator;

@Service
public class TraceLogDownloadExcel implements TraceLogDownloadBean<TraceLog> {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, TraceLog entity,
			List<TraceLog> entityList) throws Exception {
		
		String fileName = "TraceLog_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
				+ URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		generateDownload(response.getOutputStream(), request.getServletContext().getRealPath("/template/List_TraceLog.xlsx"), entity, entityList);

		response.flushBuffer();
		
	}
	
	public void generateDownload(OutputStream outputStream, String templateFile, TraceLog entity,
			List<TraceLog> entityList) throws Exception {
		Row row = null;
		Cell cell = null;
		String values = null;
		Sheet writeSheet;
		
		try(FileInputStream fileInputStream = new FileInputStream(templateFile);
			Workbook workbook = WorkbookFactory.create(fileInputStream);)
		{
			writeSheet = workbook.getSheetAt(0);
			
			// Cell ????????? ??????.
			CellStyle cellStyle_Base = getBaseCellStyle(workbook);
			CellStyle cellStyle_Info = getInfoCellStyle(workbook);
			
			// From
			values = entity.getFromLogDateTime().toString();
			row = writeSheet.getRow(3);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// To
			values = entity.getToLogDateTime().toString();
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ?????? ID
			values = entity.getTransactionId();
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ?????? ??????
			values = entity.getLogCode();
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ????????? ID
			values = entity.getAdapterId();
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ??????????????? ID
			values = entity.getInterfaceId();
			row = writeSheet.getRow(4);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ????????? ID
			values = entity.getServiceId();
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ????????? ID
			values = entity.getConnectorId();
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ???????????? ID
			values = entity.getInstanceId();
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ?????? ??????
			values = entity.getExternalTransaction();
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ?????? ?????????
			values = entity.getExternalMessage();
			row = writeSheet.getRow(5);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ?????? ??????
			values = entity.getResponseCode();
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// IP
			values = entity.getRemoteAddr();
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ?????? ID
			values = entity.getSessionId();
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ???????????? ??????
			values = null;
			if(entity.getTimeoutYn() != 0){
				values = Character.toString(entity.getTimeoutYn());			
			}
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ??????????????? ??????
			long sum = 0;
			int i = 9;
			for(TraceLog data : entityList) {
				row = writeSheet.createRow(i);
				int c = 0;
				
				//????????????
				values = "";
				if(data.getRequestTimestamp() != null) {
					values = data.getRequestTimestamp().toString();				
				}
				
				cell = row.createCell(c);
				cell.setCellValue(values);

				//?????? ID
				values = data.getTransactionId();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				//?????? ??????
				values = data.getLogCode();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				//????????? ID
				values = data.getAdapterId();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				//??????????????? ID
				values = data.getInterfaceId();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);

				//????????? ID
				values = data.getServiceId();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				//???????????? ID
				values = data.getInstanceId();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
								
				//????????????
				values = data.getExternalTransaction();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);

				//???????????????
				values = data.getExternalMessage();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				//????????????
				values = data.getResponseCode();
				cell = row.createCell(c += 1);
				cell.setCellValue(values);
				
				sum++;
				i++;
			}
			
			workbook.write(outputStream);
			
		}catch (Exception e){
			throw e ;
		}	
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
		cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.transactionId", "Transaction ID"));
		
		cell = row.createCell(6);
		cell.setCellValue(MessageGenerator.getMessage("head.log", "Log") + " " + MessageGenerator.getMessage("head.classification", "Classification"));

		cell = row.createCell(8);
		cell.setCellValue(MessageGenerator.getMessage("igate.adapter.id", "Adapter ID"));
		
		row = writeSheet.createRow(4);
		cell = row.createCell(0);
		cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));

		cell = row.createCell(2);
		cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));
					
		cell = row.createCell(4);
		cell.setCellValue(MessageGenerator.getMessage("igate.connector", "Connector") + " " + MessageGenerator.getMessage("head.id", "ID") );
		
		cell = row.createCell(6);
		cell.setCellValue(MessageGenerator.getMessage("igate.instance.id", "Instance ID"));
		
		cell = row.createCell(8);
		cell.setCellValue(MessageGenerator.getMessage("igate.externalTransaction", "External Transaction"));


		row = writeSheet.createRow(5);
		cell = row.createCell(0);
		cell.setCellValue(MessageGenerator.getMessage("igate.externalMessage", "External Message"));
		
		cell = row.createCell(2);
		cell.setCellValue(MessageGenerator.getMessage("igate.traceLog.responseCode", "Response Code"));

		cell = row.createCell(4);
		cell.setCellValue(MessageGenerator.getMessage("head.ip", "IP"));

		cell = row.createCell(6);
		cell.setCellValue(MessageGenerator.getMessage("igate.connectorControl.session", "Session") + " " + MessageGenerator.getMessage("head.id", "ID") );
		
		cell = row.createCell(8);
		cell.setCellValue(MessageGenerator.getMessage("head.timeoutYn", "TimeoutYN"));
		
		int rc = 0;
		row = writeSheet.createRow(9);
		cell = row.createCell(rc);
		cell.setCellValue(MessageGenerator.getMessage("igate.traceLog.requestTimestamp", "RequestTimestamp"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.exceptionLog.transactionId", "Transaction ID"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("head.log", "Log") + " " + MessageGenerator.getMessage("head.classification", "Classification"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.adapter.id", "Adapter ID"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.instance.id", "Instance ID"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.externalTransaction", "External Transaction"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.externalMessage", "External Message"));
		cell = row.createCell(rc+=1);
		cell.setCellValue(MessageGenerator.getMessage("igate.traceLog.responseCode", "Response Code") );

		return new Object[] {
			workbook, writeSheet, row, cell
		} ;
    }
	
	public XSSFCellStyle getBaseCellStyle(Workbook workbook) {
		// Cell ????????? ??????.
		XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
		// ????????? ??????(???????????????)
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		// ????????? ?????? (?????? ?????????)
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// ?????? ?????? ????????? 10
		cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()));

		// Cell ??????
		cellStyle.setLocked(true);
		// Cell ?????? Text ????????? ?????????
		cellStyle.setWrapText(true);

		return cellStyle;
	}
	
	public XSSFCellStyle getInfoCellStyle(Workbook workbook) {
		XSSFCellStyle cellStyle = getBaseCellStyle(workbook);
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// ?????? ?????? ????????? (??????)
		Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex());
		font.setBold(true);
		cellStyle.setFont(font);

		cellStyle.setFillForegroundColor(new XSSFColor(new byte[] { (byte) 242, (byte) 242, (byte) 242 }, null));
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		return cellStyle;
	}

	public Font getBaseFont(Workbook workbook, int size, short color) {
		// ??????
		Font font = workbook.createFont();
		font.setFontHeight((short) (20 * size));
		font.setFontName("??????");
		font.setColor(color);
		return font;
	}

}
