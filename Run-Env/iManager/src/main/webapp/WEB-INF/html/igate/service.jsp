<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 
 form 수정
 -->

<form name="popForm" action="${pageContext.request.contextPath}/igate/service/exportExcel.json" method="post">
	<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="serviceId" />
	<input type="hidden" name="serviceName" />
	<input type="hidden" name="adapterId" />
	<input type="hidden" name="serviceGroup" />
</form>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<c:if test="${'Popup' != viewMode}">
	<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
</c:if>