<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

<form name="popForm">
	<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>

<span id="fileResult" style="display: none;">
	<div class="col-lg-12">
		<div class="form-group" style="margin-bottom: 16px;">
			<label class="control-label"><span><fmt:message>head.file</fmt:message> <fmt:message>head.select</fmt:message></span></label>
			<div class="input-group">
				<input class="form-control view-disabled" type="text" v-model="fileName" readonly="readonly" placeholder="<fmt:message>igate.migration.fileSelectError</fmt:message>" />
				<button type="button" class="btn" v-on:click="selectFile" style="margin-left: 5px; margin-right: 5px;">
					<fmt:message>head.file</fmt:message>
					<fmt:message>head.select</fmt:message>
				</button>
				<button type="button" class="btn btn-primary" v-on:click="uploadFile">
					<fmt:message>head.upload</fmt:message>
				</button>
			</div>
		</div>
	</div>
	<div class="col-lg-12" v-show="errorMessage">
		<div class="form-group" style="margin-bottom: 16px;">
			<label class="control-label"><span><fmt:message>head.exception</fmt:message></span></label>
			<div class="input-group">
				<textarea class="form-control view-disabled" v-model="errorMessage" readonly="readonly" rows="10" readonly="readonly"></textarea>
			</div>
		</div>
	</div>
	<div class="col-lg-6" v-show="object.interfaces">
		<div class="form-group">
			<label class="control-label"><span><fmt:message>igate.migration.userId</fmt:message></span></label>
			<div class="input-group">
				<input type="text" class="form-control view-disabled" v-model="object.userId" disabled="disabled">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label"><span><fmt:message>igate.migration.name</fmt:message></span></label>
			<div class="input-group">
				<input type="text" class="form-control view-disabled" v-model="object.name" disabled="disabled">
			</div>
		</div>
	</div>
	<div class="col-lg-6" v-show="object.interfaces">
		<div class="form-group">
			<label class="control-label"><span><fmt:message>igate.migration.migrationDate</fmt:message></span></label>
			<div class="input-group">
				<input type="text" class="form-control view-disabled" v-model="object.migrationDate" disabled="disabled">
			</div>
		</div>
		<div class="form-group">
			<label class="control-label"><span><fmt:message>igate.migration.migrationTime</fmt:message></span></label>
			<div class="input-group">
				<input type="text" class="form-control view-disabled" v-model="object.migrationTime" disabled="disabled">
			</div>
		</div>
	</div>
	<div class="col-lg-12" v-show="object.interfaces">
		<div class="form-group" style="margin-bottom: 16px;">
			<table class="migration-table" width="100%">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<thead>
					<tr align="center" style="background-color: #f5f6fb;">
						<th><fmt:message>igate.interface</fmt:message></th>
						<th><fmt:message>igate.migration.includeList</fmt:message></th>
					</tr>
				</thead>
				<tr v-for="interface in object.interfaces">
					<td>{{interface.interface.interfaceId}}({{interface.interface.interfaceName}})</td>
					<td valign='top'>
						<table width="100%">
							<tr>
								<td width="20%"><fmt:message>igate.interface</fmt:message></td>
								<td>
									<table width="100%">
										<tr>
											<td>{{interface.interface.interfaceId}}({{interface.interface.interfaceName}})</td>
										<tr>
									</table>
								</td>
							</tr>
			
						  <tr v-if="interface.interface.requestRecordObject">
						  	<td width="30%"><fmt:message>igate.record</fmt:message></td>
						  	<td>
						  		<table width="100%">
							  		<tr>
								  		<td>{{interface.interface.requestRecordObject.recordId}}({{interface.interface.requestRecordObject.recordName}})</td>
							  		</tr>
			    					<tr v-for="interfaceResponse in interface.interface.interfaceResponses">
			    						<td>{{interfaceResponse.recordObject.recordId}}({{interfaceResponse.recordObject.recordName}})</td>
		    						</tr>
	    						</table>
   							</td>
						  </tr>
						  <tr v-for="interfaceService in interface.interface.interfaceServices">
						  	<td width="30%"><fmt:message>igate.mapping</fmt:message></td>
						  	<td>
						  		<table width="100%">
						  			<tr v-if="interfaceService.requestMappingObject">
						  				<td>{{interfaceService.requestMappingObject.mappingId}}({{interfaceService.requestMappingObject.mappingName}})</td>
					  				</tr>
					  				<tr v-if="interfaceService.responseMappingObject">
					  					<td>{{interfaceService.responseMappingObject.mappingId}}({{interfaceService.responseMappingObject.mappingName}})</td>
				  					</tr>
			  					</table>
		  					</td>
	  					 </tr>
	  					 							
						</table>
					</td>
				</tr>
			</table>
		</div>
	</div>
</span>