<%@page import="jfr.webapp.placeholdermanager.bean.ApplicationBean"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="jfabrix101.ewaf.EwafConfigSingleton"%>
<%@page import="jfabrix101.ewaf.servlet.model.EwafConfigModel"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfile"%>
<%@page import="jfabrix101.ewaf.util.EwafHelper"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfileAdapter"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="ewaf" uri="/WEB-INF/ewaf/tlds/ewaf.tld"%>
<%@ taglib prefix="screen2" uri="/WEB-INF/ewaf/tlds/screen2.tld"%>
<%@ taglib prefix="screen" uri="/WEB-INF/ewaf/tlds/screen.tld"%>
<%
	String path = request.getContextPath();
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
	String userName = null;
	if (up != null) up.getUserName();
	
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="HomePage" />


<h1> Applications <br><small>Select an application to manage it's user profiles</small> 
</h1>

<table class="table">

	<tr>
		<td> <b>Application Name</b> </td>
		<td> <b>Application Description</b> </td>
		<td align="right"> <b>Creation time</b> </td>
	</tr>
<ewaf:loop className="jfr.webapp.placeholdermanager.bean.ApplicationBean" scope="request" id="list">
	<tr>
		<td> <a href="<%= path %>/ewaf/listUserProfileForApplication?appId=<%=loopObj.id %>"> <%= loopObj.appName %> </a></td>
		<td> <%= loopObj.appDescription %></td>
		<td align="right"> <%= loopObj.getTmsInsertAsDate() %></td>
	</tr>
</ewaf:loop>
</table>

</screen2:useTemplate>