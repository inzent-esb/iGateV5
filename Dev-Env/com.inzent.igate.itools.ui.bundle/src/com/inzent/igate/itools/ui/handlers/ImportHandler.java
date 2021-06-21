package com.inzent.igate.itools.ui.handlers;

import java.io.BufferedReader ;
import java.io.File ;
import java.io.FileInputStream ;
import java.io.FileNotFoundException ;
import java.io.IOException ;
import java.io.InputStreamReader ;
import java.io.StringWriter ;
import java.util.ArrayList ;
import java.util.List ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.poi.ss.usermodel.Cell ;
import org.apache.poi.ss.usermodel.Row ;
import org.apache.poi.ss.usermodel.Sheet ;
import org.apache.poi.ss.usermodel.Workbook ;
import org.apache.poi.ss.usermodel.WorkbookFactory ;
import org.dom4j.Document ;
import org.dom4j.Element ;
import org.dom4j.io.OutputFormat ;
import org.dom4j.io.SAXReader ;
import org.dom4j.io.XMLWriter ;
import org.eclipse.core.commands.ExecutionException ;
import org.eclipse.jface.viewers.ISelection ;
import org.eclipse.jface.viewers.IStructuredSelection ;
import org.eclipse.osgi.util.NLS ;
import org.eclipse.swt.SWT ;
import org.eclipse.swt.widgets.FileDialog ;
import org.eclipse.ui.PlatformUI ;

import com.fasterxml.jackson.core.JsonEncoding ;
import com.inzent.igate.itools.editors.EditorManager ;
import com.inzent.igate.itools.handlers.AbstractImportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.views.MenuViewPart ;
import com.inzent.igate.repository.meta.Field ;
import com.inzent.igate.repository.meta.FieldPK ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.rule.operation.OperationNode ;
import com.inzent.imanager.api.IManagerException ;
import com.inzent.imanager.api.ResponseObject ;
import com.inzent.imanager.marshaller.JsonMarshaller ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.EntityUtils ;
import com.inzent.itools.util.LogHandler ;
import com.inzent.itools.views.AbstractMenuContentProvider ;
import com.inzent.itools.views.AbstractMenuViewPart ;
import com.inzent.itools.views.MenuContent ;
import com.inzent.itools.views.MenuContentEntity ;
import com.inzent.itools.views.MenuContentItem ;

public class ImportHandler extends AbstractImportHandler
{  
  private List<Record> subRecordList = new ArrayList<Record>() ;    
  public int depth = 0 ;
  
  public int importTotalCount = 0, importSuccessCount = 0;
  public List<Object> importSuccessList = new ArrayList<Object>() ;
  
  @Override
  protected void importSelected(MenuContent menuContent) throws ExecutionException
  {
    // 가져오기 Dialog 에서 view에서의 단축키 Ctrl + c, Ctrl + v의 동작을 회피하기 위함 
    ISelection selection = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().getSelection() ;
    ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(((IStructuredSelection) selection).iterator() );
    
    MenuContentEntity menuContentEntity = null ;

    if (menuContent instanceof MenuContentEntity)
      menuContentEntity = (MenuContentEntity) menuContent ;
    else if (menuContent instanceof MenuContentItem)
      for (MenuContent curr = menuContent ; null != curr ; curr = curr.getParent())
      {
        if (curr instanceof MenuContentEntity)
        {
          menuContentEntity = (MenuContentEntity) curr ;
          break ;
        }
      }

    //======= 가져오기 가능 여부 체크 =======
    boolean checkImport = false;
    String entityType = null;
    List<String> impossibleTypeList = new ArrayList<String>();
    if(null != menuContentEntity)
    {
      if((menuContentEntity.getValue() instanceof Record) || (menuContentEntity.getValue() instanceof Operation))      
      {        
        checkImport = true;
        entityType = menuContentEntity.getValue().getClass().getSimpleName();
      }
      else
      {
        checkImport = false;
        if(impossibleTypeList.contains(menuContentEntity.getValue().getClass().getSimpleName())==false)
          impossibleTypeList.add(menuContentEntity.getValue().getClass().getSimpleName());
      }

      String message = StringUtils.EMPTY;
      if(impossibleTypeList.size()>0)
      {
        message += impossibleTypeList.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE4;
        LogHandler.openInformation( message);
      }
    }
    //======= 가져오기 가능 여부 체크 =======

    //======= 가져오기 진행  =======
    if(checkImport)
    {
      importDialog(entityType) ;

      ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(((IStructuredSelection) selection).iterator() );
    } 
  }

  /**
   * import Dialog
   * 가져오기 할 파일을 선택
   * @author jkh, 2020. 3. 6.
   */
  public void importDialog(String entityType)
  {
    String resultMessage = StringUtils.EMPTY ;
    
    // 가져오기 다이얼로그 (여러항목 선택가능)
    FileDialog fileDialog = new FileDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(), SWT.MULTI) ;

    fileDialog.setText(entityType == null ?
        UiMessage.LABEL_IMPORT : String.format("%s %s", entityType,UiMessage.LABEL_IMPORT));

    fileDialog.setFilterPath("C:/") ;
    String[] filterExt = null;
    //Record
    if(entityType.equals(Record.class.getSimpleName()))
    {
      resultMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE , Record.class.getSimpleName());
      
      filterExt=new String[]{ MetaConstants.FILTER_FILE_EXTENDER_EXCEL1, MetaConstants.FILTER_FILE_EXTENDER_EXCEL2, MetaConstants.FILTER_FILE_EXTENDER_JSON };
      fileDialog.setFilterExtensions(filterExt) ;
      String selectedPath = fileDialog.open() ;
      if(selectedPath!=null)
      {
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
      else
        return;
    }
    //Operation
    else if(entityType.equals(Operation.class.getSimpleName()))
    {
      resultMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE , Operation.class.getSimpleName());
      
      filterExt=new String[]{MetaConstants.FILTER_FILE_EXTENDER_XML };
      fileDialog.setFilterExtensions(filterExt) ;
      String selectedPath = fileDialog.open() ;
      if(selectedPath!=null)
      {
        importTotalCount = fileDialog.getFileNames().length;
        int fileterExtIndex = fileDialog.getFilterIndex() ;
        switch(fileterExtIndex)
        {
          case 0 : //.xml
          {
            resultMessage += importXml(fileDialog.getFilterPath(), fileDialog.getFileNames()) ;
            break ;
          }
        }
      }
      else
        return;
    }

    //import 갯수
    if ( importTotalCount > 0 )
    {
      importSuccessCount = importSuccessList.size();
      resultMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, 
                          importTotalCount, importSuccessCount, importTotalCount-importSuccessCount );
    }

    //가져내기 결과 목록 확인 창 
    LogHandler.openInformation(UiMessage.INFORMATION_IO_MESSAGE2 + resultMessage) ;
    
    //가져오기 한 항목들 중 이미 Editor 오픈 중인 것이 있는지 확인 
    int nAlreadyOpen = 0;
    String strEditorInfo = "\n";
    for(Object item : importSuccessList)
    {
      if(isOpenedEditor(item))
      {
        nAlreadyOpen++;
        strEditorInfo += String.format(MetaConstants.MESSAGE_OPEN_EDITOR_INFO, 
                          nAlreadyOpen, item.getClass().getSimpleName(), EntityUtils.getId(item));
      }
    }
    //이미 오픈된 것이 있으면 Editor 다시 열지 확인 하고 다시 오픈 처리 수행
    if( nAlreadyOpen > 0 )
    {
      strEditorInfo += "\n\n";
      
      if( LogHandler.openConfirm( NLS.bind(UiMessage.INFORMATION_IO_MESSAGE9, nAlreadyOpen)  
                                   + strEditorInfo 
                                   + UiMessage.INFORMATION_IO_MESSAGE10 )) 
      {
        for(Object item : importSuccessList)
          reOpenEditor(item); //Editor 다시 오픈 
      }
    }
  }

  /**
   * Editor 오픈 중인지 판단하기 위해서 항목별 MenuContentItem 추출 
   * @param object
   * @return
   * @author kjm, 2020. 7. 3.
   */
  public MenuContentItem getMenuContentItemEntity(Object object)
  {
    AbstractMenuContentProvider menuContentProvider = (AbstractMenuContentProvider) ((AbstractMenuViewPart) 
        PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(
            MenuViewPart.ID )).getTreeViewer().getContentProvider() ;

    MenuContent[] menuPath = menuContentProvider.getMenuPath(
        menuContentProvider.getEntityMenu(object).getMenu().getMenuId(),
        EntityUtils.getId(object), EntityUtils.hasGroup(object) ? EntityUtils.getGroup(object) : null) ;

    if( menuPath.length > 0 )
    {
      for(int index =0 ; index < menuPath.length ; index ++)
      {
        if(menuPath[index] instanceof MenuContentItem)
        {
          MenuContentItem menuContentItem = new MenuContentItem(menuPath[index], menuPath[index].getMenu(), EntityUtils.getId(object), object) ;
          menuContentItem.setLinkOpen(true);

          return menuContentItem;
        }
      }
    }
    return null;
  }
  
  /**
   * Editor 오픈 중인지 판단
   * @param object
   * @return
   * @author kjm, 2020. 7. 3.
   */
  public boolean isOpenedEditor(Object object)
  {
    boolean already = false;
    MenuContentItem menuContentItem = getMenuContentItemEntity(object) ;
    if( null!= menuContentItem)
      already = EditorManager.getInstance().isOpened(menuContentItem, null);
    
    return already;
  }
  
  /**
   * Editor 재 오픈 
   * @param object
   * @author kjm, 2020. 7. 3.
   */
  public void reOpenEditor(Object object)
  {
    MenuContentItem menuContentItem = getMenuContentItemEntity(object) ;
    if( null!= menuContentItem)
      EditorManager.getInstance().reOpen(menuContentItem, null);
    
  }
  //===[Excel]========================================================================================================
  
  /**
   * 엑셀파일을 가져오기
   * @param String filePath 파일 경로
   * @param String fileList 가져올 파일 목록
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
   * 모델 기본 정보 설정
   * @param String path     경로를 포함한 파일 명 
   * @return
   * @author jkh, 2020. 3. 6.
   */
  public String makeModelExcel(String path)
  {
    String resultMessage = "" ;
    Row row = null ;
    subRecordList.clear() ;
    Record record = new Record() ;

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

      // 엑셀 2번째 줄 값 가져오기
      // ID
      row = readSheet.getRow(1) ;
      cell = row.getCell(1) ;
      record.setRecordId(getStringNumericValue(cell)) ;

      // 설명
      cell = row.getCell(3) ;
      record.setRecordDesc(getStringNumericValue(cell)) ;

      // 모델유형
      cell = row.getCell(10) ;
      if (getStringNumericValue(cell).equals(MetaConstants.EXCEL_HEADER))
        record.setRecordType(Record.TYPE_HEADER) ;
      else if (getStringNumericValue(cell).equals(MetaConstants.EXCEL_REFER))
        record.setRecordType(Record.TYPE_REFER) ;
      else
        record.setRecordType(Record.TYPE_INDIVI) ;

      // 모델이름
      cell = row.getCell(12) ;
      record.setRecordName(getStringNumericValue(cell));
      
      // 엑셀 3번째 줄 값 가져오기
      // 그룹
      row = readSheet.getRow(2) ;
      cell = row.getCell(1) ;
      record.setRecordGroup(getStringNumericValue(cell)) ;

      // 권한ID
      cell = row.getCell(3) ;
      record.setPrivilegeId(getStringNumericValue(cell)) ;

      // 옵션
      cell = row.getCell(5) ;
      record.setRecordOptions(getStringNumericValue(cell)) ;

      // 개별부경로
//      cell = row.getCell(8) ;
//      record.setIndividualPath(getStringNumericValue(cell)) ;

      // 전문공유
      cell = row.getCell(10) ;
      if (getStringNumericValue(cell).charAt(0) == MetaConstants.PRIVATEYN_YN_Y)
        record.setPrivateYn(MetaConstants.PRIVATEYN_YN_Y) ;
      else
        record.setPrivateYn(MetaConstants.PRIVATEYN_YN_N) ;

      // 작성자
      cell = row.getCell(14) ;
      record.setUpdateUserId(getStringNumericValue(cell)) ;

      record.setFields(new ArrayList<Field>()) ;

      importExcelFieldList(readSheet, record, 4) ;

      Record recordResult = null ;
      String errorMessage = "" ; 

      setFieldOreder(record) ;
      ResponseObject<Record> responseObject = null ;

      try
      {// 모델 존재 유무에 따라 update / insert 로 나눠서 처리
        Record recordId = new Record() ;
        recordId.setRecordId(record.getRecordId()) ;

        responseObject = ClientManager.getInstance().getIManagerClient().get(recordId) ;
        responseObject = ClientManager.getInstance().getIManagerClient().update(record) ;
      }
      catch (Exception e)
      {
        responseObject = ClientManager.getInstance().getIManagerClient().insert(record) ;
      }

      recordResult = responseObject.getObject() ;

      if (recordResult != null)
      {

        for (Field field : recordResult.getFields())
        {
          if (null == field.getValidateMessage())
            continue ;

          errorMessage = errorMessage + field.getValidateMessage() + "\n" ; 
        }

        if (!StringUtils.isBlank(errorMessage))
        {
          return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, errorMessage);
        }
      }

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
   * 모델 필드정보 설정
   * @param Sheet readSheet  엑셀 Data_Model 시트
   * @param Record record    엑셀 내용을 담을 Record
   * @param int index        엑셀 모델 필드정보가 시작하는 줄 번호 (4)
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

    // 필드가 있는 경우,
    while (StringUtils.isNotEmpty(getStringNumericValue(cell))) 
    {
      field = new Field() ;
      fieldPK = new FieldPK() ;

      // 엑셀 index(4)번째 줄부터  값 가져오기
      // Level 가져오기
      row = readSheet.getRow(index) ;
      cell = row.getCell(0) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;

      // 윗줄 필드의 Level < 현재 필드의 Level
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
      // 앞선 필드의 Level > 현재 필드의 Level
      else if (depth > nVal)
      {
        depth = depth - 1 ;
        continue ;
      }

      field.setRecord(record) ;

      // 필드 ID
      row = readSheet.getRow(index) ;
      cell = row.getCell(1) ;
      fieldPK.setFieldId(getStringNumericValue(cell).trim()) ;

      if (idList.contains(fieldPK.getFieldId()))
        throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8,fieldPK.getFieldId()) );
      else
        idList.add(fieldPK.getFieldId()) ;

      // 필드의 레코드 ID
      fieldPK.setRecordId(record.getRecordId()) ;

      field.setPk(fieldPK) ;

      // 필드 명
      cell = row.getCell(2) ;
      field.setFieldName(getStringNumericValue(cell)) ;
      
      // 필드 Index
      cell = row.getCell(3) ;
      field.setFieldIndex(getStringNumericValue(cell)) ;

      // 필드 타입 (오브젝트명)
      cell = row.getCell(4) ;
      field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

      // 필드 길이
      cell = row.getCell(5) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;
      field.setFieldLength(nVal) ;

      // 필드 소수
      cell = row.getCell(6) ;
      nVal = Integer.parseInt(getStringNumericValue(cell)) ;
      field.setFieldScale(nVal) ;

      // 반복타입 (배열형태)
      cell = row.getCell(7) ;
      field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

      // 참조 필드 ID (반복횟수)
      cell = row.getCell(8) ;
      field.setReferenceFieldId(getStringNumericValue(cell)) ;

      // 필드 기본값
      cell = row.getCell(9) ;
      field.setFieldDefaultValue(getStringNumericValue(cell)) ;

      // 비공개여부 (마스킹여부)
      cell = row.getCell(10) ;
      chVal = getStringNumericValue(cell).charAt(0) ;
      field.setFieldHiddenYn(chVal) ;

      // 필수여부 
      cell = row.getCell(11);
      chVal = getStringNumericValue(cell).charAt(0) ;
      field.setFieldRequireYn(chVal);
      
      // 유효값
      cell = row.getCell(12);
      field.setFieldValidValue(getStringNumericValue(cell));
      
      // 변환
      cell = row.getCell(13);
      field.setCodecId(getStringNumericValue(cell));
      
      // 기타속성
      cell = row.getCell(14);
      field.setFieldOptions(getStringNumericValue(cell));

      // 참조여부
      cell = row.getCell(15) ;
      refferenceYn = getStringNumericValue(cell).equals("Y") ? true : false ;
      // Grid 타입 + 참조 전문 Y
//      if (row.getLastCellNum() > 16 && field.getFieldType() == Field.TYPE_RECORD && getStringNumericValue(cell).equals("Y")) 
      if (field.getFieldType() == Field.TYPE_RECORD && getStringNumericValue(cell).equals("Y")) 
      {
        // SUB_RECORD_ID
        cell = row.getCell(16) ;

        // 참조모델ID 에 값이 없는 경우, 필드ID를 가져온다. (v4 호환용)
        // if(getStringNumericValue(cell).trim() == "")
        // field.setSubRecordId(field.getPk().getFieldId()) ;
        // else
        field.setSubRecordId(getStringNumericValue(cell)) ;
        
        Record subRecord = new Record() ;
        subRecord.setRecordId(field.getSubRecordId()) ;
        subRecord.setRecordDesc(field.getSubRecordId()) ;
        subRecord.setRecordType(Record.TYPE_REFER) ;

        field.setRecordObject(subRecord) ;
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
    if (field != null && field.getFieldType() == Field.TYPE_RECORD && !refferenceYn)
    {
      setSubField(readSheet, record, index, field) ;
    }


    record.setFields(filedList) ;

    return index ;
  }

  /**
   * 하위 Level의 모델 필드정보를 설정
   * @param Sheet readSheet 엑셀 Data_Model 시트
   * @param Record record   엑셀 내용을 담을 Record
   * @param int index       현재 index 번호
   * @param Field preField
   * @return int index      하위 Level이 끝나는 index 번호
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

        // 필드ID
        cell = row.getCell(1) ;
        fieldPK.setFieldId(getStringNumericValue(cell).trim()) ;

        if (idList.contains(fieldPK.getFieldId()))
          throw new Exception( NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE8,fieldPK.getFieldId()) );
        else
          idList.add(fieldPK.getFieldId()) ;

        // 레코드ID (모델 ID)
        fieldPK.setRecordId(subRecord.getRecordId()) ;

        field.setPk(fieldPK) ;

        // 필드명
        cell = row.getCell(2) ;
        field.setFieldName(getStringNumericValue(cell)) ;
        
        // Index
        cell = row.getCell(3) ;
        field.setFieldIndex(getStringNumericValue(cell)) ;

        // 필드타입
        cell = row.getCell(4) ;
        field.setFieldType(MetaConstants.FIELD_TYPES_INVERT.get(getStringNumericValue(cell))) ;

        // 필드 길이
        cell = row.getCell(5) ;
        nVal = Integer.parseInt(getStringNumericValue(cell)) ;
        field.setFieldLength(nVal) ;

        // 필드 소수점
        cell = row.getCell(6) ;
        nVal = Integer.parseInt(getStringNumericValue(cell)) ;
        field.setFieldScale(nVal) ;

        // 반복타입
        cell = row.getCell(7) ;
        field.setArrayType(MetaConstants.FIELD_ARRAYTYPES_INVERT.get(getStringNumericValue(cell))) ;

        // 참조 필드 (반복횟수)
        cell = row.getCell(8) ;
        field.setReferenceFieldId(getStringNumericValue(cell)) ;
        
        // Dafault
        cell = row.getCell(9) ;
        field.setFieldDefaultValue(getStringNumericValue(cell)) ;

        // 마스킹 여부
        cell = row.getCell(10) ;
        chVal = getStringNumericValue(cell).charAt(0) ;
        field.setFieldHiddenYn(chVal) ;

        // 필수여부 
        cell = row.getCell(11);
        chVal = getStringNumericValue(cell).charAt(0) ;
        field.setFieldRequireYn(chVal);
        
        // 유효값
        cell = row.getCell(12);
        field.setFieldValidValue(getStringNumericValue(cell));
        
        // 변환
        cell = row.getCell(13);
        field.setCodecId(getStringNumericValue(cell));
        
        // 기타속성
        cell = row.getCell(14);
        field.setFieldOptions(getStringNumericValue(cell));
        
       // 참조여부
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
      else if (depth < nVal) // 윗줄 Level 보다 현재 필드가 하위 Level 인 경우,
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
      else // 윗줄 Level 보다  현재 필드가 상위 Level 인 경우,
      {
        depth = depth - 1 ;
        loop = false ;

        continue ;
      }

      index++ ;

      // 다음 Row 에 값이 있는지 확인
      row = readSheet.getRow(index) ;
      cell = row.getCell(1) ;
      if (getStringNumericValue(cell).equals(""))
      {
        // index가 -1이면 종료한다.
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
   * 순자적 형변환 String > Numeric
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
   * 가져오려는 모델안에 참조모델의 존재유무 확인
   * @param String      subRecordId 참조모델 ID
   * @throws Exception
   * @author jkh, 2020. 3. 9.
   */
  private void checkRecord(String subRecordId) throws Exception
  {
    if (subRecordId.indexOf('@') == -1)
    {
      // 참조모델이 있는지 확인한다.
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

  //===[Json]========================================================================================================
  
  /**
   * json 파일 가져오기
   * @param String filePath     가져올 파일 경로
   * @param String[] fileList   가져올 파일 목록
   * @return String 결과 메시지
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
   * json 파일 가져오기
   * @param String path     경로 포함 파일명
   * @return String 결과 메시지
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
      // 파일 내용이 읽어서 import 처리 수행 
      String content = "";
      try{
       
        FileInputStream fileInputStream = new FileInputStream(path) ;
        InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, JsonEncoding.UTF8.getJavaName()) ;//입력 스트림 생성        
        BufferedReader bufReader = new BufferedReader(inputStreamReader);//입력 버퍼 생성
        
        String line = "";
        while((line = bufReader.readLine()) != null)
          content+=line;
        
        //.readLine()은 끝에 개행문자를 읽지 않는다.            
        bufReader.close();

        //System.out.println("===content====\r\n" + content);

      }catch (FileNotFoundException e) {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, e.getMessage());
      }catch(IOException e){
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, e.getMessage());
      }

      Record recordData = JsonMarshaller.unmarshal(content, Record.class) ;
      ResponseObject<Record> responseObject = null ;
      String errorMessage = "" ; 

      Record recordId = new Record() ;
      try
      {
        // 모델 존재 유무에 따라 update / insert 로 나눠서 처리
        recordId.setRecordId(recordData.getRecordId()) ;

        responseObject = ClientManager.getInstance().getIManagerClient().get(recordId) ;
        responseObject = ClientManager.getInstance().getIManagerClient().update(recordData) ;
      }
      catch (Exception e)
      {
        responseObject = ClientManager.getInstance().getIManagerClient().insert(recordData) ;
      }
      resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS);

      Record recordResult = responseObject.getObject() ;

      if (recordResult != null)
      {
        for (Field field : recordResult.getFields())
        {
          if (null == field.getValidateMessage())
            continue ;

          errorMessage = errorMessage + field.getValidateMessage() + "\n" ; 
        }

        if (!StringUtils.isBlank(errorMessage))
        {
          return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, errorMessage);
        }
      }
      if (!encryption(path))
      {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE5);
      }
      
      importSuccessList.add(recordResult);
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
  

  //===[Xml]========================================================================================================

  /**
   * Xml 파일 가져오기
   * @param String filePath     가져올 파일 경로
   * @param String[] fileList   가져올 파일 목록
   * @return String 결과 메시지
   */
  public String importXml(String filePath, String[] fileList)
  {
    importSuccessList = new ArrayList<Object>() ;
    String resultMessage = "";

    for (int fileListLength = 0 ; fileListLength < fileList.length ; fileListLength++)
    {
      resultMessage += makeOperationXml(filePath + "\\" + fileList[fileListLength]) ;
    }

    return resultMessage ; 
  }
  
  /**
   * Xml 파일 가져오기
   * @param String path     경로 포함 파일명
   * @return String 결과 메시지
   */
  public String makeOperationXml(String path)
  {
    String resultMessage = "";

    File readFile = null;
    String readFileName = StringUtils.substringAfterLast(path, "\\");
    
    if (!decryption(path))
    {
      return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE4);
    }
    
    try
    {
      readFile = new File(path);
      if(readFile!=null)
        readFileName = readFile.getName();
      
      SAXReader reader = new SAXReader();
      Document document = reader.read( readFile );

      Element rootElement = document.getRootElement();
      Operation operation = crateNewOperation(rootElement);
      removeAttribute(rootElement);
      operation.setOperationDocument(document);
      operation.setOperationRuleDirty(true) ;
      
      // xml data update
      try (StringWriter out = new StringWriter())
      {
        XMLWriter writer = new XMLWriter(out, OutputFormat.createPrettyPrint()) ;
        writer.write(operation.getOperationDocument()) ;
        writer.flush() ;

        operation.setOperationRule(out.toString().getBytes(JsonEncoding.UTF8.getJavaName())) ;
      }
      catch (IOException e)
      {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.LABEL_FAIL, e.getMessage());
      }
      
      ResponseObject<Operation> responseObject = null ;
      String errorMessage = "" ; 
      try
      {
        // 모델 존재 유무에 따라 update / insert 로 나눠서 처리
        responseObject = ClientManager.getInstance().getIManagerClient().update(operation) ;
        
      }
      catch (Exception e)
      {
        responseObject = ClientManager.getInstance().getIManagerClient().insert(operation) ;
      }
      
      resultMessage = String.format(MetaConstants.MESSAGE_IMPORT_SUCCESS, readFileName, UiMessage.LABEL_SUCCESS);
          
      Operation operationResult = responseObject.getObject() ;
      if (operationResult != null)
      {       
        if (!StringUtils.isBlank(errorMessage))
        {
          return String.format(MetaConstants.MESSAGE_IMPORT_FAIL, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE2, errorMessage);
        }
      }      
      if (!encryption(path))
      {
        return String.format(MetaConstants.MESSAGE_IMPORT_FAIL_ENCRYPTION, readFileName, UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE5);
      }
      
      importSuccessList.add(operationResult);
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
  

  /**
   * 오퍼레이션 import를 위한 파일 내의 오퍼레이션의 정보를 추출하여 오퍼레이션을 생성 하여 return 
   * @param element
   * @return
   * @author kjm, 2020. 6. 23.
   */
  public Operation crateNewOperation(Element element)
  {
    Operation operation = new Operation() ;
   
    String operationId          = StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_ID));    //operationId
    String operationTypeValue   = StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_TYPE));  //operationType
    String operationName        = StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_NAME));  //operationName
    String operationDesc        = StringUtils.defaultString(element.attributeValue(OperationNode.XML_ATTRIBUTE_DESC));  //operationDesc
    String operationGroup       = StringUtils.defaultString(element.attributeValue("operationGroup"));                  //operationGroup
    String privilegeId          = StringUtils.defaultString(element.attributeValue("privilegeId"));                     //privilegeId
    String privateYnValue       = StringUtils.defaultString(element.attributeValue("privateYn"));                       //privateYn
    String operationLogLevel    = StringUtils.defaultString(element.attributeValue("operationLogLevel"));               //operationLogLevel
    String xaTransactionAttributeValue = StringUtils.defaultString(element.attributeValue("xaTransactionAttribute"));   //xaTransactionAttribute
    
    char operationType = operationId.charAt(0) ;
    char privateYn = 'N';
    char xaTransactionAttribute = Operation.XA_TRAN_SUPPORTS;
    
    if(operationTypeValue.length()>0)
      operationType          = operationTypeValue.charAt(0);
    if(privateYnValue.length()>0)
      privateYn              = privateYnValue.charAt(0);
    if(xaTransactionAttributeValue.length()>0)
      xaTransactionAttribute = xaTransactionAttributeValue.charAt(0);
    
    operation.setOperationId(operationId);
    operation.setOperationType(operationType);
    operation.setOperationName(operationName);
    operation.setOperationDesc(operationDesc);
    operation.setOperationGroup(operationGroup);
    operation.setPrivilegeId(privilegeId);
    operation.setPrivateYn(privateYn);
    operation.setOperationLogLevel(operationLogLevel);
    operation.setXaTransactionAttribute(xaTransactionAttribute);
    
    return operation;
  }


  /**
   * 오퍼레이션 export 시 넣어준 정보들을 제거 하여 import 처리 
   * @param element
   * @author kjm, 2020. 6. 23.
   */
  public void removeAttribute (Element element)
  {
    //operationId           
    if(null!=element.attribute(OperationNode.XML_ATTRIBUTE_ID))
      element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_ID));

    //operationType         
    if(null!=element.attribute(OperationNode.XML_ATTRIBUTE_TYPE))
      element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_TYPE));

    //operationName         
    if(null!=element.attribute(OperationNode.XML_ATTRIBUTE_NAME))
      element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_NAME));

    //operationDesc         
    if(null!=element.attribute(OperationNode.XML_ATTRIBUTE_DESC))
      element.remove(element.attribute(OperationNode.XML_ATTRIBUTE_DESC));

    //operationGroup        
    if(null!=element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP))
      element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONGROUP));

    //privilegeId           
    if(null!=element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID))
      element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVILEGEID));

    //privateYn             
    if(null!=element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN))
      element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_PRIVATEYN));

    //operationLogLevel     
    if(null!=element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL))
      element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL));

    //xaTransactionAttribute
    if(null!=element.attribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE))
      element.remove(element.attribute(MetaConstants.OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE));
    return;
  }
}
