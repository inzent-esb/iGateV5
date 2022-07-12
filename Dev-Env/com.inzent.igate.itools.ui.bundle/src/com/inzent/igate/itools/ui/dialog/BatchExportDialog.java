package com.inzent.igate.itools.ui.dialog ;

import java.io.File;

import org.apache.commons.lang3.StringUtils ;
import org.eclipse.jface.dialogs.Dialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.DirectoryDialog ;
import org.eclipse.swt.widgets.Display ;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label ;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import com.inzent.igate.itools.ui.UiMessage ;
import com.inzent.igate.repository.meta.Operation ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.itools.util.LogHandler ;

public class BatchExportDialog extends Dialog
{
  public BatchExportDialog(Shell parentShell)
  {
    super(parentShell) ;
  }
  // 파일형식
  public String EntityType = null;
  private int fileType = 1 ;
  private static Group group1 ;
  private Button btnType1 ;
  private Button btnType2 ;
  
  // 경로
  private String directoryPath ;
  private static Group group_2 ;
  private static Text txtDir ;
  private static Button btnBrowse ;
  
  private ButtonBrowseMouseSelectionListener buttonBrowseMouseSelectionListener = new ButtonBrowseMouseSelectionListener() ;
  
  @Override
  protected Control createDialogArea(Composite parent) // Control
  {
    getShell().setText(getEntityType() == null ?
          UiMessage.LABEL_EXPORT : String.format("%s %s", getEntityType(),UiMessage.LABEL_EXPORT));
    
    
    Composite container = (Composite) super.createDialogArea(parent) ;
    container.setLayout(new GridLayout(1, false)) ;

    group1 = new Group(container, SWT.NONE) ;
    GridData gd_group_1 = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1) ;
    gd_group_1.widthHint = 510 ;
    group1.setLayoutData(gd_group_1) ;
    group1.setText(UiMessage.LABEL_FILE_TYPE) ;
    group1.setLayout(new GridLayout(2, false)) ;

    btnType1 = new Button(group1, SWT.RADIO) ;
    btnType1.addSelectionListener(new SelectionAdapter()
    {
      @Override
      public void widgetSelected(SelectionEvent e)
      {
        fileType = 1 ;
      }
    }) ;

    btnType2 = new Button(group1, SWT.RADIO) ;
    btnType2.addSelectionListener(new SelectionAdapter()
    {
      @Override
      public void widgetSelected(SelectionEvent e)
      {
        fileType = 2 ;
      }
    }) ;

    group_2 = new Group(container, SWT.NONE) ;
    group_2.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1)) ;
    group_2.setText(UiMessage.LABEL_SAVE_LOCATION) ;
    group_2.setLayout(new GridLayout(3, false)) ;
    
    Label lblFolder = new Label(group_2, SWT.NONE) ;
    lblFolder.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1)) ;
    lblFolder.setText(UiMessage.LABEL_DIRECTORY+":") ;

    txtDir = new Text(group_2, SWT.BORDER) ;
    GridData gd_txtDir = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1) ;
    gd_txtDir.widthHint = 248 ;
    txtDir.setLayoutData(gd_txtDir) ;

    btnBrowse = new Button(group_2, SWT.NONE) ;
    btnBrowse.setText("...") ; //$NON-NLS-1$
    
    btnBrowse.addSelectionListener(buttonBrowseMouseSelectionListener) ;
    
    //entity 타입별 초기 설정 처리 
    init() ;
    
    return container ;
  }

  // 내보내기 entity type 명
  public String getEntityType()
  {
    return EntityType ;
  }

  public void setEntityType(String entityType)
  {
    EntityType = entityType ;
  }

  // Browse(저장경로)
  private class ButtonBrowseMouseSelectionListener extends SelectionAdapter
  {
    @Override
    public void widgetSelected(SelectionEvent event)
    {
      DirectoryDialog dirDialog = new DirectoryDialog(Display.getCurrent().getActiveShell()) ;
      dirDialog.setFilterPath("C:/") ; //$NON-NLS-1$
      String selected = dirDialog.open() ;
      
      if(selected != null) 
        txtDir.setText(selected) ;
    }
  }

  // ok 버튼 눌렀을 때의 파일 경로를 넘겨주기 위해, 변수 (directoryPath)에 담음 
  @Override
  protected void okPressed() {
    if (txtDir.getText() != "")
    {
      dircetoryPathCheck() ;
      directoryPath = txtDir.getText() ;
      setReturnCode(OK);
      close();
    }
    else
      LogHandler.openInformation(UiMessage.ERROR_IMPORT_EXPORT_IO_MESSAGE6) ;
  }
  
  // 디렉토리 존재여부 확인 (없는 디렉토리의 경우 생성)
  private void dircetoryPathCheck() 
  {
    File directory = new File(txtDir.getText());
    
    if(!directory.exists())
      directory.mkdir() ;
  }
  
  public int getFileType()
  {
    return fileType ;
  }

  public void setFileType(int fileType)
  {
    this.fileType = fileType ;
  }

  public String getDirectoryPath()
  {
    return directoryPath ;
  }

  public void setDirectoryPath(String directoryPath)
  {
    this.directoryPath = directoryPath ;
  }

  /**
   * entity 타입별 초기 설정 처리
   * @author kjm, 2020. 6. 23.
   */
  public void init()
  {
    //Record
    if(getEntityType().equals(Record.class.getSimpleName()))
    {
      btnType1.setText(UiMessage.LABEL_JSON) ;  //[1]json
      btnType2.setText(UiMessage.LABEL_EXCEL) ; //[2]excel
    }
    //Operation
    else if(getEntityType().equals(Operation.class.getSimpleName()))
    {
      btnType1.setText(UiMessage.LABEL_XML) ; //[1]xml
      
      btnType2.setText(StringUtils.EMPTY) ;   //[2]없음
      btnType2.setVisible(false);
    }
    
    //젓번째 항목 선택
    
    btnType1.setSelection(true);
    btnType2.setSelection(false);

    fileType = 1 ;
  }
}
