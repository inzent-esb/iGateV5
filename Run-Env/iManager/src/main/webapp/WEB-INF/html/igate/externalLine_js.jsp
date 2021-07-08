<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('externalLine') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.externalLineId",
      'name' : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.externalLineName",
      'name' : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasExternalLineEditor,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : 'object.externalLineId',
          'name' : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.internalProcessManager',
          'name' : "<fmt:message>igate.externalLine.internalProcessManager</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.internalNetworkManager',
          'name' : "<fmt:message>igate.externalLine.internalNetworkManager</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.displayOrder',
          'name' : "<fmt:message>igate.externalLine.displayOrder</fmt:message>"
        }]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : 'object.externalLineName',
          'name' : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.name</fmt:message>",
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.externalProcessManager',
          'name' : "<fmt:message>igate.externalLine.externalProcessManager</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.externalNetworkManager',
          'name' : "<fmt:message>igate.externalLine.externalNetworkManager</fmt:message>"
        }]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.externalLineDesc",
          'name' : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.description</fmt:message>",
          'height' : 100
        }, ]
      }, ]
    }, {
      'type' : 'property',
      'id' : 'ExternalConnectors',
      'name' : '<fmt:message>igate.connector</fmt:message>',
      'addRowFunc' : 'addExternalConnector',
      'removeRowFunc' : 'removeExternalConnector(index)',
      'mappingDataInfo' : 'externalConnectors',
      'detailList' : [{
        'type' : "select",
        'mappingDataInfo' : {
          'selectModel' : 'elm.lineMode',
          'optionFor' : 'option in lineModes',
          'optionValue' : 'option.pk.propertyKey',
          'optionText' : 'option.propertyValue'
        },
        'name' : "<fmt:message>igate.externalLine.lineMode</fmt:message>"
      }, {
        'type' : 'search',
        'mappingDataInfo' : {
          'url' : '/igate/connector.html',
          'modalTitle' : '<fmt:message>igate.connector</fmt:message>',
          'vModel' : "elm.pk.connectorId",
          "callBackFuncName" : "setConnectorId"
        },
        'name' : '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>'
      }, ]
    }]) ;

    createPageObj.setPanelButtonList({
      removeBtn : hasExternalLineEditor,
      goModBtn : hasExternalLineEditor,
      saveBtn : hasExternalLineEditor,
      updateBtn : hasExternalLineEditor,
      goAddBtn : hasExternalLineEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/externalLine/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/externalLine/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          externalLineId : null,
          externalLineName : null
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
            this.object.externalLineId = null ;
            this.object.externalLineName = null ;        	  
          }	  

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchExternalLineId : function(param)
        {
          this.object.externalLineId = param.externalLineId ;
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
        newTabPageUrl: "<c:url value='/igate/externalLine.html' />"
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
          searchUri : "<c:url value='/igate/externalLine/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "externalLineId",
            header : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "40%",
          }, {
            name : "externalLineName",
            header : "<fmt:message>igate.externalLine</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "60%",
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
          externalLineId : null,
          externalConnectors : []
        },
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            externalLineId : this.object.externalLineId
          } ;
        }
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
            this.object.externalLineName = null ;
            this.object.internalNetworkManager = null ;
            this.object.internalProcessManager = null ;
            this.object.externalNetworkManager = null ;
            this.object.externalProcessManager = null ;
            this.object.displayOrder = null ;
            this.object.externalLineDesc = null ;
            this.object.externalLineId = null ;

            window.vmExternalConnectors.externalConnectors = [] ;
          }
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchExternalLineId : function(param)
        {
          this.object.externalLineId = param.externalLineId ;
        }
      }
    }) ;

    window.vmExternalConnectors = new Vue({
      el : '#ExternalConnectors',
      data : {
        viewMode : 'Open',
        lineModes : [],
        externalConnectors : []
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Connector.RequestDirection', true, function(properties)
        {
          this.lineModes = properties ;
        }.bind(this)) ;
      },
      methods : {
        openModal : function(openModalParam, selectedIndex)
        {
          if ('/igate/connector.html' == openModalParam.url)
          {
            openModalParam.modalParam = {} ;
          }

          this.selectedIndex = selectedIndex ;

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setConnectorId : function(param)
        {
          this.externalConnectors[this.selectedIndex].pk.connectorId = param.connectorId ;
          this.$forceUpdate() ;
        },
        addExternalConnector : function()
        {
          this.externalConnectors.push({
            linemode : '',
            pk : {
              connectorId : ''
            }
          }) ;
        },
        removeExternalConnector : function(index)
        {
          this.externalConnectors = this.externalConnectors.slice(0, index).concat(this.externalConnectors.slice(index + 1)) ;
        }
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>