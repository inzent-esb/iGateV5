<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

<form name="popForm" action="${pageContext.request.contextPath}/igate/exceptionLog/exportExcel.json" method="post">
	<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<div id="popFormInputs">
	</div>
</form>

<span id="exceptionStackCt" style="display: none;">
	<div class="col-lg-12" style="min-height: 270px;">
		<div class="form-group" style="height: 100%;">
			<label class="control-label"><span><fmt:message>igate.exceptionLog.exceptionStack</fmt:message></span></label>
			<div class="input-group" style="height: 100%;">
				<textarea class="form-control view-disabled" v-model="object.exceptionStack" style="height: 100%;"></textarea>
			</div>
		</div>
	</div>
</span>