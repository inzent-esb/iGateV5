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

    createPageObj.setViewName('activityModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.activityId",
      'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.activityType",
        'optionFor' : 'option in activityTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'activityTypes'
      },
      'name' : "<fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.activityDesc",
      'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      totalCount: true,
    }) ;

    createPageObj.mainConstructor() ;
<%-- grid init --%>
  PropertyImngObj.getProperties('List.Activity.ActivityType', true, function(activityTypes)
    {

      var vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            activityId : null,
            activityDesc : null
          }
        },
        methods : {
          search : function()
          {
        	vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
        	vmList.makeGridObj.search(this, function() {
                $.ajax({
                    type : "GET",
                    url : "<c:url value='/igate/activity/rowCount.json' />",
                    data: JsonImngObj.serialize(this.object),
                    processData : false,
                    success : function(result) {
                        vmList.totalCount = result.object;
                    }
                });
            }.bind(this));
          },
          initSearchArea : function()
          {

            this.pageSize = '10' ;
            this.object.activityId = null ;

            this.object.activityDesc = null ;

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;

            if (modalParam && modalParam.activityType)
            {

              this.object.activityType = modalParam.activityType ;

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes'), this.object.activityType) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes').prop('disabled', true) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes').selectpicker('refresh') ;

            }
            else
            {
              this.object.activityType = " " ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes'), this.object.activityType) ;
            }
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.activityTypes = activityTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          totalCount: '0',
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
            searchUri : "<c:url value='/igate/activity/searchPopup.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "activityId",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left"
            }, {
              name : "activityName",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.name</fmt:message>",
              align : "left"
            }, {
              name : "activityType",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "center",
              formatter : function(value)
              {
                if (value.row.activityType == "F")
                  return "<fmt:message>igate.activity.type.control</fmt:message>" ;
                else if (value.row.activityType == "A")
                  return "<fmt:message>igate.activity.type.activity</fmt:message>" ;
                else if (value.row.activityType == "S")
                  return "<fmt:message>igate.activity.type.service</fmt:message>" ;
                else if (value.row.activityType == "C")
                  return "<fmt:message>igate.activity.type.codec</fmt:message>" ;
                else if (value.row.activityType == "T")
                  return "<fmt:message>igate.activity.type.transform</fmt:message>" ;
                else if (value.row.activityType == "I")
                  return "<fmt:message>igate.activity.type.internal</fmt:message>" ;
                else if (value.row.activityType == "H")
                    return "<fmt:message>igate.activity.type.telegram.handler</fmt:message>" ;                  
              }
            }, {
              name : "activityDesc",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.description</fmt:message>",
              align : "left"
            }]
          }) ;
        }
      }) ;
    }) ;
  })
</script>