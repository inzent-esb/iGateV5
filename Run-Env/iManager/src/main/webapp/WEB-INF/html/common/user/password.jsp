<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="imc" uri="http://www.inzent.com/imanager/tags/core" %>
<html>
<head>
<%@ include file="/WEB-INF/html/layout/header/head_vue.jsp"%>
</head>
<body>
<div id="wrap" class="login">
	<header id="hd">
		<h1 class="logo text-hide">
			<a href="javascript:void(0);"><img src="<c:url value='/img/logo_wh.svg' />" alt="INZENT">INZENT</a>
		</h1>
	</header>
	<div id="ct">
		<form id='passwordForm' class='form-login' action="<c:url value='/common/user/password.html' />" method='POST'>
			<img src="<c:url value='/img/product-name.svg' />" alt="ESB">
			<div class="form-group">
				<i class="icon-lock"></i>
				<input id="passwordOld" type='password' name='passwordOld' class="form-control form-control-lg" placeholder="<fmt:message>common.user.oldPassword</fmt:message>" required onKeyup="javascript:if(event.keyCode == 13) passwordValidation() ;" />
				<i class="icon-eye" onclick="changeType('passwordOld')"></i>
			</div>
			<div class="form-group">
				<i class="icon-lock"></i>
				<input id="passwordNew" type='password' name='passwordNew' class="form-control form-control-lg" placeholder="<fmt:message>common.user.newPassword</fmt:message>" required autofocus />
				<i class="icon-eye" onclick="changeType('passwordNew')"></i>
			</div>
			<c:if test="${not empty error}">
				<div class="alert alert-danger"><imc:throwable throwable="${error}"/></div>
			</c:if>
		    <button type="button" class="btn btn-block btn-danger btn-lg" onclick="passwordValidation()"><fmt:message>head.update</fmt:message></button>
		    <sec:csrfInput />
		    <c:if test="${not empty _client_mode}">
		    	<input type="hidden" name="_client_mode" value="${_client_mode}"/>
		    </c:if>			
		</form>
		<p class="copy">&copy; <b>2020 INZENT. All rights reserved</b></p>
	</div>
	<div id="alert" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">
		<div class="modal-dialog modal-dialog-centered modal-dialog-alert">
			<div class="modal-content">
				<div class="modal-body">
					<i class="iconb-warn"></i>
					<p id="warnAlert-text" class="alert-text"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.update</fmt:message></button>
				</div>
			</div>
		</div>
	</div>	
</div>	
</body>
<script type="text/javascript">
function passwordValidation() {
	if(0 == $.trim($("#passwordNew").val()).length) {
		$("#warnAlert-text").text('<fmt:message>common.password.noNewPassword</fmt:message>');
		$("#alert").modal('show');
	}else if(0 == $.trim($("#passwordOld").val()).length) {
		$("#warnAlert-text").text('<fmt:message>common.password.noPassword</fmt:message>')
		$("#alert").modal('show');
	}else {
		$('[name=passwordOld]').val(encryptPassword($('[name=passwordOld]').val()));
		$('[name=passwordNew]').val(encryptPassword($('[name=passwordNew]').val()));
		
		startSpinner('full');
		
		$('#passwordForm').submit() ;
	}
}

function changeType(elementId) {
	$('#' + elementId).attr({'type': ('password' == $('#' + elementId).attr('type'))? 'text' : 'password'})
}
</script>
</html>