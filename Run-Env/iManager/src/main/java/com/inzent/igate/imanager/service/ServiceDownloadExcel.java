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

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.repository.meta.Service;
import com.inzent.imanager.message.MessageGenerator;

@org.springframework.stereotype.Service
public class ServiceDownloadExcel implements ServiceDownloadBean {

	@Override
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, Service entity,
			List<Service> entityList) throws Exception {

		String fileName = "Services_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
				+ URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		generateDownload(response.getOutputStream(), request.getServletContext().getRealPath("/template/List_Service.xlsx"), entity, entityList);

		response.flushBuffer();
	}

	protected void generateDownload(OutputStream outputStream, String templateFile, Service entity,
			List<Service> entityList) throws Exception {
		Workbook workbook;
		try (FileInputStream fileInputStream = new FileInputStream(templateFile)) {
			workbook = WorkbookFactory.create(fileInputStream);
		}
		Row row = null;
		Cell cell = null;
		String values = null;

		Sheet writeSheet = workbook.getSheetAt(0);

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

		// 어댑터 ID
		values = entity.getAdapterId();
		row = writeSheet.getRow(3);
		cell = row.createCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 그룹
		values = entity.getServiceGroup();
		row = writeSheet.getRow(3);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// 조회리스트 입력
		long sum = 0;
		int i = 5;
		for (Service service2 : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// 인터페이스 ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 0, 1));
			values = service2.getServiceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 인터페이스 이름
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 2, 3));
			values = service2.getServiceName();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 어댑터 ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 4, 5));
			values = service2.getAdapterId();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 그룹
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 6, 7));
			values = service2.getServiceGroup();
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
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(sum);

		workbook.write(outputStream);
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
