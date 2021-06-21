<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('interfaceRecognize');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.pk.telegramValue",  'name': "<fmt:message>igate.telegramValue</fmt:message>", 'placeholder': "<fmt:message>head.searchTelegram</fmt:message>"},
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/interface.html', 'modalTitle': '<fmt:message>igate.interface</fmt:message>', 'vModel': "object.interfaceId", 'callBackFuncName': 'setSearchInterfaceId'},  'name': "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		searchInitBtn: true,
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		addBtn: hasInterfaceEditor,
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
						{'type': "search", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'warning': "<fmt:message>igate.interfaceRecognize.changeWarn</fmt:message>", isPk: true},
						{'type': "text",   'mappingDataInfo': 'object.pk.telegramValue',  'name': "<fmt:message>igate.telegramValue</fmt:message>", isPk: true},
						{'type': "search", 'mappingDataInfo': {'url' : '/igate/interface.html', 'modalTitle': '<fmt:message>igate.interface</fmt:message>', 'vModel': "object.interfaceId", 'callBackFuncName': 'setSearchInterfaceId'}, 'name': "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>", isRequired: true },
					]
				},
			]
		},		
	]);

	createPageObj.setPanelButtonList({
		dumpBtn: hasInterfaceEditor,
		removeBtn: hasInterfaceEditor,
		goModBtn: hasInterfaceEditor,
		saveBtn: hasInterfaceEditor,
		updateBtn: hasInterfaceEditor,
		goAddBtn: hasInterfaceEditor,
	});
	
	createPageObj.panelConstructor();
	
	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/interfaceRecognize/object.json'/>"
    });

    ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/interfaceRecognize/control.json'/>"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			interfaceId : null,
    			pk : {
    				adapterId : null,
    				telegramValue: null
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
          			this.object.pk.adapterId = null;
          			this.object.pk.telegramValue = null;
          			this.object.interfaceId = null;      				
      			}
      			
      			initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
      		},
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},
            setSearchAdapterId: function(param) {
            	this.object.pk.adapterId = param.adapterId;
            },
            setSearchInterfaceId: function(param) {
            	this.object.interfaceId = param.interfaceId;
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
        	newTabPageUrl: "<c:url value='/igate/interfaceRecognize.html' />"
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
        		searchUri : "<c:url value='/igate/interfaceRecognize/search.json'/>",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
              			name : "pk.adapterId",
                		header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
                		align : "left",
                        width: "25%"
              		}, 
              		{
                		name : "pk.telegramValue",
                		header : "<fmt:message>igate.telegramValue</fmt:message>",
                		align : "left",
                        width: "50%"
              		}, 
              		{
                		name : "interfaceId",
                		header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
                		align : "left",
                        width: "25%"
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
    			interfaceId : null,
    			pk : {
    				adapterId : null
    			}
    		},
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return {
    				'pk.adapterId' : this.object.pk.adapterId,
    				'pk.telegramValue' : this.object.pk.telegramValue
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
        		} else {
        			this.object.interfaceId = null;
        			this.object.pk.adapterId = null;
            		this.object.pk.telegramValue = null;
        		}	           		
			},
			openModal: function(openModalParam) {
				
				if('/igate/interface.html' == openModalParam.url) {
					openModalParam.modalParam = {
						searchAdapter : window.vmMain.object.pk.adapterId		
					};					
				}
				
				createPageObj.openModal.call(this, openModalParam);	
			},
			setSearchAdapterId: function(param) {
				this.object.pk.adapterId = param.adapterId;
            	this.object.interfaceId = null;
			},
			setSearchInterfaceId: function(param) {
				this.object.interfaceId = param.interfaceId;
			},			
    	},
        watch: {
      	  panelMode: function() {
      		if(this.panelMode != "add") $("#panel").find('.warningLabel').hide();
      	  }
        }    	
    });    
    
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});
});
</script>