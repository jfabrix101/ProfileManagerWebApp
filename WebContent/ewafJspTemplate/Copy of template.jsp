<%@page import="jfabrix101.ewaf.util.EwafHelper"%>
<%@page import="jfabrix101.ewaf.security.EwafUserProfile"%>
<%@page import="jfabrix101.ewaf.EwafConst"%>
<%@ taglib prefix="ewaf" 	uri="/WEB-INF/ewaf/tlds/ewaf.tld" %>
<%@ taglib prefix="screen2" uri="/WEB-INF/ewaf/tlds/screen2.tld" %>
<%@ taglib prefix="screen" uri="/WEB-INF/ewaf/tlds/screen.tld" %>
<%
	String contextPath = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + contextPath;
	
	String helpFile =  (String)request.getAttribute(EwafConst.SCREEN_requestAttributePrefix + "helpFile");
	String menuLeftFile =(String) request.getAttribute(EwafConst.SCREEN_requestAttributePrefix + "menuLeft");
	String menuRightFile =(String) request.getAttribute(EwafConst.SCREEN_requestAttributePrefix + "menuRight");
	
	String pageTitle = (String) request.getAttribute(EwafConst.SCREEN_requestAttributePrefix + "bodyTitle");
	if (pageTitle == null || pageTitle.length() == 0) pageTitle = "";
	
	// Recupera le credenziali dell'utente
	EwafUserProfile up = (EwafUserProfile) EwafHelper.getUserProfile(session);
	String googleAnalytics = "";
%>
<!DOCTYPE html>
  <html lang="en">
    <head>
    	<meta charset="utf-8">
      	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1"><!--Import materialize.css-->
    	<title>  <%= pageTitle %> </title>
      	
      	<link href="<%= contextPath %>/css/bootstrap.min.css" rel="stylesheet">
		<link href="<%= contextPath %>/style/custom-navbar.css" rel="stylesheet">
		<link href="<%= contextPath %>/style/custom.css" rel="stylesheet">
		
	    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	    <!--[if lt IE 9]>
	      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	    <![endif]-->
	    <base href="<%= basePath %>">
		
	
		<ewaf:nocache />
		<meta http-equiv="keywords" content="<screen:label name="keywords" />">
		<meta http-equiv="copyright" content="<ewaf:applicationCopyright />">
		<meta http-equiv="appName" content="<ewaf:applicationName/>">
		
		<link href='<%= contextPath %>/css/custom.css' rel='stylesheet' type='text/css'>
    	
    	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    	
    	<link href='http://fonts.googleapis.com/css?family=Swanky+and+Moo+Moo' rel='stylesheet' type='text/css'>
    	
    	<ewaf:nocache />
    </head>

    <body>
     
   	 
   
     
	 <ewaf:IfUserProfilePresent>
	 	<jsp:include page="/ewafJspTemplate/navbar.jsp" />
     </ewaf:IfUserProfilePresent>
     <jsp:include page="/ewafJspTemplate/header.jsp" />  	
      <!--  page header -->
      
      
      
      <!-- page body -->
      <div class="container">
      	
      	
      	
      	<ewaf:hasMessages name="ERROR">
      		<div class="alert alert-danger alert-dismissible" role="alert">
  				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  				<strong>Error!</strong> <ewaf:showMessage name="ERROR"/> 
			</div>
      	</ewaf:hasMessages>
      
      	<ewaf:hasMessages name="OK">
      		<div class="alert alert-success alert-dismissible" role="alert">
  				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  				<strong>Info!</strong> <ewaf:showMessage name="OK"/> 
			</div>
      	</ewaf:hasMessages>
      
      
		 <div class="row-fluid container">     
	      	<% if (menuLeftFile == null || menuLeftFile.length() == 0) { %>
	      		<screen:include src="body"/>
	      	<% } else { %>
	      		<div id="menuContainer" class="col-md-2"> <jsp:include page="<%= menuLeftFile %>" /></div>
	      		<div id="bodyContainer" class="col-md-10"> <screen:include src="body"/> </div>
	      	<% } %>
       	 </div>
      </div>
      
      <!--  page footer -->
      <div class="footer">
      	<jsp:include page="/ewafJspTemplate/footer.jsp" />
      </div>
      <!--  end page -->
     
    
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="<%= contextPath %>/js/bootstrap.min.js"></script> 
    </body>
  </html>