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
public class ListUserProfilesByApplicationAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Connection conn = null;
		String id = getParameter(request, "appId");
		ApplicationBean item = null;
		if (id == null) {
			item = (ApplicationBean) request.getSession().getAttribute(Const.SESSION_APPLICATION_BEAN);
			id = "" + item.id;
		}
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = null;
			PreparedStatement pstm = null;
			ResultSet rs = null;
			
			// Recupera l'applicazione
			
			sql = "SELECT id, appName,appDescription, tmsInsert, tmsUpdate "
				+ "FROM Application where id = ?";
			pstm = conn.prepareStatement(sql);
			pstm.setString(1, id);
			rs = pstm.executeQuery();
		
			boolean found = rs.next();
			if (!found) {
				throw new EwafException("Illegal application ID");
			}
		
			item = new ApplicationBean();
			item.id = rs.getLong(1);
			item.appName = rs.getString(2);
			item.appDescription = rs.getString(3);
			item.tmsInsert = rs.getTimestamp(4).getTime();
			item.tmsUpdate = rs.getTimestamp(5).getTime();
			
		
			rs.close();
			pstm.close();
			request.getSession().setAttribute(SESSION_APPLICATION_BEAN, item);
			
			
			sql = "select id, roleName, roleDesc from Role where appId = ?";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			List<RoleBean> roleList = new ArrayList<RoleBean>();
			while (rs.next()) {
				RoleBean r = new RoleBean();
				r.id = rs.getLong(1);
				r.roleName = rs.getString(2);
				r.roleDescription = rs.getString(3);
				roleList.add(r);
			}
			rs.close(); pstm.close();
			request.getSession().setAttribute(SESSION_ROLE_LIST, roleList);
			
			
			sql = " select r.id, r.roleName, up.userName, up.fullName, up.email from UserProfile up "
					+ " 	join Role r on up.roleId = r.id"
					+ "  where up.appId = ?";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			List<UserProfileBean> upList = new ArrayList<UserProfileBean>();
			while (rs.next()) {
				UserProfileBean r = new UserProfileBean();
				r.roleId = rs.getLong(1);
				r.roleName = rs.getString(2);
				r.userName = rs.getString(3);
				r.fullName = rs.getString(4);
				r.email = rs.getString(5);
				upList.add(r);
			}
			rs.close(); pstm.close();
			request.getSession().setAttribute(SESSION_USERPROFILE_LIST, upList);
			logger.debug("Found " + upList.size() + " userProfiles for application " + item);
			
			conn.close();
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
