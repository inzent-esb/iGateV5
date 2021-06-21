<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpQueueSummarySkeleton" style="display: none;">
	<div class="row gate-row-wrp flex-1">
		<div class="col-6"></div>
		<div class="col-6"></div>
	</div>
	<div class="d-flex-space">
		<div class="legend legend-square">
			<span class="status"><i class="dot bg-cht-9"></i><fmt:message>dashboard.legend.square.message</fmt:message></span>
			<span class="status"><i class="dot bg-cht-1"></i><fmt:message>dashboard.legend.square.consumer</fmt:message></span>
		</div>
		<div class="legend">
			<span class="status"><i class="dot bg-normal"></i><fmt:message>dashboard.legend.status.normal</fmt:message></span> 
			<span class="status"><i class="dot bg-warn"></i><fmt:message>dashboard.legend.status.warn</fmt:message></span> 
			<span class="status"><i class="dot bg-cht-1"></i><fmt:message>dashboard.legend.status.error</fmt:message></span> 
			<span class="status"><i class="dot bg-danger"></i><fmt:message>dashboard.legend.status.fetal</fmt:message></span> 
			<span class="status"><i class="dot bg-down"></i><fmt:message>dashboard.legend.status.down</fmt:message></span>
		</div>
	</div>
</span>

<span id="tmpQueueSummaryContent" style="display: none;">
	<div class="gate-row">
		<div class="gate">
			<i name="instanceStatus" class="status bg-normal"></i>
			<span name="instanceId" class="t-xs"></span>
		</div>
		<div class="gate-graph">
			<div class="progress up">
				<div name="instanceMessageGraph" class="progress-bar bg-cht-9" role="progressbar" style="width: 0%">
					<span name="instanceMessageNum" class="t-xs"></span>
				</div>
			</div>
			<div class="progress">
				<div name="instanceConsumerGraph" class="progress-bar bg-cht-1" role="progressbar" style="width: 0%">
					<span name="instanceConsumerNum" class="t-xs"></span>
				</div>
			</div>
		</div>
		<div class="status-msg">
			<i class="icon-message" name="messageWarning" data-toggle="tooltip" data-placement="top" title="" data-original-title="<fmt:message>dashboard.warn.message</fmt:message>" style="display: none;"></i> <%--messageWarningYn --%> 
			<i class="icon-consumer" name="consumerWarning" data-toggle="tooltip" data-placement="top" title="" data-original-title="<fmt:message>dashboard.warn.consumer</fmt:message>" style="display: none;"></i> <%-- consumerWarningYn --%>
		</div>
	</div>
</span>