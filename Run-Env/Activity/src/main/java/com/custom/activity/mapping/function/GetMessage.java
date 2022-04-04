/*******************************************************************************
 * This program and the accompanying materials are made
 * available under the terms of the Inzent MCA License v1.0
 * which accompanies this distribution.
 * 
 * Contributors:
 *     Inzent Corporation - initial API and implementation
 *******************************************************************************/
package com.custom.activity.mapping.function ;

import org.apache.commons.lang3.StringUtils;

import com.inzent.igate.exception.IGateException ;
import com.inzent.igate.mapping.operator.AbstractExpressionFunction ;
import com.inzent.igate.repository.meta.Activity ;
import com.inzent.igate.util.message.MessageTranslator;

public class GetMessage extends AbstractExpressionFunction
{
	public GetMessage(Activity meta)
	{
		super(meta) ;
	}

	@Override
	public boolean isSingleton()
	{
		return true ;
	}

	@Override
	public int getArgumentCount()
	{
		return 3 ;
	}

	@Override
	protected Object doExecute(Object... args) throws IGateException
	{
		String langCd 	= ( null!= args[0] ? (String) args[0] : "en" );
		String resCd 	= ( null!= args[1] ? (String) args[1] : null );
		String adapterId = ( null!= args[2] ? (String) args[2] : "I_MCA" );
		logger.debug("### langCd : [" + langCd +"]");
		logger.debug("### resCd : [" + resCd +"]");
		logger.debug("### adapterId : [" + adapterId +"]");

		int idx = 0;
		String retMessage = "";

		if(resCd != null)	
		{	
			logger.debug("### MessageTranslator.getStandardMessage(resCd, adapterId, langCd) : [" + MessageTranslator.getStandardMessage(resCd, adapterId, langCd) +"]");
			for (String message : MessageTranslator.getStandardMessage(resCd.trim(), adapterId, langCd))
			{
				logger.debug("### message : [" + message +"]");
				if (StringUtils.isBlank(message))
					break ;

				if (0 != idx)
					retMessage += " , ";
				retMessage += message ;

				idx ++;
			}
		}
		
		logger.debug("### retMessage : [" + retMessage +"]");
		return retMessage;
	}
}

