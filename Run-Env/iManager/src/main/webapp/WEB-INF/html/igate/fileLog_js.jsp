<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('fileLog');
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
  				'optionFor': 'option in fileLogInstances',
  				'optionValue': 'option.instanceId',
  				'optionText': 'option.instanceId',
  				'optionIf': 'option.instanceType == "T"',
  				'id': 'fileLogInstances',
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
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
	});
	
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
		          fileLogInstances : [],
		          isInitFileLogInstances: false,
		          uri : "<c:url value='/igate/instance/list.json' />"
		        },
		        methods: {
					search : function() {
						vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
						vmList.makeGridObj.search(this);
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
		            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#fileLogInstances'), this.object.instanceId);
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
		        	this.fileLogInstances = data.object;
		        	this.timeoutYns = timeoutYns;
		        },
			});
			
			var vmList = new Vue({
				el: '#' + createPageObj.getElementId('ImngListObject'),
		        data: {
		        	makeGridObj: null,
		        	newTabPageUrl: "<c:url value='/igate/fileLog.html' />"
		        },
		        methods: $.extend(true, {}, listMethodOption, {
		        	initSearchArea: function() {
		        		window.vmSearch.initSearchArea();
		        	},
		        }),
		        mounted: function() {
		        	
		        	this.makeGridObj = getMakeGridObj();
		        	
		        	this.makeGridObj.setConfig({
		        		elementId: createPageObj.getElementId('ImngSearchGrid'),
		        		searchUri : "<c:url value='/igate/fileLog/search.json' />",
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
		                  		name : "fileName",
		                  		header : "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>",
		                  		align : "left",
		                        width: "11%"
		                	},
		                	{
		                  		name : "fileDate",
		                  		header : "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>",
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
		                	}
		                ]		        	    
		        	});
		        	
		        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
		        	
		        	this.newTabSearchGrid();
		        }
		    });			
		});
	});	
	
	SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/fileLog/object.json' />"
    });
    
    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/fileLog/control.json' />"
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