/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.record ;

import java.io.BufferedReader ;
import java.io.File ;
import java.io.FileInputStream ;
import java.io.FileNotFoundException ;
import java.io.IOException ;
import java.io.InputStreamReader ;
import java.util.ArrayList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.eclipse.osgi.util.NLS ;
import org.eclipse.swt.SWT ;
import org.eclipse.swt.widgets.FileDialog ;
import org.eclipse.ui.PlatformUI ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.itools.record.utils.RecordImportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.imanager.api.IManagerException ;
import com.inzent.imanager.api.ResponseObject ;
import com.inzent.imanager.marshaller.JsonMarshaller ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;

/**
 * <code>RecordImportHandlerImpl</code> �̰��� Ŭ���� ������ ����ϼ���
 *
 * @since 2021. 2. 8.
 * @version 5.0
 * @author Jaesuk Byon
 * @see ���� ��� Ŭ������ �Է��Ͻð� ������� �����ּ���
 */
public class RecordImportHandlerImpl implements RecordImportHandler
{

  private List<Record> subRecordList ;
  public List<Object> importSuccessList ;
  
  public int importTotalCount, importSuccessCount;
  public int depth ;
  
  Record record  ;
  /**
   * �����ڿ� ���� ������ ����ϼ���
   */
  public RecordImportHandlerImpl()
  {
  }

  /**
   * �̰��� �޼ҵ� ������ ����ϼ���
   * 
   * @return
   * @author Jaesuk Byon, 2021. 2. 8.
   * @see com.inzent.igate.itools.record.utils.RecordImportHandler#importRecord()
   */
  @Override
  public void importRecord(Record record)
  {
    subRecordList = new ArrayList<Record>() ;
    importSuccessList = new ArrayList<Object>() ;
    importTotalCount = 0;
    importSuccessCount = 0;
    depth = 0 ;
    
    this.record = record ;
 // �������� ���̾�α� (�Ѱ��� ���ð���)
    FileDialog fileDialog = new FileDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(), SWT.SINGLE) ;

    String entityType = "Record";
    String resultMessage = "";
    int importTotalCount = 0;
    
    fileDialog.setText(entityType == null ?
        UiMessage.LABEL_IMPORT : String.format("%s %s", entityType,UiMessage.LABEL_IMPORT));

    fileDialog.setFilterPath("C:/") ;
    String[] filterExt = null;
    //Record
    if(entityType.equals(Record.class.getSimpleName()))
    {
      
      filterExt=new String[]{ MetaConstants.FILTER_FILE_EXTENDER_EXCEL1, MetaConstants.FILTER_FILE_EXTENDER_EXCEL2, MetaConstants.FILTER_FILE_EXTENDER_JSON };
      fileDialog.setFilterExtensions(filterExt) ;
      String selectedPath = fileDialog.open() ;
      
      if(selectedPath!=null)
      {
        resultMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE , Record.class.getSimpleName());
        importTotalCount = fileDialog.getFileNames().length;
        int fileterExtIndex = fileDialog.getFilterIndex() ;
        switch(fileterExtIndex)
        {
          case 0 : //.xlsx
          case 1 : //.xls
          {
            resultMessage += importExcel(fileDialog.getFilterPath(), fileDialog.getFileNames()) ;
            break ;
          }
          case 2 : //.json
          {
            resultMessage += importJson(fileDialog.getFilterPath(), fileDialog.getFileNames()) ;
            break ;
          }
        }
      }
    }

    //import ����
    if ( importTotalCount > 0 )
    {
      importSuccessCount = importSuccessList.size();
      resultMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, 
                          importTotalCount, importSuccessCount, importTotalCount-importSuccessCount );
    }
    if(!resultMessage.equals(StringUtils.EMPTY))
    {
      //�������� ��� ��� Ȯ�� â 
      LogHandler.openInformation(UiMessage.INFORMATION_IO_MESSAGE2 + resultMessage) ;
    }
  }

  //===[Json]========================================================================================================
  
  /**
   * json ���� ��������
   * @param String filePath     ������ ���� ���
   * @param String[] fileList   ������ ���� ���
   * @return String ��� �޽���
   * @author jkh, 2020. 3. 6.
   */
  public String importJson(String filePath, String[] fileList)
  {
    importSuccessList = new ArrayList<Object>() ;
    String resultMessage = "" ;

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      resultMessage = resultMessage + makeModelJson(filePath + "\\" + fileList[fileListLength]) ;
    }

    return resultMessage ; 
  }

  /**
   * json ���� ��������
   * @param String path     ��� ���� ���ϸ�
   * @return String ��� �޽���
   * @author jkh, 2020. 3. 6.
   */
  public String makeModelJson(String path)
  {
    String resultMessage = "";

    String readFileName = StringUtils.substringAfterLast(path, "\\");

    if (!decryption(path))
    {
      return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE4);
    }

    try
    {
      // ���� ������ �о import ó�� ���� 
      String content = "";
      try{
       
        FileInputStream fileInputStream = new FileInputStream(path) ;
        InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, JsonEncoding.UTF8.getJavaName()) ;//�Է� ��Ʈ�� ����        
        BufferedReader bufReader = new BufferedReader(inputStreamReader);//�Է� ���� ����
        
        String line = "";
        while((line = bufReader.readLine()) != null)
          content+=line;
        
        //.readLine()�� ���� ���๮�ڸ� ���� �ʴ´�.            
        bufReader.close();

        //System.out.println("===content====\r\n" + content);

      }catch (FileNotFoundException e) {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, e.getMessage());
      }catch(IOException e){
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, e.getMessage());
      }
      
      Record jsonRecord = JsonMarshaller.unmarshal(content, Record.class) ;
      record.setFields(jsonRecord.getFields());
      record.setOptions(jsonRecord.getOptions());
      
      if (!encryption(path))
      {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE5);
      }
      
      importSuccessList.add(record);
    }
    catch (Exception e)
    {
      if (e instanceof ArrayIndexOutOfBoundsException)
        resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE3, e.getMessage());
      else if(e instanceof IManagerException)
        resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, e.getCause().toString()); 
      else
        resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, e.getMessage());
    }
    return resultMessage ;
  }

  //===[Excel]========================================================================================================
  
  /**
   * ���������� ��������
   * @param String filePath ���� ���
   * @param String fileList ������ ���� ���
   * @return
   * @author jkh, 2020. 3. 6.
   */
  public String importExcel(String filePath, String[] fileList)
  {
    importSuccessList = new ArrayList<Object>() ;
    String resultMessage = "" ;

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      resultMessage = resultMessage + makeModelExcel(filePath + "\\" + fileList[fileListLength]) ;
    }

    return resultMessage ;
  }  
  
  /**
   * �� �⺻ ���� ����
   * @param String path     ��θ� ������ ���� �� 
   * @return
   * @author jkh, 2020. 3. 6.
   */
  public String makeModelExcel(String path)
  {
    String resultMessage = "" ;
    Row row = null ;
    subRecordList.clear() ;

    File readFile = null ;
    String readFileName = StringUtils.substringAfterLast(path, "\\");
    
    if (!decryption(path))
    {
      return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE4);
    }
    
    try
    {
      readFile = new File(path) ;
      if(readFile!=null)
        readFileName = readFile.getName();
      
      Workbook readBook = WorkbookFactory.create(readFile, null, true) ;
      Sheet readSheet = readBook.getSheetAt(0) ;
      String sheetName = readSheet.getSheetName() ;

      if (!checkSheet(sheetName))
      {
        return readFile.getName() + UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE1 ;
      }

      Cell cell = null ;

      row = readSheet.getRow(2) ;
      // �ɼ�
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;


      record.setFields(new ArrayList<Field>()) ;

      importExcelFieldList(readSheet, record, 4) ;

      Record recordResult = null ;
      String errorMessage = "" ; 

      readBook.close() ;

      if (!encryption(path))
      {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE5);
      }

      if (StringUtils.isBlank(errorMessage))
      {
        resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS);
        importSuccessList.add(recordResult);
      }
    }
    catch (Throwable e)
    {
      if (e instanceof ArrayIndexOutOfBoundsException)
        resultMessage= String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE3, e.getMessage());
      else
        resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, e.toString()); 
    }
    return resultMessage ;
  }

  public boolean encryption(String filePath)
  {
    return true ;
  }

  public boolean decryption(String filePath)
  {
    return true ;
  }
  
  private boolean checkSheet(String sheetName)
  {
    boolean bResult = false ;

    bResult = sheetName.equals("Data_Model") ; 

    return bResult ;
  }
  
  /**
   * �� �ʵ����� ����
   * @param Sheet readSheet  ���� Data_Model ��Ʈ
   * @param Record record    ���� ������ ���� Record
   * @param int index        ���� �� �ʵ������� �����ϴ� �� ��ȣ (4)
   * @return
   * @throws Exception
   * @author jkh, 2020. 3. 6.
   */
  public int importExcelFieldList(Sheet readSheet, Record record, int index) throws Exception
  {
    List<Field> filedList = new ArrayList<Field>() ;
    List<String> idList = new ArrayList<String>() ;
    Cell cell = null ;
    char chVal ;
    int nVal ;
    Row row = null ;
    Field field = null ;
    FieldPK fieldPK = null ;

    Boolean refferenceYn = false ;
    row = readSheet.getRow(index) ;
    cell = row.getCell(1) ;

    // �ʵ尡 �ִ� ���,
    while (StringUtils.isNotEmpty(getStringNumericValue(cell))) 
    {
      field = new Field() ;
      fieldPK = new FieldPK() ;

      // ���� index(4)��° �ٺ���  �� ��������
      // Level ��������
      row = readSheet.getRow(index) ;
      cell = row.getCell(0) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;

      // ���� �ʵ��� Level < ���� �ʵ��� Level
      if (depth < nVal)
      {
        depth = nVal ;

        int idx = filedList.size() ;
        Field preField = filedList.get(idx - 1) ;
        index = setSubField(readSheet, record, index, preField) ;

        if (index == -1)
        {
          break ;
        }

        continue ;

      }
      // �ռ� �ʵ��� Level > ���� �ʵ��� Level
      else if (depth > nVal)
      {
        depth = depth - 1 ;
        continue ;
      }

      field.setRecord(record) ;

      // �ʵ� ID
      row = readSheet.getRow(index) ;
      cell = row.getCell(1) ;
      fieldPK.setFieldId(getStringNumericValue(cell).trim()) ;

      if (idList.contains(fieldPK.getFieldId()))
        throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8,fieldPK.getFieldId()) );
      else
        idList.add(fieldPK.getFieldId()) ;

      // �ʵ��� ���ڵ� ID
      fieldPK.setRecordId(record.getRecordId()) ;

      field.setPk(fieldPK) ;

      // �ʵ� ��
      cell = row.getCell(2) ;
      field.setFieldName(getStringNumericValue(cell)) ;
      
      // �ʵ� Index
      cell = row.getCell(3) ;
      field.setFieldIndex(getStringNumericValue(cell)) ;

      // �ʵ� Ÿ�� (������Ʈ��)
      cell = row.getCell(4) ;
      field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

      // �ʵ� ����
      cell = row.getCell(5) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;
      field.setFieldLength(nVal) ;

      // �ʵ� �Ҽ�
      cell = row.getCell(6) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;
      field.setFieldScale(nVal) ;

      // �ݺ�Ÿ�� (�迭����)
      cell = row.getCell(7) ;
      field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

      // ���� �ʵ� ID (�ݺ�Ƚ��)
      cell = row.getCell(8) ;
      field.setReferenceFieldId(getStringNumericValue(cell)) ;

      // �ʵ� �⺻��
      cell = row.getCell(9) ;
      field.setFieldDefaultValue(getStringNumericValue(cell)) ;

      // ��������� (����ŷ����)
      cell = row.getCell(10) ;
      chVal = getStringNumericValue(cell).charAt(0) ;
      field.setFieldHiddenYn(chVal) ;

      // �ʼ����� 
      cell = row.getCell(11);
      chVal = getStringNumericValue(cell).charAt(0) ;
      field.setFieldRequireYn(chVal);
      
      // ��ȿ��
      cell = row.getCell(12);
      field.setFieldValidValue(getStringNumericValue(cell));
      
      // ��ȯ
      cell = row.getCell(13);
      field.setCodecId(getStringNumericValue(cell));
      
      // ��Ÿ�Ӽ�
      cell = row.getCell(14);
      field.setFieldOptions(getStringNumericValue(cell));

      // ��������
      cell = row.getCell(15) ;
      refferenceYn = getStringNumericValue(cell).equals("Y") ? true : false ;
      // Grid Ÿ�� + ���� ���� Y
//      if (row.getLastCellNum() > 16 && field.getFieldType() == Field.TYPE_RECORD && getStringNumericValue(cell).equals("Y")) 
      if (field.getFieldType() == Field.TYPE_RECORD && getStringNumericValue(cell).equals("Y")) 
      {
        // SUB_RECORD_ID
        cell = row.getCell(16) ;

        // ������ID �� ���� ���� ���, �ʵ�ID�� �����´�. (v4 ȣȯ��)
        // if(getStringNumericValue(cell).trim() == "")
        // field.setSubRecordId(field.getPk().getFieldId()) ;
        // else
        field.setSubRecordId(getStringNumericValue(cell)) ;
        
        Record subRecord = new Record() ;
        subRecord.setRecordId(field.getSubRecordId()) ;
        subRecord.setRecordDesc(field.getSubRecordId()) ;
        subRecord.setRecordType(Record.TYPE_REFER) ;
        
        ResponseObject<Record> responseObject = null ;
        
        try
        {// �� ���� ������ ���� update / insert �� ������ ó��
          Record recordId = new Record() ;
          recordId.setRecordId(field.getSubRecordId()) ;
          
          responseObject = ClientManager.getInstance().getIManagerClient().get(recordId) ;
          
          Record rerecord = responseObject.getObject();
          rerecord.setRecordId(field.getSubRecordId()) ;
          rerecord.setRecordDesc(field.getSubRecordId()) ;
          rerecord.setRecordType(Record.TYPE_REFER) ;
          field.setRecordObject(responseObject.getObject()) ;
        }
        catch (Exception e)
        {
          throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE9, field.getSubRecordId()));
        }
        
      }
      else if (field.getFieldType() == Field.TYPE_RECORD)
      {
        field.setSubRecordId(field.getPk().getRecordId() + MetaConstants.SUBRECORD_DELIMETER + field.getPk().getFieldId()) ;
      }
      else
      {
        field.setSubRecordId(null) ;
      }
      
      filedList.add(field) ;

      index++ ;
      if (readSheet.getLastRowNum() <= index)
        break ;

      row = readSheet.getRow(index) ;
      cell = row.getCell(1) ;
      
    }
    if (field != null && field.getFieldType() == Field.TYPE_RECORD && !refferenceYn )
    {
      setSubField(readSheet, record, index, field) ;
    }


    record.setFields(filedList) ;

    return index ;
  }

  /**
   * ���� Level�� �� �ʵ������� ����
   * @param Sheet readSheet ���� Data_Model ��Ʈ
   * @param Record record   ���� ������ ���� Record
   * @param int index       ���� index ��ȣ
   * @param Field preField
   * @return int index      ���� Level�� ������ index ��ȣ
   * @throws Exception
   * @author jkh, 2020. 3. 6.
   */
  public int setSubField(Sheet readSheet, Record record, int index, Field preField) throws Exception
  {
    List<Field> filedList = new ArrayList<Field>() ;
    List<String> idList = new ArrayList<String>() ;
    Cell cell = null ;
    char chVal ;
    int nVal ;
    Row row = null ;

    checkRecord(preField.getSubRecordId()) ;

    Record subRecord = new Record() ;
    subRecord.setRecordId(preField.getSubRecordId()) ;
    subRecord.setPrivilegeId(record.getPrivilegeId()) ;
    subRecord.setPrivateYn(record.getPrivateYn()) ;
    subRecord.setRecordDesc(preField.getSubRecordId()) ;
    subRecord.setRecordGroup(record.getRecordGroup()) ;

    subRecord.setRecordType(Record.TYPE_EMBED) ;


    boolean loop = true ;
    Field exField = null ;

    while (loop)
    {
      // Field / Level
      row = readSheet.getRow(index) ;
      cell = row.getCell(0) ;

      if (getStringNumericValue(cell).equals("")) 
      {
        loop = false ;
        continue ;
      }

      nVal = Integer.parseInt(getStringNumericValue(cell)) ;

      if (depth == nVal)
      {
        Field field = new Field() ;
        FieldPK fieldPK = new FieldPK() ;

        field.setRecord(subRecord) ;

        // �ʵ�ID
        cell = row.getCell(1) ;
        fieldPK.setFieldId(getStringNumericValue(cell).trim()) ;

        if (idList.contains(fieldPK.getFieldId()))
          throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8,fieldPK.getFieldId()) );
        else
          idList.add(fieldPK.getFieldId()) ;

        // ���ڵ�ID (�� ID)
        fieldPK.setRecordId(subRecord.getRecordId()) ;

        field.setPk(fieldPK) ;

        // �ʵ��
        cell = row.getCell(2) ;
        field.setFieldName(getStringNumericValue(cell)) ;
        
        // Index
        cell = row.getCell(3) ;
        field.setFieldIndex(getStringNumericValue(cell)) ;

        // �ʵ�Ÿ��
        cell = row.getCell(4) ;
        field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

        // �ʵ� ����
        cell = row.getCell(5) ;
        nVal = Integer.parseInt(getStringNumericValue(cell)) ;
        field.setFieldLength(nVal) ;

        // �ʵ� �Ҽ���
        cell = row.getCell(6) ;
        nVal = Integer.parseInt(getStringNumericValue(cell)) ;
        field.setFieldScale(nVal) ;

        // �ݺ�Ÿ��
        cell = row.getCell(7) ;
        field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

        // ���� �ʵ� (�ݺ�Ƚ��)
        cell = row.getCell(8) ;
        field.setReferenceFieldId(getStringNumericValue(cell)) ;
        
        // Dafault
        cell = row.getCell(9) ;
        field.setFieldDefaultValue(getStringNumericValue(cell)) ;

        // ����ŷ ����
        cell = row.getCell(10) ;
        chVal = getStringNumericValue(cell).charAt(0) ;
        field.setFieldHiddenYn(chVal) ;

        // �ʼ����� 
        cell = row.getCell(11);
        chVal = getStringNumericValue(cell).charAt(0) ;
        field.setFieldRequireYn(chVal);
        
        // ��ȿ��
        cell = row.getCell(12);
        field.setFieldValidValue(getStringNumericValue(cell));
        
        // ��ȯ
        cell = row.getCell(13);
        field.setCodecId(getStringNumericValue(cell));
        
        // ��Ÿ�Ӽ�
        cell = row.getCell(14);
        field.setFieldOptions(getStringNumericValue(cell));
        
       // ��������
        cell = row.getCell(15) ;
        if (field.getFieldType() == Field.TYPE_RECORD && getStringNumericValue(cell).equals("Y"))
        {
          field.setSubRecordId(field.getPk().getFieldId()) ;
        }
        else if (field.getFieldType() == Field.TYPE_RECORD)
        {
          field.setSubRecordId(field.getPk().getRecordId() + MetaConstants.SUBRECORD_DELIMETER + field.getPk().getFieldId()) ;
        }
        else
        {
          field.setSubRecordId(null) ;
        }

        exField = field ;
        filedList.add(field) ;

      }
      else if (depth < nVal) // ���� Level ���� ���� �ʵ尡 ���� Level �� ���,
      {
        depth = nVal ;

        index = setSubField(readSheet, subRecord, index, exField) ;

        if (index == -1)
        {
          subRecord.setFields(filedList) ;
          subRecord = setFieldOreder(subRecord) ;
          preField.setRecordObject(subRecord) ;

          if (!subRecordList.contains(subRecord))
            subRecordList.add(subRecord) ;

          return index ;
        }

        continue ;
      }
      else // ���� Level ����  ���� �ʵ尡 ���� Level �� ���,
      {
        depth = depth - 1 ;
        loop = false ;

        continue ;
      }

      index++ ;

      // ���� Row �� ���� �ִ��� Ȯ��
      row = readSheet.getRow(index) ;
      cell = row.getCell(1) ;
      if (getStringNumericValue(cell).equals(""))
      {
        // index�� -1�̸� �����Ѵ�.
        index = -1 ;
        loop = false ;
      }
    }

    subRecord.setFields(filedList) ;
    subRecord = setFieldOreder(subRecord) ;
    preField.setRecordObject(subRecord) ;

    if (!subRecordList.contains(subRecord))
      subRecordList.add(subRecord) ;

    return index ;
  }
  /**
   * ������ ����ȯ String > Numeric
   * @param cell
   * @return
   * @author jkh, 2021. 1. 27.
   */
  public static String getStringNumericValue(Cell cell) {
    String rtnValue = "";
    if (cell != null)
    {
      try 
      {
        rtnValue = cell.getStringCellValue() ;
      }
      catch(IllegalStateException e) 
      {
        rtnValue = Integer.toString((int)cell.getNumericCellValue()) ;
      }
    }
    
    return rtnValue;
  }
  
  /**
   * ���������� �𵨾ȿ� �������� �������� Ȯ��
   * @param String      subRecordId ������ ID
   * @throws Exception
   * @author jkh, 2020. 3. 9.
   */
  private void checkRecord(String subRecordId) throws Exception
  {
    if (subRecordId.indexOf('@') == -1)
    {
      // �������� �ִ��� Ȯ���Ѵ�.
      try
      {
        Record subRecord = new Record() ;
        subRecord.setRecordId(subRecordId) ;

        ClientManager.getInstance().getIManagerClient().get(subRecord) ;
      }
      catch (Exception e)
      {
        throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE9, subRecordId));
      }
    }
  }
  
  public static Record setFieldOreder(Record subRecord)
  {
    int order = 1 ;
    if (subRecord.getFields() != null)
    {
      for (Field field : subRecord.getFields())
      {
        field.setFieldOrder(order) ;
        order++ ;
      }
    }
    return subRecord ;
  }
  
}
