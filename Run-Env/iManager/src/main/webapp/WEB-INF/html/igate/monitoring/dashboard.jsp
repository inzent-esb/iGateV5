<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/theme.dark.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dashboard.css' />">
</head>
<body>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_line.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_speedbar.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_connector.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_queue.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_threadpool.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_instance.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_externalLine.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_dataTable.jsp"%>
	<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_xView.jsp"%>
	
	<form name="excelForm" action="<c:url value='/igate/monitoring/dashboard/generateExcelChart.json' />" method="post">
		<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form>
	
<script type="text/javascript" src="<c:url value='/js/dashboard/sketch.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container_parent.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container_config_parent.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container_add.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container_modify.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_container_view.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/Chart.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/Chart.utils.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_lineChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_columnChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_speedBarChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_connectorChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_queueChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_threadPoolChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_instanceChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_externalLineChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_dataTableChart.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/dashboard/dash_xViewChart.js' />"></script>

<script type="text/javascript" src="<c:url value='/js/dashboard/Chart.constants.js' />"></script>
<%@ include file="/WEB-INF/html/igate/monitoring/dashboard_message.jsp"%>

<script type="text/javascript">
var dataFilterWorker = new Worker("<c:url value='/js/dashboard/dash_xViewChart_dataFilterWorker.js' />");
var websocketUrl = '<c:out value="${object}" />';

$(document).ready(function() {
	$("#ct").dashContainer({mod: 'view', websocketUrl: websocketUrl});
});
</script>
</body>
</html>