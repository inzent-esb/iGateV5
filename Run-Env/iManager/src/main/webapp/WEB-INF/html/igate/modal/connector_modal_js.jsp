<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('connectorModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.connectorId",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.connectorName",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.connectorType",
        'optionFor' : 'option in connectorTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'connectorTypes'
      },
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.connectorDesc",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      totalCount: true,
    }) ;

    createPageObj.mainConstructor() ;
<%-- grid init --%>
  PropertyImngObj.getProperties('List.Connector.Type', true, function(connectorTypes)
    {

      var vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            connectorType : " ",
            connectorId : null,
            connectorName : null,
            connectorDesc : null,
          },
          connectorTypes : [],
        },
        methods : {
          search : function()
          {
        	vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
        	vmList.makeGridObj.search(this, function() {
                $.ajax({
                    type : "GET",
                    url : "<c:url value='/igate/connector/rowCount.json' />",
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
            this.object.connectorId = null ;
            this.object.connectorName = null ;
            this.object.connectorDesc = null ;
            this.object.connectorType = ' ' ;

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorTypes'), this.object.connectorType) ;
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.connectorTypes = connectorTypes ;
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
            searchUri : "<c:url value='/igate/connector/searchPopup.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "connectorId",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left"
            }, {
              name : "connectorName",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>",
              align : "left"
            }, {
              name : "connectorDesc",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>",
              align : "left"
            }]
          }) ;
        }
      }) ;
    }) ;
  }) ;
</script>