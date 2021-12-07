<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('metaHistory');
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
		{'type': "text", 'mappingDataInfo':"object.entityName", 'name': "<fmt:message>common.metaHistory.entityName</fmt:message>", 'placeholder': "<fmt:message>head.searchName</fmt:message>"},
		{'type': "text", 'mappingDataInfo':"object.entityId",	'name': "<fmt:message>common.metaHistory.entityId</fmt:message>",   'placeholder': "<fmt:message>head.searchName</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn : true,
		totalCount: true,
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
						{'type': "text", 'mappingDataInfo': "object.pk.modifyDateTime", 'name': "<fmt:message>head.update.timestamp</fmt:message>", isPk: true},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.modifyType', 'optionFor': 'option in metaHistoryTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>common.metaHistory.modifyType</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.entityName", 'name': "<fmt:message>common.metaHistory.entityName</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.entityId", 'name': "<fmt:message>common.metaHistory.entityId</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.updateUserId", 'name': "<fmt:message>head.update.userId</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.updateRemoteAddress", 'name': "<fmt:message>common.metaHistory.updateRemoteAddress</fmt:message>"},							
					]
				},					
			]
		},
 		{
			'type': 'custom',
			'id': 'ModifiedContents',
			'name': 'Modified Contents',
			'isSubResponsive' : true,
			'getDetailArea': function() {
				return $("#modifiedContentsCt").html();	
			}
		},
	]);

	createPageObj.setPanelButtonList({
		restoreMetaBtn: hasMetaHistoryEditor,
	});
	
	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/common/metaHistory/object.json' />",
    });
    
    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			entityName : null,
    			entityId : null,
    			pk : {
    				
    			}
    		}
    	},
    	methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/common/metaHistory/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                    	vmList.totalCount = result.object;
	                    }
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
            		this.object.modifyDateTimeFrom = null;
            		this.object.modifyDateTimeTo = null;		
            		this.object.entityName = null;
            		this.object.entityId = null;            		
            	}
        		
      			initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
      			initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo'));
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
            totalCount: '0',
        	newTabPageUrl: "<c:url value='/common/metaHistory.html' />"
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
        		searchUri : "<c:url value='/common/metaHistory/search.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        	        	name : "entityName",
        	        	header : "<fmt:message>common.metaHistory.entityName</fmt:message>",
        	        	align : "left",
                        width: "25%",
        	      	},
        	      	{
        		        name : "entityId",
        	        	header : "<fmt:message>common.metaHistory.entityId</fmt:message>",
        	        	align : "left",
                        width: "25%",
        	      	},
        	      	{
        	        	name : "updateUserId",
        	        	header : "<fmt:message>head.update.userId</fmt:message>",
        	        	align : "left",
                        width: "25%",
        	      	},
        	      	{
        				name : "pk.modifyDateTime",
        	        	header : "<fmt:message>head.update.timestamp</fmt:message>",
        	        	align : "center",
                        width: "25%",
        	      	},
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
    		metaHistoryTypes : [],
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return{
    				"pk.modifyId" : this.object.pk.modifyId,
    				"pk.modifyDateTime" : this.object.pk.modifyDateTime
    			};
    		}
    	},
    	created : function() {
    		PropertyImngObj.getProperties('List.MetaHistory.Type', true, function(properties) {
    			window.vmMain.metaHistoryTypes = properties;
    		});
    	},
    	methods : {
    		loaded : function() {
    			window.vmModifiedContents.object = this.object;
    		}
    	},
        methods : {
    		loaded : function() {
    			window.vmModifiedContents.object = this.object;
    		},
			goDetailPanel: function() {
				panelOpen('detail', null, function() {
					if(this.object.entityName==="com.inzent.imanager.repository.meta.User") $("#panel").find('#panel-footer').find('#restoreMetaBtn').hide();
					else if(this.object.beforeDataString) $("#panel").find('#panel-footer').find('#restoreMetaBtn').show();
					else							 $("#panel").find('#panel-footer').find('#restoreMetaBtn').hide();
				}.bind(this));
			},    		
        	initDetailArea: function() {
				this.object.pk.modifyDateTime = null;
				this.object.modifyType = null;
				this.object.entityName = null;
				this.object.entityId = null;
				this.object.updateUserId = null;
				this.object.updateRemoteAddress = null;							
			},
        },
    });
    
    window.vmModifiedContents = new Vue({
    	el : '#ModifiedContents',
    	data : {
    		viewMode : 'Open',
    		object : {
    			pk : {}
    		}
    	},
    	computed : {
    		pk : function() {
    			return{
    				"pk.modifyId" : this.object.pk.modifyId,
    	            "pk.modifyDateTime" : this.object.pk.modifyDateTime
    			};
    		}
    	}
    });
	
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption, {
			restoreMeta: function() {
				SaveImngObj.submit("<c:url value='/common/metaHistory/restore.json' />", $.param({
					'pk.modifyDateTime' : window.vmMain.object.pk.modifyDateTime,
					'pk.modifyId' : window.vmMain.object.pk.modifyId
				}), "<fmt:message>common.metaHistory.restore.notice</fmt:message>");
			}
		})
	});
});

function initDatePicker(vueObj, dateFromSelector,dateToSelector) {
	dateFromSelector.customDateRangePicker('from', function(fromTime) {		
		vueObj.object.modifyDateTimeFrom = fromTime;
		
		dateToSelector.customDateRangePicker('to', function(toTime) {
			vueObj.object.modifyDateTimeTo = toTime;
		}, {startDate: vueObj.object.modifyDateTimeTo, minDate : fromTime});
	}, {startDate: vueObj.object.modifyDateTimeFrom});
}
</script>