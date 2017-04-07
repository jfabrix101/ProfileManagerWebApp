<%@page import="jfr.webapp.placeholdermanager.bean.UserProfileBean"%>
<%@page import="jfr.webapp.placeholdermanager.bean.PermissionBean"%>
<%@page import="jfr.webapp.placeholdermanager.bean.RoleBean"%>
<%@page import="jfr.webapp.placeholdermanager.Const"%>
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
	ApplicationBean appbean = (ApplicationBean) session.getAttribute(Const.SESSION_APPLICATION_BEAN);
	
	List<RoleBean> roles = (List<RoleBean>) session.getAttribute(Const.SESSION_ROLE_LIST);
	List<UserProfileBean> upList = (List<UserProfileBean>) session.getAttribute("upList");
	
	
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="HomePage" />

<h1> UserProfiles for <%= appbean.appName %>
	<div class="pull-right">
		<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#myModalMapNewUser"> Map New UserProfile </a>
	</div>
</h1>

<ewaf:pbpContainer name="upList" pageSize="10" />

<form>
<table class="table">
	<tr>
		
		<td> UserName: <input name="filterUserName" type="text" placeholder="userName"/> </td>
		<td> Role: <input name="filterRoleName" type="text" placeholder="roleName"/>  </td>
		<td> FullName: <input name="filterFullName" type="text" placeholder="full name"/> </td>
		<td> Email: <input name="filterEmail" type="text" placeholder="email"/> </td>
		<td> <button type="submit" ><span class="glyphicon glyphicon-search" aria-hidden="true"></span> &nbsp; Filter</button>   
	</tr>
</table>
<hr>
</form>

<table class="table table-striped">
	

	<tr>
		<td> &nbsp; </td>
		<td> <b>User Name</b> </td>
		<td> <b>Role Name</b> </td>
		<td> <b>Full Name</b> </td>
		<td> <b>Email</b> </td>
		<td> &nbsp; </td>
	</tr>
	
	<ewaf:loop className="jfr.webapp.placeholdermanager.bean.UserProfileBean" scope="request" id="upList_pbpPage">
	<tr>
		<td> <%= loopObj.appId %>_<%= loopObj.userName %></td>
		<td> <%= loopObj.userName %> </td>
		<td> <%= loopObj.roleName %> </td>
		<td> <%= loopObj.fullName %></td>
		<td> <%= loopObj.email %></td>
		<td> [Delete] [Edit] [Disable] [+] </td>
	</tr>
	</ewaf:loop>	
</table>

<div class="text-center">
	<ewaf:pbpNavigator name="upList" 
     	navigationViewRenderer="jfabrix101.ewaf.util.PageByPageClassicNavigationRenderer">
     		<ewaf:param name="leftBracket" value="["/>
     		<ewaf:param name="rightBracket" value="]"/>
     		<ewaf:param name="text" value="%d / %d"/>
     		<ewaf:param name="textStyle" value="color: #FF0000; "/>
     		
     	</ewaf:pbpNavigator>
</div>


<!-- Modal: Maschera di input per un nuovo permission -->
<div class="modal fade" id="myModalMapNewUser" tabindex="-1" role="dialog" aria-labelledby="myModal1">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/addUserProfileForApplication" method="post"  >
  	<input type="hidden" name="appId" value="<%= appbean.id %>" />
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModal1">Map New User</h4>
      </div>
      <div class="modal-body">
        		<fieldset>

			<!-- Text input-->
			<div class="form-group">
			  <label class="col-md-4 control-label" for="userName">UserName</label>  
			  <div class="col-md-8">
			  <input id="userName" name="userName" type="text" placeholder="userName / userId" class="form-control input-md" required="">
			    
			  </div>
			</div>
			
			<!-- Text input-->
			<br><p><div class="form-group">
			  <label class="col-md-4 control-label" for="fullName">Full Name</label>  
			  <div class="col-md-8">
			  <input id="fullName" name="fullName" type="text" placeholder="user full name" class="form-control input-md" required="">
			    
			  </div>
			</div>
			
			<!-- Text input-->
			<br><p><div class="form-group">
			  <label class="col-md-4 control-label" for="email">Email</label>  
			  <div class="col-md-8">
			  <input id="email" name="email" type="text" placeholder="email" class="form-control input-md">
			    
			  </div>
			</div>
			
			<!-- Select Basic -->
			<br><p><div class="form-group">
			  <label class="col-md-4 control-label" for="selectbasic">Application Role</label>
			  <div class="col-md-8">
			    <select id="selectbasic" name="roleId" class="form-control">
			      <% for (RoleBean s : roles) { %>
			      <option value="<%= s.id %>"><%= s.roleName %></option>
			      <% } %>
			    </select>
			  </div>
			</div>
			
			</fieldset>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add User</button>
      </div>
    </div>
    </form>
  </div>
</div>



</screen2:useTemplate>