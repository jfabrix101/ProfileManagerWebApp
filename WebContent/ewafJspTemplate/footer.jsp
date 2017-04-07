<%@page import="jfabrix101.ewaf.util.EwafHelper"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfile"%>
<%@ taglib prefix="ewaf" uri="/WEB-INF/ewaf/tlds/ewaf.tld"%><%
	String path = request.getContextPath();
	String userName = ""; // "Fabrizio Russo";
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
	if (up != null) userName = up.getUserName();
%>
<style>
	.footer {
		bottom: 8px;
		position: fixed;
		width: 100%
	}
</style>
<div id="footer">
  <div class="container text-center">
  	<hr width="90%">
  	<ewaf:IfUserProfilePresent>
  	<b><%= userName %></b> /
  	</ewaf:IfUserProfilePresent>
	<ewaf:applicationName/> - <ewaf:applicationDescription/>
		  	
  </div>
  
</div>