<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
var dataCnt = 200;

$(document).ready(function(){
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('connectorControl');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.instanceId",
  				'optionFor': 'option in connectorInstances',
  				'optionValue': 'option.instanceId',
  				'optionText': 'option.instanceId',
  				'optionIf': 'option.instanceType == "T"',
  				'id': 'connectorInstances',
  			},			
			'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},	
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.statusInfo",
  				'optionFor': 'option in connotorStatusInfos',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'connotorStatusInfos'
  			},			
			'name': "<fmt:message>head.status</fmt:message> <fmt:message>head.info</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		}, 
		{
			'type': "text", 
			'mappingDataInfo': "object.connectorId", 
			'name': "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>", 
			'placeholder': "<fmt:message>head.searchId</fmt:message>"
		},	
		{
			'type': "text", 
			'mappingDataInfo': "object.connectorName", 
			'name': "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>", 
			'placeholder': "<fmt:message>head.searchName</fmt:message>"},	
		{
			'type': "text", 
			'mappingDataInfo': "object.adapterId", 
			'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 
			'placeholder': "<fmt:message>head.searchId</fmt:message>"
		},	
	]);
	
	createPageObj.searchConstructor(true);
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		startBtn: hasConnectorEditor,
		stopBtn: hasConnectorEditor,
		stopForceBtn: hasConnectorEditor,
		interruptBtn: hasConnectorEditor,
		blockBtn: hasConnectorEditor,
		unblockBtn: hasConnectorEditor,
	});
	
	createPageObj.mainConstructor();
	
	ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/connectorControl/control.json' />",
	});	
	
	$.getJSON("<c:url value='/igate/instance/list.json' />", function(data) {  
  	  
        PropertyImngObj.getProperties('List.Connector.StatusInfo', true, function(connotorStatusInfos){

        	window.vmSearch = new Vue({
        		el : '#' + createPageObj.getElementId('ImngSearchObject'),
                data : {
                	pageSize : '10',
                	object : {
                		adapterId : null,
                		connectorId : null,
                		instanceId : " ",
                		statusInfo : " ",
                		connectorName : null,
                	},
                	connotorStatusInfos : [],
                	connectorInstances : [],
                	isInitConnectorInstances : false,
                	uri : "<c:url value='/igate/instance/list.json' />"
                },
                methods: {
        			search : function() {
        				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
        				vmList.makeGridObj.search(this, function() {
        					if(dataCnt <= vmList.makeGridObj.getSearchGrid().getRowCount())
        						normalAlert({message: '<fmt:message>igate.add.search.criteria<fmt:param value="' + dataCnt + '" /></fmt:message>'});
        				});
        			},
                    initSearchArea: function(searchCondition) {
                    	if(searchCondition) {
                    		for(var key in searchCondition) {
                    		    this.$data[key] = searchCondition[key];
                    		}                    		
                    	}else {
                        	this.pageSize = '10';
                        	this.object.instanceId = ' ';
                        	this.object.statusInfo = ' '; 
                    		this.object.connectorId	= null;
                    		this.object.connectorName = null;	
                    		this.object.adapterId = null;                    		
                    	}
                    	
                    	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
                    	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorInstances'), this.object.instanceId);
                    	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connotorStatusInfos'), this.object.statusInfo);
                    },
        			openModal: function(openModalParam) {
        				createPageObj.openModal.call(this, openModalParam);	
        			},
                },
                mounted : function() {
					this.initSearchArea();
             	},
             	created: function() {
             		this.connotorStatusInfos = connotorStatusInfos;
             		this.connectorInstances = data.object;
             	}
        	});
	    	
        	window.vmList = new Vue({
        		el: '#' + createPageObj.getElementId('ImngListObject'),
                data: {
                	makeGridObj: null,
                	newTabPageUrl: "<c:url value='/igate/connectorControl.html' />"
                },
                methods: $.extend(true, {}, listMethodOption, {
                	initSearchArea: function() {
                		window.vmSearch.initSearchArea();
                	},
                	start: function() {
                		if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
        					warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;                			
                			return;
                		}
                		
                		$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
                			SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
                			ControlImngObj.rowControl("start", item.instanceId, $.param({
                				connectorId : item.connectorId
                			}), item.rowKey);
                		});
                	},
					stop: function() {
						if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
        					warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;
                			return;
                		}
						
						$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
							SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
							ControlImngObj.rowControl("stop", item.instanceId, $.param({
								connectorId : item.connectorId
							}), item.rowKey);
						});
					},
					block: function() {
						if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
                			warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;          
                			return;
                		}
						
						$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
							SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
							ControlImngObj.rowControl("block", item.instanceId, $.param({
								connectorId : item.connectorId
							}), item.rowKey);
						})
					},
					unblock: function() {
						if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
        					warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;                			
                			return;
                		}
						
						$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
							SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
							ControlImngObj.rowControl("unblock", item.instanceId, $.param({
								connectorId : item.connectorId
							}), item.rowKey);
						})
					},
					interrupt: function() {
						if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
        					warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;                			
                			return;
                		}
						
						$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
							SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
							ControlImngObj.rowControl("interrupt", item.instanceId, $.param({
								connectorId : item.connectorId
							}), item.rowKey);
						})
					},
					stopForce: function() {
						if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
        					warnAlert({alertMessage : "<fmt:message>head.selectError</fmt:message>"}) ;                			
                			return;
                		}
						
						normalConfirm({message : "<fmt:message>igate.connectorControl.alert</fmt:message>", callBackFunc : function() {
	                	    $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
	                	    	SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.stopping</fmt:message>');
	                	    	ControlImngObj.rowControl("stopForce", item.instanceId, $.param({
	                	    		connectorId : item.connectorId
	                	    	}), item.rowKey);
							});							
						}});
					}
                }),
                mounted: function() {
                	
                	this.makeGridObj = getMakeGridObj();
                	
                	this.makeGridObj.setConfig({
                		elementId: createPageObj.getElementId('ImngSearchGrid'),
                		searchUri : "<c:url value='/igate/connectorControl/searchSnapshot.json' />",
                		viewMode : "${viewMode}",
                		popupResponse : "${popupResponse}",
                		popupResponsePosition : "${popupResponsePosition}",
                		rowHeaders : [ 'checkbox', 'rowNum'],
                		header : {
                			height : 60,
                			complexColumns : [
                				{
                					name : "sessioninfo",
                					header : "<fmt:message>igate.connectorControl.session</fmt:message> <fmt:message>head.info</fmt:message>",
                					childNames : ["sessionCount", "sessionInuse", "sessionMaxCount"]
                				}, 
                				{
                					name : "threadinfo",
                					header : "<fmt:message>igate.connectorControl.threadInfo</fmt:message>",
                					childNames : ["threadCount", "threadInuse", "threadMax"]
                				}
                			]
                		},
                		columns : [
                			{
                	        	name : "connectorId",
                	        	header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
                		        align : "left",
		                        width: "10%"
                	      	}, 
                	      	{
                	        	name : "connectorName",
                	        	header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>",
                	        	align : "left",
		                        width: "11%"
                	      	}, 
                	      	{
                	        	name : "adapterId",
                	        	header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
                	        	align : "left",
		                        width: "10%"
                	      	}, 
                	      	{
                	        	name : "instanceId",
                	        	header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
                	        	align : "left",
		                        width: "8%"
                	      	}, 
                	      	{
                	        	name : "socketAddress",
                	        	header : "<fmt:message>igate.connectorControl.nodeAdress</fmt:message>",
                	        	align : "left",
		                        width: "8%"
                	      	}, 
                	      	{
                	        	name : "socketPort",
                	        	header : "<fmt:message>igate.connectorControl.port</fmt:message>",
                	        	align : "center",
		                        width: "6%"
                	      	}, 
                	      	{
                	        	name : "sessionCount",
                	        	header : "<fmt:message>igate.connectorControl.create</fmt:message>",
                	        	align : "right",
		                        width: "5%"
                	      	}, 
                	      	{
                	        	name : "sessionInuse",
                	        	header : "<fmt:message>igate.connectorControl.inuse</fmt:message>",
                	        	align : "right",
		                        width: "5%"
                	      	}, 	
                	      	{
                	        	name : "sessionMaxCount",
                	        	header : "<fmt:message>igate.connectorControl.max</fmt:message>",
                	        	align : "right",
		                        width: "5%",
                	        	formatter : function(name) {
                	        		if(name.row.sessionMaxCount == "2147483647") return "MAX";
                	        		else										 return escapeHtml(name.row.sessionMaxCount);
                	        	}
                	      	}, 
                	      	{
                	      		name : "threadCount",
                	      		header : "<fmt:message>igate.connectorControl.create</fmt:message>",
                	      		align : "right",
		                        width: "5%"
                	      	}, 
                	      	{
                	        	name : "threadInuse",
                	        	header : "<fmt:message>igate.connectorControl.inuse</fmt:message>",
                	        	align : "right",
		                        width: "5%"
                	      	}, 
                	      	{
                	        	name : "threadMax",
                	        	header : "<fmt:message>igate.connectorControl.max</fmt:message>",
                	        	align : "right",
		                        width: "5%",
                	        	formatter : function(name) {
                	        		if(name.row.threadMax == "2147483647")  return "MAX";
                	        		else									return escapeHtml(name.row.threadMax);
                	        	}
                	      	}, 
                	      	{
                	        	name : "status",
                	        	header : "<fmt:message>head.status</fmt:message> <fmt:message>head.info</fmt:message>",
                	        	align : "center",
		                        width: "7%",
                	        	formatter : function(name) {	        		
                	        		var backgroundColor = "";
                	        		var fontColor = "#151826";
                	        		
                	        		if(name.row.status == "Down")          {backgroundColor = "" ;}
                	        		else if(name.row.status == "Normal")   {backgroundColor = "#62d36f" ; fontColor = "white" ;}
                	        		else if(name.row.status == "Starting") {backgroundColor = "" ;}
                	        		else if(name.row.status == "Stoping")  {backgroundColor = "" ;}
                	        		else if(name.row.status == "Error")    {backgroundColor = "#ed3137" ; fontColor = "white" ;}
                	        		else if(name.row.status == "Fail")     {backgroundColor = "#9932a1" ; fontColor = "white" ;}
                	        		else if(name.row.status == "Warn")     {backgroundColor = "#b7bf22" ; fontColor = "white" ;}
                	        		else                                   {backgroundColor = "#4e464f" ; fontColor = "white" ;}//Blocking
                	        		
                	        		return '<div style="width:100%;height:100%;background-color:' + backgroundColor + ';color:' +fontColor +';">' + escapeHtml(name.row.status) + '</div>';
                	        	}
                	      	}, 
                	      	{
                	        	name : "processResult",
                	        	header : "<fmt:message>head.process.result</fmt:message>",
                	        	defaultValue : " ",
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
});
</script>