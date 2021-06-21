<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;

    var modalParam = $("#" + popupId).data('modalParam') ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('interfaceModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.interfaceId",
      'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.interfaceName",
      'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
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
          interfaceId : null,
          interfaceName : null
        }
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
          this.object.interfaceId = null ;
          this.object.interfaceName = null ;

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        }
      },
      mounted : function()
      {
        this.initSearchArea() ;
      },
      created : function()
      {
        if (modalParam && modalParam.searchAdapter)
        {
          this.object.adapterId = modalParam.searchAdapter ;
        }
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
          onClick : function(loadParam, ev)
          {
            if ($("#" + popupId).data('isMultiCheck'))
            {
              var searchGrid = this.makeGridObj.getSearchGrid() ;

              if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey))
              {
                searchGrid.uncheck(ev.rowKey) ;
                searchGrid.removeRowClassName(ev.rowKey, "row-selected") ;
              }
              else
              {
                searchGrid.check(ev.rowKey) ;
                searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
              }
            }
            else
            {
              startSpinner() ;
              $("#" + popupId).data('callBackFunc')(loadParam) ;
              $("#" + popupId).find('#modalClose').trigger('click') ;
            }
          }.bind(this),
          searchUri : "<c:url value='/igate/interface/searchPopup.json' />",
          rowHeaders : ($('#' + popupId).data('isMultiCheck')) ? ['rowNum', 'checkbox'] : [],
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "interfaceId",
            header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left"
          }, {
            name : "interfaceName",
            header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left"
          }, {
            name : "interfaceDesc",
            header : "<fmt:message>igate.interface</fmt:message><fmt:message>head.description</fmt:message>",
            align : "left"
          }, {
            name : "interfaceType",
            header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.type</fmt:message>",
            align : "left"
          }]
        }) ;
      }
    }) ;

    if ($("#" + popupId).data('isMultiCheck'))
    {
      $("#" + popupId).find('#modalConfirm').on('click', function()
      {
        $("#" + popupId).data('callBackFunc')(vmList.makeGridObj.getSearchGrid().getCheckedRows()) ;
        $("#" + popupId).find('#modalClose').trigger('click') ;
      }) ;
    }
  }) ;
</script>