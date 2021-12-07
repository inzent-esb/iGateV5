<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="imc" uri="http://www.inzent.com/imanager/tags/core" %>
<html>
<head>
<%@ include file="/WEB-INF/html/layout/header/head_vue.jsp"%>
<%@ include file="/WEB-INF/html/layout/modal/footer_modal.jsp"%>
</head>
<body>
<div id="wrap" class="login">
	<header id="hd">
		<h1 class="logo text-hide">
			<a href="javascript:void(0);"><img src="<c:url value='/img/logo_wh.svg' />" alt="INZENT">INZENT</a>
		</h1>
	</header>
	<div id="ct">
		<form id='passwordForm' class='form-login'>
			<input type="hidden" name="_method" value="POST"/>
			<img src="<c:url value='/img/product-name.svg' />" alt="ESB">
			<div class="passwordLabel">
				<span><fmt:message>common.password.page</fmt:message></span>
			</div>
			<div class="form-group">
				<i class="icon-lock"></i>
				<input type="hidden" name='passwordOld'>
				<input id="passwordStrOld" type='password'  class="form-control form-control-lg" placeholder="<fmt:message>common.user.oldPassword</fmt:message>" required onKeyup="javascript:if(event.keyCode == 13) passwordValidation() ;" />
				<i class="icon-eye" onclick="changeType('passwordStrOld')"></i>
			</div>
			<div class="form-group">
				<i class="icon-lock"></i>
				<input type="hidden" name='passwordNew'>
				<input id="passwordStrNew" type='password' class="form-control form-control-lg" placeholder="<fmt:message>common.user.newPassword</fmt:message>" required autofocus />
				<i class="icon-eye" onclick="changeType('passwordStrNew')"></i>
			</div>			
			<%-- <c:if test="${not empty error}">
				<div class="alert alert-danger"><imc:throwable throwable="${error}"/></div>
			</c:if> --%>
			<div class="alert alert-danger" style="display: none;"><span id="errorMsg"></span></div>
			<p style="font-size: 0.73rem;">
				<fmt:message>common.user.validationPassCheck</fmt:message>
			</p>
		    <button type="button" class="btn btn-block btn-danger btn-lg" onclick="passwordValidation()"><fmt:message>head.update</fmt:message></button>
		    <sec:csrfInput />
		    <c:if test="${not empty _client_mode}">
		    	<input type="hidden" name="_client_mode" value="${_client_mode}"/>
		    </c:if>			
		</form>
		<p class="copy">&copy; <b>2020 INZENT. All rights reserved</b></p>
	</div>
</div>	
</body>
<script type="text/javascript">
function passwordValidation() {
	if(0 == $.trim($("#passwordStrNew").val()).length) {
		warnAlert({message: '<fmt:message>common.password.noNewPassword</fmt:message>'});
	}else if(0 == $.trim($("#passwordStrOld").val()).length) {
		warnAlert({message: '<fmt:message>common.password.noPassword</fmt:message>'});
	}else {
		$('[name=passwordOld]').val(encryptPassword($('#passwordStrOld').val()));
		$('[name=passwordNew]').val(encryptPassword($('#passwordStrNew').val()));
		
		startSpinner('full');

		$.ajax({
            type : "POST",
            url : "<c:url value='/common/user/password.json' />",
            data: $('#passwordForm').serialize(),
            processData : false,
            success : function(result) {
            	stopSpinner();
            	
            	if('error' === result.result) {
            		$('#errorMsg').text('<fmt:message>common.password.change.fail</fmt:message>').parent().show();
            		return;
            	}
            	
            	normalAlert({message : '<fmt:message>common.password.change.success</fmt:message><br><fmt:message>common.password.go.to.login</fmt:message>', isSpinnerMode: true, isXSSMode: false, callBackFunc : function() {
            		location.href = "<c:url value='/common/auth/login.html' />";
            	}});
            }
        });
	}
}

function changeType(elementId) {
	$('#' + elementId).attr({'type': ('password' == $('#' + elementId).attr('type'))? 'text' : 'password'})
}
</script>
</html>