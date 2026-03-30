package com.inzent.igate.openapi.entity.metahistory ;

import java.io.InputStream;
import java.io.OutputStream ;
import java.net.URLEncoder ;
import java.sql.Timestamp ;
import java.util.List ;

import jakarta.servlet.http.HttpServletRequest ;
import jakarta.servlet.http.HttpServletResponse ;

import org.apache.commons.lang3.time.FastDateFormat ;
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
import org.springframework.web.multipart.MultipartFile ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.imanager.CommonTools ;
import  com.inzent.imanager.repository.meta.MetaHistory ;
import com.inzent.imanager.EntityExportImportBean;
import com.inzent.imanager.message.MessageGenerator ;

@Component
public class MetaHistoryExportImport implements EntityExportImportBean<MetaHistory>
{
  @Override
  public void exportList(HttpServletRequest request, HttpServletResponse response, MetaHistory entity, List<MetaHistory> list) throws Exception
  {
    String fileName = "MetaHistory_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
    response.setContentType("application/octet-stream");

    generateDownload(request, response, "/template/List_MetaHistory.xlsx", entity, list);

    response.flushBuffer();
  }

  @Override
  public void exportObject(HttpServletRequest request, HttpServletResponse response, MetaHistory entity) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public MetaHistory importObject(MultipartFile multipartFile) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

	public void generateDownload(HttpServletRequest request, HttpServletResponse response, String templateFile, MetaHistory entity, List<MetaHistory> entityList) throws Exception {
		
		try (OutputStream outputStream = response.getOutputStream();
			 InputStream fileInputStream = request.getServletContext().getResourceAsStream(templateFile);
			 Workbook workbook = WorkbookFactory.create(fileInputStream);)
		{
			Sheet writeSheet = workbook.getSheetAt(0);
	        Row row = null ;
	        Cell cell = null ;
	        String values = null ;
			
			// Cell 스타일 지정.
			CellStyle cellStyle_Base = getBaseCellStyle(workbook);
			CellStyle cellStyle_Info = getInfoCellStyle(workbook);
			
			// From
			values = entity.getModifyDateTimeFrom().toString().substring(0, 19);
			row = writeSheet.getRow(3);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// To
			values = entity.getModifyDateTimeTo().toString().substring(0, 19);
			row = writeSheet.getRow(3);
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// Entity Name
			values = entity.getEntityName();
			row = writeSheet.getRow(4);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// Entity ID
			values = entity.getEntityId();
			row = writeSheet.getRow(4);
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// Modify Type
			switch (Character.toString(entity.getModifyType())) {
		      case "D" :
		    	  values = MessageGenerator.getMessage("head.delete", "Delete");
		    	  break ;
		      case "S" :
			      values = MessageGenerator.getMessage("head.insert", "Insert");
			      break ;
		      case "R" :
			      values = MessageGenerator.getMessage("common.metaHistory.restore", "Restore");
			      break ;
		      case "U" :
			      values = MessageGenerator.getMessage("head.update", "Update");
			      break ;
		      default: 
		    	  values = "";
		    	  break ;
		    }
			
			row = writeSheet.getRow(4);
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 조회리스트 입력
			long sum = 0;
			int i = 7;
			for(MetaHistory data : entityList) {
				row = writeSheet.createRow(i);
				int c = 0;
				
				// 수정일
				values = data.getPk().getModifyDateTime().toString().substring(0, 19);
				cell = row.createCell(c);
				cell.setCellValue(values);

				// Entity Name
				values = data.getEntityName();
				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				// Entity ID
				values = data.getEntityId();
				cell = row.createCell(++c);
				cell.setCellValue(values);

				// Entity Version
				values = Integer.toString(data.getEntityVersion());
				cell = row.createCell(++c);
				cell.setCellValue(values);

				// Modify Type
				switch (Character.toString(data.getModifyType())) {
			      case "D" :
			    	  values = MessageGenerator.getMessage("head.delete", "Delete");
			    	  break ;
			      case "S" :
				      values = MessageGenerator.getMessage("head.insert", "Insert");
				      break ;
			      case "R" :
				      values = MessageGenerator.getMessage("common.metaHistory.restore", "Restore");
				      break ;
			      case "U" :
				      values = MessageGenerator.getMessage("head.update", "Update");
				      break ;
			      default: 
			    	  values = "";
			    	  break ;
			    }

				cell = row.createCell(++c);
				cell.setCellValue(values);
				
				// 수정자
				values = data.getUpdateUserId();
				cell = row.createCell(++c);
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
      
      row = writeSheet.createRow(4);
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.entityName", "Entity Name"));
      
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.entityId", "Entity ID"));
      
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.modifyType", "Modify Type"));
      
      int rc = 0;
      row = writeSheet.createRow(6);
      cell = row.createCell(rc);
      cell.setCellValue(MessageGenerator.getMessage("head.update.timestamp", "Modified Date"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.entityName", "Entity Name"));
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.entityId", "Entity ID"));
      cell = row.createCell(rc+=1);
      cell.setCellValue("Entity Version");
      cell = row.createCell(rc+=1);
      cell.setCellValue(MessageGenerator.getMessage("common.metaHistory.modifyType", "Modify Type"));
      cell = row.createCell(rc+=1);      

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
