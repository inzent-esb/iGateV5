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
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonEncoding;
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
		Workbook workbook;

		try (FileInputStream fileInputStream = new FileInputStream(templateFile)) {
			workbook = WorkbookFactory.create(fileInputStream);
		}
		Row row = null;
		Cell cell = null;
		String values = null;

		Sheet writeSheet = workbook.getSheetAt(0);

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

		// �׷�
		values = entity.getInterfaceGroup();
		row = writeSheet.getRow(3);
		cell = row.createCell(7);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ��뿩��
		values = Character.toString(entity.getUsedYn());
		row = writeSheet.getRow(3);
		cell = row.createCell(9);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(values);

		// ��ȸ����Ʈ �Է�
		long sum = 0;
		int i = 5;
		for (Interface interface2 : entityList) {
			row = writeSheet.createRow(i);
			int c = 0;

			// �������̽� ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 0, 1));
			values = interface2.getInterfaceId();
			cell = row.createCell(c);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// �������̽� �̸�
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 2, 3));
			values = interface2.getInterfaceName();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// ����� ID
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 4, 5));
			values = interface2.getAdapterId();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// �׷�
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 6, 7));
			values = interface2.getInterfaceGroup();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// ���������ð�
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 8, 9));
			values = interface2.getUpdateTimestamp() == null ? "" : interface2.getUpdateTimestamp().toString();
			cell = row.createCell(c += 2);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// �������ð�
			writeSheet.addMergedRegion(new CellRangeAddress(i, i, 10, 11));
			values = interface2.getUsedTimestamp() == null ? "" : interface2.getUsedTimestamp().toString();
			cell = row.createCell(c += 2);
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
		cell = row.createCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(sum);

		workbook.write(outputStream);

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