<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="login" class="login wrap" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>		
		<header id="hd">
			<h1 class="logo text-hide">
				<a href="javascript:void(0);">
					<img id="logoImg" src="${prefixFileUrl}/img/logo_wh.svg" alt="INZENT" />INZENT
				</a>
			</h1>
		</header>
		<div id="ct">
			<div class="form-login">
				<img src="${prefixFileUrl}/img/product-name.svg" alt="ESB">

				<div class="form-group">
					<img src="${prefixFileUrl}/img/login_user.png" class="icon" /> 
						<input type="text" id="userId" name="userId" class="form-control form-control-lg" placeholder="<fmt:message>head.id</fmt:message>" />
				</div>
				<div class="form-group">
					<img src="${prefixFileUrl}/img/login_pass.png" class="icon" /> 
					<input type="password" id="password" name="password" class="form-control form-control-lg" placeholder="<fmt:message>head.password</fmt:message>" />
				</div>
				<label class="custom-control custom-checkbox"> 
					<input id="ckSaveUserId" type="checkbox" class="custom-control-input" />
					<span class="custom-control-label"> <fmt:message>head.save.id</fmt:message></span>
				</label>
				<div id="error" class="alert alert-danger" style="display: none;"></div>
				<button id="loginBtn" class="btn btn-block btn-danger btn-lg">
					<fmt:message>common.user.login</fmt:message>
				</button>
			</div>
			<p class="copy"> 
				&copy; <b>2023 INZENT. All rights reserved</b>
			</p>
		</div>
	</div>
	
	<script type="text/javascript">
	var loginType = 'normal';
	var loginQueryParam = null;
	var clientMode = '<c:out value="${_client_mode}"/>'; 
	var combineLogin = '<c:out value="${combineLogin}"/>';
	var returnUrl = location.href;
	
	document.querySelector('#login').addEventListener('loginQueryParam', function(evt) {
		loginQueryParam = evt.detail;
	});
	
	document.querySelector('#login').addEventListener('ready', function(evt) {
		initLoginArea();	

		initEventBind();

		if (combineLogin) {
			if (loginQueryParam && loginQueryParam.user && loginQueryParam.token) {
				loginType = 'combine';
				login();
			} else {
				loginType = 'normal';
			}
		} else {
			loginType = 'normal';
		}
	});
	
	function login() {
		$.ajax({
			type: 'POST',
			url: "${prefixUrl}/api/auth/token" + ('combine' === loginType? '?combineLogin=true' : ''),
			dataType: "json",
			traditional: true,
	        xhrFields: {
	        	withCredentials: true
	        },
			data: JSON.stringify({
				'userId': 'combine' === loginType? loginQueryParam.user : $('#userId').val(),
				'password': 'combine' === loginType? loginQueryParam.token : encryptPassword($('#password').val()),
				'_client_mode': 'c',
				'clientTimeMillis': Date.now()
			}),
			beforeSend: function(jqXHR, settings) {
				window.$startSpinner('full');
			},
			success: function(data, textStatus, jqXHR) {
				if ('error' == data.result) {
					if ('combine' === loginType) {
						window._alert({
							type: 'warn',
							message: '<fmt:message>head.error.info</fmt:message> <br/>' + escapeHtml(data.error[0].className) + '<br/><br/>' + escapeHtml(data.error[0].message),
							backdropMode: true,
							isXSSMode: false,
							callBackFunc: function() {
								location.href = combineLogin + "?returnUrl=" + returnUrl;	
							}
						});
					} else {
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
	                        $("#error").text('<fmt:message>common.restricted.login</fmt:message>').show();
						} else {
							$("#error").text('<fmt:message>common.id.password.entered.incorrectly</fmt:message>').show();	
						}						
					}
					
					return;
				}
				
				var accessToken = jqXHR.getResponseHeader('X-iManager-Access');
				var refreshToken = jqXHR.getResponseHeader('X-iManager-Refresh');
				
				localStorage.setItem('accessToken', 'Bearer ' + accessToken);
				localStorage.setItem('refreshToken', refreshToken);
				localStorage.setItem('tokenExpiration', data.object);

				licExpirationModal();

			    <c:choose>
		        	<c:when test="${not empty _client_mode && 'c' == _client_mode}">
						if (window.iManagerLogined) {
							window.iManagerLogined("true", accessToken, refreshToken, String(data.object));
						} else {
							document.querySelector('#login').dispatchEvent(new CustomEvent('loginSuccess'));
						}
		        	</c:when>
		            <c:otherwise>
		            	document.querySelector('#login').dispatchEvent(new CustomEvent('loginSuccess'));
		            </c:otherwise>
		        </c:choose>
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
	}
	
	function initLoginArea() {
		removeStorage();
		
		$.ajax({
			type: 'POST',
			url: "${prefixUrl}/api/page/logoFileName",
			dataType: "json",
			data: JSON.stringify({ 'type': 'login' }),		
			beforeSend: function (request) {
	            request.setRequestHeader('X-iManager-Method', 'GET');
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