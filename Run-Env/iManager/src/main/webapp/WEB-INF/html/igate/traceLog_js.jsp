<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  var traceLogTreeGrid = null ;

  $(document).ready(function()
  {

    traceLogTreeGrid = null ;

    var selectedRowTraceLog = null ;

    if (localStorage.getItem('selectedRowTraceLog'))
    {
      selectedRowTraceLog = JSON.parse(localStorage.getItem('selectedRowTraceLog')) ;
      localStorage.removeItem('selectedRowTraceLog') ;
    }

    var selectedRowDashboard = null ;

    if (localStorage.getItem('selectedRowDashboard'))
    {
      selectedRowDashboard = localStorage.getItem('selectedRowDashboard') ;
      localStorage.removeItem('selectedRowDashboard') ;
    }
    
    var selectedTransactionInfo = null ;

    if (localStorage.getItem('selectedTransactionInfo'))
    {
      selectedTransactionInfo = JSON.parse(localStorage.getItem('selectedTransactionInfo')) ;
      localStorage.removeItem('selectedTransactionInfo') ;
    }    

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('traceLog') ;
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
       'type' : "dateCalc",
       'mappingDataInfo': {
     	  'unit' : 'm',
     	  'id' :  'rangeTime', 
     	  'selectModel' : 'rangeTime',
     	  'changeEvt' : 'changeRangeTime',
     	  'optionFor' : 'time in rangeTimeList',
     	  'optionValue' : 'time',
     	  'optionText' : 'time',
     	 
        },
        'name' : "<fmt:message>head.from.time</fmt:message>",
        'placeholder' : "<fmt:message>head.unchecked</fmt:message>"
     }, {
      'type' : "text",
      'mappingDataInfo' : "object.transactionId",
      'name' : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.instanceId",
        'optionFor' : 'option in traceLogInstances',
        'optionValue' : 'option.instanceId',
        'optionText' : 'option.instanceId',
        'optionIf': 'option.instanceType == "T"',
        'id' : 'traceLogInstances',
      },
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
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
        'url' : '/igate/service.html',
        'modalTitle' : '<fmt:message>igate.service</fmt:message>',
        'vModel' : "object.serviceId",
        'callBackFuncName' : 'setSearchServiceId'
      },
      'name' : "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.remoteAddr",
      'name' : "<fmt:message>head.ip</fmt:message>",
      'placeholder' : "<fmt:message>head.searchIP</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.timeoutYn",
        'optionFor' : 'option in timeoutYns',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'timeoutYns',
      },
      'name' : "<fmt:message>head.timeoutYn</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.logCode",
      'name' : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      downloadBtn : true,
      searchInitBtn : true,
      totalCount: true,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'custom',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'noRowClass' : true,
      'getDetailArea' : function()
      {
        return $("#traceLog-panel").html() ;
      }
    }, {
      'type' : 'custom',
      'id' : 'MessageInfo',
      'name' : '<fmt:message>igate.traceLog.message.info</fmt:message>',
      'isSubResponsive' : true,
      'getDetailArea' : function()
      {
        return $("#messageInfoCt").html() ;
      }
    }, {
      'type' : 'tree',
      'id' : 'ModelInfo',
      'name' : '<fmt:message>head.model.info</fmt:message>',
    }, ]) ;

    createPageObj.panelConstructor(true) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/traceLog/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/traceLog/control.json'/>"
    }) ;

    $.getJSON("<c:url value='/igate/instance/list.json' />", function(data)
    {

      PropertyImngObj.getProperties('List.TraceLog.Yn', true, function(properties)
      {

        window.vmSearch = new Vue({
          el : '#' + createPageObj.getElementId('ImngSearchObject'),
          data : {
            pageSize : '10',
            object : {
              fromLogDateTime : null,
              toLogDateTime : null,
              adapterId : null,
              connectorId : null,
              interfaceId : null,
              serviceId : null,
              transactionId : null,
              remoteAddr : null,
              requestTimestamp : null,
              responseTimestamp: null,
              logCode : null,
              instanceId : " ",
              timeoutYn : " ",
              pk : {},
            },
            timeoutYns : [],
            traceLogInstances : [],
            rangeTime : 10,
            rangeTimeList : [1, 3, 5 ,10],
            isInitTraceLogInstances : false,
            uri : "<c:url value='/igate/instance/list.json' />",
          },
          methods : {
            search : function()
            {
              vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
              vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/igate/traceLog/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                        vmList.totalCount = numberWithComma(result.object);
	                    }
	                });
	            }.bind(this));
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
                this.object.fromLogDateTime = null ;
                this.object.toLogDateTime = null ;
                this.object.transactionId = null ;
                this.object.adapterId = null ;
                this.object.connectorId = null ;
                this.object.interfaceId = null ;
                this.object.serviceId = null ;
                this.object.remoteAddr = null ;
                this.object.requestTimestamp = null;
                this.object.responseTimestamp = null;
                this.object.logCode = null ;
                this.object.instanceId = " " ;
                this.object.timeoutYn = " " ;
                this.rangeTime = '10';    
                
                this.changeRangeTime('m');
              }	  
              
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#timeoutYns'), this.object.timeoutYn) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#traceLogInstances'), this.object.instanceId) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#rangeTime'), this.rangeTime) ;
              initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo')) ;

              this.$forceUpdate() ;
            },
            changeRangeTime : function(unit) {
	   			var startDate = new Date();
	          	startDate.setDate(startDate.getDate());
	          	startDate.setHours(startDate.getHours());
	          	startDate.setMinutes(startDate.getMinutes());
	        	startDate.setSeconds(startDate.getSeconds());
	        	
	        	if('h' == unit) startDate.setHours(startDate.getHours() - this.rangeTime);
	        	if('m' == unit) startDate.setMinutes(startDate.getMinutes() - this.rangeTime);
	        	
	        	if(this.rangeTime !== '0') 
	        		this.object.fromLogDateTime = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
	        	
	           	initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo')) ;
            },
            openModal : function(openModalParam)
            {
              createPageObj.openModal.call(this, openModalParam) ;
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
            setSearchServiceId : function(param)
            {
              this.object.serviceId = param.serviceId ;
            },
          },
          mounted : function()
          {
            this.initSearchArea() ;
          },
          created : function()
          {
            this.traceLogInstances = data.object ;
            this.timeoutYns = properties ;
          }
        }) ;

        var vmList = new Vue({
          el : '#' + createPageObj.getElementId('ImngListObject'),
          data : {
            makeGridObj : null,
            makebasicInfoGridObj : null,
            newTabPageUrl: "<c:url value='/igate/traceLog.html' />",
            totalCount: '0',
          },
          methods : $.extend(true, {}, listMethodOption, {
            initSearchArea : function()
            {
              window.vmSearch.initSearchArea() ;
              this.$forceUpdate();
            },
            downloadFile : function()
            {
            	var myForm = document.popForm;
    			var ipt = null;
            	var inputs = document.getElementById("popFormInputs");
            	
            	while ( inputs.hasChildNodes() ) { inputs.removeChild( inputs.firstChild ); }
            	
            	if(window.vmSearch.object.fromLogDateTime){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="fromLogDateTime";
            		ipt.value=window.vmSearch.object.fromLogDateTime;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.toLogDateTime){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="toLogDateTime";
            		ipt.value=window.vmSearch.object.toLogDateTime;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.adapterId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="adapterId";
            		ipt.value=window.vmSearch.object.adapterId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.connectorId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="connectorId";
            		ipt.value=window.vmSearch.object.connectorId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.interfaceId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="interfaceId";
            		ipt.value=window.vmSearch.object.interfaceId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.serviceId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="serviceId";
            		ipt.value=window.vmSearch.object.serviceId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.transactionId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="transactionId";
            		ipt.value=window.vmSearch.object.transactionId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.remoteAddr){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="remoteAddr";
            		ipt.value=window.vmSearch.object.remoteAddr;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.logCode){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="logCode";
            		ipt.value=window.vmSearch.object.logCode;
            		inputs.appendChild(ipt);
            	}

            	if(window.vmSearch.object.instanceId){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="instanceId";
            		ipt.value=window.vmSearch.object.instanceId;
            		inputs.appendChild(ipt);
            	}
            	
            	if(window.vmSearch.object.timeoutYn){
            		ipt = document.createElement("input");
            		ipt.type="hidden";
            		ipt.name="timeoutYn";
            		ipt.value=window.vmSearch.object.timeoutYn;
            		inputs.appendChild(ipt);
            	}
            	
    			var data = new FormData(myForm);

    			startSpinner();
    			
    			var req = new XMLHttpRequest();
    			req.open("POST", "<c:url value='/igate/traceLog/exportExcel.json' />", true);
    			
    			req.setRequestHeader('X-CSRF-TOKEN', myForm.elements._csrf.value);
    			req.responseType = "blob";
    			req.send(data);
    			    	  
    			req.onload = function (event) {
    				stopSpinner();
    				var blob = req.response;
    				var file_name = "<fmt:message>igate.traceLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx";
    				
    				if(blob.size <= 0  || event.target.status != "200"){
    					warnAlert({message : "<fmt:message>igate.sap.error</fmt:message>"}) ;
            			return;
    				}
    				
    				if (window.navigator && window.navigator.msSaveOrOpenBlob) {
    			        window.navigator.msSaveOrOpenBlob(blob, file_name);
    			    } else {
    					var link=document.createElement('a');
    					link.href=window.URL.createObjectURL(blob);
    					link.download=file_name;
    					link.click();
    					URL.revokeObjectURL(link.href)
    			        link.remove();
    			    }
    			};
            }
          }),
          mounted : function()
          {
            this.makeGridObj = getMakeGridObj() ;

            this.makeGridObj.setConfig({
              elementId : createPageObj.getElementId('ImngSearchGrid'),
              onClick : SearchImngObj.clicked,
              searchUri : "<c:url value='/igate/traceLog/search.json' />",
              viewMode : "${viewMode}",
              popupResponse : "${popupResponse}",
              popupResponsePosition : "${popupResponsePosition}",
              columns : [{
                name : "transactionId",
                header : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "messageId",
                header : "<fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "6%"
              },{
                name : "logCode",
                header : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
                align : "center",
                width: "6%"
              }, {
                name : "adapterId",
                header : "<fmt:message>igate.adapter</fmt:message>",
                align : "left",
                width: "8%"
              }, {
                name : "interfaceId",
                header : "<fmt:message>igate.interface</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "serviceId",
                header : "<fmt:message>igate.service</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "externalTransaction",
                header : "<fmt:message>igate.externalTransaction</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "externalMessage",
                header : "<fmt:message>igate.externalMessage</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "requestTimestamp",
                header : "<fmt:message>igate.traceLog.requestTimestamp</fmt:message>",
                align : "center",
                width: "11%"
              }, {
                name : "responseTimestamp",
                header : "<fmt:message>igate.traceLog.responseTimestamp</fmt:message>",
                align : "center",
                width: "11%"
              }, {
                name : "instanceId",
                header : "<fmt:message>igate.instance</fmt:message>",
                align : "left",
                width: "6%"
              }, {
                name : "connectorId",
                header : "<fmt:message>igate.connector</fmt:message>",
                align : "left",
                width: "9%"
              }, {
                name : "partitionId",
                hidden : true
              }]
            }) ;

            SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
            
            if(!this.newTabSearchGrid() && selectedTransactionInfo)
            {
              this.$nextTick(function() 
              {
            	window.vmSearch.object.transactionId = selectedTransactionInfo.transactionId ;            	  
                window.vmSearch.search();  
              });
            }
          }
        }) ;

        window.vmMain = new Vue({
          el : '#MainBasic',
          data : {
            viewMode : 'Open',
            object : {
              pk : {
                logDateTime : '',
                logId : ''
              },
              selectedTraceSearch : null,
            },
            panelMode : null,
            treeGrid : null,
            totalData : null
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
              window.vmMain.object.logDateTime = this.object.pk.logDateTime ;
              window.vmMain.object.logId = this.object.pk.logId ;
              window.vmMain.object = this.object ;
              window.vmMessageInfo.messageModel() ;
              window.vmModelInfo.modelModel() ;
            },
            goDetailPanel : function()
            {
              panelOpen('detail', null, function()
              {

                if (selectedRowTraceLog)
                {
                  $("#panel").find("[data-target='#panel']").trigger('click') ;

                  if ('c' == $("#_client_mode").val())
                  {
                    $("#panel").find('#panel-header').find('.ml-auto').remove() ;
                  }
                }

                startSpinner() ;

                $.ajax({
                  type : "GET",
                  url : "<c:url value='/igate/traceLog/list.json' />",
                  processData : false,
                  data : JsonImngObj.serialize($.extend({}, {
                    transactionId : this.object.transactionId
                  })),
                  dataType : "json",
                  beforeSend : function(xhr)
                  {

                    var token = $("meta[name='_csrf']").attr("content") ;
                    var header = $("meta[name='_csrf_header']").attr("content") ;

                    if (header)
                      xhr.setRequestHeader(header, token) ;

                    var windowName = (function()
                    {
                      var S4 = function()
                      {
                        return (Math.floor(mathRandom() * 0x10000).toString(16)) ;
                      }

                      return "GUID-" + (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4()) ;
                    })() ;

                    xhr.setRequestHeader("X-IMANAGER-WINDOW", windowName) ;
                  },
                  success : function(result)
                  {

                    stopSpinner() ;

                    this.totalData = result.object ;

                    this.makebasicInfoGridObj.search({
                      pageSize : '5',
                      object : {
                        'transactionId' : this.object.transactionId
                      }
                    }) ;

                  }.bind(this),
                  error : function(request, status, error)
                  {
                    stopSpinner() ;
                  }
                }) ;
              }.bind(this)) ;
              
              if(this.object.exceptionCode)
              {
                $("#transactionId").addClass('underlineTxt');
                $("#transactionId").parent().css('cursor', 'pointer');
              }
              else
              {
            	$("#transactionId").removeClass('underlineTxt');
                $("#transactionId").parent().css('cursor', '');
              }
            },
            downloadFile : function()
            {
              var object = window.vmMain.object ;
              var makeData = '?' ;

              for ( var key in object)
              {

                if (typeof object[key] === 'object')
                {

                  for ( var subkey in object[key])
                  {
                    makeData += key + "." + subkey + "=" + object[key][subkey] + "&" ;
                  }

                }
                else
                {
                  makeData += key + "=" + object[key] + "&" ;
                }
              }

              var url = encodeURI("<c:url value='/igate/traceLog/body.json'/>" + makeData) ;
              var popup = window.open(url, "_parent", "width=0, height=0, top=0, statusbar=no, scrollbars=no, toolbar=no") ;
              popup.focus() ;
            },
            clickExceptionInfo: function(exceptionInfo) {
            	if(!this.object.exceptionCode) return ;
            	
            	localStorage.setItem('selectedExceptionInfo', JSON.stringify(exceptionInfo));        	
            	window.open("<c:url value='/igate/exceptionLog.html' />");
            }
          },
          created : function()
          {
        	var _this = this;
        	
            $('a[href="#MainBasic"]').off('shown.bs.tab').on('shown.bs.tab', function(e)
            {
           	  setTimeout(function(){
           		  _this.makebasicInfoGridObj.getSearchGrid().setWidth($('#panel').find('.panel-body').width()) ;
           	  }, 350);
            }) ;
            
            if(localStorage.getItem('selectedTraceSearch')){
        	  this.selectedTraceSearch = JSON.parse(localStorage.getItem('selectedTraceSearch'));
        	  localStorage.removeItem('selectedTraceSearch');
        	  if(this.selectedTraceSearch.startTimestamp!=null){
        	    window.vmSearch.object.requestTimestamp = this.selectedTraceSearch.startTimestamp;
        	  }
        	  else{
        	    window.vmSearch.object.responseTimestamp = this.selectedTraceSearch.endTimestamp
        	  }
        	  window.vmSearch.object.transactionId = this.selectedTraceSearch.transactionId;
        	  window.vmSearch.search() ;
          }
          },
          mounted : function()
          {

            var previousTime = '' ;
            this.makebasicInfoGridObj = getMakeGridObj() ;

            this.makebasicInfoGridObj.setConfig({
              elementId : 'basicInfoGrid',
              isModal : true,
              onClick : function(loadParam)
              {

                if (!loadParam)
                  return ;

                localStorage.setItem('selectedRowTraceLog', JSON.stringify(loadParam)) ;

                if ('c' == $("#_client_mode").val())
                {
                  window.open("<c:url value='/igate/traceLog.html?_client_mode=c' />") ;
                }
                else
                {
                  window.open("<c:url value='/igate/traceLog.html' />") ;
                }
              },
              searchUri : "<c:url value='/igate/traceLog/search.json' />",
              viewMode : "${viewMode}",
              popupResponse : "${popupResponse}",
              popupResponsePosition : "${popupResponsePosition}",
              columns : [{
                name : "logCode",
                header : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
                align : "left"
              }, {
                name : "requestTimestamp",
                header : "<fmt:message>igate.traceLog.requestTimestamp</fmt:message>",
                align : "left"
              }, {
                name : "responseTimestamp",
                header : "<fmt:message>igate.traceLog.responseTimestamp</fmt:message>",
                align : "left"
              }, {
                name : "transactionTime",
                header : "<fmt:message>igate.traceLog.transactionTimestamp</fmt:message>",
                align : 'left',
                formatter : function(name)
                {

                  if ('INI' == name.row.logCode)
                    return "" ;

                  if (null != name.row.responseTimestamp)
                  {
                    if('I'== name.row.logCode[2] || 'O'== name.row.logCode[2])
                  	  return moment(name.row.responseTimestamp, "YYYY-MM-DD HH:mm:ss.SSS").diff(moment(name.row.requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS")) + ' ms' ;
                  }
                  else
                  {

                    var findIndex = null ;

                    if(this.totalData==null)
                      return '';
                      
                    for (var i = 0 ; i < this.totalData.length ; i++)
                    {
                      if ((this.totalData[i].pk.logDateTime == name.row['pk.logDateTime']) && (this.totalData[i].pk.logId == name.row['pk.logId']))
                      {
                        findIndex = i ;
                        break ;
                      }
                    }

                    if (null == findIndex)
                      return '' ;

                    if (0 == findIndex && 'SFS' == name.row.logCode)
                      return '' ;
                    if('I'== name.row.logCode[2] || 'O'== name.row.logCode[2])
                    	return moment(name.row.requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS").diff(moment(this.totalData[findIndex - 1].requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS")) + ' ms' ;
                  }

                }.bind(this)
              }]
            }) ;

            if (selectedRowTraceLog)
            {
              window.vmSearch.search() ;
              SearchImngObj.load($.param(selectedRowTraceLog)) ;
            }

            if (selectedRowDashboard)
            {
              window.vmSearch.object.transactionId = selectedRowDashboard ;
              window.vmSearch.search() ;
            }
          }
        }) ;

        window.vmMessageInfo = new Vue({
          el : '#MessageInfo',
          data : {
            viewMode : 'Open',
            object : {}
          },
          methods : {
            messageModel : function()
            {
              ajaxCall("<c:url value='/igate/traceLog/dump.json'/>", function(msResult)
              {
                this.object = ("ok" == msResult.result)? msResult.response : msResult.error[0].message;
              }.bind(this)) ;
            }
          }
        }) ;

        window.vmModelInfo = new Vue({
          el : '#ModelInfo',
          data : {
            grid : null
          },
          methods : {
        	initTreeGrid : function(data)
        	{
        		traceLogTreeGrid = new tui.Grid({
        			el : document.getElementById('ModelInfo'),
                    data : data,
                    bodyHeight : $('.panel-body').height() - 72,
                    rowHeight : 30,
                    minRowHeight : 30,
                    columnOptions: {
                    	resizable : true
                    },
                    treeColumnOptions : {
                      name : 'fieldId'
                    },
                    columns : [
                    	{
                    		name : 'fieldId',
                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.id</fmt:message>"
                    	}, 
                    	{
                    		name : 'fieldName',
                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.name</fmt:message>"
                    	}, 
                    	{
                    		name : 'fieldType',
                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.type</fmt:message>",
                    		formatter : function(value) {
                    			var fieldType = "" ;

		                        switch (value.row.fieldType)
		                        {
		                        case 'B' : {
		                          fieldType = "Byte" ;
		                          break ;
		                        }
		                        case 'S' : {
		                          fieldType = "Short" ;
		                          break ;
		                        }
		                        case 'I' : {
		                          fieldType = "Int" ;
		                          break ;
		                        }
		                        case 'L' : {
		                          fieldType = "Long" ;
		                          break ;
		                        }
		                        case 'F' : {
		                          fieldType = "Float" ;
		                          break ;
		                        }
		                        case 'D' : {
		                          fieldType = "Double" ;
		                          break ;
		                        }
		                        case 'N' : {
		                          fieldType = "Numeric" ;
		                          break ;
		                        }
		                        case 'p' : {
		                          fieldType = "TimeStamp" ;
		                          break ;
		                        }
		                        case 'b' : {
		                          fieldType = "Boolean" ;
		                          break ;
		                        }
		                        case 'v' : {
		                          fieldType = "Individual" ;
		                          break ;
		                        }
		                        case 'A' : {
		                          fieldType = "Raw" ;
		                          break ;
		                        }
		                        case 'P' : {
		                          fieldType = "PackedDecimal" ;
		                          break ;
		                        }
		                        case 'R' : {
		                          fieldType = "Record" ;
		                          break ;
		                        }
		                        case 'T' : {
		                          fieldType = "String" ;
		                          break ;
		                        }
		                        }
		                        if (value.row.fieldType === undefined || value.row.fieldLength === undefined)
		                          return "" ;
		
		                        return fieldType + "( " + value.row.fieldLength + " )" ;
                    		}
                    	}, 
                    	{
                    		name : 'value',
                    		header : "<fmt:message>common.property.value</fmt:message>"
                    	}, 
                    	{
                    		name : 'rawValue',
                    		header : "Hex",
                    	}
                    ]
        		}) ;
        		
		        traceLogTreeGrid.on('click', function(ev) {
		        	if (ev.rowKey != null) {
		        		traceLogTreeGrid.store.data.rawData.forEach(function(data) {
		        			traceLogTreeGrid.removeRowClassName(data.rowKey, "row-selected");
		        		});        

		        		traceLogTreeGrid.addRowClassName(ev.rowKey, "row-selected");
		        	}
		        });
		        
        		traceLogTreeGrid.expandAll() ;
        	},
            modelModel : function()
            {
              if(traceLogTreeGrid)
              {
            	  traceLogTreeGrid.destroy() ;
            	  traceLogTreeGrid = null ;
              }
              
              if($('#ModelInfo').hasClass('active'))
              {
               	setTimeout(function() {
                   	ajaxCall("<c:url value='/igate/traceLog/record.json'/>", function(rcResult)
                    {
                   		this.initTreeGrid(rcResult.object) ; 	
                    }.bind(this)) ;                		
               	}.bind(this), 350) ;
              }
            	
              $('a[href="#ModelInfo"]').off('shown.bs.tab').on('shown.bs.tab', function(e)
              {
            	if(traceLogTreeGrid) return;

                ajaxCall("<c:url value='/igate/traceLog/record.json'/>", function(rcResult)
                {
                    this.initTreeGrid(rcResult.object) ; 	
                }.bind(this)) ;
              }.bind(this)) ;
            },
            refresh : function()
            {
            	setTimeout(function() {
            		if(traceLogTreeGrid)
                		traceLogTreeGrid.setBodyHeight($('.panel-body').height() - 72) ;
            	}, 350) ;
            }
          }
        }) ;

        new Vue({
          el : '#panel-footer',
          methods : $.extend(true, {}, panelMethodOption)
        }) ;
      }) ;
    }) ;
  }) ;

  function ajaxCall(url, callback)
  {

    var object = window.vmMain.object ;

    for ( var key in object)
    {
      var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
      if (window.hasOwnProperty(name))
        object[key] = window[name][key] ;
    }

    $.ajax({
      type : "GET",
      url : url,
      processData : false,
      data : JsonImngObj.serialize(object),
      dataType : "json",
      success : function(result)
      {
          callback(result) ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
  }

  function initDatePicker(vueObj, dateFromSelector, dateToSelector)
  {
    dateFromSelector.customDateRangePicker('from', function(fromTime)
    {
      vueObj.object.fromLogDateTime = fromTime;

      dateToSelector.customDateRangePicker('to', function(toTime)
      {
        vueObj.object.toLogDateTime = toTime ;
      }, {
    	startDate: vueObj.object.toLogDateTime,
        minDate : fromTime
      }) ;

    }, {startDate: vueObj.object.fromLogDateTime}) ;
  }
  
  function initModelGrid(gridId, result)
  {

    $('#' + gridId).empty() ;

    treeGrid = new tui.Grid({
      el : document.getElementById(gridId),
      data : result.object,
      bodyHeight : 260,
      rowHeight : 30,
      minRowHeight : 30,
      treeColumnOptions : {
        name : 'fieldId'
      },
      columns : [{
        name : 'fieldId',
        header : "<fmt:message>head.field</fmt:message> <fmt:message>head.id</fmt:message>"
      }, {
        name : 'fieldName',
        header : "<fmt:message>head.field</fmt:message> <fmt:message>head.name</fmt:message>"
      }, {
        name : 'fieldType',
        header : "<fmt:message>head.field</fmt:message> <fmt:message>head.type</fmt:message>",
        formatter : function(value)
        {
          var fieldType = "" ;

          switch (value.row.fieldType)
          {
          case 'B' : {
            fieldType = "Byte" ;
            break ;
          }
          case 'S' : {
            fieldType = "Short" ;
            break ;
          }
          case 'I' : {
            fieldType = "Int" ;
            break ;
          }
          case 'L' : {
            fieldType = "Long" ;
            break ;
          }
          case 'F' : {
            fieldType = "Float" ;
            break ;
          }
          case 'D' : {
            fieldType = "Double" ;
            break ;
          }
          case 'N' : {
            fieldType = "Numeric" ;
            break ;
          }
          case 'p' : {
            fieldType = "TimeStamp" ;
            break ;
          }
          case 'b' : {
            fieldType = "Boolean" ;
            break ;
          }
          case 'v' : {
            fieldType = "Individual" ;
            break ;
          }
          case 'A' : {
            fieldType = "Raw" ;
            break ;
          }
          case 'P' : {
            fieldType = "PackedDecimal" ;
            break ;
          }
          case 'R' : {
            fieldType = "Record" ;
            break ;
          }
          case 'T' : {
            fieldType = "String" ;
            break ;
          }
          }
          if (value.row.fieldType === undefined || value.row.fieldLength === undefined)
            return "" ;

          return fieldType + "( " + value.row.fieldLength + " )" ;
        }
      }, {
        name : 'value',
        header : "<fmt:message>common.property.value</fmt:message>"
      }, {
        name : 'rawValue',
        header : "Hex",
      }]
    }) ;

    treeGrid.expandAll() ;
  } ;
</script>