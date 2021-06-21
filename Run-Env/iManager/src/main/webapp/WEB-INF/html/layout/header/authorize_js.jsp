<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 대외회선 --%>
<sec:authorize var="hasExternalLineViewer" access="hasRole('ExternalLineViewer')"></sec:authorize>
<sec:authorize var="hasExternalLineEditor" access="hasRole('ExternalLineEditor')"></sec:authorize>

<%-- 서비스 식별, 웹서비스 등록, 서비스 이관 --%>
<sec:authorize var="hasServiceViewer" access="hasRole('ServiceViewer')"></sec:authorize>
<sec:authorize var="hasServiceEditor" access="hasRole('ServiceEditor')"></sec:authorize>

<%-- 인터페이스 식별, 인터페이스 이관 --%>
<sec:authorize var="hasInterfaceViewer" access="hasRole('InterfaceViewer')"></sec:authorize>
<sec:authorize var="hasInterfaceEditor" access="hasRole('InterfaceEditor')"></sec:authorize>

<%-- 쿼리 --%>
<sec:authorize var="hasQueryViewer" access="hasRole('QueryViewer')"></sec:authorize>
<sec:authorize var="hasQueryEditor" access="hasRole('QueryEditor')"></sec:authorize>

<%-- 거래 변수 --%>
<sec:authorize var="hasTransactionContextViewer" access="hasRole('TransactionContextViewer')"></sec:authorize>
<sec:authorize var="hasTransactionContextEditor" access="hasRole('TransactionContextEditor')"></sec:authorize>

<%-- 표준코드 --%>
<sec:authorize var="hasStandardCodeViewer" access="hasRole('StandardCodeViewer')"></sec:authorize>
<sec:authorize var="hasStandardCodeEditor" access="hasRole('StandardCodeEditor')"></sec:authorize>

<%-- 에러코드 --%>
<sec:authorize var="hasExceptionCodeViewer" access="hasRole('ExceptionCodeViewer')"></sec:authorize>
<sec:authorize var="hasExceptionCodeEditor" access="hasRole('ExceptionCodeEditor')"></sec:authorize>

<%-- 모델 이관, 필드메타 --%>
<sec:authorize var="hasRecordViewer" access="hasRole('RecordViewer')"></sec:authorize>
<sec:authorize var="hasRecordEditor" access="hasRole('RecordEditor')"></sec:authorize>

<%-- 액티비티 --%>
<sec:authorize var="hasActivityViewer" access="hasRole('ActivityViewer')"></sec:authorize>
<sec:authorize var="hasActivityEditor" access="hasRole('ActivityEditor')"></sec:authorize>

<%-- 에러로그 --%>
<sec:authorize var="hasExceptionLogViewer" access="hasRole('ExceptionLogViewer')"></sec:authorize>
<sec:authorize var="hasExceptionLogEditor" access="hasRole('ExceptionLogEditor')"></sec:authorize>

<%-- 추적로그 --%>
<sec:authorize var="hasTraceLogViewer" access="hasRole('TraceLogViewer')"></sec:authorize>
<sec:authorize var="hasTraceLogEditor" access="hasRole('TraceLogEditor')"></sec:authorize>

<%-- 파일로그, SAF 거래내역 --%>
<sec:authorize var="hasFileLogViewer" access="hasRole('FileLogViewer')"></sec:authorize>
<sec:authorize var="hasFileLogEditor" access="hasRole('FileLogEditor')"></sec:authorize>

<%-- 예약된 배치 스케줄 --%>
<sec:authorize var="hasReservedScheduleViewer" access="hasRole('ReservedScheduleViewer')"></sec:authorize>
<sec:authorize var="hasReservedScheduleEditor" access="hasRole('ReservedScheduleEditor')"></sec:authorize>

<%-- 커넥터--%>
<sec:authorize var="hasConnectorViewer" access="hasRole('ConnectorViewer')"></sec:authorize>
<sec:authorize var="hasConnectorEditor" access="hasRole('ConnectorEditor')"></sec:authorize>

<%-- 커넥터 제어 --%>
<sec:authorize var="hasConnectorController" access="hasRole('ConnectorController')"></sec:authorize>

<%-- 어댑터 --%>
<sec:authorize var="hasAdapterViewer" access="hasRole('AdapterViewer')"></sec:authorize>
<sec:authorize var="hasAdapterEditor" access="hasRole('AdapterEditor')"></sec:authorize>

<%-- 어댑터 제어 --%>
<sec:authorize var="hasAdapterController" access="hasRole('AdapterController')"></sec:authorize>

<%-- 인터페이스 제한 --%>
<sec:authorize var="hasInterfaceRestrictionViewer" access="hasRole('InterfaceRestrictionViewer')"></sec:authorize>
<sec:authorize var="hasInterfaceRestrictionEditor" access="hasRole('InterfaceRestrictionEditor')"></sec:authorize>

<%-- 서비스 제한 --%>
<sec:authorize var="hasServiceRestrictionViewer" access="hasRole('ServiceRestrictionViewer')"></sec:authorize>
<sec:authorize var="hasServiceRestrictionEditor" access="hasRole('ServiceRestrictionEditor')"></sec:authorize>

<%-- 온라인헤더 맵핑 정책 --%>
<sec:authorize var="hasOnlineHeaderMappingPolicyViewer" access="hasRole('OnlineHeaderMappingPolicyViewer')"></sec:authorize>
<sec:authorize var="hasOnlineHeaderMappingPolicyEditor" access="hasRole('OnlineHeaderMappingPolicyEditor')"></sec:authorize>

<%-- 인터페이스 정책 --%>
<sec:authorize var="hasInterfacePolicyViewer" access="hasRole('InterfacePolicyViewer')"></sec:authorize>
<sec:authorize var="hasInterfacePolicyEditor" access="hasRole('InterfacePolicyEditor')"></sec:authorize>

<%-- 서비스 정책 --%>
<sec:authorize var="hasServicePolicyViewer" access="hasRole('ServicePolicyViewer')"></sec:authorize>
<sec:authorize var="hasServicePolicyEditor" access="hasRole('ServicePolicyEditor')"></sec:authorize>

<%-- 맵핑 이관 --%>
<sec:authorize var="hasMappingViewer" access="hasRole('MappingViewer')"></sec:authorize>
<sec:authorize var="hasMappingEditor" access="hasRole('MappingEditor')"></sec:authorize>

<%-- 오퍼레이션 이관 --%>
<sec:authorize var="hasOperationViewer" access="hasRole('OperationViewer')"></sec:authorize>
<sec:authorize var="hasOperationEditor" access="hasRole('OperationEditor')"></sec:authorize>

<%-- 배치 작업 --%>
<sec:authorize var="hasJobViewer" access="hasRole('JobViewer')"></sec:authorize>
<sec:authorize var="hasJobEditor" access="hasRole('JobEditor')"></sec:authorize>

<%-- 배치 작업 결과 --%>
<sec:authorize var="hasJobResultViewer" access="hasRole('JobResultViewer')"></sec:authorize>
<sec:authorize var="hasJobResultEditor" access="hasRole('JobResultEditor')"></sec:authorize>

<%-- Property --%>
<sec:authorize var="hasPropertyViewer" access="hasRole('PropertyViewer')"></sec:authorize>
<sec:authorize var="hasPropertyEditor" access="hasRole('PropertyEditor')"></sec:authorize>

<%-- 쓰레드풀 --%>
<sec:authorize var="hasThreadPoolViewer" access="hasRole('ThreadPoolViewer')"></sec:authorize>
<sec:authorize var="hasThreadPoolEditor" access="hasRole('ThreadPoolEditor')"></sec:authorize>

<%-- 휴일 --%>
<sec:authorize var="hasCalendarViewer" access="hasRole('CalendarViewer')"></sec:authorize>
<sec:authorize var="hasCalendarEditor" access="hasRole('CalendarEditor')"></sec:authorize>

<%-- 인스턴스 --%>
<sec:authorize var="hasInstanceViewer" access="hasRole('InstanceViewer')"></sec:authorize>
<sec:authorize var="hasInstanceEditor" access="hasRole('InstanceEditor')"></sec:authorize>

<%-- 수정 내역 --%>
<sec:authorize var="hasMetaHistoryViewer" access="hasRole('MetaHistoryViewer')"></sec:authorize>
<sec:authorize var="hasMetaHistoryEditor" access="hasRole('MetaHistoryEditor')"></sec:authorize>

<%-- 소스 프로젝트 --%>
<sec:authorize var="hasJavaProjectViewer" access="hasRole('JavaProjectViewer')"></sec:authorize>
<sec:authorize var="hasJavaProjectEditor" access="hasRole('JavaProjectEditor')"></sec:authorize>

<%-- 메시지 --%>
<sec:authorize var="hasMessageViewer" access="hasRole('MessageViewer')"></sec:authorize>
<sec:authorize var="hasMessageEditor" access="hasRole('MessageEditor')"></sec:authorize>

<%-- 권한 --%>
<sec:authorize var="hasPrivilegeViewer" access="hasRole('PrivilegeViewer')"></sec:authorize>
<sec:authorize var="hasPrivilegeEditor" access="hasRole('PrivilegeEditor')"></sec:authorize>

<%-- 역할 --%>
<sec:authorize var="hasRoleViewer" access="hasRole('RoleViewer')"></sec:authorize>
<sec:authorize var="hasRoleEditor" access="hasRole('RoleEditor')"></sec:authorize>

<%-- 사용자 --%>
<sec:authorize var="hasUserViewer" access="hasRole('UserViewer')"></sec:authorize>
<sec:authorize var="hasUserEditor" access="hasRole('UserEditor')"></sec:authorize>

<%-- 메뉴 --%>
<sec:authorize var="hasMenuEditor" access="hasRole('MenuEditor')"></sec:authorize>

<%-- 통계 --%>
<sec:authorize var="hasLogStatisticsViewer" access="hasRole('LogStatisticsViewer')"></sec:authorize>

<%-- 공지사항 --%>
<sec:authorize var="hasNoticeViewer" access="hasRole('NoticeViewer')"></sec:authorize>
<sec:authorize var="hasNoticeEditor" access="hasRole('NoticeEditor')"></sec:authorize>

<%-- etc --%>
<sec:authorize var="hasAdministrator" access="hasRole('Administrator')"></sec:authorize>
<sec:authorize var="hasDashBoardEditor" access="hasRole('DashBoardEditor')"></sec:authorize>
<sec:authorize var="hasDashBoardViewer" access="hasRole('DashBoardViewer')"></sec:authorize>
<sec:authorize var="hasFileRepositoryEditor" access="hasRole('FileRepositoryEditor')"></sec:authorize>
<sec:authorize var="hasFileRepositoryViewer" access="hasRole('FileRepositoryViewer')"></sec:authorize>
<sec:authorize var="hasJobController" access="hasRole('JobController')"></sec:authorize>
<sec:authorize var="hasJunitTestPrivilege" access="hasRole('JunitTestPrivilege')"></sec:authorize>
<sec:authorize var="hasMigrationEditor" access="hasRole('MigrationEditor')"></sec:authorize>
<sec:authorize var="hasMonitoringEditor" access="hasRole('MonitoringEditor')"></sec:authorize>
<sec:authorize var="hasMonitoringViewer" access="hasRole('MonitoringViewer')"></sec:authorize>
<sec:authorize var="hasOnlineDailyStatsEditor" access="hasRole('OnlineDailyStatsEditor')"></sec:authorize>
<sec:authorize var="hasOnlineDailyStatsViewer" access="hasRole('OnlineDailyStatsViewer')"></sec:authorize>
<sec:authorize var="hasReplyEmulateEditor" access="hasRole('ReplyEmulateEditor')"></sec:authorize>
<sec:authorize var="hasReplyEmulateViewer" access="hasRole('ReplyEmulateViewer')"></sec:authorize>
<sec:authorize var="hasSafMessageEditor" access="hasRole('SafMessageEditor')"></sec:authorize>
<sec:authorize var="hasSafMessageViewer" access="hasRole('SafMessageViewer')"></sec:authorize>
<sec:authorize var="hasTestCaseEditor" access="hasRole('TestCaseEditor')"></sec:authorize>
<sec:authorize var="hasTestCaseViewer" access="hasRole('TestCaseViewer')"></sec:authorize>

<sec:authorize access="isAuthenticated()">
	<input type="hidden" id="userId" value="<sec:authentication property="principal.username" />">
</sec:authorize>

<script type="text/javascript">

<%-- 대외회선 --%>
var hasExternalLineViewer = "true" == "${hasExternalLineViewer}"
var hasExternalLineEditor = "true" == "${hasExternalLineEditor}"


<%-- 서비스 식별, 웹서비스 등록, 서비스 이관 --%>
var hasServiceViewer = "true" == "${hasServiceViewer}"
var hasServiceEditor = "true" == "${hasServiceEditor}"

<%-- 인터페이스 식별, 인터페이스 이관 --%>
var hasInterfaceViewer = "true" == "${hasInterfaceViewer}"
var hasInterfaceEditor = "true" == "${hasInterfaceEditor}"

<%-- 거래 변수 --%>
var hasTransactionContextViewer = "true" == "${hasTransactionContextViewer}"
var hasTransactionContextEditor = "true" == "${hasTransactionContextEditor}"

<%-- 표준코드 --%>
var hasStandardCodeViewer = "true" == "${hasStandardCodeViewer}"
var hasStandardCodeEditor = "true" == "${hasStandardCodeEditor}"

<%-- 에러코드 --%>
var hasExceptionCodeViewer = "true" == "${hasExceptionCodeViewer}"
var hasExceptionCodeEditor = "true" == "${hasExceptionCodeEditor}"

<%-- 모델 이관, 필드메타 --%>
var hasRecordViewer = "true" == "${hasRecordViewer}"
var hasRecordEditor = "true" == "${hasRecordEditor}"

<%-- 액티비티 --%>
var hasActivityViewer = "true" == "${hasActivityViewer}"
var hasActivityEditor = "true" == "${hasActivityEditor}"

<%-- 에러로그 --%>
var hasExceptionLogViewer = "true" == "${hasExceptionLogViewer}"
var hasExceptionLogEditor = "true" == "${hasExceptionLogEditor}"

<%-- 파일로그, 파일 송수신내역 --%>
var hasFileLogViewer = "true" == "${hasFileLogViewer}"
var hasFileLogEditor = "true" == "${hasFileLogEditor}"

<%-- 예약된 배치 스케줄 --%>
var hasReservedScheduleViewer = "true" == "${hasReservedScheduleViewer}"
var hasReservedScheduleEditor = "true" == "${hasReservedScheduleEditor}"

<%-- 커넥터 --%>
var hasConnectorViewer = "true" == "${hasConnectorViewer}"
var hasConnectorEditor = "true" == "${hasConnectorEditor}"

<%-- 커넥터 제어 --%>
var hasConnectorController = "true" == "${hasConnectorController}"

<%-- 인터페이스 제한 --%>
var hasInterfaceRestrictionViewer = "true" == "${hasInterfaceRestrictionViewer}"
var hasInterfaceRestrictionEditor = "true" == "${hasInterfaceRestrictionEditor}"

<%-- 서비스 제한 --%>
var hasServiceRestrictionViewer = "true" == "${hasServiceRestrictionViewer}"
var hasServiceRestrictionEditor = "true" == "${hasServiceRestrictionEditor}"

<%-- 어댑터 --%>
var hasAdapterViewer = "true" == "${hasAdapterViewer}"
var hasAdapterEditor = "true" == "${hasAdapterEditor}"

<%-- 어댑터 제어--%>
var hasAdapterController = "true" == "${hasAdapterController}"

<%-- 온라인헤더 맵핑 정책 --%>
var hasOnlineHeaderMappingPolicyViewer = "true" == "${hasOnlineHeaderMappingPolicyViewer}"
var hasOnlineHeaderMappingPolicyEditor = "true" == "${hasOnlineHeaderMappingPolicyEditor}"

<%-- 인터페이스 정책 --%>
var hasInterfacePolicyViewer = "true" == "${hasInterfacePolicyViewer}"
var hasInterfacePolicyEditor = "true" == "${hasInterfacePolicyEditor}"

<%-- 서비스 정책 --%>
var hasServicePolicyViewer = "true" == "${hasServicePolicyViewer}"
var hasServicePolicyEditor = "true" == "${hasServicePolicyEditor}"

<%-- 맵핑 이관 --%>
var hasMappingViewer = "true" == "${hasMappingViewer}"
var hasMappingEditor = "true" == "${hasMappingEditor}"

<%-- 오퍼레이션 이관 --%>
var hasOperationViewer = "true" == "${hasOperationViewer}"
var hasOperationEditor = "true" == "${hasOperationEditor}"

<%-- 배치 작업 --%>
var hasJobViewer = "true" == "${hasJobViewer}"
var hasJobEditor = "true" == "${hasJobEditor}"

<%-- 배치 작업 결과 --%>
var hasJobResultViewer = "true" == "${hasJobResultViewer}"
var hasJobResultEditor = "true" == "${hasJobResultEditor}"

<%-- Property --%>
var hasPropertyViewer = "true" == "${hasPropertyViewer}"
var hasPropertyEditor = "true" == "${hasPropertyEditor}"

<%-- 쓰레드풀 --%>
var hasThreadPoolViewer = "true" == "${hasThreadPoolViewer}"
var hasThreadPoolEditor = "true" == "${hasThreadPoolEditor}"

<%-- 휴일 --%>
var hasCalendarViewer = "true" == "${hasCalendarViewer}"
var hasCalendarEditor = "true" == "${hasCalendarEditor}"

<%-- 인스턴스 --%>
var hasInstanceViewer = "true" == "${hasInstanceViewer}"
var hasInstanceEditor = "true" == "${hasInstanceEditor}"

<%-- 수정 내역 --%>
var hasMetaHistoryViewer = "true" == "${hasMetaHistoryViewer}"
var hasMetaHistoryEditor = "true" == "${hasMetaHistoryEditor}"

<%-- 소스 프로젝트 --%>
var hasJavaProjectViewer = "true" == "${hasJavaProjectViewer}"
var hasJavaProjectEditor = "true" == "${hasJavaProjectEditor}"

<%-- 메시지 --%>
var hasMessageViewer = "true" == "${hasMessageViewer}"
var hasMessageEditor = "true" == "${hasMessageEditor}"

<%-- 권한 --%>
var hasPrivilegeViewer = "true" == "${hasPrivilegeViewer}"
var hasPrivilegeEditor = "true" == "${hasPrivilegeEditor}"

<%-- 역할 --%>
var hasRoleViewer = "true" == "${hasRoleViewer}"
var hasRoleEditor = "true" == "${hasRoleEditor}"

<%-- 사용자 --%>
var hasUserViewer = "true" == "${hasUserViewer}"
var hasUserEditor = "true" == "${hasUserEditor}"

<%-- 메뉴 --%>
var hasMenuEditor = "true" == "${hasMenuEditor}"

<%-- 통계 --%>
var hasLogStatisticsViewer = "true" == "${hasLogStatisticsViewer}"

<%-- 공지사항 --%>
var hasNoticeViewer = "true" == "${hasNoticeViewer}"
var hasNoticeEditor = "true" == "${hasNoticeEditor}"

<%-- 쿼리 이관 --%>
var hasQueryViewer = "true" == "${hasQueryViewer}"
var hasQueryEditor = "true" == "${hasQueryEditor}"

<%-- etc --%>
var hasAdministrator = "true" == "${hasAdministrator}"
var hasDashBoardEditor = "true" == "${hasDashBoardEditor}"
var hasDashBoardViewer = "true" == "${hasDashBoardViewer}"
var hasFileRepositoryEditor = "true" == "${hasFileRepositoryEditor}"
var hasFileRepositoryViewer = "true" == "${hasFileRepositoryViewer}"
var hasJobController = "true" == "${hasJobController}"
var hasJunitTestPrivilege = "true" == "${hasJunitTestPrivilege}"
var hasMigrationEditor = "true" == "${hasMigrationEditor}"
var hasMonitoringEditor = "true" == "${hasMonitoringEditor}"
var hasMonitoringViewer = "true" == "${hasMonitoringViewer}"
var hasOnlineDailyStatsEditor = "true" == "${hasOnlineDailyStatsEditor}"
var hasOnlineDailyStatsViewer = "true" == "${hasOnlineDailyStatsViewer}"
var hasReplyEmulateEditor = "true" == "${hasReplyEmulateEditor}"
var hasReplyEmulateViewer = "true" == "${hasReplyEmulateViewer}"
var hasSafMessageEditor = "true" == "${hasSafMessageEditor}"
var hasSafMessageViewer = "true" == "${hasSafMessageViewer}"
var hasTestCaseEditor = "true" == "${hasTestCaseEditor}"
var hasTestCaseViewer = "true" == "${hasTestCaseViewer}"
var hasTraceLogEditor = "true" == "${hasTraceLogEditor}"
var hasTraceLogViewer = "true" == "${hasTraceLogViewer}"

</script>