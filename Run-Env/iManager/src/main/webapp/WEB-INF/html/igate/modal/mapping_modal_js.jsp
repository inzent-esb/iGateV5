<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('mappingModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.mappingId",
      'name' : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, ]) ;

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
          mappingId : null,
          pk : {}
        },
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
          this.object.mappingId = null ;

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
          searchUri : "<c:url value='/igate/mapping/searchPopup.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "mappingId",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left"
          }, {
            name : "mappingName",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left"
          }, {
            name : "mappingDesc",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.description</fmt:message>",
            align : "left"
          }, {
            name : "mappingType",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.type</fmt:message>",
            align : "left"
          }]
        }) ;
      }
    }) ;
  }) ;
</script>