package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;

public class UpdateFlagPlaceholderAction extends MyAction {

	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String id = getParameter(request, "placeholderId");
		String status = getParameter(request, "status");
		
		int flag = 0;
		if ("ON".equals(status)) flag = 1;
		
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "UPDATE Placeholder set placeholderEnabled = ? WHERE id = ? ";
			PreparedStatement pstm = conn.prepareStatement(sql);
			pstm.setInt(1, flag);
			pstm.setString(2, id);
			
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
