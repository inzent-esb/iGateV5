<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="imc" uri="http://www.inzent.com/imanager/tags/core"%>
<html>
<head>
<c:choose>
	<c:when test="${not empty _client_mode && 'c' == _client_mode}">
		<meta name="_csrf" content="${_csrf.token}" />
		<meta name="_csrf_header" content="${_csrf.headerName}" />

		<c:set var="serverName" value="<%=request.getServerName()%>" />
		<c:set var="serverPort" value="<%=request.getServerPort()%>" />
		<c:set var="contextPath" value="<%=request.getContextPath()%>" />
		<c:set var="prefixUrl"
			value="http://${serverName}:${serverPort}${contextPath}" />
		<c:set var="prefixFileUrl" value="${prefixUrl}/custom" />
		<%-- css/fonts/img/js 경로 --%>

		<link rel="stylesheet" type="text/css"
			href="${prefixFileUrl}/css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css"
			href="${prefixFileUrl}/css/common.css">

		<%@ include file="/WEB-INF/html/layout/header/fmt_message.jsp"%>

		<script type="text/javascript" src="${prefixFileUrl}/js/jquery.min.js"></script>
		<script type="text/javascript"
			src="${prefixFileUrl}/js/bootstrap.bundle.min.js"></script>
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
	<div id="login" class="login wrap" data-ready>
		<header id="hd">
			<h1 class="logo text-hide">
				<a href="javascript:void(0);"><img id="logoImg"
					src="${prefixFileUrl}/img/logo_wh.svg" alt="INZENT" />INZENT</a>
			</h1>
		</header>
		<div id="ct">
			<c:if test="${empty logined}">
				<form id="loginForm" class="form-login"
					action="${prefixUrl}/common/auth/login.html" method='POST'
					onsubmit="return false;">
					<c:if test="${not empty _client_mode}">
						<input type="hidden" name="_client_mode" value="${_client_mode}" />
					</c:if>
					<div class="form-login">
						<img src="${prefixFileUrl}/img/product-name.svg" alt="ESB">

						<div class="form-group">
							<img src="${prefixFileUrl}/img/login_user.png" class="icon" /> <input
								type="text" id="userId" name="userId"
								class="form-control form-control-lg"
								placeholder="<fmt:message>head.id</fmt:message>" />
						</div>
						<div class="form-group">
							<img src="${prefixFileUrl}/img/login_pass.png" class="icon" /> <input
								type="password" id="password" name="password"
								class="form-control form-control-lg"
								placeholder="<fmt:message>head.password</fmt:message>" />
						</div>
						<label class="custom-control custom-checkbox"> <input
							id="ckSaveUserId" type="checkbox" class="custom-control-input" />
							<span class="custom-control-label"> <fmt:message>head.save.id</fmt:message>
						</span>
						</label>
						<c:choose>
							<c:when test="${not empty error}">
								<div class="alert alert-danger">
									<imc:throwable throwable="${error}" />
								</div>
							</c:when>
							<c:otherwise>
								<div id="error" class="alert alert-danger"
									style="display: none;"></div>
							</c:otherwise>
						</c:choose>
						<button id="loginBtn" class="btn btn-block btn-danger btn-lg">
							<fmt:message>common.user.login</fmt:message>
						</button>
					</div>
				</form>
				<p class="copy">
					&copy; <b>2022 INZENT. All rights reserved</b>
				</p>
			</c:if>
		</div>
	</div>
	<c:if test="${not empty _client_mode && 'c' == _client_mode}">
		<div id="spinnerDiv"
			style="position: absolute; width: 100%; height: 100%; z-index: 9999; right: 0px; display: none;">
			<div class="spinnerBg"
				style="width: 100%; height: 100%; background-color: #000; opacity: 0.6;"></div>
			<div class="spinner"></div>
		</div>
	</c:if>

	<script type="text/javascript">
<c:choose>
	<c:when test="${not empty _client_mode && 'c' == _client_mode}">
		$(document).ready(function() {
			initLoginArea();
			
			<c:if test="${not empty logined}">
				localStorage.setItem('csrfToken', JSON.stringify({ headerName: $("meta[name='_csrf_header']").attr("content"), token: $("meta[name='_csrf']").attr("content") }));
				
				iManagerLogined("true", "${logined}", "JSESSIONID");
				
				<c:choose>
					<c:when test="${not empty menu}">
						location.href = '${prefixUrl}${menu}?_client_mode=c';
					</c:when>
					<c:otherwise>
						location.href = '${prefixUrl}/common/notice.html?_client_mode=c';
					</c:otherwise>
				</c:choose>
			</c:if>			
	   
		    <c:if test="${(not empty error) and (not empty passwordUrl)}">
 		    	window._alert({
		    		type: 'warn',
		    		backdropMode: false,
		    		message: '<fmt:message>common.password.change.must</fmt:message>',
		    		callBackFunc: function() {
		    			location.href = '${prefixUrl}' + unescapeHtml('<c:out value="${passwordUrl}" />');
		    		}
		    	});
	    	</c:if>
	    
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
		document.querySelector('#login').addEventListener('ready', function(evt) {
			initLoginArea();
			
			initEventBind();
		});	
	</c:otherwise>
</c:choose>

function login() {
	<c:choose>
		<c:when test="${not empty _client_mode && 'c' == _client_mode}">
			if ($("[name=ckSaveUserId]").is(":checked")) {
				localStorage.setItem('ckSaveUserId', 'checked');
				localStorage.setItem('saveUserId', $.trim($("#userId").val()));
			} else {
				localStorage.removeItem('ckSaveUserId');
				localStorage.removeItem('saveUserId');		
			}
			
			$('#password').val(encryptPassword($('#password').val()));
			
			startSpinner('full');

			$('#loginForm')[0].submit();			
		</c:when>
		<c:otherwise>
			$.ajax({
				type: 'POST',
				url: "${prefixUrl}/common/auth/login.json",
				dataType: "json",
				traditional: true,
		        xhrFields: {
		        	withCredentials: true
		        },
				data: {
					'userId': $('#userId').val(),
					'password': encryptPassword($('#password').val()),
					'_client_mode': 'c'
				},
				beforeSend: function(jqXHR, settings) {
					window.$startSpinner('full');
				},
				success: function(data, textStatus, jqXHR) {
					if ('error' == data.result) {
						if (-1 < data.error[0].className.indexOf('CredentialsExpiredException')) {
							window._confirm({
								type: 'warn',
								message: '<fmt:message>common.password.expired</fmt:message>',
								backdropMode: 'full',
								callBackFunc: function() {
									document.querySelector('#login').dispatchEvent(new CustomEvent('goPasswordPage', {
										detail: {
											userId: $('#userId').val()
										}
									}));
								}
							});
						} else if (-1 < data.error[0].className.indexOf('AccountExpiredException')) {
							$("#error").text('<fmt:message>common.expired.account</fmt:message>').show();
						} else if (-1 < data.error[0].className.indexOf('LockedException')) {
							$("#error").text('<fmt:message>common.exceeded.loginAttempts</fmt:message>').show();
						} else {
							$("#error").text('<fmt:message>common.id.password.entered.incorrectly</fmt:message>').show();	
						}
						return;
					}
					
					localStorage.setItem('csrfToken', JSON.stringify({ headerName: data.object.csrfHeader, token: data.object.csrfToken }));
					
					document.querySelector('#login').dispatchEvent(new CustomEvent('loginSuccess'));
				}.bind(this),
				error: function(jqXHR, textStatus, errorThrown) {
					$("#error").text('<fmt:message>common.error.contact.administrator</fmt:message>').show();
				},
				complete: function(jqXHR, textStatus) {
					window.$stopSpinner();
					
					if ($("#ckSaveUserId").is(":checked")){
						localStorage.setItem('ckSaveUserId', 'checked');
						localStorage.setItem('saveUserId', $.trim($("#userId").val()));
					} else {
						localStorage.removeItem('ckSaveUserId');
						localStorage.removeItem('saveUserId');		
					}			
				}
			});			
		</c:otherwise>
	</c:choose>
}

function initLoginArea() {
	removeStorage();
	
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
	
	$("#userId").focus();

	if ('checked' == localStorage.getItem('ckSaveUserId')) {
		$("#ckSaveUserId").prop('checked', true);
		$("#userId").val(localStorage.getItem('saveUserId'));
	}
}

function initEventBind() {
	$("#userId, #password").keypress(function(evt) {
		if (13 == evt.which) {
			evt.preventDefault();
			login();
		}
	});

	$("#loginBtn").click(function() {
		login();
	});
}
</script>
</body>
</html>