package jfr.webapp.placeholdermanager.users;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.EwafException;
import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.Const;
import jfr.webapp.placeholdermanager.MyAction;
import jfr.webapp.placeholdermanager.bean.ApplicationBean;
import jfr.webapp.placeholdermanager.bean.PermissionBean;
import jfr.webapp.placeholdermanager.bean.RoleBean;
import jfr.webapp.placeholdermanager.bean.UserProfileBean;

/**
 * Restituisce la lista dei profilu utenti censiti per una data applicazione
 * 
 * @author frusso
 *
 */
public class AddUserProfilesByApplicationAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String roleId = getParameter(request, "roleId");
		String username = getParameter(request, "userName");
		String appId = getParameter(request, "appId");
		String fullName = getParameter(request, "fullName");
		String email = getParameter(request, "email");
		
		
		
		Connection conn = null;
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			PreparedStatement pstm = null;
			
			// Recupera l'applicazione
			String sql = null;
			sql = "insert into UserProfile (appId, roleId, userName, fullName, email) VALUES (?, ?, ?, ?, ?)";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, Long.parseLong(appId));
			pstm.setLong(2, Long.parseLong(roleId));
			pstm.setString(3, username);
			pstm.setString(4, fullName);
			pstm.setString(5, email);
			pstm.executeUpdate();
		
			addInfoMessage(request, "User " + username + " sucessfully profiled");	
		
			pstm.close();
			
			conn.close();
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
