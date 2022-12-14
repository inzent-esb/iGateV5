/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 *
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.inzent.igate.imanager.tracelog ;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller ;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping ;
import org.springframework.web.bind.annotation.RequestMethod;

import com.inzent.igate.imanager.testcase.TestCaseService;
import com.inzent.igate.repository.log.TestCase;
import com.inzent.igate.repository.log.TraceLog ;
import com.inzent.igate.util.SerializationUtils;

@Controller
@RequestMapping(AbstractTraceLogController.URI)
public class TraceLogController extends AbstractTraceLogController<TraceLog>
{
  @Autowired
  private TestCaseService testCaseService ; 
  
  @RequestMapping(path = "/createTestCase", method = RequestMethod.PUT)
  public void createTestCase(HttpServletRequest request, @ModelAttribute TraceLog traceLog, @ModelAttribute TestCase testCase, BindingResult bindingResult, Model model) throws Exception
  {
    try
    {
      testCase.setTestCaseData(SerializationUtils.serialize(((AbstractTraceLogService) service).getBody(traceLog))) ;
      testCaseService.insert(testCase) ;
    }
    catch (Throwable th) 
    {
      model.addAttribute(MODEL_ERROR, unwrapThrowable(th)) ;
      
      return ;
	}
  }
}
