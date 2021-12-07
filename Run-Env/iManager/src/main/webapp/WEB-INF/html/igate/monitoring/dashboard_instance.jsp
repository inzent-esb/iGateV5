<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpInstanceSummary" style="display: none;">
	<div class="row no-gutters flex-1" style="overflow-x: hidden;"></div>
	
	<div class="legend legend-square">
		<span class="status"><i class="dot bg-cht-6"></i><fmt:message>dashboard.legend.square.cpu</fmt:message></span>
		<span class="status"><i class="dot bg-cht-7"></i><fmt:message>dashboard.legend.square.memory</fmt:message></span>
		<span class="status"><i class="dot bg-cht-3"></i><fmt:message>dashboard.legend.square.disk1</fmt:message></span>
		<span class="status"><i class="dot bg-cht-3"></i><fmt:message>dashboard.legend.square.disk2</fmt:message></span>
	</div>	
</span>

<span id="tmpInstanceSummaryContent" style="display: none;">
	<div class="gate-col">
		<div class="graph-caption">
			<span name="instanceId"></span>
			<i class="iconb-warn" style="display: none;" title="Down"></i>
		</div>
		<div class="graph-vs" style="width: 100%;">
			<div class="progress progress-vertical" style="width: 25%;height:calc(100% - 1.0rem); padding-bottom: 1.0rem;">
				<div name="instanceCpuGraph" class="progress-bar bg-cht-6" role="progressbar" data-toggle="tooltip" data-placement="top" title="0%" style="width: 100%;height: 0%" ></div>
				<span class="progress-status" style="font-size: 1.0rem; line-height: 0.875rem;"><span name="instanceCpu" class="t-xs"></span></span>
			</div>
			<div class="progress progress-vertical" style="width: 25%;height:calc(100% - 1.0rem); padding-bottom: 1.0rem;">
				<div name="instanceMemoryGraph" class="progress-bar bg-cht-7" role="progressbar" data-toggle="tooltip" data-placement="top" title="0%" style="width: 100%;height: 0%"></div>
				<span class="progress-status" style="font-size: 1.0rem; line-height: 0.875rem;"><span name="instanceMemory" class="t-xs"></span></span>
			</div>
			<div class="progress progress-vertical" style="width: 25%;height:calc(100% - 1.0rem); padding-bottom: 1.0rem;">
				<div name="instanceDiskGraph1" class="progress-bar bg-cht-3" role="progressbar" data-toggle="tooltip" data-placement="top" title="0%" style="width: 100%;height: 0%"></div>
				<span class="progress-status" style="font-size: 1.0rem; line-height: 0.875rem;"><span name="instanceDisk1" class="t-xs"></span></span>
			</div>
			<div class="progress progress-vertical" style="width: 25%;height:calc(100% - 1.0rem); padding-bottom: 1.0rem;">
				<div name="instanceDiskGraph2" class="progress-bar bg-cht-3" role="progressbar" data-toggle="tooltip" data-placement="top" title="0%" style="width: 100%;height: 0%"></div>
				<span class="progress-status" style="font-size: 1.0rem; line-height: 0.875rem;"><span name="instanceDisk2" class="t-xs"></span></span>
			</div>
		</div>
	</div>
</span>