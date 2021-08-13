/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.itools.ui.importexport ;

import java.util.Map ;

/**
 * <code>Importer</code>
 *
 * @since 2021. 8. 6.
 * @version 5.0
 * @author Jaesuk Byon
 */
public interface Importer<T>
{
  public Map<String, Object> importJson(String path, String[] fileList, T object) ;
  public Map<String, Object> importExcel(String path, String[] fileList, T object) ;
  public Map<String, Object> importXml(String path, String[] fileList, T object) ;

  public default String decryption(String filePath, boolean start) throws Exception
  {
    return filePath ;
  }
}
