<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() { 
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('exceptionCode');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{
			'type': "text", 
			'mappingDataInfo': "object.exceptionCode", 
			'name': "<fmt:message>igate.exceptionCode</fmt:message>", 
			'placeholder': "<fmt:message>head.searchCode</fmt:message>"
		},
		{
			'type' : "modal",
			'mappingDataInfo' : {
				'url' : '/igate/standardCode.html',
				'modalTitle' : '<fmt:message>igate.standardCode</fmt:message>',
				'vModel' : "object.standardCode",
				"callBackFuncName" : "setSearchStandardCode"
			},
			'name' : "<fmt:message>igate.standardCode</fmt:message>",
			'placeholder' : "<fmt:message>head.searchCode</fmt:message>"
		}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		searchInitBtn: true,
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		addBtn: hasExceptionCodeEditor,
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
						{'type': "text",   'mappingDataInfo': 'object.exceptionCode', 	'name': "<fmt:message>igate.exceptionCode</fmt:message>", isPk: true},
						{'type': "search", 'mappingDataInfo': {'url' : '/igate/standardCode.html', 'modalTitle': '<fmt:message>igate.standardCode</fmt:message>', 'vModel': "object.standardCode", 'callBackFuncName': 'setSearchPkstandardCode'}, 'name': "<fmt:message>igate.standardCode</fmt:message>", isRequired: true},
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.exceptionDesc", 'name': "<fmt:message>igate.exceptionCode</fmt:message> <fmt:message>head.description</fmt:message>", height:80},
					]
				},	
			]
		},
		{
			'type': 'property',
			'id': 'ExceptionProperties',
			'name': '<fmt:message>igate.exceptionCode.exceptionProperty</fmt:message>',
			'addRowFunc': 'addExceptionProperty',
			'removeRowFunc': 'removeExceptionProperty(index)',
			'mappingDataInfo': 'exceptionProperties',
			'detailList': [
				{'type': 'text', 'mappingDataInfo': 'elm.pk.propertyKey',	'name': '<fmt:message>common.property.key</fmt:message>'}, 
				{'type': 'text', 'mappingDataInfo': 'elm.propertyValue',	'name': '<fmt:message>common.property.value</fmt:message>'}, 
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasExceptionCodeEditor,
		removeBtn: hasExceptionCodeEditor,
		goModBtn: hasExceptionCodeEditor,
		saveBtn: hasExceptionCodeEditor,
		updateBtn: hasExceptionCodeEditor,
		goAddBtn: hasExceptionCodeEditor,
	});

	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/exceptionCode/object.json'/>"
    }); 

    ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/exceptionCode/control.json'/>"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			exceptionCode : null,
    			standardCode : null,
    		}
      	},
      	methods : {
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
                	this.object.exceptionCode = null;
                	this.object.standardCode = null;         
          		}
          	
            	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
            },
            openModal : function(openModalParam) {
            	createPageObj.openModal.call(this, openModalParam);
            },
            setSearchStandardCode: function(param) {
            	this.object.standardCode = param['pk.standardCode'];
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
        	newTabPageUrl: "<c:url value='/igate/exceptionCode.html' />"
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
        		searchUri : "<c:url value='/igate/exceptionCode/search.json' />",
        	    viewMode : "${viewMode}",
        	    popupResponse : "${popupResponse}",
        	    popupResponsePosition : "${popupResponsePosition}",
        	    columns : [
        	    	{
        	    		name : "exceptionCode",
        	        	header : "<fmt:message>igate.exceptionCode</fmt:message>",
        	        	align : "left",
                        width: "30%"
        	    	}, 
        	    	{
        	    		name : "standardCode",
        	        	header : "<fmt:message>igate.standardCode</fmt:message>",
        	        	align : "left",
                        width: "30%"
        	    	}, 
        	    	{
        	        	name : "exceptionDesc",
        	        	header : "<fmt:message>igate.exceptionCode</fmt:message> <fmt:message>head.description</fmt:message>",
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
    			standardCode : null,
    			pk : {},
    			exceptionProperties : []
    		},
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return {
    				exceptionCode : this.object.exceptionCode
    			};
    		}
    	},
    	methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {        		
        		if (object) {
        			this.object = object;
        		}else {
        			this.object.exceptionCode = null;
    				this.object.standardCode = null;
    				this.object.exceptionDesc = null;
    				
    				window.vmExceptionProperties.exceptionProperties = [];
        		}
        		
			},
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},        	
        	setSearchPkstandardCode: function(param) {
        		this.object.standardCode = param['pk.standardCode'];
        	}			
    	}
    });
    
    window.vmExceptionProperties = new Vue({
    	el : '#ExceptionProperties',
    	data : {
    		viewMode : 'Open',
    		exceptionProperties : []
    	},
    	methods : {
    		addExceptionProperty : function() {
    			
    			this.exceptionProperties.push({
    				pk : {}
    			});
    		},
    		removeExceptionProperty : function(index) {
    			this.exceptionProperties = this.exceptionProperties.slice(0, index).concat(this.exceptionProperties.slice(index + 1));
    		},
			validationCheck: function() {
		   		
				var isValidation = true;
				
				for(var i = 0; i < this.exceptionProperties.length; i++) {
					
					var info = this.exceptionProperties[i];
					
					if(!info || !info.pk || !info.pk.propertyKey || !info.propertyValue) {
						warnAlert('<fmt:message>igate.exceptionCode.valNullCheck</fmt:message>');
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
				if(!window.vmExceptionProperties.validationCheck()) return;
				
				SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
		   	},
			saveInfo: function() {		   			
				if(!window.vmExceptionProperties.validationCheck()) return;
				
				SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
		   	}
		})
	});    
});
</script>