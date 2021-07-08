<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

<span id="messageInfoCt" style="display: none;">
	<div class="col-lg-12" style="min-height: 270px;">
		<div class="form-group" style="height: 100%;">
			<label class="control-label"><span><fmt:message>igate.traceLog.message.info</fmt:message></span></label>
			<div class="input-group" style="height: 100%;">
				<textarea class="form-control view-disabled dumparea" v-model="object" style="height: 100%;"></textarea>
			</div>
		</div>
	</div>
</span>

<div id="traceLog-panel" style="display : none;">
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.basic.info</fmt:message></h3>
		</header>
		<div class="row frm-row">
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.transactionId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.messageId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.logCode" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.instanceId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.externalTransaction</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.externalTransaction" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.externalMessage</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.externalMessage" disabled>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.adapter</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.adapterId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.connector</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.connectorId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.connectorControl.session</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.sessionId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.ip</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.remoteAddr" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.traceLog.requestTimestamp</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.requestTimestamp" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.traceLog.responseTimestamp</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.responseTimestamp" disabled>
				</div>
			</div>
		</div>
	</section>
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.extensionInfo</fmt:message></h3>
		</header>
		<div class="row frm-row">
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.interfaceId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.serviceId" disabled>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.traceLog.responseCode</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.responseCode" disabled>
				</div>
			</div>
		</div>
	</section>
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.errorInfo</fmt:message></h3>
		</header>
		<div class="row frm-row">
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.exception.code</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.exceptionCode" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.exception.message</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.exceptionMessage" disabled>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.timeoutYn</fmt:message></label>
					<input type="text" v-if="object.timeoutYn==='Y'" class="form-control view-disabled" value="<fmt:message>head.yes</fmt:message>" disabled> 
					<input type="text" v-else class="form-control view-disabled"  class="form-control view-disabled" value="<fmt:message>head.no</fmt:message>" disabled>
				</div>
			</div>
		</div>
	</section>
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.logInfo</fmt:message></h3>
		</header>
		<div class="row frm-row">
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.logId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>head.date</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.logDateTime" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.fileName" disabled>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.offset</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.fileOffset" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.size</fmt:message></label>
					<div class="input-group viewGroup">
						<input type="text" class="form-control view-disabled" v-model="object.bodySize">
						<div class="input-group-append">
							<button type="button" class="btn viewGroup" v-on:click="downloadFile">다운로드</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.modelInfo</fmt:message></h3>
		</header>
		<div class="table-responsive">
			<div id="basicInfoGrid"></div>
		</div>
	</section>
</div>