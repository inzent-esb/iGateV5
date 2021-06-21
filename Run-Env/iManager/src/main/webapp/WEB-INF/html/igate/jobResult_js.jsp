<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('jobResult');
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
	{'type': "modal", 'mappingDataInfo': {'url' : '/igate/job.html', 'modalTitle': '<fmt:message>igate.job</fmt:message>', 'vModel': "object.pk.jobId", 'callBackFuncName': 'setSearchJobId'}, 'name': "<fmt:message>igate.job</fmt:message> <fmt:message>head.id</fmt:message>",      'placeholder': "<fmt:message>head.searchId</fmt:message>"},
	{'type': "modal", 'mappingDataInfo': {'url' : '/igate/instance.html', 'modalTitle': '<fmt:message>igate.instance</fmt:message>', 'vModel': "object.pk.instanceId", 'callBackFuncName': 'setSearchInstanceId'}, 'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"}
	]);
	
	createPageObj.searchConstructor();

    createPageObj.setMainButtonList({
    	newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
        searchInitBtn : true
    }) ;

	createPageObj.mainConstructor();
	
	createPageObj.setTabList([
		{
			'type': 'basic',
			'id': 'MainBasic',
			'name': '<fmt:message>head.basic.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.pk.scheduledDateTime", 'name': "<fmt:message>igate.jobResult.scheduledDateTime</fmt:message>", 			  isPk: true}, 
						{'type': "text", 'mappingDataInfo': "object.pk.jobId", 			   'name': "<fmt:message>igate.job</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.pk.instanceId", 	   'name': "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.successYn", 		   'name': "<fmt:message>igate.jobResult.successYn</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						
						{'type': "text", 'mappingDataInfo': "object.executeTimestamp",	   'name': "<fmt:message>igate.jobResult.executeTimestamp</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.exceptionMessage", 	   'name': "<fmt:message>head.exception.message</fmt:message>"},	
						{'type': "text", 'mappingDataInfo': "object.exceptionDateTime",    'name': "<fmt:message>igate.jobResult.exceptionDateTime</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.exceptionId", 		   'name': "<fmt:message>head.exception</fmt:message> <fmt:message>head.id</fmt:message>"}
					]
				},				
			]
		}		
	]);
	
	createPageObj.setPanelButtonList(null);
	
	createPageObj.panelConstructor(true);
	
	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/jobResult/object.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			pk : {
    				jobId : null,
    				instanceId : null
    			}
    		}
    	},
    	methods: {
			search : function() {
				if('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display')) {
					$('#' + createPageObj.getElementId('ImngListObject')).show();
					$('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide();					
				}
				
				vmList.makeGridObj.search(this);
			},
            initSearchArea: function(searchCondition) {
            	
            	if(searchCondition) {
            		for(var key in searchCondition) {
            		    this.$data[key] = searchCondition[key];
            		}            		
            	}else {
                	this.pageSize = '10';
            		this.object.fromScheduledDateTime = null;
            		this.object.toScheduledDateTime = null;            	
            		this.object.pk.jobId = null;	
            		this.object.pk.instanceId = null;            		
            	}
            	
    	   		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
    	   		initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
            },
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},
            setSearchJobId: function(param) {
            	console.log(param)
            	this.object.pk.jobId = param.jobId;
            },
            setSearchInstanceId: function(param) {
            	this.object.pk.instanceId = param.instanceId;
            }
    	},
    	mounted: function() {
			this.initSearchArea();
    	}
    });
    
    var vmList = new Vue({
        el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        	newTabPageUrl: "<c:url value='/igate/jobResult.html' />"
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
        		searchUri : "<c:url value='/igate/jobResult/search.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "pk.scheduledDateTime",
        	        	header : "<fmt:message>igate.jobResult.scheduledDateTime</fmt:message>",
        	        	align : "center",
        	            width: "40%",
        	      	},
        	      	{
        	        	name : "pk.instanceId",
        	        	header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
        	        	align : "left",
        	            width: "30%",
        	      	},
        	      	{
        	        	name : "pk.jobId",
        	        	header : "<fmt:message>igate.job</fmt:message> <fmt:message>head.id</fmt:message>",
        	        	align : "left",
        	            width: "30%",
        	      	}
        	    ]        	    
        	});
        	
        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
        	
        	this.newTabSearchGrid();
        }        
    });	    

    window.vmMain = new Vue({
    	el : '#MainBasic',
    	data : {
    		viewMode : 'Open',
    		object : {
    			pk : {}
    		},
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return{
    				"pk.scheduledDateTime" : this.object.pk.scheduledDateTime,
    	            "pk.instanceId" : this.object.pk.instanceId,
    	            "pk.jobId" : this.object.pk.jobId
    			} ;
    		}
    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object=object;
        		}else {
    				this.object.successYn = null;
    				this.object.executeTimestamp = null;
    				this.object.exceptionMessage = null;	
    				this.object.exceptionDateTime = null;
    				this.object.exceptionId = null;
        			this.object.pk.scheduledDateTime = null; 
    				this.object.pk.jobId = null;
    				this.object.pk.instanceId = null;
        		}
			}
        },    	
    }) ;	
	
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});    
});

function initDatePicker(vueObj, dateFromSelector,dateToSelector) {
	dateFromSelector.customDateRangePicker('from', function(fromTime) {		
		vueObj.object.fromScheduledDateTime = fromTime;
			
		dateToSelector.customDateRangePicker('to', function(toTime) {
			vueObj.object.toScheduledDateTime = toTime;
		}, {startDate: vueObj.object.toScheduledDateTime, minDate : fromTime});
	}, {startDate: vueObj.object.fromScheduledDateTime});
}
</script>