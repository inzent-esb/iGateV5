<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpConnectorSummarySkeleton" style="display: none;">
	<div class="row gate-row-wrp flex-1">
		<div class="col-6"></div>
		<div class="col-6"></div>
	</div>
	<div class="d-flex-space">
		<div class="legend legend-square">
			<span class="status"><i class="dot bg-cht-11"></i><fmt:message>dashboard.legend.square.activeSession</fmt:message></span> 
			<span class="status"><i class="dot bg-cht-11-l"></i><fmt:message>dashboard.legend.square.idleSession</fmt:message></span>
			<span class="status"><i class="dot bg-cht-2"></i><fmt:message>dashboard.legend.square.activeThread</fmt:message></span>
			<span class="status"><i class="dot bg-cht-2-l"></i><fmt:message>dashboard.legend.square.idleThread</fmt:message></span>
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

<span id="tmpConnectorSummaryContent" style="display: none;">
	<div class="gate-row">
		<div class="gate">
			<i name="instanceStatus" class="status bg-normal"></i>
			<span name="instanceId" class="t-xs"></span>
		</div>
		<div class="gate-graph">
			<div class="progress up">
				<div name="instanceActiveSessionInuseGraph" class="progress-bar bg-cht-11" role="progressbar" style="width: 0%" data-toggle="tooltip" data-placement="top">
					<span name="instanceActiveSessionInuseNum" class="t-xs"></span>
				</div>
				<div name="instanceSessionWaitGraph" class="progress-bar bg-cht-11-l" role="progressbar" style="width: 0%" data-toggle="tooltip" data-placement="top">
					<span name="instanceSessionWaitNum" class="t-xs"></span>
				</div>
			</div>
			<div class="progress">
				<div name="instanceThreadInuseGraph" class="progress-bar bg-cht-2" role="progressbar" style="width: 0%" data-toggle="tooltip" data-placement="bottom">
					<span name="instanceThreadInuseNum" class="t-xs"></span>
				</div>
				<div name="instanceThreadWaitGraph" class="progress-bar bg-cht-2-l" role="progressbar" style="width: 0%" data-toggle="tooltip" data-placement="bottom">
					<span name="instanceThreadWaitNum" class="t-xs"></span>
				</div>
			</div>
		</div>
		<div class="status-msg">
			<%-- idleWarningYn, sessionCountWarningYn, sessionInuseWarningYn, sessionWaitWarningYn, threadCountWarningYn, threadInuseWarningYn --%>
			<i class="icon-using" data-toggle="tooltip" data-placement="top" title="<fmt:message>dashboard.wait.session</fmt:message>" style="display: none;"></i> 
			<i class="icon-thread" data-toggle="tooltip" data-placement="top" title="<fmt:message>dashboard.create.session</fmt:message>" style="display: none;"></i>
			<i class="icon-screated" data-toggle="tooltip" data-placement="top" title="<fmt:message>dashboard.using.session</fmt:message>" style="display: none;"></i> 
		</div>
	</div>
</span>