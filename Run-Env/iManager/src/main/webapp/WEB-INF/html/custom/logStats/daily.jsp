<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="daily" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

		<ul id="summaryTemplate" class="row media-dl" style="display: none;">
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/call.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.request</fmt:message></dt>
						<dd class="h1">{{ requestCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/complete.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.normal</fmt:message></dt>
						<dd class="h1">{{ successCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/warn.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.exception</fmt:message></dt>
						<dd class="h1">{{ exceptionCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/danger.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.timeout</fmt:message></dt>
						<dd class="h1">{{ timeoutCount }}</dd>
					</dl>
				</div>
			</li>
		</ul>
	</div>
	<script>
		document.querySelector('#daily').addEventListener('privilege', function(evt) {
			this.setAttribute('viewer', evt.detail.viewer);
			this.setAttribute('editor', evt.detail.editor);
		});
		
		document.querySelector('#daily').addEventListener('ready', function(evt) {
			var viewer = 'true' == this.getAttribute('viewer');
			var editor = 'true' == this.getAttribute('editor');
			
			var createPageObj = getCreatePageObj();
			
			createPageObj.setViewName('daily');
			createPageObj.setIsModal(false);
			
			createPageObj.setSearchList(
				[
					{
						type: 'select',
						name: '<fmt:message>igate.logStatistics.searchType</fmt:message>',
						isHideAllOption: true,
						mappingDataInfo: {
							id: 'dailyTimes',
							selectModel: 'object.searchType',
							optionFor: 'option in dailyTimes',
							optionValue: 'option.pk.propertyKey',
							optionText: 'option.propertyValue',
						}
					},				
					{
						type: 'daterange',
						name: '<fmt:message>igate.logStatistics.searchType</fmt:message>',
						mappingDataInfo: {
							daterangeInfo: [
								{ id: 'fromDateTime', name: '<fmt:message>head.from</fmt:message>'},
								{ id: 'toDateTime', name: '<fmt:message>head.to</fmt:message>'},
							]							
						}
					},	
					{
						type: 'select',
						name: '<fmt:message>igate.logStatistics.classification</fmt:message>',
						placeholder: '<fmt:message>head.all</fmt:message>',
						mappingDataInfo: {
							id: 'statsTypes',
							selectModel: 'object.pk.statsType',
							optionFor: 'option in statsTypes',
							optionValue: 'option.pk.propertyKey',
							optionText: 'option.propertyValue',
						}
					},					
				]
			);
			
			createPageObj.searchConstructor();
			
			createPageObj.setMainButtonList({
				newTabBtn: viewer,
				searchInitBtn: viewer,
				downloadBtn: viewer,
				totalCount: viewer,
			});
			
			createPageObj.mainConstructor();
			
			$('.empty').after($('#summaryTemplate'));			
			
			(new HttpReq('/common/property/properties.json')).read({ propertyId: 'List.LogStats.SearchType', orderByKey: true }, function(searchTypeResult) {
				(new HttpReq('/common/property/properties.json')).read({ propertyId: 'List.LogStats.online.statsDataTypes', orderByKey: true }, function(statsDataTypesResult) {
					window.vmSearch = new Vue({
						el: '#' + createPageObj.getElementId('ImngSearchObject'),
				    	data: {
				    		pageSize : '10',
				    		dailyTimes: [],
				    		statsTypes: [],
				    		object : {
				    			searchType: 'D',
				    			fromDateTime: null,
				    			toDateTime: null,
				    			pk: {
				    				statsType: ' ',
				    			}
				    		},
				    	},
				    	methods: {
							search: function() {
								$('#summaryTemplate').removeAttr('id').show();
								
								vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
								
								vmList.makeGridObj.getSearchGrid().setPerPage(Number(this.pageSize));
								
								vmList.makeGridObj.search(this, function(result) {
									vmList.totalCount = result.object.page.length;

						        	vmList.requestCount = 0;
						        	vmList.successCount = 0;
						        	vmList.exceptionCount = 0;
						        	vmList.timeoutCount = 0;
									
									result.object.page.forEach(function(info) {
							        	vmList.requestCount += Number(info.requestCount);
							        	vmList.successCount += Number(info.successCount);
							        	vmList.exceptionCount += Number(info.exceptionCount);
							        	vmList.timeoutCount += Number(info.timeoutCount);								
									});

						        	vmList.requestCount = numberWithComma(vmList.requestCount);
						        	vmList.successCount = numberWithComma(vmList.successCount);
						        	vmList.exceptionCount = numberWithComma(vmList.exceptionCount);
						        	vmList.timeoutCount = numberWithComma(vmList.timeoutCount);
					            }.bind(this));
							},					
				            initSearchArea: function(searchCondition) {
				            	if(searchCondition) {
				            		for(var key in searchCondition) {
				            		    this.$data[key] = searchCondition[key];
				            		}
				            	}else {
				                	this.pageSize = '10';
				                	this.object.searchType = 'D';
				                	this.object.fromDateTime = null;
				                	this.object.toDateTime = null;
				                	this.object.pk.statsType = ' ';
				            	}
								
				            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statsTypes'), this.object.pk.statsType);
				            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#dailyTimes'), this.object.searchType);
				        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
				        		
				        		this.initDatePicker();
				            },
				            initDatePicker: function() {
				            	var fromDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#fromDateTime');
				            	var toDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#toDateTime');
				            	
				            	fromDateTime.customDateRangePicker('from', function(fromDateTime) {
				            		this.object.fromDateTime = fromDateTime;
				            		
					            	toDateTime.customDateRangePicker('to', function(toDateTime) {
					            		this.object.toDateTime = toDateTime;
					            	}.bind(this), {
					            		startDate: this.object.toDateTime,
					            		minDate : fromDateTime
					            	});		            		
				            	}.bind(this), {
				            		startDate: this.object.fromDateTime
				            	});
				            },
				    	},
				    	mounted: function() {
				    		this.dailyTimes = searchTypeResult.object;
				    		this.statsTypes = statsDataTypesResult.object;

			    			this.$nextTick(function() {
			    				this.initSearchArea();
			    			});
				    	}
				    });				
					
				    var vmList = new Vue({
				        el: '#' + createPageObj.getElementId('ImngListObject'),
				        data: {
				        	makeGridObj: null,
				        	totalCount: 0,
				        	requestCount: 0,
				        	successCount: 0,
				        	exceptionCount: 0,
				        	timeoutCount: 0,
				        },        
				        methods: $.extend(true, {}, listMethodOption, {
				        	initSearchArea: function() {
				        		window.vmSearch.initSearchArea();
				        	},
				        	downloadFile: function() {
				        		var excelForm = document.createElement('form');
				        		
				        		['fromDateTime', 'toDateTime', 'pk.statsType', 'searchType'].forEach(function(key) {
				        			var hiddenField = document.createElement('input');
				        			
				        			hiddenField.setAttribute('type', 'hidden');
				        			hiddenField.setAttribute('name', key);
				        			
				        			var object = window.vmSearch.object;
				        			var value = null;
				        			
				        			key.split('.').forEach(function(info) {
				        				if ('object' === typeof(object[info]))  object = object[info];
				        				else									value = object[info];
				        			});
				        			
				        			hiddenField.setAttribute('value', null === value? '' : value);
				        			
				        			excelForm.appendChild(hiddenField);
				        		});
				        		
		                        var data = new FormData(excelForm);
		                        
		                        window.$startSpinner();

		                        var req = new XMLHttpRequest();
		                        
		                        req.open("POST", "${prefixUrl}/igate/logStatistics/generateExcelOnlineDaily.json", true);

		        				var csrfToken = JSON.parse(localStorage.getItem('csrfToken'));
		        				req.setRequestHeader(csrfToken.headerName, csrfToken.token);
		        				
		        				req.withCredentials = true;
		        				
		                        req.responseType = "blob";
		                        req.send(data);
		                        
		                        req.onload = function (event) {
		                        	window.$stopSpinner();
		                        	
		                        	var blob = req.response;
		                        	var file_name = "<fmt:message>igate.logStatistics.dailyStatistics</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx";

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
				        		searchUri: "/igate/logStatistics/onlineDailyList.json",
				        		viewMode: "${viewMode}",
				              	popupResponse: "${popupResponse}",
				              	popupResponsePosition: "${popupResponsePosition}",
				                pageOptions: {
				                	useClient: true,
				                	perPage: 10
				                },		              	
				              	columns: [		              		
									{
										name: 'pk.logDateTime',
										header: '<fmt:message>head.transaction</fmt:message>' + ' ' + '<fmt:message>head.date</fmt:message>',
										align: 'center',
										width: '20%',
										sortable: true,
									},
									{
										name: 'pk.statsType',
										header: '<fmt:message>igate.logStatistics.classification</fmt:message>',
										align: 'center',
										width: '20%',
										formatter: function(info) {
											if ('I' === info.value) return '<fmt:message>head.online.interface</fmt:message>';
											else if ('O' === info.value) return '<fmt:message>head.online.service</fmt:message>';
											else if ('R' === info.value) return '<fmt:message>head.file.interface</fmt:message>';
											else if ('S' === info.value) return '<fmt:message>head.file.service</fmt:message>';
										},
									},	
									{
										name: 'requestCount',
										header: '<fmt:message>igate.logStatistics.requestCount</fmt:message>',
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.requestCount);
										}
									},
									{
										name: 'successCount',
										header: '<fmt:message>igate.logStatistics.successCount</fmt:message>',
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.successCount);
										}								
									},
									{
										name: 'exceptionCount',
										header: '<fmt:message>igate.logStatistics.exceptionCount</fmt:message>',
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.exceptionCount);
										}								
									},
									{
										name: 'timeoutCount',
										header: '<fmt:message>igate.logStatistics.timeoutCount</fmt:message>',
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.timeoutCount);
										}								
									},
									{
										name: 'responseTotal',
										header: '<fmt:message>igate.logStatistics.responseTotal</fmt:message>' + " (ms)",
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.responseTotal);
										}								
									},
									{
										name: 'responseMax',
										header: '<fmt:message>igate.logStatistics.responseMax</fmt:message>' + " (ms)",
										align: 'right',
										width: '15%',
										sortable: true,
										formatter: function(info) {
											return numberWithComma(info.row.responseMax);
										}								
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
				});
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