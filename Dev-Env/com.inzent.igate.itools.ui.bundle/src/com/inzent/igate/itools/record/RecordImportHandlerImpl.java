/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.record ;

import java.util.List ;
import java.util.Map ;

import org.eclipse.swt.SWT ;
import org.eclipse.swt.widgets.FileDialog ;
import org.eclipse.ui.PlatformUI ;

import com.inzent.igate.itools.record.utils.RecordImportHandler ;
import com.inzent.igate.itools.ui.MetaConstants ;
import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.itools.ui.importexport.ExportImportRecordUtils ;
import com.inzent.igate.itools.ui.importexport.Importer ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.itools.util.LogHandler ;

/**
 * <code>RecordImportHandlerImpl</code>
 *
 * @since 2021. 2. 8.
 * @version 5.0
 * @author Jaesuk Byon
 */
public class RecordImportHandlerImpl implements RecordImportHandler
{
  protected final Importer<Record> recordImporter ;

  public RecordImportHandlerImpl()
  {
    recordImporter = createRecordImporter() ;
  }

  protected Importer<Record> createRecordImporter()
  {
    return new ExportImportRecordUtils() ;
  }

  @Override
  @SuppressWarnings("unchecked")
  public void importRecord(Record record)
  {
    // 가져오기 다이얼로그 (한개만 선택가능)
    FileDialog fileDialog = new FileDialog(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(), SWT.SINGLE) ;
    fileDialog.setText(String.format("%s %s", Record.class.getSimpleName(), UiMessage.LABEL_IMPORT)) ;
    fileDialog.setFilterExtensions(new String[] { MetaConstants.FILTER_FILE_EXTENDER_EXCEL1, MetaConstants.FILTER_FILE_EXTENDER_EXCEL2, MetaConstants.FILTER_FILE_EXTENDER_JSON }) ;
    /*
     * Kiuwan
     * Avoid absolute paths 처리
     */
    fileDialog.setFilterPath(System.getProperty("user.home")) ;

    String selectedPath = fileDialog.open() ;
    if (selectedPath == null)
      return ;

    Map<String, Object> resultMap  ;
    switch (fileDialog.getFilterIndex())
    {
    case 0 : // .xlsx
    case 1 : // .xls
      resultMap = recordImporter.importExcel(fileDialog.getFilterPath(), fileDialog.getFileNames(), record) ;
      break ;

    case 2 : // .json
      resultMap = recordImporter.importJson(fileDialog.getFilterPath(), fileDialog.getFileNames(), record) ;
      break ;

    default :
      resultMap = null ;
      break ;
    }

    if (null != resultMap)
    {
      List<Object> importSuccessList = (List<Object>) resultMap.get(ExportImportRecordUtils.RESULT_List) ;

      String resultMessage = String.format(MetaConstants.MESSAGE_ENTITY_TYPE, Record.class.getSimpleName()) ;
      resultMessage += resultMap.get(ExportImportRecordUtils.MESSAGE) ;
      resultMessage += String.format(MetaConstants.MESSAGE_SUMMARYINFO, fileDialog.getFileNames().length, importSuccessList.size(), fileDialog.getFileNames().length - importSuccessList.size()) ;

      // 가져내기 결과 목록 확인 창
      LogHandler.openInformation(UiMessage.INFORMATION_IO_MESSAGE2 + resultMessage) ;
    }
  }
}
