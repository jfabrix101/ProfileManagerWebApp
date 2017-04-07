package jfr.webapp.placeholdermanager.profiles;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.MyAction;

/**
 * Restituisce la lista delle applicazioni censite
 * 
 * @author frusso
 *
 */
public class UpdateApplicationProfileAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Connection conn = null;
		
		String _appId = request.getParameter("appId");
		String _selectedRole = request.getParameter("selectedRole");
		
		
		long appId = Long.parseLong(_appId);
		long selectedRole = Long.parseLong(_selectedRole);
		
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			conn.setAutoCommit(false);
			String sql = "DELETE FROM ApplicationProfile where roleId = ?";
			PreparedStatement pstm = conn.prepareStatement(sql);
			pstm.setLong(1, selectedRole);
			pstm.executeUpdate();
			
			sql = "INSERT INTO ApplicationProfile (appId, roleId, permissionId) values (?, ?, ?)";
			pstm = conn.prepareStatement(sql);
			Enumeration<String> keyEnum = request.getParameterNames();
			while (keyEnum.hasMoreElements()) {
				String key = keyEnum.nextElement();
				String val = request.getParameter(key);
				if (!key.startsWith("value_")) continue;
				pstm.setLong(1, appId);
				pstm.setLong(2, selectedRole);
				pstm.setLong(3, Long.parseLong(key.substring(6)));
				pstm.executeUpdate();
				pstm.clearParameters();
				logger.debug("Param " + Long.parseLong(key.substring(6)));
			}
			conn.commit();
			
			pstm.close();
			
			conn.close();
			
			addInfoMessage(request, "Application profile successfully updated !");
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) {
				conn.rollback();
				conn.close();
			}
		}
		
		return OK;
	}
	
	
}
