/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.openapi.logstats ;

import java.io.File;
import java.io.FileInputStream ;
import java.io.OutputStream ;
import java.net.URLEncoder ;
import java.util.List ;
import java.util.Objects ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.lang3.time.FastDateFormat ;
import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;
import org.apache.poi.ss.usermodel.BorderStyle ;
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
import org.apache.poi.ss.util.CellRangeAddress ;
import org.apache.poi.xssf.usermodel.XSSFCellStyle ;
import org.apache.poi.xssf.usermodel.XSSFColor ;
import org.springframework.stereotype.Component ;
import org.springframework.web.multipart.MultipartFile ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.imanager.CommonTools;
import com.inzent.igate.imanager.EntityExportImportBean ;
import com.inzent.igate.repository.log.LogStats ;
import com.inzent.imanager.message.MessageGenerator;


/**
 * <code>LogStatsExcelImpl</code>
 *
 * @since 2020. 7. 7.
 * @version 5.0
 * @author jkh
 */
@Component
public class LogStatsExportImport implements EntityExportImportBean<LogStats>
{
  protected final Log logger = LogFactory.getLog(getClass()) ; 

  @Override
  public void exportList(HttpServletRequest request, HttpServletResponse response, LogStats entity, List<LogStats> list) throws Exception
  {
    StringBuffer sb = new StringBuffer().append(getStatsTypeName(entity)).append("_TranStats_") ;

    switch (entity.getStatsFilter())
    {
    case LogStatsRepository.FILTER_ADAPTER :
      if (!StringUtils.isBlank(entity.getPk().getAdapterId()))
        sb.append('_').append(entity.getPk().getAdapterId()) ;
      break ;

    case LogStatsRepository.FILTER_INTERFACE :
    case LogStatsRepository.FILTER_SERVICE :
      if (!StringUtils.isBlank(entity.getPk().getInterfaceServiceId()))
        sb.append('_').append(entity.getPk().getInterfaceServiceId()) ;
      break ;

    default :
      break ;
    }

    String[] dates = getDateTimeFormat(entity) ;
    sb.append('_').append(dates[0]).append('-').append(dates[1]).append(".xlsx") ; 

    String fileName = sb.toString() ;

    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
    response.setContentType("application/octet-stream") ;
    
    switch (entity.getStatsClass())
    {
    case LogStatsRepository.CLASS_DB :
      generateDownloadDB(response.getOutputStream(), request.getServletContext().getRealPath("/template/LogsStats" + entity.getStatsClass() + "_" + entity.getStatsFilter() + ".xlsx"), entity, list) ;
      break ;

    default :
      generateDownload(response.getOutputStream(), request.getServletContext().getRealPath("/template/LogsStats" + entity.getStatsClass() + "_" + entity.getStatsFilter() + ".xlsx"), entity, list) ;
      break ;
    }

    response.flushBuffer() ;
  }

  @Override
  public void exportObject(HttpServletRequest request, HttpServletResponse response, LogStats entity) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  @Override
  public LogStats importObject(MultipartFile multipartFile) throws Exception
  {
    throw new UnsupportedOperationException() ;
  }

  protected String getStatsTypeName(LogStats entity)
  {
    switch (entity.getPk().getStatsType())
    {
    case LogStats.STATS_ONLINE_INTERFACE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.1.onlineInterface", "Online Interface") ;

    case LogStats.STATS_ONLINE_SERVICE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.2.onlineService", "Online Service") ;

    case LogStats.STATS_FILE_INTERFACE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.4.fileInterface", "File Interface") ;

    case LogStats.STATS_FILE_SERVICE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.5.fileService", "File Service") ;

    case LogStats.STATS_DB_INTERFACE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.7.dbInterface", "DB Interface") ;

    case LogStats.STATS_DB_SERVICE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.8.dbService", "DB Service") ;

    default :
      switch (entity.getStatsClass())
      {
      case LogStatsRepository.CLASS_ONLINE :
        return MessageGenerator.getMessage("igate.logStatistics.statsType.0.online", "Online") ;

      case LogStatsRepository.CLASS_FILE :
        return MessageGenerator.getMessage("igate.logStatistics.statsType.3.file", "File") ;

      case LogStatsRepository.CLASS_DB :
        return MessageGenerator.getMessage("igate.logStatistics.statsType.6.db", "DB") ;

      default :
        return MessageGenerator.getMessage("head.all", "All") ;
      }
    }
  }

  protected String[] getDateTimeFormat(LogStats entity)
  {
    switch (entity.getSearchType())
    {
    case LogStatsRepository.SEARCH_MINUTE :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd HH:mm").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd HH:mm").format(entity.getToDateTime()) } ;

    case LogStatsRepository.SEARCH_HOUR :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd HH:00").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd HH:59").format(entity.getToDateTime()) } ;

    case LogStatsRepository.SEARCH_DAILY :
    default :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd").format(entity.getToDateTime()) } ;
    }
  }

  /**
   * Excel 파일 생성
   * @param request
   * @param logStats
   * @param logStatsList
   * @return
   * @author jkh, 2020. 7. 10.
   * @throws Exception 
   */
  protected void generateDownload(OutputStream outputStream, String templateFile, LogStats logStats, List<LogStats> logStatsList) throws Exception
  {  
    Workbook workbook ;
    try (FileInputStream fileInputStream = new FileInputStream(new File(templateFile)))
    {
      workbook = WorkbookFactory.create(fileInputStream) ;
    }

    boolean typeFlag = false;
    switch(logStats.getStatsFilter())
    {
    	case LogStatsRepository.FILTER_ADAPTER:
    		typeFlag = true;
    		break;
    	default: 
    	   	break;
    }
    Row row = null ;
    Cell cell = null ;
    String values = null ;
    String[] valuseList = null ;

    Sheet writeSheet = workbook.getSheetAt(0) ;

    // Cell 스타일 지정.
    CellStyle cellStyle_Base = getBaseCellStyle(workbook) ;
    CellStyle cellStyle_Info = getInfoCellStyle(workbook) ;

    // 조회 일자 from
    valuseList = getDateTimeFormat(logStats) ;
    values = valuseList[0] ;
    row = writeSheet.getRow(3) ;
    cell = row.createCell(1) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // 조회 일자 to
    values = valuseList[1] ;
    row = writeSheet.getRow(3) ;
    cell = row.createCell(3) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    int nextCell = 1;
    switch (logStats.getStatsFilter())
    {
    case LogStatsRepository.FILTER_DAILY:
    case LogStatsRepository.FILTER_ADAPTER :
      // 구분
      values = getStatsTypeName(logStats) ;
      row = writeSheet.getRow(4) ;
      cell = row.createCell(nextCell) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      nextCell += 2;
      break ;
     default: 
	   	break;
    }
    
    // 조회타입
    values = logStats.getSearchType().equals(LogStatsRepository.SEARCH_DAILY) ? MessageGenerator.getMessage("igate.logStatistics.daily", "Daily") : logStats.getSearchType().equals(LogStatsRepository.SEARCH_HOUR) ? MessageGenerator.getMessage("igate.logStatistics.hour", "Hour") : MessageGenerator.getMessage("igate.logStatistics.minute", "Minute") ;
    row = writeSheet.getRow(4) ;
    cell = row.createCell(nextCell) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    nextCell+=2;
    
    switch (logStats.getStatsFilter())
    {
    case LogStatsRepository.FILTER_ADAPTER :
      values = logStats.getPk().getAdapterId() ;
      cell = row.createCell(nextCell) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
    case LogStatsRepository.FILTER_INTERFACE :
    case LogStatsRepository.FILTER_SERVICE :
      values = logStats.getPk().getInterfaceServiceId() ;
      cell = row.createCell(nextCell) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
     default: 
	   	break;
    }

    // 조회리스트 입력
    long requestSum = 0, successSum = 0, exceptionSum = 0, timeoutSum = 0 ;
    int i = 6 ;
    for (LogStats logStats2 : logStatsList)
    {
      row = writeSheet.createRow(i) ;
      int c = 0 ;
      // logDateTime
      values = logStats2.getPk().getLogDateTime() ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

      switch (logStats.getStatsFilter())
      {
      case LogStatsRepository.FILTER_DAILY :
        values = getStatsTypeName(logStats2) ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
    	
    	break;  
      case LogStatsRepository.FILTER_ADAPTER :
        values = getStatsTypeName(logStats2) ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;

        values = logStats2.getPk().getAdapterId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      case LogStatsRepository.FILTER_INTERFACE :
      case LogStatsRepository.FILTER_SERVICE :
        values = logStats2.getPk().getInterfaceServiceId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      default: 
  	   	break;
      }

      // request
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getRequestCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // success
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getSuccessCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // exception
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getExceptionCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // timeout
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getTimeoutCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

  	  // 평균 처리 시간
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getResponseTotal())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // 최대 처리 시간
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getResponseMax())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
		
      switch (logStats.getStatsClass())
      {
        case LogStatsRepository.CLASS_FILE : 
          // 평균 파일 크기
          values = CommonTools.numberWithComma(String.valueOf(getFileSize(logStats2.getFileSizeTotal()))) ;
          cell = row.createCell(c++) ;
          cell.setCellStyle(cellStyle_Base) ;
          cell.setCellValue(values) ;
          // 최대 파일 크기
          values = CommonTools.numberWithComma(String.valueOf(getFileSize(logStats2.getFileSizeMax()))) ;
          cell = row.createCell(c++) ;
          cell.setCellStyle(cellStyle_Base) ;
          cell.setCellValue(values) ;
    	 break;
        default: 
    	   	break;

      }
      
      requestSum += logStats2.getRequestCount() ;
      successSum += logStats2.getSuccessCount() ;
      exceptionSum += logStats2.getExceptionCount() ;
      timeoutSum += logStats2.getTimeoutCount() ;

      i++ ;
    }
    // 합계
    row = writeSheet.createRow(i) ;
    writeSheet.addMergedRegion(new CellRangeAddress(i, i, 0, typeFlag ? 2 : 1)) ;

    values = MessageGenerator.getMessage("head.total", "Total") ;
    cell = row.createCell(0) ;
    cell.setCellStyle(cellStyle_Info) ;
    cell.setCellValue(values) ;
    cell = row.createCell(1) ;
    cell.setCellStyle(cellStyle_Info) ;
    cell = row.createCell(2) ;
    cell.setCellStyle(cellStyle_Info) ;

    i = typeFlag ? 3 : 2 ;

    // requestSum
    values = CommonTools.numberWithComma(Long.toString(requestSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // successSum
    values = CommonTools.numberWithComma(Long.toString(successSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // exceptionSum
    values = CommonTools.numberWithComma(Long.toString(exceptionSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // timeoutSum
    values = CommonTools.numberWithComma(Long.toString(timeoutSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    workbook.write(outputStream) ;
  }
  
  /**
   * DB Excel 파일 생성
   * @param request
   * @param logStats
   * @param logStatsList
   * @return
   * @author myj, 2022. 6. 14.
   * @throws Exception 
   */
  protected void generateDownloadDB(OutputStream outputStream, String templateFile, LogStats logStats, List<LogStats> logStatsList) throws Exception
  {
    Workbook workbook ;
    try (FileInputStream fileInputStream = new FileInputStream(templateFile))
    {
      workbook = WorkbookFactory.create(fileInputStream) ;
    }

    boolean typeFlag = Objects.equals(logStats.getStatsFilter(), LogStatsRepository.FILTER_ADAPTER) ;
    Row row = null ;
    Cell cell = null ;
    String values = null ;
    String[] valuseList = null ;

    Sheet writeSheet = workbook.getSheetAt(0) ;

    // Cell 스타일 지정.
    CellStyle cellStyle_Base = getBaseCellStyle(workbook) ;
    CellStyle cellStyle_Info = getInfoCellStyle(workbook) ;

    // 조회 일자 from
    valuseList = getDateTimeFormat(logStats) ;
    values = valuseList[0] ;
    row = writeSheet.getRow(3) ;
    cell = row.createCell(1) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // 조회 일자 to
    values = valuseList[1] ;
    row = writeSheet.getRow(3) ;
    cell = row.createCell(3) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    int nextCell = 1;
    switch (logStats.getStatsFilter())
    {
    case LogStatsRepository.FILTER_DAILY:
    case LogStatsRepository.FILTER_ADAPTER :
      // 구분
      values = getStatsTypeName(logStats) ;
      row = writeSheet.getRow(4) ;
      cell = row.createCell(1) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      nextCell += 2;
      break ;
    default: 
	   	break;
    }

    // 조회타입
    values = logStats.getSearchType().equals(LogStatsRepository.SEARCH_DAILY) ? MessageGenerator.getMessage("igate.logStatistics.daily", "Daily") : logStats.getSearchType().equals(LogStatsRepository.SEARCH_HOUR) ? MessageGenerator.getMessage("igate.logStatistics.hour", "Hour") : MessageGenerator.getMessage("igate.logStatistics.minute", "Minute") ;
    row = writeSheet.getRow(4) ;
    cell = row.createCell(nextCell) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    nextCell += 2;

    switch (logStats.getStatsFilter())
    {
    case LogStatsRepository.FILTER_ADAPTER :
      values = logStats.getPk().getAdapterId() ;
      cell = row.createCell(nextCell) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
    case LogStatsRepository.FILTER_INTERFACE :
    case LogStatsRepository.FILTER_SERVICE :
      values = logStats.getPk().getInterfaceServiceId() ;
      cell = row.createCell(nextCell) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
    default: 
	   	break;
    }

	// 조회리스트 입력
    long requestSum = 0, successSum = 0, exceptionSum = 0, msgSuccessSum = 0, msgExceptionSum = 0, dbRequestSum = 0, dbSuccessSum = 0, dbExceptionSum = 0 ;
    int i = 7 ;
    for (LogStats logStats2 : logStatsList)
    {
      row = writeSheet.createRow(i) ;
      int c = 0 ;
      // logDateTime
      values = logStats2.getPk().getLogDateTime() ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

      switch (logStats.getStatsFilter())
      {
      case LogStatsRepository.FILTER_DAILY:
        values = getStatsTypeName(logStats2) ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        
        break;
      case LogStatsRepository.FILTER_ADAPTER :
        values = getStatsTypeName(logStats2) ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
          
    	values = logStats2.getPk().getAdapterId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      case LogStatsRepository.FILTER_INTERFACE :
      case LogStatsRepository.FILTER_SERVICE :
        values = logStats2.getPk().getInterfaceServiceId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      default: 
  	   	break;
      }

      // request
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getRequestCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // success
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getSuccessCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // exception
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getExceptionCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      // message
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getMessageSuccessCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getMessageExceptionCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      // data row
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getDbRequestRowCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getDbSuccessRowCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getDbExceptionRowCount())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      
      // 평균 처리 시간
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getResponseTotal())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // 최대 처리 시간
      values = CommonTools.numberWithComma(String.valueOf(logStats2.getResponseMax())) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

      requestSum += logStats2.getRequestCount() ;
      successSum += logStats2.getSuccessCount() ;
      exceptionSum += logStats2.getExceptionCount() ;
      msgSuccessSum += logStats2.getMessageSuccessCount();
      msgExceptionSum += logStats2.getMessageExceptionCount();
      dbRequestSum += logStats2.getDbRequestRowCount();
      dbSuccessSum += logStats2.getDbSuccessRowCount();
      dbExceptionSum += logStats2.getDbExceptionRowCount();
      
      i++ ;
    }
    // 합계
    row = writeSheet.createRow(i) ;
    writeSheet.addMergedRegion(new CellRangeAddress(i, i, 0, typeFlag ? 2 : 1)) ;

    values = MessageGenerator.getMessage("head.total", "Total") ;
    cell = row.createCell(0) ;
    cell.setCellStyle(cellStyle_Info) ;
    cell.setCellValue(values) ;
    cell = row.createCell(1) ;
    cell.setCellStyle(cellStyle_Info) ;
    cell = row.createCell(2) ;
    cell.setCellStyle(cellStyle_Info) ;

    i = typeFlag ? 3 : 2 ;

    // requestSum
    values = CommonTools.numberWithComma(Long.toString(requestSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // successSum
    values = CommonTools.numberWithComma(Long.toString(successSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    // exceptionSum
    values = CommonTools.numberWithComma(Long.toString(exceptionSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    
    //msg sum
    values = CommonTools.numberWithComma(Long.toString(msgSuccessSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    values = CommonTools.numberWithComma(Long.toString(msgExceptionSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    //db sum
    values = CommonTools.numberWithComma(Long.toString(dbRequestSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    values = CommonTools.numberWithComma(Long.toString(dbSuccessSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    values = CommonTools.numberWithComma(Long.toString(dbExceptionSum)) ;
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;
    
    workbook.write(outputStream) ;
  }

  /**
   * getBaseFont
   * 
   * 기본 폰트 
   * @param workbook
   * @param size
   * @param color
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public Font getBaseFont(Workbook workbook, int size, short color)
  {
    // 폰트
    Font font = workbook.createFont() ;
    font.setFontHeight((short) (20 * size)) ;
    font.setFontName("굴림") ;
    font.setColor(color);
    return font;
  }

  /**
   * getBaseCellStyle
   * 
   * 기본 Cell 스타일
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public XSSFCellStyle getBaseCellStyle(Workbook workbook)
  {
    // Cell 스타일 지정.
    XSSFCellStyle cellStyle = (XSSFCellStyle) workbook.createCellStyle() ;
    // 텍스트 맞춤(세로가운데)
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;
    // 텍스트 맞춤 (가로 가운데)
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;

    // 폰트 지정 사이즈 10
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex())) ;

    // Cell 테두리 (점선)
    cellStyle.setBorderTop(BorderStyle.HAIR) ;
    cellStyle.setBorderBottom(BorderStyle.HAIR) ;
    cellStyle.setBorderLeft(BorderStyle.HAIR) ;
    cellStyle.setBorderRight(BorderStyle.HAIR) ;

    // Cell 잠금
    cellStyle.setLocked(true) ;
    // Cell 에서 Text 줄바꿈 활성화
    cellStyle.setWrapText(true) ;

    return cellStyle ;
  }

  /**
   * getInfoCellStyle
   * 
   * 항목 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public XSSFCellStyle getInfoCellStyle(Workbook workbook)
  {
    XSSFCellStyle cellStyle = getBaseCellStyle(workbook) ;
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;

    // 폰트 지정 사이즈 (굵게)
    Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex()) ;
    font.setBold(true) ;
    cellStyle.setFont(font) ;

    cellStyle.setFillForegroundColor(new XSSFColor(new byte[] { (byte) 242, (byte) 242, (byte) 242 }, null)) ;
    cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND) ;
    return cellStyle ;
  }
  
  public long getFileSize(long fileSize)
  {
	  long rtn = 0;
	  
	  if(fileSize > 0) {
		  rtn = Math.round(fileSize / 1024.0);
		  if(rtn <= 0) rtn = 1;
	  }
	  
	  return rtn;
  }
}
