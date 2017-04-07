<%@page import="jfabrix101.ewaf.EwafConst"%>
<%@page import="jfabrix101.ewaf.EwafConfigSingleton"%>
<%@page import="jfabrix101.ewaf.util.XProperties"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfile"%>
<%@page import="jfabrix101.ewaf.util.EwafHelper"%>
<%@ taglib prefix="ewaf" uri="/WEB-INF/ewaf/tlds/ewaf.tld"%>
<%@ taglib prefix="screen" uri="/WEB-INF/ewaf/tlds/screen.tld"%>
<%
	// Recupera le credenziali dell'utente
	String path = request.getContextPath();
	String userName = null; // "Fabrizio Russo";
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
	if (up != null) userName = up.getUserName();
	
	String pageTitle = (String) request.getAttribute(EwafConst.SCREEN_requestAttributePrefix + "bodyTitle");
	if (pageTitle == null) pageTitle = "";
	
	String brandName = EwafConfigSingleton.getInstance().getApplicationProperty("applicationTitle");
%>
<table class="table" >
	<tr>
 		<td width="150px">  <a href="<%=path %>/"><img src="<%= path %>/images/profileManager.png" width="100%"/> </a></td>
 		<td valign="middle"> 
 			<h1><ewaf:applicationProperty name="applicationTitle"/> 
 			 <small> / <ewaf:applicationProperty name="applicationSubTitle"/></small>
 			</h1>
 			
			<ewaf:IfUserProfilePresent>
 				<jsp:include page="/ewafJspTemplate/navbar.jsp" />
   			</ewaf:IfUserProfilePresent> 
	</td> </tr>
</table>