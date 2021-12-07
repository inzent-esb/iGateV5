/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.record ;

import java.awt.Desktop ;
import java.io.File ;
import java.io.IOException ;
import java.util.Map ;

import org.eclipse.osgi.util.NLS ;
import org.eclipse.ui.PlatformUI ;

import com.inzent.igate.itools.record.utils.RecordExportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.dialog.BatchExportDialog ;
import com.inzent.igate.itools.ui.importexport.ExportImportRecordUtils ;
import com.inzent.igate.itools.ui.importexport.Exporter ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.itools.util.LogHandler ;

/**
 * <code>RecordExportHandlerImpl</code>
 *
 * @since 2021. 2. 8.
 * @version 5.0
 * @author Jaesuk Byon
 */
public class RecordExportHandlerImpl implements RecordExportHandler
{
  protected final Exporter<Record> recordExporter ;

  public RecordExportHandlerImpl()
  {
    recordExporter = createRecordExporter() ;
  }

  protected Exporter<Record> createRecordExporter()
  {
    return new ExportImportRecordUtils() ;
  }

  @Override
  public void exportRecord(Record record)
  {
    // ======= �������� ó�� ���� Ÿ�� ���� ó�� =======
    BatchExportDialog dialog = new BatchExportDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell()) ;

    // entity Ÿ�� ���� �ѱ�
    dialog.setEntityType(Record.class.getSimpleName()) ;

    // ��θ� �������� ���� ��� ����
    if (BatchExportDialog.OK != dialog.open() || null == dialog.getDirectoryPath())
      return ;

    String selectedPath = dialog.getDirectoryPath() ;

    Map<String, Object> resultMap ;
    switch (dialog.getFileType())
    {
    case 1 :
      resultMap = recordExporter.exportJson(selectedPath, record) ;
      break ;

    case 2 :
      resultMap = recordExporter.exportExcel(selectedPath, record) ;
      break ;

    default :
      resultMap = null ;
    }

    if (null != resultMap)
    {
      // ��� �޽��� ����
      String resulRecordtMessage = String.format(MetaConstants.MESSAGE_ENTITY_TYPE, Record.class.getSimpleName()) ;
      resulRecordtMessage += String.format(MetaConstants.MESSAGE_EXPORT_PATH, selectedPath) ;
      resulRecordtMessage += resultMap.get(ExportImportRecordUtils.MESSAGE) ;
      resulRecordtMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, 1, (int) resultMap.get(ExportImportRecordUtils.RESULT_COUNT), 1 - (int) resultMap.get(ExportImportRecordUtils.RESULT_COUNT)) ;

      // �������� ��� ��� & ��������� ������ ������ ���� ������ ���ڽ��ϱ�? Ȯ�� �޽��� â
      if (LogHandler.openConfirm(UiMessage.INFORMATION_IO_MESSAGE1 + resulRecordtMessage + "\n\n" + UiMessage.INFORMATION_IO_MESSAGE8))
      {
        try
        {
          Desktop.getDesktop().open(new File(selectedPath)) ;
        }
        catch (IOException e)
        {
          LogHandler.openError(RecordActivator.PLUGIN_ID, NLS.bind(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE11, selectedPath)) ;
        }
      }
    }
  }
}
