/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.logstats ;

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
import org.apache.commons.text.WordUtils ;
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

import com.fasterxml.jackson.core.JsonEncoding ;
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
public class LogStatsDownloadExcel implements LogStatsDownloadBean
{
  protected final Log logger = LogFactory.getLog(getClass()) ; 

  @Override
  public void downloadStats(HttpServletRequest request, HttpServletResponse response, String type, LogStats logStats, List<LogStats> logStatsList) throws Exception
  {
    StringBuffer sb = new StringBuffer().append(WordUtils.capitalize(type)).append('_').append(getStatsTypeName(logStats)).append("_TranStats_") ;

    switch (type)
    {
    case LogStatsRepository.ADAPTER :
      if (!StringUtils.isBlank(logStats.getPk().getAdapterId()))
        sb.append('_').append(logStats.getPk().getAdapterId()) ;
      break ;

    case LogStatsRepository.INTERFACE :
    case LogStatsRepository.SERVICE :
      if (!StringUtils.isBlank(logStats.getPk().getInterfaceServiceId()))
        sb.append('_').append(logStats.getPk().getInterfaceServiceId()) ;
      break ;
    }

    String[] dates = getDateTimeFormat(logStats) ;
    sb.append('_').append(dates[0]).append('-').append(dates[1]).append(".xlsx") ; 

    String fileName = sb.toString() ;

    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate") ;
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + URLEncoder.encode(fileName, JsonEncoding.UTF8.getJavaName()).replaceAll("\\+", "%20")) ;
    response.setContentType("application/octet-stream") ;

    generateDownload(response.getOutputStream(), type, request.getServletContext().getRealPath("/template/LogsStats" + WordUtils.capitalize(type) + ".xlsx"), logStats, logStatsList) ;

    response.flushBuffer() ;
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
  protected void generateDownload(OutputStream outputStream, String type, String templateFile, LogStats logStats, List<LogStats> logStatsList) throws Exception
  {
    Workbook workbook ;
    try (FileInputStream fileInputStream = new FileInputStream(templateFile))
    {
      workbook = WorkbookFactory.create(fileInputStream) ;
    }

    boolean typeFlag = !Objects.equals(type, LogStatsRepository.DAILY) ;
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

    // 구분
    values = getStatsTypeName(logStats) ;
    row = writeSheet.getRow(4) ;
    cell = row.createCell(1) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    // 조회타입
    values = logStats.getSearchType().equals(LogStatsRepository.SEARCHTYPE_DAILY) ? MessageGenerator.getMessage("igate.logStatistics.daily", "Daily") : logStats.getSearchType().equals(LogStatsRepository.SEARCHTYPE_HOUR) ? MessageGenerator.getMessage("igate.logStatistics.hour", "Hour") : MessageGenerator.getMessage("igate.logStatistics.minute", "Minute") ;
    row = writeSheet.getRow(4) ;
    cell = row.createCell(3) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(values) ;

    switch (type)
    {
    case LogStatsRepository.ADAPTER :
      values = logStats.getPk().getAdapterId() ;
      cell = row.createCell(5) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
    case LogStatsRepository.INTERFACE :
    case LogStatsRepository.SERVICE :
      values = logStats.getPk().getInterfaceServiceId() ;
      cell = row.createCell(5) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      break ;
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
      // statsType
      values = getStatsTypeName(logStats2) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

      switch (type)
      {
      case LogStatsRepository.ADAPTER :
        values = logStats2.getPk().getAdapterId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      case LogStatsRepository.INTERFACE :
      case LogStatsRepository.SERVICE :
        values = logStats2.getPk().getInterfaceServiceId() ;
        cell = row.createCell(c++) ;
        cell.setCellStyle(cellStyle_Base) ;
        cell.setCellValue(values) ;
        break ;
      }

      // request
      values = String.valueOf(logStats2.getRequestCount()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // success
      values = String.valueOf(logStats2.getSuccessCount()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // exception
      values = String.valueOf(logStats2.getExceptionCount()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // timeout
      values = String.valueOf(logStats2.getTimeoutCount()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // 평균 처리 시간
      values = String.valueOf(logStats2.getResponseTotal()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;
      // 최대 처리 시간
      values = String.valueOf(logStats2.getResponseMax()) ;
      cell = row.createCell(c++) ;
      cell.setCellStyle(cellStyle_Base) ;
      cell.setCellValue(values) ;

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
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(requestSum) ;
    // successSum
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(successSum) ;
    // exceptionSum
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(exceptionSum) ;
    // timeoutSum
    cell = row.createCell(i++) ;
    cell.setCellStyle(cellStyle_Base) ;
    cell.setCellValue(timeoutSum) ;

    workbook.write(outputStream) ;
  }

  public String[] getDateTimeFormat(LogStats entity)
  {
    switch (entity.getSearchType())
    {
    case LogStatsRepository.SEARCHTYPE_DAILY :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd 00:00").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd 23:59").format(entity.getToDateTime()) } ;

    case LogStatsRepository.SEARCHTYPE_HOUR :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd HH:00").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd HH:59").format(entity.getToDateTime()) } ;

    default :
      return new String[] { FastDateFormat.getInstance("yyyy-MM-dd HH:mm").format(entity.getFromDateTime()), FastDateFormat.getInstance("yyyy-MM-dd HH:mm").format(entity.getToDateTime()) } ;
    }
  }

  public String getStatsTypeName(LogStats entity)
  {
    switch (entity.getPk().getStatsType())
    {
    case LogStatsRepository.STATSDATATYPE_ONLINE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.0.online", "Online") ;

    case LogStatsRepository.STATSDATATYPE_FILE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.3.file", "File") ;

    case LogStatsRepository.STATSDATATYPE_ONLINEINTERFACE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.1.onlineInterface", "Online Interface") ;

    case LogStatsRepository.STATSDATATYPE_ONLINESERVICE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.2.onlineService", "Online Service") ;

    case LogStatsRepository.STATSDATATYPE_FILE_INTERFACE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.4.fileInterface", "File Interface") ;

    case LogStatsRepository.STATSDATATYPE_FILE_SERVICE :
      return MessageGenerator.getMessage("igate.logStatistics.statsType.5.fileService", "File Service") ;

    default :
      return MessageGenerator.getMessage("head.all", "All") ;
    }
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
}
