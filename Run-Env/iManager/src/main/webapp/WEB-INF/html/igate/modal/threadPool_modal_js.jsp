<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('threadPool') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.threadPoolId",
      'name' : "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
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
          threadPoolId : null
        }
      },
      methods : {
        search : function()
        {
          vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
          vmList.makeGridObj.search(this) ;
        },
        initSearchArea : function()
        {

          this.pageSize = '10' ;
          this.object.threadPoolId = null ;

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
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
          searchUri : "<c:url value='/igate/threadPool/searchPopup.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "threadPoolId",
            header : "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left"
          }, {
            name : "rejectPolicy",
            label : "<fmt:message>igate.threadPool.rejectPolicy</fmt:message>",
            align : "left"
          }, {
            name : "threadMin",
            label : "<fmt:message>igate.threadPool.min</fmt:message>",
            align : "left"
          }, {
            name : "threadMax",
            label : "<fmt:message>igate.threadPool.max</fmt:message>",
            align : "left"
          }, {
            name : "threadIdle",
            label : "<fmt:message>igate.threadPool.idle</fmt:message>",
            align : "left"
          }, {
            name : "threadThreshold",
            label : "<fmt:message>igate.threadPool.threshold</fmt:message>",
            align : "left"
          }]
        }) ;
      }
    }) ;
  }) ;
</script>