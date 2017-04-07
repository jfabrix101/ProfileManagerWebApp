package jfr.webapp.placeholdermanager;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.servlet.EwafAction;
import jfabrix101.ewaf.util.StringHelper;

public abstract class MyAction extends EwafAction implements Const {

	
	public abstract String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception;
	
	@Override
	public String executeAction(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String res = null;
		try {
			res = executeRequest(config, request, response);
		} catch (Exception e) {
			e.printStackTrace();
			addErrorMessage(request, "Exception : " + StringHelper.dumpException(e));
			res = ERROR;
		}
		return res;
	}

	@Override
	protected String validate(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub
		return null;
	}

}
