package jfr.webapp.placeholdermanager.profiles;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.Const;
import jfr.webapp.placeholdermanager.MyAction;
import jfr.webapp.placeholdermanager.bean.ApplicationBean;

/**
 * Restituisce la lista delle applicazioni censite
 * 
 * @author frusso
 *
 */
public class AddPermissionForApplicationAction extends MyAction {

	
	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		Connection conn = null;
		
		String permName = request.getParameter("permName");
		String permDesc = request.getParameter("permDesc");
		
		
		ApplicationBean item = null;
		item = (ApplicationBean) request.getSession().getAttribute(Const.SESSION_APPLICATION_BEAN);
		
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "INSERT INTO Permission (id, appId, permissionName, permissionDesc) VALUES (?, ?, ?, ?)";
			PreparedStatement pstm = conn.prepareStatement(sql);
			pstm.setLong(1, System.currentTimeMillis());
			pstm.setLong(2, item.id);
			pstm.setString(3, permName);
			pstm.setString(4, permDesc);
			
			pstm.executeUpdate();
			pstm.close();
			
			conn.close();
			addInfoMessage(request, "Added permission " + permName);
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}
	
	
}
