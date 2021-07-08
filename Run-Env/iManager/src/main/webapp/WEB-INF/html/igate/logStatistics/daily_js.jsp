<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('daily');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([{
	       'type' : "daterange",
	       'mappingDataInfo': {
	        	'daterangeInfo': [
	         	{'id' :  'searchDateFrom', 'name' : "<fmt:message>head.from</fmt:message>"},
	         	{'id' :  'searchDateTo', 'name' : "<fmt:message>head.to</fmt:message>"},
	       	]
	       }
	    },
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.pk.statsType",
  				'optionFor': 'option in statsTypes',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'statsTypes'
  			},
			'name': "<fmt:message>igate.logStatistics.classification</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.searchType",
  				'optionFor': 'option in dailyTimes',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'dailyTimes'
  			},			
			'name': "<fmt:message>igate.logStatistics.searchType</fmt:message>", 
			'isHideAllOption' : true
		}		
	]);
	
	createPageObj.searchConstructor(true);
		
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		downloadBtn: true,
	});
	
	createPageObj.mainConstructor();
	
	$("#" + createPageObj.getElementId('ImngListObject')).find('.table-responsive').before($("#logStatisticsSummary").show());
	
	PropertyImngObj.getProperties('List.LogStats.statsDataTypes', false, function(pstatsDataTypes){
		
     	PropertyImngObj.getProperties('List.LogStats.DailyTime', true, function(pDailyTime){
     		
     		window.vmSearch = new Vue({
     			el : '#' + createPageObj.getElementId('ImngSearchObject'),
     		    data : {
     		    	pageSize : '10',
     		        object : {
     		        	privilegeId : null,
     		        	fromDateTime : null,
     		        	toDateTime : null,
     		        	searchType : "D",
     		          	pk : {statsType : " ", adapterId : null}
     		        },
     		        dailyTimes : [],
     		        statsTypes : []
     		    },
			 	methods : {
			 		
					search : function() {
						if('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display')) {
							$('#' + createPageObj.getElementId('ImngListObject')).show();
							$('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide();					
						}
						
						vmList.makeGridObj.search(this, function(result) {
							vmList.total(result);
						});
					},
	   	        	initSearchArea: function(searchCondition) {
	   	        		if(searchCondition) {
	   	        			for(var key in searchCondition) {
	   	        			    this.$data[key] = searchCondition[key];
	   	        			}	   	        			
	   	        		}else {
		   	        		this.object.pk.statsType= " ";
		   	        		this.object.searchType = 'D';	   	  
		   	        		this.object.fromDateTime = null;
		   	        		this.object.toDateTime = null;
	   	        		}
	   	        		
		        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statsTypes'), this.object.pk.statsType);
	   	   	        	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#dailyTimes'), this.object.searchType);
	   	   	      		initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
	   	        	},
	   	        	downloadFile: function(){
	   	        		var myForm = document.popForm;
	   	        	  	
	   	        		$("[name=fromDateTime]").val(this.object.fromDateTime);
	   	        	  	$("[name=toDateTime]").val(this.object.toDateTime);
	   	        	  	$("[name=pk\\.statsType]").val(this.object.pk.statsType);
	   	        	  	$("[name=searchType]").val(this.object.searchType);

	   	        	  	var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no,    scrollorbars=no, resizable=no") ;
	   	        	  	myForm.target = "hiddenframe";
	   	        	  	myForm.submit();
	   	        	}
		    	},
	      		created : function(){
	          		this.statsTypes = pstatsDataTypes;
					this.dailyTimes = pDailyTime;
	        	},
	        	mounted : function(){
	        		this.initSearchArea();
	        	}
			});
     		
    		var vmList = new Vue({
    			el: '#' + createPageObj.getElementId('ImngListObject'),
    			data : {
    	      		requestCount : 0,
    	 			successCount : 0,
    	 			exceptionCount : 0,
    	 			timeoutCount : 0,
    	 			makeGridObj: null,
    	 			newTabPageUrl: "<c:url value='/igate/logStatistics/daily.html' />"
    	      	},
    	        methods: $.extend(true, {}, listMethodOption, {
    	        	initSearchArea: function() {
    	        		window.vmSearch.initSearchArea();
    	        	},
    	        	initTotalArea: function(){
    	        		this.requestCount = 0;
    	        		this.successCount = 0;
    	        		this.exceptionCount = 0;
    	        		this.timeoutCount = 0;
    	        	},
    	        	downloadFile: function() {
    	        		window.vmSearch.downloadFile();
    	        	},
    	        	total: function(result){
    	        		
    	        		this.initTotalArea();
    	        		
    	      			var total = result.object.page;
    			 		
    			 		total.forEach(function(element){
    			 			this.requestCount += element.requestCount;
    			 			this.successCount += element.successCount;
    			 			this.exceptionCount += element.exceptionCount;
    			 			this.timeoutCount += element.timeoutCount;
    			 		}.bind(this));
    	      		}
    	        }),
    	        mounted: function() {
    	        	
    	        	this.makeGridObj = getMakeGridObj();
    	        	
    	        	this.makeGridObj.setConfig({
    	        		elementId: createPageObj.getElementId('ImngSearchGrid'),
    	                searchUri : "<c:url value='/igate/logStatistics/dailyList.json' />",
    	                viewMode : "${viewMode}",
    	                popupResponse : "${popupResponse}",
    	                popupResponsePosition : "${popupResponsePosition}",
    	                rowHeaders : ['rowNum'],
    	                columns : [
    	                	{
    	                		name : "pk.logDateTime",
    	                		header : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.date</fmt:message>",
    	                		align : "center",
    	                        width: "20%",
    	                	}, 
    	                	{
    	                		name : "pk.statsType",
    	                		header : "<fmt:message>igate.logStatistics.classification</fmt:message>",
    	                		align : "center",
    	                        width: "20%",
    	                		formatter : function(value){
    	                			switch (value.row['pk.statsType']){
	    	                			case 'I' : {
	    	                				return "<fmt:message>head.online.interface</fmt:message>" ;
	    	                			}
	    	                			case 'O' : {
	    	                				return "<fmt:message>head.online.service</fmt:message>" ;
	    	                			}
	    	                			case 'R' : {
	    	                				return "<fmt:message>head.file.interface</fmt:message>" ;
	    	                			}
	    	                			case 'S' : {
	    	                				return "<fmt:message>head.file.service</fmt:message>" ;
	    	                			}
    	                			}
    	                		}
    	                	}, 
    	                	{
    	                		name : "requestCount",
    	                		header : "<fmt:message>igate.logStatistics.requestCount</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
    	                	}, 
    	                	{
    	                		name : "successCount",
    	                		header : "<fmt:message>igate.logStatistics.successCount</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
    	                	}, 
    	                	{
    	                		name : "exceptionCount",
    	                		header : "<fmt:message>igate.logStatistics.exceptionCount</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
    	                	}, 
    	                	{
    	                		name : "timeoutCount",
    	                		header : "<fmt:message>igate.logStatistics.timeoutCount</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
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

function initDatePicker(vueObj, dateFromSelector,dateToSelector) {
	dateFromSelector.customDateRangePicker('from', function(fromTime) {		
		vueObj.object.fromDateTime = fromTime;
		
		dateToSelector.customDateRangePicker('to', function(toTime) {
			vueObj.object.toDateTime = toTime;
		}, {startDate: vueObj.object.toDateTime	, minDate : fromTime});
	}, {startDate: vueObj.object.fromDateTime});
}
</script>