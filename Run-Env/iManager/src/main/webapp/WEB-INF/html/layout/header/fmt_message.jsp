<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<script type="text/javascript">
/* days Of Week */
var weekMon = "<fmt:message>head.monday</fmt:message>";
var weekThes = "<fmt:message>head.tuesday</fmt:message>";
var weekWednes = "<fmt:message>head.wednesday</fmt:message>";
var weekThur = "<fmt:message>head.thursday</fmt:message>";
var weekFri = "<fmt:message>head.friday</fmt:message>";
var weekSatur = "<fmt:message>head.saturday</fmt:message>";
var weekSun = "<fmt:message>head.sunday</fmt:message>";

/* month Names */
var monthJanuary = "<fmt:message>head.january</fmt:message>";
var monthFebruary = "<fmt:message>head.february</fmt:message>";
var monthMarch = "<fmt:message>head.march</fmt:message>";
var monthApril = "<fmt:message>head.april</fmt:message>";
var monthMay = "<fmt:message>head.may</fmt:message>";
var monthJune = "<fmt:message>head.june</fmt:message>";
var monthJuly = "<fmt:message>head.july</fmt:message>";
var monthAugust = "<fmt:message>head.august</fmt:message>";
var monthSeptember = "<fmt:message>head.september</fmt:message>";
var monthOctober = "<fmt:message>head.october</fmt:message>";
var monthNovember = "<fmt:message>head.november</fmt:message>";
var monthDecember = "<fmt:message>head.december</fmt:message>";

/* button */
var okBtn = "<fmt:message>head.ok</fmt:message>";
var closeBtn = "<fmt:message>head.close</fmt:message>";
var cancelBtn = "<fmt:message>head.cancel</fmt:message>";
var searchBtn = "<fmt:message>head.search</fmt:message>";

/* msg */
var validateToken = "<fmt:message>head.validateToken</fmt:message>";
var loadDataWarn = "<fmt:message>head.error.load.data.warn</fmt:message>";
var totalCountLabel = function(value) {
	return '<fmt:message key="head.totalCount"><fmt:param value="'+ numberWithComma(value) +'"/></fmt:message>'
};
	
/* time Names */
var timeHour = "<fmt:message>igate.hours.before</fmt:message>";
var timeMinute = "<fmt:message>igate.minutes.before</fmt:message>";
var timeSecond = "<fmt:message>igate.seconds.before</fmt:message>";

/* message */
var messageSessionExpired = "<fmt:message>igate.session.expired</fmt:message>";

</script>