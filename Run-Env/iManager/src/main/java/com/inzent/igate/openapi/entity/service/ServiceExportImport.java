package com.inzent.igate.openapi.entity.service ;

import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
import org.springframework.stereotype.Component ;
import org.springframework.web.multipart.MultipartFile ;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.imanager.EntityExportImportBean ;
import com.inzent.igate.repository.meta.Service;
import com.inzent.imanager.message.MessageGenerator;

@Component
public class ServiceExportImport implements EntityExportImportBean<Service>
{
  @Override
  public void exportList(HttpServletRequest request, HttpServletResponse response, Service entity, List<Service> list) throws Exception
  {
    String fileName = "Services_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx" ;

    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
    response.setContentType("application/octet-stream") ;

    generateDownload(response, request.getServletContext().getRealPath("/template/List_Service.xlsx"), entity, list) ;

    response.flushBuffer() ;
  }

  @Override
  public void exportObject(HttpServletRequest request, HttpServletResponse response, Service entity) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public Service importObject(MultipartFile multipartFile) throws Exception
  {
    throw new UnsupportedOperationException() ;
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
	    
		// Cell 스타일 지정.
		CellStyle cellStyle_Base = getBaseCellStyle(workbook);
		CellStyle cellStyle_Info = getInfoCellStyle(workbook);

		// 서비스 ID
		values = entity.getServiceId();
		row = writeSheet.getRow(3);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 서비스 이름
		values = entity.getServiceName();
		row = writeSheet.getRow(3);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 서비스 종류
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
	    	  break ;
	    }
		
		row = writeSheet.getRow(3);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 어댑터 ID
		values = entity.getServiceGroup();
		row = writeSheet.getRow(3);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 그룹
		values = entity.getServiceGroup();
		row = writeSheet.getRow(4);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 권한
		values = entity.getPrivilegeId();
		row = writeSheet.getRow(4);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);
		
		// 비고
		values = entity.getServiceDesc();
		row = writeSheet.getRow(4);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 조회리스트 입력
		long sum = 0;
		int i = 7;
		for (Service serviceInfo : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// 서비스 ID
			values = serviceInfo.getServiceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 서비스 이름
			values = serviceInfo.getServiceName();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 서비스 종류			
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
		    	  
		      default : 
		    	break ;

		    }
			
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 어댑터 ID
			values = serviceInfo.getAdapterId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 그룹
			values = serviceInfo.getServiceGroup();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 권한
			values = serviceInfo.getPrivilegeId();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 비고
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 6, 7));
			values = serviceInfo.getServiceDesc();
			cell = row.createCell(++c);
			cell.setCellStyle(cellStyle_Base);
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
