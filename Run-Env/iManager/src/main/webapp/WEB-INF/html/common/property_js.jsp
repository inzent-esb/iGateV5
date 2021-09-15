<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('property');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
	     {
	       'type' : 'datalist',
	       'mappingDataInfo' : {
	          'dataListId': 'propertyId',
	          'vModel': 'object.pk.propertyId',
	          'dataListFor': 'tmp in dataList',
	          'dataListText': 'tmp'
	       },
	       'name': "<fmt:message>head.property</fmt:message> <fmt:message>head.id</fmt:message>",
	       'placeholder' : "<fmt:message>head.searchId</fmt:message>"
	    },
		{'type': "text",	'mappingDataInfo': "object.pk.propertyKey",		'name': "<fmt:message>common.property.key</fmt:message>",							   'placeholder': "<fmt:message>head.searchId</fmt:message>"},	
		{'type': "text", 	'mappingDataInfo': "object.propertyDesc",		'name': "<fmt:message>head.description</fmt:message>", 								   'placeholder': "<fmt:message>head.searchComment</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();

	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasPropertyEditor,
	});
	
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
						{'type': "text", 'mappingDataInfo': "object.pk.propertyId", 'name': "<fmt:message>head.property</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.pk.propertyKey", 'name': "<fmt:message>common.property.key</fmt:message>", 							   isPk: true},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.cipherYn', 'optionFor': 'option in cipherYns', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>common.property.cipher</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.requireYn', 'optionFor': 'option in requireYns', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>common.property.require</fmt:message>"},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.cacheYn', 'optionFor': 'option in cacheYns', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>common.property.cache</fmt:message>"},
						{'type': "text", 	 'mappingDataInfo': "object.propertyValue", 'name': "<fmt:message>common.property.value</fmt:message>", 'isShowFlagDataName': '!("Y" == object.cipherYn && "Y" == object.cacheYn)'},						
						{'type': "password", 'mappingDataInfo': "object.propertyValue", 'name': "<fmt:message>common.property.value</fmt:message>", 'isShowFlagDataName': '"Y" == object.cipherYn && "Y" == object.cacheYn'},						
					]
				},	
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.propertyDesc", 'name': "<fmt:message>head.description</fmt:message>", height:60},							
					]
				},	
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasPropertyEditor,
		removeBtn: hasPropertyEditor,
		goModBtn: hasPropertyEditor,
		saveBtn: hasPropertyEditor,
		updateBtn: hasPropertyEditor,
		goAddBtn: hasPropertyEditor,
	});
	
	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/common/property/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/common/property/control.json' />"
    });
    
    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		uri : "<c:url value='/common/property/propertyIds.json' />",
    		dataList : [],
    		object : {
    			pk : {
    				propertyId: null,
    				propertyKey: null	
    			},
    			propertyDesc: null
    		}
    	},
    	methods : {
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
                	
                	var paramPropertyId = '<c:out value="${object.pk.propertyId}" />';
            		this.object.pk.propertyId = (paramPropertyId)? paramPropertyId : null;
            		
            		this.object.pk.propertyKey = null;	
            		this.object.propertyDesc = null;            		
            	}
            	
        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
            }    		
    	},
    	mounted: function() {
    		this.$nextTick(function() {
    			this.initSearchArea();	
    		}.bind(this));
    		
    		$.getJSON(this.uri, function(data) { 
    			this.dataList = data.object; 
    		}.bind(this)) ;
    	}
    });
    
    var vmList = new Vue({
        el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        	newTabPageUrl: "<c:url value='/common/property.html' />"
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
        		searchUri : "<c:url value='/common/property/search.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "pk.propertyId",
                  		header : "<fmt:message>head.property</fmt:message> <fmt:message>head.id</fmt:message>",
                  		align : "left",
                        width: "25%",
                	}, 
                	{
                		name : "pk.propertyKey",
                  		header : "<fmt:message>common.property.key</fmt:message>",
                  		align : "left",
                        width: "22%",
                	}, 
                	{
                  		name : "propertyValue",
                  		header : "<fmt:message>common.property.value</fmt:message>",
                  		align : "left",
                        width: "27%",
                        formatter: function(info) {
                        	var rtnValue = '';
                        	
                        	if('Y' == info.row.cipherYn && 'Y' == info.row.cacheYn) {
                        		for(var i = 0; i < info.value.length; i++) {
                        			rtnValue += '*';
                        		}                           		
                        	}else {
                        		rtnValue = info.value;
                        	}
                        	
                        	return escapeHtml(rtnValue);
                        }
                	},
                	{
                  		name : "propertyDesc",
                  		header : "<fmt:message>head.description</fmt:message>",
                  		align : "left",
                        width: "26%",
                	},
                	{   name : "cipherYn",
                		hidden : true
                	},
                	{   name : "cacheYn",
                		hidden : true
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
    		object: {
    			pk: {
    				propertyId: null,
    				propertyKey: null,
    			},
    			cipherYn: 'Y',
    			requireYn: 'N',
    			cacheYn: 'N',
    			propertyValue: null,
    			propertyDesc: null,
    		},
    		cipherYns : [],
    		requireYns : [],
    		cacheYns : [],
    		panelMode : null,
    	},
    	computed : {
    		pk: function() {
    			return{
    				'pk.propertyId' : this.object.pk.propertyId,
    				'pk.propertyKey' : this.object.pk.propertyKey,
    			};
    		}
    	},
        created : function() {
        	PropertyImngObj.getProperties('List.Yn', true, function(properties) {
        		this.cipherYns = properties;
        	}.bind(this));

        	PropertyImngObj.getProperties('List.Yn', true, function(properties) {
        		this.requireYns = properties;
        	}.bind(this));

        	PropertyImngObj.getProperties('List.Yn', true, function(properties) {
        		this.cacheYns = properties;
        	}.bind(this));
        },
        methods : {
			goDetailPanel: function() {
				this.$nextTick(function() {
					panelOpen('detail');
				});
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object = object;
        		}else{
    				this.object.cipherYn = 'Y';
    				this.object.requireYn = 'N';
    				this.object.cacheYn = 'N';
    				this.object.propertyValue = null;
    				this.object.propertyDesc = null; 
    				this.object.pk.propertyId = null;
    				this.object.pk.propertyKey = null;
        		}
			}
        }        
    });
    
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});
});
</script>