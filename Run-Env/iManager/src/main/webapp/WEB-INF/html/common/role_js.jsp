<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('role');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.roleId",   'name': "<fmt:message>common.role.id</fmt:message>",   'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.roleDesc", 'name': "<fmt:message>head.description</fmt:message>", 'placeholder': "<fmt:message>head.searchComment</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		totalCount: true,
		addBtn: hasRoleEditor,
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
						{'type': "text", 'mappingDataInfo': "object.roleId", 'name': "<fmt:message>common.role.id</fmt:message>", isPk: true}, 
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [ 
						{'type': "textarea", 'mappingDataInfo': "object.roleDesc", 'name': "<fmt:message>head.description</fmt:message>", height:100},
					]
				},
			]
		},
		{
			'type': 'property',
			'id': 'RolePrivileges',
			'name': '<fmt:message>common.role.privilege.info</fmt:message>',
			'addRowFunc': 'addRolePrivilege',
			'removeRowFunc': 'removeRolePrivilege(index)',
			'mappingDataInfo': 'rolePrivileges',
			'detailList': [
				{'type': 'text', 'mappingDataInfo': 'elm.pk.privilegeId', 'name': '<fmt:message>common.privilege</fmt:message>', 'disabled': true}, 
			]
		}	
	]);
	
	createPageObj.setPanelButtonList({
		removeBtn: hasRoleEditor,
		goModBtn: hasRoleEditor,
		saveBtn: hasRoleEditor,
		updateBtn: hasRoleEditor,
		goAddBtn: hasRoleEditor,
	});
	
	createPageObj.panelConstructor();
	
	SaveImngObj.setConfig({ 
		objectUri : "<c:url value='/common/role/object.json' />", 
	});

	window.vmSearch = new Vue({
		el : '#' + createPageObj.getElementId('ImngSearchObject'),
		data : { 
			pageSize : '10', 
			object : {
			    roleId : "",
			    roleDesc : ""
			}
		},
		methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/common/role/rowCount.json' />",
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
					this.object.roleId = null;
					this.object.roleDesc = null;					
				}
				
				initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
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
        	newTabPageUrl: "<c:url value='/common/role.html' />"
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
        		searchUri : "<c:url value='/common/role/search.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "roleId",
        				header : "<fmt:message>common.role.id</fmt:message>",
        				align : "left",
        	              width: "45%",
        			}, 
        			{
        				name : "roleDesc",
        	        	header : "<fmt:message>head.description</fmt:message>",
        	        	align : "left",
        	              width: "55%",
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
				rolePrivileges : [] 
			},
    		panelMode : null 
		},
		computed : {
			pk : function() {
				return { 
					roleId : this.object.roleId 
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
    				this.object.roleDesc = null;
    				this.object.roleId = null;
    				
    				window.vmRolePrivileges.rolePrivileges = [];
        		}  		
			},			
		}
	}); 	
	  
	window.vmRolePrivileges = new Vue({
		el : '#RolePrivileges',
		data : { 
			viewMode : 'Open', 
			rolePrivileges : [] 
		},
        methods : $.extend(true, {}, panelMethodOption, {
			openModal: function(openModalParam) {
				createPageObj.openModal.call(this, openModalParam);	
			},        	
			addRolePrivilege : function() {
				this.openModal({
					url: '/common/privilege.html', 
					modalTitle: '<fmt:message>common.privilege</fmt:message>', 
					callBackFuncName: 'setSearchPrivilegeIdInfoList',
					isMultiCheck: true,
				});
			},
			removeRolePrivilege : function(index) {
				this.rolePrivileges = this.rolePrivileges.slice(0, index).concat(this.rolePrivileges.slice(index + 1)) ;
			},
			setSearchPrivilegeIdInfoList: function(infoList) {
				
				for(var i = 0; i < infoList.length; i++) {
				
					var isExistId = false;
					
					for(var j = 0; j < this.rolePrivileges.length; j++) {
						if(infoList[i].privilegeId == this.rolePrivileges[j].pk.privilegeId) {
							isExistId = true;
							break;
						}
					}
					
					if(isExistId) continue;
					
					this.rolePrivileges.push({pk: {privilegeId: infoList[i].privilegeId}});
				}
			},
        }),	
	});
	
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});
});
</script>