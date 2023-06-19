package com.inzent.igate.itools.testcase ;

import java.io.ByteArrayInputStream ;
import java.io.File ;
import java.io.FileOutputStream ;
import java.util.ArrayList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.poi.ss.usermodel.BorderStyle ;
import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.CellStyle ;
import org.apache.poi.ss.usermodel.Font ;
import org.apache.poi.ss.usermodel.HorizontalAlignment ;
import org.apache.poi.ss.usermodel.IndexedColors ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.VerticalAlignment ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;

import com.inzent.igate.itools.interfaces.InterfaceActivator ;
import com.inzent.igate.itools.interfaces.utils.TestCaseValidateConstants ;
import com.inzent.igate.itools.interfaces.utils.TestSuiteExporter ;
import com.inzent.igate.itools.utils.Configuration ;
import com.inzent.igate.repository.log.TestCase ;
import com.inzent.igate.repository.log.TestCasePK ;
import com.inzent.igate.repository.log.TestCaseResult ;
import com.inzent.igate.repository.log.TestCaseValidate ;
import com.inzent.igate.repository.log.TestCaseValidatePK ;
import com.inzent.igate.repository.log.TestSuite ;
import com.inzent.igate.repository.log.TestSuiteResult ;
import com.inzent.igate.repository.log.TestSuiteScenario ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;

public class TestSuiteExporterImpl extends TestSuiteExporter
{
  public TestSuiteExporterImpl()
  {
    INSTANCE = this ;
  }

  /**
   * getTestCaseListByScenario
   * 
   * TestSuiteScenario list --> TestCase list 추출
   *  
   * @param scenarioList
   * @return
   * @author kjm, 2020. 5. 15.
   */
  public List<TestCase> getTestCaseListByScenario(TestSuite testSuite)
  {
    List<TestCase> testCaseList = new ArrayList<TestCase>() ;
    
    for(TestSuiteScenario scenario : testSuite.getTestSuiteScenario())
    {
      try
      {
        TestCase searchTestCase = new TestCase();
        TestCasePK pk = new TestCasePK();
        searchTestCase.setPk(pk);
        searchTestCase.getPk().setInterfaceId(scenario.getPk().getInterfaceId());
        searchTestCase.getPk().setTestCaseId(scenario.getPk().getTestCaseId());
        
        TestCase testCase = ClientManager.getInstance().getIManagerClient().get(searchTestCase).getObject();
        testCase.setTestCaseResults(new ArrayList<TestCaseResult> () );
        testCase.setTestCaseStatus(TestCase.TEST_CASE_STATUS_NONE);
        testCase.setTestUserId(null);        
        testCase.setTestDateTime(null);
        
        testCaseList.add(testCase);
      }
      catch (Exception e)
      {
       LogHandler.openError(InterfaceActivator.PLUGIN_ID, e) ;
      }
    }
    return testCaseList;
  }

  
  
  /**
   * getTestCaseListByResult
   * 
   * TestSuiteResult list --> TestCase Result list 추출
   *  
   * @param testCaseList
   * @param scenarioList
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public List<TestCase> getTestCaseListByResult(List<TestCase> testCaseList, TestSuite testSuite)
  {
    for(TestCase testCase : testCaseList)
    {        
      String testCasePKvalue = testCase.getPk().toString();
      testCase.setTestUserId(testSuite.getTestUserId());
      testCase.setTestDateTime(testSuite.getTestDateTime());
      
      List<TestCaseResult> testCaseResultList = new ArrayList<TestCaseResult>() ;
      int testcaseSucess = 0;
      for(TestSuiteResult testSuiteResult :testSuite.getTestSuiteResult())
      {
        if( testCasePKvalue.equals(testSuiteResult.getPk().getInterfaceId()+"@"+testSuiteResult.getPk().getTestCaseId()))
        {
          TestCaseResult testCaseResult = new TestCaseResult();
          testCaseResult.setPk(new TestCaseValidatePK());
          testCaseResult.getPk().setInterfaceId(testSuiteResult.getPk().getInterfaceId());
          testCaseResult.getPk().setTestCaseId(testSuiteResult.getPk().getTestCaseId());
          testCaseResult.getPk().setTestCaseValidateId(testSuiteResult.getPk().getTestCaseValidateId());
          testCaseResult.setTestValue(testSuiteResult.getTestValue());
          testCaseResult.setTestResult(testSuiteResult.getTestResult());
          testCaseResult.setTestMessage(testSuiteResult.getTestMessage());
          testCaseResult.setTestCase(testCase);
          
          testCaseResultList.add(testCaseResult);
          testcaseSucess = (testCaseResult.getTestResult() == 'Y') ? testcaseSucess + 1 : testcaseSucess ;
        }
      }
      testCase.setTestCaseResults(testCaseResultList);
      
      char testResult = ( testCaseResultList.size() >0 ) ?
          ((testcaseSucess == testCaseResultList.size()) ? TestCase.TEST_CASE_STATUS_SUCESS : TestCase.TEST_CASE_STATUS_FAIL )
          : TestCase.TEST_CASE_STATUS_NONE ;

      testCase.setTestCaseStatus(testResult);
    }
    return testCaseList ;
    
  }
    
  public List<TestCase> getTestCaseResultList(TestSuite testSuite)
  {
    return getTestCaseListByResult(getTestCaseListByScenario(testSuite), testSuite);
  }
  
  /**
   * exportExcel
   * @param path
   * @param testSuite
   * @throws Exception
   * @author kjm, 2020. 5. 19.
   * @see com.inzent.igate.itools.interfaces.utils.TestSuiteExporter#exportExcel(java.lang.String, com.inzent.igate.repository.log.TestSuite)
   */
  @Override
  public void exportExcel(String path, TestSuite testSuite) throws Exception
  {
    List<TestCase> testCaseResultList = getTestCaseResultList(testSuite);
    
    Workbook workbook ;
    Row row = null ;
    Cell cell = null ;
    
    int nTotal = 0, nSucess =0, nFail=0;

    nTotal = testCaseResultList.size();
    if(nTotal > 0 )
    {
      for(TestCase testCase : testCaseResultList)
        nSucess = (testCase.getTestCaseStatus() == TestCase.TEST_CASE_STATUS_SUCESS) ? nSucess + 1 : nSucess ;
      nFail = nTotal - nSucess;
    }
    
    workbook = WorkbookFactory.create(new ByteArrayInputStream(Configuration.getTemplate("TestSuiteResult_Excel.xlsx"))) ;

    File newExcel = new File(path) ;
    Sheet writeSheet = workbook.getSheetAt(0) ;

    String value = null ;         
    CellStyle cellStyle_info = getInfoCellStyle(workbook);

    //===== 엑셀 2번째 줄 값 설정 =====
    // 제목 
    CellStyle cellStyle_title = getTitileCellStyle(workbook);
    value = String.format("%s( %s )", testSuite.getTestSuiteId(), testSuite.getTestSuiteDesc());
    row = writeSheet.getRow(1) ;
    for(int index = 0 ; index < 7 ;index ++)
    {
      cell = row.getCell(index) ;
      cell.setCellStyle(cellStyle_title) ;
      if(index ==0)
        cell.setCellValue(value) ;
    }

    //===== 엑셀 4번째 줄 값 설정 =====
    // 테스트 결과
    if (TestCaseValidateConstants.TEST_SUITE_RESULTS.containsKey(testSuite.getTestSuiteStatus()))
      value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.TEST_SUITE_RESULTS.get(testSuite.getTestSuiteStatus()).getValue());
    else
      value = Character.toString(testSuite.getTestSuiteStatus());
    
    row = writeSheet.getRow(3) ;
    cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    // 테스트 수행자
    value = testSuite.getTestUserId();
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    // 테스트 일시
    value = testSuite.getTestDateTime();
    cell = row.getCell(5) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    //===== 엑셀 5번째 줄 값 설정 =====
    // 총 건수
    value =  Integer.toString(nTotal);
    row = writeSheet.getRow(4) ;
    cell = row.getCell(1) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    // 성공 건수
    value =  Integer.toString(nSucess);
    cell = row.getCell(3) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    // 실패 건수
    value =  Integer.toString(nFail);
    cell = row.getCell(5) ;
    cell.setCellStyle(cellStyle_info) ;
    cell.setCellValue(value) ;

    if(testCaseResultList.size() > 0)
      exportExcelTestResults(workbook, writeSheet, testCaseResultList, 6) ;
    

    try (FileOutputStream fileOutputStream = new FileOutputStream(newExcel))
    {
      workbook.write(fileOutputStream) ;
      fileOutputStream.close() ;
    }
  }

  /**
   * 테스트 결과리스트를 생성 
   * @param workbook 내보내기 할 엑셀  workbook
   * @param writeSheet 내보내기 할 엑셀  Sheet
   * @param result 내보내기 할 정보
   * @param rowindex 테스트 결과리스트 정보가 입력될 엑셀의 시작 row 번호 (6)
   * @author kjm, 2020. 5. 19.
   */
  public void exportExcelTestResults(Workbook workbook, Sheet writeSheet, List<TestCase> testCaseResultList, int rowindex)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);   
    CellStyle cellStyleIndention = getIndentionDataCellStyle(workbook);  //들여쓰기
    Row row = null ;
    Cell cell = null ;
    String value = null ;
    
    for(TestCase testCase :  testCaseResultList)
    {
      cellStyle = getBoldDataCellStyle(workbook);
      
      //row         
      row = writeSheet.createRow(rowindex) ;
      
      //제목  
      value = String.format("%s (%s)", testCase.getPk().toString(), testCase.getTestCaseDesc());
      cell = row.createCell(0) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value);
      
      // 테스트 결과  
      value = String.valueOf(TestCaseValidateConstants.TEST_CASE_STATUS_NONE_DESC);
      if (TestCaseValidateConstants.TEST_CASE_RESULTS.containsKey(testCase.getTestCaseStatus()))
        value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.TEST_CASE_RESULTS.get(testCase.getTestCaseStatus()).getValue());
      
      value = String.valueOf(String.format("[%s]", value));
      cell = row.createCell(5) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value) ;
      
      rowindex++ ;
      
      for(TestCaseValidate testCaseValidate :  testCase.getTestCaseValidates())
      { 
        for( TestCaseResult testCaseResult : testCase.getTestCaseResults())
        {
          if( testCaseValidate.getPk().compareTo(testCaseResult.getPk()) == 0 )
          {
            if( !Boolean.valueOf((testCaseResult.getTestResult()=='Y')))
            {
              cellStyle = getErrorDataCellStyle(workbook);
              cellStyleIndention = getIndentionErrorDataCellStyle(workbook);  //들여쓰기
            }
            else
            {
              cellStyle = getDataCellStyle(workbook);
              cellStyleIndention = getIndentionDataCellStyle(workbook);  //들여쓰기
            }

            //row         
            row = writeSheet.createRow(rowindex) ;

            //제목
               
            value = String.format("\t%s",testCaseResult.getPk().getTestCaseValidateId());
            cell = row.createCell(0) ;
            cell.setCellStyle(cellStyleIndention);
            cell.setCellValue(value);

            //필드
            value = testCaseValidate.getFieldPath();
            cell = row.createCell(1) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            //검증방법  
            if (TestCaseValidateConstants.VALIDATE_TYPES.containsKey(testCaseValidate.getValidateMethod()))
              value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.VALIDATE_TYPES.get(testCaseValidate.getValidateMethod()).getValue());
            else
              value = Character.toString(testCaseValidate.getValidateMethod());
            cell = row.createCell(2) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            //기대값
            value = testCaseValidate.getExpectedValue();
            cell = row.createCell(3) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // 테스트값    
            value = testCaseResult.getTestValue();
            cell = row.createCell(4) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // 테스트 결과  
            value = String.valueOf(testCaseResult.getTestResult()=='Y');
            cell = row.createCell(5) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // 오류 메세지
            value = testCaseResult.getTestMessage();
            cell = row.createCell(6) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            rowindex++ ;          
          }
        } 
      } 
      
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
   * 테스트 케이스 기본 Cell 스타일
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getBaseCellStyle(Workbook workbook)
  {
    // Cell 스타일 지정.
    CellStyle cellStyle = workbook.createCellStyle() ;
    // 텍스트 맞춤(세로가운데)
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;
    // 텍스트 맞춤 (가로 가운데)
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;

    //폰트 지정 사이즈 10
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

    return cellStyle;
  }

  /**
   * getTitileCellStyle
   * 
   * 테스트 케이스 결과 title Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getTitileCellStyle(Workbook workbook)
  {      
    CellStyle cellStyle = getBaseCellStyle(workbook);
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;
    
    //폰트 지정 사이즈 18
    Font font = getBaseFont(workbook, 18, IndexedColors.BLACK.getIndex());
    font.setBold(true);
    cellStyle.setFont(font);

    // Cell 테두리 (두꺼운)
    cellStyle.setBorderTop(BorderStyle.THICK) ;
    cellStyle.setBorderBottom(BorderStyle.THICK) ;
    // Cell 테두리 (없는)
    cellStyle.setBorderLeft(BorderStyle.NONE) ;
    cellStyle.setBorderRight(BorderStyle.NONE) ;

    // Cell 에서 Text 줄바꿈 활성화
    cellStyle.setWrapText(false) ;

    return cellStyle;
  }

  /**
   * getInfoCellStyle
   * 
   * 테스트 케이스 결과 정보 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getInfoCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getBaseCellStyle(workbook);
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;

    return cellStyle;
  }


  /**
   * getDataCellStyle
   * 
   * 테스트 케이스 결과 목록 정상 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getBaseCellStyle(workbook);
    cellStyle.setAlignment(HorizontalAlignment.LEFT) ;

    return cellStyle;
  }


  /**
   * getBoldDataCellStyle
   * 
   * 테스트 케이스 결과 목록 정상 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getBoldDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);
    
    //폰트 지정 사이즈 10  / bold
    Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex());
    font.setBold(true);
    cellStyle.setFont(font);
    
    // Cell 에서 Text 줄바꿈 비활성화
    cellStyle.setWrapText(false) ; 
    
    return cellStyle;
  }

  

  /**
   * getIndentionDataCellStyle
   * 
   * 테스트 케이스 결과 목록 정상 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getIndentionDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);
    
    // Cell에서 들여쓰기 공백수 지정
    cellStyle.setIndention((short) 2); 
    
    return cellStyle;
  }
  
  
  /**
   * getErrorDataCellStyle
   * 
   * 테스트 케이스 결과 목록 오류 Cell 스타일
   * (getDataCellStyle)을 기본으로 변경 건만 설정 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getErrorDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);

    //폰트 지정 사이즈 10 red
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.RED.getIndex())) ; 
      
    return cellStyle;
  }

  /**
   * getIndentionErrorDataCellStyle
   * 
   * 테스트 케이스 결과 목록 정상 Cell 스타일
   * (getBaseCellStyle)을 기본으로 변경 건만 설정 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getIndentionErrorDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getErrorDataCellStyle(workbook);
    
    // Cell에서 들여쓰기 공백수 지정
    cellStyle.setIndention((short) 2); 
    
    return cellStyle;
  }
  
  
}
