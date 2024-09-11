package com.inzent.igate.openapi.entity.externalLine;

import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.FastDateFormat;
import org.apache.poi.openxml4j.opc.OPCPackage;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.imanager.EntityExportImportBean;
import com.inzent.igate.repository.meta.Connector;
import com.inzent.igate.repository.meta.ExternalConnector;
import com.inzent.igate.repository.meta.ExternalLine;
import com.inzent.imanager.message.MessageGenerator;
import com.inzent.imanager.repository.MetaEntityRepository;

//@Component
public class ExternalLineExportImport implements EntityExportImportBean<ExternalLine> {

	@Override
	public void exportList(HttpServletRequest arg0, HttpServletResponse arg1, ExternalLine arg2,
			List<ExternalLine> arg3) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void exportObject(HttpServletRequest arg0, HttpServletResponse arg1, ExternalLine arg2) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ExternalLine importObject(MultipartFile arg0) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
/*

	// Export List
	@Override
	public void exportList(HttpServletRequest request, HttpServletResponse response, ExternalLine entity,
			List<ExternalLine> entityList) throws Exception {
		String fileName = "ExternalLines_"
				+ FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis()))
				+ ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
				+ URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");



		response.flushBuffer();

	}

	
	
	public List<ExternalLine> importList(MultipartFile multipartFile) throws Exception {
		List<ExternalLine> list = new ArrayList<ExternalLine>();
		
		try (OPCPackage opcPackage = OPCPackage.open(multipartFile.getInputStream()); Workbook workbook = new XSSFWorkbook(opcPackage)) {
			list = importExcelSheet(workbook, 0);			
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		}

		return list;
	}
	
	public List<ExternalLine> importExcelSheet(Workbook workbook, int sheetIdx) throws Exception{
		List<ExternalLine> list = new ArrayList<ExternalLine>();
		Sheet sheet = workbook.getSheetAt(sheetIdx);
		Row row = null;
	    Cell cell = null;
	    int index = 2;
	    
	    while (true) {
	    	row = sheet.getRow(index);
	    	if (null == row || getStringNumericValue(row.getCell(1)).isEmpty()) break;
	    	index++;
	    }
		return list;
	}

	@Override
	public void exportObject(HttpServletRequest var1, HttpServletResponse var2, ExternalLine var3) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public ExternalLine importObject(MultipartFile var1) throws Exception {
		// TODO Auto-generated method stub
		return null;
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

	protected String getStringNumericValue(Cell cell) {
		if (cell != null)
			try {
				return cell.getStringCellValue();
			} catch (IllegalStateException e) {
				return Integer.toString((int) cell.getNumericCellValue());
			}

		return "";
	}*/
}
