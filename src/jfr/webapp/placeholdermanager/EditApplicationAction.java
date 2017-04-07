package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.bean.ApplicationBean;
import jfr.webapp.placeholdermanager.bean.PlaceholderBean;

public class EditApplicationAction extends MyAction {

	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Object id = getParameter(request, "id");
		long appId = 0;
		if (id == null) {
			ApplicationBean appBean = (ApplicationBean) request.getSession().getAttribute(SESSION_APPLICATION_BEAN);
			if (appBean != null) id = appBean.id;
		}
		try {
			appId = Long.parseLong(id.toString());
		} catch (Exception e) {
			addErrorMessage(request, "Invalid id for application");
			return ERROR;
		}
		
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
		
			String sql = "SELECT id, appName,appDescription, tmsInsert, tmsUpdate "
					+ "FROM Application WHERE id = ?";
			PreparedStatement pstm = conn.prepareStatement(sql);
			pstm.setLong(1, appId);
			ResultSet rs = pstm.executeQuery();
			ApplicationBean item = new ApplicationBean();
			if (!rs.next()) {
				addErrorMessage(request, "Application not found for id " + id);
				rs.close(); pstm.close(); conn.close();
				return ERROR;
				
			} else {
				item.id = rs.getLong(1);
				item.appName = rs.getString(2);
				item.appDescription = rs.getString(3);
				item.tmsInsert = rs.getLong(4);
				item.tmsUpdate = rs.getLong(5);
			}
			rs.close(); pstm.close(); 
			
			sql = "SELECT id, placeholderName, placeholderValue, placeholderEnabled, tmsInsert, tmsUpdate  "
					+ "FROM Placeholder WHERE appId = ? ORDER BY tmsUpdate desc";
			pstm = conn.prepareStatement(sql);
			
			pstm.setLong(1, appId);
			
			rs = pstm.executeQuery();
			
			List<PlaceholderBean> items = new ArrayList<>();
			while (rs.next()) {
				PlaceholderBean x = new PlaceholderBean();
				x.setId(rs.getLong(1));
				x.placeholderName = rs.getString(2);
				x.placeholderValue = rs.getString(3);
				x.placeholderEnabled = (rs.getInt(4) == 0 ? false : true);
				x.tmsInsert = rs.getTimestamp(5).getTime();
				x.tmsUpdate = rs.getTimestamp(6).getTime();
				items.add(x);
			}
			rs.close();
			pstm.close();
			
		
			
			request.getSession().setAttribute(SESSION_APPLICATION_ID, id);
			request.getSession().setAttribute(SESSION_APPLICATION_BEAN, item);
			request.setAttribute("list", items);
			
			conn.close();
			
			
			
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
			return ERROR;
		}
		
		return OK;
	}

}
