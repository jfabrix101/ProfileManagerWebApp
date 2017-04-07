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

<h1> Applications 
	<span class="pull-right">
	
	
		<ewaf:ifUserHasPermission permissionName="addApplication">
		<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#myModalAddApplication"> New Application</a>
		</ewaf:ifUserHasPermission>
		<ewaf:ifUserHasPermission permissionName="importApplicationXml">
		<a href="#" class="btn btn-success" data-toggle="modal" data-target="#myModalImportApplcation"> Import XML </a>
		</ewaf:ifUserHasPermission>
	</span>
</h1>

<table class="table">

	<tr>
		<td> <b>Application Name</b> </td>
		<td> <b>Application Description</b> </td>
		<td align="right"> <b>Token</b> </td>
		<ewaf:ifUserHasPermission permissionName="exportApplicationXml">
		<td align="right"> <b>Quick Actions</b> </td>
		</ewaf:ifUserHasPermission>
	</tr>
<ewaf:loop className="jfr.webapp.placeholdermanager.bean.ApplicationBean" scope="request" id="list">
	<tr>
		<td>  <%= loopObj.appName %> </td>
		<td> <%= loopObj.appDescription %></td>
		<td align="right"> <%= loopObj.appToken %></td>
		<td align="right"> 
			<ewaf:ifUserHasPermission permissionName="exportApplicationXml">
			<a href="<%= path %>/ewaf/editApplication?id=<%=loopObj.id %>">
				<a href="<%= path %>/ewaf/exportXmlApplication?appId=<%= loopObj.id %>" download target="_blank" class="btn btn-info" > Export XML </a>
			</a>
			</ewaf:ifUserHasPermission>
			<ewaf:ifUserHasPermission permissionName="removeApplication">
				<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModalDelete"> Delete </button>
			</ewaf:ifUserHasPermission>
			
		</td>
	</tr>
</ewaf:loop>
</table>

<!-- Modal : Maschera di inserimento di una nuova applicazione -->
<ewaf:ifUserHasPermission permissionName="addApplication">
<div class="modal fade" id="myModalAddApplication" tabindex="-1" role="dialog" aria-labelledby="myModal">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/addApplication" method="post">
  	<div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModal">Add Application</h4>
      </div>
      <div class="modal-body">
        		
		 	<p>Add application information (name and descriptin)
			<br> The application token will generated automatically.
			<fieldset>
			<!-- Text input-->
			<div class="form-group">
			  <label class="col-md-4 control-label" for="appName">Name</label>  
			  <div class="col-md-8">
			  <input id="appName" name="appName" type="text" placeholder="" class="form-control input-md" required="">
			  </div>
			</div>
			
			<!-- Text input-->
			<div class="form-group">
			  <label class="col-md-4 control-label" for="appDescription">Description</label>  
			  <div class="col-md-8">
			  <input id="appDescription" name="appDescription" type="text" placeholder="" class="form-control input-md" required="">
			  </div>
			</div>
       		</fieldset>
        		
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add Application</button>
      </div>
    </div>
    </form>
  </div>
</div>
</ewaf:ifUserHasPermission>

<!-- Modal : Maschera per l'import di un file XML -->
<ewaf:ifUserHasPermission permissionName="importApplicationXml">
<div class="modal fade" id="myModalImportApplcation" tabindex="-1" role="dialog" aria-labelledby="myModal2">
  <div class="modal-dialog" role="document">
  	<form class="form-horizontal" enctype="multipart/form-data" action="<%= path %>/ewaf/snoop" method="post">
  	<div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModal2">Import Application</h4>
      </div>
      <div class="modal-body">
        		
		 	<p>Select an xml file to import as application
			<fieldset>
			
			<!-- File Button --> 
			<div class="control-group">
			  <label class="control-label" for="filebutton-0">File Button</label>
			  <div class="controls">
			    <input id="filebutton-0" name="filebutton-0" class="input-file" type="file">
			  </div>
			</div>
       		</fieldset>
        		
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add Application</button>
      </div>
    </div>
    </form>
  </div>
</div>
</ewaf:ifUserHasPermission>




<!-- Modal : Maschera di warning per la cencellazione dell'intera applicazione -->
<div class="modal fade" id="myModalDelete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/snoop" method="post"  >
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Remove Application</h4>
      </div>
      <div class="modal-body">
        		<h2><span  style="color: #d9534f;">Attention</span></h2>
        		
        		<p> Do you really want to remove this application ?
        		<br> Removing this application all placeholder, profile, permission and users relate to it will 
        		be removed also. <b>This operation can't be undone</b>.
        		<p> To procede, type the application name  in the field below.
        		
        		<div class="text-center">
        		<input id="placeholderName" name="appNameToRemove" type="text" placeholder="" class="form-control input-md" required="" />
        		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-danger">Remove Application</button>
      </div>
    </div>
    </form>
  </div>
</div>


</screen2:useTemplate>