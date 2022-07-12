package com.inzent.igate.itools.ui.handlers ;

import java.util.Collections ;
import java.util.List ;
import java.util.Map ;

import org.apache.commons.lang3.StringUtils ;
import org.eclipse.core.commands.ExecutionException ;
import org.eclipse.jface.viewers.ISelection ;
import org.eclipse.jface.viewers.IStructuredSelection ;
import org.eclipse.osgi.util.NLS ;
import org.eclipse.swt.SWT ;
import org.eclipse.swt.widgets.FileDialog ;
import org.eclipse.ui.PlatformUI ;

import com.inzent.igate.itools.editors.EditorManager ;
import com.inzent.igate.itools.handlers.AbstractImportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.importexport.ExportImportOperationUtils ;
import com.inzent.igate.itools.ui.importexport.ExportImportRecordUtils ;
import com.inzent.igate.itools.ui.importexport.Importer ;
import com.inzent.igate.itools.views.MenuViewPart ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.itools.util.EntityUtils ;
import com.inzent.itools.util.LogHandler ;
import com.inzent.itools.views.AbstractMenuContentProvider ;
import com.inzent.itools.views.AbstractMenuViewPart ;
import com.inzent.itools.views.MenuContent ;
import com.inzent.itools.views.MenuContentEntity ;
import com.inzent.itools.views.MenuContentItem ;

public class ImportHandler extends AbstractImportHandler
{
  protected String resultMessage ;
  protected int importTotalCount ;

  protected final Importer<Operation> operationImporter ;
  protected final Importer<Record> recordImporter ;

  public ImportHandler()
  {
    operationImporter = createOperationImporter() ;
    recordImporter = createRecordImporter() ;
  }

  protected Importer<Operation> createOperationImporter()
  {
    return new ExportImportOperationUtils() ;
  }

  protected Importer<Record> createRecordImporter()
  {
    return new ExportImportRecordUtils() ;
  }

  @Override
  @SuppressWarnings("unchecked")
  protected void importSelected(MenuContent menuContent) throws ExecutionException
  {
    resultMessage = StringUtils.EMPTY ;
    importTotalCount = 0 ;
    
    // 가져오기 Dialog 에서 view에서의 단축키 Ctrl + c, Ctrl + v의 동작을 회피하기 위함
    ISelection selection = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().getSelection() ;
    ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(((IStructuredSelection) selection).iterator()) ;

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

    // ======= 가져오기 가능 여부 체크 =======
    String impossibleType ;
    if (null == menuContentEntity)
      impossibleType = StringUtils.EMPTY ;
    else if (!isPossible(menuContentEntity.getValue()))
      impossibleType = menuContentEntity.getValue().getClass().getSimpleName() ;
    else
      impossibleType = null ;

    if (null != impossibleType)
    {
      LogHandler.openInformation(impossibleType + " " + UiMessage.INFORMATION_IO_MESSAGE4) ;

      return ;
    }
    // ======= 가져오기 가능 여부 체크 =======

    // ======= 가져오기 진행 =======
    Map<String, Object> resultMap = null ;

    if (isRecord(menuContentEntity.getValue()))
      resultMap = importRecord((Record) menuContentEntity.getValue()) ;
    else if (isOperation(menuContentEntity.getValue()))
      resultMap = importOperation((Operation) menuContentEntity.getValue()) ;

    if (null != resultMap)
    {
      resultMessage += resultMap.get(ExportImportRecordUtils.MESSAGE) ;

      List<Object> importSuccessList ;

      // import 갯수
      if (importTotalCount > 0)
      {
        importSuccessList = (List<Object>) resultMap.get(ExportImportRecordUtils.RESULT_List) ;
        resultMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, importTotalCount, importSuccessList.size(), importTotalCount - importSuccessList.size()) ;
      }
      else
        importSuccessList = Collections.emptyList() ;

      // 가져내기 결과 목록 확인 창
      LogHandler.openInformation(UiMessage.INFORMATION_IO_MESSAGE2 + resultMessage) ;

      // 가져오기 한 항목들 중 이미 Editor 오픈 중인 것이 있는지 확인
      int nAlreadyOpen = 0 ;
      String strEditorInfo = "\n" ;
      for (Object item : importSuccessList)
      {
        if (isOpenedEditor(item))
        {
          nAlreadyOpen++ ;
          strEditorInfo += String.format(MetaConstants.MESSAGE_OPEN_EDITOR_INFO, nAlreadyOpen, item.getClass().getSimpleName(), EntityUtils.getId(item)) ;
        }
      }

      // 이미 오픈된 것이 있으면 Editor 다시 열지 확인 하고 다시 오픈 처리 수행
      if (nAlreadyOpen > 0)
      {
        strEditorInfo += "\n\n" ;

        if (LogHandler.openConfirm(NLS.bind(UiMessage.INFORMATION_IO_MESSAGE9, nAlreadyOpen) + strEditorInfo + UiMessage.INFORMATION_IO_MESSAGE10))
        {
          for (Object item : importSuccessList)
            reOpenEditor(item) ; // Editor 다시 오픈
        }
      }

      ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(((IStructuredSelection) selection).iterator()) ;
    }
  }

  protected boolean isPossible(Object object)
  {
    return isRecord(object) || isOperation(object) ;
  }

  protected boolean isRecord(Object object)
  {
    return object instanceof Record ;
  }

  protected boolean isOperation(Object object)
  {
    return object instanceof Operation ;
  }

  protected Map<String, Object> importRecord(Record record)
  {
    String entityType = Record.class.getSimpleName() ;

    resultMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE, entityType) ;

    // 가져오기 다이얼로그 (여러항목 선택가능)
    FileDialog fileDialog = new FileDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(), SWT.MULTI) ;

    fileDialog.setText(String.format("%s %s", entityType, UiMessage.LABEL_IMPORT)) ;
    fileDialog.setFilterPath("C:/") ;
    fileDialog.setFilterExtensions(new String[] { MetaConstants.FILTER_FILE_EXTENDER_EXCEL1, MetaConstants.FILTER_FILE_EXTENDER_EXCEL2, MetaConstants.FILTER_FILE_EXTENDER_JSON }) ;

    String selectedPath = fileDialog.open() ;
    if (selectedPath != null)
    {
      importTotalCount = fileDialog.getFileNames().length ;
      switch (fileDialog.getFilterIndex())
      {
      case 0 : // .xlsx
      case 1 : // .xls
        return recordImporter.importExcel(fileDialog.getFilterPath(), fileDialog.getFileNames(), null) ;

      case 2 : // .json
        return recordImporter.importJson(fileDialog.getFilterPath(), fileDialog.getFileNames(), null) ;
      }
    }

    return null ;
  }

  protected Map<String, Object> importOperation(Operation operation)
  {
    String entityType = Operation.class.getSimpleName() ;

    resultMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE, entityType) ;

    // 가져오기 다이얼로그 (여러항목 선택가능)
    FileDialog fileDialog = new FileDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(), SWT.MULTI) ;

    fileDialog.setText(String.format("%s %s", entityType, UiMessage.LABEL_IMPORT)) ;
    fileDialog.setFilterPath("C:/") ;
    fileDialog.setFilterExtensions(new String[] { MetaConstants.FILTER_FILE_EXTENDER_XML }) ;

    String selectedPath = fileDialog.open() ;
    if (selectedPath != null)
    {
      importTotalCount = fileDialog.getFileNames().length ;
      switch (fileDialog.getFilterIndex())
      {
      case 0 : // .xml
        return operationImporter.importXml(fileDialog.getFilterPath(), fileDialog.getFileNames(), null) ;
      }
    }

    return null ;
  }

  /**
   * Editor 오픈 중인지 판단
   * 
   * @param object
   * @return
   * @author kjm, 2020. 7. 3.
   */
  protected boolean isOpenedEditor(Object object)
  {
    boolean already = false ;
    MenuContentItem menuContentItem = getMenuContentItemEntity(object) ;
    if (null != menuContentItem)
      already = EditorManager.getInstance().isOpened(menuContentItem, null) ;

    return already ;
  }

  /**
   * Editor 재 오픈
   * 
   * @param object
   * @author kjm, 2020. 7. 3.
   */
  protected void reOpenEditor(Object object)
  {
    MenuContentItem menuContentItem = getMenuContentItemEntity(object) ;
    if (null != menuContentItem)
      EditorManager.getInstance().reOpen(menuContentItem, null) ;
  }

  /**
   * Editor 오픈 중인지 판단하기 위해서 항목별 MenuContentItem 추출
   * 
   * @param object
   * @return
   * @author kjm, 2020. 7. 3.
   */
  public MenuContentItem getMenuContentItemEntity(Object object)
  {
    AbstractMenuContentProvider menuContentProvider = (AbstractMenuContentProvider) ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).getTreeViewer().getContentProvider() ;

    MenuContent[] menuPath = menuContentProvider.getMenuPath(menuContentProvider.getEntityMenu(object).getMenu().getMenuId(), EntityUtils.getId(object), EntityUtils.hasGroup(object) ? EntityUtils.getGroup(object) : null) ;

    if (menuPath.length > 0)
    {
      for (int index = 0 ; index < menuPath.length ; index++)
      {
        if (menuPath[index] instanceof MenuContentItem)
        {
          MenuContentItem menuContentItem = new MenuContentItem(menuPath[index], menuPath[index].getMenu(), EntityUtils.getId(object), object) ;
          menuContentItem.setLinkOpen(true) ;

          return menuContentItem ;
        }
      }
    }
    return null ;
  }
}
