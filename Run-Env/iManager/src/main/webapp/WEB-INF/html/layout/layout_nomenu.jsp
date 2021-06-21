<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<html>
<head>
<%@ include file="/WEB-INF/html/layout/header/head_vue.jsp"%>
<header id="hd">
	<div class="hd-brand">
		<h1 class="logo text-hide">
			<img src="<c:url value='/img/logo.svg' />" alt="INZENT">INZENT
		</h1>
	</div>
	<ul class="breadcrumb">
		<li class="breadcrumb-item"></li>
		<li class="breadcrumb-item"></li>
		<li class="breadcrumb-item active"></li>
	</ul>
	<div class="hd-side">

		<!-- <a href="" title="수신함"><i class="icon-alarm active"></i></a> -->
		<a href="javascript:void(0);" id="userInfoBtn" title="<fmt:message>head.mypage</fmt:message>"><i class="icon-profile"></i></a>
		<%-- <a href="javascript:void(0);" id="logoutBtn" title="<fmt:message>common.auth.logout</fmt:message>"><img src="<c:url value='/img/logout.svg' />"></a> --%>

	</div>
</header>
</head>
<body>
	<div id="wrap">
		<div id="ct">
			<tiles:insertAttribute name="content_js" />
			<tiles:insertAttribute name="content" />
		</div>
	</div>
	<%@ include file="/WEB-INF/html/layout/modal/footer_modal.jsp"%>
</body>

<script type="text/javascript">
  $(document).ready(function()
  {
    initMenu() ;
  }) ;

  $("#userInfoBtn").on('click', function()
  {
    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('editUserModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.openModal({
      url : '/common/user/edit.html',
      appendUrlObj : {
        userId : $("#userId").val()
      },
      modalTitle : '<fmt:message>common.user</fmt:message> <fmt:message>head.update</fmt:message>',
    }) ;
  }) ;

  function initMenu()
  {

    startSpinner() ;

    $.ajax({
      type : "GET",
      url : "<c:url value='/common/portal/menu.json' />",
      processData : true,
      data : null,
      dataType : "json",
      success : function(res)
      {

        if ("ok" !== res.result)
        {
          stopSpinner();
          return ;
        }

        for (var i = 0 ; i < res.object.subMenus.length ; i++)
        {
          var test = menuList(res.object.subMenus[i]) ;
          if (test)
          {
            stopSpinner();
            return ;
          }
        }
        stopSpinner();
      },
      error : function(request, status, error)
      {
        stopSpinner();
      }
    }) ;

    function menuList(menu)
    {

      for (var i = 0 ; i < menu.subMenus.length ; i++)
      {
        // Test menu remove
        if ('104000' === menu.subMenus[i].menuId)
          continue ;

        for (var j = 0 ; j < menu.subMenus[i].subMenus.length ; j++)
        {

          var menuAction = (menu.subMenus[i].subMenus[j].menuUrl) ? menu.subMenus[i].subMenus[j].menuUrl : (menu.subMenus[i].subMenus[j].menuEditor) ? menu.subMenus[i].subMenus[j].menuEditor : '' ;

          if (-1 === menuAction.indexOf('html'))
            continue ;

          if (window.location.pathname === ('${pageContext.request.contextPath}' + menuAction))
          {

            $('.breadcrumb').children().eq(0).text(menu.menuName) ;
            $('.breadcrumb').children().eq(1).text(menu.subMenus[i].menuName) ;
            $('.breadcrumb').children().eq(2).text(menu.subMenus[i].subMenus[j].menuName) ;

            return true ;
          }

        }
      }
    }
  }
</script>

</html>
