package com.inzent.igate.openapi.entity.record ;

import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.FastDateFormat;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.BorderStyle;
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
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonEncoding;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.imanager.EntityExportImportBean ;
import com.inzent.igate.openapi.entity.record.RecordRepository ;
import com.inzent.igate.repository.meta.Field;
import com.inzent.igate.repository.meta.FieldPK;
import com.inzent.igate.repository.meta.Record;
import com.inzent.imanager.message.MessageGenerator;

@Component
public class RecordExportImport implements EntityExportImportBean<Record> {
	
	@Autowired
	protected RecordRepository recordRepository;

	//	Export List
	@Override
	public void exportList(HttpServletRequest request, HttpServletResponse response, Record entity, List<Record> entityList) throws Exception {
		  String fileName = "Records_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx" ;

		  response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
		  response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
		  response.setContentType("application/octet-stream") ;

		  generateDownload(response, request.getServletContext().getRealPath("/template/List_Record.xlsx"), entity, entityList) ;

		  response.flushBuffer() ;
		
	}
	
	private void generateDownload(HttpServletResponse response, String templateFile, Record entity, List<Record> entityList) throws Exception {
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

			// ID
			values = entity.getRecordId();
			row = writeSheet.getRow(3);
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 이름
			values = entity.getRecordName();
			row = writeSheet.getRow(3);
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 종류
			switch (String.valueOf(entity.getRecordType()).trim()) {
		      case "H" :
		    	  values = MessageGenerator.getMessage("igate.record.type.header", "header");
		    	  break ;
		      case "I" :
			      values = MessageGenerator.getMessage("igate.record.type.indivi", "indivi");
			      break ;
		      case "R" :
		    	  values = MessageGenerator.getMessage("igate.record.type.refer", "refer");
		    	  break ;
		      case "C" :
		    	  values = MessageGenerator.getMessage("igate.record.type.common", "common");
		    	  break ;
		      default: 
		    	  values = "";
		    	  break ;
		    }
			row = writeSheet.getRow(3);
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);
			
			// 그룹
			values = entity.getRecordGroup();
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
			values = entity.getRecordDesc();
			row = writeSheet.getRow(4);
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle_Base);
			cell.setCellValue(values);

			// 조회리스트 입력
			long sum = 0;
			int i = 7;
			for (Record recordInfo : entityList) {
				row = writeSheet.createRow(i);
				int c = 0;

				// ID
				values = recordInfo.getRecordId();
				cell = row.createCell(c);
				cell.setCellStyle(cellStyle_Base);
				cell.setCellValue(values);

				// 이름
				values = recordInfo.getRecordName();
				cell = row.createCell(++c);
				cell.setCellStyle(cellStyle_Base);
				cell.setCellValue(values);
				
				// 종류						
				switch (String.valueOf(recordInfo.getRecordType()).trim()) {
			      case "H" :
			    	  values = MessageGenerator.getMessage("igate.record.type.header", "header");
			    	  break ;
			      case "I" :
				      values = MessageGenerator.getMessage("igate.record.type.indivi", "indivi");
				      break ;
			      case "R" :
			    	  values = MessageGenerator.getMessage("igate.record.type.refer", "refer");
			    	  break ;
			      case "C" :
			    	  values = MessageGenerator.getMessage("igate.record.type.common", "common");
			    	  break ;
			      default: 
			    	  values = "";
			    	  break ;
			    }
								
				cell = row.createCell(++c);
				cell.setCellStyle(cellStyle_Base);
				cell.setCellValue(values);
				
				// 그룹
				values = recordInfo.getRecordGroup();
				cell = row.createCell(++c);
				cell.setCellStyle(cellStyle_Base);
				cell.setCellValue(values);
				
				// 권한
				values = recordInfo.getPrivilegeId();
				cell = row.createCell(++c);
				cell.setCellStyle(cellStyle_Base);
				cell.setCellValue(values);

				// 비고
				writeSheet.addMergedRegion(new CellRangeAddress(i, i, 5, 6));
				values = recordInfo.getRecordDesc();
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
	
	// Export Object
	@Override
	public void exportObject(HttpServletRequest request, HttpServletResponse response, Record entity) throws Exception {
		String fileName = "RecordTemplate_" + FastDateFormat.getInstance("yyyy-MM-dd hh:mm").format(new Timestamp(System.currentTimeMillis())) + ".xlsx";

		response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20"));
		response.setContentType("application/octet-stream");

		try (FileInputStream fileInputStream = new FileInputStream(request.getServletContext().getRealPath("/template/Model_Define.xlsx"));
			 Workbook workbook = WorkbookFactory.create(fileInputStream);
			 OutputStream outputStream = response.getOutputStream()) {
			
			exportExcelSheet(workbook, 0, entity);
			workbook.write(outputStream);
			
		} catch (Exception e) {
			throw e;
		}

		response.flushBuffer();
	}
	
	public void exportExcelSheet(Workbook workbook, int sheetIdx, Record entity)
	{
		Sheet writeSheet = workbook.getSheetAt(sheetIdx);
		Row row = null;
		Cell cell = null;

		CellStyle cellStyle_Base = getBaseCellStyle(workbook);
		
		cellStyle_Base.setBorderTop(BorderStyle.HAIR);
		cellStyle_Base.setBorderLeft(BorderStyle.HAIR);
		cellStyle_Base.setBorderRight(BorderStyle.HAIR);
		cellStyle_Base.setBorderBottom(BorderStyle.HAIR);
				
		row = writeSheet.getRow(1);

		// ID(모델ID)
		cell = row.getCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getRecordId());
		
		// 비고(설명)
		cell = row.getCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getRecordDesc());
		
		// 입&출력 체크
		cell = row.getCell(8);
		String value = null;

		if (entity.getRecordId().endsWith("_I")) 		 value = MessageGenerator.getMessage("label.input", "Input");
		else if (entity.getRecordId().endsWith("_O"))  value = MessageGenerator.getMessage("label.output", "Output");
		else									 value = "";

		cell.setCellValue(value);
		
		// 종류(모델유형)
		cell = row.getCell(10);
	
		if (entity.getRecordType() == Record.TYPE_HEADER) 		value = MetaConstants.EXCEL_HEADER;
		else if (entity.getRecordType() == Record.TYPE_REFER)	value = MetaConstants.EXCEL_REFER;
		else													value = MetaConstants.EXCEL_INDIVI;
	
		cell.setCellValue(value);

		// 이름(모델이름)
		cell = row.getCell(12);
		cell.setCellValue(entity.getRecordName());	
		
		// 메타도메인
		cell = row.getCell(16);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getMetaDomain());

		row = writeSheet.getRow(2);
		
		// 그룹
		cell = row.getCell(1);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getRecordGroup());
				
		// 권한
		cell = row.getCell(3);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getPrivilegeId());
		
		// 옵션
		cell = row.getCell(5);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getRecordOptions());
		
		// Private(전문공유)
		cell = row.getCell(10);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(String.valueOf(entity.getPrivateYn()));
		
		// 개별부경로, 직원번호 생략(iTools 제공)
		
		// 수정 사용자 
		cell = row.getCell(14);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(entity.getUpdateUserId());
		
		// 수정 시각
		cell = row.getCell(17);
		cell.setCellStyle(cellStyle_Base);
		cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(null != entity.getUpdateTimestamp() ? entity.getUpdateTimestamp() : new Date(System.currentTimeMillis())));
		
		exportExcelSheetRows(workbook, writeSheet, entity, 4, 0);
	}

	protected int exportExcelSheetRows(Workbook workbook, Sheet writeSheet, Record entity, int index, int depth) {
		Row row;
		Cell cell;

		// Cell 스타일 지정.
		CellStyle cellStyle = workbook.createCellStyle();
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);// 텍스트 맞춤(세로 가운데)
		cellStyle.setAlignment(HorizontalAlignment.LEFT);// 텍스트 맞춤 (가로 왼쪽)

		Font font = workbook.createFont();// 폰트
		font.setFontHeight((short) 180);
		font.setFontName("굴림");
		font.setBold(false);
		cellStyle.setFont(font);

		cellStyle.setBorderBottom(BorderStyle.THIN);// Cell 테두리 (선)
		cellStyle.setBorderLeft(BorderStyle.THIN);
		cellStyle.setBorderRight(BorderStyle.THIN);
		cellStyle.setBorderTop(BorderStyle.THIN);

		cellStyle.setLocked(true);// Cell 잠금

		for (Field field : entity.getFields()) {
			
			// FIELD_LEVEL
			row = writeSheet.createRow(index);
			cell = row.createCell(0);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(Integer.toString(depth));

			// ID
			String value = field.getPk().getFieldId();
			for (int j = 0; j < depth; j++)
				value = "   " + value;
			cell = row.createCell(1);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(value);

			// 기본정보 > 이름
			cell = row.createCell(2);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldName());

			// 기본정보 > INDEX
			cell = row.createCell(3);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldIndex());

			// 기본정보 > 타입
			cell = row.createCell(4);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(MetaConstants.FIELD_TYPES.get(field.getFieldType()));

			// 기본정보 > 길이
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(Integer.toString(field.getFieldLength()));

			// 기본정보 > 소수
			cell = row.createCell(6);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(Integer.toString(field.getFieldScale()));

			// 반복정보 > 반복타입
			cell = row.createCell(7);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(MetaConstants.FIELD_ARRAYTYPES.get(field.getArrayType()));

			// Reference_FIELD_ID
			cell = row.createCell(8);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getReferenceFieldId());

			// FIELD_DEFAULT_VALUE
			cell = row.createCell(9);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldDefaultValue());

			// FIELD_HIDDEN_YN
			cell = row.createCell(10);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(Character.toString(field.getFieldHiddenYn()));

			// FIELD_REQUIRE YN
			cell = row.createCell(11);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(Character.toString(field.getFieldRequireYn()));

			// FIELD_VALID_VALUE
			cell = row.createCell(12);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldValidValue());

			// FIELD_CODEC_ID
			cell = row.createCell(13);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getCodecId());

			// Options
			cell = row.createCell(14);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldOptions());
			
			cell = row.createCell(15);
			cell.setCellStyle(cellStyle);
			
			cell = row.createCell(16);
			cell.setCellStyle(cellStyle);

			if (field.getFieldType() == Field.TYPE_RECORD && null != field.getRecordObject() && field.getSubRecordId() != null) {
				
				Record subRecord = field.getRecordObject();

				// RECORD_OPTION
				cell = row.createCell(14);
				cell.setCellStyle(cellStyle);
				cell.setCellValue(subRecord.getRecordOptions());

				index++;
				
				if (subRecord.getRecordType() == Record.TYPE_EMBED) {
					index = exportExcelSheetRows(workbook, writeSheet, subRecord, index, depth + 1);
				} else {
					
					cell = row.createCell(15);
					cell.setCellStyle(cellStyle);
					cell.setCellValue("Y");	

					// SUB_RECORD_ID
					cell = row.createCell(16);
					cell.setCellStyle(cellStyle);
					cell.setCellValue(field.getSubRecordId());
				}
			} else {
				index++;
			}
			
			// 비고
			cell = row.createCell(17);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(field.getFieldDesc());
		}

		return index;
	}
		
	// Import Object
	@Override
	public Record importObject(MultipartFile multipartFile) throws Exception {
		Record record = new Record();

		try (OPCPackage opcPackage = OPCPackage.open(multipartFile.getInputStream()); Workbook workbook = new XSSFWorkbook(opcPackage)) {
			record = importExcelSheet(workbook, 0);			
		} catch (Exception e) {
			System.out.println(e);
			throw e;
		}

		return record;
	}
	
	public Record importExcelSheet(Workbook workbook, int sheetIdx) throws Exception
	{
		Record record = new Record();
		
		Sheet sheet = workbook.getSheetAt(sheetIdx);
		Row row = null;
	    Cell cell = null;
	    
		row = sheet.getRow(1);
		
		// ID(모델ID)
		cell = row.getCell(1);
		record.setRecordId(cell.getStringCellValue());
		
		// 비고(설명)
		cell = row.getCell(3);
		record.setRecordDesc(getStringNumericValue(cell));
		
		// 종류(모델유형)
		cell = row.getCell(10);
		switch (getStringNumericValue(cell)) {
		case MetaConstants.EXCEL_HEADER:
			record.setRecordType(Record.TYPE_HEADER);
			break;

		case MetaConstants.EXCEL_REFER:
			record.setRecordType(Record.TYPE_REFER);
			break;

		default:
			record.setRecordType(Record.TYPE_INDIVI);
		}

		// 이름(모델이름)
		cell = row.getCell(12);
		record.setRecordName(getStringNumericValue(cell));
		
		// 메타도메인
		cell = row.getCell(16);
		record.setMetaDomain(getStringNumericValue(cell));
		
		row = sheet.getRow(2);
		
		// 그룹
		cell = row.getCell(1);
		record.setRecordGroup(getStringNumericValue(cell));
		
		// 권한
		cell = row.getCell(3);
		record.setPrivilegeId(getStringNumericValue(cell));
		
		// 옵션
		cell = row.getCell(5);
		record.setRecordOptions(getStringNumericValue(cell));
				
		// Private
		cell = row.getCell(10);
		record.setPrivateYn(getStringNumericValue(cell).charAt(0));
		
		importExcelSheetRows(sheet, record, 4, 0);
	    
		return record;
	}

	protected int importExcelSheetRows(Sheet sheet, Record record, int index, int depth) throws Exception {
		Row row; 
		Cell cell;
		Field field;
		LinkedList<Field> filedList = new LinkedList<>();
		Set<String> duplicateIdList = new TreeSet<>();
		int nVal, idx = 0;

		while (true) {
			row = sheet.getRow(index);

			if (null == row || getStringNumericValue(row.getCell(1)).isEmpty()) break;

			// 필드가 있는 경우, Level 가져오기
			cell = row.getCell(0);
			nVal = Integer.parseInt(getStringNumericValue(cell));

			if (depth < nVal) // 윗줄 필드의 Level < 현재 필드의 Level
			{
				index = importExcelSheetRows(sheet, filedList.getLast().getRecordObject(), index, nVal);
				continue;
			} else if (depth > nVal) // 앞선 필드의 Level > 현재 필드의 Level
				break;

			field = new Field();
			field.setPk(new FieldPK());
			field.getPk().setRecordId(record.getRecordId());
			field.setFieldOrder(idx++) ;
			field.setRecord(record);

			// 필드 ID
			cell = row.getCell(1);
			field.getPk().setFieldId(getStringNumericValue(cell).trim());

			if (duplicateIdList.contains(field.getPk().getFieldId()))
				throw new Exception(MessageGenerator.getMessage("[{0}] 필드 ID가 중복됩니다.", "Duplicate Field ID", field.getPk().getFieldId()));
			else
				duplicateIdList.add(field.getPk().getFieldId());

			// 필드 이름
			cell = row.getCell(2);
			field.setFieldName(getStringNumericValue(cell));

			// 필드 Index
			cell = row.getCell(3);
			field.setFieldIndex(getStringNumericValue(cell));

			// 필드 타입 (오브젝트명)
			cell = row.getCell(4);
			field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell)));

			// 필드 길이
			cell = row.getCell(5);
			field.setFieldLength(Integer.parseInt(getStringNumericValue(cell)));

			// 필드 소수
			cell = row.getCell(6);
			field.setFieldScale(Integer.parseInt(getStringNumericValue(cell)));

			// 반복타입 (배열형태)
			cell = row.getCell(7);
			field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell)));

			// 참조 필드 ID (반복횟수)
			cell = row.getCell(8);
			field.setReferenceFieldId(getStringNumericValue(cell));

			// 필드 기본값
			cell = row.getCell(9);
			field.setFieldDefaultValue(getStringNumericValue(cell));

			// 비공개여부 (마스킹여부)
			cell = row.getCell(10);
			field.setFieldHiddenYn(getStringNumericValue(cell).isEmpty()? 'N': getStringNumericValue(cell).charAt(0));

			// 필수여부
			cell = row.getCell(11);
			field.setFieldRequireYn(getStringNumericValue(cell).isEmpty()? 'N': getStringNumericValue(cell).charAt(0));

			// 유효값
			cell = row.getCell(12);
			field.setFieldValidValue(getStringNumericValue(cell));

			// 변환
			cell = row.getCell(13);
			field.setCodecId(getStringNumericValue(cell));

			// 기타속성
			cell = row.getCell(14);
			field.setFieldOptions(getStringNumericValue(cell));

			if (field.getFieldType() == Field.TYPE_RECORD) {
				Record subRecord = new Record();

				// 참조여부
				cell = row.getCell(15);
				if (getStringNumericValue(cell).equals("Y")) {
					String recordID = getStringNumericValue(row.getCell(16));
					subRecord.setRecordId(recordID);

					try {
						subRecord = recordRepository.get(recordID);
					} catch (Exception e) {
						throw new Exception(MessageGenerator.getMessage("[{0}] 등록되지 않은 참조모델이 있습니다.", "There is an unregistered reference model.", subRecord.getRecordId()));
					}

					subRecord.setRecordType(Record.TYPE_REFER);
					field.setSubRecordId(recordID);
				} else {
					subRecord.setRecordId(record.getRecordId() + "@" + field.getPk().getFieldId());
					subRecord.setPrivilegeId(record.getPrivilegeId());
					subRecord.setRecordType(Record.TYPE_EMBED);
					
		            field.setSubRecordId(subRecord.getRecordId());
				}

				field.setRecordObject(subRecord);

			}
			
			// 비고
			cell = row.getCell(17);
			field.setFieldDesc(getStringNumericValue(cell));

			filedList.add(field);

			index++;
		}

		record.setFields(filedList);

		return index;

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

	protected String getStringNumericValue(Cell cell) {
		if (cell != null)
			try {
				return cell.getStringCellValue();
			} catch (IllegalStateException e) {
				return Integer.toString((int) cell.getNumericCellValue());
			}

		return "";
	}
}
