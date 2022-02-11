<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('threadPool');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.threadPoolId", 'name': "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasThreadPoolEditor,
		totalCount: true,
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
						{'type': "text", 'mappingDataInfo': "object.threadPoolId", 'name': "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true}, 
						{'type': "text", 'mappingDataInfo': "object.threadMin", 'name': "<fmt:message>igate.threadPool.min</fmt:message>"},						
						{'type': "textEvt", 'mappingDataInfo': "object.threadMax", 'name': "<fmt:message>igate.threadPool.max</fmt:message>",  'changeEvt' : 'isValid'},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.rejectWarnYn', 'optionFor': 'option in rejectWarnYns', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.threadPool.rejectWarnYn</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.rejectPolicy', 'optionFor': 'option in threadPoolRejectPolicy', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.threadPool.rejectPolicy</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.threadIdle", 'name': "<fmt:message>igate.threadPool.idle</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.threadThreshold", 'name': "<fmt:message>igate.threadPool.threshold</fmt:message>"},							
					]
				},					
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasThreadPoolEditor,
		removeBtn: hasThreadPoolEditor,
		goModBtn: hasThreadPoolEditor,
		saveBtn: hasThreadPoolEditor,
		updateBtn: hasThreadPoolEditor,
		goAddBtn: hasThreadPoolEditor,
	});
	
	createPageObj.panelConstructor();	
    
	SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/threadPool/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/threadPool/control.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data :{
    		pageSize : '10',
    		object : {}
    	},
    	methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/igate/threadPool/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                    	vmList.totalCount = numberWithComma(result.object);
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
                	this.object.threadPoolId = null;            		
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
            totalCount: '0',
        	newTabPageUrl: "<c:url value='/igate/threadPool.html' />"
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
                searchUri : "<c:url value='/igate/threadPool/search.json' />",
                viewMode : "${viewMode}",
                popupResponse : "${popupResponse}",
                popupResponsePosition : "${popupResponsePosition}",
                columns : [
	                {
	                  name : "threadPoolId",
	                  header : "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>",
	                  align : "left",
                      width: "20%",
	                },
	                {
	                  name : "rejectPolicy",
	                  header : "<fmt:message>igate.threadPool.rejectPolicy</fmt:message>",
	                  align : "center",
                      width: "16%",
                      formatter : function(value)
                      {
                    	  switch (value.value) {
                    	  	case 'A':  { return "abort" } ;
                    	  	case 'C':  { return "caller runs" } ;
                    	  	case 'D':  { return "discard" } ;
                    	  	case 'O':  { return "discard oldest" } ;
                    	  }
                      }
	                },
	                {
	                  name : "threadMin",
	                  header : "<fmt:message>igate.threadPool.min</fmt:message>",
	                  align : "right",
                      width: "16%",
                      formatter: function(info) {
                  		return numberWithComma(info.row.threadMin);
                      }
	                },
	                {
	                  name : "threadMax",
	                  header : "<fmt:message>igate.threadPool.max</fmt:message>",
	                  align : "right",
                      width: "16%",
                      formatter: function(info) {
                      	return numberWithComma(info.row.threadMax);
                      }
	                },
	                {
	                  name : "threadIdle",
	                  header : "<fmt:message>igate.threadPool.idle</fmt:message>",
	                  align : "right",
                      width: "16%",
                      formatter: function(info) {
                      	return numberWithComma(info.row.threadIdle);
                      }
	                },
	                {
	                  name : "threadThreshold",
	                  header : "<fmt:message>igate.threadPool.threshold</fmt:message>",
	                  align : "right",
                      width: "16%",
                      formatter: function(info) {
                      	return numberWithComma(info.row.threadThreshold);
                      }
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
    		object : {},
    		threadPoolRejectPolicy : [],
    		rejectWarnYns : [],
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return{
    				threadPoolId : this.object.threadPoolId
    			};
    		}
    	},
    	created : function() {
    		PropertyImngObj.getProperties('List.Threadpool.Rejectpolicy', true, function(properties) {
    			this.threadPoolRejectPolicy = properties;
    		}.bind(this));
    		
        	PropertyImngObj.getProperties('List.Yn', true, function(properties) {
    			this.rejectWarnYns = properties;
    		}.bind(this));

    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object=object;
        		}else {
        			this.object.rejectPolicy = null;
    				this.object.threadMin = null;
    				this.object.threadMax = null;
    				this.object.threadIdle = null;
    				this.object.threadThreshold = null;			
    				this.object.threadPoolId = null; 	
    				this.object.rejectWarnYn = null;
        		}
			},
			isValid: function() {
			    if(this.object.threadMax <= 0) {
					alert("<fmt:message>igate.threadPool.max.warn</fmt:message>");
					this.object.threadMax = null;
					this.$forceUpdate();
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