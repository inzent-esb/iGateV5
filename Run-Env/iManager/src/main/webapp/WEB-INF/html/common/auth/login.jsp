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
<script type="text/javascript">
$(document).ready(function() {
    initLoginArea();

    <c:if test="${not empty logined}">
      iManagerLogined("true", "${logined}", "JSESSIONID") ;
      <c:choose>
      <c:when test="${not empty menu}">
        location.href = '<c:url value="${menu}?_client_mode=c" />' ;
      </c:when>
      <c:otherwise>
        location.href = '<c:url value="/common/notice.html?_client_mode=c" />' ;
      </c:otherwise>
      </c:choose>
    </c:if>

    <c:if test="${(not empty error) and (not empty passwordUrl)}">
    	warnAlert({message : '<fmt:message>common.password.change.must</fmt:message>', isSpinnerMode: true, callBackFunc : function() {
    		location.href = contextPath + unescapeHtml('<c:out value="${passwordUrl}" />');    		
    	}});
    </c:if>

    initEventBind();
}) ;

function initLoginArea() {
	
	$("[name=userId]").focus();
	
	if('checked' == localStorage.getItem('ckSaveUserId')) {
		$("[name=ckSaveUserId]").prop('checked', true);
		$("[name=userId]").val(localStorage.getItem('saveUserId'));
	}
}

function initEventBind() {
	$("[name=userId], [name=password]").keypress(function(evt) {
		if(13 == evt.which) {
			evt.preventDefault();
			login();
		}
	});
	
	$("#loginBtn").click(function() {
		login();
	});
}

function login() {
	
	if($("[name=ckSaveUserId]").is(":checked")){
		localStorage.setItem('ckSaveUserId', 'checked');
		localStorage.setItem('saveUserId', $.trim($("[name=userId]").val()));
	}else{
		localStorage.removeItem('ckSaveUserId');
		localStorage.removeItem('saveUserId');		
	}
	
	$('[name=password]').val(encryptPassword($('[name=password]').val()));
	
	startSpinner('full');
	
	$('#loginForm')[0].submit();
}
</script>
</head>
<body>
<div id="wrap" class="login">
	<header id="hd">
		<h1 class="logo text-hide">
			<a href="javascript:void(0);"><img src="<c:url value='/img/logo_wh.svg' />" alt="INZENT">INZENT</a>
		</h1>
	</header>
	<div id="ct">
	  <c:if test="${empty logined}">
		<form id="loginForm" class="form-login" action="<c:url value='/common/auth/login.html' />" method='POST' onsubmit="return false;">
		<sec:csrfInput />
			<img src="<c:url value='/img/product-name.svg' />" alt="ESB">
			<div class="form-group">
				<img src="<c:url value='/img/login_user.png' />" class="icon">
				<input type="text" name='userId' class="form-control form-control-lg" placeholder="<fmt:message>head.id</fmt:message>">
			</div>
			<div class="form-group">
				<img src="<c:url value='/img/login_pass.png' />" class="icon">
				<input type="password" name='password' class="form-control form-control-lg" placeholder="<fmt:message>head.password</fmt:message>">
			</div>
			<label class="custom-control custom-checkbox">
				<input name="ckSaveUserId" type="checkbox" class="custom-control-input">
				<span class="custom-control-label"><b><fmt:message>head.save.id</fmt:message></b></span>
			</label>
			<c:if test="${not empty error}">
				<div class="alert alert-danger"><imc:throwable throwable="${error}"/></div>
			</c:if>
			<button id="loginBtn" class="btn btn-block btn-danger btn-lg"><fmt:message>common.user.login</fmt:message></button>
			
			<c:if test="${not empty _client_mode}">
				<input type="hidden" name="_client_mode" value="${_client_mode}"/>
			</c:if>			
		</form>
		<p class="copy">&copy; <b>2020 INZENT. All rights reserved</b></p>
		</c:if>
	</div>
</div>	
</body>
</html>