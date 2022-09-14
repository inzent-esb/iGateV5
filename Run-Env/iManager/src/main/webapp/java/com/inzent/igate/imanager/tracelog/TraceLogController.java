/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 *
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.tracelog ;

import org.springframework.stereotype.Controller ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.inzent.igate.repository.log.TraceLog ;

@Controller
@RequestMapping(AbstractTraceLogController.URI)
public class TraceLogController extends AbstractTraceLogController<TraceLog>
{
}
