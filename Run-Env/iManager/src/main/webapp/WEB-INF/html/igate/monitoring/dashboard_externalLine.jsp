<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpExternalLine" style="display: none;">
	<div class="row row-label" style="overFlow:auto;">
	</div>
	
	<div class="legend">
		<span class="status"><i class="dot bg-normal"></i><fmt:message>dashboard.legend.status.normal</fmt:message></span>
		<span class="status"><i class="dot bg-warn"></i><fmt:message>dashboard.legend.status.warn</fmt:message></span>
		<span class="status"><i class="dot bg-cht-1"></i><fmt:message>dashboard.legend.status.error</fmt:message></span>
		<span class="status"><i class="dot bg-danger"></i><fmt:message>dashboard.legend.status.fetal</fmt:message></span>
		<span class="status"><i class="dot bg-down"></i><fmt:message>dashboard.legend.status.down</fmt:message></span>
	</div>	
</span>

<span id="tmpExternalLineContent" style="display: none;">
	<div class="col-auto" style="flex-basis: 4%">
		<span class="label" data-toggle="tooltip" data-placement="top" title=""><i name="externalLineStatus" class="status bg-normal"></i><span name="externalLineName"></span></span>
	</div>
</span>
