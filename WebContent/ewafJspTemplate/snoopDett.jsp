<%@ page import="java.lang.reflect.Field" %>
<%@ page import="java.lang.reflect.Modifier" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.lang.reflect.Method" %>



<html>
<%
	String copyright = "";
	
	String path = request.getContextPath();
	//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

	String scope = request.getParameter("scope");
	String varName = request.getParameter("name");
	
	final String RED = "CC0000";
	final String BLUE = "0000FF";
%>

<%! 
	// Restituisce il nome di una classe
	public String getClassName(Class c) {
		String res = c.getName();
		if (res.startsWith("class")) res = res.substring(5);
		if (res.startsWith("java.lang.")) res = res.substring(10);
		return res;
	}
%>

<head>
	<link rel="stylesheet" type="text/css" href="<%= path %>/ewafJsp/ewaf.css">
</head>

<body bgcolor="#FFFFFF">

<h1 align="center"><a href="snoop.jsp">Snoop JSP</a></h1>
<h2 align="center"> Object Info </h2>

<p> <center> 
	Scope : <b><%= scope %></b> <br> Key : <b><%= varName %> </b>
</center>

<%	if (scope != null) { 
		Object obj = null;
		if ("application".equals(scope)) obj = application.getAttribute(varName);
		if ("session".equals(scope)) obj = session.getAttribute(varName);
		if ("cookie".equals(scope)) {
			Cookie c[] = request.getCookies();
			int i=0; while (obj == null && i<c.length) { if (c[i].getName().equals(varName)) obj = c[i]; i++; }
		}
		if (obj == null) return;
		
		
%>

<p><table border='0' align="center">
	<tr> 
		<td> <img src='img/class.jpg'> </td>
		<td valign="top">
<%
	out.print("<p> <table border='0'>");
	out.print("<tr><td>");	
	out.print("<font color='" + RED + "'><b>");
	out.print(Modifier.toString(obj.getClass().getModifiers()));
	out.print("</b></font> ");
	out.print("</td><td>");
	
	out.print("<b>" + obj.getClass().getName() + "</b>");
	
	out.println("</td>");


	out.print("<tr><td> &nbsp; </td><td> ");	
	String extendClass = getClassName(obj.getClass().getSuperclass());
	out.println("<font color='" + RED + "'><b> extends </b></font>" + extendClass);
	

	Class [] implementsClass = obj.getClass().getInterfaces();
	if (implementsClass.length > 0) {
		out.print("<tr><td>&nbsp;</td><td>");
		out.print("<font  color='" + RED + "'>  <b>implements</b> </font>   ");
		for (int i=0; i<implementsClass.length - 1; i++) 
			out.println(implementsClass[i].getName() + ",");
		out.print(implementsClass[implementsClass.length - 1].getName());
		out.println("</td></tr>");
	}
	out.println("</table>");
%>
	</td>
	</tr>
</table>

<hr>
<TABLE border="0" width="100%">
	<TR>
		<TD><font size="+1"><b>Object.toString() :&nbsp; </b></font></TD>
		<TD><TEXTAREA rows="7" cols="90" ><%= obj.toString() %></TEXTAREA></TD>
	</TR>
</TABLE>

<%
	Field fields[] = obj.getClass().getFields();
	if (fields != null && fields.length > 0) {
		out.println("<p><h3>Fields</h3>");
		out.println("<ul>");

		for (int i=0; i<fields.length; i++) {
			out.print("<li>");
			out.print("<font color='" + RED + "'><b>" + Modifier.toString(fields[i].getModifiers()) + "</b></font> ");
			
			String type = getClassName(fields[i].getType());
			out.print(" <b>" + type.trim() + "</b> ");
			out.print(fields[i].getName());
			
			out.print(" = ");
			
			String delLeft = "{\"", delRight = "\"}";
			if (type.endsWith("String")) { delLeft = delRight = "\""; }
			if (type.endsWith("int") || type.endsWith("short")) { delLeft = delRight = ""; }
			if (type.endsWith("int") || type.endsWith("long")) { delLeft = delRight = ""; }
			if (type.endsWith("byte") || type.endsWith("char")) { delLeft = delRight = "'"; }
			out.print("<font color='" + BLUE + "'>" + delLeft + fields[i].get(obj).toString() + delRight + "</FONT>");
			
			out.println("</li>");
		}
		out.println("</ul>");
	}
	
	
	Method methods[] = obj.getClass().getMethods();
	if (methods != null && methods.length > 0) {
		out.println("<p><h3>Object Methods</h3>");
		out.println("<ul>");

		for (int i=0; i<methods.length; i++) {
			Method m = methods[i];
			out.print("<li>");
			out.print("<font color='" + RED + "'><b>" + Modifier.toString(m.getModifiers()) + "</b></font> ");
			
			String retType = getClassName(m.getReturnType());
			
			String type = "<b>" + retType + "</b>&nbsp;" + m.getName();
			Class params[] = m.getParameterTypes();
		
			type += "(";
				if (params != null && params.length > 0) {
					for (int j=0; j<params.length - 1; j++) {
						type += getClassName(params[j].getClass()) + " arg" + j + ", ";
					}
					type += getClassName(params[params.length - 1]) + " arg" + (params.length);
				}
			type += ")";
			out.print(type.trim());
			
			if (params.length == 0) {
				try {
					Object xxvalue = m.invoke(obj, null);
					String strVal = "NULL";
					if (xxvalue != null) strVal = xxvalue.toString();
					if (strVal.length() > 50) strVal = strVal.substring(0, 49) + " ... ";
					out.print(" = ");
					out.print("<font color='" + BLUE + "'>");
					out.print(strVal);
					out.print("</font>");
				} catch (Exception xxx) {
					out.println(xxx.getMessage());
				}
				
			}
			
					
			out.println("</li>");
		}
		out.println("</ul>");
	}
%>


<% 
	return;
	} // Enf if scope != null 
%>


<p align="center"> <%= copyright %> </p>
</body>