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
 * <code>Exporter</code>
 *
 * @since 2021. 8. 6.
 * @version 5.0
 * @author Jaesuk Byon
 */
public interface Exporter<T>
{
  public Map<String, Object> exportJson(String path, T object) ;
  public Map<String, Object> exportExcel(String path, T object) ;
  public Map<String, Object> exportXml(String path, T object) ;

  public default void encryption(String filePath) throws Exception { }
}
