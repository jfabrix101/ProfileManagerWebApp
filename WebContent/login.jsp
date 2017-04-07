<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	EwafUserProfile up = (EwafUserProfile) EwafHelper
			.getUserProfile(session);
	String userName = null;
	if (up != null)
		up.getUserName();
%>
<screen2:useTemplate templateName="MASTER" alias="body">
<screen2:redefineAlias name="bodyTitle" value="fesd HomePage" />

<style>
card-container.card {
	max-width: 350px;
	padding: 40px 40px;
}

/*
 * Card
 */
.card {
	background-color: #F7F7F7;
	/* just in case there no content*/
	padding: 20px 25px 30px;
	margin: 0 auto 25px;
	margin-top: 50px;
	/* shadows and rounded borders */
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	border-radius: 2px;
	-moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	-webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
}

.logo-img {
	width: 100%;
	margin: 0 auto 10px;
	display: block;
}

.form-signin #inputEmail, .form-signin #inputPassword {
	direction: ltr;
	height: 44px;
	font-size: 16px;
}

.form-signin input[type=email], .form-signin input[type=password],
	.form-signin input[type=text], .form-signin button {
	width: 100%;
	display: block;
	margin-bottom: 10px;
	z-index: 1;
	position: relative;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
}

.form-signin .form-control:focus {
	border-color: rgb(104, 145, 162);
	outline: 0;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px
		rgb(104, 145, 162);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px
		rgb(104, 145, 162);
}
</style>


<div class="row-fluid container">
	<div class="container">
		<div class="col-md-4">&nbsp;</div>
		<div class="col-md-4 card card-container">
			<img id="logo-img" class="logo-img"	src="https://placeholdit.imgix.net/~text?txtsize=33&txt=INSERT_LOGO&w=350&h=150" />
			
			<form class="form-signin" method="post" action="<%= path %>/ewaf/login">
				<input type="text" name="userName" id="inputEmail"
					class="form-control" placeholder="username" required autofocus>
				<input type="password" name="password" id="inputPassword"
					class="form-control" placeholder="password" required>
				<button class="btn btn-lg btn-primary btn-block btn-signin"
					type="submit">Accedi</button>
			</form>
		</div>
		<div class="col-md-4">&nbsp;</div>
	</div>
</div>

</screen2:useTemplate>