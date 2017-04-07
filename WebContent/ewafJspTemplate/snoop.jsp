<%@page import="jfabrix101.ewaf.EwafConst"%>
<%@page import="jfabrix101.ewaf.servlet.EwafActionStepBean"%>
<html>
<%
	String copyright = "Ewaf - Enterprise Web Application Framework";
	
	String path = request.getContextPath();
	
	boolean isSerializable = true;
	
	long sizeOfSession = 0;
	long sizeOfApplication = 0;
	
	if (request.getParameter("removeSessionKey") != null) {
		session.removeAttribute(request.getParameter("removeSessionKey"));
	}
	
	if (request.getParameter("removeApplicationKey") != null) {
		application.removeAttribute(request.getParameter("removeApplicationKey"));
	}
	
	if (request.getParameter("operation") != null) {
		if ("session".equals(request.getParameter("scope"))) {
			String key = request.getParameter("key");
			String val = request.getParameter("value");
			session.setAttribute(key, val);
		}
		if ("application".equals(request.getParameter("scope"))) {
			String key = request.getParameter("key");
			String val = request.getParameter("value");
			application.setAttribute(key, val);
		}
	}
%>

<%! 
	// Restituisce il nome di una classe
	public String getClassName(Class c) {
		String res = c.getName();
		if (res.startsWith("class")) res = res.substring(5);
		if (res.startsWith("java.lang.")) res = res.substring(10);
		return res;
	}
	
	// Restituisce la dimensione in bytes di un oggetto (se e' serializabile)
	public long getObjectSize(Object x) {
		long size = -1;
		
		if (x instanceof java.io.Serializable) {
			try {
				java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream();
				java.io.ObjectOutputStream oout = new java.io.ObjectOutputStream(bout);
				oout.writeObject(x);
				size = bout.toByteArray().length;
			} catch (Exception e) {	size = -1;	}
		}
		
		return size;
	}
%>

<head>
	<link rel="stylesheet" type="text/css" href="<%= path %>/ewafJsp/ewaf.css">
</head>

<body bgcolor="#FFFFFF">



<table width="100%" bgcolor="#FFFFFF">
	<TR>
		<TD align="center"> <img src='<%=path%>/ewafJsp/img/class.jpg'>  </TD>
		<TD align="left">
			<font size="+2"> <b> Snoop JSP </b> </font> <br> 
			<font size="+1">
			<a href="#request">Request</a> 
			| <a href="#session">Session </a> 
			| <a href="#application">Application </a> 
			| <a href="#system">System </a> 
			</font>
		</TD>
	</TR>
</table>


<h3>Request Parameters :</h3>

<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">
  <tr> 
    <th nowrap="nowrap" height="22"> <font class="block-title"> Key </font></th>
    <th nowrap="nowrap" height="22"> <font class="block-title"> Value </font></th>
  </tr>
  <%
      java.util.Enumeration enum1 = request.getParameterNames();
	  while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
	  		if (pName == null) return;
  %>
  <tr> 
    <td class="row1" ><%= pName %></td>
    <td class="row1" ><%= request.getParameter(pName) %></td>
  </tr>
  <%
     }
  %>
</table>

<p><a name="#request">&nbsp;</a></p>
<h3>Request Attributes :</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">
  <tr> 
    <th nowrap="nowrap"> <font class="block-title"><b>Key</b> </font></th>
    <th nowrap="nowrap"> <font class="block-title"><b>Type</b> </font></th>
    <th nowrap="nowrap"> <font class="block-title"><b>Value</b> </font></th>
  </tr>
  <%
      enum1 = request.getAttributeNames();
	  while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
	  		if (pName == null) return;
			Object obj = request.getAttribute(pName);
			if (obj == null) return;
  %>
  <tr> 
    <td class="row1" ><%= pName%></td>
    <td class="row1" ><%= obj.getClass().getName() %></td>
    <td class="row1" ><%= obj.toString() %></td>
  </tr>
  <%
     }
  %>
</table>


<p><a name="#session">&nbsp;</a></p>
<h3>Http Session :</h3>

<%
      if (session == null) out.println("Sessione utente non definita");
      if (session != null) {
%>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">
	<tr> <th nowrap="nowrap"> <font class="block-title"><b>Attribute</b></font></th>  <th nowrap="nowrap"> <font class="block-title"><b>Valore</b></font></th> <tr>  
	
	<tr> <td class="row1"> Session ID</td>  <td class="row1"><%= session.getId() %></td> <tr>  
	<tr> <td class="row1">Creation Time</td>  <td class="row1" ><%= session.getCreationTime() %> ( <%= new java.util.Date(session.getCreationTime()).toString() %>)</td> <tr>    			
	<tr> <td class="row1" >Last Accessed Time</td>  <td class="row1" ><%= new java.util.Date(session.getLastAccessedTime()) %></td> <tr> 
	<tr> <td class="row1" >Max Inactive Interval</td>  <td class="row1" ><%= new java.util.Date(session.getMaxInactiveInterval()) %></td> <tr> 
	<tr> <td class="row1" >Is New</td>  <td class="row1" ><%= session.isNew() %></td> <tr> 
</table>
<br>
<form action="" method="POST" >
	<p align="center" class="row1">
	Add New value :
	<input type="hidden" name="scope" value="session"> <input type="hidden" name="operation" value="addValue">
	Key: <input type="text" name="key" value="" size="20">
	Value: <input type="text" name="value" value="" size="20">
	<input type="submit" value="Add New Value"></p>
</form>

<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">
  <tr> 
    <th nowrap="nowrap"> <font class="block-title"><b>Key</b></font></th>
    <th nowrap="nowrap"> <font class="block-title"><b>Type</b></font></th>
    <th nowrap="nowrap"> <font class="block-title"><b>Value</b></font></th>
    <th nowrap="nowrap"> <font class="block-title"><b>&nbsp;</b></font></th>
  </tr>
  <%
      enum1 = session.getAttributeNames();
      isSerializable = true;
	  while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
	  		if (pName == null) return;
	  		Object obj = session.getAttribute(pName);
	  		if (obj == null) obj = new String ("NULL");
	  		String val = "";
	  		try {
		  		val = obj.toString();
		  	} catch (Exception e) { val = "NULL"; }
		  	long size = getObjectSize(obj);
		  	if (size > 0) sizeOfSession += size;
		  	String strSize = "" + size;
		  	if (size == -1) {
		  			strSize = "<font color='RED'><b> " + size + "</b></font>";
		  			isSerializable = false; 
		  	}
  %>
  <tr> 
    <td class="row1"> <a href="<%=path%>/ewafJsp/snoopDett.jsp?scope=session&name=<%= pName %>"><%= pName %></a></td>
    <td class="row1"><%= obj.getClass().getName() %> (<b><%= strSize %></b> bytes) </td>
    <td class="row1"><%= val %> </td>
    <td class="row1"> <a href="?removeSessionKey=<%=pName%>"><img src="<%= path %>/ewafJsp/img/remove.gif" border="0"/></a> </td>
  </tr>
  <%
     }
  %>
  <tr> <td colspan="5" class="row0"> Size of Session : <b> <%= sizeOfSession %></b></td></tr>
  <% if (!isSerializable) { %>
  <tr> <td colspan="5" class="row0" > <img src="<%= path %>/ewafJsp/img/taskError.gif"> <font color="RED"><strong> Warning : HttpSession is not serializable </strong></font></td></tr>
  <% } %>
</table>
<% } // End session != null %>


<p>&nbsp;</p>
<h3>Request Header :</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">
  <tr> 
    <th nowrap="nowrap"><font class="block-title" width="25%"><b>Key</b></font></th>
    <th nowrap="nowrap"><font class="block-title" width="75%"><b>Value</b></font></th>
  </tr>
  <%
      enum1 = request.getHeaderNames();
	  while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
	  		if (pName == null) return;
	  		String headerValue = request.getHeader(pName) ;
  %>
  <tr> 
    <td class="row1" width="25%"><%= pName %></td>
    <td class="row1" width="75%"><%= headerValue %></td>
  </tr>
  <%
     }
  %>
</table>
<h3>&nbsp;</h3>
<h3>Request general info :</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">

  <tr> 
    <th nowrap="nowrap"><font class="block-title"><b>Attribute</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>Value</b></font></th>
  </tr>
  <tr> 
    <td class="row1" width="25%">Method</td>
    <td class="row1"> <%= request.getMethod() %></td>
  </tr>
  <tr> 
    <td class="row1" width="25%">Request URI</td>
    <td class="row1" ><%= request.getRequestURI() %></td>
  </tr>
  <tr> 
    <td class="row1" width="25%">Protocol</td>
    <td class="row1" ><%= request.getProtocol() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Servlet path</td>
    <td class="row1" ><%= request.getServletPath() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Path info</td>
    <td class="row1" ><%= request.getPathInfo() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Path translated</td>
    <td class="row1" ><%= request.getPathTranslated() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Query string</td>
    <td class="row1" > <%= request.getQueryString() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Content length</td>
    <td class="row1" ><%= request.getContentLength() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Content type</td>
    <td class="row1" ><%= request.getContentType() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Server name</td>
    <td class="row1" ><%= request.getServerName() %></td>
  </tr>
  <tr> 
    <td class="row1"  width="25%">Server port</td>
    <td class="row1" > <%= request.getServerPort() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Remote user</td>
    <td class="row1" ><%= request.getRemoteUser() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Remote address</td>
    <td class="row1" ><%= request.getRemoteAddr() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Remote host</td>
    <td class="row1" ><%= request.getRemoteHost() %></td>
  </tr>
  <tr> 
    <td  class="row1" width="25%">Authorization scheme</td>
    <td class="row1" ><%= request.getAuthType() %> </td>
  </tr>
</table>
<p>&nbsp;</p>


<h3>Cookies :</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">

  <tr> 
    <th nowrap="nowrap"><font class="block-title"><b>Name</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Value</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Domain</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Age</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Comment</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Path</b></FONT></TH>
    <th nowrap="nowrap"><font class="block-title"><b>Secure</b></FONT></TH>
  </tr>
  <%
  		javax.servlet.http.Cookie cookies[] = request.getCookies();
  		if (cookies != null) {
			for (int i=0; i<cookies.length; i++) {
				String name = cookies[i].getName();
  %>
  <tr> 
    <td class="row1" > <a href="<%=path%>/ewafJsp/snoopDett.jsp?scope=cookie&name=<%= name %>"> <%= name %></a></td>
    <td class="row1" > <%= cookies[i].getValue() %> </td>
    <td class="row1" > <%= cookies[i].getDomain() %> </td>
    <td class="row1" > <%= cookies[i].getMaxAge() %> </td>
    <td class="row1" > <%= cookies[i].getComment() %> </td>
    <td class="row1" > <%= cookies[i].getPath() %> </td>
    <td class="row1" > <%= cookies[i].getSecure() %> </td>
  </tr>
  <%
  	    }
  	 } // End if cookies != null
  %>
</table>


<p><a name="application">&nbsp;</a></p>
<h3>Application Context:</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">

  <tr> 
    <th nowrap="nowrap"><font class="block-title"><b>Name</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>Type</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>Value</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>&nbsp;</b></font></th>
  </tr>
  <%
      enum1 = application.getAttributeNames();
      isSerializable = true;
	  while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
	  		if (pName == null) return;
			Object obj = application.getAttribute(pName);
			if (obj== null) return;
			String val = obj.toString();
			long size = getObjectSize(obj);
			if (size > 0) sizeOfApplication += size;
			String strSize = "" + size;
		  	if (size == -1) {
		  			strSize = "<font color='RED'><b> " + size + "</b></font>";
		  			isSerializable = false; 
		  	}
  %>
  <tr> 
    <td class="row1" ><a href="<%=path%>/ewafJsp/snoopDett.jsp?scope=application&name=<%= pName %>"><%= pName %></a></td>
    <td class="row1" ><%= obj.getClass().getName() %>  (<%= strSize %> bytes) </td>
    <td class="row1" ><%= (val.length() > 60 ? val.substring(0,20) + "..." : val ) %> </td>
    <td class="row1"> <a href="?removeApplicationKey=<%=pName%>"><img src="<%= path %>/ewafJsp/img/remove.gif" border="0"/></a> </td>
  </tr>
  <%
     }
  %>
  <tr> <td  class="row0" colspan="5"> Size of Application Context : <b> <%= sizeOfApplication %></b></td></tr>
</table>
<form action="" method="POST" >
	<p align="center" class="row1">
	Add New value :
	<input type="hidden" name="scope" value="application"> <input type="hidden" name="operation" value="addValue">
	Key: <input type="text" name="key" value="" size="20">
	Value: <input type="text" name="value" value="" size="20">
	<input type="submit" value="Add New Value"></p>
</form>

<p><a name="system">&nbsp;</a></p>
<h3>System Environment:</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">

  <tr> 
    <th nowrap="nowrap"><font class="block-title"><b>Name</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>Value</b></font></th>
  </tr>
  <%
      enum1 = System.getProperties().keys();
      while (enum1.hasMoreElements()) {
	  		String pName = (String)enum1.nextElement();
			String val = System.getProperty(pName);
			if (val == null) val = "&nbsp;";
  %>
  <tr> 
    <td class="row1" ><%= pName %></td>
    <td class="row1" ><%= (val.length() > 100 ? val.substring(0,20) + "..." : val ) %> </td>
  </tr>
  <%
     }
  %>
  
</table>

<h3>Ewaf Action Stack :</h3>
<table class="roundTable"  cellpadding="0" cellspacing="1" border="1" width="100%">

  <tr> 
    <th nowrap="nowrap"><font class="block-title"><b>ActionName</b></font></th>
    <th nowrap="nowrap"><font class="block-title"><b>Request parameters</b></font></th>
  </tr>
  <%
  	  java.util.List<EwafActionStepBean> actionStackList = (java.util.List<EwafActionStepBean>) session.getAttribute(EwafConst.EWAF_Session_ACTION_STACK_KEY);
  	  for (EwafActionStepBean bean : actionStackList) {
      		String actionName = bean.getActionName();
			java.util.Map map = bean.getRequestParameters();
			String props = "&nbsp;";
			if (map != null) props = map.toString();
			
  %>
  <tr> 
    <td class="row1" ><%= actionName %></td>
    <td class="row1" ><%= props %> </td>
  </tr>
  <%
     }
  %>
  
</table>


<p align="center"> <%= copyright %> </p>
</body>