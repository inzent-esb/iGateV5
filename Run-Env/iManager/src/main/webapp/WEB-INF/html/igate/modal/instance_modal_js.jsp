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

    createPageObj.setViewName('instanceModal') ;
    createPageObj.setIsModal(true) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.instanceId",
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.instanceNode",
      'name' : "<fmt:message>igate.instance.node</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.instanceType",
        'optionFor' : 'option in instanceTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'instanceTypes'
      },
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true
    }) ;

    createPageObj.mainConstructor() ;
<%-- grid init --%>
  PropertyImngObj.getProperties('List.Instance.InstanceType', true, function(instanceTypes)
    {

      var vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            instanceId : null,
            instanceNode : null,
            instanceType : " "
          },
          instanceTypes : []
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
            this.object.instanceId = null ;
            this.object.instanceNode = null ;

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;

            if (modalParam && modalParam.instanceType)
            {

              this.object.instanceType = modalParam.instanceType ;

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.object.instanceType) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes').prop('disabled', true) ;

              $('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes').selectpicker('refresh') ;

            }
            else
            {
              this.object.instanceType = ' ' ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.object.instanceType) ;
            }
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.instanceTypes = instanceTypes ;
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
            searchUri : "<c:url value='/igate/instance/searchPopup.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "instanceId",
              header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left"
            }, {
              name : "instanceType",
              header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "left",
              formatter : function(value)
              {
                switch (value.row.instanceType)
                {
                case 'T' : {
                  return "<fmt:message>igate.instance.type.trx</fmt:message>" ;
                }
                case 'A' : {
                  return "<fmt:message>igate.instance.type.adm</fmt:message>" ;
                }
                case 'L' : {
                  return "<fmt:message>igate.instance.type.log</fmt:message>" ;
                }
                case 'M' : {
                  return "<fmt:message>igate.instance.type.mnt</fmt:message>" ;
                }
                }
              }
            }, {
              name : "instanceAddress",
              header : "<fmt:message>igate.instance.address</fmt:message>",
              align : "left"
            }, {
              name : "instanceNode",
              header : "<fmt:message>igate.instance.node</fmt:message>",
              align : "left"
            }],
          }) ;
        }
      }) ;
    }) ;
  }) ;
</script>