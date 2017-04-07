package jfr.webapp.placeholdermanager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jfabrix101.ewaf.util.DatabaseManager;
import jfabrix101.ewaf.util.StringHelper;
import jfr.webapp.placeholdermanager.bean.ApplicationBean;

public class AddPlaceholderAction extends MyAction {

	@Override
	public String executeRequest(Map<String, String> config,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		String placeholderKey = getParameter(request, "placeholderKey");
		String placeholderValue  = getParameter(request, "placeholderValue");
		
		ApplicationBean appBean = (ApplicationBean) request.getSession().getAttribute("appBean");
		if (appBean == null) {
			addErrorMessage(request, "Application not found in session");
			return OK;
		}
		
		request.setAttribute("id", "" + appBean.id);  // Lo aggiunge come stringa
		Connection conn = null;
		try {
			conn = DatabaseManager.getConnection(JNDI_NAME);
			String sql = "INSERT INTO Placeholder "
					+ "(id, appId, placeholderName, placeholderValue, placeholderEnabled)"
					+ " VALUES (?, ?, ?, ?, ?)";
			PreparedStatement pstm = conn.prepareStatement(sql);
			
			int ENABLED = 1;
			long id = System.currentTimeMillis();
			pstm.setLong(1, id);
			pstm.setLong(2, appBean.id);
			pstm.setString(3, placeholderKey);
			pstm.setString(4, placeholderValue);
			pstm.setInt(5, ENABLED);
			pstm.executeUpdate();
			
			pstm.close();
			conn.close();
			addInfoMessage(request, "Succesfully added placeholder " + placeholderKey + " = " + placeholderValue);
			
		} catch (Exception e) {
			addErrorMessage(request, "Exception: " + StringHelper.dumpException(e));
			if (conn != null) conn.close();
		}
		
		return OK;
	}

}
