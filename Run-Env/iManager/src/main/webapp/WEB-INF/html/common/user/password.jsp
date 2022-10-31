<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<c:choose>
	<c:when test="${not empty _client_mode && 'c' == _client_mode}">
		<c:set var="serverName" value="<%= request.getServerName() %>" />
		<c:set var="serverPort" value="<%= request.getServerPort() %>" />
		<c:set var="contextPath" value="<%= request.getContextPath() %>" />
		<c:set var="prefixUrl" value="http://${serverName}:${serverPort}${contextPath}" />
		<c:set var="prefixFileUrl" value="${prefixUrl}/custom" /> <%-- css/fonts/img/js 경로 --%>
		
		<link rel="stylesheet" type="text/css" href="${prefixFileUrl}/css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" href="${prefixFileUrl}/css/common.css">
		
		<%@ include file="/WEB-INF/html/layout/header/fmt_message.jsp"%>
		
		<script type="text/javascript" src="${prefixFileUrl}/js/jquery.min.js"></script>
		<script type="text/javascript" src="${prefixFileUrl}/js/bootstrap.bundle.min.js"></script>
		<script type="text/javascript" src="${prefixFileUrl}/js/aes.js"></script>
		<script type="text/javascript" src="${prefixFileUrl}/js/utils.js"></script>
		<script type="text/javascript" src="${prefixFileUrl}/js/modal.js"></script>
	</c:when>
	<c:otherwise>
		<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
	</c:otherwise>
</c:choose>
</head>
<body>
    <div id="password" class="login wrap" data-ready>
        <header id="hd">
            <h1 class="logo text-hide">
                <a href="javascript:void(0);"><img id="logoImg" src="${prefixFileUrl}/img/logo_wh.svg" alt="INZENT" />INZENT</a>
            </h1>
        </header>
        <div id="ct">
        	<div class="form-login">
	            <img src="${prefixFileUrl}/img/product-name.svg" alt="ESB">
	            
				<div class="password-label"><fmt:message>common.password.page</fmt:message></div>
				
				<div class="form-group">
					<i class="icon-lock"></i>
					<input id='passwordOld' type="hidden">
					<input id="passwordStrOld" type='password' class="form-control form-control-lg" placeholder="<fmt:message>common.user.oldPassword</fmt:message>" />
					<i class="icon-eye"></i>
				</div>
	            
				<div class="form-group">
					<i class="icon-lock"></i>
					<input id="passwordNew" type="hidden">
					<input id="passwordStrNew" type='password' class="form-control form-control-lg" placeholder="<fmt:message>common.user.newPassword</fmt:message>" />
					<i class="icon-eye"></i>
				</div>	            

				<div id="error" class="alert alert-danger" style="display: none;"></div>
				
				<p style="font-size: 0.73rem;">
					<fmt:message>common.user.validationPassCheck</fmt:message>
				</p>
				
	            <button id="passwordBtn" class="btn btn-block btn-danger btn-lg">
	            	<fmt:message>head.update</fmt:message>
	            </button>
            </div>
            <p class="copy">&copy; <b>2022 INZENT. All rights reserved</b></p>
        </div>
    </div>
    <sec:csrfMetaTags />
    <c:if test="${not empty _client_mode && 'c' == _client_mode}">
	    <div id="spinnerDiv" style="position: absolute; width: 100%; height: 100%; z-index: 9999; right: 0px; display: none;">
			<div class="spinnerBg" style="width: 100%; height: 100%; background-color: #000; opacity: 0.6;"></div>
			<div class="spinner"></div>
		</div>    
    </c:if>    
    
<script type="text/javascript">
<c:choose>
	<c:when test="${not empty _client_mode && 'c' == _client_mode}">
		$(document).ready(function() {
			getLogoFileName();
			
			$("#passwordStrOld").focus();
			
			initEventBind();			
		});
	
		function startSpinner(spinnerMode) {
			$("#spinnerDiv").width(('full' == spinnerMode)? '100%' : $("#ct").outerWidth(true)).height('100%').show() ;
		    $("#spinnerDiv").removeData('spinnerMode');
		    $("#spinnerDiv").data('spinnerMode', spinnerMode);
		}
	
		function stopSpinner(callbackFunc) {
			setTimeout(function() {
				$("#spinnerDiv").hide(0, function() {
					if (callbackFunc)
						callbackFunc();  
				}) ;
			}, 350) ;
		}	
	</c:when>
	<c:otherwise>
		document.querySelector('#password').addEventListener('ready', function(evt) {
			getLogoFileName();
		
			$("#passwordStrOld").focus();
			
			initEventBind();
		});	
	</c:otherwise>
</c:choose>	

function getLogoFileName() {
	$.ajax({
		type: 'GET',
		url: "${prefixUrl}/igate/page/common/logoFileName.json",
		dataType: "json",
		data: {
			'type': 'login'
		},		
        success: function(res) {
			if ('ok' !== res.result || !res.object) return;
			
			$('#logoImg').attr('src', "${prefixFileUrl}/img/" + escapeHtml(res.object));
		}
	});
}

function initEventBind() {
	$("#passwordStrOld, #passwordStrNew").keypress(function(evt) {
		if(13 == evt.which) {
			passwordValidation();
		}
	});
	
	$("#passwordBtn").click(function() {
		passwordValidation();
	});
	
	$(".icon-eye").click(function() {
		$(this).prev().attr({'type': ('password' == $(this).prev().attr('type'))? 'text' : 'password'});
	});
}

function passwordValidation() {
	var isError = false;
	var errorTxt = null;
    
	if(0 == $.trim($("#passwordStrNew").val()).length) {
		window._alert({type: 'warn', message: '<fmt:message>common.password.noNewPassword</fmt:message>'});
	}else if(0 == $.trim($("#passwordStrOld").val()).length) {
		window._alert({type: 'warn', message: '<fmt:message>common.password.noPassword</fmt:message>'});
	} else {
		$('#passwordOld').val(encryptPassword($('#passwordStrOld').val()));
		$('#passwordNew').val(encryptPassword($('#passwordStrNew').val()));
		
		$.ajax({
			type: 'POST',
			url: "${prefixUrl}/common/user/password.json",
			dataType: "json",
			traditional: true,
	        xhrFields: {
	        	withCredentials: true
	        },			
			data: {
				'userId': '<c:out value="${object.userId}" />',
				'passwordOld': $('#passwordOld').val(),
				'passwordNew': $('#passwordNew').val(),
			},
			beforeSend: function (request) {
				<c:choose>
					<c:when test="${not empty _client_mode && 'c' == _client_mode}">
						startSpinner('full');
					</c:when>
					<c:otherwise>
						window.$startSpinner('full');
					</c:otherwise>
				</c:choose>					
				
				request.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
			},
			success: function(data, textStatus, jqXHR) {
				if ('error' == data.result) {
					isError = true;
					errorTxt = '<fmt:message>common.password.entered.incorrectly</fmt:message>';
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				isError = true;
				errorTxt = '<fmt:message>common.error.contact.administrator</fmt:message>';				
			},
			complete: function(jqXHR, textStatus) {
				<c:choose>
					<c:when test="${not empty _client_mode && 'c' == _client_mode}">
						stopSpinner();
					</c:when>
					<c:otherwise>
						window.$stopSpinner();
					</c:otherwise>
				</c:choose>					
				
				if (isError) {
					$("#error").text(errorTxt).show();
				} else {
					window._alert({
						type: 'normal',
						message: '<fmt:message>common.password.change.success</fmt:message><br><fmt:message>common.password.go.to.login</fmt:message>', 
						backdropMode: true, 
						isXSSMode: false, 
						callBackFunc: function() {
							<c:choose>
								<c:when test="${not empty _client_mode && 'c' == _client_mode}">
									location.href = '${prefixUrl}/common/auth/login.html?_client_mode=c';
								</c:when>
								<c:otherwise>
									document.querySelector('#password').dispatchEvent(new CustomEvent('goLoginPage'));
								</c:otherwise>
							</c:choose>									
	            	}});					
				}
			}
		});		
	}
}
</script>
</body>
</html>