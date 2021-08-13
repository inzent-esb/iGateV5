package com.inzent.igate.itools.ui.handlers ;

import java.awt.Desktop ;
import java.io.File ;
import java.io.IOException ;
import java.util.HashMap ;
import java.util.Map ;
import java.util.Set ;
import java.util.TreeSet ;

import org.apache.commons.lang3.StringUtils ;
import org.eclipse.core.commands.ExecutionException ;
import org.eclipse.ui.PlatformUI ;

import com.inzent.igate.itools.handlers.AbstractExportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.dialog.BatchExportDialog ;
import com.inzent.igate.itools.ui.importexport.ExportImportOperationUtils ;
import com.inzent.igate.itools.ui.importexport.ExportImportRecordUtils ;
import com.inzent.igate.itools.ui.importexport.Exporter ;
import com.inzent.igate.itools.views.MenuViewPart ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.itools.util.ClientManager ;
import com.inzent.itools.util.LogHandler ;
import com.inzent.itools.views.AbstractMenuViewPart ;
import com.inzent.itools.views.MenuContentItem ;

public class ExportHandler extends AbstractExportHandler
{
  protected String resulRecordtMessage ;
  protected int exportTotalRecordCount ; // 총 모델 갯수
  protected int exportSuccessRecordCount ; // 성공한 모델 갯수

  protected String resulOperationtMessage ;
  protected int exportTotalOperationCount ; // 총 오퍼레이션 갯수
  protected int exportSuccessOperationCount ; // 성공한 오퍼레이션 갯수

  protected final Exporter<Operation> operationExporter ;
  protected final Exporter<Record> recordExporter ;

  public ExportHandler()
  {
    operationExporter = createOperationExporter() ;
    recordExporter = createRecordExporter() ;
  }

  protected Exporter<Operation> createOperationExporter()
  {
    return new ExportImportOperationUtils() ;
  }

  protected Exporter<Record> createRecordExporter()
  {
    return new ExportImportRecordUtils() ;
  }

  @Override
  protected void exportSelected(Set<MenuContentItem> items) throws ExecutionException
  {
    // 내보내기 Dialog 에서 view에서의 단축키 Ctrl + c, Ctrl + v의 동작을 회피하기 위함
    ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(items.iterator()) ;

    // ======= 내보내기 가능 여부 체크 =======
    TreeSet<String> possibleTypes = new TreeSet<>() ;
    TreeSet<String> impossibleTypes = new TreeSet<>() ;

    for (MenuContentItem menuContentItem : items)
      if (isPossible(menuContentItem.getValue()))
        possibleTypes.add(menuContentItem.getValue().getClass().getSimpleName()) ;
      else
        impossibleTypes.add(menuContentItem.getValue().getClass().getSimpleName()) ;

    // export 시도 항목들 중의 타입별 1 불가능/가능 확인 메시지
    String message = "\n\n" ;
    if (!impossibleTypes.isEmpty())
      message += impossibleTypes.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE3 ;

    if (!possibleTypes.isEmpty())
    {
      message += possibleTypes.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE6 ;
      message += "\n\n" ;
      message += UiMessage.INFORMATION_IO_MESSAGE7 ;
    }

    // export 가능한 타입이 없는 경우 메시치 출력 후 종료
    if (possibleTypes.isEmpty())
    {
      LogHandler.openInformation(message.substring(2)) ;
      return ;
    }
    //export 가능한 타입이 존재 하는 경우 export 진행할지 여부 확인 메시지창 
    else if (!LogHandler.openConfirm(message.substring(2) + "\n\n" + UiMessage.INFORMATION_IO_MESSAGE11))
      return ;
    // ======= 내보내기 가능 여부 체크 =======

    // ======= 내보내기 처리 가능 타입 별로 처리 =======
    // 엔티티 타입별 export 할 경로
    HashMap<String, String> exportTypePathMap = new HashMap<String, String>() ;
    // 엔티이 타입별 export 할 파일의 타입 ( [ ex ] Record : (1)json / (2)excel , Operation : (1)xml )
    HashMap<String, Integer> exportFileTypeMap = new HashMap<String, Integer>() ;

    for (String entityType : possibleTypes)
    {
      // Browse(저장경로)
      BatchExportDialog dialog = new BatchExportDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell()) ;
      // entity 타입 정보 넘김
      dialog.setEntityType(entityType) ;

      if (BatchExportDialog.OK == dialog.open())
      {
        int fileTpye = dialog.getFileType() ;
        String selectedPath = dialog.getDirectoryPath() ;

        if (selectedPath != null)
        {
          exportTypePathMap.put(entityType, selectedPath) ;
          exportFileTypeMap.put(entityType, fileTpye) ;
        }
      }
    }

    // 경로를 지정하지 않은 경우 종료
    if (exportTypePathMap.isEmpty())
      return ;

    resulRecordtMessage = StringUtils.EMPTY ;
    exportTotalRecordCount = 0 ;
    exportSuccessRecordCount = 0 ;

    resulOperationtMessage = StringUtils.EMPTY ;
    exportTotalOperationCount = 0 ;
    exportSuccessOperationCount = 0 ;

    for (MenuContentItem menuContentItem : items)
    {
      String selectedPath = exportTypePathMap.get(menuContentItem.getValue().getClass().getSimpleName()) ;
      if (null == selectedPath)
        continue ;

      // Record 인 경우,
      if (isRecord(menuContentItem.getValue()))
        exportRecord((Record) menuContentItem.getValue(), selectedPath, exportFileTypeMap.get(Record.class.getSimpleName())) ;
      //Operation 인 경우 ,
      else if (isOperation(menuContentItem.getValue()))
        exportOperation((Operation) menuContentItem.getValue(), selectedPath, exportFileTypeMap.get(Operation.class.getSimpleName())) ;
    }

    // 결과 메시지 조립
    String resulTotaltMessage = StringUtils.EMPTY ;
    if (!resulRecordtMessage.equals(StringUtils.EMPTY))
    {
      // export 갯수
      if (exportTotalRecordCount > 0)
        resulRecordtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, exportTotalRecordCount, exportSuccessRecordCount, exportTotalRecordCount - exportSuccessRecordCount) ;

      resulTotaltMessage += resulRecordtMessage ;
    }

    if (!resulOperationtMessage.equals(StringUtils.EMPTY))
    {
      // export 갯수
      if (exportTotalOperationCount > 0)
        resulOperationtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, exportTotalOperationCount, exportSuccessOperationCount, exportTotalOperationCount - exportSuccessOperationCount) ;

      resulTotaltMessage += resulOperationtMessage ;
    }

    if (!resulTotaltMessage.isEmpty())
    {
      if (LogHandler.openConfirm(UiMessage.INFORMATION_IO_MESSAGE1 + resulTotaltMessage + "\n\n" + UiMessage.INFORMATION_IO_MESSAGE8))
      {
        for (String exportPath : exportTypePathMap.values())
        {
          try
          {
            Desktop.getDesktop().open(new File(exportPath)) ;
          }
          catch (IOException e)
          {
            ;
          }
        }
      }
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

  protected void exportRecord(Record record, String selectedPath, int fileTpye)
  {
    if (0 == exportTotalRecordCount)
    {
      resulRecordtMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE, Record.class.getSimpleName()) ;
      resulRecordtMessage += String.format(MetaConstants.MESSAGE_EXPORT_PATH, selectedPath) ;
    }

    exportTotalRecordCount ++ ;

    Record currentRecord = null ;
    try
    {
      currentRecord = ClientManager.getInstance().getIManagerClient().get(record).getObject() ;
    }
    catch (Exception e)
    { 
      LogHandler.openInformation(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE7) ;
    }

    Map<String, Object> resultMap = null ;
    switch (fileTpye)
    {
    case 1 : // JSON 인 경우,
      resultMap = recordExporter.exportJson(selectedPath, currentRecord) ;
      break ;

    case 2 : // Excel 인 경우,
      resultMap = recordExporter.exportExcel(selectedPath, currentRecord) ;
      break ;
    }

    if (null != resultMap)
    {
      resulRecordtMessage += resultMap.get(ExportImportRecordUtils.MESSAGE) ;
      exportSuccessRecordCount += (int) resultMap.get(ExportImportRecordUtils.RESULT_COUNT) ;
    }
  }

  protected void exportOperation(Operation operation, String selectedPath, int fileTpye)
  {
    if (0 == exportTotalOperationCount)
    {
      resulOperationtMessage += String.format(MetaConstants.MESSAGE_ENTITY_TYPE, Operation.class.getSimpleName()) ;
      resulOperationtMessage += String.format(MetaConstants.MESSAGE_EXPORT_PATH, selectedPath) ;
    }

    exportTotalOperationCount ++ ;

    Operation currentOperation = null ;
    try
    {
      currentOperation = ClientManager.getInstance().getIManagerClient().get(operation).getObject() ;
    }
    catch (Exception e)
    {
      LogHandler.openInformation(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE7) ;
    }

    Map<String, Object> resultMap = null ;
    switch (fileTpye)
    {
    case 1 :// xml 인 경우,
      resultMap =  operationExporter.exportXml(selectedPath, currentOperation) ;
      break ;
    }

    if (null != resultMap)
    {
      resulRecordtMessage += resultMap.get(ExportImportOperationUtils.MESSAGE) ;
      exportSuccessOperationCount += (int) resultMap.get(ExportImportOperationUtils.RESULT_COUNT) ;
    }
  }
}
