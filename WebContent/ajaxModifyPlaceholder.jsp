<%@page import="jfabrix101.ewaf.util.JspHelper"%>
<fieldset>
	<input type="hidden" name="pid" value="<%= request.getParameter("pid") %>" />
	<!-- Text input-->
	<div class="form-group">
	  <label class="col-md-2 control-label" for="placeholderName">Name</label>  
	  <div class="col-md-10">
	  <input id="placeholderName" name="placeholderName" type="text" placeholder="" class="form-control input-md" 
	  			required="" value="<%= JspHelper.getParameter(request, "placeholderName") %>">
	  </div>
	</div>
	
	<!-- Text input-->
	<br><p> <div class="form-group">
	  <label class="col-md-2 control-label" for="placeholderValue">Value</label>  
	  <div class="col-md-10">
	  <input id="placeholderValue" name="placeholderValue" type="text" placeholder="" class="form-control input-md" 
	  		required="" value="<%= JspHelper.getParameter(request, "placeholderValue") %>">
	  </div>
	</div>

</fieldset>