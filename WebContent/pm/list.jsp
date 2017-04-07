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
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
	String userName = null;
	if (up != null) up.getUserName();
	ApplicationBean appbean = (ApplicationBean) session.getAttribute(Const.SESSION_APPLICATION_BEAN);
	List<RoleBean> roleList = (List<RoleBean>) session.getAttribute(Const.SESSION_ROLE_LIST);
	List<PermissionBean> permissList = (List<PermissionBean>) session.getAttribute(Const.SESSION_PERMISSION_LIST);
	
	Set<Long> permissionEnabled = (Set<Long>) session.getAttribute("set");
	if (permissionEnabled == null) permissionEnabled = new HashSet();
	long  selectedRole = -1;
	try {
		selectedRole = Long.parseLong(request.getParameter("selectedRole"));
	} catch (Exception e) {}
	if (selectedRole < 0 && roleList.size() > 0) selectedRole = roleList.get(0).id; 
	
	
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="HomePage" />

<h1> ApplicationProfiles for <%= appbean.appName %>
	<div class="pull-right">
		<ewaf:ifUserHasPermission permissionName="addApplicationProfile">
		<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#myModalRole"> Add Role </a>
		<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#myModalPermission"> Add Permission </a>
		</ewaf:ifUserHasPermission>		
	</div>
</h1>

<style>
.scroll {
    width: 100%;
    height: 300px;
    overflow: scroll;
    overflow-x: hidden;
}
</style>



<div class="row">
	<div class="col-md-3"> 
		<h1>Roles</h1>
		<ul class="nav nav-pills nav-stacked">
		  <ewaf:loop className="jfr.webapp.placeholdermanager.bean.RoleBean" scope="session" id="<%= Const.SESSION_ROLE_LIST %>">
		  	<li role="presentation"	class="<%= (loopObj.id == selectedRole ? "active" : "") %>"> 
		  			<a href="<%= path %>/ewaf/listApplicationProfiles?selectedRole=<%=loopObj.id %>&appId=<%= appbean.id %>"><%= loopObj.roleName %> </a></li>
		  </ewaf:loop>
		</ul>
	</div>
	<div class="col-md-9">
		<h1>Permissions
		<div class="pull-right">
			<a href="#" class="btn btn-default"> <span class="glyphicon glyphicon-check" aria-hidden="true"></span> Only Selected</a>
		</div>
		</h1>
		<form action="<%= path %>/ewaf/updateApplicationProfile" method="POST">
		<input type="hidden" name="appId" value="<%= appbean.id %>" />
		<input type="hidden" name="selectedRole" value="<%= selectedRole %>" />
		<div class="scroll">
			<ul class="list-group">
			<ewaf:loop className="jfr.webapp.placeholdermanager.bean.PermissionBean" scope="session" id="<%= Const.SESSION_PERMISSION_LIST %>">
				<li class="list-group-item">
					<input type="checkbox" name="value_<%= loopObj.id %>" <%= ( permissionEnabled.contains(loopObj.id) ? "checked" : "") %>/> 
					&nbsp; <%= loopObj.permissionName %>
					&nbsp; - <%= loopObj.permissionDesc %>  
				</li>
			</ewaf:loop>
			</ul>
		</div>
		<p>&nbsp;
		<p><div class="pull-right">
		<input type="submit" class="btn btn-primary" value="Update" />
		</form>
		</div>
	</div>

</div>


<!-- -------------------------------------------------------------------  DIALOG  -->

<!-- Modal: Maschera di input per un nuovo permission -->
<div class="modal fade" id="myModalPermission" tabindex="-1" role="dialog" aria-labelledby="myModalPermission">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/addPermissionForApplication" method="post"  >
  	<input type="hidden" name="selectedRole" value="<%= selectedRole %>" />
  	<input type="hidden" name="appId" value="<%= appbean.id %>" />
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalPermission">New Permission</h4>
      </div>
      <div class="modal-body">
        		<fieldset>
				
				<!-- Text input-->
				<div class="form-group">
				  <label class="col-md-4 control-label" for="placeholderName">Permission Name</label>  
				  <div class="col-md-8">
				  <input id="placeholderName" name="permName" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				<br><p><div class="form-group">
				  <label class="col-md-4 control-label" for="placeholderDesc">Description</label>  
				  <div class="col-md-8">
				  <input id="placeholderDesc" name="permDesc" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				</fieldset>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add Permission</button>
      </div>
    </div>
    </form>
  </div>
</div>


<!-- Modal: Maschera di input per un nuovo permission -->
<div class="modal fade" id="myModalRole" tabindex="-1" role="dialog" aria-labelledby="myModalRole">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/addRoleForApplication" method="post"  >
  	<input type="hidden" name="selectedRole" value="<%= selectedRole %>" />
  	<input type="hidden" name="appId" value="<%= appbean.id %>" />
  	
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">New Role</h4>
      </div>
      <div class="modal-body">
        		<fieldset>
				
				<!-- Text input-->
				<div class="form-group">
				  <label class="col-md-4 control-label" for="roleName">Role Name</label>  
				  <div class="col-md-8">
				  <input id="roleName" name="roleName" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				<br><p><div class="form-group">
				  <label class="col-md-4 control-label" for="roleDesc">Description</label>  
				  <div class="col-md-8">
				  <input id="roleDesc" name="roleDesc" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				</fieldset>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add Role</button>
      </div>
    </div>
    </form>
  </div>
</div>
</screen2:useTemplate>