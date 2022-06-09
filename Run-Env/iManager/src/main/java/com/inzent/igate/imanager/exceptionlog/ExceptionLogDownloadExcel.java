package com.inzent.igate.imanager.exceptionlog;

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
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.repository.log.ExceptionLog;
import com.inzent.imanager.message.MessageGenerator;

@Service
public class ExceptionLogDownloadExcel implements ExceptionLogDownloadBean<ExceptionLog> {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, ExceptionLog entity, List<ExceptionLog> entityList) throws Exception {
		
		String fileName = "ExceptionLog_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		generateDownload(response, request.getServletContext().getRealPath("/template/List_ExceptionLog.xlsx"), entity, entityList);

		response.flushBuffer();
	}
	
	public void generateDownload(HttpServletResponse response  , String templateFile, ExceptionLog entity, List<ExceptionLog> entityList) throws Exception {
		
		try (OutputStream outputStream = response.getOutputStream();
			 FileInputStream fileInputStream = new FileInputStream(templateFile);
			 Workbook workbook = WorkbookFactory.create(fileInputStream);)
		{
			Sheet writeSheet = workbook.getSheetAt(0);
	        Row row = null ;
	        Cell cell = null ;
	        String values = null ;
	        Object[] objects = null ;
			
			// Cell ��Ÿ�� ����.
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
			row = writeSheet.getRow(3);
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �ŷ� ID
			values = entity.getTransactionId();
			row = writeSheet.getRow(3);
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ����� ID
			values = entity.getAdapterId();
			row = writeSheet.getRow(3);
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ���� �ڵ�
			values = entity.getExceptionCode();
			row = writeSheet.getRow(3);
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �������̽� ID
			values = entity.getInterfaceId();
			row = writeSheet.getRow(4);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ���� ID
			values = entity.getServiceId();
			row = writeSheet.getRow(4);
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �ν��Ͻ� ID
			values = entity.getInstanceId();
			row = writeSheet.getRow(4);
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// Ŀ���� ID
			values = entity.getConnectorId();
			row = writeSheet.getRow(4);
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ��Ƽ��Ƽ ID
			values = entity.getActivityId();
			row = writeSheet.getRow(4);
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ��ȸ����Ʈ �Է�
			long sum = 0;
			int i = 7;
			for(ExceptionLog data : entityList) {
				row = writeSheet.createRow(i);
				int c = 0;
				
				//��¥/�ð�
				values = data.getPk().getExceptionDateTime().toString();
				cell = row.createCell(c);
				cell.setCellValue(values);

				//�ŷ� ID
				values = data.getTransactionId();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//����� ID
				values = data.getAdapterId();
				cell = row.createCell(++c);
				cell.setCellValue(values);

				//���� �ڵ�
				values = data.getExceptionCode();
				cell = row.createCell(++c);
				cell.setCellValue(values);

				//�������̽� ID
				values = data.getInterfaceId();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//���� ID
				values = data.getServiceId();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//�ν��Ͻ� ID
				values = data.getInstanceId();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//Ŀ���� ID
				values = data.getConnectorId();
				cell = row.createCell(++c);
				cell.setCellValue(values);				
				
				//��Ƽ��Ƽ ID
				values = data.getActivityId();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//Exception Text
				values = data.getExceptionText();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				//Exception Stack
				values = data.getExceptionStack();
				
				/* ===Excel�� �� field�� �� �� �ִ� ���ڼ��� 32,767�̹Ƿ� �̰� �Ѿ�� ���� �ִٸ� ���=== */
				//�ڿ��� 32000�� �ڸ��� (Caused by ���� ��)
				if(values.length() > 32000) values = values.substring(values.length()-32000, values.length());
				// �տ��� 32000�� �ڸ���
				//if(values.length() > 32000) values = values.substring(0, 32000);
				/* ====================================================================== */
				
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				sum++;
				i++;
			}
			
			// �հ�
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
		} catch (Exception e) {
			throw e;
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
		// Cell ��Ÿ�� ����.
		XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();
		// �ؽ�Ʈ ����(���ΰ��)
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		// �ؽ�Ʈ ���� (���� ���)
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// ��Ʈ ���� ������ 10
		cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()));

		// Cell ���
		cellStyle.setLocked(true);
		// Cell ���� Text �ٹٲ� Ȱ��ȭ
		cellStyle.setWrapText(true);

		return cellStyle;
	}

	public XSSFCellStyle getInfoCellStyle(Workbook workbook) {
		XSSFCellStyle cellStyle = getBaseCellStyle(workbook);
		cellStyle.setAlignment(HorizontalAlignment.CENTER);

		// ��Ʈ ���� ������ (����)
		Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex());
		font.setBold(true);
		cellStyle.setFont(font);

		cellStyle.setFillForegroundColor(new XSSFColor(new byte[] { (byte) 242, (byte) 242, (byte) 242 }, null));
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		return cellStyle;
	}

	public Font getBaseFont(Workbook workbook, int size, short color) {
		// ��Ʈ
		Font font = workbook.createFont();
		font.setFontHeight((short) (20 * size));
		font.setFontName("����");
		font.setColor(color);
		return font;
	}
}
