<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<script type="text/javascript">

/* word */
var dashboardLabel_dashboard = "<fmt:message>head.dashboard</fmt:message>";
var dashboardLabel_addDashboard = "<fmt:message>dashboard.head.add.dashboard</fmt:message>";
var dashboardLabel_modifyDashboard = "<fmt:message>dashboard.head.modify.dashboard</fmt:message>";
var dashboardLabel_copyDashboard = "<fmt:message>dashboard.head.copy.dashboard</fmt:message>";

var dashboardLabel_shareOff = "<fmt:message>dashboard.share.off</fmt:message>";
var dashboardLabel_shareOn = "<fmt:message>dashboard.share.on</fmt:message>";

var dashboardLabel_name = "<fmt:message>dashboard.head.name</fmt:message>";
var dashboardLabel_resolution = "<fmt:message>dashboard.head.resolution</fmt:message>";
var dashboardLabel_chartType = "<fmt:message>dashboard.head.chartType</fmt:message>";
var dashboardLabel_target = "<fmt:message>dashboard.head.target</fmt:message>";
var dashboardLabel_inoutType = "<fmt:message>dashboard.head.inoutType</fmt:message>";

var dashboardLabel_movementForm = "<fmt:message>dashboard.head.movement.form</fmt:message>";
var dashboardLabel_moveTypeCurrent = "<fmt:message>dashboard.moveType.current</fmt:message>";
var dashboardLabel_moveTypeNew = "<fmt:message>dashboard.moveType.new</fmt:message>";

var dashboardLabel_max = "<fmt:message>dashboard.head.max</fmt:message>";
var dashboardLabel_min = "<fmt:message>dashboard.head.min</fmt:message>";
var dashboardLabel_avg = "<fmt:message>dashboard.head.avg</fmt:message>";

var dashboardLabel_success = "<fmt:message>dashboard.head.success</fmt:message>";
var dashboardLabel_timeout = "<fmt:message>dashboard.head.time.out</fmt:message>";
var dashboardLabel_error = "<fmt:message>dashboard.head.error</fmt:message>";
var dashboardLabel_serious = "<fmt:message>head.serious</fmt:message>";
var dashboardLabel_warn = "<fmt:message>head.warn</fmt:message>";

var dashboardLabel_fullScreen = "<fmt:message>dashboard.head.full.screen</fmt:message>";
var dashboardLabel_setting = "<fmt:message>dashboard.head.setting</fmt:message>";

var dashboardLabel_widget = "<fmt:message>dashboard.head.widget</fmt:message>";
var dashboardLabel_addWidget = "<fmt:message>dashboard.head.add.widget</fmt:message>";

var dashboardLabel_theme = "<fmt:message>dashboard.head.theme</fmt:message>";
var dashboardLabel_themeLight = "<fmt:message>dashboard.theme.light</fmt:message>";
var dashboardLabel_themeDark = "<fmt:message>dashboard.theme.dark</fmt:message>";

var dashboardLabel_legend = "<fmt:message>dashboard.head.legend</fmt:message>";
var dashboardLabel_legendOn = "<fmt:message>dashboard.legend.on</fmt:message>";
var dashboardLabel_legendOff = "<fmt:message>dashboard.legend.off</fmt:message>";

var dashboardLabel_xViewYAxisMax = "<fmt:message>dashboard.xview.yAxis.max</fmt:message>";
var dashboardLabel_xViewTrans = "<fmt:message>dashboard.xview.data.trans</fmt:message>";
var dashboardLabel_xViewMinData = "<fmt:message>dashboard.xview.data.min</fmt:message>";

var dashboardLabel_datatableRowCnt = "<fmt:message>dashboard.row.cnt</fmt:message>";

var dashboardLabel_contextChangeDash = "<fmt:message>dashboard.context.dashChange</fmt:message>";
var dashboardLabel_contextExitFullscreen = "<fmt:message>dashboard.context.exit.fullscreen</fmt:message>";
var dashboardLabel_contextFullscreenMsg = "<fmt:message>dashboard.context.fullscreenMsg</fmt:message>";

var dashboardLabel_initialize= "<fmt:message>head.initialize</fmt:message>";

var dashboardLabel_colCnt = "<fmt:message>dashboard.col.cnt</fmt:message>";

var dashboardLabel_adapterId = "<fmt:message>igate.adapter.id</fmt:message>";
var dashboardLabel_instanceId = "<fmt:message>igate.instance.id</fmt:message>";

var dashboardNotification = "<fmt:message>dashboard.notification</fmt:message>";
var dashboardNotificationSettings = "<fmt:message>dashboard.notification.settings</fmt:message>";
var dashboardNotificationTime = "<fmt:message>dashboard.notification</fmt:message> <fmt:message>head.time</fmt:message>";
var dashboardNotificationMessage = "<fmt:message>igate.message</fmt:message>";
var dashboardNotificationHeadStatus = "<fmt:message>head.status</fmt:message>";
var dashboardNotificationInstanceId = "<fmt:message>igate.instance</fmt:message> ID";

/* sentence */
var dashboardMsg_selectContainer = "<fmt:message>dashboard.select.container</fmt:message>";
var dashboardMsg_selectShareDashboard = "<fmt:message>dashboard.select.shareDashboard</fmt:message>";
var dashboardMsg_selectDeleteDashboard = "<fmt:message>dashboard.select.deleteDashboard</fmt:message>";
var dashboardMsg_selectModifyDashboard = "<fmt:message>dashboard.select.modifyDashboard</fmt:message>";
var dashboardMsg_selectCopyDashboard = "<fmt:message>dashboard.select.copyDashboard</fmt:message>";
var dashboardMsg_selectNoDashboard = "<fmt:message>dashboard.select.noDashboard</fmt:message>";

var dashboardMsg_enterName = "<fmt:message>dashboard.enter.name</fmt:message>";
var dashboardMsg_enterResolution = "<fmt:message>dashboard.enter.resolution</fmt:message>";
var dashboardMsg_enterNumber = "<fmt:message>dashboard.enter.number</fmt:message>";

var dashboardMsg_addSuccess = "<fmt:message>dashboard.add.success</fmt:message>";
var dashboardMsg_modifySuccess = "<fmt:message>dashboard.modify.success</fmt:message>";
var dashboardMsg_deleteSuccess = "<fmt:message>dashboard.delete.success</fmt:message>";
var dashboardMsg_deleteWarn = "<fmt:message>dashboard.delete.warn</fmt:message>";
var dashboardMsg_overlapWarn = "<fmt:message>dashboard.overlap.warn</fmt:message>";

var dashboardMsg_closeNewDashboard = "<fmt:message>dashboard.close.new.window</fmt:message>";
var dashboardMsg_moveNoSameDashboard = "<fmt:message>dashboard.move.no.same</fmt:message>";
var dashboardMsg_shareSuccess= "<fmt:message>dashboard.share.success</fmt:message>";
var dashboardMsg_deployNoComponent= "<fmt:message>dashboard.deploy.noComponent</fmt:message>";
var dashboardMsg_dragWidget = "<fmt:message>dashboard.drag.widget</fmt:message>";
var dashboardMsg_noMatchCriteria= "<fmt:message>dashboard.noMatch.criteria</fmt:message>";
var dashboardMsg_xViewNumerialCheck= "<fmt:message>dashboard.enter.xview.numericalCheck</fmt:message>";
var dashboardMsg_xViewRangeCheck= "<fmt:message>dashboard.enter.xview.rangeCheck</fmt:message>";
var dashboardMsg_xViewExportMaxCnt = '<fmt:message>dashboard.xview.export.maxCnt<fmt:param value="' + xViewMaxExportCnt + '" /></fmt:message>';

/* button */
var dashboardBtn_share = "<fmt:message>head.share</fmt:message>";
var dashboardBtn_copy = "<fmt:message>head.copy</fmt:message>";
var dashboardBtn_modify = "<fmt:message>head.update</fmt:message>";
var dashboardBtn_delete = "<fmt:message>head.delete</fmt:message>";
var dashboardBtn_move = "<fmt:message>head.move</fmt:message>";
var dashboardBtn_back = "<fmt:message>dashboard.head.back</fmt:message>";
var dashboardBtn_save = "<fmt:message>head.save</fmt:message>";
var dashboardBtn_backward = "<fmt:message>head.goBackward</fmt:message>";
var dashboardBtn_forward = "<fmt:message>head.goForward</fmt:message>";
var dashboardBtn_closeCurrentDashboard = "<fmt:message>dashboard.head.close.current.dashboard</fmt:message>";

/* chart */
var dashboardChart_lineChart = "<fmt:message>dashboard.chart.lineChart</fmt:message>";
var dashboardChart_columnChart = "<fmt:message>dashboard.chart.columnChart</fmt:message>";
var dashboardChart_instanceSummaryChart = "<fmt:message>dashboard.chart.instanceSummaryChart</fmt:message>";
var dashboardChart_connectorSummaryChart = "<fmt:message>dashboard.chart.connectorSummaryChart</fmt:message>";
var dashboardChart_queueSummaryChart = "<fmt:message>dashboard.chart.queueSummaryChart</fmt:message>";
var dashboardChart_threadSummaryChart = "<fmt:message>dashboard.chart.threadSummaryChart</fmt:message>";
var dashboardChart_speedBarChart = "<fmt:message>dashboard.chart.speedBarChart</fmt:message>";
var dashboardChart_dataTable = "<fmt:message>dashboard.chart.dataTable</fmt:message>";
var dashboardChart_externalLine = "<fmt:message>dashboard.target.externalLine</fmt:message>";
var dashboardChart_xview = "<fmt:message>dashboard.chart.xview</fmt:message>";


/* chart */
var dashboardChart_lineChart = "<fmt:message>dashboard.chart.lineChart</fmt:message>";
var dashboardChart_columnChart = "<fmt:message>dashboard.chart.columnChart</fmt:message>";
var dashboardChart_instanceSummaryChart = "<fmt:message>dashboard.chart.instanceSummaryChart</fmt:message>";
var dashboardChart_connectorSummaryChart = "<fmt:message>dashboard.chart.connectorSummaryChart</fmt:message>";
var dashboardChart_queueSummaryChart = "<fmt:message>dashboard.chart.queueSummaryChart</fmt:message>";
var dashboardChart_threadSummaryChart = "<fmt:message>dashboard.chart.threadSummaryChart</fmt:message>";
var dashboardChart_speedBarChart = "<fmt:message>dashboard.chart.speedBarChart</fmt:message>";
var dashboardChart_dataTable = "<fmt:message>dashboard.chart.dataTable</fmt:message>";
var dashboardChart_externalLine = "<fmt:message>dashboard.target.externalLine</fmt:message>";
var dashboardChart_xview = "<fmt:message>dashboard.chart.xview</fmt:message>";


/* target */
var dashboardTarget_instance = "<fmt:message>dashboard.target.instance</fmt:message>"; 
var dashboardTarget_adaptor = "<fmt:message>dashboard.target.adaptor</fmt:message>";
var dashboardTarget_connector = "<fmt:message>dashboard.target.connector</fmt:message>";
var dashboardTarget_queue = "<fmt:message>dashboard.target.queue</fmt:message>";
var dashboardTarget_thread = "<fmt:message>dashboard.target.thread</fmt:message>";
var dashboardTarget_externalLine = "<fmt:message>dashboard.target.externalLine</fmt:message>";

/* widget */
var dashboardWidget = {
	cpuUsage: 			"<fmt:message>dashboard.widget.cpuUsage</fmt:message>",
	connectorSummary: 	"<fmt:message>dashboard.widget.connectorSummary</fmt:message>",
	externalLineStatus: "<fmt:message>dashboard.widget.externalLineSummary</fmt:message>",
	fileMainUsage: 		"<fmt:message>dashboard.widget.diskUsage</fmt:message>",
	fileMainUsed:		"<fmt:message>dashboard.widget.diskUsed</fmt:message>",
	heapUsage: 			"<fmt:message>dashboard.widget.memoryUsage</fmt:message>",
	heapUsed: 			"<fmt:message>dashboard.widget.memoryUsed</fmt:message>",
	instanceSummary: 	"<fmt:message>dashboard.widget.instanceSummary</fmt:message>",
	activeTransaction: 	"<fmt:message>dashboard.widget.livedTransaction</fmt:message>",
	queueSummary: 		"<fmt:message>dashboard.widget.queueSummary</fmt:message>",
	threadPoolSummary:	"<fmt:message>dashboard.widget.threadSummary</fmt:message>",
	deal: 				"<fmt:message>dashboard.widget.transactionCount</fmt:message>",
	elapsed: 			"<fmt:message>dashboard.widget.transactionElapsed</fmt:message>",
	xView: 				"<fmt:message>dashboard.widget.xView</fmt:message>",
	transaction: 		"<fmt:message>dashboard.widget.dateTable</fmt:message>"
};

/* widget desc*/
var dashboardWidgetDesc = {
	cpuUsage: 			"<fmt:message>dashboard.widget.cpuUsage.desc</fmt:message>",
	connectorSummary: 	"<fmt:message>dashboard.widget.connectorSummary.desc</fmt:message>",
	externalLineStatus: "<fmt:message>dashboard.widget.externalLineSummary.desc</fmt:message>",
	fileMainUsage: 		"<fmt:message>dashboard.widget.diskUsage.desc</fmt:message>",
	fileMainUsed:		"<fmt:message>dashboard.widget.diskUsed.desc</fmt:message>",
	heapUsage: 			"<fmt:message>dashboard.widget.memoryUsage.desc</fmt:message>",
	heapUsed: 			"<fmt:message>dashboard.widget.memoryUsed.desc</fmt:message>",
	instanceSummary: 	"<fmt:message>dashboard.widget.instanceSummary.desc</fmt:message>",
	activeTransaction: 	"<fmt:message>dashboard.widget.livedTransaction.desc</fmt:message>",
	queueSummary: 		"<fmt:message>dashboard.widget.queueSummary.desc</fmt:message>",
	threadPoolSummary:	"<fmt:message>dashboard.widget.threadSummary.desc</fmt:message>",
	deal: 				"<fmt:message>dashboard.widget.transactionCount.desc</fmt:message>",
	elapsed: 			"<fmt:message>dashboard.widget.transactionElapsed.desc</fmt:message>",
	xView: 				"<fmt:message>dashboard.widget.xView.desc</fmt:message>",
	transaction: 		"<fmt:message>dashboard.widget.dateTable.desc</fmt:message>"
};

/* widget - dataTable, xView */
var dashboardGrid_status = "<fmt:message>dashboard.head.status</fmt:message>";
var dashboardGrid_uuid = "<fmt:message>dashboard.head.uuid</fmt:message>";
var dashboardGrid_transactionId = "<fmt:message>dashboard.head.transactionId</fmt:message>";
var dashboardGrid_interfaceserviceId = "<fmt:message>dashboard.head.interface.service.id</fmt:message>";
var dashboardGrid_transactionName = "<fmt:message>dashboard.head.transactionName</fmt:message>";
var dashboardGrid_adapterId = "<fmt:message>igate.adapter.id</fmt:message>";
var dashboardGrid_instanceId = "<fmt:message>igate.instance.id</fmt:message>";
var dashboardGrid_snapshotTimestamp = "<fmt:message>dashboard.head.snapshotTimestamp</fmt:message>";
var dashboardGrid_responseTime = "<fmt:message>dashboard.head.responseTime</fmt:message>";

</script>