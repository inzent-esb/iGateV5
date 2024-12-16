package com.inzent.igate.openapi.entity.externalline;

import java.io.FileInputStream ;
import java.io.IOException;
import java.io.OutputStream ;
import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle ;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle ;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Font ;
import org.apache.poi.ss.usermodel.HorizontalAlignment ;
import org.apache.poi.ss.usermodel.IndexedColors ;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment ;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle ;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.inzent.igate.imanager.EntityListExportImportBean ;
import com.inzent.igate.repository.meta.Connector;
import com.inzent.igate.repository.meta.ExternalConnector;
import com.inzent.igate.repository.meta.ExternalConnectorPK;
import com.inzent.igate.repository.meta.ExternalLine;
import com.inzent.imanager.message.MessageGenerator;

@Component
public class ExternalLineExportImport implements EntityListExportImportBean<ExternalLine> 
{

  @Override
  public void exportList(HttpServletRequest request, HttpServletResponse response, ExternalLine entity, List<ExternalLine> list) throws Exception
  {
    generateDownload(response, request.getServletContext().getRealPath("/template/List_ExternalLine.xlsx"), entity, list);
    
    response.flushBuffer() ;
  }

  @Override
  public void exportObject(HttpServletRequest request, HttpServletResponse response, ExternalLine entity) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public ExternalLine importObject(MultipartFile multipartFile) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public List<ExternalLine> importObjects(MultipartFile multipartFile) throws Exception
  {
    List<ExternalLine> result = new LinkedList<ExternalLine>();
    String extension = FilenameUtils.getExtension(multipartFile.getOriginalFilename());
    if (!extension.equals("xlsx") && !extension.equals("xls")) 
        throw new IOException("!!" + extension);

    Workbook workbook = null;

    // 확장자가 xlsx 인지 xls 인지 구분
    if (extension.equals("xlsx")) {
        workbook = new XSSFWorkbook(multipartFile.getInputStream());
    } else if (extension.equals("xls")) {
        workbook = new HSSFWorkbook(multipartFile.getInputStream());
    }

    Sheet worksheet = workbook.getSheetAt(0);

    String regex = "^[a-zA-Z0-9_]*$"; // ID 체크 정규식

    ExternalLine externalLine = null ;
    ExternalConnector externalConnector = null;
    ExternalConnectorPK connectorPK = null;
    List<ExternalConnector> connectorList = null ;
    String externalLineId = "";

    Cell cell;

    int rows = worksheet.getPhysicalNumberOfRows();

    for (int rowindex = 2; rowindex < rows; rowindex++) 
    {
        Row row = worksheet.getRow(rowindex);

        // id
        cell = row.getCell(0);
        if(!isMergedCell(worksheet, cell)) 
        {
            externalLine = new ExternalLine() ;
            connectorList = new LinkedList() ;
            externalLineId = "" ;
        }
        
        if ( cell != null && !cell.getCellType().equals(CellType.BLANK))
        {
            externalLine = new ExternalLine() ;
            connectorList = new LinkedList() ;

            externalLine.setExternalConnectors(connectorList) ;
            result.add(externalLine);

            externalLineId = getCellvalue(cell) ;
            if (externalLineId.matches(regex) == false) // ID 체크 정규식
              throw new Exception() ;
            externalLine.setExternalLineId(externalLineId) ;

            // 이름
            externalLine.setExternalLineName(getCellvalue(row.getCell(1))) ;

            // 내부회선담당자
            externalLine.setInternalNetworkManager(getCellvalue(row.getCell(2))) ;

            // 내부업무당담자
            externalLine.setInternalProcessManager(getCellvalue(row.getCell(3))) ;

            // 외부회선담당자
            externalLine.setExternalNetworkManager(getCellvalue(row.getCell(4))) ;

            // 외부업무담당자
            externalLine.setExternalProcessManager(getCellvalue(row.getCell(5))) ;

            // 출력순서
            Object displayOrder = getCellvalue(row.getCell(6)) ;
            externalLine.setDisplayOrder((displayOrder instanceof Integer) ? (int) displayOrder : Integer.parseInt((String) displayOrder)) ;

            // 비고
            externalLine.setExternalLineDesc(getCellvalue(row.getCell(7))) ;
        }

        externalConnector = new ExternalConnector() ;
        connectorPK = new ExternalConnectorPK() ;
        // 커넥터 ID
        cell = row.getCell(8) ;
        if (cell != null && !externalLineId.isEmpty()) {
            switch (cell.getCellType()) {
            case STRING:
                connectorPK.setExternalLineId(externalLine.getExternalLineId()) ;
                connectorPK.setConnectorId(cell.getStringCellValue()) ;
                externalConnector.setPk(connectorPK) ;

                // LineMode
                cell = row.getCell(9);
                switch (cell.getCellType()) {
                case STRING:
                    if (MessageGenerator.getMessage("igate.connector.requestDirection.both", "Both")
                            .equals(cell.getStringCellValue()))
                        externalConnector.setLineMode(Connector.DIRECTION_BOTH_WAY) ;
                    else if (MessageGenerator.getMessage("igate.connector.requestDirection.in", "In")
                            .equals(cell.getStringCellValue()))
                        externalConnector.setLineMode(Connector.DIRECTION_INBOUND) ;
                    else if (MessageGenerator.getMessage("igate.connector.requestDirection.out", "Out")
                            .equals(cell.getStringCellValue()))
                        externalConnector.setLineMode(Connector.DIRECTION_OUTBOUND) ;
                    break ;
                default:
                    break ;
                }

                connectorList.add(externalConnector) ;
                break ;
            default:
                break ;
            }
        }
    }

    return result;
  }

  public static String getCellvalue(Cell cell) {
    if(cell == null)
      return "" ;

    switch (cell.getCellType())
    {
    case STRING :
    case BLANK :
      return cell.getStringCellValue() ;
    case NUMERIC :
      return new DecimalFormat("###.#####").format(cell.getNumericCellValue()) ;
    default:
      break ;
    }
    return "";
  }

  private void generateDownload(HttpServletResponse response, String templateFile, ExternalLine entity, List<ExternalLine> entityList) throws Exception {
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

      // 조회리스트 입력

      int i = 2;
      List<ExternalConnector> connectorList = new LinkedList();
      
      for (ExternalLine externalLineInfo : entityList) {
          row = writeSheet.createRow(i);

          int c = 0;

          connectorList = new LinkedList();
          connectorList = externalLineInfo.getExternalConnectors();
          
          // ID
          values = externalLineInfo.getExternalLineId();
          cell = row.createCell(c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);

          // 이름
          values = externalLineInfo.getExternalLineName();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 내부회선담당자
          values = externalLineInfo.getInternalNetworkManager();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 내부업무담당자
          values = externalLineInfo.getInternalProcessManager();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 외부회선담당자
          values = externalLineInfo.getExternalNetworkManager();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 외부업무담당자
          values = externalLineInfo.getExternalProcessManager();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 출력순서
          values = Integer.toString(externalLineInfo.getDisplayOrder());
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);

          // 비고
          values = externalLineInfo.getExternalLineDesc();
          cell = row.createCell(++c);
          cell.setCellStyle(cellStyle_Base);
          cell.setCellValue(values);
          
          // 대회 회선 커넥터 목록
          if(connectorList.size() > 0) {
              int a = 0;
              for(a = 0; a < connectorList.size(); a++) {
                  ExternalConnector externalConnectorInfo = connectorList.get(a);
                  int d = c;
                  if(writeSheet.getRow(i) == null) {
                      row = writeSheet.createRow(i);                      
                  }else
                      row = writeSheet.getRow(i);
                  
                  // 커넥터 ID
                  values = externalConnectorInfo.getPk().getConnectorId();
                  cell = row.createCell(++d);
                  cell.setCellStyle(cellStyle_Base);
                  cell.setCellValue(values);
                  
                  // LineMode
                  switch (externalConnectorInfo.getLineMode()) {
                  case Connector.DIRECTION_BOTH_WAY:
                      values = MessageGenerator.getMessage("igate.connector.requestDirection.both", "both");
                      break;
                  case Connector.DIRECTION_INBOUND:
                      values = MessageGenerator.getMessage("igate.connector.requestDirection.in", "in");                      
                      break;
                  case Connector.DIRECTION_OUTBOUND:
                      values = MessageGenerator.getMessage("igate.connector.requestDirection.out", "out");
                      break;

                  default:
                      values = "";
                      break;
                  }
                  cell = row.createCell(++d);
                  cell.setCellStyle(cellStyle_Base);
                  cell.setCellValue(values);
                  i++;                            
              }
              int sRow = i-a;
              i--;
              if(sRow < i)
                  for(int s = 0; s <= 7; s++) {
                      CellRangeAddress mergedRegion = new CellRangeAddress(sRow, i, s, s);
                      writeSheet.addMergedRegion(mergedRegion);
                      applyMergedRegionBorders(writeSheet, mergedRegion, cellStyle_Base);
                  }
              
          }else {
              cell = row.createCell(8);
              cell.setCellStyle(cellStyle_Base);
              cell = row.createCell(9);
              cell.setCellStyle(cellStyle_Base);
          }
          i++;
      }

      entityList = null ;
      workbook.write(outputStream);
    }
    catch (Exception e) 
    {
      throw e ;
    }
  }

  public XSSFCellStyle getBaseCellStyle(Workbook workbook) {
    // Cell 스타일 지정
    XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle();

    // 텍스트 맞춤 (세로 가운데)
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);

    // 텍스트 맞춤 (가로 가운데)
    cellStyle.setAlignment(HorizontalAlignment.CENTER);

    // 폰트 지정 사이즈 10
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()));

    // Cell 잠금
    cellStyle.setLocked(true);

    // Cell 에서 Text 줄바꿈 활성화
    cellStyle.setWrapText(true);

    // 테두리 설정
    cellStyle.setBorderTop(BorderStyle.THIN);
    cellStyle.setBorderBottom(BorderStyle.THIN);
    cellStyle.setBorderLeft(BorderStyle.THIN);
    cellStyle.setBorderRight(BorderStyle.THIN);

    // 테두리 색상 설정
    cellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
    cellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
    cellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
    cellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());

    return cellStyle;
  }

  public Font getBaseFont(Workbook workbook, int size, short color) {
    // 폰트
    Font font = workbook.createFont() ;
    font.setFontHeight((short) (20 * size)) ;
    font.setFontName("굴림") ;
    font.setColor(color) ;
    
    return font ;
  }

  private void applyMergedRegionBorders(Sheet sheet, CellRangeAddress region, CellStyle borderStyle) {
    for (int rowNum = region.getFirstRow(); rowNum <= region.getLastRow(); rowNum++) {
        Row row = sheet.getRow(rowNum);
        if (row == null) {
            row = sheet.createRow(rowNum);
        }

        for (int colNum = region.getFirstColumn(); colNum <= region.getLastColumn(); colNum++) {
            Cell cell = row.getCell(colNum);
            if (cell == null) {
                cell = row.createCell(colNum);
            }
            cell.setCellStyle(borderStyle);
        }
    }
  }

  public boolean isMergedCell(Sheet sheet, Cell cell) {
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
