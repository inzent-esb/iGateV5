//라인차트
const info = {
	lineChartTimeDuration: 5, //라인차트 > X축 범위(분단위)
	lineChartDrawDataCycle: 7500, //라인차트 > 점과 점사이의 간격 (초단위)

	//응답분포차트
	//응답분포차트 > X축 범위(분단위)
	xViewChartTimeDuration: 5, 
	//응답분포차트 > 기본 Y축 최대값
	xViewDefaultYAxisMax: 5000,
	//응답분포차트 > 기본 데이터 표현 투명도
	xViewDefaultTrans: 1.0, 
	//응답분포차트 > 기본 데이터 표현 최소값
	xViewDefaultxMinData: 10, 
	//응답분포차트 > CSV 최대 출력 건수
	xViewMaxExportCnt: 100000, 

	//인스턴스 요약 차트 > 한 행의 인스턴스 개수
	instanceSummaryDefaultColCnt: 10, 

	//트랜잭션 TOP N 차트 > 조회될 행의 개수
	datatableDefaultRowCnt: 5, 

	//대상 동기화 시간.
	targetSyncRefreshStandardTime: 60 * 1000,

	//알림창 가로 크기
	noticeAreaWidth: 1048,

	//알림창 세로 크기
	noticeAreaHeight: 250,

	//알림 최대 개수
	//var noticeMaxCnt: 100,

	//알림 최대 유지 시간 (초)
	noticeDataHoldingTime: 20,

	//알림 임시 종료 유지 시간 (초)
	noticeTemporaryCloseStartTime: 10,

	//알림 > 알림시간
	noticeDateTimeColWidth: '20%',
	//알림 > 인스턴스 ID
	noticeInstanceIdColWidth: '12%',
	//알림 > 메시지
	noticeMessageColWidth: '60%',
	//알림 > 상태
	noticeStatusColWidth: '8%',

	//편집 모드 > 컨테이너 상태 저장 갯수
	containerStateCnt: 100,

	//차트 COLOR
	COLORS: [
		'#7977C2', '#7BBAE7', '#FFC000', '#FF7800', '#87BB66', '#1DA8A0',
		'#929292', '#555D69', '#0298D5', '#FA5559', '#F5A397', '#06D9B6',
		'#C6A9D9', '#6E6AFC', '#E3E766', '#C57BC3', '#DF328B', '#96D7EB',
		'#839CB5', '#9228E4',
	],

	//이벤트 이력 갯수
	noticeDataHistoryListMaxCnt: 100,

	//data 수집 간격
	dataIntervalSeconds: 5,		
};