package com.inzent.igate.openapi.entity.externalLine;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.inzent.igate.repository.meta.Connector;
import com.inzent.igate.repository.meta.ExternalConnector;
import com.inzent.igate.repository.meta.ExternalConnectorPK;
import com.inzent.igate.repository.meta.ExternalLine;
import com.inzent.imanager.message.MessageGenerator;

@Component
public class ExternalLineUploadImpl implements ExternalLineUploadBean {

	@Override
	public List<ExternalLine> getExcelUpload(MultipartFile uploadFile) throws Exception {
		List<ExternalLine> result = new LinkedList<ExternalLine>();
		String extension = FilenameUtils.getExtension(uploadFile.getOriginalFilename());
		if (!extension.equals("xlsx") && !extension.equals("xls")) {
			throw new IOException("!!" + extension);
		}

		Workbook workbook = null;

		// 확장자가 xlsx 인지 xls 인지 구분
		if (extension.equals("xlsx")) {
			workbook = new XSSFWorkbook(uploadFile.getInputStream());
		} else if (extension.equals("xls")) {
			workbook = new HSSFWorkbook(uploadFile.getInputStream());
		}

		Sheet worksheet = workbook.getSheetAt(0);

		int rows = worksheet.getPhysicalNumberOfRows();

		ExternalLine externalLine = new ExternalLine();
		ExternalConnector externalConnector = new ExternalConnector();
		ExternalConnectorPK connectorPK = new ExternalConnectorPK();
		List<ExternalConnector> connectorList = new LinkedList();
		String externalLineId = "";

		for (int rowindex = 2; rowindex < rows; rowindex++) {
			String regex = "^[a-zA-Z0-9_]*$"; // ID 체크 정규식
			Row row = worksheet.getRow(rowindex);
			Cell cell;
			
			// id
			cell = row.getCell(0);
			if(!isMergedCell(worksheet, cell)) {
				externalLine = new ExternalLine();
				connectorList = new LinkedList();
				externalLineId = "";
			}
			
			if ( (cell != null && !cell.getCellType().equals(CellType.BLANK))) {
				externalLine = new ExternalLine();
				connectorList = new LinkedList();

				externalLine.setExternalConnectors(connectorList);
				result.add(externalLine);

				switch (cell.getCellType()) {
				case STRING:
					if (cell.getStringCellValue().matches(regex) == false) // ID 체크 정규식
						return result;
					externalLine.setExternalLineId(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setExternalLineId(new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}
				
				externalLineId = externalLine.getExternalLineId();

				// 이름
				cell = row.getCell(1);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setExternalLineName(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setExternalLineName(new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}

				// 내부회선담당자
				cell = row.getCell(2);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setInternalNetworkManager(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setInternalNetworkManager(
							new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}

				// 내부업무당담자
				cell = row.getCell(3);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setInternalProcessManager(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setInternalProcessManager(
							new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}

				// 외부회선담당자
				cell = row.getCell(4);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setExternalNetworkManager(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setExternalNetworkManager(
							new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}

				// 외부업무담당자
				cell = row.getCell(5);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setExternalProcessManager(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setExternalProcessManager(
							new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}

				// 출력순서
				cell = row.getCell(6);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setDisplayOrder(Integer.parseInt(cell.getStringCellValue()));
					break;
				case NUMERIC:
					externalLine.setDisplayOrder((int) cell.getNumericCellValue());
					break;
				default:
					break;
				}

				// 비고
				cell = row.getCell(7);
				switch (cell.getCellType()) {
				case STRING:
					externalLine.setExternalLineDesc(cell.getStringCellValue());
					break;
				case NUMERIC:
					externalLine.setExternalLineDesc(new DecimalFormat("###.#####").format(cell.getNumericCellValue()));
					break;
				default:
					break;
				}
			}

			externalConnector = new ExternalConnector();
			connectorPK = new ExternalConnectorPK();
			// 커넥터 ID
			cell = row.getCell(8);
			if (cell != null && !externalLineId.isEmpty()) {
				switch (cell.getCellType()) {
				case STRING:
					connectorPK.setExternalLineId(externalLine.getExternalLineId());
					connectorPK.setConnectorId(cell.getStringCellValue());
					externalConnector.setPk(connectorPK);

					// LineMode
					cell = row.getCell(9);
					switch (cell.getCellType()) {
					case STRING:
						if (MessageGenerator.getMessage("igate.connector.requestDirection.both", "Both")
								.equals(cell.getStringCellValue()))
							externalConnector.setLineMode(Connector.DIRECTION_BOTH_WAY);
						else if (MessageGenerator.getMessage("igate.connector.requestDirection.in", "In")
								.equals(cell.getStringCellValue()))
							externalConnector.setLineMode(Connector.DIRECTION_INBOUND);
						else if (MessageGenerator.getMessage("igate.connector.requestDirection.out", "Out")
								.equals(cell.getStringCellValue()))
							externalConnector.setLineMode(Connector.DIRECTION_OUTBOUND);
						break;
					default:
						break;
					}

					connectorList.add(externalConnector);
					break;
				default:
					break;
				}
			}
		}

		return result;
	}

	public static boolean isMergedCell(Sheet sheet, Cell cell) {
		if(sheet == null)
			return false;
		if(cell == null)
			return false;
		
		int numMergedRegions = sheet.getNumMergedRegions();

		for (int i = 0; i < numMergedRegions; i++) {
			CellRangeAddress mergedRegion = sheet.getMergedRegion(i);

			// 현재 셀이 병합 범위 내에 있는지 확인
			if (mergedRegion.isInRange(cell.getRowIndex(), cell.getColumnIndex())) {
				return true;
			}
		}
		return false;
	}
}
