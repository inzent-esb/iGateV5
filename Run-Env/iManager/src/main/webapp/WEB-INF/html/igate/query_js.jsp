<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function() {

	var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('query') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
    	'type' : "text",
        'mappingDataInfo' : "object.queryId",
        'name' : "<fmt:message>igate.query</fmt:message> <fmt:message>head.id</fmt:message>",
        'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
    	'type' : "text",
        'mappingDataInfo' : "object.queryName",
        'name' : "<fmt:message>igate.query</fmt:message> <fmt:message>head.name</fmt:message>",
        'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([
    	{
			'type' : 'basic',
	      	'id' : 'MainBasic',
	      	'name' : '<fmt:message>head.basic.info</fmt:message>',
	      	'detailList': [
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "text",   'mappingDataInfo': 'object.queryId',  'name': "<fmt:message>igate.query</fmt:message> <fmt:message>head.id</fmt:message>", isPk : true},
						{'type': "text",   'mappingDataInfo': 'object.queryName', 'name': "<fmt:message>igate.query</fmt:message> <fmt:message>head.name</fmt:message>"},					
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privilegeId', 'optionFor': 'option in privilegeIds', 'optionValue': 'option', 'optionText': 'option' }, 'name': "<fmt:message>common.privilege</fmt:message>"},				
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privateYn', 'optionFor': 'option in privateYnList', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "<fmt:message>head.private</fmt:message>"},
						{'type': "text",   'mappingDataInfo': 'object.queryGroup',  'name': "<fmt:message>head.group</fmt:message>"},	
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.queryType', 'optionFor': 'option in queryTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.query</fmt:message> <fmt:message>head.type</fmt:message>"},					
						
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.queryLogYn", 'name': "<fmt:message>igate.query.log</fmt:message>"},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.dataSource', 'optionFor': 'option in dataSourceList', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.query.datasource</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "textEvt", 'mappingDataInfo': "object.inputDataModel", 'name': "<fmt:message>igate.query.input.dataModel</fmt:message>",  'clickEvt' : 'clickRecord(object.inputRecordId)'},
						{'type': "textEvt", 'mappingDataInfo': "object.outputDataModel", 'name': "<fmt:message>igate.query.output.dataModel</fmt:message>", 'clickEvt' : "clickRecord(object.outputRecordId)" },						
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.queryStatement", 'name': "<fmt:message>igate.query.statement</fmt:message>", 'height': 200},							
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.queryDesc", 'name': "<fmt:message>igate.query.description</fmt:message>", 'height': 200},							
					]
				},
			]
    	}, {
	       'type' : 'basic',
	       'id' : 'ResouceInUse',
	       'name' : '<fmt:message>head.resource.inuse.info</fmt:message>',
	       'detailList': [
	 			{
	 				'className': 'col-lg-6',
	 				'detailSubList': [
	 					{'type': "text",   'mappingDataInfo': 'object.lockUserId',  'name': "<fmt:message>head.lock.userId</fmt:message>"},
	 					{'type': "text",   'mappingDataInfo': 'object.updateVersion', 'name': "<fmt:message>head.updateVersion</fmt:message>"},
	 					{'type': "text",   'mappingDataInfo': 'object.updateUserId',  'name': "<fmt:message>head.update.userId</fmt:message>"},
	 					{'type': "text",   'mappingDataInfo': 'object.updateTimestamp',  'name': "<fmt:message>head.update.timestamp</fmt:message>"},							
	 				]
	 			},					
	 		]
	     }
	]);

    createPageObj.setPanelButtonList() ;

    createPageObj.panelConstructor(true) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/query/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/query/control.json'/>"
    }) ;

    window.vmSearch = new Vue({
		el : '#' + createPageObj.getElementId('ImngSearchObject'),
      	data : {
        	pageSize : '10',
        	object : {
  	        	queryId : null,
	        	queryName : null,
	        	privilegeId : null,
        	},
      	},
      	methods : {
        	search : function() {
        		vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
          		vmList.makeGridObj.search(this) ;
        	},
        	initSearchArea : function(searchCondition) {
	        	
        		if(searchCondition) {        			
		            for(var key in searchCondition) {
		              this.$data[key] = searchCondition[key];
		      		}
	          	} else {
	            	this.pageSize = '10' ;
	            	this.object.queryId = null ;
	            	this.object.queryName = null ;
	            	this.privilegeId = null;
	          	}	  

          	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        	},
      	},
      	mounted : function() {
        	this.initSearchArea() ;
      	}
    }) ;

    var vmList = new Vue({
    	el : '#' + createPageObj.getElementId('ImngListObject'),
      	data : {
        	makeGridObj : null,
        	newTabPageUrl: "<c:url value='/igate/query.html' />"
      	},
      	methods : $.extend(true, {}, listMethodOption, {
        	initSearchArea : function() {
          		window.vmSearch.initSearchArea() ;
        	}
      	}),
      	mounted : function() {

	        this.makeGridObj = getMakeGridObj() ;

    	    this.makeGridObj.setConfig({
          		elementId : createPageObj.getElementId('ImngSearchGrid'),
          		onClick : SearchImngObj.clicked,
          		searchUri : "<c:url value='/igate/query/search.json' />",
          		viewMode : "${viewMode}",
          		popupResponse : "${popupResponse}",
          		popupResponsePosition : "${popupResponsePosition}",
          		columns : [{
       	  			name : "queryId",
            		header : "<fmt:message>igate.query</fmt:message> <fmt:message>head.id</fmt:message>",
            		align : "left",
            		width: "15%",
          		}, {
		          	name : "queryName",
		            header : "<fmt:message>igate.query</fmt:message> <fmt:message>head.name</fmt:message>",
		            align : "left",
		            width: "20%",
          		},  {
		            name : "privilegeId",
		            header : "<fmt:message>common.privilege</fmt:message>",
		            align : "left",
		            width: "25%"
          		}]
        	}) ;

        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
        
        	this.newTabSearchGrid();
      	}
    }) ;

    window.vmMain = new Vue({
		el : '#MainBasic',
	    data : {
	    	viewMode : 'Open',
		    object : {
		    	queryId : null,
		    	queryName : null,
	            privilegeId : null,
	            privateYn : null,
	            queryGroup: null,
	            dataSource : null,
	            queryLogYn : null,
	            queryStatement : null,
		        inputDataModel : null,
		        outputDataModel : null,
	    		queryDesc: null,
	    	},
	        panelMode : null,
	        privateYnList: [{value: 'Y', name: 'Y'}, {value: 'N', name: 'N'}],
	        privilegeIds : [],
            queryTypes: [],
            dataSourceList : [],
	    },
	    created : function() {
	      	$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(privilegeIdData) {
	    		this.privilegeIds = privilegeIdData.object;	
			}.bind(this));
	      	
	      	PropertyImngObj.getProperties('List.Query.QueryType', false, function(queryTypes) {
		      	this.queryTypes = queryTypes ;    		
			}.bind(this)) ;  
	      	
	    	PropertyImngObj.getProperties('List.Query.DataSource', false, function(dataSourceList) {
		    	this.dataSourceList = dataSourceList.map(function(property) {
		    		property.propertyValue = property.pk.propertyKey + ' - ' + property.propertyValue;
		    		return property;
		    	});
			}.bind(this)) ;  
	    },
      	methods : {
      		loaded : function() {     		      		
      			if(this.object.inputRecordId) this.object.inputDataModel = this.object.inputRecordId + ' - ' +  this.object.inputRecordObject.recordName;
      			if(this.object.outputRecordId) this.object.outputDataModel = this.object.outputRecordId + ' - ' +  this.object.outputRecordObject.recordName;
      		
	    		window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
	            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
	            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
	            window.vmResouceInUse.object.updateTimestamp = this.object.updateTimestamp;
    		},
        	goDetailPanel : function() {
        		panelOpen('detail');
        	},
        	initDetailArea : function(object) {        	
	          	if (object) {  
	        		this.object = object ;
	          	} else {
	        		this.object.queryId = null ;
	              	this.object.queryName = null ;
	              	this.object.privilegeId = null ;
	              	this.object.privateYn = null ;
	              	this.object.queryGroup = null ;
	              	this.object.queryLogYn = null,
	              	this.object.queryStatement = null,
	        	  	this.object.queryType = null ;
	        	  	this.object.dataSource = null ;
	        	  	this.object.inputDataModel = null ;
	        	  	this.object.outputDataModel = null ;
	              	this.object.queryDesc = null ;
	              
	              	window.vmResouceInUse.object.lockUserId = null;
	              	window.vmResouceInUse.object.updateVersion = null;
	              	window.vmResouceInUse.object.updateUserId = null;
	              	window.vmResouceInUse.object.updateTimestamp = null;
	          	}
        	},
        	clickRecord : function(param) {        	
        		localStorage.setItem('selectedMessageModel', JSON.stringify({recordId : param})) ;
				window.open("<c:url value='/igate/record.html' />") ;
        	}
    	},
    }) ;
    
    window.vmResouceInUse = new Vue({
    	el : '#ResouceInUse',
       	data : {
       		object : {
       			lockUserId : null,
       	  		updateVersion : null,
            	updateUserId : null,
            	updateTimestamp : null,
       		}
    	},
    });

    new Vue({
    	el : '#panel-footer',
      	methods : $.extend(true, {}, panelMethodOption)
	});
}) ;
</script>