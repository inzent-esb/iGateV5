<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
var dataCnt = 200;

$(document).ready(function(){
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('adapterControl');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.instanceId",
  				'optionFor': 'option in adapterInstances',
  				'optionValue': 'option.instanceId',
  				'optionText': 'option.instanceId',
  				'optionIf': 'option.instanceType == "T"',
  				'id': 'adapterInstances',
  			},			
			'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
		{
			'type': "text",
			'mappingDataInfo': "object.adapterId",
			'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
			'placeholder': "<fmt:message>head.searchId</fmt:message>"
		}
	]);
	
	createPageObj.searchConstructor(true);
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		totalCount: true,
		startBtn: hasAdapterEditor,
		stopBtn: hasAdapterEditor,
	});
	
	createPageObj.mainConstructor();
	
    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/adapterControl/control.json' />",
    });
    
	$.getJSON("<c:url value='/igate/instance/list.json' />", function(data) {

	    window.vmSearch = new Vue({
	    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
	    	data : {
	    		pageSize : '10',
	    		object : {
	    			adapterId : null,
	    			instanceId : " ",
	    			pk : {}
	    		},
	    		adapterInstances : [],
	    		uri : "<c:url value='/igate/instance/list.json' />"
	    	},
	    	methods: {
				search : function() {
					vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
					
					vmList.makeGridObj.search(this, function() {
    					if(dataCnt <= vmList.makeGridObj.getSearchGrid().getRowCount())
    						normalAlert({message: '<fmt:message>igate.add.search.criteria<fmt:param value="' + dataCnt + '" /></fmt:message>'});
    					
    					vmList.totalCount = vmList.makeGridObj.getSearchGrid().getRowCount();
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
		        		this.object.adapterId = null;	            		
	            	}
	            	
		    		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		  			initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#adapterInstances'), this.object.instanceId);
	            },
				openModal: function(openModalParam) {
					createPageObj.openModal.call(this, openModalParam);	
				}
	    	},
	    	mounted: function() {
				this.initSearchArea();
	  	    },
	  	    created: function(){
	  	    	this.adapterInstances = data.object;
	  	    }
	  	});
    	
		window.vmList = new Vue({
			el: '#' + createPageObj.getElementId('ImngListObject'),
	        data: {
	        	makeGridObj: null,
	        	newTabPageUrl: "<c:url value='/igate/adapterControl.html' />",
	        	totalCount: '0'
	        },
			methods : $.extend(true, {}, listMethodOption, {
	        	initSearchArea: function() {
	        		window.vmSearch.initSearchArea();
	        	},
	        	start: function() {
	        		if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
            		    warnAlert({message : "<fmt:message>head.selectError</fmt:message>"}) ;
            			return;
            		}
	        		
	        		$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
	        			SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.running</fmt:message>');
	        			ControlImngObj.rowControl("start", item.instanceId, $.param({
	        				adapterId : item.queueId
	        			}), item.rowKey);
	        		});
	        	},
	        	stop: function() {
	        		if(SearchImngObj.searchGrid.getCheckedRows().length == 0) {
            		    warnAlert({message : "<fmt:message>head.selectError</fmt:message>"}) ;
            			return;
            		}
	        		
	        		$.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item) {
	        			SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', '<fmt:message>common.stopping</fmt:message>');
	        			ControlImngObj.rowControl("stop", item.instanceId, $.param({
	        				adapterId : item.queueId
	        			}), item.rowKey);
	        		});
	        	}	        	
	        }),
	        mounted: function() {
	        	
	        	this.makeGridObj = getMakeGridObj();
	        	
	        	this.makeGridObj.setConfig({
	        		elementId: createPageObj.getElementId('ImngSearchGrid'),
	        		searchUri : "<c:url value='/igate/adapterControl/searchSnapshot.json' />",
	        		viewMode : "${viewMode}",
	        		popupResponse : "${popupResponse}",
	        	    popupResponsePosition : "${popupResponsePosition}",
	        	    rowHeaders : ['checkbox', 'rowNum'],
	        	    header : {
	        	    	height : 60,
	        	    	complexColumns : [
	        	    		{
	        	    			name : "consumerInfo",
	        	    			header : "<fmt:message>igate.adapterControl.consumerInfo</fmt:message>",
	        	    			childNames : ["consumerCount", "consumerMax"]
	        	    		}, 
	        	    		{
	        	    			name : "messageInfo",
	        	    			header : "<fmt:message>igate.adapterControl.messageInfo</fmt:message>",
	        	    			childNames : ["messageCount", "messageMax"]
	        	    		}
	        	    	]
	        	    },
	        	    columns : [
	        	    	{
	        	    		name : "queueId",
	        	        	header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
	        	        	align : "left",
	                        width: "14%"
	        	      	}, 
	        	      	{
	        	      		name : "status",
	        	        	header : "<fmt:message>head.queue</fmt:message> <fmt:message>head.status</fmt:message>",
	        	        	align : "center",
	                        width: "13%",
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
	        	      		name : "queueMode",
	        	      		header : "<fmt:message>head.queue</fmt:message> <fmt:message>head.mode</fmt:message>",
	        	      		align : "center",
	                        width: "12%",
	        	      		formatter : function(name) {
	        	      			if (name.row.queueMode == "F")		return "File";
	        	      			else if (name.row.queueMode == "D")	return "DB";
	        	      			else if (name.row.queueMode == "M")	return "Memory";
	        	      			else if (name.row.queueMode == "S") return "Shared";
	        	      		}
	        	      	}, 
	        	      	{
	        	      		name : "instanceId",
	        	        	header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
	        	        	align : "left",
	                        width: "12%",
	        	      	}, 
	        	      	{
	        	      		name : "consumerCount",
	        	      		header : "<fmt:message>igate.queue.consumerCount</fmt:message>",
	        	      		align : "right",
	                        width: "8%",
	                        formatter: function(info) {
                        		return numberWithComma(info.row.consumerCount);
                          	}
	        	      	}, 
	        	      	{
	        	      		name : "consumerMax",
	        	      		header : "<fmt:message>igate.queue.consumerMax</fmt:message>",
	        	      		align : "right",
	                        width: "8%",
	                        formatter: function(info) {
                        		return numberWithComma(info.row.consumerMax);
                          	}
	        	      	}, 
	        	      	{
	        	      		name : "messageCount",
	        	      		header : "<fmt:message>igate.queue.messageCount</fmt:message>",
	        	      		align : "right",
	                        width: "8%",
	                        formatter: function(info) {
                        		return numberWithComma(info.row.messageCount);
                          	}
	        	      	}, 
	        	      	{
	        	      		name : "messageMax",
	        	      		header : "<fmt:message>igate.queue.messageMax</fmt:message>",
	        	      		align : "center",
	                        width: "8%",
	        	      		formatter : function(name) {
	        	      			if (name.row.messageMax == "2147483647") return "MAX";
	        	      			else									 return numberWithComma(name.row.messageMax);
	        	      		}
	        	      	}, 
	        	      	{
	        	        	name : "processResult",
	        	        	header : "<fmt:message>head.process.result</fmt:message>",
	        	        	align : "left",
	        	        	defaultValue : " ",
	                        width: "12%",
	        	      	}
	        	     ]	        	    
	        	});
	        	
	        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
	        	
	        	this.newTabSearchGrid();
	        }
	    });	    
	});
});
</script>