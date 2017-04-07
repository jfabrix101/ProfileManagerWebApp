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
	ApplicationBean appBean = (ApplicationBean) session.getAttribute("appBean");
	
	// maschera di editing dei placeholder dell'applicazione
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="HomePage" />

<p><h1> <b><%= appBean.appName %></b> placeholders
	<span class="pull-right">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal"> Add placeholder </button>
	</span>
	<br><small><%= appBean.appDescription %></small>
</h1>




<!-- Modal: Maschera di input per un nuovo placeholder -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/addPlaceholder" method="post"  >
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Add Placeholder</h4>
      </div>
      <div class="modal-body">
        		<fieldset>
				
				<!-- Text input-->
				<div class="form-group">
				  <label class="col-md-2 control-label" for="placeholderName">Name</label>  
				  <div class="col-md-10">
				  <input id="placeholderName" name="placeholderKey" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				<!-- Text input-->
				<br><p> <div class="form-group">
				  <label class="col-md-2 control-label" for="placeholderValue">Value</label>  
				  <div class="col-md-10">
				  <input id="placeholderValue" name="placeholderValue" type="text" placeholder="" class="form-control input-md" required="" size="50">
				  </div>
				</div>
				
				</fieldset>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Add</button>
      </div>
    </div>
    </form>
  </div>
</div>



<%-- Tabella con i placeholder dell'applicazione --%>
<p>&nbsp;
<p><table class="table table-striped">
	<tr>
		<td> <b>Name</b>  </td>
		<td> <b>Value</b> </td>
		<td> <b>Enabled</b> </td>
		<td align="right"> <b>Creation Time</b></td>
		<td align="right"> <b>Last Update</b></td>
		<td align="right"> <b>Actions</b></td>
	</tr>
	
<ewaf:loop className="jfr.webapp.placeholdermanager.bean.PlaceholderBean" scope="request" id="list">
	<tr>
		<td> <%= loopObj.placeholderName %> </td>
		<td> <%= loopObj.placeholderValue %></td>
		<td> <%= (loopObj.placeholderEnabled  ? 
			"<span class=\"glyphicon glyphicon-ok\" aria-hidden=\"true\"></span>"
 			: "<span class=\"glyphicon glyphicon-minus\" aria-hidden=\"true\"></span>" )%></td>
		<td align="right"> <%= loopObj.getTmsInsertAsDate() %></td>
		<td align="right"> <%= loopObj.getTmsUpdateAsDate() %></td>
		<td align="right">
		
			<div class="dropdown"> <%-- Menu dropDown delle ACTION per placeholder con ajax per la modifica --%>
			  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Actions<span class="caret"></span></button>
			  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">  
			  	<%
			  		String link = path + "/ajaxModifyPlaceholder.jsp?pid=" + loopObj.id + "&placeholderName=" + loopObj.placeholderName + "&placeholderValue=" + loopObj.placeholderValue;
			  		String sourceId = "ajaxModifyPlaceholderButton_" + loopObj.id;
			  		String targetId = "ajaxModifyPlaceholder";
			  		System.out.println(link);
			  	%>

			    <li><a id="<%= sourceId %>" href="#" data-toggle="modal" data-target="#myModalModify">Modify</a></li>
			    <li><a href="<%= path %>/ewaf/updateFlagPlaceholder?placeholderId=<%= loopObj.id %>&status=<%= ( loopObj.placeholderEnabled ? "OFF" : "ON") %>">Change status</a></li>
			    <li role="separator" class="divider"></li>
			    <li><a href="<%= path %>/ewaf/removePlaceholder?placeholderId=<%= loopObj.id %>"><span class="danger">Remove</span></a></li>
			  </ul>
			  <script> $("#<%= sourceId %>").click(function() { 
				  	$("#ajaxModifyPlaceholder").load("<%= link %>"); 
				  	return true;
				  }); 
			  </script>
			</div>
			
					 
		</td>
	</tr>
</ewaf:loop>
</table>


<div class="modal fade" id="myModalModify" tabindex="-1" role="dialog" aria-labelledby="myModalModify">
  <div class="modal-dialog" role="document">
  	<form action="<%= path %>/ewaf/updatePlaceholder" method="post"  >
  	<input type="hidden" name="appId" value="<%= appBean.id %>" />
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modify Placeholder</h4>
      </div>
      <div class="modal-body">
        		<div id="ajaxModifyPlaceholder"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Modify Placeholder</button>
      </div>
    </div>
    </form>
  </div>
</div>

</screen2:useTemplate>