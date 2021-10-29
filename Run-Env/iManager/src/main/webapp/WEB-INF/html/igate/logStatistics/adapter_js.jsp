<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('adapter');
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
		},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		downloadBtn: true,
	});
	
	createPageObj.mainConstructor();
	
	$("#" + createPageObj.getElementId('ImngListObject')).find('.table-responsive').before($("#logStatisticsSummary").show());
	
	PropertyImngObj.getProperties('List.LogStats.statsDataTypes', false, function(pstatsDataTypes){
		
     	PropertyImngObj.getProperties('List.LogStats.SearchType', true, function(pDailyTime){
     		
     		window.vmSearch = new Vue({
     			el : '#' + createPageObj.getElementId('ImngSearchObject'),
		      	data : {
		        	pageSize : '10',
		        	object : {
		          		privilegeId : null,
			          	fromDateTime : null,
			          	toDateTime : null,
			          	searchType : "D",
			          	pk : {
			          		statsType : " ",
			          		adapterId: null,	
			          	}
		        	},
		        	dailyTimes : [],
		        	statsTypes : [],
		    	},
		    	methods: {
	   				search : function() {
	   					vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
	   					
	   					vmList.makeGridObj.getSearchGrid().setPerPage(Number(this.pageSize));
	   					
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
		   	        		this.object.pk.adapterId = null;
		   	        		this.object.pk.statsType= ' ';
		   	        		this.object.searchType = 'D';	   	
		   	        		this.object.fromDateTime = null;
		   	        		this.object.toDateTime = null;
	   	        		}
	   	        		
		        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statsTypes'), this.object.pk.statsType);
	   	   	        	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#dailyTimes'), this.object.searchType);
	   	   	      		initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
	   	        	},
	   				openModal: function(openModalParam) {
	   					createPageObj.openModal.call(this, openModalParam);	
	   				},	   	        	
	   	        	setSearchAdapterId: function(param) {
	   	        		this.object.pk.adapterId = param.adapterId;
	   	        	},
	   	        	downloadFile: function(){
	   	        		var myForm = document.popForm ;

	   	        	  	$("[name=fromDateTime]").val(this.object.fromDateTime);
	   	        	  	$("[name=toDateTime]").val(this.object.toDateTime);
	   	        	  	$("[name=pk\\.statsType]").val(this.object.pk.statsType);
	   	        	  	$("[name=searchType]").val(this.object.searchType);
	   	        	  	$("[name=pk\\.adapterId]").val(this.object.pk.adapterId);

	   	        		var data = new FormData(myForm);

		   				startSpinner();
		   				
		   				var req = new XMLHttpRequest();
		   				req.open("POST", "<c:url value='/igate/logStatistics/generateExcelAdapter.json' />", true);
		   				
		   				req.setRequestHeader('X-CSRF-TOKEN', myForm.elements._csrf.value);
		   				req.responseType = "blob";
		   				req.send(data);
		   				    	  
		   				req.onload = function (event) {
		   					stopSpinner();
		   					var blob = req.response;
		   					var file_name = "<fmt:message>igate.logStatistics.adapterStatistics</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx";
		   					
		   					if(blob.size <= 0){
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
    	 			newTabPageUrl: "<c:url value='/igate/logStatistics/adapter.html' />"
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
    	        		searchUri : "<c:url value='/igate/logStatistics/adapterList.json' />",
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
    	                        sortable: true
    	    			    }, 
    	    			    {
    	    	        		name : "pk.statsType",
    	    	        		header : "<fmt:message>igate.logStatistics.classification</fmt:message>",
    	    	        		align : "center",
    	                        width: "20%",
    	    	        		formatter : function(value){
    	    	          			switch (value.row['pk.statsType']){
    	    		          			case 'I' : {
    	    		            			return "<fmt:message>igate.logStatistics.statsType.1.onlineInterface</fmt:message>" ;
    	    		          			}
    	    		          			case 'O' : {
    	    		            			return "<fmt:message>igate.logStatistics.statsType.2.onlineService</fmt:message>" ;
    	    		          			}
    	    		          			case 'R' : {
    	    		            			return "<fmt:message>igate.logStatistics.statsType.4.fileInterface</fmt:message>" ;
    	    		          			}
    	    		          			case 'S' : {
    	    		            			return "<fmt:message>igate.logStatistics.statsType.5.fileService</fmt:message>" ;
    	    		          			}
    	    		    			}
    	    	        		}
    	    			    }, 
    	    			    {
    	    	        		name : "pk.adapterId",
    	    	        		header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
    	    	        		align : "left",
    	                        width: "15%",
    	    			    }, 
    	    			    {
    	    	        		name : "requestCount",
    	    	        		header : "<fmt:message>igate.logStatistics.requestCount</fmt:message>",
    	    	        		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	    	      		}, 
    	    	      		{
    	    	        		name : "successCount",
    	    	        		header : "<fmt:message>igate.logStatistics.successCount</fmt:message>",
    	    	        		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	    	      		}, 
    	    	      		{
    	    	        		name : "exceptionCount",
    	    	        		header : "<fmt:message>igate.logStatistics.exceptionCount</fmt:message>",
    	    	        		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	    	      		}, 
    	    	      		{
    	    	        		name : "timeoutCount",
    	    	        		header : "<fmt:message>igate.logStatistics.timeoutCount</fmt:message>",
    	    	        		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	    	      		},
    	                	{
    	                		name : "responseTotal",
    	                		header : "<fmt:message>igate.logStatistics.responseTotal</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	                	}, 
    	                	{
    	                		name : "responseMax",
    	                		header : "<fmt:message>igate.logStatistics.responseMax</fmt:message>",
    	                		align : "right",
    	                        width: "15%",
    	                        sortable: true
    	                	}
    	    	      	], 
    	    	      	pageOptions: {
    	    	      		useClient: true,
    	    	      		perPage: 10
    	    	      	}     	    	      	
    	        	});
    	        	
    	        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
    	        	
    	        	$('#' + createPageObj.getElementId('ImngSearchGrid')).find('.tui-pagination').off('click').on('click', resizeSearchGrid);
    	        	
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
		}, {startDate: vueObj.object.toDateTime, minDate : fromTime});
	}, {startDate: vueObj.object.fromDateTime});
}
</script>