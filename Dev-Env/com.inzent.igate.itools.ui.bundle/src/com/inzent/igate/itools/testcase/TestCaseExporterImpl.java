package com.inzent.igate.itools.testcase ;

import java.io.File ;
import java.io.FileOutputStream ;
import java.io.InputStream ;

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

import com.inzent.igate.itools.interfaces.utils.TestCaseExporter ;
import com.inzent.igate.itools.interfaces.utils.TestCaseValidateConstants ;
import com.inzent.igate.itools.utils.Configuration ;
import com.inzent.igate.repository.log.TestCase ;
import com.inzent.igate.repository.log.TestCaseResult ;
import com.inzent.igate.repository.log.TestCaseValidate ;

public class TestCaseExporterImpl extends TestCaseExporter
{
  public TestCaseExporterImpl()
  {
    INSTANCE = this ;
  }

  @Override
  public void exportExcel(String path, TestCase testCase) throws Exception
  {
    Workbook workbook ;
    Row row = null ;
    Cell cell = null ;
    
    int nTotal = 0, nSucess =0, nFail=0;
    if(testCase.getTestCaseResults() !=null )
    {
      nTotal = testCase.getTestCaseResults().size();
      if(nTotal > 0 )
      {
        for(TestCaseResult testCaseResult : testCase.getTestCaseResults())
          nSucess = (testCaseResult.getTestResult() == 'Y') ? nSucess + 1 : nSucess ;
        nFail = nTotal - nSucess;
      }
    }
    
    try (InputStream is = Configuration.getTemplate("TestCaseResult_Excel.xlsx"))
    {
      workbook = WorkbookFactory.create(is) ;

      File newExcel = new File(path) ;
      Sheet writeSheet = workbook.getSheetAt(0) ;

      String value = null ;         
      CellStyle cellStyle_info = getInfoCellStyle(workbook);

      //===== ���� 2��° �� �� ���� =====
      // ���� 
      CellStyle cellStyle_title = getTitileCellStyle(workbook);
      value = String.format("%s( %s )", testCase.getPk().toString(), testCase.getTestCaseDesc());
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
      if (TestCaseValidateConstants.TEST_CASE_RESULTS.containsKey(testCase.getTestCaseStatus()))
        value = StringUtils.trimToEmpty((String) TestCaseValidateConstants.TEST_CASE_RESULTS.get(testCase.getTestCaseStatus()).getValue());
      else
        value = Character.toString(testCase.getTestCaseStatus());
      
      row = writeSheet.getRow(3) ;
      cell = row.getCell(1) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // �׽�Ʈ ������
      value = testCase.getTestUserId();
      cell = row.getCell(3) ;
      cell.setCellStyle(cellStyle_info) ;
      cell.setCellValue(value) ;

      // �׽�Ʈ �Ͻ�
      value = testCase.getTestDateTime();
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

      if((testCase.getTestCaseResults() != null) && (testCase.getTestCaseResults().size() > 0))
        exportExcelTestResults(workbook, writeSheet, testCase, 6) ;

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
   * @author kjm, 2020. 4. 29.
   */
  public void exportExcelTestResults(Workbook workbook, Sheet writeSheet, TestCase testCase, int rowindex)
  {
    CellStyle cellStyle = getDataCellStyle(workbook);

    Row row = null ;
    Cell cell = null ;
    String value = null ;

    for(TestCaseValidate testCaseValidate :  testCase.getTestCaseValidates())
    {
      for( TestCaseResult testCaseResult : testCase.getTestCaseResults())
      {
        if( testCaseValidate.getPk().compareTo(testCaseResult.getPk()) == 0 )
        {
          
          if( !Boolean.valueOf((testCaseResult.getTestResult()=='Y')))
            cellStyle = getErrorDataCellStyle(workbook);
          else
            cellStyle = getDataCellStyle(workbook);

          //row         
          row = writeSheet.createRow(rowindex) ;

          //����  
          value = testCaseResult.getPk().getTestCaseValidateId();
          cell = row.createCell(0) ;
          cell.setCellStyle(cellStyle) ;
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
}
