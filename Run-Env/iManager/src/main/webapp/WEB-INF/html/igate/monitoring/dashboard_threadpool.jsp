<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpThreadPoolSummarySkeleton" style="display: none;">
	<div class="row gate-row-wrp flex-1">
		<div class="col-6"></div>
		<div class="col-6"></div>
	</div>
	<div class="d-flex-space">
		<div class="legend legend-square">
			<span class="status"><i class="dot bg-cht-10"></i><fmt:message>dashboard.legend.square.activeThread</fmt:message></span> 
			<span class="status"><i class="dot bg-cht-10-l"></i><fmt:message>dashboard.legend.square.idleThread</fmt:message></span>
		</div>
		<div class="legend">
			<span class="status"><i class="dot bg-normal"></i><fmt:message>dashboard.legend.status.normal</fmt:message></span> 
			<span class="status"><i class="dot bg-warn"></i><fmt:message>dashboard.legend.status.warn</fmt:message></span> 
			<span class="status"><i class="dot bg-cht-1"></i><fmt:message>dashboard.legend.status.shutdown</fmt:message></span> 
			<span class="status"><i class="dot bg-down"></i><fmt:message>dashboard.legend.status.terminating</fmt:message></span> 
			<span class="status"><i class="dot bg-alarm"></i><fmt:message>dashboard.legend.status.terminated</fmt:message></span> 
			<span class="status"><i class="dot bg-danger"></i><fmt:message>dashboard.legend.status.fail</fmt:message></span>
		</div>
	</div>
</span>

<span id="tmpThreadPoolSummaryContent" style="display: none;">
	<div class="gate-row">
		<div class="gate">
			<i name="instanceStatus" class="status bg-normal"></i>
			<span name="instanceId" class="t-xs"></span>
		</div>
		<div class="gate-graph">
			<div class="progress">
				<div name="instanceActiveThreadGraph" class="progress-bar bg-cht-10" role="progressbar" style="width: 0%">
					<span name="instanceActiveThreadNum" class="t-xs"></span>
				</div>
				<div name="instanceIdleThreadGraph" class="progress-bar bg-cht-10-l" role="progressbar" style="width: 0%">
					<span name="instanceIdleThreadNum" class="t-xs"></span>
				</div>
			</div>
		</div>
		<div class="status-msg"></div>
	</div>
</span>