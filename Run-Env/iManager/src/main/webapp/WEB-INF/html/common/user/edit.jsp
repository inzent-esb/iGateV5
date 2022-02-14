<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<form:form id="MainForm" commandName="user" action="<c:url value='/common/user/edit.json'/>" method="post" >
	<ul class="nav nav-tabs flex-shrink-0">
		<li class="nav-item"><a class="nav-link active" href="#baseInfo" data-toggle="tab"><fmt:message>head.basic.info</fmt:message></a></li>
		<li class="nav-item"><a class="nav-link" href="#crtfcInfo" data-toggle="tab"><fmt:message>common.user.authentication.info</fmt:message></a></li>
		<li class="nav-item"><a class="nav-link" href="#authorInfo" data-toggle="tab"><fmt:message>common.user</fmt:message> <fmt:message>common.user.privilege.info</fmt:message></a></li>
	</ul>
	<div class="modal-body tab-content py-4">
		<!-- 기본 정보 -->
		<div id="baseInfo" class="tab-pane active">
			<div class="row frm-row">
				<div class="col-lg-6">
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user</fmt:message> <fmt:message>head.id</fmt:message><b class="icon-star"></b></label>
						<input type="text" v-model="object.userId" class="form-control dataKey" disabled>

					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user</fmt:message> <fmt:message>head.name</fmt:message></label>
						<input type="text" v-model="object.userName" class="form-control" disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.department</fmt:message></label>
						<input type="text" v-model="object.department" class="form-control"  disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.telephone</fmt:message></label>
						<input type="text" v-model="object.telephone" class="form-control" disabled>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.mobilephone</fmt:message></label>
						<input type="text" v-model="object.mobilephone" class="form-control" disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.email</fmt:message></label>
						<input type="text" v-model="object.email" class="form-control"disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>head.update.timestamp</fmt:message></label>
						<spring:bind path="user.updateTimestamp">
			            	<input type="text" v-model="object.updateTimestamp" class="form-control readonlyField" disabled>
			            </spring:bind>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>head.update.userId</fmt:message></label>
						<input type="text" v-model="object.updateUserId" class="form-control readonlyField" disabled>
					</div>
				</div>
			</div>
		</div>
		<!-- 인증 정보 -->
		<div id="crtfcInfo" class="tab-pane">
			<div class="row frm-row">
				<div class="col-lg-6">
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.disable</fmt:message></label>
			             <select class="form-control readonlyField" disabled>
			               <option value="Y" <c:if test="${charY == user.userDisableYn}"> selected</c:if>>Yes</option>
			               <option value="N" <c:if test="${charY != user.userDisableYn}"> selected</c:if>>No</option>
			             </select>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.userExpiration</fmt:message></label>
			            <input type="text" v-model="object.userExpiration" id="userExpiration" class="form-control input-date readonlyField" disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.oldPassword</fmt:message></label>
						<input id="passwordOld" v-bind:type="passwordOldType" v-model="object.passwordOld" class="form-control" style="display: inline; width: calc(100% - 1.65rem)" disabled>
						<i class="icon-eye" style="font-size: 1.3rem;" v-on:click="changeType('passwordOld')"></i>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.newPassword</fmt:message></label>
						<input id="passwordNew" v-bind:type="passwordNewType" v-model="object.passwordNew" class="form-control"  style="display: inline; width: calc(100% - 1.65rem)" disabled>
						<i class="icon-eye" style="font-size: 1.3rem;" v-on:click="changeType('passwordNew')"></i>
					</div>				
				</div>
				<div class="col-lg-6">
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.passwordExpiration</fmt:message></label>
						<input type="text" v-model="object.passwordExpiration" id="passwordExpiration" class="form-control input-date readonlyField"  disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.loginIp</fmt:message></label>
						<input type="text" v-model="object.loginIp" class="form-control readonlyField" value="${user.loginIp}" disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.loginAttempts</fmt:message></label>
						<input type="number" v-model="object.loginAttempts" class="form-control readonlyField" value="${user.loginAttempts}" disabled>
					</div>
					<div class="form-group">
						<label class="control-label"><fmt:message>common.user.loginTimestamp</fmt:message></label>
						<spring:bind path="user.loginTimestamp">
							<input type="text" v-model="object.loginTimestamp" class="form-control readonlyField" value="${status.value}" disabled>
            			</spring:bind>
					</div>
				</div>
			</div>
		</div>
		<!-- 권한 정보 -->
		<div id="authorInfo" class="tab-pane">
			<table class="table">
				<colgroup>
					<col span="2" style="width: 1%">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col"></th>
						<th scope="col"><fmt:message>common.privilege</fmt:message> <fmt:message>head.type</fmt:message></th>
						<th scope="col"><fmt:message>common.privilege</fmt:message></th>
					</tr>
				</thead>
				<tbody>
			    	<tr v-for="elm in totalUserPrivileges">	   	
			    		<td>
			    			<select class="form-control view-disabled" v-model="elm.privilegeName" disabled>
			    				<option value=" "><fmt:message>common.user.privilege.none</fmt:message></option>
			    				<option value="Admin"><fmt:message>common.user.privilege.admin</fmt:message></option>
			    				<option value="Member"><fmt:message>common.user.privilege.member</fmt:message></option>
			    			</select>
						</td>
						<td class="px-1" v-if="elm.privilegeType===isSystem"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.privilege.type.system</fmt:message>></td>
						<td class="px-1" v-if="elm.privilegeType===isBusiness"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.privilege.type.business</fmt:message>></td>
						<td class="px-1" v-if="elm.privilegeType!==isSystem && elm.privilegeType!==isBusiness"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.role</fmt:message>></td>
					   	<td class="px-1"><input type="text" class="form-control readonlyField" v-model="elm.privilegeId" disabled="disabled"></td>
			         </div>
			    	</tr>
				</tbody>
			</table>
		</div>
	</div>
</form:form>

<security:authorize access="isAuthenticated()">
	<input type="hidden" id="accountId" value="<security:authentication property="principal.username" />">
</security:authorize>