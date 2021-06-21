<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('javaProject');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.projectId", 'name': "<fmt:message>igate.javaProject.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"}		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasJavaProjectEditor,
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
						{'type': "text", 'mappingDataInfo': "object.projectId", 'name': "<fmt:message>igate.javaProject.id</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.projectName", 'name': "<fmt:message>head.name</fmt:message>"},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.projectType', 'optionFor': 'option in projectTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>head.type</fmt:message>"},
						
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.projectArtifact", 'name': "<fmt:message>igate.javaProject.artifact</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.projectClassPath", 'name': "<fmt:message>igate.javaProject.classPath</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.projectRepository", 'name': "<fmt:message>igate.javaProject.repository</fmt:message>"},						
					]
				},		
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.projectDesc", 'name': "<fmt:message>head.description</fmt:message>", height:60},							
					]
				},	
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasJavaProjectEditor,
		removeBtn: hasJavaProjectEditor,
		goModBtn: hasJavaProjectEditor,
		saveBtn: hasJavaProjectEditor,
		updateBtn: hasJavaProjectEditor,
		goAddBtn: hasJavaProjectEditor,
	});
	
	createPageObj.panelConstructor();	
    
	SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/javaProject/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/javaProject/control.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {}
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
                	this.object.projectId = null;            		
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
        	newTabPageUrl: "<c:url value='/igate/javaProject.html' />"
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
        		searchUri : "<c:url value='/igate/javaProject/search.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "projectId",
        	        	header : "<fmt:message>igate.javaProject.id</fmt:message>",
        	        	align : "left",
                        width: "30%",
        			}, 
        			{
        				name : "projectName",
        	        	header : "<fmt:message>head.name</fmt:message>",
        	        	align : "left",
                        width: "30%",
        			}, 
        			{
        	        	name : "projectDesc",
        	        	header : "<fmt:message>head.description</fmt:message>",
        	        	align : "left",
                        width: "40%",
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
    		projectTypes : [],
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return { 
    				projectId : this.object.projectId 
    			};
    		}
    	},
    	created : function() {
    		PropertyImngObj.getProperties('List.JavaProject.Type', true, function(properties) {
    			this.projectTypes = properties;
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
    				this.object.projectName = null;
    				this.object.projectType = null;
    				this.object.projectArtifact = null;
    				this.object.projectClassPath = null;
    				this.object.projectRepository = null;
    				this.object.projectDesc = null;	
            		this.object.projectId = null;
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