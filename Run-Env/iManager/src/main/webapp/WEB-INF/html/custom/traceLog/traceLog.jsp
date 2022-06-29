<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="traceLog" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
		
		<%@ include file="/WEB-INF/html/custom/traceLog/detail.jsp"%>
	</div>
	<script>
		var traceLogTreeGrid = null;
	
		document.querySelector('#traceLog').addEventListener('privilege', function(evt) {
			this.setAttribute('viewer', evt.detail.viewer);
			this.setAttribute('editor', evt.detail.editor);
		});
		
		document.querySelector('#traceLog').addEventListener('ready', function(evt) {
			var viewer = 'true' == this.getAttribute('viewer');
			var editor = 'true' == this.getAttribute('editor');
					    			
			traceLogTreeGrid = null;
			
			var selectedRowTraceLog = null;

			if (localStorage.getItem('selectedRowTraceLog')) {
				selectedRowTraceLog = JSON.parse(localStorage.getItem('selectedRowTraceLog'));
				localStorage.removeItem('selectedRowTraceLog');
		    }

		    var selectedRowDashboard = null;

		    if (localStorage.getItem('selectedRowDashboard')) {
		    	selectedRowDashboard = localStorage.getItem('selectedRowDashboard');
		    	localStorage.removeItem('selectedRowDashboard');
		    }
		    
		    var selectedTransactionInfo = null;

		    if (localStorage.getItem('selectedTransactionInfo')) {
		    	selectedTransactionInfo = JSON.parse(localStorage.getItem('selectedTransactionInfo'));
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
							{ id: 'fromLogDateTime', name: '<fmt:message>head.from</fmt:message>'},
							{ id: 'toLogDateTime', name: '<fmt:message>head.to</fmt:message>'},
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
						optionText: 'time',
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
					type: "modal",
					mappingDataInfo: {
						url: '/modal/adapterModal.html',
				        modalTitle: '<fmt:message>igate.adapter</fmt:message>',
				        vModel: "object.adapterId",
				        callBackFuncName: "setSearchAdapterId"
					},
					regExpType: 'searchId',
					name: "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
					placeholder: "<fmt:message>head.searchId</fmt:message>"
				},		
				{
					type: "modal",
					mappingDataInfo: {
						url: '/modal/interfaceModal.html',
				        modalTitle: '<fmt:message>igate.interface</fmt:message>',
				        vModel: "object.interfaceId",
				        callBackFuncName: "setSearchInterfaceId"
					},
					regExpType: 'searchId',
					name: "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
					placeholder: "<fmt:message>head.searchId</fmt:message>"
				},		
				{
					type: "modal",
					mappingDataInfo: {
						url: '/modal/serviceModal.html',
				        modalTitle: '<fmt:message>igate.service</fmt:message>',
				        vModel: "object.serviceId",
				        callBackFuncName: "setSearchServiceId"
					},
					regExpType: 'searchId',
					name: "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
					placeholder: "<fmt:message>head.searchId</fmt:message>"
				},
				{
					type: "modal",
					mappingDataInfo: {
						url: '/modal/connectorModal.html',
				        modalTitle: '<fmt:message>igate.connector</fmt:message>',
				        vModel: "object.connectorId",
				        callBackFuncName: "setSearchConnectorId"
					},
					regExpType: 'searchId',
					name: "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
					placeholder: "<fmt:message>head.searchId</fmt:message>"
				},				
				{
					type: "modal",
					mappingDataInfo: {
						url: '/modal/instanceModal.html',
						modalTitle: '<fmt:message>igate.instance</fmt:message>',
				        vModel: "object.instanceId",
				        callBackFuncName: "setSearchInstanceId"
					},
					regExpType: 'searchId',
					name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
					placeholder: "<fmt:message>head.searchId</fmt:message>"
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
					placeholder: '<fmt:message>head.searchId</fmt:message>'			
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
						optionText: 'option.propertyValue',
					}
				},
			]);
			
			createPageObj.searchConstructor();
			
			createPageObj.setMainButtonList({
				newTabBtn: viewer,
				searchInitBtn: viewer,
				downloadBtn: viewer,
				totalCount: viewer,
			});
			
			createPageObj.mainConstructor();
			
			createPageObj.setTabList([
				{
					'type': 'custom',
					'id': 'MainBasic',
					'name': '<fmt:message>head.basic.info</fmt:message>',
					'noRowClass': true,
					'getDetailArea': function() {
						return $("#traceLog-panel").html();
					}
				},
				{
					'type': 'custom',
					'id': 'MessageInfo',
					'name': '<fmt:message>igate.traceLog.message.info</fmt:message>',
					'isSubResponsive': true,
					'getDetailArea': function() {
						return $("#messageInfoCt").html();
					}
				},
				{
					'type': 'tree',
					'id': 'ModelInfo',
					'name': '<fmt:message>head.model.info</fmt:message>'
				}
			]);		
			
			createPageObj.setPanelButtonList({	
			});	
			
			createPageObj.panelConstructor(true);	
			
		    SaveImngObj.setConfig({
		    	objectUri : "/igate/traceLog/object.json"
		    });
		    
		    ControlImngObj.setConfig({
		        controlUri : "/igate/record/control.json"
		    });
		    
		    if (localStorage.getItem('searchObj')) {
		    	var searchObj = JSON.parse(localStorage.getItem('searchObj'));
		    	localStorage.removeItem('searchObj');
		    	
		    	localStorage.setItem(createPageObj.getElementId('ImngListObject') + '-newTabSearchCondition', JSON.stringify({
		    		object: {
		    			fromLogDateTime: null,
		    			toLogDateTime: null,
		    			transactionId: searchObj['transactionId']? searchObj['transactionId'] : null,
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
		    			requestTimestamp : null,
		                responseTimestamp: null,
		    		}
		    	}));
		    }
		    
	    	(new HttpReq('/common/property/properties.json')).read({ propertyId: 'List.Yn', orderByKey: true }, function(timeoutYnResult) {
			    window.vmSearch = new Vue({
			    	el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    	data: {
			    		pageSize : '10',
			    		timeoutYnList: [],
			    		rangeTime : 10,
			            rangeTimeList : [1, 3, 5 ,10],
			            object : {
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
			    			requestTimestamp : null,
			                responseTimestamp: null,
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
			    			exceptionCode: 0,
			    		},
			    	},
			    	methods: {
			    		inputEvt: function(info) {
			    			setLengthCnt.call(this, info);
			    		},
						search: function() {
							vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
							
							vmList.makeGridObj.search(this, function() {
								(new HttpReq("/igate/traceLog/rowCount.json")).read(this.object, function(result) {
									vmList.totalCount = 0 == result.object? 0 : numberWithComma(result.object);
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
			                	this.rangeTime = '10';
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
			        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			        		
			        		this.initDatePicker();
			            },
			            initDatePicker: function() {
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
				        	
				           	this.initDatePicker();
			            },
			            openModal: function(openModalParam, regExpInfo) {
			            	if (-1 < openModalParam.vModel.indexOf('instanceId')) {
			            		openModalParam.modalParam = {
			            			instanceType: 'T'		
			            		};
			            	}	

			            	createPageObj.openModal.call(this, openModalParam, regExpInfo);		            	
			            },
			            setSearchAdapterId: function(param) {
			            	this.object.adapterId = param.adapterId;
			            },
			            setSearchConnectorId: function(param) {
			            	this.object.connectorId = param.connectorId;
			            },
			            setSearchInterfaceId: function(param) {
			            	this.object.interfaceId = param.interfaceId;
			            },
			            setSearchServiceId: function(param) {
			            	this.object.serviceId = param.serviceId;
			            },
			            setSearchInstanceId: function(param) {
			            	this.object.instanceId = param.instanceId;
			            }
			    	},
			    	mounted: function() {
			    		this.timeoutYnList = timeoutYnResult.object;
			    	
			    		this.$nextTick(function() {
		    				this.initSearchArea();
		    			});
			    	}
			    });
			    
			    var vmList = new Vue({
			    	el: '#' + createPageObj.getElementId('ImngListObject'),
			        data: {
			        	makeGridObj: null,
			        	makebasicInfoGridObj : null,
			        	newTabPageUrl: "<c:url value='/igate/traceLog.html' />",
			        	totalCount: '0',
			        	exportArr: [
			        		'fromLogDateTime',
			        		'toLogDateTime',
			        		'transactionId',
			        		'logCode',
			        		'instanceId',
			        		'adapterId',
			        		'connectorId',
			        		'sessionId',
			        		'remoteAddr',
			        		'interfaceId',
			        		'serviceId',
			        		'externalTransaction',
			        		'externalMessage',
			        		'responseCode',
			        		'timeoutYn',
			        		'exceptionCode'
			        	],
			        },        
			        methods: $.extend(true, {}, listMethodOption, {
			        	initSearchArea: function() {
			        		window.vmSearch.initSearchArea();
			        	},
			        	downloadFile: function() { 
			        		var excelForm = document.createElement('form');
			        		
			        		this.exportArr.forEach(function(key) {
			        			var hiddenField = document.createElement('input');
			        			
			        			hiddenField.setAttribute('type', 'hidden');
			        			hiddenField.setAttribute('name', key);
			        			
			        			var object = window.vmSearch.object;
			        			var value = null;
			        			
		        				if ('object' === typeof(object[key]))  object = object[key];
		        				else									value = object[key];
			        			
			        			hiddenField.setAttribute('value', null === value? '' : value);
			        			
			        			excelForm.appendChild(hiddenField);
			        		});
			        		
	                        var data = new FormData(excelForm);
	                        
	                        window.$startSpinner();
	
	                        var req = new XMLHttpRequest();
	                        
	                        req.open("POST", "${prefixUrl}/igate/traceLog/exportExcel.json", true);
	
	        				var csrfToken = JSON.parse(localStorage.getItem('csrfToken'));
	        				req.setRequestHeader(csrfToken.headerName, csrfToken.token);
	        				
	        				req.withCredentials = true;
	        				
	                        req.responseType = "blob";
	                        req.send(data);
	                        
	                        req.onload = function (event) {
	                        	window.$stopSpinner();
	                        	
	                        	var blob = req.response;
	                        	var file_name = "<fmt:message>igate.traceLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx";
	
	                        	if (blob.size <= 0){
	                        		window._alert({type: 'warn', message: "<fmt:message>head.fail.notice</fmt:message>"});
	                                return;
	                        	}
	
	                        	if (window.navigator && window.navigator.msSaveOrOpenBlob) {
	                        		window.navigator.msSaveOrOpenBlob(blob, file_name);
	                        	} else {
	                        		var link = document.createElement('a');
	                        		link.href = window.URL.createObjectURL(blob);
	                        		link.download = file_name;
	                        		link.click();
	                        		URL.revokeObjectURL(link.href)
	                        		link.remove();
	                        	}
	                        };	
			        	 },
			        }),
			        mounted: function() {
			        	this.makeGridObj = getMakeGridObj();
			        	
			        	this.makeGridObj.setConfig({
			        		elementId: createPageObj.getElementId('ImngSearchGrid'),
			        		onClick: function(loadParam, ev) {
			        			SearchImngObj.clicked({'pk.logId': loadParam['pk.logId'], 'pk.logDateTime': loadParam['pk.logDateTime']});
			        		},
			        		searchUri: "/igate/traceLog/search.json",
			        		viewMode: "${viewMode}",
			              	popupResponse: "${popupResponse}",
			              	popupResponsePosition: "${popupResponsePosition}",
			              	columns: [		  
								{
									name: 'requestTimestamp',
									header: '<fmt:message>igate.traceLog.requestTimestamp</fmt:message>',
									align: 'center',
									width: '12%',
								},
			              		{
									name: "transactionId",
									header: "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '10%',
								},
								{
									name: "logCode",
									header: "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
									align: 'center',
									width: '6%',
								},
								{
									name: "adapterId",
									header: "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '8%',
								},
								{
									name: "interfaceId",
									header: "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '12%',
								},
								{
									name: "serviceId",
									header: "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '12%',
								},
								{
									name: "instanceId",
									header: "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
									width: '6%',
								},								
								{
									name: "externalTransaction",
									header: "<fmt:message>igate.externalTransaction</fmt:message>",
									width: '12%',
								},
								{
									name: "externalMessage",
									header: "<fmt:message>igate.externalMessage</fmt:message>",
									width: '12%',
								},
								{
									name: 'responseCode',
									header: '<fmt:message>igate.traceLog.responseCode</fmt:message>',
									align: 'center',
									width: '12%',
								},
								{
									name: "partitionId",
									hidden: true,
								},
			              	]        	    
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
			    				logId: null,
			    				logDateTime: null,
			    			},
			    			selectedTraceSearch: null,
			    		},
			    		openWindows: [],
			    		panelMode: null,
			    		treeGrid : null,
			            totalData : null
			    	},
			    	computed: {
			    		pk: function() {
			    			return {
			    				'pk.exceptionDateTime' : this.object.pk.exceptionDateTime,
			                    'pk.exceptionId' : this.object.pk.exceptionId
			    			};
			    		}
			    	},
			        methods : {
			        	loaded : function() {
			        		window.vmMain.object.logDateTime = this.object.pk.logDateTime;
				            window.vmMain.object.logId = this.object.pk.logId;
			              	window.vmMain.object = this.object;
			              	window.vmMessageInfo.messageModel();
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
				            	  
				            	  (new HttpReq('/igate/traceLog/list.json')).read(window.vmMain.object, function(result) {
				            		  this.totalData = result.object;
				            		  
				            		  this.makebasicInfoGridObj.search({
			                        	  pageSize : '5',
			                              object : {
			                            	  'transactionId' : this.object.transactionId
			                              }
			                          });
				            	  }.bind(this));
				            	  
				              }.bind(this));
	                    },
			        	initDetailArea: function(object) {
			        		if(object) this.object = object;
						},
						downloadFile: function() {
							var object = window.vmMain.object;
							var makeData = '?';
	
							for (var key in object) {
								if (typeof object[key] === 'object') {
									for (var subkey in object[key]) {
										makeData += key + "." + subkey + "=" + object[key][subkey] + "&";
									}
				                } else {
				                	makeData += key + "=" + object[key] + "&";
				                }
							}
							
							var url = encodeURI('${prefixUrl}/igate/traceLog/body.json' + makeData);
							var popup = window.open(url, "_parent", "width=0, height=0, top=0, statusbar=no, scrollbars=no, toolbar=no");
							
							popup.focus();
						},
						clickExceptionInfo: function(exceptionInfo) {
			            	localStorage.setItem('searchObj', JSON.stringify(exceptionInfo));
			            	localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '103000', '103010']));
			            	
			            	window.open(location.href);
			            }
			        },
			        created : function() {
			        	var _this = this;
			        	  
			        	$('a[href="#MainBasic"]').off('shown.bs.tab').on('shown.bs.tab', function(e) {
			        		setTimeout(function() {
			        			_this.makebasicInfoGridObj.getSearchGrid().setWidth($('#panel').find('.panel-body').width());
			       			}, 350);
			       		});
			        	  
			        	if(localStorage.getItem('selectedTraceSearch')) { 
			        		this.selectedTraceSearch = JSON.parse(localStorage.getItem('selectedTraceSearch'));
			        		localStorage.removeItem('selectedTraceSearch');
			        	  	
			        		if(this.selectedTraceSearch.startTimestamp!=null) {
			        			window.vmSearch.object.fromLogDateTime = moment(this.selectedTraceSearch.startTimestamp).format('YYYY-MM-DD 00:00:00');
			        			window.vmSearch.object.toLogDateTime = moment(this.selectedTraceSearch.startTimestamp).format('YYYY-MM-DD 23:59:59');
			       			} else {
			       				window.vmSearch.object.fromLogDateTime = moment(this.selectedTraceSearch.endTimestamp).format('YYYY-MM-DD 00:00:00');
			       				window.vmSearch.object.toLogDateTime = moment(this.selectedTraceSearch.endTimestamp).format('YYYY-MM-DD 23:59:59');
			  				}
			        		  
			        		window.vmSearch.object.transactionId = this.selectedTraceSearch.transactionId;
			        		window.vmSearch.search();
			        		window.vmSearch.initDatePicker();
			       		}
			        },
			        mounted : function() {
			        	var previousTime = '';
			        	this.makebasicInfoGridObj = getMakeGridObj();
	
			            this.makebasicInfoGridObj.setConfig({
			            	elementId : 'basicInfoGrid',
			              	isModal : true,
			              	onClick : function(loadParam) {
			              		if (!loadParam) return;
				
			              		localStorage.setItem('searchObj', JSON.stringify({transactionId: loadParam.transactionId}));
			              		localStorage.setItem('selectedRowTraceLog', JSON.stringify(loadParam));
			              		
			              		window.open(location.href);
			              	},
			              	searchUri : '/igate/traceLog/search.json',
			              	viewMode : "${viewMode}",
			              	popupResponse : "${popupResponse}",
			              	popupResponsePosition : "${popupResponsePosition}",
			              	columns : [
			              		{
			              			name : "logCode",
			                		header : "<fmt:message>head.log</fmt:message> <fmt:message>head.classification</fmt:message>",
			                		align : "left"
			              		},
			              		{
			              			name : "requestTimestamp",
					                header : "<fmt:message>igate.traceLog.requestTimestamp</fmt:message>",
					                align : "left"
		              			},
		              			{
		              				name : "responseTimestamp",
					                header : "<fmt:message>igate.traceLog.responseTimestamp</fmt:message>",
					                align : "left"
			              		},
			              		{
			              			name : "transactionTime",
			              			header : "<fmt:message>igate.traceLog.transactionTimestamp</fmt:message>",
			              			align : 'left',
			                		formatter : function(name) {
			                			if ('INI' === name.row.logCode) return "";
	
			                  			if (null != name.row.responseTimestamp) {
			                    			if('I' === name.row.logCode[2] || 'O' === name.row.logCode[2])
			                  	  			return moment(name.row.responseTimestamp, "YYYY-MM-DD HH:mm:ss.SSS").diff(moment(name.row.requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS")) + ' ms';
		                  				} else {
		                  					var findIndex = null;
	
			                    			if(null === this.totalData) return '';
			                      
		                    				for (var i = 0; i < this.totalData.length; i++) {
		                    					if ((this.totalData[i].pk.logDateTime == name.row['pk.logDateTime']) && (this.totalData[i].pk.logId == name.row['pk.logId'])) {
		                    						findIndex = i;
			                        				break;
		                      					}
			                    			}
		                    				
		                    				if (null === findIndex) return '';
	
		                    				if (0 === findIndex) return '';
		                    				
		                    				if ('SFS' === name.row.logCode) return '';
						                    
						                    if('I' === name.row.logCode[2] || 'O' === name.row.logCode[2])
			                    				return moment(name.row.requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS").diff(moment(this.totalData[findIndex - 1].requestTimestamp, "YYYY-MM-DD HH:mm:ss.SSS")) + ' ms';
			                  			}
		                  			}.bind(this)
		              			}
		              		]
			            });
			            
			            if (selectedRowTraceLog) {
			              	SearchImngObj.load($.param(selectedRowTraceLog));
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
			            object : {}
			    	},
			    	methods : {
			    		messageModel : function() {
			    			 (new HttpReq('/igate/traceLog/dump.json')).read(window.vmMain.object, function(result) {
				                	this.object = ("ok" == result.result)? result.response : result.error[0].message;
			    			 }.bind(this));
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
			                    	}, 
			                    	{
			                    		name : 'fieldName',
			                    		header : "<fmt:message>head.field</fmt:message> <fmt:message>head.name</fmt:message>",
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
			                    	}, 
			                    	{
			                    		name : 'rawValue',
			                    		header : "Hex",
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
			            	if(traceLogTreeGrid) {
			            		traceLogTreeGrid.destroy();
			            	  	traceLogTreeGrid = null;
			              	}
			              
			              	if($('#ModelInfo').hasClass('active')) {
			              		
			              		setTimeout(function() {
			              			(new HttpReq('/igate/traceLog/record.json')).read(window.vmMain.object, function(result) {
			              				this.initTreeGrid(result.object);
			              			}.bind(this));               		
			               		}.bind(this), 350);
			              	}
			            	
			              	$('a[href="#ModelInfo"]').off('shown.bs.tab').on('shown.bs.tab', function(e) {
			              		if(traceLogTreeGrid) return;
			              		
		              			(new HttpReq('/igate/traceLog/record.json')).read(window.vmMain.object, function(result) {
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
		    	if(!traceLogTreeGrid) return;
		    	
		    	setTimeout(function() {
		    		traceLogTreeGrid.setWidth($('#panel').find('.panel-body').width());	
		    	}, 350);
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