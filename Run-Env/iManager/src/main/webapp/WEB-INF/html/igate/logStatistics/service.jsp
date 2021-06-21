<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<form name="popForm" action="${pageContext.request.contextPath}/igate/logStatistics/generateExcelService.json" method="post">
	<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="fromDateTime" />
	<input type="hidden" name="toDateTime" />
	<input type="hidden" name="pk.statsType" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="pk.interfaceServiceId" />
</form>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<ul id="logStatisticsSummary" class="row media-dl" style="display: none;">
	<li class="col-6 col-xl-3">
		<div class="media align-items-center">
			<img src="<c:url value='/img/call.svg' />" class="media-icon" alt="">
			<dl class="media-body">
				<dt><fmt:message>head.request</fmt:message></dt>
				<dd class="h1">{{requestCount}}</dd>
			</dl>
		</div>
	</li>
	<li class="col-6 col-xl-3">
		<div class="media align-items-center">
			<img src="<c:url value='/img/complete.svg' />" class="media-icon" alt="">
			<dl class="media-body">
				<dt><fmt:message>head.normal</fmt:message></dt>
				<dd class="h1">{{successCount}}</dd>
			</dl>
		</div>
	</li>
	<li class="col-6 col-xl-3">
		<div class="media align-items-center">
			<img src="<c:url value='/img/warn.svg' />" class="media-icon" alt="">
			<dl class="media-body">
				<dt><fmt:message>head.exception</fmt:message></dt>
				<dd class="h1">{{exceptionCount}}</dd>
			</dl>
		</div>
	</li>
	<li class="col-6 col-xl-3">
		<div class="media align-items-center">
			<img src="<c:url value='/img/danger.svg' />" class="media-icon" alt="">
			<dl class="media-body">
				<dt><fmt:message>head.timeout</fmt:message></dt>
				<dd class="h1">{{timeoutCount}}</dd>
			</dl>
		</div>
	</li>
</ul>