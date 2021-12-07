<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('standardCode');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.standardCode</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text",  'mappingDataInfo': "object.pk.standardCode", 'name': "<fmt:message>igate.standardCode</fmt:message>", 'placeholder': "<fmt:message>head.searchCode</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		searchInitBtn: true,
		totalCount: true,
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		addBtn: hasStandardCodeEditor,
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
						{'type': "search", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.standardCode</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true},
						{'type': "text",   'mappingDataInfo': 'object.pk.standardCode',  'name': "<fmt:message>igate.standardCode</fmt:message>", isPk: true},
						{'type': "text",   'mappingDataInfo': 'object.localCode', 		 'name': "<fmt:message>igate.standardCode.localCode</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text",   'mappingDataInfo': 'object.message1',  'name': "<fmt:message>igate.standardCode.message1</fmt:message>"},
						{'type': "text",   'mappingDataInfo': 'object.message2',  'name': "<fmt:message>igate.standardCode.message2</fmt:message>"},
						{'type': "text",   'mappingDataInfo': 'object.message3',  'name': "<fmt:message>igate.standardCode.message3</fmt:message>"},							
					]
				},					
			]
		},
		{
			'type': 'property',
			'id': 'StandardCodeLocales',
			'name': '<fmt:message>head.property</fmt:message>',
			'addRowFunc': 'addStandardCodeLocale',
			'removeRowFunc': 'removeStandardCodeLocale(index)',
			'mappingDataInfo': 'standardCodeLocales',
			'detailList': [
				{'type': 'text', 'mappingDataInfo': 'elm.pk.localeCode', 'name': '<fmt:message>igate.message.locale</fmt:message>'},
				{'type': 'text', 'mappingDataInfo': 'elm.message1',	'name': '<fmt:message>igate.standardCode.message1</fmt:message>'}, 
				{'type': 'text', 'mappingDataInfo': 'elm.message2',	'name': '<fmt:message>igate.standardCode.message2</fmt:message>'}, 
				{'type': 'text', 'mappingDataInfo': 'elm.message3',	'name': '<fmt:message>igate.standardCode.message3</fmt:message>'}
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasStandardCodeEditor,
		removeBtn: hasStandardCodeEditor,
		goModBtn: hasStandardCodeEditor,
		saveBtn: hasStandardCodeEditor,
		updateBtn: hasStandardCodeEditor,
		goAddBtn: hasStandardCodeEditor,
	});
	
	createPageObj.panelConstructor();	
	
	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/standardCode/object.json' />"
	});
	
	ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/standardCode/control.json' />"
	});
	
	window.vmSearch = new Vue({
		el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            pk : {
              adapterId : null,
              standardCode: null,
            }
          }
        },
        methods: {
        	search : function() {
        		vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
        		vmList.makeGridObj.search(this, function() {
        			$.ajax({
 	                    type : "GET",
 	                    url : "<c:url value='/igate/standardCode/rowCount.json' />",
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
					this.object.pk.adapterId = null;
					this.object.pk.standardCode = null;					
				}
        	  
				initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			},
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},
			setSearchAdapterId: function(param) {
				this.object.pk.adapterId = param.adapterId;
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
        	newTabPageUrl: "<c:url value='/igate/standardCode.html' />",
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
                searchUri : "<c:url value='/igate/standardCode/search.json' />",
                viewMode : "${viewMode}",
                popupResponse : "${popupResponse}",
                popupResponsePosition : "${popupResponsePosition}",
                columns : [
                	{
                		name : "pk.adapterId",
                		header : "<fmt:message>igate.standardCode</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
                		align : "left",
                        width: "15%"
                	}, 
                	{
                		name : "pk.standardCode", 
                		header : "<fmt:message>igate.standardCode</fmt:message>",
                		align : "left",
                        width: "12%"
                	}, 
                	{
                		name : "message1",
                  		header : "<fmt:message>igate.standardCode.message1</fmt:message>",
                  		align : "left",
                        width: "20%"
                	}, 
                	{
                		name : "message2",
                  		header : "<fmt:message>igate.standardCode.message2</fmt:message>",
                  		align : "left",
                        width: "20%"
                	}, 
                	{
                		name : "message3",
                		header : "<fmt:message>igate.standardCode.message3</fmt:message>",
                		align : "left",
                        width: "20%"
                	}, 
                	{
                		name : "localCode",
                		header : "<fmt:message>igate.standardCode.localCode</fmt:message>",
                		align : "left",
                        width: "12%"
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
    			pk : {
    				adapterId : null
    			},
    			standardCodeLocales : []
    		},
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return {
    				'pk.adapterId' : this.object.pk.adapterId,
    				'pk.standardCode' : this.object.pk.standardCode
    			};
    		}
    	},
    	methods : {
			goDetailPanel: function() {
				panelOpen('detail');				
			},
    		initDetailArea: function(object) {        		
    			
    			if(object) {
        			this.object = object;
        		}else {
    				this.object.localCode = null;
    				this.object.message1 = null;
    				this.object.message2 = null;
    				this.object.message3 = null;			
    				this.object.pk.adapterId = null;
    				this.object.pk.standardCode = null;
    				
    				window.vmStandardCodeLocales.standardCodeLocales = [];
        		}
			},
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},		
			setSearchAdapterId: function(param) {
				this.object.pk.adapterId = param.adapterId;
			}
    	}
    });
    
    window.vmStandardCodeLocales = new Vue({
    	el : '#StandardCodeLocales',
    	data : {
    		viewMode : 'Open',
    		standardCodeLocales : []
    	},
        methods : {
        	addStandardCodeLocale : function() {
        		this.standardCodeLocales.push({
        			pk : {}
        		});
        	},
        	removeStandardCodeLocale : function(index) {
        		this.standardCodeLocales = this.standardCodeLocales.slice(0, index).concat(this.standardCodeLocales.slice(index + 1));
        	},
			validationCheck: function() {
		   		
				var isValidation = true;
				
				for(var i = 0; i < this.standardCodeLocales.length; i++) {
					
					var info = this.standardCodeLocales[i];
					
					if(!info || !info.pk || !info.pk.localeCode) {
						warnAlert({message : '<fmt:message>igate.standardCode.valNullCheck</fmt:message>'});
						isValidation = false;
						break;
					}
				}
		   		
		   		return isValidation;
		   	}
        }
    });
	
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption, {
			updateInfo: function() {	
				if(!window.vmStandardCodeLocales.validationCheck()) return;

				SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
				
		   	},
			saveInfo: function() {		   		
				if(!window.vmStandardCodeLocales.validationCheck()) return;
	    		
				SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
		   	},
		})
	});
});
</script>