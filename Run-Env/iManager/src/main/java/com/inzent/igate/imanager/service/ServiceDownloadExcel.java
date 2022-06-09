package com.inzent.igate.imanager.service;

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
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.imanager.logstats.LogStatsRepository;
import com.inzent.igate.repository.meta.Service;
import com.inzent.imanager.message.MessageGenerator;

@org.springframework.stereotype.Service
public class ServiceDownloadExcel implements ServiceDownloadBean {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, Service entity, List<Service> entityList) throws Exception 
	{
	  String fileName = "Services_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx" ;

	  response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
	  response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
	  response.setContentType("application/octet-stream") ;

	  generateDownload(response, request.getServletContext().getRealPath("/template/List_Service.xlsx"), entity, entityList) ;

	  response.flushBuffer() ;
	}

	protected void generateDownload(HttpServletResponse response, String templateFile, Service entity, List<Service> entityList) throws Exception 
	{
	  try(OutputStream outputStream = response.getOutputStream();
		  FileInputStream fileInputStream = new FileInputStream(templateFile);
		  Workbook workbook = WorkbookFactory.create(fileInputStream);)
	  {
	    Sheet writeSheet = workbook.getSheetAt(0) ;
	    Row row = null ;
	    Cell cell = null ;
	    String values = null ;
	    
		// Cell ��Ÿ�� ����.
		CellStyle cellStyle_Base = getBaseCellStyle(workbook);
		CellStyle cellStyle_Info = getInfoCellStyle(workbook);

		// ���� ID
		values = entity.getServiceId();
		row = writeSheet.getRow(3);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ���� �̸�
		values = entity.getServiceName();
		row = writeSheet.getRow(3);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ���� ����
		switch (String.valueOf(entity.getServiceType()).trim()) {
	      case "DB" :
	    	  values = MessageGenerator.getMessage("DB", "DB");
	    	  break ;
	      case "File" :
		      values = MessageGenerator.getMessage("head.file", "File");
		      break ;
	      case "Online" :
	    	  values = MessageGenerator.getMessage("head.online", "Online");
	    	  break ;
	      default: 
	    	  values = "";
	    }
		
		row = writeSheet.getRow(3);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ����� ID
		values = entity.getServiceGroup();
		row = writeSheet.getRow(3);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// �׷�
		values = entity.getServiceGroup();
		row = writeSheet.getRow(4);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ����
		values = entity.getPrivilegeId();
		row = writeSheet.getRow(4);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ���
		values = entity.getServiceDesc();
		row = writeSheet.getRow(4);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ��ȸ����Ʈ �Է�
		long sum = 0;
		int i = 7;
		for (Service serviceInfo : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// ���� ID
			values = serviceInfo.getServiceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ���� �̸�
			values = serviceInfo.getServiceName();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ���� ����			
			switch (serviceInfo.getServiceType()) {
		      case "DB" :
		    	  values = MessageGenerator.getMessage("DB", "DB");
		    	  break ;
		      case "File" :
			      values = MessageGenerator.getMessage("head.file", "File");
			      break ;
		      case "Online" :
		    	  values = MessageGenerator.getMessage("head.online", "Online");
		    	  break ;
		    }
			
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ����� ID
			values = serviceInfo.getAdapterId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// �׷�
			values = serviceInfo.getServiceGroup();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ����
			values = serviceInfo.getPrivilegeId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ���
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 6, 7));
			values = serviceInfo.getServiceDesc();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
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
	  }
	  catch (Exception e) 
	  {
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

      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("head.name", "Name") );
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("common.type", "Type"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.adapter", "Adapter") + " " + MessageGenerator.getMessage("head.id", "ID"));
      
      row = writeSheet.createRow(4);      
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.service.group", "Service Group"));
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("common.privilege", "Privilege"));
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("head.description", "Service Description"));
      
      row = writeSheet.createRow(7);
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 0, 1));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 2, 3));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 4, 5));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 6, 7));
      
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(1);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("head.name", "Name") );
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.service", "Service") + " " + MessageGenerator.getMessage("common.type", "Type"));
      cell = row.createCell(3);
      cell.setCellValue(MessageGenerator.getMessage("igate.adapter", "Adapter") + " " + MessageGenerator.getMessage("head.id", "ID"));
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.service.group", "Service Group"));
      cell = row.createCell(5);
      cell.setCellValue(MessageGenerator.getMessage("common.privilege", "Privilege"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("head.description", "service Description"));
      /* Create Base Excel Template */
      
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
