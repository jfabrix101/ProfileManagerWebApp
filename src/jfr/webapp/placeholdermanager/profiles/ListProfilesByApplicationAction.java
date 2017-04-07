package jfr.webapp.placeholdermanager.profiles;

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

/**
 * Restituisce la lista delle applicazioni censite
 * 
 * @author frusso
 *
 */
public class ListProfilesByApplicationAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Connection conn = null;
		String id = getParameter(request, "appId");
		ApplicationBean item = null;
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = null;
			PreparedStatement pstm = null;
			ResultSet rs = null;
			
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
			logger.debug("Found " + roleList.size() + " roles for application " + item);
			
			sql = "select id, permissionName, permissionDesc from Permission where appId =  ? order by permissionName";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			List<PermissionBean> permissionList = new ArrayList<PermissionBean>();
			while (rs.next()) {
				PermissionBean r = new PermissionBean();
				r.id = rs.getLong(1);
				r.permissionName = rs.getString(2);
				r.permissionDesc = rs.getString(3);
				permissionList.add(r);
			}
			rs.close(); pstm.close();
			
			
			
			request.getSession().setAttribute(SESSION_PERMISSION_LIST, permissionList);
			logger.debug("Found " + permissionList.size() + " permissions for application " + item);
			
			Set<Long> permissionEnabled = new java.util.HashSet();
			
			String _selectedRole = request.getParameter("selectedRole");
			if (_selectedRole == null && roleList.size() > 0) _selectedRole = "" + roleList.get(0).id; 
			
			try {
				long selectedRole = Long.parseLong(_selectedRole);
				sql = "select permissionId from ApplicationProfile where roleId = ?";
				pstm = conn.prepareStatement(sql);
				pstm.setLong(1, selectedRole);
				rs = pstm.executeQuery();
				while (rs.next()) {
					permissionEnabled.add(rs.getLong(1));
				}
				rs.close(); pstm.close();
			} catch (Exception e) {}
			
			request.getSession().setAttribute("set", permissionEnabled);
			
			
			conn.close();
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
