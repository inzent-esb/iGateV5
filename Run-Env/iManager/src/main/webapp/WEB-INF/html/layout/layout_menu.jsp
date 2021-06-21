<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/head_vue.jsp"%>
	<%@ include file="/WEB-INF/html/common/portal/menu_js.jsp"%>
</head>
<body>
<div id="wrap">		
	<%@ include file="/WEB-INF/html/common/portal/menu.jsp"%>

	<div id="ct"></div>
</div>

<%@ include file="/WEB-INF/html/layout/modal/footer_modal.jsp"%>

<form id="LogOutForm" method="post" action="<c:url value='/common/auth/logout.html' />" onsubmit="return false;">
	<sec:csrfInput />
</form>

</body>
</html>