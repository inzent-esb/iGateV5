<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  
$(document).ready(function() {
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('reservedSchedule');
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
  				'selectModel': "object.pk.scheduleType",
  				'optionFor': 'option in scheduleTypes',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'scheduleTypes'
  			},				
			'name': "<fmt:message>igate.reservedSchedule</fmt:message> <fmt:message>head.type</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
		{
			'type': "select",
  			'mappingDataInfo': {
  				'selectModel': "object.executeStatus",
  				'optionFor': 'option in executeStatus',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'executeStatus'
  			},			
			'name': "<fmt:message>igate.reservedSchedule.execute.status</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>",
		},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/instance.html', 'modalTitle': '<fmt:message>igate.instance</fmt:message>', 'vModel': "object.pk.instanceId", 'callBackFuncName': 'setSearchInstanceId'}, 'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
	});
	
	createPageObj.mainConstructor();
	
	createPageObj.setTabList([
		{
			'type': 'basic',
			'id': 'MainBasic',
			'name': '<fmt:message>head.basic.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-4',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.pk.reserveDateTime", 'name': "<fmt:message>igate.reservedSchedule.reserved.dateTime</fmt:message>", 		 isPk: true}, 
						{'type': "text", 'mappingDataInfo': "object.pk.instanceId", 	 'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.pk.reserveSchedule", 'name': "<fmt:message>igate.reservedSchedule</fmt:message>", 							 isPk: true},
					]
				},
				{
					'className': 'col-lg-4',
					'detailSubList': [{
			          'type' : "select",
			          'mappingDataInfo' : {
			            'selectModel' : 'object.pk.scheduleType',
			            'optionFor' : 'option in scheduleTypes',
			            'optionValue' : 'option.pk.propertyKey',
			            'optionText' : 'option.propertyValue'
			          },
			          'name' : "<fmt:message>igate.reservedSchedule</fmt:message> <fmt:message>head.type</fmt:message>",
			          isPk: true
			        },{
			          'type' : "select",
			          'mappingDataInfo' : {
			            'selectModel' : 'object.executeStatus',
			            'optionFor' : 'option in executeStatus',
			            'optionValue' : 'option.pk.propertyKey',
			            'optionText' : 'option.propertyValue'
			          },
			          'name' : "<fmt:message>igate.reservedSchedule.execute.status</fmt:message>",
			        },
						{'type': "text", 'mappingDataInfo': "object.executeTimestamp",  'name': "<fmt:message>igate.reservedSchedule.execute.timestamp</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-4',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.exceptionMessage",   'name': "<fmt:message>head.exception.message</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.exceptionDateTime",  'name': "<fmt:message>igate.reservedSchedule.exception.dateTime</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.exceptionId", 		 'name': "<fmt:message>head.exception</fmt:message> <fmt:message>head.id</fmt:message>"},
					]
				},					
			]
		},		
	]);
	
	createPageObj.setPanelButtonList(null);
	
	createPageObj.panelConstructor(true);	

	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/reservedSchedule/object.json'/>"
	});
	
	ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/reservedSchedule/control.json'/>"
	});
    
	window.vmMain = new Vue({
    	el : '#MainBasic',
        data : {
        	viewMode : 'Open',
        	object : {
        		pk : {}
        	},
        	scheduleTypes : [],
        	executeStatus : [],
    		panelMode : null
        },
        computed : {
        	pk : function() {
        		return {
        			'pk.fieldId' : this.object.pk.fieldId,
        			'pk.metaDomain' : this.object.pk.metaDomain
        		};
        	}
        },
        created : function()
        {
          PropertyImngObj.getProperties('List.ReservedSchedule.ScheduleType', false, function(properties)
              {
                this.scheduleTypes = properties ;
              }.bind(this)) ;

              PropertyImngObj.getProperties('List.ReservedSchedule.ExecuteStatus', false, function(properties)
              {
                this.executeStatus = properties ;
              }.bind(this)) ;
        },
		methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},			
        	initDetailArea: function(object) {
   				this.object.executeTimestamp = null;
   				this.object.exceptionMessage = null;
   				this.object.exceptionDateTime = null;
   				this.object.exceptionId = null;
        		this.object.pk.reserveDateTime = null; 
				this.object.pk.instanceId = null;
				this.object.pk.reserveSchedule = null;
				this.object.pk.scheduleType = null;
				this.object.executeStatus = null;
			}
		},        
    });
	
	PropertyImngObj.getProperties('List.ReservedSchedule.ExecuteStatus', true, function(pExecuteStatus){	  
		
		PropertyImngObj.getProperties('List.ReservedSchedule.ScheduleType', true, function(pScheduleType){
	  		
	    	window.vmSearch = new Vue({
	    		el : '#' + createPageObj.getElementId('ImngSearchObject'),
	    		data : {
	    			pageSize : '10',
	    			object : {
	    				fromReserveDateTime : '',
	    				toReserveDateTime : '',
	    				executeStatus : " ",
	    				pk : {
	    					scheduleType : " ",
	    					instanceId : null
	    				}
	    			},
	    			executeStatus : [],
	    			scheduleTypes : []
	    		},
	    		methods: {
	    			search : function() {
	    				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
	    				
	    				if('' == this.object.pk.instanceId)
	    					this.object.pk.instanceId = null;
	    				
	    				vmList.makeGridObj.search(this);
	    			},
	    	    	initSearchArea: function(searchCondition) {
	    	    		if(searchCondition) {
	    	    			for(var key in searchCondition) {
	    	    			    this.$data[key] = searchCondition[key];
	    	    			}
	    	    		}else {
		    	    		this.pageSize = '10';
		    	    		this.object.fromReserveDateTime = null;
		    	    		this.object.toReserveDateTime = null;
		    	    		this.object.pk.instanceId = null;	    	    		
		    	    		this.object.pk.scheduleType = ' ';
		    	    		this.object.executeStatus = ' ';	    	    			
	    	    		}
	    	    		
		    	 		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		    	 		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#scheduleTypes'), this.object.pk.scheduleType);
		    	 		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#executeStatus'), this.object.executeStatus);
		    	 		
		    	 		initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
	    	    	
		    	 		this.$forceUpdate();
	    	    	},
	    			openModal: function(openModalParam) {
	    				
	    				if('/igate/instance.html' == openModalParam.url) {
	    					openModalParam.modalParam = {
	    						instanceType: 'T'		
	    					};
	    				}
	    				
	    				createPageObj.openModal.call(this, openModalParam);	
	    			},
	    	    	setSearchInstanceId: function(modal) {
	    	    		this.object.pk.instanceId = modal.instanceId;
	    	    	}	    	    	
	    	    },
	    		mounted: function() {
					this.initSearchArea();
	    	 	},
	    	 	created: function(){
	    	 		this.executeStatus = pExecuteStatus;
	    	 		this.scheduleTypes = pScheduleType
	    	 	}
	    	});
	    	
	    	var vmList = new Vue({
		        el: '#' + createPageObj.getElementId('ImngListObject'),
		        data: {
		        	makeGridObj: null,
		        	newTabPageUrl: "<c:url value='/igate/reservedSchedule.html' />"
		        },
		        methods : $.extend(true, {}, listMethodOption, {
		        	initSearchArea: function() {
		        		window.vmSearch.initSearchArea();
		        	}
		        }),
		        mounted: function() {
		        	
		        	this.makeGridObj = getMakeGridObj();
		        	
		        	this.makeGridObj.setConfig({
		        		elementId: createPageObj.getElementId('ImngSearchGrid'),
		        		onClick: SearchImngObj.clicked,
		        		searchUri : "<c:url value='/igate/reservedSchedule/search.json'/>",
		        		viewMode : "${viewMode}",
		        		popupResponse : "${popupResponse}",
		        		popupResponsePosition : "${popupResponsePosition}",
		        		columns : [
		        			{
		        	        	name : "pk.reserveDateTime",
		        	        	header : "<fmt:message>igate.reservedSchedule.reserved.dateTime</fmt:message>",
		        	        	align : "center",
		                        width: "25%"
		        	      	}, 
		        	      	{
		        	        	name : "pk.instanceId",
		        	        	header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
		        	        	align : "left",
		                        width: "25%"
		        	      	}, 
		        	      	{
		        	        	name : "pk.reserveSchedule",
		        	        	header : "<fmt:message>igate.reservedSchedule</fmt:message>",
		        	        	align : "left",
		                        width: "30%"
		        	      	},
		        	      	{
		        	        	name : "pk.scheduleType",
		        	        	header : "<fmt:message>igate.reservedSchedule</fmt:message> <fmt:message>head.type</fmt:message>",
		        	        	align : "left",
		                        width: "20%",
                	        	formatter : function(type) {                	        		
                	        		if(type.value == "J") 	   return "Job";
                	        		else if(type.value == "I") return "Interface";	 
                	        		else 					   return escapeHtml(type.value);
                	        	}
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
		vueObj.object.fromReserveDateTime = fromTime;
			
		dateToSelector.customDateRangePicker('to', function(toTime) {
			vueObj.object.toReserveDateTime = toTime;
		}, {startDate: vueObj.object.toReserveDateTime, minDate : fromTime});
	}, {startDate: vueObj.object.fromReserveDateTime});
}
</script>