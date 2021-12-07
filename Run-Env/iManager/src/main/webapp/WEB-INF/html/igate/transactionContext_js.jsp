<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('transactionContext');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.variableId", 'name': "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();

	createPageObj.setMainButtonList({
		searchInitBtn: true,
		totalCount: true,
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		addBtn: hasTransactionContextEditor,
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
						{'type': "text",   'mappingDataInfo': 'object.variableId', 	  'name': "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.id</fmt:message>",		  	  isPk: true},
						{'type': "text",   'mappingDataInfo': 'object.variableType',  'name': "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.type</fmt:message>", 		  isRequired: true},
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea",   'mappingDataInfo': 'object.variableDesc',  'name': "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.description</fmt:message>",  height: 100},						
					]
				},
			]
		},		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasTransactionContextEditor,
		removeBtn: hasTransactionContextEditor,
		goModBtn: hasTransactionContextEditor,
		saveBtn: hasTransactionContextEditor,
		updateBtn: hasTransactionContextEditor,
		goAddBtn: hasTransactionContextEditor,
	});
	
	createPageObj.panelConstructor();	
	
    SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/transactionContext/object.json'/>"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/transactionContext/control.json'/>"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			variableId: null,
    			pk : {}
    		}
    	},
    	methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this, function() {
					$.ajax({
	                    type : "GET",
	                    url : "<c:url value='/igate/transactionContext/rowCount.json' />",
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
                	this.object.variableId = null;            		
            	}
            	
            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
            }        	
      	},
      	mounted: function() {
      		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
    	}
	});

    var vmList = new Vue({
        el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        	newTabPageUrl: "<c:url value='/igate/transactionContext.html' />",
        	totalCount: '0',
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
        		searchUri : "<c:url value='/igate/transactionContext/search.json'/>",
              	viewMode : "${viewMode}",
              	popupResponse : "${popupResponse}",
              	popupResponsePosition : "${popupResponsePosition}",
              	columns : [
              		{
                		name : "variableId",
                		header : "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.id</fmt:message>",
                		align : "left",
                        width: "30%"
              		}, 
              		{
                		name : "variableType",
                		header : "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.type</fmt:message>",
                		align : "left",
                        width: "30%"
              		},
              		{
                		name : "variableDesc",
                		header : "<fmt:message>head.transaction.context</fmt:message> <fmt:message>head.description</fmt:message>",
                		align : "left",
                        width: "40%"
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
        		return {
        			variableId : this.object.variableId
        		};
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
        			this.object.variableType = null;
    				this.object.variableDesc = null;
    				this.object.variableId = null;
        		}	
			}
      	},
    });    
    
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});    
});
</script>