<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="messageInfoCt" style="display: none;">
	<div class="col-lg-12" style="min-height: 270px;">
		<div class="form-group" style="height: 100%;">
			<label class="control-label">
				<span>
					<fmt:message>igate.traceLog.message.info</fmt:message>
				</span>
				<div style="position: absolute; top:-3px; right: 12px;" >
					<a id="downloadBtn" title="<fmt:message>head.download</fmt:message>" class="btn btn-m" style="padding-top: 0.1rem; padding-bottom: 0.1rem;" v-on:click="downloadFile">
						<i class="icon-export"></i>
						<span class="hide"><fmt:message>head.download</fmt:message></span>
					</a>
					<a title="<fmt:message>igate.traceLog.create.testCase</fmt:message>" class="btn btn-m" style="padding-top: 0.1rem; padding-bottom: 0.1rem;" v-on:click="createTestCase" v-if="'INI' === logCode">
						<i class="icon-play"></i>
						<span class="hide"><fmt:message>igate.traceLog.create.testCase</fmt:message></span>
					</a>					
				</div>
			</label>
			<div class="input-group" style="height: 100%;">
				<textarea class="form-control view-disabled dumparea" v-model="object" style="height: 100%;"></textarea>
			</div>
		</div>
	</div>
</span>

<span id="createTestCaseTemplate" style="display: none;">
	<div>
		<div class="form-group">
			<label class="control-label">
				<fmt:message>igate.interface.id</fmt:message>
			</label> 
			<input type="text" v-model="object.pk.interfaceId" class="form-control view-disabled" readonly="readonly">
		</div> 	
		<div class="form-group">
			<label class="control-label">
				<fmt:message>igate.traceLog.testCase.id</fmt:message>
				<span class="letterLength" v-text="'(' + letter.pk.testCaseId + ' / ' + testCaseIdRegExp.maxLength + ')'"></span>
				<b class="icon-star"></b>
			</label> 
			<input type="text" v-model="object.pk.testCaseId" placeholder="<fmt:message>igate.traceLog.enter.testCase</fmt:message>" :maxLength="testCaseIdRegExp.maxLength" v-on:input="inputEvt({regExp: testCaseIdRegExp.regExp, key: 'object.pk.testCaseId'})" class="form-control">
		</div> 
		<div class="form-group">
			<label class="control-label">
				<fmt:message>igate.instance.id</fmt:message>
				<b class="icon-star"></b>
			</label> 
			<select class="form-control"  v-model="object.testInstance">
				<option v-for="(instanceInfo, idx) in instanceList" v-bind:value="instanceInfo.instanceId" v-text="instanceInfo.instanceId"></option>
			</select>
		</div>
		<div class="form-group">
			<label class="control-label">
				<fmt:message>head.group</fmt:message> <fmt:message>head.name</fmt:message>
			</label> 
			<input type="text" v-model="object.testCaseGroup" class="form-control view-disabled" readonly="readonly">
		</div>		
		<div class="form-group">
			<label class="control-label">
				<fmt:message>head.description</fmt:message> 
				<span class="letterLength" v-text="'(' + letter.testCaseDesc + ' / ' + testCaseDescRegExp.maxLength + ')'"></span>
			</label> 
			<textarea v-model="object.testCaseDesc" placeholder="<fmt:message>head.enter.comment</fmt:message>" class="form-control" :maxLength="testCaseDescRegExp.maxLength" v-on:input="inputEvt({regExp: testCaseDescRegExp.regExp, key: 'object.testCaseDesc'})" style="height: 100px;"></textarea>
		</div>
	</div>	
</span>

<div id="traceLog-panel" style="display : none;">
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>head.basic.info</fmt:message></h3>
		</header>
		<div class="row frm-row">
			<div class="col-lg-6" style="cursor : pointer;">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message></label>
					<div :class="{ 'input-group': object.exceptionCode? true : false }">
						<input id="transactionId" type="text" class="form-control view-disabled" v-model="object.transactionId" disabled>
						<button class="btn btn-icon search-linkBtn" title=<fmt:message>head.open</fmt:message> @click="clickEvt('transactionId')" v-if="object.exceptionCode">
							<i class="icon-link"></i>
						</button>
					</div>
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
					<label class="control-label"><fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message></label>
					<span @click="clickEvt('adapterId')" style="cursor: pointer;">
						<input type="text" class="form-control view-disabled" v-model="object.adapterId" style="text-decoration: underline; color: #007bff"  disabled>
					</span>					
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message></label>
					<span @click="clickEvt('connectorId')" style="cursor: pointer;">
						<input type="text" class="form-control view-disabled" v-model="object.connectorId" style="text-decoration: underline; color: #007bff"  disabled>
					</span>
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
					<span @click="clickEvt('interfaceId')" style="cursor: pointer;">
						<input type="text" class="form-control view-disabled" v-model="object.interfaceId" style="text-decoration: underline; color: #007bff" disabled>
					</span>						
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message></label>
					<span @click="clickEvt('serviceId')" style="cursor: pointer;">
						<input type="text" class="form-control view-disabled" v-model="object.serviceId" style="text-decoration: underline; color: #007bff" disabled>
					</span>
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
		<div class="row frm-row" style="margin-bottom: 0">
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.exception.code</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.exceptionCode" disabled>
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
		<div class="row frm-row">
			<div class="col-lg-12">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.exception.message</fmt:message></label>
					<textarea class="form-control view-disabled" v-model="object.exceptionMessage" disabled style="height: 45px;"></textarea>
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
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>head.date</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.pk.logDateTime" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>head.id</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.logId" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.log</fmt:message> <fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message></label>
					<div class="input-group viewGroup">
						<input type="text" class="form-control view-disabled" v-model="object.logInstanceId" disabled>
					</div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.fileName" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.offset</fmt:message></label>
					<input type="text" class="form-control view-disabled" v-model="object.fileOffset" disabled>
				</div>
				<div class="form-group">
					<label class="control-label"><fmt:message>head.file</fmt:message> <fmt:message>head.size</fmt:message></label>
					<div class="input-group viewGroup">
						<input type="text" class="form-control view-disabled" v-model="object.bodySize" disabled>
					</div>
				</div>
			</div>
		</div>
	</section>
	<section class="tab-section">
		<header class="sub-bar">
			<h3 class="sub-bar-text"><fmt:message>igate.traceLog.relatedLog</fmt:message></h3>
		</header>
		<div class="table-responsive">
			<div id="basicInfoGrid"></div>
		</div>
	</section>
</div>