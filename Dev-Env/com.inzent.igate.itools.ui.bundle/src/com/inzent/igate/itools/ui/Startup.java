/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.ui ;

import org.eclipse.jface.resource.ImageDescriptor ;
import org.eclipse.ui.IStartup ;
import org.eclipse.wb.swt.ResourceManager ;

import com.inzent.igate.itools.activity.dialogs.ActivityFilterDialog ;
import com.inzent.igate.itools.activity.editors.ActivityEditor ;
import com.inzent.igate.itools.activity.utils.ActivityUtils ;
import com.inzent.igate.itools.editors.EntityEditorInput ;
import com.inzent.igate.itools.handlers.FilterHandler ;
import com.inzent.igate.itools.interfaces.InterfaceActivator ;
import com.inzent.igate.itools.interfaces.dialogs.InterfaceFilterDialog ;
import com.inzent.igate.itools.interfaces.dialogs.TestCaseFilterDialog ;
import com.inzent.igate.itools.interfaces.dialogs.TestSuiteFilterDialog ;
import com.inzent.igate.itools.interfaces.editors.InterfaceEditor ;
import com.inzent.igate.itools.interfaces.editors.TestCaseEditor ;
import com.inzent.igate.itools.interfaces.editors.TestSuiteEditor ;
import com.inzent.igate.itools.mapping.MappingActivator ;
import com.inzent.igate.itools.mapping.ValidationMappingStandard ;
import com.inzent.igate.itools.mapping.dialogs.MappingFilterDialog ;
import com.inzent.igate.itools.mapping.editors.MappingEditor ;
import com.inzent.igate.itools.mapping.utils.AutoMappingImpl ;
import com.inzent.igate.itools.mapping.utils.MappingUtils ;
import com.inzent.igate.itools.operation.OperationActivator ;
import com.inzent.igate.itools.operation.dialogs.OperationFilterDialog ;
import com.inzent.igate.itools.operation.editors.OperationEditor ;
import com.inzent.igate.itools.operation.utils.OperationUtils ;
import com.inzent.igate.itools.query.dialogs.QueryFilterDialog;
import com.inzent.igate.itools.query.editors.QueryEditor;
import com.inzent.igate.itools.query.utils.QueryUtils ;
import com.inzent.igate.itools.record.RecordActivator ;
import com.inzent.igate.itools.record.RecordExportHandlerImpl ;
import com.inzent.igate.itools.record.RecordImportHandlerImpl ;
import com.inzent.igate.itools.record.dialogs.RecordFilterDialog ;
import com.inzent.igate.itools.record.editors.RecordEditor ;
import com.inzent.igate.itools.record.utils.RecordUtils ;
import com.inzent.igate.itools.service.ServiceActivator ;
import com.inzent.igate.itools.service.dialogs.ReplyEmulateFilterDialog ;
import com.inzent.igate.itools.service.dialogs.ServiceFilterDialog ;
import com.inzent.igate.itools.service.editors.ReplyEmulateEditor ;
import com.inzent.igate.itools.service.editors.ServiceEditor ;
import com.inzent.igate.itools.testcase.TestCaseExporterImpl ;
import com.inzent.igate.itools.testcase.TestSuiteExporterImpl ;
import com.inzent.igate.repository.log.ReplyEmulate ;
import com.inzent.igate.repository.log.TestCase ;
import com.inzent.igate.repository.log.TestSuite ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Mapping ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Query;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.repository.meta.Service ;

/**
 * <code>Startup</code>
 *
 * @since 2019. 5. 8.
 * @version 5.0
 * @author Jaesuk
 */
public class Startup implements IStartup
{
  @Override
  public void earlyStartup()
  {
    EntityEditorInput.appendEntity(Activity.class, ActivityEditor.ID, t -> getActivityImageDescriptor((Activity) t)) ;
    FilterHandler.appendEntity(Activity.class, ActivityFilterDialog.class) ;

    EntityEditorInput.appendEntity(Interface.class, InterfaceEditor.ID, ResourceManager.getPluginImageDescriptor(InterfaceActivator.PLUGIN_ID, "icons/obj16/interface.png")) ;
    FilterHandler.appendEntity(Interface.class, InterfaceFilterDialog.class) ;

    EntityEditorInput.appendEntity(Mapping.class, MappingEditor.ID, ResourceManager.getPluginImageDescriptor(MappingActivator.PLUGIN_ID, "icons/obj16/mapping.png")) ;
    FilterHandler.appendEntity(Mapping.class, MappingFilterDialog.class) ;

    EntityEditorInput.appendEntity(Operation.class, OperationEditor.ID, ResourceManager.getPluginImageDescriptor(OperationActivator.PLUGIN_ID, "icons/obj16/operation.png")) ;
    FilterHandler.appendEntity(Operation.class, OperationFilterDialog.class) ;

    EntityEditorInput.appendEntity(Record.class, RecordEditor.ID, ResourceManager.getPluginImageDescriptor(RecordActivator.PLUGIN_ID, "icons/obj16/record.png")) ;
    FilterHandler.appendEntity(Record.class, RecordFilterDialog.class) ;

    EntityEditorInput.appendEntity(Service.class, ServiceEditor.ID, ResourceManager.getPluginImageDescriptor(ServiceActivator.PLUGIN_ID, "icons/obj16/service.png")) ;
    FilterHandler.appendEntity(Service.class, ServiceFilterDialog.class) ;

    EntityEditorInput.appendEntity(ReplyEmulate.class, ReplyEmulateEditor.ID, ResourceManager.getPluginImageDescriptor(ServiceActivator.PLUGIN_ID, "icons/obj16/replyEmulate.png")) ;
    FilterHandler.appendEntity(ReplyEmulate.class, ReplyEmulateFilterDialog.class) ;

    EntityEditorInput.appendEntity(TestCase.class, TestCaseEditor.ID, ResourceManager.getPluginImageDescriptor(InterfaceActivator.PLUGIN_ID, "icons/obj16/testCase.png")) ;
    FilterHandler.appendEntity(TestCase.class, TestCaseFilterDialog.class) ;

    EntityEditorInput.appendEntity(TestSuite.class, TestSuiteEditor.ID, ResourceManager.getPluginImageDescriptor(InterfaceActivator.PLUGIN_ID, "icons/obj16/testSuite.png")) ;
    FilterHandler.appendEntity(TestSuite.class, TestSuiteFilterDialog.class) ;
    
    EntityEditorInput.appendEntity(Query.class, QueryEditor.ID, QueryUtils.getFigureImageDescriptor(QueryUtils.IMAGE_QUERY)) ;
    FilterHandler.appendEntity(Query.class, QueryFilterDialog.class) ;
    
    MappingUtils.classLoader = this.getClass().getClassLoader() ;

    MappingUtils.validationMappingInstance = new ValidationMappingStandard() ;
    
    MappingUtils.autoMapping = new AutoMappingImpl();

    RecordUtils.exportHandler = new RecordExportHandlerImpl() ;

    RecordUtils.importHandler = new RecordImportHandlerImpl() ;

    new TestCaseExporterImpl() ; // TestCase Result 탭의 다른이름저장 버튼 처리 -Excel 저장

    new TestSuiteExporterImpl() ; // TestSuite Result 탭의 다른이름저장 버튼 처리 -Excel 저장
  }

  protected ImageDescriptor getActivityImageDescriptor(Activity t)
  {
    switch (t.getActivityType())
    {
    case Activity.TYPE_CONTROL :
      switch (t.getActivityId())
      {
      case "Break" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_BREAK) ;
      case "Case" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_CASE) ;
      case "Condition" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_CONDITION) ;
      case "Continue" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_CONTINUE) ;
      case "Default" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_DEFAULT) ;
      case "End" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_END) ;
      case "FaultHandler" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_FAULT_HANDLER) ;
      case "ForEach" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_FOR_EACH) ;
      case "Fork" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_FORK) ;
      case "InvokeActivity" :
        return ActivityUtils.getFigureImageDescriptor(ActivityUtils.IMAGE_ACTIVITY) ;
      case "InvokeOperation" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_OPERATION) ;
      case "ReThrow" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_RETHROW) ;
      case "Scope" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_SCOPE) ;
      case "Script" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_SCRIPT) ;
      case "Switch" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_SWITCH) ;
      case "Throw" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_THROW) ;
      case "While" :
        return OperationUtils.getFigureImageDescriptor(OperationUtils.IMAGE_WHILE) ;
      }

    default :
      if (t.getActivityProject() == null)
        return ActivityUtils.getFigureImageDescriptor(ActivityUtils.IMAGE_ACTIVITY) ;
      else
        return ActivityUtils.getFigureImageDescriptor(ActivityUtils.IMAGE_ACTIVITY_CUSTOM) ;
    }
  }
}
