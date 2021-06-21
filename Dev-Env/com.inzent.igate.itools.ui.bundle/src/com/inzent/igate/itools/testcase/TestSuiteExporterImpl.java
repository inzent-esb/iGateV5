package com.inzent.igate.itools.testcase ;

import java.io.File ;
import java.io.FileOutputStream ;
import java.io.InputStream ;
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
   * TestSuiteScenario list --> TestCase list ����
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
   * TestSuiteResult list --> TestCase Result list ����
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
    
    try (InputStream is = Configuration.getTemplate("TestSuiteResult_Excel.xlsx"))
    {
      workbook = WorkbookFactory.create(is) ;

      File newExcel = new File(path) ;
      Sheet writeSheet = workbook.getSheetAt(0) ;

      String value = null ;         
      CellStyle cellStyle_info = getInfoCellStyle(workbook);

      //===== ���� 2��° �� �� ���� =====
      // ���� 
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

      //===== ���� 4��° �� �� ���� =====
      // �׽�Ʈ ���
      if (TestCaseValidateConstants.TEST_SUITE_RESULTS.containsKey(testSuite.getTestSuiteStatus()))
        value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.TEST_SUITE_RESULTS.get(testSuite.getTestSuiteStatus()).getValue());
      else
        value = Character.toString(testSuite.getTestSuiteStatus());
      
      row = writeSheet.getRow(3) ;
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // �׽�Ʈ ������
      value = testSuite.getTestUserId();
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // �׽�Ʈ �Ͻ�
      value = testSuite.getTestDateTime();
      cell = row.getCell(5) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      //===== ���� 5��° �� �� ���� =====
      // �� �Ǽ�
      value =  Integer.toString(nTotal);
      row = writeSheet.getRow(4) ;
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // ���� �Ǽ�
      value =  Integer.toString(nSucess);
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // ���� �Ǽ�
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
  }

  /**
   * �׽�Ʈ �������Ʈ�� ���� 
   * @param workbook �������� �� ����  workbook
   * @param writeSheet �������� �� ����  Sheet
   * @param result �������� �� ����
   * @param rowindex �׽�Ʈ �������Ʈ ������ �Էµ� ������ ���� row ��ȣ (6)
   * @author kjm, 2020. 5. 19.
   */
  public void exportExcelTestResults(Workbook workbook, Sheet writeSheet, List<TestCase> testCaseResultList, int rowindex)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);   
    CellStyle cellStyleIndention = getIndentionDataCellStyle(workbook);  //�鿩����
    Row row = null ;
    Cell cell = null ;
    String value = null ;
    
    for(TestCase testCase :  testCaseResultList)
    {
      cellStyle = getBoldDataCellStyle(workbook);
      
      //row         
      row = writeSheet.createRow(rowindex) ;
      
      //����  
      value = String.format("%s (%s)", testCase.getPk().toString(), testCase.getTestCaseDesc());
      cell = row.createCell(0) ;
      cell.setCellStyle(cellStyle) ;
      cell.setCellValue(value);
      
      // �׽�Ʈ ���  
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
              cellStyleIndention = getIndentionErrorDataCellStyle(workbook);  //�鿩����
            }
            else
            {
              cellStyle = getDataCellStyle(workbook);
              cellStyleIndention = getIndentionDataCellStyle(workbook);  //�鿩����
            }

            //row         
            row = writeSheet.createRow(rowindex) ;

            //����
               
            value = String.format("\t%s",testCaseResult.getPk().getTestCaseValidateId());
            cell = row.createCell(0) ;
            cell.setCellStyle(cellStyleIndention);
            cell.setCellValue(value);

            //�ʵ�
            value = testCaseValidate.getFieldPath();
            cell = row.createCell(1) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            //�������  
            if (TestCaseValidateConstants.VALIDATE_TYPES.containsKey(testCaseValidate.getValidateMethod()))
              value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.VALIDATE_TYPES.get(testCaseValidate.getValidateMethod()).getValue());
            else
              value = Character.toString(testCaseValidate.getValidateMethod());
            cell = row.createCell(2) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            //��밪
            value = testCaseValidate.getExpectedValue();
            cell = row.createCell(3) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // �׽�Ʈ��    
            value = testCaseResult.getTestValue();
            cell = row.createCell(4) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // �׽�Ʈ ���  
            value = String.valueOf(testCaseResult.getTestResult()=='Y');
            cell = row.createCell(5) ;
            cell.setCellStyle(cellStyle) ;
            cell.setCellValue(value) ;

            // ���� �޼���
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
   * �⺻ ��Ʈ 
   * @param workbook
   * @param size
   * @param color
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public Font getBaseFont(Workbook workbook, int size, short color)
  {
    // ��Ʈ
    Font font = workbook.createFont() ;
    font.setFontHeight((short) (20 * size)) ;
    font.setFontName("����") ;
    font.setColor(color);
    return font;
  }

  /**
   * getBaseCellStyle
   * 
   * �׽�Ʈ ���̽� �⺻ Cell ��Ÿ��
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getBaseCellStyle(Workbook workbook)
  {
    // Cell ��Ÿ�� ����.
    CellStyle cellStyle = workbook.createCellStyle() ;
    // �ؽ�Ʈ ����(���ΰ��)
    cellStyle.setVerticalAlignment(VerticalAlignment.CENTER) ;
    // �ؽ�Ʈ ���� (���� ���)
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;

    //��Ʈ ���� ������ 10
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex())) ; 

    // Cell �׵θ� (����)
    cellStyle.setBorderTop(BorderStyle.HAIR) ;
    cellStyle.setBorderBottom(BorderStyle.HAIR) ;
    cellStyle.setBorderLeft(BorderStyle.HAIR) ;
    cellStyle.setBorderRight(BorderStyle.HAIR) ;

    // Cell ���
    cellStyle.setLocked(true) ; 
    // Cell ���� Text �ٹٲ� Ȱ��ȭ
    cellStyle.setWrapText(true) ; 

    return cellStyle;
  }

  /**
   * getTitileCellStyle
   * 
   * �׽�Ʈ ���̽� ��� title Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getTitileCellStyle(Workbook workbook)
  {      
    CellStyle cellStyle = getBaseCellStyle(workbook);
    cellStyle.setAlignment(HorizontalAlignment.CENTER) ;
    
    //��Ʈ ���� ������ 18
    Font font = getBaseFont(workbook, 18, IndexedColors.BLACK.getIndex());
    font.setBold(true);
    cellStyle.setFont(font);

    // Cell �׵θ� (�β���)
    cellStyle.setBorderTop(BorderStyle.THICK) ;
    cellStyle.setBorderBottom(BorderStyle.THICK) ;
    // Cell �׵θ� (����)
    cellStyle.setBorderLeft(BorderStyle.NONE) ;
    cellStyle.setBorderRight(BorderStyle.NONE) ;

    // Cell ���� Text �ٹٲ� Ȱ��ȭ
    cellStyle.setWrapText(false) ;

    return cellStyle;
  }

  /**
   * getInfoCellStyle
   * 
   * �׽�Ʈ ���̽� ��� ���� Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
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
   * �׽�Ʈ ���̽� ��� ��� ���� Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
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
   * �׽�Ʈ ���̽� ��� ��� ���� Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getBoldDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);
    
    //��Ʈ ���� ������ 10  / bold
    Font font = getBaseFont(workbook, 10, IndexedColors.BLACK.getIndex());
    font.setBold(true);
    cellStyle.setFont(font);
    
    // Cell ���� Text �ٹٲ� ��Ȱ��ȭ
    cellStyle.setWrapText(false) ; 
    
    return cellStyle;
  }

  

  /**
   * getIndentionDataCellStyle
   * 
   * �׽�Ʈ ���̽� ��� ��� ���� Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getIndentionDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);
    
    // Cell���� �鿩���� ����� ����
    cellStyle.setIndention((short) 2); 
    
    return cellStyle;
  }
  
  
  /**
   * getErrorDataCellStyle
   * 
   * �׽�Ʈ ���̽� ��� ��� ���� Cell ��Ÿ��
   * (getDataCellStyle)�� �⺻���� ���� �Ǹ� ���� 
   * @param workbook
   * @return
   * @author kjm, 2020. 4. 23.
   */
  public CellStyle getErrorDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);

    //��Ʈ ���� ������ 10 red
    cellStyle.setFont(getBaseFont(workbook, 10, IndexedColors.RED.getIndex())) ; 
      
    return cellStyle;
  }

  /**
   * getIndentionErrorDataCellStyle
   * 
   * �׽�Ʈ ���̽� ��� ��� ���� Cell ��Ÿ��
   * (getBaseCellStyle)�� �⺻���� ���� �Ǹ� ���� 
   * 
   * @param workbook
   * @return
   * @author kjm, 2020. 5. 19.
   */
  public CellStyle getIndentionErrorDataCellStyle(Workbook workbook)
  {
    CellStyle cellStyle = getErrorDataCellStyle(workbook);
    
    // Cell���� �鿩���� ����� ����
    cellStyle.setIndention((short) 2); 
    
    return cellStyle;
  }
  
  
}
