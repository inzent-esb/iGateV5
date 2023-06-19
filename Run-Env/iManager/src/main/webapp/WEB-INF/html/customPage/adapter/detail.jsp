<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- Cron Expression - 커스텀 모달 html --%>
<span id="cronExpression" style="display: none;">
	<span id="cronVue">
		<ul class="nav nav-tabs flex-shrink-0">
			<li v-for="(item, idx) in items" :key="item.id" class="nav-item">
				<a class="nav-link" :id="item.id" :class="{active : 0 === idx}" :href="'#'+item.id+'Div'" data-toggle="tab" @click="tabClick">
					{{ item.name }}
				</a>
			</li>
		</ul>
		<div class="panel-body tab-content" style="width:970px; height:220px;">			
			<!--  초 -->
			<div id="secondTab" class="tab-pane active">
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div class="cron-div-row-margin">
						<label class="custom-control custom-radio custom-control-inline">
				   			<input type="radio" name="second" value="1" v-model="secondCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   			</label>
					</div>
			   		<div class="cron-div-row-margin">
			   			<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="second" value="2" v-model="secondCheckValue" class="custom-control-input" >
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
			   			</label>
			   			<select class="form-control view-disabled cron-select" :disabled="secondCheckValue != 2" v-model="secondResult1" style="margin-left: -16px;">
							<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="secondCheckValue != 2" v-model="secondResult2">
					    	<option v-for="option in 60" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</div>
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="second" value="3" v-model="secondCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
				   		<select class="form-control view-disabled cron-select" :disabled="secondCheckValue != 3" v-model="secondResult3" style="margin-left: -16px;">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="secondCheckValue != 3" v-model="secondResult4">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message></span>
			   		</div>
			   		<div>
			   			<label class="custom-control custom-radio custom-control-inline custom-cron" style="display:block" >
				   			<input type="radio" name="second" value="4" v-model="secondCheckValue" class="custom-control-input">
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" style="width: 108% !important; margin-left: 4px;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="secondCheckValue != 4" v-model="secondResult5">
				   			</span>
				   		</label>
			   		</div>
		    	</div>
		    </div>
		    <!--  분 -->
		    <div id="minuteTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div class="cron-div-row-margin">
						<label class="custom-control custom-radio custom-control-inline">
				   			<input type="radio" name="minute" value="1" v-model="minuteCheckValue"  class="custom-control-input">
				   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
				   		</label>
					</div>
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="minute" value="2" v-model="minuteCheckValue" class="custom-control-input" >
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
			   			<select class="form-control view-disabled cron-select" :disabled="minuteCheckValue != 2" v-model="minuteResult1" style="margin-left: -16px;">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="minuteCheckValue != 2" v-model="minuteResult2">
					    	<option v-for="option in 60" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</div>
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="minute" value="3" v-model="minuteCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
						<select class="form-control view-disabled cron-select" :disabled="minuteCheckValue != 3" v-model="minuteResult3" style="margin-left: -16px;">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="minuteCheckValue != 3" v-model="minuteResult4">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message></span>	
			   		</div>
			   		<div>
			   			<label class="custom-control custom-radio custom-control-inline custom-cron" style="display: block;">
				   			<input type="radio" name="minute" value="4" v-model="minuteCheckValue" class="custom-control-input">
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" style="width: 108% !important; margin-left: 4px;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="minuteCheckValue != 4" v-model="minuteResult5">
				   			</span>
		   				</label>		   				
			   		</div>
		    	</div>
		    </div>
		    <!--  시 -->
		    <div id="hourTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div class="cron-div-row-margin">
						<label class="custom-control custom-radio custom-control-inline">
				   			<input type="radio" name="hour" value="1" v-model="hourCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
				   		</label>
					</div>					
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="hour" value="2" v-model="hourCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
			   			<select class="form-control view-disabled cron-select" :disabled="hourCheckValue != 2" v-model="hourResult1" style="margin-left: -16px;">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="hourCheckValue != 2" v-model="hourResult2">
					    	<option v-for="option in 24" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.hourDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</div>
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="hour" value="3" v-model="hourCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
						<select class="form-control view-disabled cron-select" :disabled="hourCheckValue != 3" v-model="hourResult3" style="margin-left: -16px;">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="hourCheckValue != 3" v-model="hourResult4">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message></span>		
			   		</div>
			   		<div>
			   			<label class="custom-control custom-radio custom-control-inline custom-cron" style="display: block;">
				   			<input type="radio" name="hour" value="4" v-model="hourCheckValue" class="custom-control-input">
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" style="width:108% !important; margin-left:4px;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="hourCheckValue != 4" v-model="hourResult5">
			   				</span>
				   		</label>
		   				
			   		</div>
		    	</div>
		    </div>
		    <!--  일 -->
		    <div id="dayTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div class="cron-day-margin-div-1">
						<label class="custom-control custom-radio custom-control-inline" >
				   			<input type="radio" name="day" value="1" v-model="dayCheckValue" class="custom-control-input">
				   			<span class="custom-control-label"><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.dayOfMonth</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
				   		</label>
					</div>
			   		<div class="cron-day-margin-div-2">
				   		<label class="custom-control custom-radio custom-control-inline">
				   			<input type="radio" name="day" value="2" v-model="dayCheckValue" class="custom-control-input">
				   			<span class="custom-control-label"><fmt:message>igate.job.noValue</fmt:message></span>
				   			
				   		</label>
			   		</div>
			   		<div >
			   			<label class="custom-control custom-radio custom-control-inline custom-cron" style="display: block;">
				   			<input type="radio" name="day" value="3" v-model="dayCheckValue" class="custom-control-input">
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled cron-input-margin"  placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="dayCheckValue != 3" v-model="dayResult1" style="text-transform:uppercase;">
			   				</span>				   				
			   			</label>
		   				
		   			</div>
		   		</div>
	   		</div>
		    <!--  월 -->
		    <div id="monthTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div  class="cron-div-row-margin">
						<label class="custom-control custom-radio custom-control-inline">
				   			<input type="radio" name="month" value="1" v-model="monthCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
				   		</label>
					</div>					
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio"  name="month" value="2" v-model="monthCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
			   			<select class="form-control view-disabled cron-select" :disabled="monthCheckValue != 2" v-model="monthResult1" style="margin-left: -16px;">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="monthCheckValue != 2" v-model="monthResult2">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.monthDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</div>
			   		<div class="cron-div-row-margin">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="month" value="3" v-model="monthCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;"></span>
				   		</label>
						<select class="form-control view-disabled cron-select" :disabled="monthCheckValue != 3" v-model="monthResult3" style="margin-left: -16px;">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message></span>
				    	<select class="form-control view-disabled cron-select" :disabled="monthCheckValue != 3" v-model="monthResult4">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<span class="cron-font"><fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message></span>
			   		</div>
			   		<div>
			   			<label class="custom-control custom-radio custom-control-inline custom-cron" style="display: block;">
				   			<input type="radio" name="month" value="4" v-model="monthCheckValue" class="custom-control-input" >
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" style="width:108% !important; margin-left:4px;" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.monthTooltip</fmt:message>" :disabled="monthCheckValue != 4" v-model="monthResult5">
			   				</span>				   				
			   			</label>
		   				
					</div>
		    	</div>
		    </div>
		    <!--  요일 -->
		    <div id="weekTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<div class="cron-div-row-margin">
						<label class="custom-control custom-radio custom-control-inline" style="margin-right: 0px;">
				   			<input type="radio" name="week" value="1" v-model="weekCheckValue" class="custom-control-input">
				   			<span class="custom-control-label"><fmt:message>igate.job.noValue</fmt:message></span>
				   		</label>
					</div>
					<div class="cron-week-margin-div">
				   		<label class="custom-control custom-radio custom-control-inline custom-cron-select">
				   			<input type="radio" name="week" value="2" v-model="weekCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="display: -webkit-box !important;">
				   		</label>
			   			<select class="form-control view-disabled cron-control-select" :disabled="weekCheckValue != 2" v-model="weekResult1">
					    	<option value="Sun"><fmt:message>igate.job.sunday</fmt:message></option>
					    	<option value="Mon"><fmt:message>igate.job.monday</fmt:message></option>
					    	<option value="Tue"><fmt:message>igate.job.tuesday</fmt:message></option>
					    	<option value="Wed"><fmt:message>igate.job.wednesday</fmt:message></option>
					    	<option value="Thu"><fmt:message>igate.job.thursday</fmt:message></option>
					    	<option value="Fri"><fmt:message>igate.job.friday</fmt:message></option>
					    	<option value="Sat"><fmt:message>igate.job.saturday</fmt:message></option>
				    	</select>
			   		</div>
			   		<div >
				   		<label class="custom-control custom-radio custom-control-inline custom-cron" style="display: block;">
				   			<input type="radio" name="week" value="3" v-model="weekCheckValue" class="custom-control-input">
				   			<span class="custom-control-label">
				   				<input type="text" class="form-control view-disabled cron-input-margin" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.weekTooltip</fmt:message>" :disabled="weekCheckValue != 3" v-model="weekResult2">
			   				</span>				   				
						</label>		   				
				   	</div>
		   		</div>
	   		</div>
		</div>
	    <div id="gridDiv" style="overflow: hidden; height: 80px; "></div>
    </span>
</span>

<style>
.cron-font {
	margin: auto 3px;
	font-size: .778rem;
}
.cron-div-row-margin {
	margin-bottom: 16px;
}
.cron-pointer {
	pointer-events: none;
}
.cron-select {
	display: inline-block !important;
	width: 0 !important;
}
.custom-radio.custom-cron .custom-control-label::before,
.custom-radio.custom-cron .custom-control-label::after {
	top: 9px;
}
.cron-control-select {
	margin-left: -16px; 
	width: 185px !important;
	display: inline-block !important;
}
.cron-day-margin-div-1 {
	margin-bottom: 19px;
}
.cron-day-margin-div-2 {
	margin-bottom: 21px;
}
.cron-input-margin {
	width:108% !important;
	margin-left:4px;
	margin-top: 3px;
}
.cron-week-margin-div {
	margin-bottom: 13px;
}

@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
 /* Enter your style code */
	.custom-radio.custom-cron-select .custom-control-label::before,
	.custom-radio.custom-cron-select .custom-control-label::after {
		top: -13px !important;
	}
	
	.cron-control-select {
		margin-left: -16px; 
		width: 171px !important;
		display: inline-block !important;
	}
	
	.cron-day-margin-div-1 {
		margin-bottom: 24px;
	}
	.cron-day-margin-div-2 {
		margin-bottom: 22px;
	}
	.cron-input-margin {
		width:108% !important;
		margin-left:3px;
		margin-top: 1px;
	}
	.cron-week-margin-div {
		margin-bottom: 15px;
	}
}
</style>