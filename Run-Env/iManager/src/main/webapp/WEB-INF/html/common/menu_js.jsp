<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){
    
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('menu');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.menuId", 		'name': "<fmt:message>common.menu</fmt:message> <fmt:message>head.id</fmt:message>", 	'placeholder': "<fmt:message>head.searchId</fmt:message>"},		
		{'type': "text", 'mappingDataInfo': "object.menuName", 		'name': "<fmt:message>common.menu</fmt:message> <fmt:message>head.name</fmt:message>",  'placeholder': "<fmt:message>head.searchName</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.parentMenuId", 	'name': "<fmt:message>common.menu.parent</fmt:message>", 								'placeholder': "<fmt:message>head.searchData</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasMenuEditor,
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
						{'type': "text", 'mappingDataInfo': "object.menuId", 'name': "<fmt:message>common.menu</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true}, 
						{'type': "text", 'mappingDataInfo': "object.menuName", 'name': "<fmt:message>common.menu</fmt:message> <fmt:message>head.name</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.menuIcon", 'name': "<fmt:message>common.menu.icon</fmt:message>"},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.openWindow', 'optionFor': 'option in openWindows', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>common.menu.openWindow</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.menuUrl", 'name': "<fmt:message>common.menu.url</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.menuEditor", 'name': "<fmt:message>common.menu.editor</fmt:message>"},
						{'type': "search", 'mappingDataInfo': {'url' : '/common/privilege.html', 'modalTitle': '<fmt:message>common.privilege</fmt:message>', 'vModel': "object.menuPrivilegeId", 'callBackFuncName': 'setSearchPrivilegeId'}, 'name': "<fmt:message>common.menu.privilege</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.parentMenuId", 'name': "<fmt:message>common.menu.parent</fmt:message>"},
					]
				},					
			]
		},	
	]);
	
	createPageObj.setPanelButtonList({
		removeBtn: hasMenuEditor,
		goModBtn: hasMenuEditor,
		saveBtn: hasMenuEditor,
		updateBtn: hasMenuEditor,
		goAddBtn: hasMenuEditor,
	});
	
	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/common/menu/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/common/menu/control.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {}
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
            		this.object.menuId = null;		
            		this.object.menuName = null;
            		this.object.parentMenuId = null;            		
            	}
            	
        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
        		
        		this.$forceUpdate();
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
        	newTabPageUrl: "<c:url value='/common/menu.html' />"
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
        		searchUri : "<c:url value='/common/menu/search.json' />",
        		viewMode : "${viewMode}",
              	popupResponse : "${popupResponse}",
              	popupResponsePosition : "${popupResponsePosition}",
              	columns : [
              		{
              			name : "menuId",
              			header : "<fmt:message>common.menu</fmt:message> <fmt:message>head.id</fmt:message>",
              			align : "left",
                        width: "30%",
              		}, 
              		{
              			name : "menuName",
              			header : "<fmt:message>common.menu</fmt:message> <fmt:message>head.name</fmt:message>",
              			align : "left",
                        width: "40%",
              		}, 
              		{
              			name : "parentMenuId",
              			header : "<fmt:message>common.menu.parent</fmt:message>",
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
    			menuPrivilegeId : null
    		},
    		openWindows : [],
    		panelMode : null    		
    	},
    	computed : {
    		pk : function() {
    			return {
    				menuId : this.object.menuId
    			};
    		}
    	},
    	created : function() {
    		PropertyImngObj.getProperties('List.Yn', true, function(properties) {
    			this.openWindows = properties;
    		}.bind(this));
    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {
        		
        		if(object) {
        			this.object = object;
        		}else{
    				this.object.menuName = null;
    				this.object.menuIcon = null;
    				this.object.menuUrl = null;
    				this.object.openWindow = null;
    				this.object.menuEditor = null;
    				this.object.menuPrivilegeId = null;
    				this.object.parentMenuId = null;
    				this.object.menuId = null;
        		}
			},
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},		
			setSearchPrivilegeId: function(param) {
				this.object.menuPrivilegeId = param.privilegeId;
				this.$forceUpdate();
			}
        }
    });
    
    new Vue({
    	el: '#panel-footer',
    	methods : $.extend(true, {}, panelMethodOption)
    });
});
</script>