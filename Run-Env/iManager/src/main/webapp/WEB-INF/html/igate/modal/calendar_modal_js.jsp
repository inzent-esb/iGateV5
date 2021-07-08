<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('calendarModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.calendarId",
      'name' : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.calendarName",
      'name' : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.calendarDesc",
      'name' : "<fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true
    }) ;

    createPageObj.mainConstructor() ;

    var vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          calendarId : null,
          calendarName : null,
          calendarDesc : null,
          holidayYear : null
        },
        messageLocales : []
      },
      methods : {
        search : function()
        {
          if ('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display'))
          {
            $('#' + createPageObj.getElementId('ImngListObject')).show() ;
            $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide() ;
          }

          vmList.makeGridObj.search(this) ;
        },
        initSearchArea : function()
        {

          this.pageSize = '10' ;
          this.object.calendarId = null ;
          this.object.calendarName = null ;
          this.object.calendarDesc = null ;
          this.object.holidayYear = null ;

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
          initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDaterange')) ;
        }
      },
      mounted : function()
      {
        this.initSearchArea() ;
      }
    }) ;

    var vmList = new Vue({
      el : '#' + createPageObj.getElementId('ImngListObject'),
      data : {
        makeGridObj : null,
      },
      methods : {
        initSearchArea : function()
        {
          vmSearch.initSearchArea() ;
        },
      },
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          isModal : true,
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : function(loadParam)
          {

            startSpinner() ;

            $("#" + popupId).data('callBackFunc')(loadParam) ;

            $("#" + popupId).find('#modalClose').trigger('click') ;
          },
          searchUri : "<c:url value='/igate/calendar/searchPopup.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "calendarId",
            header : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left"
          }, {
            name : "calendarName",
            header : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left"
          }, {
            name : "calendarDesc",
            header : "<fmt:message>head.description</fmt:message>",
            align : "left"
          }, {
            name : "saturdayYn",
            header : "<fmt:message>igate.calendar.saturday</fmt:message>",
            align : "left"
          }, {
            name : "sundayYn",
            header : "<fmt:message>igate.calendar.sunday</fmt:message>",
            align : "left"
          }]
        }) ;
      }
    }) ;

    function initDatePicker(vueObj, dateRangeSelector)
    {
      dateRangeSelector.customDatePicker(dateRangeSelector, function(time)
      {
        vueObj.object.holidayYear = time ;
      }) ;
    }
  }) ;
</script>