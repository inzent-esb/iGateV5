<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('batchLog');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([{
	       'type' : "daterange",
	       'mappingDataInfo': {
	       		'daterangeInfo': [
	        		{'id' :  'searchDateFrom', 'name' : "<fmt:message>head.from</fmt:message>"},
	          		{'id' :  'searchDateTo', 'name' : "<fmt:message>head.to</fmt:message>"},
	            ]
 			}
	    }, {
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.instanceId",
  				'optionFor': 'option in batchLogInstances',
  				'optionValue': 'option.instanceId',
  				'optionText': 'option.instanceId',
  				'optionIf': 'option.instanceType == "T"',
  				'id': 'batchLogInstances',
  			},
  			'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>", 
  			'placeholder': "<fmt:message>head.all</fmt:message>"
		},	
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/connector.html', 'modalTitle': '<fmt:message>igate.connector</fmt:message>', 'vModel': "object.connectorId", 'callBackFuncName': 'setSearchConnectorId'}, 'name': "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/interface.html', 'modalTitle': '<fmt:message>igate.interface</fmt:message>', 'vModel': "object.interfaceId", 'callBackFuncName': 'setSearchInterfaceId'}, 'name': "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/service.html', 'modalTitle': '<fmt:message>igate.service</fmt:message>', 'vModel': "object.serviceId", 'callBackFuncName': 'setSearchServiceId'}, 'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.fileName", 'name': "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>", 'placeholder': "<fmt:message>head.searchName</fmt:message>"},
		{'type': "singleDaterange", 'mappingDataInfo': {'id': 'searchSingleDaterange'}, 'name': "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>", 'placeholder': "<fmt:message>head.searchFileStamp</fmt:message>"},
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setTabList([{
	      'type' : 'basic',
	      'id' : 'MainBasic',
	      'name' : '<fmt:message>head.basic.info</fmt:message>',
	      'detailList' : [{
	        'className' : 'col-lg-4',
	        'detailSubList' : [{
	          'type' : "text",
	          'mappingDataInfo' : "object.transactionId",
	          'name' : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.adapterId",
	          'name' : '<fmt:message>igate.adapter</fmt:message>'
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.remoteAddr",
	          'name' : "<fmt:message>common.metaHistory.updateRemoteAddress</fmt:message>"
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.fileName",
	          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>"
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.tableLastKey",
	          'name' : "<fmt:message>igate.batchLog.tableLastKey</fmt:message>"
		    },{
	          'type' : "text",
	          'mappingDataInfo' : "object.exceptionMessage",
	          'name' : "<fmt:message>head.exception.message</fmt:message>"
		    }]
	      }, {
	        'className' : 'col-lg-4',
	        'detailSubList' : [{
	          'type' : "text",
	          'mappingDataInfo' : "object.logCode",
	          'name' : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.connectorId",
	          'name' : '<fmt:message>igate.connector</fmt:message>'
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.interfaceServiceId",
	          'name' : "<fmt:message>igate.interface</fmt:message><fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>"
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.fileSequence",
	          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.sequence</fmt:message>"
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.safId",
	          'name' : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.id</fmt:message>"
		    },{
	          'type' : "text",
	          'mappingDataInfo' : "object.startTimestamp",
	          'name' : "<fmt:message>igate.transactionRestriction.time.start</fmt:message>"
		    }]
	      }, {
	        'className' : 'col-lg-4',
	        'detailSubList' : [{
	          'type' : "text",
	          'mappingDataInfo' : "object.instanceId",
	          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>"
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.sessionId",
	          'name' : "<fmt:message>igate.connectorControl.session</fmt:message> <fmt:message>head.id</fmt:message>"
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.fileDate",
	          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>"
	        }, {
	          'type' : "text",
	          'mappingDataInfo' : "object.tableSequence",
	          'name' : "<fmt:message>head.table</fmt:message> <fmt:message>head.sequence</fmt:message>"
	        },{
	          'type' : "text",
	          'mappingDataInfo' : "object.exceptionCode",
	          'name' : "<fmt:message>igate.exceptionCode</fmt:message>"
		    },{
	          'type' : "text",
	          'mappingDataInfo' : "object.endTimestamp",
	          'name' : "<fmt:message>igate.transactionRestriction.time.end</fmt:message>"
		    }]
	      },]
	    } ]) ;
	
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		refreshArea : true,
		totalCount: true,
	});
	createPageObj.setPanelButtonList(null) ;
    createPageObj.panelConstructor(true) ;
	createPageObj.mainConstructor();
	
	$.getJSON("<c:url value='/igate/instance/list.json' />", function(data) {
		
		PropertyImngObj.getProperties('List.TraceLog.Yn', true, function(timeoutYns) {
			
			window.vmSearch = new Vue({
				el : '#' + createPageObj.getElementId('ImngSearchObject'),
		    	data : {
		          pageSize : '10',
		          object : {
		        	  adapterId : null,
		        	  connectorId : null,
		        	  interfaceServiceId : null,
		        	  interfaceId : null,
		        	  serviceId : null,
		        	  instanceId : " ",
		        	  fileName : null,
		        	  pk : {}
		          },
		          timeoutYns : [],
		          batchLogInstances : [],
		          isInitbatchLogInstances: false,
		          uri : "<c:url value='/igate/instance/list.json' />"
		        },
		        methods: {
					search : function() {
						vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
						vmList.makeGridObj.search(this, function() {
			                $.ajax({
			                    type : "GET",
			                    url : "<c:url value='/igate/batchLog/rowCount.json' />",
			                    data: JsonImngObj.serialize(this.object),
			                    processData : false,
			                    success : function(result) {
			                    	vmList.totalCount = numberWithComma(result.object);
			                    }
			                });
			            }.bind(this));
					},
		            initSearchArea: function(searchCondition) {
		            	if(searchCondition) {
		            		for(var key in searchCondition) {
		            		    this.$data[key] = searchCondition[key];
		            		}
		            	}else {
			            	this.pageSize = '10';
			        		this.object.fromLogDateTime = null;
			        		this.object.toLogDateTime = null;
			        		this.object.transactionId = null;	
			        		this.object.adapterId = null;
			        		this.object.connectorId = null;
			        		this.object.interfaceId = null;
			        		this.object.serviceId = null;
			        		this.object.fileName = null;
			        		this.object.fileDate = null;		            	
			        		this.object.interfaceServiceId = null;
			        		this.object.instanceId = " ";		            		
		            	}

		            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#batchLogInstances'), this.object.instanceId);
		            	initDateSinglePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchSingleDaterange'));
		            	initDateRangePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
			 			
			 			this.$forceUpdate();
		            },
					openModal: function(openModalParam) {
						createPageObj.openModal.call(this, openModalParam);	
					},	
		            setSearchAdapterId: function(param) {
		            	this.object.adapterId = param.adapterId;
		            },
		            setSearchConnectorId: function(param) {
		            	this.object.connectorId = param.connectorId;
		            },
		            setSearchInterfaceId: function(param) {
		            	this.object.interfaceServiceId = param.interfaceId;
		            	this.object.interfaceId = param.interfaceId;
		            	this.object.serviceId = null;
		            },
		            setSearchServiceId: function(param) {
		            	this.object.interfaceServiceId = param.serviceId;
		            	this.object.serviceId = param.serviceId;
		            	this.object.interfaceId = null;
		            }
		        },
		        mounted : function() {
					this.initSearchArea();
		        },
		        created : function() {
		        	this.batchLogInstances = data.object;
		        	this.timeoutYns = timeoutYns;
		        },
			});
			
			var vmList = new Vue({
				el: '#' + createPageObj.getElementId('ImngListObject'),
		        data: {
		        	makeGridObj: null,
		        	timerSeconds : 60,
		            displayTimerSeconds : 60,
		            timerSecondsList : [10, 20, 30, 40, 50, 60],
		            isStartRefresh : false,
		            refreshIntervalId : null,
		        	newTabPageUrl: "<c:url value='/igate/batchLog.html' />",
		        	totalCount: '0',
		        },
		        methods: $.extend(true, {}, listMethodOption, {
		        	initSearchArea: function() {
		        		window.vmSearch.initSearchArea();
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
		        mounted: function() {
		        	
		        	this.makeGridObj = getMakeGridObj();
		        	
		        	this.makeGridObj.setConfig({
		        		elementId: createPageObj.getElementId('ImngSearchGrid'),
		        		searchUri : "<c:url value='/igate/batchLog/search.json' />",
		        		onClick : SearchImngObj.clicked,
		                viewMode : "${viewMode}",
		                popupResponse : "${popupResponse}",
		                popupResponsePosition : "${popupResponsePosition}",
		                columns : [
		                	{
		                  		name : "transactionId",
		                  		header : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
		                  		align : "left",
		                        width: "12%"
		                	}, 
		                	{
		                  		name : "logCode",
		                  		header : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
		                  		align : "center",
		                        width: "6%"
		                	}, 
		                	{
		                  		name : "adapterId",
		                  		header : "<fmt:message>igate.adapter</fmt:message>",
		                  		align : "left",
		                        width: "9%"
		                	}, 
		                	{
		                  		name : "interfaceServiceId",
		                  		header : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.service</fmt:message>",
		                  		align : "left",
		                        width: "10%"
		                	},
		                	{
		                  		name : "exceptionCode",
		                  		header : "<fmt:message>igate.exceptionCode</fmt:message>",
		                  		align : "center",
		                        width: "8%"
		                	},
		                	{
		                  		name : "startTimestamp",
		                  		header : "<fmt:message>igate.traceLog.requestTimestamp</fmt:message>",
		                  		align : "center",
		                        width: "12.5%"
		                	}, 
		                	{
		                  		name : "endTimestamp",
		                  		header : "<fmt:message>igate.traceLog.responseTimestamp</fmt:message>",
		                  		align : "center",
		                        width: "12.5%"
		                	}, 
		                	{
		                  		name : "instanceId",
		                  		header : "<fmt:message>igate.instance</fmt:message>",
		                  		align : "left",
		                        width: "8%"
		                	}, 
		                	{
		                  		name : "connectorId",
		                  		header : "<fmt:message>igate.connector</fmt:message>",
		                  		align : "left",
		                        width: "10%"
		                	},
		                	{
		                  		name : "safMessage",
		                  		header : "<fmt:message>igate.batchLog.retryInfo</fmt:message>",
		                  		align : "center",
		                        width: "8%",
		                        formatter : function(name){
		                          if(name.row.exceptionCode!=null)
	              	        		return '<div><a type="button" class="btn-m icon-srch"></a></div>';
	              	        	 else
	              	        	   return '<div><a>-</a></div>';
		                        }
		                	},{
		                  		name : "traceLog",
		                  		header : "<fmt:message>igate.batchLog.logInfo</fmt:message>",
		                  		align : "center",
		                        width: "8%",
		                        formatter : function(name){
	              	        		return '<div><a type="button" class="btn-m icon-srch"></a></div>';
		                        }
		                	},
		                ]		        	    
		        	});
		        	
		        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
		        	
		        	
					SearchImngObj.searchGrid.on('click', function(ev) {
		   	       		
		   	       		var row = SearchImngObj.searchGrid.getRow(ev.rowKey);
		   	       		var menu = null;
		   	       		var loadParam = {};
		   	       		switch(SearchImngObj.searchGrid.getFocusedCell().columnName) {
		   	       	        case 'safMessage':  
		   	       	          if(row.exceptionCode!=null)
		   	       	      		menu = 'safMessage';  loadParam = { 'itemName' : 'selectedSafSearch', param : {transactionId : row.transactionId ,startTimestamp : row.startTimestamp, endTimestamp : row.endTimestamp} };
		   	       	    	  break;
		   	       			case 'traceLog':   menu = 'traceLog';  loadParam = { 'itemName' : 'selectedTraceSearch', param : {transactionId : row.transactionId, startTimestamp : row.startTimestamp, endTimestamp : row.endTimestamp}};  break;
		   	       		}
		   	       		
	 	              	if (!menu) return ;
	 	              	
		   	       		localStorage.setItem(loadParam.itemName , JSON.stringify(loadParam.param));
	                	window.open("<c:url value='/igate/"+ menu +".html' />") ;
	 	              	
	 	              });
					
					
					this.newTabSearchGrid();
		        }
		    });			
			
			
			 window.vmMain = new Vue({
			      el : '#MainBasic',
			      data : {
			        viewMode : 'Open',
			        object : {
			        },
			        panelMode : null
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
			          this.object.transactionId = null ;
			          this.object.logCode = null ;
			          this.object.instanceId = null ;
			          this.object.adapterId = null ;
			          this.object.connectorId = null ;
			          this.object.sessionId = null ;
			          this.object.remoteAddr = null ;
			          this.object.interfaceServiceId = null ;
			          this.object.fileDate = null;
			          this.object.fileName =null;
			          this.object.fileSequence = null;
			          this.object.tableSequence = null;
			          this.object.tableLastKey = null;
			          this.object.safId = null;
			          this.object.exceptionCode = null;
			          this.object.exceptionMessage = null;
			          this.object.startTimestamp = null;
			          this.object.endTimestamp = null;
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
			    
		});
	});	
	
	SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/batchLog/object.json' />"
    });
    
    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/batchLog/control.json' />"
    });
});

function initDateSinglePicker(vueObj, dateRangeSelector) {
	var startDate = null;
	
	if(vueObj.object.fileDate) {
		var year = vueObj.object.fileDate.substring(0, 4);
		var month = vueObj.object.fileDate.substring(4, 6);
		var day = vueObj.object.fileDate.substring(6, 8);
		startDate = month + '/' + day + '/' + year;
	}
	
	dateRangeSelector.customDatePicker(function(time) {
		vueObj.object.fileDate = time;
	}, {startDate: startDate, localeFormat: "YYYYMMDD"});
}

function initDateRangePicker(vueObj, dateFromSelector,dateToSelector) {
	dateFromSelector.customDateRangePicker('from', function(fromTime) {
		vueObj.object.fromLogDateTime = fromTime;
		
		dateToSelector.customDateRangePicker('to', function(toTime) {
			vueObj.object.toLogDateTime = toTime;
		}, {startDate: vueObj.object.toLogDateTime, minDate: fromTime});
	}, {startDate: vueObj.object.fromLogDateTime});
}
</script>