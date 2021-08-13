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
  protected int exportTotalRecordCount ; // �� �� ����
  protected int exportSuccessRecordCount ; // ������ �� ����

  protected String resulOperationtMessage ;
  protected int exportTotalOperationCount ; // �� ���۷��̼� ����
  protected int exportSuccessOperationCount ; // ������ ���۷��̼� ����

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
    // �������� Dialog ���� view������ ����Ű Ctrl + c, Ctrl + v�� ������ ȸ���ϱ� ����
    ((AbstractMenuViewPart) PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().findView(MenuViewPart.ID)).refresh(items.iterator()) ;

    // ======= �������� ���� ���� üũ =======
    TreeSet<String> possibleTypes = new TreeSet<>() ;
    TreeSet<String> impossibleTypes = new TreeSet<>() ;

    for (MenuContentItem menuContentItem : items)
      if (isPossible(menuContentItem.getValue()))
        possibleTypes.add(menuContentItem.getValue().getClass().getSimpleName()) ;
      else
        impossibleTypes.add(menuContentItem.getValue().getClass().getSimpleName()) ;

    // export �õ� �׸�� ���� Ÿ�Ժ� 1 �Ұ���/���� Ȯ�� �޽���
    String message = "\n\n" ;
    if (!impossibleTypes.isEmpty())
      message += impossibleTypes.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE3 ;

    if (!possibleTypes.isEmpty())
    {
      message += possibleTypes.toString() + " " + UiMessage.INFORMATION_IO_MESSAGE6 ;
      message += "\n\n" ;
      message += UiMessage.INFORMATION_IO_MESSAGE7 ;
    }

    // export ������ Ÿ���� ���� ��� �޽�ġ ��� �� ����
    if (possibleTypes.isEmpty())
    {
      LogHandler.openInformation(message.substring(2)) ;
      return ;
    }
    //export ������ Ÿ���� ���� �ϴ� ��� export �������� ���� Ȯ�� �޽���â 
    else if (!LogHandler.openConfirm(message.substring(2) + "\n\n" + UiMessage.INFORMATION_IO_MESSAGE11))
      return ;
    // ======= �������� ���� ���� üũ =======

    // ======= �������� ó�� ���� Ÿ�� ���� ó�� =======
    // ��ƼƼ Ÿ�Ժ� export �� ���
    HashMap<String, String> exportTypePathMap = new HashMap<String, String>() ;
    // ��Ƽ�� Ÿ�Ժ� export �� ������ Ÿ�� ( [ ex ] Record : (1)json / (2)excel , Operation : (1)xml )
    HashMap<String, Integer> exportFileTypeMap = new HashMap<String, Integer>() ;

    for (String entityType : possibleTypes)
    {
      // Browse(������)
      BatchExportDialog dialog = new BatchExportDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell()) ;
      // entity Ÿ�� ���� �ѱ�
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

    // ��θ� �������� ���� ��� ����
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

      // Record �� ���,
      if (isRecord(menuContentItem.getValue()))
        exportRecord((Record) menuContentItem.getValue(), selectedPath, exportFileTypeMap.get(Record.class.getSimpleName())) ;
      //Operation �� ��� ,
      else if (isOperation(menuContentItem.getValue()))
        exportOperation((Operation) menuContentItem.getValue(), selectedPath, exportFileTypeMap.get(Operation.class.getSimpleName())) ;
    }

    // ��� �޽��� ����
    String resulTotaltMessage = StringUtils.EMPTY ;
    if (!resulRecordtMessage.equals(StringUtils.EMPTY))
    {
      // export ����
      if (exportTotalRecordCount > 0)
        resulRecordtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, exportTotalRecordCount, exportSuccessRecordCount, exportTotalRecordCount - exportSuccessRecordCount) ;

      resulTotaltMessage += resulRecordtMessage ;
    }

    if (!resulOperationtMessage.equals(StringUtils.EMPTY))
    {
      // export ����
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
    case 1 : // JSON �� ���,
      resultMap = recordExporter.exportJson(selectedPath, currentRecord) ;
      break ;

    case 2 : // Excel �� ���,
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
    case 1 :// xml �� ���,
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
