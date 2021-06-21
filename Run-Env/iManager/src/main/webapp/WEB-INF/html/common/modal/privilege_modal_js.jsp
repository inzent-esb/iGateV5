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

    createPageObj.setViewName('privilegeModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.privilegeId",
      'name' : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.privilegeDesc",
      'name' : "<fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.privilegeType",
        'optionFor' : 'option in privilegeTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'privilegeTypes'
      },
      'name' : "<fmt:message>common.privilege.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true
    }) ;

    createPageObj.mainConstructor() ;
<%-- grid init --%>
  PropertyImngObj.getProperties('List.Privilege.Type', true, function(privilegeTypes)
    {

      var vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            privilegeType : " ",
            privilegeId : null,
            privilegeDesc : null
          },
          privilegeTypes : []
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
            this.object.privilegeId = null ;
            this.object.privilegeDesc = null ;

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;

            if (modalParam && modalParam.privilegeType)
            {
              this.object.privilegeType = modalParam.privilegeType ;

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#privilegeTypes'), this.object.privilegeType) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#privilegeTypes').prop('disabled', true) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#privilegeTypes').selectpicker('refresh') ;
            }
            else
            {
              this.object.privilegeType = ' ' ;

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#privilegeTypes'), this.object.privilegeType) ;
            }
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.privilegeTypes = privilegeTypes ;
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
            searchUri : "<c:url value='/common/privilege/searchPopup.json' />",
            rowHeaders : ($('#' + popupId).data('isMultiCheck')) ? ['rowNum', 'checkbox'] : [],
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "privilegeId",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left"
            }, {
              name : "privilegeType",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "left",
              formatter : function(value)
              {
                if (value.row.privilegeType == "S")
                  return "<fmt:message>common.privilege.type.system</fmt:message>" ;
                else if (value.row.privilegeType == "b")
                  return "<fmt:message>common.privilege.type.business</fmt:message>" ;
              }
            }, {
              name : "privilegeDesc",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.description</fmt:message>",
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
  }) ;
</script>