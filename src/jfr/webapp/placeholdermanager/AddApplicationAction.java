package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;

public class AddApplicationAction extends MyAction {

	private UUID uuid = UUID.randomUUID();
	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String appName = getParameter(request, "appName");
		String appDescription  = getParameter(request, "appDescription");
		if (StringHelper.isEmpty(appDescription)) appDescription = "";
		
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "INSERT INTO Application (id, appName, appDescription, appToken) VALUES (?, ?, ?, ?)";
			PreparedStatement pstm = conn.prepareStatement(sql);
			
			long id = System.currentTimeMillis();
			System.out.println(id);
			pstm.setLong(1, id);
			pstm.setString(2, appName);
			pstm.setString(3, appDescription);
			pstm.setString(4, uuid.toString());
			
			pstm.executeUpdate();
			request.getSession().setAttribute(SESSION_APPLICATION_ID, id);
			request.getSession().setAttribute(SESSION_APPLICATION_NAME, appName);
			pstm.close();
			conn.close();
			
			addInfoMessage(request, "Aggiunta applicazione " + appName);
			request.setAttribute("id", "" + id);
			
			logger.debug("Saved application " + appName + " with id " + id);
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
			return ERROR;
		}
		
		return OK;
	}

}
