package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;

public class RemovePlaceholderAction extends MyAction {

	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String id = getParameter(request, "placeholderId");
		
		
		
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "DELETE FROM Placeholder WHERE id = ? ";
			PreparedStatement pstm = conn.prepareStatement(sql);
			pstm.setString(1, id);
			pstm.executeUpdate();
			
			pstm.close();
			conn.close();
			
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}

}
