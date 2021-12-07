<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,shrink-to-fit=no" />
<sec:csrfMetaTags />

<!-- favicon -->
<link rel="icon" href="<c:url value='/img/favicon.png' />" />

<!-- css block -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap-select.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/daterangepicker.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery-ui-timepicker-addon.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/tui-grid.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/tree.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/tui-pagination.css' />">

<!-- js block -->
<script type="text/javascript" src="<c:url value='/js/jquery.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap.bundle.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap-select.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/inzent-esb.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui-timepicker-addon.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui-timepicker-addon-i18n.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui-timepicker-addon-i18n-ext.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/vue.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/tui-code-snippet.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/tui-pagination.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/tui-grid.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/moment.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/daterangepicker.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/daterangepicker_custom.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/imanager_vue.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/cytoscape.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/xml2json.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/aes.js' />"></script>

<%@ include file="authorize_js.jsp"%>
<%@ include file="fmt_message_js.jsp"%>

<title>${_title}</title>

<script type="text/javascript">
  var contextPath = "<%=request.getContextPath()%>" ;

  PropertyImngObj.setConfig(
  {
    contextRoot : '${pageContext.request.contextPath}'
  }) ;

  $(window).ready(function()
  {
    if (!window.name.match(/^GUID-/))
    {
      var GUID = function()
      {
        var S4 = function()
        {
          return (Math.floor(mathRandom() * 0x10000).toString(16)) ;
        }

        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4()) ;
      }

      window.name = "GUID-" + GUID() ;
    }

    var format =
    {
      timeFormat : 'HH:mm:ss',
      timeInput : true
    } ;

    var region = $.timepicker.regional[navigator.language || navigator.userLanguage] ;

    if (undefined != region)
    {
      $.extend(region, format) ;
      $.timepicker.setDefaults(region) ;
    }
    else
    {
      $.timepicker.setDefaults(format) ;
    }
  }) ;

  $(document).ready(function()
  {
    $.ajaxSetup(
    {
      beforeSend : function(xhr)
      {
        var token = $("meta[name='_csrf']").attr("content") ;
        var header = $("meta[name='_csrf_header']").attr("content") ;

        if (header)
          xhr.setRequestHeader(header, token) ;

        xhr.setRequestHeader("X-IMANAGER-WINDOW", window.name) ;
      }
    }) ;

    $('[data-toggle="tooltip"]').tooltip() ;
  }) ;

  function startSpinner(spinnerMode)
  {
    $("#spinnerDiv").width(('full' == spinnerMode)? '100%' : $("#ct").outerWidth(true)).height('100%').show() ;
    $("#spinnerDiv").removeData('spinnerMode');
    $("#spinnerDiv").data('spinnerMode', spinnerMode);
  }

  function stopSpinner(callbackFunc)
  {
    setTimeout(function()
    {
      $("#spinnerDiv").hide(0, function() {
    	  if(callbackFunc)
    		  callbackFunc();  
      }) ;
    }, 350) ;
  }
</script>

<div id="spinnerDiv" style="position: absolute; width: 100%; height: 100%; z-index: 9999; right: 0px; display: none;">
	<div class="spinnerBg" style="width: 100%; height: 100%; background-color: #000; opacity: 0.6;"></div>
	<div class="spinner"></div>
</div>

<input type="hidden" id="_client_mode" value="${_client_mode}">