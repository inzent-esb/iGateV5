<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>

<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

<!-- Cron Expression - 커스텀 모달 html -->
<span id="cronExpression" style="display: none;">
	<span id="cronVue">
		<ul class="nav nav-tabs flex-shrink-0">
			<li v-for="(item, idx) in items" :key="item.id" class="nav-item">
				<a class="nav-link" :id="item.id" :class="{active : 0 === idx}" :href="'#'+item.id+'Div'" data-toggle="tab" @click="tabClick">
					{{ item.name }}
				</a>
			</li>
		</ul>
		<div class="panel-body tab-content" style="width:970px; height:202px;">			
			<!--  초 -->
			<div id="secondTab" class="tab-pane active">
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="second-radio-1" name="second" value="1" v-model="secondCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
			   			<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
				   			<input type="radio" id="second-radio-2" name="second" value="2" v-model="secondCheckValue" class="custom-control-input" >
				   			<span id="radio-second-span1" class="custom-control-label">
					   			<select id="radio-second-select1" class="form-control-cron view-disabled" :disabled="secondCheckValue != 2" v-model="secondResult1">
									<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
						    	<select id="radio-second-select2" class="form-control-cron view-disabled" :disabled="secondCheckValue != 2" v-model="secondResult2">
							    	<option v-for="option in 60" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
				   			</span>
			   			</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
			   			<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
			   				<input type="radio" id="second-radio-2" name="second" value="2" v-model="secondCheckValue" class="custom-control-input">
			   				<span id="radio-second-span1" class="custom-control-label">
			   			</label>
			   			<select id="radio-second-select1" class="form-control-cron view-disabled" :disabled="secondCheckValue != 2" v-model="secondResult1">
				    		<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
				    	<select id="radio-second-select2" class="form-control-cron view-disabled" :disabled="secondCheckValue != 2" v-model="secondResult2">
					    	<option v-for="option in 60" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="margin-bottom: 8px;">
				   			<input type="radio" id="second-radio-3" name="second" value="3" v-model="secondCheckValue" class="custom-control-input">
				   			<span id="radio-second-span2" class="custom-control-label">
								<select id="radio-second-select3" class="form-control-cron view-disabled" :disabled="secondCheckValue != 3" v-model="secondResult3">
							    	<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
						    	<select id="radio-second-select4" class="form-control-cron view-disabled" :disabled="secondCheckValue != 3" v-model="secondResult4">
							    	<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
							</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
				   			<input type="radio" id="second-radio-3" name="second" value="3" v-model="secondCheckValue" class="custom-control-input">
				   			<span id="radio-second-span2" class="custom-control-label">
				   		</label>
						<select id="radio-second-select3" class="form-control-cron view-disabled" :disabled="secondCheckValue != 3" v-model="secondResult3">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
				    	<select id="radio-second-select4" class="form-control-cron view-disabled" :disabled="secondCheckValue != 3" v-model="secondResult4">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.second</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
			   			<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block" >
				   			<input type="radio" id="second-radio-4" name="second" value="4" v-model="secondCheckValue" class="custom-control-input">
				   			<span id="radio-second-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="secondCheckValue != 4" v-model="secondResult5">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display: inline-block;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display: inline-block;" >
				   			<input type="radio" id="second-radio-4" name="second" value="4" v-model="secondCheckValue" class="custom-control-input">
				   			<span id="radio-second-span3" class="custom-control-label" style="top:13px;">
			   			</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width: 40%; margin-left: -1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="secondCheckValue != 4" v-model="secondResult5">
		   			</div>
		    	</div>
		    </div>
		    <!--  분 -->
		    <div id="minuteTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="minute-radio-1" value="1" v-model="minuteCheckValue" name="minute" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
				   			<input type="radio" id="minute-radio-2" name="minute" value="2" v-model="minuteCheckValue" class="custom-control-input" >
				   			<span id="radio-minute-span1" class="custom-control-label">
					   			<select id="radio-minute-select1" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 2" v-model="minuteResult1">
							    	<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
						    	<select id="radio-minute-select2" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 2" v-model="minuteResult2">
							    	<option v-for="option in 60" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select"  style="margin-right:-0.25rem;">
				   			<input type="radio" id="minute-radio-2" name="minute" value="2" v-model="minuteCheckValue" class="custom-control-input" >
				   			<span id="radio-minute-span1" class="custom-control-label">
				   		</label>
			   			<select id="radio-minute-select1" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 2" v-model="minuteResult1">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
				    	<select id="radio-minute-select2" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 2" v-model="minuteResult2">
					    	<option v-for="option in 60" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="margin-bottom: 8px;">
				   			<input type="radio" id="minute-radio-3" name="minute" value="3" v-model="minuteCheckValue" class="custom-control-input" >
				   			<span id="radio-minute-span2" class="custom-control-label">
								<select id="radio-minute-select3" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 3" v-model="minuteResult3">
							    	<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
						    	<select id="radio-minute-select4" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 3" v-model="minuteResult4">
							    	<option v-for="option in 60" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>	
				    		</span>
				    	</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
				   			<input type="radio" id="minute-radio-3" name="minute" value="3" v-model="minuteCheckValue" class="custom-control-input" >
				   			<span id="radio-minute-span2" class="custom-control-label">
				   		</label>
						<select id="radio-minute-select3" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 3" v-model="minuteResult3">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
				    	<select id="radio-minute-select4" class="form-control-cron view-disabled" :disabled="minuteCheckValue != 3" v-model="minuteResult4">
					    	<option v-for="option in 60" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.minute</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>	
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block" >
				   			<input type="radio" id="minute-radio-4" name="minute" value="4" v-model="minuteCheckValue" class="custom-control-input">
				   			<span id="radio-minute-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="minuteCheckValue != 4" v-model="minuteResult5">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display: inline-block;">
			   			<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display: inline-block;">
				   			<input type="radio" id="minute-radio-4" name="minute" value="4" v-model="minuteCheckValue" class="custom-control-input">
				   			<span id="radio-minute-span3" class="custom-control-label" style="top:13px;">
		   				</label>
		   				<input type="text" class="form-control view-disabled" style="display: inline-block; width: 40%; margin-left: -1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="minuteCheckValue != 4" v-model="minuteResult5">
			   		</div>
		    	</div>
		    </div>
		    <!--  시 -->
		    <div id="hourTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="hour-radio-1" name="hour" value="1" v-model="hourCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
				   			<input type="radio" id="hour-radio-2" name="hour" value="2" v-model="hourCheckValue" class="custom-control-input">
				   			<span id="radio-hour-span1" class="custom-control-label">
					   			<select id="radio-hour-select1" class="form-control-cron view-disabled" :disabled="hourCheckValue != 2" v-model="hourResult1">
							    	<option v-for="option in 24" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
						    	<select id="radio-hour-select2" class="form-control-cron view-disabled" :disabled="hourCheckValue != 2" v-model="hourResult2">
							    	<option v-for="option in 24" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.hourDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select"  style="margin-right:-0.25rem;">
				   			<input type="radio" id="hour-radio-2" name="hour" value="2" v-model="hourCheckValue" class="custom-control-input">
				   			<span id="radio-hour-span1" class="custom-control-label">
				   		</label>
			   			<select id="radio-hour-select1" class="form-control-cron view-disabled" :disabled="hourCheckValue != 2" v-model="hourResult1">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
				    	<select id="radio-hour-select2" class="form-control-cron view-disabled" :disabled="hourCheckValue != 2" v-model="hourResult2">
					    	<option v-for="option in 24" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.hourDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="margin-bottom: 8px;">
				   			<input type="radio" id="hour-radio-3" name="hour" value="3" v-model="hourCheckValue" class="custom-control-input">
				   			<span id="radio-hour-span2" class="custom-control-label">
								<select id="radio-hour-select3" class="form-control-cron view-disabled" :disabled="hourCheckValue != 3" v-model="hourResult3">
							    	<option v-for="option in 24" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
						    	<select id="radio-hour-select4" class="form-control-cron view-disabled" :disabled="hourCheckValue != 3" v-model="hourResult4">
							    	<option v-for="option in 24" v-text="option-1"></option>
						    	</select>
						    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
							</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
				   			<input type="radio" id="hour-radio-3" name="hour" value="3" v-model="hourCheckValue" class="custom-control-input">
				   			<span id="radio-hour-span2" class="custom-control-label">
				   		</label>
						<select id="radio-hour-select3" class="form-control-cron view-disabled" :disabled="hourCheckValue != 3" v-model="hourResult3">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
				    	<select id="radio-hour-select4" class="form-control-cron view-disabled" :disabled="hourCheckValue != 3" v-model="hourResult4">
					    	<option v-for="option in 24" v-text="option-1"></option>
				    	</select>
				    	<fmt:message>igate.job.hour</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>		
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block" >
				   			<input type="radio" id="hour-radio-4" name="hour" value="4" v-model="hourCheckValue" class="custom-control-input" >
				   			<span id="radio-hour-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="hourCheckValue != 4" v-model="hourResult5">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display: inline-block;">
			   			<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display: inline-block">
				   			<input type="radio" id="hour-radio-4" name="hour" value="4" v-model="hourCheckValue" class="custom-control-input">
				   			<span id="radio-hour-span3" class="custom-control-label" style="top:13px;">
				   		</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width:40%; margin-left:-1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="hourCheckValue != 4" v-model="hourResult5">
			   		</div>
		    	</div>
		    </div>
		    <!--  일 -->
		    <div id="dayTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 24px;">
			   			<input type="radio" id="day-radio-1" name="day" value="1" v-model="dayCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.dayOfMonth</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline" style="display:block; margin-bottom: 16px;">
				   			<input type="radio" id="day-radio-2" name="day" value="2" v-model="dayCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" style="top:1px;"><fmt:message>igate.job.noValue</fmt:message>
				   		</label>
			   		</div>
			   		<div v-else>
				   		<label class="custom-control custom-radio custom-control-inline" style="display:block; margin-bottom: 21px;">
				   			<input type="radio" id="day-radio-2" name="day" value="2" v-model="dayCheckValue" class="custom-control-input">
				   			<span class="custom-control-label" ><fmt:message>igate.job.noValue</fmt:message>
				   		</label>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block">
				   			<input type="radio" id="day-radio-3" name="day" value="3" v-model="dayCheckValue" class="custom-control-input">
				   			<span id="radio-day-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="dayCheckValue != 3" v-model="dayResult1" style="text-transform:uppercase;">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display: inline-block;">
			   			<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display: inline-block;">
				   			<input type="radio" id="day-radio-3" name="day" value="3" v-model="dayCheckValue" class="custom-control-input">
				   			<span id="radio-day-span3" class="custom-control-label" style="top:12px;">
			   			</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width:40%; margin-left:-1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" :disabled="dayCheckValue != 3" v-model="dayResult1" style="text-transform:uppercase;">
		   			</div>
		   		</div>
	   		</div>
		    <!--  월 -->
		    <div id="monthTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="month-radio-1" name="month" value="1" v-model="monthCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
				   			<input type="radio"  id="month-radio-2" name="month" value="2" v-model="monthCheckValue" class="custom-control-input">
				   			<span id="radio-month-span1" class="custom-control-label">
					   			<select id="radio-month-select1" class="form-control-cron view-disabled" :disabled="monthCheckValue != 2" v-model="monthResult1">
							    	<option v-for="option in 12" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
						    	<select id="radio-month-select2" class="form-control-cron view-disabled" :disabled="monthCheckValue != 2" v-model="monthResult2">
							    	<option v-for="option in 12" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.monthDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select"  style="margin-right:-0.25rem;">
				   			<input type="radio"  id="month-radio-2" name="month" value="2" v-model="monthCheckValue" class="custom-control-input">
				   			<span id="radio-month-span1" class="custom-control-label">
				   		</label>
			   			<select id="radio-month-select1" class="form-control-cron view-disabled" :disabled="monthCheckValue != 2" v-model="monthResult1">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
				    	<select id="radio-month-select2" class="form-control-cron view-disabled" :disabled="monthCheckValue != 2" v-model="monthResult2">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.monthDesc</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="margin-bottom: 8px;">
				   			<input type="radio" id="month-radio-3" name="month" value="3" v-model="monthCheckValue" class="custom-control-input">
				   			<span id="radio-month-span2" class="custom-control-label">
								<select id="radio-month-select3" class="form-control-cron view-disabled" :disabled="monthCheckValue != 3" v-model="monthResult3">
							    	<option v-for="option in 12" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
						    	<select id="radio-month-select4" class="form-control-cron view-disabled" :disabled="monthCheckValue != 3" v-model="monthResult4">
							    	<option v-for="option in 12" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
							</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
				   			<input type="radio" id="month-radio-3" name="month" value="3" v-model="monthCheckValue" class="custom-control-input">
				   			<span id="radio-month-span2" class="custom-control-label">
				   		</label>
						<select id="radio-month-select3" class="form-control-cron view-disabled" :disabled="monthCheckValue != 3" v-model="monthResult3">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
				    	<select id="radio-month-select4" class="form-control-cron view-disabled" :disabled="monthCheckValue != 3" v-model="monthResult4">
					    	<option v-for="option in 12" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.month</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block">
				   			<input type="radio" id="month-radio-4" name="month" value="4" v-model="monthCheckValue" class="custom-control-input">
				   			<span id="radio-month-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.monthTooltip</fmt:message>" :disabled="monthCheckValue != 4" v-model="monthResult5">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display: inline-block;">
			   			<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display: inline-block;" >
				   			<input type="radio" id="month-radio-4" name="month" value="4" v-model="monthCheckValue" class="custom-control-input" >
				   			<span id="radio-month-span3" class="custom-control-label" style="top:13px;">
			   			</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width:40%; margin-left:-1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.monthTooltip</fmt:message>" :disabled="monthCheckValue != 4" v-model="monthResult5">
					</div>
		    	</div>
		    </div>
		    <!--  요일 -->
		    <div id="weekTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="week-radio-1" name="week" value="1" v-model="weekCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.noValue</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
				   			<input type="radio" id="week-radio-2" name="week" value="2" v-model="weekCheckValue" class="custom-control-input">
				   			<span id="radio-week-span1" class="custom-control-label">
					   			<select id="radio-week-select1" class="form-control-cron view-disabled" :disabled="weekCheckValue != 2" v-model="weekResult1">
							    	<option value="Sun"><fmt:message>igate.job.sunday</fmt:message></option>
							    	<option value="Mon"><fmt:message>igate.job.monday</fmt:message></option>
							    	<option value="Tue"><fmt:message>igate.job.tuesday</fmt:message></option>
							    	<option value="Wed"><fmt:message>igate.job.wednesday</fmt:message></option>
							    	<option value="Thu"><fmt:message>igate.job.thursday</fmt:message></option>
							    	<option value="Fri"><fmt:message>igate.job.friday</fmt:message></option>
							    	<option value="Sat"><fmt:message>igate.job.saturday</fmt:message></option>
						    	</select>
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select"  style="margin-right:-0.25rem;">
				   			<input type="radio" id="week-radio-2" name="week" value="2" v-model="weekCheckValue" class="custom-control-input">
				   			<span id="radio-week-span1" class="custom-control-label">
				   		</label>
			   			<select id="radio-week-select1" class="form-control-cron view-disabled" :disabled="weekCheckValue != 2" v-model="weekResult1">
					    	<option value="Sun"><fmt:message>igate.job.sunday</fmt:message></option>
					    	<option value="Mon"><fmt:message>igate.job.monday</fmt:message></option>
					    	<option value="Tue"><fmt:message>igate.job.tuesday</fmt:message></option>
					    	<option value="Wed"><fmt:message>igate.job.wednesday</fmt:message></option>
					    	<option value="Thu"><fmt:message>igate.job.thursday</fmt:message></option>
					    	<option value="Fri"><fmt:message>igate.job.friday</fmt:message></option>
					    	<option value="Sat"><fmt:message>igate.job.saturday</fmt:message></option>
				    	</select>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:block">
				   			<input type="radio" id="week-radio-3" name="week" value="3" v-model="weekCheckValue" class="custom-control-input">
				   			<span id="radio-week-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.weekTooltip</fmt:message>" :disabled="weekCheckValue != 3" v-model="weekResult2">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display:inline-block;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display:inline-block;">
				   			<input type="radio" id="week-radio-3" name="week" value="3" v-model="weekCheckValue" class="custom-control-input">
				   			<span id="radio-week-span3" class="custom-control-label" style="top:12px;">
						</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width:40%; margin-left:-1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.weekTooltip</fmt:message>" :disabled="weekCheckValue != 3" v-model="weekResult2">
				   	</div>
		   		</div>
	   		</div>
		    <!--  년도 -->
		    <div id="yearTab" class="tab-pane" >
				<div class="form-group" style="display:inline-grid; margin-left: 11px;">
					<label class="custom-control custom-radio custom-control-inline" style="margin-bottom: 16px;">
			   			<input type="radio" id="year-radio-1" name="year" value="1" v-model="yearCheckValue" class="custom-control-input">
			   			<span class="custom-control-label" ><fmt:message>igate.job.every</fmt:message> <fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message></span>
			   		</label>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select"  style="margin-bottom: 8px;">
			   				<input type="radio" id="year-radio-2" name="year" value="2" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span1" class="custom-control-label">
					   			<select id="radio-year-select1" class="form-control-cron view-disabled" :disabled="yearCheckValue != 2" v-model="yearResult1">
							    	<option v-for="option in 2099" v-if="option > 2020" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
						    	<select id="radio-year-select2" class="form-control-cron view-disabled" :disabled="yearCheckValue != 2" v-model="yearResult2">
							    	<option v-for="option in 10" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select"  style="margin-right:-0.25rem;">
			   				<input type="radio" id="year-radio-2" name="year" value="2" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span1" class="custom-control-label">
				   		</label>
			   			<select id="radio-year-select1" class="form-control-cron view-disabled" :disabled="yearCheckValue != 2" v-model="yearResult1">
					    	<option v-for="option in 2099" v-if="option > 2020" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.fromEvery</fmt:message>
				    	<select id="radio-year-select2" class="form-control-cron view-disabled" :disabled="yearCheckValue != 2" v-model="yearResult2">
					    	<option v-for="option in 10" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.fromEveryTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="margin-bottom: 6px;">
				   			<input type="radio" id="year-radio-3" name="year" value="3" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span2" class="custom-control-label">
								<select id="radio-year-select3" class="form-control-cron view-disabled" :disabled="yearCheckValue != 3" v-model="yearResult3">
							    	<option v-for="option in 2098" v-if="option > 2020" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
						    	<select id="radio-year-select4" class="form-control-cron view-disabled" :disabled="yearCheckValue != 3" v-model="yearResult4">
							    	<option v-for="option in 2099" v-if="option > yearResult3 && option > 2021" v-text="option"></option>
						    	</select>
						    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
							</span>
				   		</label>
			   		</div>
			   		<div v-else style="margin-bottom: 8px;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="margin-right:-0.25rem;">
				   			<input type="radio" id="year-radio-3" name="year" value="3" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span2" class="custom-control-label">
				   		</label>
						<select id="radio-year-select3" class="form-control-cron view-disabled" :disabled="yearCheckValue != 3" v-model="yearResult3">
					    	<option v-for="option in 2098" v-if="option > 2020" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.betweenAnd</fmt:message>
				    	<select id="radio-year-select4" class="form-control-cron view-disabled" :disabled="yearCheckValue != 3" v-model="yearResult4">
					    	<option v-for="option in 2099" v-if="option > yearResult3 && option > 2021" v-text="option"></option>
				    	</select>
				    	<fmt:message>igate.job.year</fmt:message> <fmt:message>igate.job.betweenAndTime</fmt:message>
			   		</div>
			   		<div v-if="hideIE">
				   		<label class="custom-control custom-radio custom-control-inline hide-ie-select" style="display:inline-block;">
				   			<input type="radio" id="year-radio-4" name="year" value="4" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span3" class="custom-control-label">
				   				<input type="text" class="form-control view-disabled" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.yearTooltip</fmt:message>" :disabled="yearCheckValue != 4" v-model="yearResult5">
				   			</span>
				   		</label>
			   		</div>
			   		<div v-else style="display:inline-block;">
				   		<label class="custom-control custom-radio custom-control-inline show-ie-select" style="display:inline-block;">
				   			<input type="radio" id="year-radio-4" name="year" value="4" v-model="yearCheckValue" class="custom-control-input">
				   			<span id="radio-year-span3" class="custom-control-label" style="top:13px;">
						</label>
		   				<input type="text" class="form-control view-disabled" style="display:inline-block; width:40%; margin-left:-1.25rem;" placeholder="<fmt:message>igate.job.input</fmt:message>" data-toggle="tooltip" title="<fmt:message>igate.job.yearTooltip</fmt:message>" :disabled="yearCheckValue != 4" v-model="yearResult5">
				   	</div>
		    	</div>
		    </div>
		</div>
	    <div id="gridDiv" style="overflow: hidden; height: 81px; "></div>
    </span>
</span>