<%@page import="jfabrix101.ewaf.util.Helper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="ewaf" 	uri="/WEB-INF/ewaf/tlds/ewaf.tld" %>
<%@ taglib prefix="screen2" uri="/WEB-INF/ewaf/tlds/screen2.tld" %>
<%
	String path = request.getContextPath();
	Exception e = (Exception) request.getAttribute("exception");
	String stackTrace = "";
	if (e != null) stackTrace = Helper.dumpStackTrace(e);
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="Home Page" />
<screen2:redefineAlias name="menuLeft" value="" />

  	<div class="row">
	 	<h2 class="text-error text-center">Something is gone wrong</h2>
	   	<p class="text-error  text-center"><%= e.getMessage() %></p>
	</div>
   	
    <div class="row container">
   	<p align="left"> <pre> <%= stackTrace %> </pre>
	</div>   	
     

</screen2:useTemplate>