<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('interfacePolicy') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.pk.adapterId",
        'callBackFuncName' : 'setSearchAdapterId'
      },
      'name' : "<fmt:message>igate.interface.adapter</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasInterfacePolicyEditor,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/adapter.html',
            'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
            'vModel' : "object.pk.adapterId",
            'callBackFuncName' : 'setSearchAdapterId'
          },
          'name' : "<fmt:message>igate.interface.adapter</fmt:message>",
          isPk : true
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.pk.interfaceType',
            'optionFor' : 'option in interfaceTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.type</fmt:message>",
          isPk : true
        }]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/operation.html',
            'modalTitle' : '<fmt:message>igate.operation</fmt:message>',
            'vModel' : "object.operationId",
            'callBackFuncName' : 'setSearchOperationId'
          },
          'name' : "<fmt:message>igate.interface.operation</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.instanceId',
            'optionFor' : 'elm in instances',
            'optionValue' : 'elm.instanceId',
            'optionText' : 'elm.instanceId'
          },
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>"
        }]
      }]
    }]) ;

    createPageObj.setPanelButtonList({
      dumpBtn : hasInterfacePolicyEditor,
      removeBtn : hasInterfacePolicyEditor,
      goModBtn : hasInterfacePolicyEditor,
      saveBtn : hasInterfacePolicyEditor,
      updateBtn : hasInterfacePolicyEditor,
      goAddBtn : hasInterfacePolicyEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/interfacePolicy/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/interfacePolicy/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          pk : {
            adapterId : null
          }
        },
      },
      methods : {
        search : function()
        {
          vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
          vmList.makeGridObj.search(this) ;
        },
        initSearchArea : function(searchCondition)
        {
          if(searchCondition)
          {
            for(var key in searchCondition) 
            {
        	  this.$data[key] = searchCondition[key];
            }        	  
          }	  
          else
          {
            this.pageSize = '10' ;
            this.object.pk.adapterId = null ;        	  
          }	  

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.pk.adapterId = param.adapterId ;
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
        newTabPageUrl: "<c:url value='/igate/interfacePolicy.html' />"
      },
      methods : $.extend(true, {}, listMethodOption, {
        initSearchArea : function()
        {
          window.vmSearch.initSearchArea() ;
        }
      }),
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/interfacePolicy/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "pk.adapterId",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "28%",
          }, {
            name : "pk.interfaceType",
            header : "<fmt:message>head.type</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "center",
            width: "16%",
            formatter : function(value)
            {
              if (value.row['pk.interfaceType'] == "DB")
                return "<fmt:message>head.db</fmt:message>" ;
              else if (value.row['pk.interfaceType'] == "File")
                return "<fmt:message>head.file</fmt:message>" ;
              else if (value.row['pk.interfaceType'] == "Online")
                return "<fmt:message>head.online</fmt:message>" ;
            }
          }, {
            name : "operationId",
            header : "<fmt:message>igate.operation</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "28%",
          }, {
            name : "instanceId",
            header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "28%",
          }]
        }) ;

        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
        
        this.newTabSearchGrid();
      }
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          operationId : null,
          pk : {
            adapterId : null,
            interfaceType : null
          }
        },
        interfaceTypes : [],
        instances : [],
        uri : "<c:url value='/igate/instance/list.json' />",
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.adapterId' : this.object.pk.adapterId,
            'pk.interfaceType' : this.object.pk.interfaceType
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Interface.InterfaceType', true, function(properties)
        {
          this.interfaceTypes = properties ;
        }.bind(this)) ;
      },
      mounted : function()
      {
        $.getJSON(this.uri, function(data)
        {
          this.instances = data.object ;
      	this.instances.unshift(" ");

        }.bind(this)) ;
      },
      methods : {
        goDetailPanel : function()
        {
          panelOpen('detail') ;
        },
        initDetailArea : function(object)
        {
          if (object)
          {
            this.object = object ;
          }
          else
          {
            this.object.operationId = null ;
            this.object.instanceId = null ;
            this.object.pk.adapterId = null ;
            this.object.pk.interfaceType = null;
          }
        },
        openModal : function(openModalParam)
        {

          if ('/igate/operation.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              operationType : 'I'
            } ;
          }

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.pk.adapterId = param.adapterId ;
        },
        setSearchOperationId : function(param)
        {
          this.object.operationId = param.operationId ;
        }
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>