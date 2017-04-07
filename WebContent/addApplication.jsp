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

<p><h1> Aggiungi Applicazione </h1>


<form class="form-horizontal" action="<%= path %>/ewaf/addApplication">
	<fieldset>
	
	<!-- Form Name -->
	<legend>Inserire i dati per la nuova applicazione da censire</legend>
	
	<!-- Text input-->
	<div class="form-group">
	  <label class="col-md-4 control-label" for="appName">Nome</label>  
	  <div class="col-md-4">
	  <input id="appName" name="appName" type="text" placeholder="" class="form-control input-md" required="">
	    
	  </div>
	</div>
	
	<!-- Text input-->
	<div class="form-group">
	  <label class="col-md-4 control-label" for="appDescription">Descrizione</label>  
	  <div class="col-md-4">
	  <input id="appDescription" name="appDescription" type="text" placeholder="" class="form-control input-md" required="">
	    
	  </div>
	</div>
	
	<!-- Button -->
	<div class="form-group">
	  <label class="col-md-4 control-label" for="singlebutton"></label>
	  <div class="col-md-4">
	    <button id="singlebutton" name="singlebutton" class="btn btn-primary">OK</button>
	  </div>
	</div>
	
	</fieldset>
</form>



</screen2:useTemplate>