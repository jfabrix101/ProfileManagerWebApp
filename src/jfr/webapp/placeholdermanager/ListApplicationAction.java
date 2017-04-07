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

/**
 * Restituisce la lista delle applicazioni censite
 * 
 * @author frusso
 *
 */
public class ListApplicationAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "SELECT id, appName,appDescription, tmsInsert, tmsUpdate, appToken "
					+ "FROM Application ORDER BY  tmsInsert desc;";
			PreparedStatement pstm = conn.prepareStatement(sql);
			ResultSet rs = pstm.executeQuery();
			List<ApplicationBean> list = new ArrayList<ApplicationBean>();
			while (rs.next()) {
				ApplicationBean item = new ApplicationBean();
				item.id = rs.getLong(1);
				item.appName = rs.getString(2);
				item.appDescription = rs.getString(3);
				item.tmsInsert = rs.getTimestamp(4).getTime();
				item.tmsUpdate = rs.getTimestamp(5).getTime();
				item.appToken = rs.getString(6);
				list.add(item);
			}
			rs.close();
			pstm.close();
			
			conn.close();
			request.setAttribute("list", list);
			logger.debug("Found " + list.size() + " applications");
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
