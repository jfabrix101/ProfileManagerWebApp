<%@page import="jfabrix101.ewaf.util.EwafHelper"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfile"%>
<%@page import="jfabrix101.ewaf.EwafConfigSingleton"%>
<%@ taglib prefix="ewaf" uri="/WEB-INF/ewaf/tlds/ewaf.tld"%>
<%
	String path = request.getContextPath();
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
%>



<nav class="navbar navbar-default">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <!-- 
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="<%= path %>/"></a>
    </div>
 	-->
 	
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="<%= path %>/ewaf/listApps">Application <span class="sr-only">(current)</span></a></li>
        <li><a href="<%= path %>/ewaf/listAppsForPlaceholders">Placeholder <span class="sr-only">(current)</span></a></li>
        <li><a href="<%= path %>/ewaf/listAppsForProfiles">Profiles</a></li>
        <li><a href="<%= path %>/ewaf/listAppsForUsers">Users</a></li>
        
        <!--  
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Separated link</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">One more separated link</a></li>
          </ul>
        </li>
        -->
        
      </ul>
      
      
      <!--   
      <form class="navbar-form navbar-left">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      -->
      
      
      <ul class="nav navbar-nav navbar-right">
        
        
        <li><a href="<%= path %>/ewaf/logout">Logout</a></li>
        
        <ewaf:ifUserHasPermission permissionName="developer">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">DevMode <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="<%= path %>/ewaf/snoop">Snoop</a></li>
            <li><a href="<%= path %>/ewaf/ewafReloadXML">ReloadXML</a></li>
            <li role="separator" class="divider"></li>
            <li><a href="#">Something else here</a></li>
            <li><a href="#">Separated link</a></li>
          </ul>
        </li>
        
        </ewaf:ifUserHasPermission>
      </ul>
       
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
