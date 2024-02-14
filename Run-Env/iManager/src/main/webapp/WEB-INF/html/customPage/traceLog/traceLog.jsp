<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="traceLog" data-ready>
		<sec:authorize var="hasTraceLogViewer" access="hasRole('TraceLogViewer')"></sec:authorize>
		<sec:authorize var="hasTraceLogMessage" access="hasRole('TraceLogMessage')"></sec:authorize>
		<sec:authorize var="hasTraceLogModel" access="hasRole('TraceLogModel')"></sec:authorize>
		<sec:authorize var="hasTraceLogDown" access="hasRole('TraceLogDown')"></sec:authorize>
		<sec:authorize var="hasTraceLogTest" access="hasRole('TraceLogTest')"></sec:authorize>
	
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
		
		<%@ include file="/WEB-INF/html/customPage/traceLog/detail.jsp"%>
	</div>
	<script>
		var traceLogTreeGrid = null;
		
		document.querySelector('#traceLog').addEventListener('ready', function(evt) {
			var isViewer = 'true' == '${hasTraceLogViewer}';
			var isMessage = 'true' == '${hasTraceLogMessage}';
			var isModel = 'true' == '${hasTraceLogModel}';
			var isDown = 'true' == '${hasTraceLogDown}';
			var isTest = 'true' == '${hasTraceLogTest}';

			traceLogTreeGrid = null;

			var selectedRowTraceLog = null;

			if (localStorage.getItem('selectedRowTraceLog')) {
			    selectedRowTraceLog = JSON.parse(
			        localStorage.getItem('selectedRowTraceLog')
			    );
			    localStorage.removeItem('selectedRowTraceLog');
			}

			var selectedRowDashboard = null;

			if (localStorage.getItem('selectedRowDashboard')) {
			    selectedRowDashboard = localStorage.getItem('selectedRowDashboard');
			    localStorage.removeItem('selectedRowDashboard');
			}

			var selectedTransactionInfo = null;

			if (localStorage.getItem('selectedTransactionInfo')) {
			    selectedTransactionInfo = JSON.parse(
			        localStorage.getItem('selectedTransactionInfo')
			    );
			    localStorage.removeItem('selectedTransactionInfo');
			}

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('traceLog');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'daterange',
			        mappingDataInfo: {
			            daterangeInfo: [
			                {
			                    id: 'fromLogDateTime',
			                    name: '<fmt:message>head.from</fmt:message>'
			                },
			                {
			                    id: 'toLogDateTime',
			                    name: '<fmt:message>head.to</fmt:message>'
			                }
			            ]
			        }
			    },
			    {
			        type: 'dateCalc',
			        mappingDataInfo: {
			            unit: 'm',
			            id: 'rangeTime',
			            selectModel: 'rangeTime',
			            changeEvt: 'changeRangeTime',
			            optionFor: 'time in rangeTimeList',
			            optionValue: 'time',
			            optionText: 'time'
			        },
			        name: '<fmt:message>head.from.time</fmt:message>',
			        placeholder: '<fmt:message>head.unchecked</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.transactionId',
			        regExpType: 'searchId',
			        name: '<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.logCode',
			        name: '<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/interfaceModal',
			            modalTitle: '<fmt:message>igate.interface</fmt:message>',
			            vModel: 'object.interfaceId',
			            callBackFuncName: 'setSearchInterfaceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/serviceModal',
			            modalTitle: '<fmt:message>igate.service</fmt:message>',
			            vModel: 'object.serviceId',
			            callBackFuncName: 'setSearchServiceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/connectorModal',
			            modalTitle: '<fmt:message>igate.connector</fmt:message>',
			            vModel: 'object.connectorId',
			            callBackFuncName: 'setSearchConnectorId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/instanceModal',
			            modalTitle: '<fmt:message>igate.instance</fmt:message>',
			            vModel: 'object.instanceId',
			            callBackFuncName: 'setSearchInstanceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.externalTransaction',
			        name: '<fmt:message>igate.externalTransaction</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.externalMessage',
			        name: '<fmt:message>igate.externalMessage</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.responseCode',
			        name: '<fmt:message>igate.traceLog.responseCode</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.remoteAddr',
			        regExpType: 'ip',
			        name: '<fmt:message>head.ip</fmt:message>',
			        placeholder: '<fmt:message>head.searchIP</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.sessionId',
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connectorControl.session</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>head.timeoutYn</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'timeoutYnList',
			            selectModel: 'object.timeoutYn',
			            optionFor: 'option in timeoutYnList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: isViewer,
			    searchInitBtn: isViewer,
			    downloadBtn: isViewer,
			    currentCnt: isViewer,
			    totalCnt: isViewer,
			});

			createPageObj.mainConstructor();

			var tabList = [
			    {
			        type: 'custom',
			        id: 'MainBasic',
			        name: '<fmt:message>head.basic.info</fmt:message>',
			        noRowClass: true,
			        getDetailArea: function () {
			            return $('#traceLog-panel').html();
			        }
			    }
			];

			if (isMessage) {
			    tabList.push({
			        type: 'custom',
			        id: 'MessageInfo',
			        name: '<fmt:message>igate.traceLog.message.info</fmt:message>',
			        isSubResponsive: true,
			        getDetailArea: function () {
			            var messageInfoCt = $('#messageInfoCt').clone();

			            if (!isDown) {
			                messageInfoCt.find('a[title="' + '<fmt:message>head.download</fmt:message>' + '"]').remove();
			            }

			            if (!isTest) {
			                messageInfoCt.find('a[title="' + '<fmt:message>igate.traceLog.create.testCase</fmt:message>' + '"]').remove();
			            }

			            return messageInfoCt.html();
			        }
			    });
			}

			if (isModel) {
			    tabList.push({
			        type: 'tree',
			        id: 'ModelInfo',
			        name: '<fmt:message>head.model.info</fmt:message>'
			    });
			}

			createPageObj.setTabList(tabList);

			createPageObj.setPanelButtonList({});

			createPageObj.panelConstructor(true);

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/traceLog/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/traceLog/control'
			});

			if (localStorage.getItem('searchObj')) {
			    var searchObj = JSON.parse(localStorage.getItem('searchObj'));
			    localStorage.removeItem('searchObj');

			    localStorage.setItem(
			        createPageObj.getElementId('ImngListObject') + '-newTabSearchCondition',
			        JSON.stringify({
			            object: {
			                fromLogDateTime: null,
			                toLogDateTime: null,
			                transactionId: searchObj['transactionId']
			                    ? searchObj['transactionId']
			                    : null,
			                logCode: null,
			                instanceId: null,
			                adapterId: null,
			                connectorId: null,
			                sessionId: null,
			                remoteAddr: null,
			                interfaceId: null,
			                serviceId: null,
			                externalTransaction: null,
			                externalMessage: null,
			                responseCode: null,
			                timeoutYn: ' ',
			                exceptionCode: null,
			                requestTimestamp: null,
			                responseTimestamp: null,
			                pageSize: 10,
			            },
			            letter: {
	    		            transactionId: searchObj['transactionId']
		                    ? searchObj['transactionId'].length
		                    : 0
	    		        }
			        })
			    );
			}
			
	    	(new HttpReq('/api/page/properties')).read({ pk : { propertyId: 'List.Yn' }, orderByKey: true }, function(timeoutYnResult) {
	    		
	    		window.vmSearch = new Vue({
	    		    el: '#' + createPageObj.getElementId('ImngSearchObject'),
	    		    data: {
	    		        timeoutYnList: [],
	    		        rangeTime: 10,
	    		        rangeTimeList: [1, 3, 5, 10],
	    		        object: {
	    		            fromLogDateTime: null,
	    		            toLogDateTime: null,
	    		            transactionId: null,
	    		            logCode: null,
	    		            instanceId: null,
	    		            adapterId: null,
	    		            connectorId: null,
	    		            sessionId: null,
	    		            remoteAddr: null,
	    		            interfaceId: null,
	    		            serviceId: null,
	    		            externalTransaction: null,
	    		            externalMessage: null,
	    		            responseCode: null,
	    		            timeoutYn: ' ',
	    		            exceptionCode: null,
	    		            requestTimestamp: null,
	    		            responseTimestamp: null,
	    		            pageSize: 10,
	    		        },
	    		        letter: {
	    		            transactionId: 0,
	    		            logCode: 0,
	    		            instanceId: 0,
	    		            adapterId: 0,
	    		            connectorId: 0,
	    		            sessionId: 0,
	    		            remoteAddr: 0,
	    		            interfaceId: 0,
	    		            serviceId: 0,
	    		            externalTransaction: 0,
	    		            externalMessage: 0,
	    		            responseCode: 0,
	    		            exceptionCode: 0
	    		        }
	    		    },
	    		    methods: $.extend(true, {}, searchMethodOption, {
	    		        inputEvt: function (info) {
	    		            setLengthCnt.call(this, info);
	    		        },
	    		        search: function () {
	    		            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

	    		            vmList.makeGridObj.search(this.object, function(info) {
				            	vmList.currentCnt = info.currentCnt;
				            	vmList.totalCnt = info.totalCnt;
				            });
	    		        },
	    		        initSearchArea: function (searchCondition) {
	    		            if (searchCondition) {
	    		                for (var key in searchCondition) {
	    		                    this.$data[key] = searchCondition[key];
	    		                }
	    		            } else {
	    		                this.rangeTime = '10';
	    		                this.object.pageSize = 10;
	    		                this.object.fromLogDateTime = null;
	    		                this.object.toLogDateTime = null;
	    		                this.object.transactionId = null;
	    		                this.object.logCode = null;
	    		                this.object.instanceId = null;
	    		                this.object.adapterId = null;
	    		                this.object.connectorId = null;
	    		                this.object.sessionId = null;
	    		                this.object.remoteAddr = null;
	    		                this.object.interfaceId = null;
	    		                this.object.serviceId = null;
	    		                this.object.externalTransaction = null;
	    		                this.object.externalMessage = null;
	    		                this.object.responseCode = null;
	    		                this.object.timeoutYn = ' ';
	    		                this.object.exceptionCode = null;

	    		                this.letter.transactionId = 0;
	    		                this.letter.logCode = 0;
	    		                this.letter.instanceId = 0;
	    		                this.letter.adapterId = 0;
	    		                this.letter.connectorId = 0;
	    		                this.letter.sessionId = 0;
	    		                this.letter.remoteAddr = 0;
	    		                this.letter.interfaceId = 0;
	    		                this.letter.serviceId = 0;
	    		                this.letter.externalTransaction = 0;
	    		                this.letter.externalMessage = 0;
	    		                this.letter.responseCode = 0;
	    		                this.letter.exceptionCode = 0;

	    		                this.changeRangeTime('m');
	    		            }

	    		            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#rangeTime'), this.rangeTime);
	    		            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#timeoutYnList'), this.object.timeoutYn);
	    		            
	    		            this.initDatePicker();
	    		        },
	    		        initDatePicker: function () {
	    		        	var fromLogDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#fromLogDateTime');
	    		            var toLogDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#toLogDateTime');
	    		            
	    		            fromLogDateTime.customDateRangePicker('from', function(fromLogDateTime) {
	    		                this.object.fromLogDateTime = fromLogDateTime;
	    		                
	    		                toLogDateTime.customDateRangePicker('to', function(toLogDateTime) {
	    		                    this.object.toLogDateTime = toLogDateTime;
	    		                }.bind(this), {
	    		                    startDate: this.object.toLogDateTime,
	    		                    minDate : fromLogDateTime
	    		                });		            		
	    		            }.bind(this), {
	    		                startDate: this.object.fromLogDateTime
	    		            });
	    		        },
	    		        changeRangeTime: function (unit) {
	    		            var startDate = new Date();
	    		            startDate.setDate(startDate.getDate());
	    		            startDate.setHours(startDate.getHours());
	    		            startDate.setMinutes(startDate.getMinutes());
	    		            startDate.setSeconds(startDate.getSeconds());
	    		            
	    		            var endDate = new Date();
	    		            endDate.setHours(endDate.getHours());
	    		            endDate.setMinutes(endDate.getMinutes());
	    		            endDate.setSeconds(endDate.getSeconds());

	    		            if ('h' == unit)
	    		                startDate.setHours(startDate.getHours() - this.rangeTime);
	    		            if ('m' == unit)
	    		                startDate.setMinutes(startDate.getMinutes() - this.rangeTime);

	    		            if (this.rangeTime !== '0')
	    		                this.object.fromLogDateTime = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
	    		            
	    		            this.object.toLogDateTime = moment(endDate).format('YYYY-MM-DD HH:mm:ss');

	    		            this.initDatePicker();
	    		        },
	    		        openModal: function (openModalParam, regExpInfo) {
	    		            if (-1 < openModalParam.vModel.indexOf('instanceId')) {
	    		                openModalParam.modalParam = { instanceType: 'T' };
	    		            }

	    		            createPageObj.openModal.call(this, openModalParam, regExpInfo);
	    		        },
	    		        setSearchAdapterId: function (param) {
	    		            this.object.adapterId = param.adapterId;
	    		        },
	    		        setSearchConnectorId: function (param) {
	    		            this.object.connectorId = param.connectorId;
	    		        },
	    		        setSearchInterfaceId: function (param) {
	    		            this.object.interfaceId = param.interfaceId;
	    		        },
	    		        setSearchServiceId: function (param) {
	    		            this.object.serviceId = param.serviceId;
	    		        },
	    		        setSearchInstanceId: function (param) {
	    		            this.object.instanceId = param.instanceId;
	    		        }
	    		    }),
	    		    mounted: function () {
	    		        this.timeoutYnList = timeoutYnResult.object;

	    		        this.$nextTick(function () {
	    		            this.initSearchArea();
	    		        });
	    		    }
	    		});
			    
			    var vmList = new Vue({
			    	el: '#' + createPageObj.getElementId('ImngListObject'),
			        data: {
			        	makeGridObj: null,
			        	makeBasicInfoGridObj : null,
			        	totalCnt: null,
			        	currentCnt: null,
			        },        
			        methods: $.extend(true, {}, listMethodOption, {
			        	initSearchArea: function() {
			        		window.vmSearch.initSearchArea();
			        	},
			        	downloadFile: function() {
			        		downloadFileFunc({ 
			        			url : '/api/entity/traceLog/download',  
			        			param : { object : window.vmSearch.object, reverseOrder : false },
			        			fileName : "<fmt:message>igate.traceLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx"
			        		});
			        	}
			        }),
			        mounted: function() {
			        	this.makeGridObj = getMakeGridObj();
			        	
			        	this.makeGridObj.setConfig({
			        		el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),	
			        		searchUrl: '/api/entity/traceLog/search',
			        		totalCntUrl: '/api/entity/traceLog/count',
			        		paging: {
				    			isUse: true,
				    			side: "server",
				    			setCurrentCnt: function(currentCnt) {
				    			    this.currentCnt = currentCnt
				    			}.bind(this)				    			
				    		},
			              	columns: [		  
								{
									name: 'requestTimestamp',
									header: '<fmt:message>igate.traceLog.requestTimestamp</fmt:message>',
									align: 'center',
									width: '15%',
									formatter: function(obj) {
										return changeDateFormat(obj.value);
									}
								},
			              		{
									name: "transactionId",
									header: "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '15%'
								},
								{
									name: "logCode",
									header: "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
									align: 'center',
									width: '5%'
								},
								{
									name: "adapterId",
									header: "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '5%'
								},
								{
									name: "interfaceId",
									header: "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '10%'
								},
								{
									name: "serviceId",
									header: "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '10%'
								},
								{
									name: "instanceId",
									header: "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '5%'
								},								
								{
									name: "externalTransaction",
									header: "<fmt:message>igate.externalTransaction</fmt:message>",
									width: '10%'
								},
								{
									name: "externalMessage",
									header: "<fmt:message>igate.externalMessage</fmt:message>",
									width: '15%'
								},
								{
									name: 'responseCode',
									header: '<fmt:message>igate.traceLog.responseCode</fmt:message>',
									align: 'center',
									width: '10%'
								},
								{
									name: "partitionId",
									hidden: true
								}
			              	],
			              	onGridMounted: function(evt) {              		
				            	evt.instance.on('click', function(evt) {
				              		if ('undefined' === typeof evt.rowKey) return;
				            		
				            		SearchImngObj.clicked(evt.instance.getRow(evt.rowKey));
				            	});
				            }
			        	});
			        	
			        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
			        	
			        	if(this.newTabSearchGrid()) {
			        		this.$nextTick(function() {
			            		window.vmSearch.search();	
			            	});	
			        	}
			        }
			    });
			    
			    window.vmMain = new Vue({
			    	el: '#MainBasic',
			    	data: {
			    		viewMode: 'Open',
			    		object: {
			    			pk: {
			    				logDateTime: null,
			    				logId: null
			    			},
			    			selectedTraceSearch: null
			    		},
			    		openWindows: [],
			    		panelMode: null,
			    		refGridData : null,
			    		hasClickEvt: true,
			    		isTools: window.isTools
			    	},
			    	computed: {
			    		pk: function() {
			    			return {
			    				'pk.logDateTime' : this.object.pk.exceptionId,
			    				'pk.logId' : this.object.pk.exceptionDateTime			                    
			    			};
			    		}
			    	},
			        methods : {
			        	loaded : function() {
			        		window.vmMain.object.requestTimestamp = changeDateFormat(this.object.requestTimestamp);
			        		window.vmMain.object.responseTimestamp = changeDateFormat(this.object.responseTimestamp);
				            window.vmMain.object.logId = this.object.pk.logId;
			              	window.vmMain.object = this.object;
			              	window.vmMessageInfo.messageModel();
			              	window.vmMessageInfo.logCode = this.object.logCode;
			              	window.vmMessageInfo.interfaceId = this.object.interfaceId;
			              	window.vmModelInfo.modelModel();
			            },
						goDetailPanel: function() {
				              panelOpen('detail', null, function() {
				            	  if (selectedRowTraceLog) {
				            		  $("#panel").find("[data-target='#panel']").trigger('click');
				            		  
				            		  if ('c' == $("#_client_mode").val()) {
				            			  $("#panel").find('#panel-header').find('.ml-auto').remove();
			                          }
			            		  }
				            	  
				            	//reference Log Grid
				            	  var param = {
				            		  limit : null,
				            		  next: null,
				            		  object: window.vmMain.object,
				            		  reverseOrder: false
				            	  };
				            	  
				            	  (new HttpReq('/api/entity/traceLog/search')).read(param, function(result) {
				            		  this.refGridData = result.object;	            		  
				            		  this.makeBasicInfoGridObj.search({ 'transactionId' : this.object.transactionId, pageSize : 5 });
				            	  }.bind(this));
				            	  
				              }.bind(this));
	                    },
			        	initDetailArea: function(object) {
			        		if(object) this.object = object;
						},
						clickEvt: function(data) {		
							if(!this.object[data]) {
								window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
								return;
							} 
							
							var menuId = [];
							
							switch(data) {
								case 'transactionId':
									menuId = ['100000', '103000', '103010'];
									break;
								case 'adapterId':
									menuId = ['200000', '202000', '202030'];
									break;
								case 'connectorId':
									menuId = ['200000', '202000', '202020'];
									break;
								case 'interfaceId':
									menuId = ['100000', '101000', '101050'];
									break;
								case 'serviceId':
									menuId = ['100000', '101000', '101030'];
									break;
							};
							
							var clickData = {};
							clickData[data] = this.object[data];
							
			            	localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(menuId));
			            	localStorage.setItem('searchObj', JSON.stringify(clickData));
			            	
			            	window.open(location.href);
			            }
			        },
			        created : function() {
			        	var _this = this;
			        	  
			        	$('a[href="#MainBasic"]').off('shown.bs.tab').on('shown.bs.tab', function(e) {
			        		setTimeout(function() {
			        			_this.makeBasicInfoGridObj.getSearchGrid().setWidth($('#panel').find('.panel-body').width());
			       			}, 350);
			       		});
			        	
			        	if(localStorage.getItem('selectedTraceSearch')) { 
			        		this.selectedTraceSearch = JSON.parse(localStorage.getItem('selectedTraceSearch'));
			        		localStorage.removeItem('selectedTraceSearch');
			        					        		
			        		if(this.selectedTraceSearch.startTimestamp!=null) {
			        			window.vmSearch.object.fromLogDateTime = changeDateFormat(this.selectedTraceSearch.startTimestamp, 'yyyy-mm-dd') + '00:00:00';
			        			window.vmSearch.object.toLogDateTime = changeDateFormat(this.selectedTraceSearch.startTimestamp, 'yyyy-mm-dd') + '23:59:59';
			       			} else {
			       				window.vmSearch.object.fromLogDateTime = changeDateFormat(this.selectedTraceSearch.startTimestamp, 'yyyy-mm-dd') + '00:00:00';
			       				window.vmSearch.object.toLogDateTime = changeDateFormat(this.selectedTraceSearch.startTimestamp, 'yyyy-mm-dd') + '23:59:59';
			  				}
			        		  
			        		window.vmSearch.object.transactionId = this.selectedTraceSearch.transactionId;
			        		window.vmSearch.search();
			        		window.vmSearch.initDatePicker();
			       		}
			        },
			        mounted : function() {
			        	this.makeBasicInfoGridObj = getMakeGridObj();
	
			            this.makeBasicInfoGridObj.setConfig({
			            	el : document.querySelector('#basicInfoGrid'),
			            	searchUrl: '/api/entity/traceLog/search',
			        		paging: {
				    			isUse: true,
				    			side: "client"
				    		},
			              	columns : [
			              		{
			              			name : "logCode",
			                		header : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
			                		align : "left"
			              		},
			              		{
			              			name : "requestTimestamp",
					                header : "<fmt:message>igate.traceLog.requestTimestamp</fmt:message>",
					                align : "left",
					                formatter: function(obj) {
					                	return changeDateFormat(obj.value);
					                }
		              			},
		              			{
		              				name : "responseTimestamp",
					                header : "<fmt:message>igate.traceLog.responseTimestamp</fmt:message>",
					                align : "left",
					                formatter: function(obj) {
					                	return changeDateFormat(obj.value);
					                }
			              		},
			              		{
			              			name : "transactionTime",
			              			header : "<fmt:message>igate.traceLog.transactionTimestamp</fmt:message>",
			              			align : 'left',
			                		formatter : function(info) {
										var rowInfo = info.row;
										var logCode = rowInfo.logCode;
										var timestampFormat = "YYYY-MM-DD HH:mm:ss.SSS";
										
										var fromTime = null;
										var toTime = null;
										
			                			if (!('I' === logCode.charAt(2) || 'O' === logCode.charAt(2)) || 'INI' === logCode || 'SFS' === logCode) return '';
			                			
			                  			if (rowInfo.responseTimestamp) {
			                  				fromTime = rowInfo.responseTimestamp;
			                  				toTime = rowInfo.requestTimestamp;			                    				
		                  				} else {
			                    			if(0 === this.refGridData.length) return '';
			                    			
		                    				for (var i = 0; i < this.refGridData.length; i++) {
		                    					if (this.refGridData[i].pk.logDateTime == rowInfo['pk.logDateTime'] && this.refGridData[i].pk.logId == rowInfo['pk.logId']) {
		                    						fromTime = rowInfo.requestTimestamp;
					                  				toTime = this.refGridData[i].requestTimestamp;
			                        				break;
		                      					}
			                    			}
			                  			}
			                  			
			                  			if(!fromTime || !toTime) return '';
			                  			
			                  			return moment(fromTime, timestampFormat).diff(moment(toTime, timestampFormat)) + ' ms';
		                  			}.bind(this)
		              			}
		              		],
		              		onGridMounted: function(evt) {
		              			evt.instance.on('click', function(evt) {
		              				if ('undefined' === typeof evt.rowKey) return;
				              		
		              				var rowInfo = evt.instance.getRow(evt.rowKey);
				              		
				              		localStorage.setItem('searchObj', JSON.stringify({transactionId: rowInfo.transactionId}));
				              		localStorage.setItem('selectedRowTraceLog', JSON.stringify(rowInfo));
				              		
				              		window.open(location.href);
				            	});
				            }
			            });
			            
			            if (selectedRowTraceLog) {
			              	SearchImngObj.load(selectedRowTraceLog);
			            }
	
			            if (selectedRowDashboard) {
			              	window.vmSearch.object.transactionId = selectedRowDashboard;
			              	window.vmSearch.search();
			            }
			    	}
			    });
			    
			    window.vmMessageInfo = new Vue({
			    	el : '#MessageInfo',
			    	data : {
			    		viewMode : 'Open',
			            object : null,
			            logCode: null,
			            interfaceId: null
			    	},
			    	methods : {
			    		messageModel : function() {
			    			if (isMessage) {
			    				(new HttpReq('/api/entity/traceLog/dump')).read(window.vmMain.object, function(result) {
			    					
			    					if("ok" == result.result) {
			    						this.object = result.object;
			    						
			    						if(result.object) $('#MessageInfo').find('#downloadBtn').show();
			    						else $('#MessageInfo').find('#downloadBtn').hide();
			    					} else {
				    					this.object = result.error[0].message;			    						
			    					}
			    				}.bind(this));			    				
			    			}
			            },
						downloadFile: function() {
							var param = JSON.parse(JSON.stringify(window.vmMain.object));
							
							var file_name = '';
	                        
	                        if(param.transactionId) file_name += param.transactionId + '_';
	                        if(param.messageId) file_name += param.messageId + '_';
	                        
	                        file_name += param.pk.logDateTime + '_' + param.pk.logId + ".dat";
							
	                        downloadFileFunc({ 
			        			url : '/api/entity/traceLog/body',  
			        			param : param,
			        			fileName : file_name
			        		});
						},            
			            createTestCase: function() {
			            	var instanceList = null;
			            	var interfaceInfo = null;
			            	var testCaseInfo = null;
			            	var testCaseId = null; 
			            		
			            	getInstanceList(
			            		getInterfaceInfo.bind(this, 
	            					getTestCaseInfo.bind(this, 
	    				            	getTestCaseList.bind(this, initModal)
	    		            		)
		            			)
			            	);
							
							function getInstanceList(callback) {
								var param = {
									object: { instanceType: 'T' },
									limit: null,
									next: null,
									reverseOrder: false,
								};
							
								new HttpReq('/api/entity/instance/search').read(param, function(result) {
									instanceList = result.object;
									
									if(callback) callback();
				            	});
							}
							
							function getInterfaceInfo(callback) {
								new HttpReq('/api/entity/interface/object').read({ interfaceId: this.interfaceId }, function(result) {
									interfaceInfo = result.object;
									if(callback) callback();
				            	});
							}
							
							function getTestCaseInfo(callback) {
								var param = {
									object: { interfaceId: this.interfaceId },
									className: 'com.inzent.igate.repository.meta.Interface'
								};
								
								new HttpReq('/api/reference/entity').read(param, function(result) {
									testCaseInfo = result.object[0];
									if(callback) callback();
				            	});
							}
							
							function getTestCaseList(callback) {
								new HttpReq('/api/entity/testCase/count').read({ pk : { interfaceId: this.interfaceId } }, function(result) {
									testCaseId = 'CASE_' + (Number(result.object) + 1); 
									
									if(callback) callback();
				            	});								
							}
							
							function initModal() {
				            	var createTestCaseTemplate = $('#createTestCaseTemplate').clone();
				            	
				            	createTestCaseTemplate.children('div').attr('id', 'createTestCaseCt');
				            	
				            	var vmTestCase = null;
				            	
				            	openModal({
				            		name: 'createTestCase',
				            		title: "<fmt:message>igate.traceLog.create.testCase</fmt:message>",
				            		size: 'small',
				            		bodyHtml: createTestCaseTemplate.html(),
				            		isMultiCheck: true,
				            		buttonList: [
				        				{
				        					customBtnId: 'confirmBtn',
				        					customBtn: '<fmt:message>head.ok</fmt:message>',
				        					customBtnAction: function() {
				        						if (null === vmTestCase.object.pk.testCaseId || 0 === vmTestCase.object.pk.testCaseId.trim().length) {
					            					_alert({
					            						type: 'warn',
					            						message: "<fmt:message>igate.traceLog.not.exist.testCase.id</fmt:message>"
					            					});
					            					
													return;				            					
					            				}
				        											
				        						if (null === vmTestCase.object.testInstance || 0 === vmTestCase.object.testInstance.trim().length) {
					            					_alert({
					            						type: 'warn',
					            						message: "<fmt:message>igate.traceLog.not.exist.testInstance.id</fmt:message>"
					            					});
					            					
													return;				            					
					            				}
				        						
				        						new HttpReq('/api/entity/testCase/count').read({'pk.testCaseId': vmTestCase.object.pk.testCaseId, 'pk.interfaceId': vmTestCase.object.pk.interfaceId}, function(result) {
					            					if(0 < Number(result.object)) {
						            					_alert({
						            						type: 'warn',
						            						message: "<fmt:message>igate.traceLog.same.testCase</fmt:message>"
						            					});
						            					
														return;	
					            					}
					            					
					            					new HttpReq('/api/entity/traceLog/testCase').create({ 'log' : window.vmMain.object, 'testCase' : vmTestCase.object}, function() {
						            					_alert({
						            						type: 'compt',
						            						message: "<fmt:message>igate.traceLog.created.testCase</fmt:message>",
						            						callBackFunc: function() {
						            							$('#createTestCaseModalSearch').find('#modalClose').trigger('click');
						            						}
						            					});												
													}, true);
					            				});
				        					}
				        				}
				        			],
				            		shownCallBackFunc: function() {
				            			vmTestCase = new Vue({
				            				el: '#createTestCaseCt',
				            				data: {
				            		    		letter: {
				            		    			pk: {
				            		    				testCaseId: testCaseId.length
				            		    			},
				            		    			testCaseDesc: 0			            		    			
				            		    		},
				            		    		object : {
				            		    			pk: {
				            		    				testCaseId: testCaseId,
				            		    				interfaceId: testCaseInfo? testCaseInfo.pk.interfaceId : interfaceInfo.interfaceId
				            		    			},
				            		    			testInstance: testCaseInfo? testCaseInfo.testInstance : null,
				            		    			testCaseGroup: testCaseInfo? testCaseInfo.testCaseGroup : interfaceInfo.adapterId + "." + interfaceInfo.interfaceId,
				            		    			testCaseDesc: testCaseInfo? testCaseInfo.testCaseDesc : null,
				            		    			testCaseStatus: testCaseInfo? testCaseInfo.testCaseStatus : 'N',
				            		    			testCaseSync: testCaseInfo? testCaseInfo.testCaseSync: 'S',
				            		    			testCaseMessage: window.vmMessageInfo.object
				            		    		},
				            		    		testCaseIdRegExp: getRegExpInfo('id'),
				            		    		testCaseDescRegExp: getRegExpInfo('desc'),
				            		    		
				            		    		instanceList: instanceList
				            				},
				            				methods: {
				            		    		inputEvt: function(info) {
				            		    			setLengthCnt.call(this, info);	
				            		    		}			            					
				            				}
				            			});
				            		}
				            	});									
							}
			            }
		          	}
		        });
			    
			    window.vmModelInfo = new Vue({
			    	el : '#ModelInfo',
			    	data : {
			    		grid : null
		          	},
		          	methods : {
		          		initTreeGrid : function(data) {
			            	if(traceLogTreeGrid) {
			            		traceLogTreeGrid.destroy();
			            	  	traceLogTreeGrid = null;
			              	}
			            	
		          			traceLogTreeGrid = new tui.Grid({
		          				el : document.getElementById('ModelInfo'),
			                    data : data,
			                    minRowHeight : 40,
			                    scrollX: false,
			                    columnOptions: {
			                    	resizable : true
			                    },
			                    treeColumnOptions : {
			                      	name : 'fieldId'
			                    },
			                    columns : [
			                    	{
			                    		name : 'fieldId',
			                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.id</fmt:message>",
			                    		escapeHTML: true
			                    	}, 
			                    	{
			                    		name : 'fieldName',
			                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.name</fmt:message>",
			                    		escapeHTML: true
			                    	}, 
			                    	{
			                    		name : 'fieldType',
			                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.type</fmt:message>",
			                    		formatter : function(value) {
			                    			var fieldType = "";
	
					                        switch (value.row.fieldType) {
					                        	case 'B' : {
					                        		fieldType = "Byte";
					                          		break;
				                          		}
					                        	case 'S' : {
					                          		fieldType = "Short";
					                          		break;
					                        	}
					                        	case 'I' : {
					                          		fieldType = "Int";
					                          		break;
					                        	}
					                        	case 'L' : {
					                          		fieldType = "Long";
					                          		break;
					                        	}
					                        	case 'F' : {
					                          		fieldType = "Float";
					                          		break;
					                        	}
					                        	case 'D' : {
					                          		fieldType = "Double";
					                          		break;
					                        	}
					                        	case 'N' : {
					                          		fieldType = "Numeric";
					                          		break;
					                        	}
				                        		case 'p' : {
					                          		fieldType = "TimeStamp";
					                          		break;
					                        	}
					                        	case 'b' : {
					                          		fieldType = "Boolean";
					                          		break;
					                        	}
					                        	case 'v' : {
					                          		fieldType = "Individual";
					                          		break;
					                        	}
					                        	case 'A' : {
					                          		fieldType = "Raw";
					                          		break;
					                        	}
					                        	case 'P' : {
					                        		fieldType = "PackedDecimal";
						                          	break;
					                        	}
					                        	case 'R' : {
					                          		fieldType = "Record";
					                          		break;
					                        	}
					                        	case 'T' : {
					                          		fieldType = "String";
					                          		break;
					                        	}
				                        	}
					                        if (value.row.fieldType === undefined || value.row.fieldLength === undefined) return "";
					
					                        return fieldType + "( " + value.row.fieldLength + " )";
			                    		}
			                    	}, 
			                    	{
			                    		name : 'value',
			                    		header : "<fmt:message>common.property.value</fmt:message>",
			                    		escapeHTML: true
			                    	}, 
			                    	{
			                    		name : 'rawValue',
			                    		header : "Hex",
			                    		escapeHTML: true
			                    	}
			                    ]
			        		});
			        		
					        traceLogTreeGrid.on('click', function(ev) {
					        	if (ev.rowKey != null) {
					        		traceLogTreeGrid.store.data.rawData.forEach(function(data) {
					        			traceLogTreeGrid.removeRowClassName(data.rowKey, "row-selected");
									});        
	
					        		traceLogTreeGrid.addRowClassName(ev.rowKey, "row-selected");
					        	}
					        });
					        
			        		traceLogTreeGrid.expandAll();
			        	},
			            modelModel : function() {
			              	if($('#ModelInfo').hasClass('active')) {
			              		setTimeout(function() {
			              			(new HttpReq('/api/entity/traceLog/record')).read(window.vmMain.object, function(result) {
			              				this.initTreeGrid(result.object);
			              			}.bind(this));               		
			               		}.bind(this), 350);
			              	}
			            	
			              	$('a[href="#ModelInfo"]').off('shown.bs.tab').on('shown.bs.tab', function(e) {
		              			(new HttpReq('/api/entity/traceLog/record')).read(window.vmMain.object, function(result) {
		              				this.initTreeGrid(result.object);
		              			}.bind(this));
		              			
			              	}.bind(this));
			            },
			            refresh : function() {
			            	setTimeout(function() {
			            		if(traceLogTreeGrid)
			            			traceLogTreeGrid.setBodyHeight($('.panel-body').height() - 110);
			            	}, 350);
			            }
		          	}
		        });
	    	});
		    
		    new Vue({
				el: '#panel-header',
				methods: $.extend(true, {}, panelMethodOption)
			});			
			
		    new Vue({
		    	el: '#panel-footer',
		    	methods: $.extend(true, {}, panelMethodOption)
		    });	
		    
		    this.addEventListener('resize', function(evt) {		    	
		    	var traceLogBasicGrid = window.vmMain.makeBasicInfoGridObj.getSearchGrid();
		    	var panelWidth = $('#panel').find('.panel-body').width();
		    	
		    	if(traceLogBasicGrid) {
			    	traceLogBasicGrid.setWidth(panelWidth);			    		
		    	}
		    	
		    	if(traceLogTreeGrid) {
			    	traceLogTreeGrid.setWidth(panelWidth);			    		
		    	}
		    });
		    
			this.addEventListener('destroy', function(evt) {
				$(".daterangepicker").remove();
				$(".ui-datepicker").remove();
				$(".backdrop").remove();
				$(".modal").remove();
				$(".modal-backdrop").remove();
				$('#ct').find('script').remove();
			});
		});		
	</script>
</body>
</html>