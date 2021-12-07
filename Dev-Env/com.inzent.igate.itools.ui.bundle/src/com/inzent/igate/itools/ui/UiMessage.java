package com.inzent.igate.itools.ui ;

import org.eclipse.osgi.util.NLS ;

public class UiMessage extends NLS
{
  private static final String BUNDLE_NAME = "com.inzent.igate.itools.ui.UiMessage" ; //$NON-NLS-1$

  public static String LABEL_DIRECTORY ; // Directory
  public static String LABEL_EXCEL ; // Excel
  public static String LABEL_EXCEL_EXPORT ; // Excel Export
  public static String LABEL_EXCEL_IMPORT ; // Excel Import
  public static String LABEL_EXPORT ; // Export
  public static String LABEL_FAIL ; // Fail 
  public static String LABEL_FILE_TYPE ; // File Type
  public static String LABEL_IMPORT ; // Import
  public static String LABEL_JSON ; // Json
  public static String LABEL_SAVE_LOCATION ; // Save Location
  public static String LABEL_SUCCESS ; // Success
  public static String LABEL_XML ; // xml
  public static String INFORMATION_IO_MESSAGE1 ; // Export Information
  public static String INFORMATION_IO_MESSAGE10 ; // Do you want to reopen the Editor with the information that performed the import?
  public static String INFORMATION_IO_MESSAGE11 ; // Do you want to proceed with the export?
  public static String INFORMATION_IO_MESSAGE2 ; // Import Information
  public static String INFORMATION_IO_MESSAGE3 ; // Type not supported for export.
  public static String INFORMATION_IO_MESSAGE4 ; // Type not supported for import.
  public static String INFORMATION_IO_MESSAGE5 ; // Please enter a path.
  public static String INFORMATION_IO_MESSAGE6 ; // Type supported for export.
  public static String INFORMATION_IO_MESSAGE7 ; // Specify the storage location by type and run the export.
  public static String INFORMATION_IO_MESSAGE8 ; // Do you want to open the parent folder of the files saved by export?
  public static String INFORMATION_IO_MESSAGE9 ; // There are [{0}] of the items that were successfully imported.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE1 ; // Fail (There is no recognizable sheet)
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE10 ; // OperationRule is null.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE11 ; // [{0}] Failed to open folder.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE2 ; // Fail (Failed for the following reasons)
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE3 ; // This file is not in the correct format.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE4 ; // Fail (DRM release failed)
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE5 ; // Fail (DRM registration failed)
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE6 ; // Enter Save Location.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE7 ; // An error occurred while exporting.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE8 ; // [{0}] Duplicate field ID.
  public static String ERROR_IMPORT_EXPORT_IO_MESSAGE9 ; // [{0}] There is an unregistered reference model.

  static
  {
    NLS.initializeMessages(BUNDLE_NAME, UiMessage.class) ;
  }
}