package com.inzent.igate.imanager.interfaces;

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
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.repository.meta.Interface;
import com.inzent.imanager.message.MessageGenerator;

@Service
public class InterfaceDownloadExcel implements InterfaceDownloadBean {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, Interface entity, List<Interface> entityList) throws Exception 
	{
	  String fileName = "Interfaces_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx" ;

	  response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
	  response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
	  response.setContentType("application/octet-stream") ;

	  generateDownload(response, request.getServletContext().getRealPath("/template/List_Interface.xlsx"), entity, entityList) ;

	  response.flushBuffer() ;
	}

	public void generateDownload(HttpServletResponse response, String templateFile, Interface entity, List<Interface> entityList) throws Exception 
	{
	  try (OutputStream outputStream = response.getOutputStream();
		   FileInputStream fileInputStream = new FileInputStream(templateFile);
		   Workbook workbook = WorkbookFactory.create(fileInputStream);) 
	  {
	    Sheet writeSheet = workbook.getSheetAt(0);
		Row row = null ;
		Cell cell = null ;
		String values = null ;

		// Cell ��Ÿ�� ����.
		CellStyle cellStyle_Base = getBaseCellStyle(workbook);
		CellStyle cellStyle_Info = getInfoCellStyle(workbook);

		// �������̽� ID
		values = entity.getInterfaceId();
		row = writeSheet.getRow(3);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// �������̽� �̸�
		values = entity.getInterfaceName();
		row = writeSheet.getRow(3);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ����� ID
		values = entity.getAdapterId();
		row = writeSheet.getRow(3);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// �������̽� ����
		switch (String.valueOf(entity.getInterfaceType()).trim()) {
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
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ������ ����
		switch (String.valueOf(entity.getScheduleType()).trim()) {
	      case "B" :
	    	  values = "Batched";
	    	  break ;
	      case "D" :
	    	  values = "Deferred";
		      break ;
	      case "O" :
	    	  values = "Online";
		      break ;
	      case "T" :
		      values = "Triggered";
		      break ;
	      default: 
	    	  values = "";
	    }
		
		row = writeSheet.getRow(3);
		cell = row.createCell(9);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// �������̽� ��뿩��
		switch (String.valueOf(entity.getUsedYn()).trim()) {
	      case "Y" :
	    	  values = MessageGenerator.getMessage("head.yes", "Yes");
	    	  break ;
	      case "N" :
		      values = MessageGenerator.getMessage("head.no", "No");
		      break ;
	      default: 
	    	  values = "";
	    }

		row = writeSheet.getRow(4);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// �׷�
		values = entity.getInterfaceGroup();
		row = writeSheet.getRow(4);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ����
		values = entity.getPrivilegeId();
		row = writeSheet.getRow(4);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// ���
		values = entity.getInterfaceDesc();
		row = writeSheet.getRow(4);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ��ȸ����Ʈ �Է�
		long sum = 0;
		int i = 7;
		for (Interface interfaceInfo : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// �������̽� ID
			values = interfaceInfo.getInterfaceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// �������̽� �̸�
			values = interfaceInfo.getInterfaceName();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ����� ID
			values = interfaceInfo.getAdapterId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �������̽� ����
			switch (String.valueOf(interfaceInfo.getInterfaceType())) {
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
			
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ����			
			switch (String.valueOf(interfaceInfo.getScheduleType())) {
		      case "B" :
		    	  values = "Batched";
		    	  break ;
		      case "D" :
		    	  values = "Deferred";
			      break ;
		      case "O" :
		    	  values = "Online";
			      break ;
		      case "T" :
			      values = "Triggered";
			      break ;
		      default: 
		    	  values = "";
		    }
			
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �׷�
			values = interfaceInfo.getInterfaceGroup();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ����
			values = interfaceInfo.getPrivilegeId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ����
			values = interfaceInfo.getInterfaceDesc();
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
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("head.name", "Name") );
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("common.privilege", "Privilege"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("common.type", "Type"));
      cell = row.createCell(8);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.usedYn", "Interface Usage Status"));
      
      row = writeSheet.createRow(4);
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.adapter", "Adapter ID"));
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.calendar", "Calendar"));
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("head.group", "Group"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("head.description", "Interface Description"));
      
      row = writeSheet.createRow(7);      
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));
      cell = row.createCell(1);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("head.name", "Name") );
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("common.privilege", "Privilege"));
      cell = row.createCell(3);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("common.type", "Type"));
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.usedYn", "Interface Usage Status"));
      cell = row.createCell(5);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.adapter", "Adapter ID"));
      cell = row.createCell(5);
      cell.setCellValue(MessageGenerator.getMessage("igate.calendar", "Calendar"));
      cell = row.createCell(7);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.group", "Interface Group"));
      cell = row.createCell(8);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.usedTimestamp", "Used Timestamp"));
      cell = row.createCell(9);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.updateTimestamp", "Update Timestamp"));
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
