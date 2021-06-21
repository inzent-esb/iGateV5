<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpSpeedBar" style="display: none;">
	<div class="transaction flex-1">
		<div class="transaction-status">
			<ul>
				<li><span>RPS</span><span id="rpsCnt" class="num">0</span></li>
				<li><span>TPS</span><span id="tpsCnt" class="num">0</span></li>
			</ul>
		</div>
		<div class="transaction-info">
			<div class="rps" style="position:absolute; top: 0px; left: 0; width: 50%; height: 100%;"></div>
			<div class="tps" style="position:absolute; top: 0px; left: 50%;  width: 50%; height: 100%;"></div>
			<div class="activeTransactions" style="position:absolute; top: 0px; left: 25%; width: 50%; height: 100%;"></div>
		</div>
	</div>
	<div class="legend transaction-legend">
		<span class="status"><i class="dot bg-normal"></i><fmt:message>head.normal</fmt:message></span>
		<span class="status"><i class="dot bg-warn"></i><fmt:message>head.warn</fmt:message></span>
		<span class="status"><i class="dot bg-danger"></i><fmt:message>head.serious</fmt:message></span>
	</div>	
</span>

<img id="speedbar-bg-white" src="<c:url value='/img/traffic-light.png' />" style="display: none;">
<img id="speedbar-bg-dark" src="<c:url value='/img/traffic-dark.png' />" style="display: none;">
<img id="speedbar-rps" src="<c:url value='/img/traffic-ball.svg' />" style="display: none;">
<img id="speedbar-tps-green" src="<c:url value='/img/traffic-ball-green.svg' />" style="display: none;">
<img id="speedbar-tps-yellow" src="<c:url value='/img/traffic-ball-yellow.svg' />" style="display: none;">
<img id="speedbar-tps-red" src="<c:url value='/img/traffic-ball-red.svg' />" style="display: none;">