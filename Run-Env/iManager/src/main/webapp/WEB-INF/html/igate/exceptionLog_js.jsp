<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('exceptionLog') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
       'type' : "daterange",
       'mappingDataInfo': {
        	'daterangeInfo': [
         	{'id' :  'searchDateFrom', 'name' : "<fmt:message>head.from</fmt:message>"},
         	{'id' :  'searchDateTo', 'name' : "<fmt:message>head.to</fmt:message>"},
       	]
       }	
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/instance.html',
        'modalTitle' : '<fmt:message>igate.instance</fmt:message>',
        'vModel' : "object.instanceId",
        'callBackFuncName' : 'setSearchInstanceId'
      },
      'name' : "<fmt:message>igate.instance</fmt:message><fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.transactionId",
      'name' : "<fmt:message>igate.exceptionLog.transactionId</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.exceptionCode",
      'name' : "<fmt:message>igate.exceptionCode</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/interface.html',
        'modalTitle' : '<fmt:message>igate.interface</fmt:message>',
        'vModel' : "object.interfaceId",
        'callBackFuncName' : 'setSearchInterfaceId'
      },
      'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.adapterId",
        'callBackFuncName' : 'setSearchAdapterId'
      },
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/connector.html',
        'modalTitle' : '<fmt:message>igate.connector</fmt:message>',
        'vModel' : "object.connectorId",
        'callBackFuncName' : 'setSearchConnectorId'
      },
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      downloadBtn : true,
      refreshArea : true,
      searchInitBtn : true,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.pk.exceptionDateTime",
          'name' : "<fmt:message>igate.exceptionLog.exceptionDateTime</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.exceptionId",
          'name' : "<fmt:message>igate.exceptionLog</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.exceptionCode",
          'name' : "<fmt:message>igate.exceptionCode</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.transactionId",
          'name' : "<fmt:message>igate.exceptionLog.transactionId</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.adpaterId",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.interfaceId",
          'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.instanceId",
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.messageId",
          'name' : "<fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.connectorId",
          'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.activityId",
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.exceptionText",
          'name' : "<fmt:message>igate.exceptionLog.exceptionText</fmt:message>",
          'height' : 100
        }, ]
      }, ]
    }, {
      'type' : 'custom',
      'id' : 'Details',
      'name' : '<fmt:message>igate.exceptionLog.exceptionStack</fmt:message>',
      'isSubResponsive' : true,
      'getDetailArea' : function()
      {
        return $("#exceptionStackCt").html() ;
      }
    }, ]) ;

    createPageObj.setPanelButtonList(null) ;

    createPageObj.panelConstructor(true) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/exceptionLog/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/exceptionLog/control.json'/>"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          instanceId : null,
          transactionId : null,
          toExceptionDateTime : '',
          fromExceptionDateTime : '',
          interfaceId : null,
          adapterId : null,
          connectorId : null,
          exceptionCode : null,
          pk : {}
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
            this.object.instanceId = null ;
            this.object.transactionId = null ;
            this.object.toExceptionDateTime = '' ;
            this.object.fromExceptionDateTime = '' ;
            this.object.interfaceId = null ;
            this.object.adapterId = null ;
            this.object.connectorId = null ;
            this.object.exceptionCode = null ;
          }

          var ImngSearchObjectElement = $('#' + createPageObj.getElementId('ImngSearchObject'));
          
          initSelectPicker(ImngSearchObjectElement.find('#pageSize'), this.pageSize) ;
          initDatePicker(this, ImngSearchObjectElement.find('#searchDateFrom'), ImngSearchObjectElement.find('#searchDateTo')) ;

          this.$forceUpdate() ;
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchInstanceId : function(param)
        {
          this.object.instanceId = param.instanceId ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.adapterId = param.adapterId ;
        },
        setSearchInterfaceId : function(param)
        {
          this.object.interfaceId = param.interfaceId ;
        },
        setSearchConnectorId : function(param)
        {
          this.object.connectorId = param.connectorId ;
        },
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
        timerSeconds : 60,
        displayTimerSeconds : 60,
        timerSecondsList : [10, 20, 30, 40, 50, 60],
        isStartRefresh : false,
        refreshIntervalId : null,
        newTabPageUrl: "<c:url value='/igate/exceptionLog.html' />"
      },
      methods : $.extend(true, {}, listMethodOption, {
        initSearchArea : function()
        {
          window.vmSearch.initSearchArea() ;
        },
        downloadFile : function()
        {
          var gridObj = this.makeGridObj.getSearchGrid() ;

          var csvData = '' ;

          csvData += '<fmt:message>head.from</fmt:message>, ' + window.vmSearch.object.fromExceptionDateTime + '\r\n' ;
          csvData += '<fmt:message>head.to</fmt:message>, ' + window.vmSearch.object.toExceptionDateTime + '\r\n' ;
          csvData += '<fmt:message>igate.instance</fmt:message><fmt:message>head.id</fmt:message>, ' + ((null == window.vmSearch.object.instanceId) ? '' : window.vmSearch.object.instanceId) + '\r\n' ;
          csvData += '<fmt:message>igate.exceptionLog.transactionId</fmt:message>, ' + ((null == window.vmSearch.object.transactionId) ? '' : window.vmSearch.object.transactionId) + '\r\n' ;
          csvData += '<fmt:message>igate.exceptionCode</fmt:message>, ' + ((null == window.vmSearch.object.exceptionCode) ? '' : window.vmSearch.object.exceptionCode) + '\r\n' ;
          csvData += '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>, ' + ((null == window.vmSearch.object.interfaceId) ? '' : window.vmSearch.object.interfaceId) + '\r\n' ;
          csvData += '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>, ' + ((null == window.vmSearch.object.adapterId) ? '' : window.vmSearch.object.adapterId) + '\r\n' ;
          csvData += '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>, ' + ((null == window.vmSearch.object.connectorId) ? '' : window.vmSearch.object.connectorId) + '\r\n' ;
          csvData += '<fmt:message>igate.page.num</fmt:message>, ' + $('#' + createPageObj.getElementId('ImngSearchGrid')).find('.ImngSearchGridPagination').find('.active').text() + '\r\n\r\n' ;

          gridObj.getColumns().forEach(function(column, index)
          {
            csvData += ((0 == index) ? '' : ',') + column.header ;
          }) ;

          csvData += '\r\n' ;

          gridObj.getData().forEach(function(dataObj)
          {
            gridObj.getColumns().forEach(function(column, index)
            {
              csvData += ((0 == index) ? '' : ',') + ((null == dataObj[column.name]) ? '' : ' ' + dataObj[column.name]) ;
            }) ;
            csvData += '\r\n' ;
          }) ;

          downloadCSV('<fmt:message>igate.exceptionLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_' + Date.now(), csvData) ;
        },
        refresh : function()
        {
          this.isStartRefresh = !this.isStartRefresh ;

          if (this.isStartRefresh)
          {
            this.displayTimerSeconds = this.timerSeconds ;

            this.refreshIntervalId = setInterval(function()
            {
              if (0 == $("#" + createPageObj.getElementId('ImngListObject')).length)
              {
                clearInterval(this.refreshIntervalId) ;
                return ;
              }

              if (0 >= this.displayTimerSeconds)
              {
                this.displayTimerSeconds = this.timerSeconds ;
                window.vmSearch.search() ;
              }
              else
              {
                --this.displayTimerSeconds ;
              }
            }.bind(this), 1000) ;
          }
          else
          {
            clearInterval(this.refreshIntervalId) ;
          }
        }
      }),
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/exceptionLog/search.json'/>",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "instanceId",
            header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "8%"
          }, {
            name : "exceptionCode",
            header : "<fmt:message>igate.exceptionCode</fmt:message>",
            align : "left",
            width: "8%"
          }, {
            name : "transactionId",
            header : "<fmt:message>igate.exceptionLog.transactionId</fmt:message>",
            align : "left",
            width: "16%"
          }, {
            name : "pk.exceptionId",
            header : "<fmt:message>igate.exceptionLog</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "16%"
          }, {
            name : "interfaceId",
            header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "10%"
          }, {
            name : "adapterId",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "15%"
          }, {
            name : "connectorId",
            header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "15%"
          },
          {
            name : "pk.exceptionDateTime",
            header : "<fmt:message>igate.exceptionLog.exceptionDateTime</fmt:message>",
            align : "center",
            width: "12%"
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
          pk : {}
        },
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.exceptionDateTime' : this.object.pk.exceptionDateTime,
            'pk.exceptionId' : this.object.pk.exceptionId
          } ;
        }
      },
      methods : {
        loaded : function()
        {
          window.vmDetails.object = this.object ;
        },
        goDetailPanel : function()
        {
          panelOpen('detail') ;
        },
        initDetailArea : function()
        {
          this.object.pk.exceptionDateTime = null ;
          this.object.pk.exceptionId = null ;
          this.object.exceptionCode = null ;
          this.object.transactionId = null ;
          this.object.adpaterId = null ;
          this.object.interfaceId = null ;
          this.object.instanceId = null ;
          this.object.messageId = null ;
          this.object.connectorId = null ;
          this.object.activityId = null ;
          this.object.exceptionText = null ;
        }
      }
    }) ;

    window.vmDetails = new Vue({
      el : '#Details',
      data : {
        viewMode : 'Open',
        object : {
          pk : {}
        }
      }
    }) ;
  }) ;

  function initDatePicker(vueObj, dateFromSelector, dateToSelector) {
	  dateFromSelector.customDateRangePicker('from', function(fromTime) {
		  vueObj.object.fromExceptionDateTime = fromTime;

		  dateToSelector.customDateRangePicker('to', function(toTime) {
			  vueObj.object.toExceptionDateTime = toTime;
		  }, {startDate: vueObj.object.toExceptionDateTime, minDate: fromTime});
	  }, {startDate: vueObj.object.fromExceptionDateTime});
  }
</script>