<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/html/layout/header/fmt_message.jsp"%>

<c:set var="serverName" value="<%= request.getServerName() %>" />
<c:set var="serverPort" value="<%= request.getServerPort() %>" />
<c:set var="contextPath" value="<%= request.getContextPath() %>" />
<c:set var="prefixUrl" value="//${serverName}:${serverPort}${contextPath}" />
<c:set var="prefixFileUrl" value="${prefixUrl}/custom" /> <%-- css/fonts/img/js 경로 --%>

<link rel="stylesheet" type="text/css" href="${prefixFileUrl}/css/common-external.css">

<script type="text/javascript">
var windowId = null;

var failMessage = '<fmt:message>head.fail.notice</fmt:message>';

var prefixUrl = '${prefixUrl}';

var scriptInfoArr = [
	{'url': "/js/vue.min.js"},
 	{'url': "/js/tui-code-snippet.js"}, 
 	{'url': "/js/tui-pagination.js"}, 
 	{'url': "/js/tui-grid.min.js"},
 	{'url': "/js/aes.js"},
 	{'url': "/js/moment.min.js"},
 	{'url': "/js/daterangepicker.min.js"},
 	{'url': "/js/cytoscape.min.js"},
 	{'url': "/js/xml2json.js"},
 	{'url': "/js/polyfill.js"},
 	{'url': "/js/httpReq.js"},
 	{'url': "/js/constants.js" },
 	{'url': "/js/resize.js"},
 	{'url': "/js/utils.js"},
 	{'url': "/js/modal.js"},
 	{'url': "/js/daterangepicker_custom.js"},
 	{'url': "/js/xlsx.full.min.js"},
 	
 	{'url': "/js/jquery-ui-timepicker-addon.min.js"},
 	{'url': "/js/jquery-ui-timepicker-addon-i18n.min.js"},
 	{'url': "/js/jquery-ui-timepicker-addon-i18n-ext.js"},
 	 	
 	{'url': "/js/page-config.js"},
 	{'url': "/js/page-actions.js"}
];

if(0 == $('script[src$="' + scriptInfoArr[0].url + '"]').length) {	
	makeScript(0);
}

function makeScript(idx) {
	var scriptInfo = scriptInfoArr[idx];
	
	var script = document.createElement('script');
	script.type = "text/javascript";
	script.src = "${prefixFileUrl}" + scriptInfo.url;
	
	document.querySelector('#ct').appendChild(script);
	
	script.addEventListener("load", function(event) {
		if (idx === scriptInfoArr.length - 1) {
			$('[data-ready]').each(function(index, element) {
				element.dispatchEvent(new CustomEvent('ready'));
				
				tui.Grid.applyTheme('clean', {
					row: {
						hover: {
							background: '#f5f6fb',
						},
					},
				});

				tui.Grid.setLanguage('en', {
					display: {
						noData: '<fmt:message>igate.noData</fmt:message>',
					},
				});					
			});
			
			if (2 == $('[data-ready]').children('.ct-header, .ct-content').length) {
				$('[data-ready]').children('.ct-content').height('calc(100% - ' + $('[data-ready]').children('.ct-header').outerHeight(true) +'px)');
			}
			
			windowId = 'GUID-' + getUUID();
		} else {
			makeScript(idx + 1);	
		}
	});
}
</script>