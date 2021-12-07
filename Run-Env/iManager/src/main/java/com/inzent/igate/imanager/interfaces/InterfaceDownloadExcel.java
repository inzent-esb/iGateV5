package com.inzent.igate.imanager.interfaces;

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
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, Interface entity,
			List<Interface> entityList) throws Exception {

		String fileName = "Interfaces_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
				+ URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		generateDownload(response.getOutputStream(), request.getServletContext().getRealPath("/template/List_Interface.xlsx"), entity, entityList);

		response.flushBuffer();
	}

	public void generateDownload(OutputStream outputStream, String templateFile, Interface entity,
			List<Interface> entityList) throws Exception {
		Workbook workbook = null ;
		Sheet writeSheet = null ;
		Row row = null ;
		Cell cell = null ;
		String values = null ;
		Object[] objects = null ;
        try
        {
          FileInputStream fileInputStream = new FileInputStream(templateFile) ;
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

		// 인터페이스 ID
		values = entity.getInterfaceId();
		row = writeSheet.getRow(3);
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 인터페이스 이름
		values = entity.getInterfaceName();
		row = writeSheet.getRow(3);
		cell = row.createCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 어댑터 ID
		values = entity.getAdapterId();
		row = writeSheet.getRow(3);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 그룹
		values = entity.getInterfaceGroup();
		row = writeSheet.getRow(3);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 사용여부
		values = Character.toString(entity.getUsedYn());
		row = writeSheet.getRow(3);
		cell = row.createCell(9);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 조회리스트 입력
		long sum = 0;
		int i = 5;
		for (Interface interface2 : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// 인터페이스 ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 0, 1));
			values = interface2.getInterfaceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 인터페이스 이름
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 2, 3));
			values = interface2.getInterfaceName();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 어댑터 ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 4, 5));
			values = interface2.getAdapterId();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 그룹
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 6, 7));
			values = interface2.getInterfaceGroup();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 최종수정시간
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 8, 9));
			values = interface2.getUpdateTimestamp() == null ? "" : interface2.getUpdateTimestamp().toString();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 최종사용시간
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 10, 11));
			values = interface2.getUsedTimestamp() == null ? "" : interface2.getUsedTimestamp().toString();
			cell = row.createCell(c += 2);
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
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.adapter", "Adapter ID"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.group", "Interface Group"));
      cell = row.createCell(8);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.usedYn", "Interface Usage Status"));
      
      row = writeSheet.createRow(4);
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 0, 1));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 2, 3));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 4, 5));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 6, 7));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 8, 9));
      writeSheet.addMergedRegion(new CellRangeAddress(4, 4, 10, 11));
      
      cell = row.createCell(0);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.id", "Interface ID"));
      cell = row.createCell(2);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface", "Interface") + " " + MessageGenerator.getMessage("head.name", "Name") );
      cell = row.createCell(4);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.adapter", "Adapter ID"));
      cell = row.createCell(6);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.group", "Interface Group"));
      cell = row.createCell(8);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.usedTimestamp", "Used Timestamp"));
      cell = row.createCell(10);
      cell.setCellValue(MessageGenerator.getMessage("igate.interface.updateTimestamp", "Update Timestamp"));
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
