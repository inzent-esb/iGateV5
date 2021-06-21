<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

var defaultUri = "/common/portal.html";
var forwardServletPathUrl = '<%= request.getAttribute("javax.servlet.forward.servlet_path") %>'

var homeViewMenuId = null;

var bookmarkMaxCnt = 5;

var isOnPopState = false;

var spinnerOption = 'full';

$(document).ready(function() {
	
	initEventBind();
	
	PropertyImngObj.getProperty('Property.Menu', 'default.home.menuId', function(res) {
		
		homeViewMenuId = (res)? res.propertyValue : 303080;
		
		initMenu();
	});
});

function initMenu() {
	
	startSpinner(spinnerOption);
	
    $.ajax({
    	type: "GET",
    	url: "<c:url value='/common/portal/menu.json' />",
        processData: true,
        data: null,
        dataType: "json",
        success: function(res) {

        	if("ok" !== res.result) {
        		stopSpinner();
        		return;
        	}
        	
        	for(var i = 0; i < res.object.subMenus.length; i++) {
        		menuBuilder(res.object.subMenus[i], $("#gnb"), i);
        	}
        	
        	stopSpinner();
        	
        	$("#menu-home").data({
        		'href': $('#' + homeViewMenuId).data('href'), 
        		'pathIdList': ['menu-home'],
        		'pathList': $('#' + homeViewMenuId).data('pathList'),
        		'window': $('#' + homeViewMenuId).data('window')
        	});
        	
			if(defaultUri != forwardServletPathUrl) {
				$("#gnb").find('.menu-link').each(function(index, element) {
					if(forwardServletPathUrl == $(element).data('href')) {
						sessionStorage.removeItem('pathIdList');
						sessionStorage.setItem('pathIdList', $(element).data('pathIdList'));
						return false;
					}
				});
			}        	
        	
        	if(sessionStorage.getItem('pathIdList')) {
        		var pathIdList = sessionStorage.getItem('pathIdList').split(',');
        		
        		var clickedFunc = function() {
            		for(var i = 0; i < pathIdList.length; i++) {
            			
            			if('true' == $("#" + pathIdList[i]).attr('aria-expanded')) continue;
            			
            			$("#" + pathIdList[i]).trigger('click');
            		}
        		};
        		
        		if(0 < pathIdList[pathIdList.length - 1].indexOf('_bookmark')) {
        			setMenuBookmark(clickedFunc);
        		} else {
        			setMenuBookmark();
        			clickedFunc();
        		}
        		
        	} else {
        		setMenuBookmark();
        		$("#menu-home").trigger('click');
        	}
        },
        error: function(request, status, error) {
        	stopSpinner();
        }
    });
    
 	function menuBuilder(menu, parentTag, index) {
 		
		if(menu.menuUrl) {
			parentTag.append(
				$("<li/>").addClass('menu-item')
						  .attr({'id': 'menuLi' + index})
						  .append(
							  $("<a/>").addClass('menu-link')
							  		   .attr({'href': 'javascript:void(0);', 'id': menu.menuId})
							           .data({'href': menu.menuUrl, 'pathIdList': [menu.menuId], 'pathList': [menu.menuName], 'window': menu.openWindows})
							           .append(
							               (menu.menuIcon)? $('<img/>').attr({'src': '<c:url value="/img/menu/' + menu.menuIcon + '"/>'}) : $('<i/>').addClass('icon-lock')
							           )
							           .append(
							               escapeHtml(menu.menuName)
							           )
						  )
						  .append(
						      $("<button/>").addClass('menu-bookmark icon-bookmark').data('menuId', menu.menuId)
						  )
			);
		} else {
			parentTag.append(
				$("<li/>").attr({'id': 'menuLi' + index})
						  .append(
						      $("<a/>").addClass('menu-collapse-link collapsed')
									   .attr({'href': '#menu_' + menu.menuId, 'id': menu.menuId, 'data-window': menu.openWindow, 'data-toggle': 'collapse'})	
				                       .append(
				                           escapeHtml(menu.menuName)
				                       )		
				                       .append(
				                           $('<i/>').addClass('icon-down') 
				                       )			                       
						  )
						  .append(
						      $("<ul/>").addClass('menu-collapse collapse').attr({'id': 'menu_' + menu.menuId, 'data-parent' : ''})
						  )
			);
		
	    	for(var i = 0; i < menu.subMenus.length; i++) {
	    		
	    		if(menu.subMenus[i].menuUrl) {
	    			$('#menu_' + menu.menuId).append(
			    	    $("<li/>").addClass('menu-collapse-item')
			    	    		  .attr({'id': 'menuLi' + index + 'sub' + i})
			    	              .append(
			    	                  $("<a/>").addClass('menu-link')
			    	                  		   .attr({'href': 'javascript:void(0);', 'id': menu.subMenus[i].menuId})
			    	                  		   .data({'href': menu.subMenus[i].menuUrl, 'pathIdList': [menu.subMenus[i].menuId], 'pathList': [menu.subMenus[i].menuName], 'window': menu.subMenus[i].openWindow})
			    	                  		   .append(
											       (menu.subMenus[i].menuIcon)? $('<img/>').attr({'src': '<c:url value="/img/menu/' + menu.subMenus[i].menuIcon + '"/>'}) : $('<i/>').addClass('icon-lock')    	                  				   
			    	                  		   )
			    	                  		   .append(
			    	                  		       escapeHtml(menu.subMenus[i].menuName)          		   
			    	                  		   )
			    	              )
			    	              .append(
			    	                  $("<button/>").addClass('menu-bookmark icon-bookmark').data('menuId', menu.subMenus[i].menuId)
			    	              )
		    	 	);
	    		} else {
	    			$('#menu_' + menu.menuId).append(
			    	    $("<li/>").addClass('menu-collapse-item')
			    	    		  .attr({'id': 'menuLi' + index + 'sub' + i})
								  .append(
								      $("<a/>").addClass('menu-collapse-link collapsed')
								      		   .attr({'href': '#menu_' + menu.subMenus[i].menuId, 'id': menu.subMenus[i].menuId, 'data-toggle': 'collapse'})
								      		   .append(
								      				 escapeHtml(menu.subMenus[i].menuName)
								      		   )
								      		   .append(
								      				 $('<i/>').addClass('icon-down')
								      		   )
								  )
								  .append(
								      $("<ul/>").addClass('collapse').attr({'id': 'menu_' + menu.subMenus[i].menuId})
								  )
		    	 	);
	    			
		    		for(var j = 0; j < menu.subMenus[i].subMenus.length; j++) {    			
		    			
		    			var menuAction = (menu.subMenus[i].subMenus[j].menuUrl)? menu.subMenus[i].subMenus[j].menuUrl : (menu.subMenus[i].subMenus[j].menuEditor)? menu.subMenus[i].subMenus[j].menuEditor : '';

		    			if(-1 == menuAction.indexOf('.html') && !menuAction.startsWith('http') && !menuAction.startsWith('https')) continue;
		    			
		    			$('#menu_' + menu.subMenus[i].menuId).append(
		    				$("<li/>").addClass('menu-item')
		    						  .attr({'id': 'menuLi' + index + 'sub' + i + 'sub' + j})
		    						  .append(
		    						      $("<a/>").addClass('menu-link')
		    						      		   .attr({'href': 'javascript:void(0);', 'id': menu.subMenus[i].subMenus[j].menuId})
		    						      		   .data({'href': menuAction, 'window': menu.subMenus[i].subMenus[j].openWindow, 'pathList': [menu.menuName, menu.subMenus[i].menuName, menu.subMenus[i].subMenus[j].menuName], 'pathIdList': [menu.menuId, menu.subMenus[i].menuId, menu.subMenus[i].subMenus[j].menuId]})
		    						      		   .append(
		    						      		       (menu.subMenus[i].subMenus[j].menuIcon)? $('<img/>').attr({'src': '<c:url value="/img/menu/' + menu.subMenus[i].subMenus[j].menuIcon + '"/>'}) : $('<i/>').addClass('icon-lock')   						      				   
		    						      		   )
		    						      		   .append(
		    						      		       escapeHtml(menu.subMenus[i].subMenus[j].menuName)	   
		    						      		   )
		    						  )
		    						  .append(
		    						      $("<button/>").addClass('menu-bookmark icon-bookmark').data('menuId', menu.subMenus[i].subMenus[j].menuId)  
		    						  )
		    			);
		    		}	    			
	    		}
	    	}			
		}
    } 	
}

function setMenuBookmark(callBackFunc) {
	
	startSpinner(spinnerOption);
	
	$("#menu-bookmark").find('.menu').empty();
	
	$.ajax({
		type : "GET",
		url: "<c:url value='/common/menuBookmark/list.json'/>",
		dataType : "json",
		data: {
			'pk.userId': $("#userId").val(),
		},
		success : function(res) {
			
			if('ok' != res.result) {
				stopSpinner();
				return;
			}
			
			var menuBookmarkList = res.object;
			
			if(0 == menuBookmarkList.length) {
				$("#menu-bookmark-no-data").show();
				
				if(!$("#menu-bookmark-parent").hasClass('disabled')) {
					$("#menu-bookmark-parent").addClass('disabled');	
				}
			}else{
				$("#menu-bookmark-no-data").hide();
				$("#menu-bookmark-parent").removeClass('disabled');
				
				menuBookmarkList.forEach(function(menuBookmark) {
					
					$("#" + menuBookmark.pk.menuId).parent().find('.menu-bookmark').addClass('active');
					
					var cloneMenu = $("#" + menuBookmark.pk.menuId).parent().clone();
					 
					cloneMenu.attr({'id': cloneMenu.attr('id') + '_bookmark'});
					cloneMenu.find('.menu-link').attr({'id': menuBookmark.pk.menuId + '_bookmark'});
					
					var tmpData = $("#" + menuBookmark.pk.menuId).data();
					
					cloneMenu.find('.menu-link').data('href', tmpData['href']);
					cloneMenu.find('.menu-link').data('pathList', tmpData['pathList']);
					cloneMenu.find('.menu-link').data('pathIdList', ['menu-bookmark-parent', menuBookmark.pk.menuId + '_bookmark']);
					
					cloneMenu.children('a').removeClass('active');
					cloneMenu.find('.menu-bookmark').data('menuId', menuBookmark.pk.menuId);
					
					$("#menu-bookmark").find('.menu').append(cloneMenu);
				});
			}
			
			stopSpinner();
			
			if(callBackFunc)
				callBackFunc();
        },
        error : function(request, status, error) {
        	stopSpinner();
        }
	});	
}

function initEventBind() {
	
	$("#homeLogo").on('click', function() {
    	if(sessionStorage.getItem('pathIdList')) {
    		
    		var pathIdList = sessionStorage.getItem('pathIdList').split(',');
    		
    		for(var i = 0; i < pathIdList.length; i++) {
    			
    			if('true' == $("#" + pathIdList[i]).attr('aria-expanded')) continue;
    			
    			$("#" + pathIdList[i]).trigger('click');
    		}
    		
    	}else{
    		$("#menu-home").trigger('click');
    	}
	});
	
	$("#menu-home, #gnb, #menu-bookmark").on('click', function(evt) {		
		
		if($(evt.target).hasClass('menu-bookmark')) {
			initMenuBookmarkEventBind.call(evt.target);
		} else {
			
			if(!$(evt.target).data('href')) return;
			
			if(('Y' == $(evt.target).data('window')) && ('Y' != localStorage.getItem('isNewOpenPopup'))) {
				
				var openUrl = null;
				
				if($(evt.target).data('href').startsWith('http') || $(evt.target).data('href').startsWith('https')){
					openUrl = $(evt.target).data('href');
				}else{
					openUrl = contextPath + $(evt.target).data('href');
					localStorage.setItem('isNewOpenPopup', 'Y');				
				}
				
				$(".menu-link").removeClass('active');
				$(evt.target).addClass('active');
				
				$(".breadcrumb").empty();
				
				sessionStorage.setItem('pathIdList', $(evt.target).data('pathIdList').join(','));
				
				var pathList = $(evt.target).data('pathList');
				
				pathList.forEach(function(path, index) {
					$(".breadcrumb").append($("<li/>").addClass('breadcrumb-item ' + ((index == pathList.length - 1)? 'active' : '')).text(path));
				});
				
				window.open(openUrl);
				
				if(0 == $("#ct").children().length) {
	 				$("#ct").html(
 						'<div class="empty">' +
 						'	<p><fmt:message>common.menu.opened.newtab</fmt:message></p>' +
 						'	<img src="<c:url value="/img/empty.svg" />" class="center-block" alt="">' +
 						'</div>'
	 				);
				}
				
			}else {				
				$(".menu-link").removeClass('active');
				$(evt.target).addClass('active');
				
				$(".breadcrumb").empty();
				
				sessionStorage.setItem('pathIdList', $(evt.target).data('pathIdList').join(','));
				
				var pathList = $(evt.target).data('pathList');
				
				pathList.forEach(function(path, index) {
					$(".breadcrumb").append($("<li/>").addClass('breadcrumb-item ' + ((index == pathList.length - 1)? 'active' : '')).text(path));
				});
				
				customResizeFunc = null;
				$(".daterangepicker").remove();
				$(".ui-datepicker").remove();
				$('#ct').parent().removeClass();
		    	$('body').removeClass();
		    	$(".backdrop").remove();
		    	$(".modal").not('#modal1, #modal2, #modal3, #modalSearch').remove();
		    	$(".modal-backdrop").remove();
		    	delete window['vmMain'];
				
				if($(evt.target).data('href').startsWith('http') || $(evt.target).data('href').startsWith('https')){
					document.location.href = (($(evt.target).data('href').startsWith('www'))? 'http://' : '') + $(evt.target).data('href');
				}else{
					startSpinner();

					var href = $(evt.target).data('href');

					var url = contextPath + href + ((-1 < href.indexOf('?'))? '&' : '?') + '_client_mode=b';
					
					$("#ct").load(url, function(response, status, xhr) {
				
						if(!isOnPopState) history.pushState({menuId: evt.target.id}, null, null);	
						
						isOnPopState = false;
						
						stopSpinner();
						
						localStorage.removeItem('isNewOpenPopup');
						
						if(401 === xhr.status) {
							sessionStorage.removeItem('pathIdList');
							location.href = "<c:url value='/common/auth/logout.html' />?_csrf=" + $("[name=_csrf]").val();				
						}		
					});
					
				}
			}			
		}
	});
	
	$("#userInfoBtn").on('click', function() {
		
		var createPageObj = getCreatePageObj();
		
		createPageObj.setViewName('editUserModal');
		createPageObj.setIsModal(true);
		
		createPageObj.openModal({
			url: '/common/user/edit.html',
			appendUrlObj: {
				userId: $("#userId").val()
			},
			modalTitle: '<fmt:message>common.user</fmt:message> <fmt:message>head.update</fmt:message>',
	        modalParam : {
	        	spinnerMode : spinnerOption
	        }
		});
	});
	
	$("#logoutBtn").on('click', function() {
		sessionStorage.removeItem('pathIdList');	
		$('#LogOutForm')[0].submit();
	});	
}

function initMenuBookmarkEventBind() {

	<%-- 
	if(bookmarkMaxCnt < $("#menu-bookmark").find('.menu').children('.menu-item').length + (($(this).hasClass('active'))? -1 : +1)) {
		warnAlert('<fmt:message key="head.maxCnt"><fmt:param value="' + bookmarkMaxCnt + '" /></fmt:message>');
		return false;
	}
	--%>
	
	startSpinner(spinnerOption);
	
	$.ajax({
		type : "POST",
		url: "<c:url value='/common/menuBookmark/object.json'/>",
		dataType : "json",
		data: {
			'pk.menuId': $(this).data('menuId'),
			'pk.userId': $("#userId").val(),
			'_method': ($(this).hasClass('active'))? 'DELETE' : 'PUT'
		},
		success : function(result) {
			
			if($(this).hasClass('active'))	{
				$("#" + $(this).data('menuId')).parent().find('.menu-bookmark').removeClass('active');
				$("#" + $(this).data('menuId') + '_bookmark').parent().find('.menu-bookmark').removeClass('active');
			}else{
				$("#" + $(this).data('menuId')).parent().find('.menu-bookmark').addClass('active');
				$("#" + $(this).data('menuId') + '_bookmark').parent().find('.menu-bookmark').addClass('active');
			}
			
			stopSpinner();
			
			setMenuBookmark(function() {
				if(!sessionStorage.getItem('pathIdList')) return;
				
        		var pathIdList = sessionStorage.getItem('pathIdList').split(',');
        		
        		if(0 < $('#' + pathIdList[pathIdList.length - 1]).length) return;
        			
        		sessionStorage.removeItem('pathIdList');        		
			});
			
        }.bind(this),
        error : function(request, status, error) {
        	stopSpinner();
        }
	});	
}

window.onpopstate = function(event) {
	if(!event.state || !event.state.menuId) return;
	
	isOnPopState = true;
	
	$('#sidebar').find('#' + event.state.menuId).trigger('click');
}
</script>