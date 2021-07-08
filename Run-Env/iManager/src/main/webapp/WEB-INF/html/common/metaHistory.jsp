<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>


<span id="modifiedContentsCt" style="display: none;">
	<div class="col-lg-6" style="min-height: 300px;">
		<div class="form-group" style="height: 100%;">
			<label class="control-label"><span><fmt:message>common.metaHistory.before</fmt:message></span></label>
			<div class="input-group" style="height: 100%;">
				<textarea class="form-control view-disabled" v-model="object.beforeDataString" disabled="disabled" style="height: 100%;"></textarea>
			</div>
		</div>
	</div>
	<div class="col-lg-6" style="min-height: 300px;">
		<div class="form-group" style="height: 100%;">
			<label class="control-label"><span><fmt:message>common.metaHistory.after</fmt:message></span></label>
			<div class="input-group" style="height: 100%;">
				<textarea class="form-control view-disabled" v-model="object.afterDataString" disabled="disabled" style="height: 100%;"></textarea>
			</div>
		</div>
	</div>
</span>
