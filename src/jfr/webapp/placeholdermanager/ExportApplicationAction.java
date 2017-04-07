package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.EwafException;
import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.SimpleXMLHelper;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.bean.ApplicationBean;
import jfr.webapp.placeholdermanager.bean.PermissionBean;
import jfr.webapp.placeholdermanager.bean.PlaceholderBean;
import jfr.webapp.placeholdermanager.bean.RoleBean;
import jfr.webapp.placeholdermanager.xml.XmlApplicationDescription;

/**
 * Restituisce la lista delle applicazioni censite
 * 
 * @author frusso
 *
 */
public class ExportApplicationAction extends MyAction {

	
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
		
		XmlApplicationDescription xml = new XmlApplicationDescription();
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = null;
			PreparedStatement pstm = null;
			ResultSet rs = null;
			
			if (item == null) {
				sql = "SELECT id, appName,appDescription, tmsInsert, tmsUpdate, appToken "
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
				item.appToken = rs.getString(6);
				
				rs.close();
				pstm.close();
				request.getSession().setAttribute(SESSION_APPLICATION_BEAN, item);
			}
			
			xml.name = item.appName;
			xml.description = item.appDescription;
			xml.appToken = item.appToken;
			
			sql = "select id, roleName, roleDesc from Role where appId = ? order by roleName";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			while (rs.next()) {
				RoleBean r = new RoleBean();
				r.id = rs.getLong(1);
				r.roleName = rs.getString(2);
				r.roleDescription = rs.getString(3);
				xml.roleList.add(r);
			}
			rs.close(); pstm.close();
			
			sql = "select id, permissionName, permissionDesc from Permission where appId =  ? order by permissionName";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			while (rs.next()) {
				PermissionBean r = new PermissionBean();
				r.id = rs.getLong(1);
				r.permissionName = rs.getString(2);
				r.permissionDesc = rs.getString(3);
				xml.permissionList.add(r);
			}
			rs.close(); pstm.close();
			
			
			sql = "select placeholderName, placeholderValue, placeholderEnabled from Placeholder where appId =  ? order by placeholderName";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			while (rs.next()) {
				PlaceholderBean pItem = new PlaceholderBean();
				pItem.placeholderName = rs.getString(1);
				pItem.placeholderValue = rs.getString(2);
				pItem.placeholderEnabled = (rs.getInt(3) != 0);
				xml.placeholderList.add(pItem);
			}
			rs.close(); pstm.close();
			
			
			sql = "select roleName, permissionName from ApplicationProfile ap"
					+ " join Permission perm on perm.id = ap.permissionId"
					+ " join Role r on r.id = ap.roleId"
					+ " where ap.appId = ?"
					+ " order by roleName, permissionName";
			pstm = conn.prepareStatement(sql);
			pstm.setLong(1, item.id);
			rs = pstm.executeQuery();
			while (rs.next()) {
				xml.applicationProfileMap.put(rs.getString(1), rs.getString(2));
			}
			rs.close(); pstm.close();
			
			conn.close();
			
			response.setContentType("text/xml");
			String res = SimpleXMLHelper.toString(xml);
			response.getOutputStream().print(res);
			return null;
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
