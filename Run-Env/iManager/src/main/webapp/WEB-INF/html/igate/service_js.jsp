<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function() {

	var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('service') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
	   'type' : "text",
	   'mappingDataInfo' : "object.serviceId",
	   'name' :  "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
	   'placeholder' : "<fmt:message>head.searchId</fmt:message>"
	}, {
	    'type' : "text",
	    'mappingDataInfo' : "object.serviceName",
	    'name' :  "<fmt:message>igate.service</fmt:message> <fmt:message>head.name</fmt:message>",
	    'placeholder' : "<fmt:message>head.searchName</fmt:message>"
	}, 
	{
      	'type' : "modal",
      	'mappingDataInfo' : {
	      	'url' : '/igate/adapter.html',
	      	'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
	      	'vModel' : "object.adapterId",
	      	"callBackFuncName" : "setSearchAdapterId"
		},
	    'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
	    'placeholder' : "<fmt:message>head.searchId</fmt:message>"
	},
	{
	    'type' : "text",
	    'mappingDataInfo' : "object.serviceGroup",
	    'name' :  "<fmt:message>head.group</fmt:message>",
	    'placeholder' : "<fmt:message>head.searchId</fmt:message>"
	}]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      downloadBtn : true,
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
						{'type': "text",   'mappingDataInfo': 'object.serviceId',  'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>", isPk : true},
						{'type': "text",   'mappingDataInfo': 'object.serviceName', 'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.name</fmt:message>"},					
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.serviceType', 'optionFor': 'option in serviceTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.type</fmt:message>"},					
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privilegeId', 'optionFor': 'option in privilegeIds', 'optionValue': 'option', 'optionText': 'option' }, 'name': "<fmt:message>common.privilege</fmt:message>"},				
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privateYn', 'optionFor': 'option in privateYnList', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "<fmt:message>head.private</fmt:message>"},
						{'type': "text",   'mappingDataInfo': 'object.serviceGroup',  'name': "<fmt:message>head.group</fmt:message>"},	
						
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.adapterId", 'name': "<fmt:message>igate.adapter</fmt:message>"},
						{'type': "textEvt", 'mappingDataInfo': "object.operationId", 'name': "<fmt:message>igate.operation</fmt:message>",  'clickEvt' : 'clickOperation(object.operationId)'},
						{'type': "text", 'mappingDataInfo': "object.serviceActivity", 'name': "<fmt:message>igate.activity</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-3',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.metaDomain', 'optionFor': 'option in metaDomains', 'optionValue': 'option', 'optionText': 'option' }, 'name': "<fmt:message>igate.service.metaDomain</fmt:message>"},
						{'type': "textEvt", 'mappingDataInfo': "object.requestRecordName", 'name': "<fmt:message>igate.service.request.model</fmt:message>",  'clickEvt' : 'clickRecord(object.requestRecordId)'},
						{'type': "textEvt", 'mappingDataInfo': "object.responseRecordName", 'name': "<fmt:message>igate.service.response.model</fmt:message>", 'clickEvt' : "clickRecord(object.responseRecordId)" },
						
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.serviceDesc", 'name': "<fmt:message>igate.service.description</fmt:message>", 'height': 200},							
					]
				},
			]
    	}, 
    	{
			'type': 'property',
			'id': 'ServiceProperties',
			'name': '<fmt:message>head.extend.info</fmt:message>',
			'mappingDataInfo': 'serviceProperties',
			'detailList': [
				{'type': 'text', 'mappingDataInfo': 'elm.pk.propertyKey',	'name': '<fmt:message>common.property.key</fmt:message>'}, 
				{'type': 'text', 'mappingDataInfo': 'elm.propertyValue',	'name': '<fmt:message>common.property.value</fmt:message>'}, 
				{'type': 'text', 'mappingDataInfo': 'elm.propertyDesc',		'name': '<fmt:message>head.description</fmt:message>'}
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
      objectUri : "<c:url value='/igate/service/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/service/control.json'/>"
    }) ;

    window.vmSearch = new Vue({
		el : '#' + createPageObj.getElementId('ImngSearchObject'),
      	data : {
        	pageSize : '10',
        	object : {
         		serviceId : null,
          		serviceName : null,
          		adapterId : null,
          		serviceGroup : null,
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
	            	this.object.serviceId = null ;
	            	this.object.serviceName = null ;
	            	this.object.adapterId = null ;
	            	this.object.serviceGroup = null;
	          	}	  

          	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        	},
        	openModal : function(openModalParam) {
         		createPageObj.openModal.call(this, openModalParam) ;
        	},
            setSearchAdapterId : function(param){
              	this.object.adapterId = param.adapterId ;
            },
        	setSearchServiceId : function(param) {
          		this.object.serviceId = param.serviceId ;
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
        newTabPageUrl: "<c:url value='/igate/service.html' />"
      },
      methods : $.extend(true, {}, listMethodOption, {
        initSearchArea : function()
        {
          window.vmSearch.initSearchArea() ;
        },
        downloadFile : function() {
			var myForm = document.popForm;
			
       		$("[name=serviceId]").val(window.vmSearch.object.serviceId);
       	  	$("[name=serviceName]").val(window.vmSearch.object.serviceName);
       	  	$("[name=adapterId]").val(window.vmSearch.object.adapterId);
       	  	$("[name=serviceGroup]").val(window.vmSearch.object.serviceGroup);

       	  	var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no,    scrollorbars=no, resizable=no") ;
       	  	myForm.target = "hiddenframe";
       	  	myForm.submit();
		}
      }),
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/service/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "serviceId",
            header : "<fmt:message>igate.service</fmt:message><fmt:message>head.id</fmt:message>",
            align : "left",
            width: "20%"
          }, {
            name : "serviceName",
            header : "<fmt:message>igate.service</fmt:message><fmt:message>head.name</fmt:message>",
            align : "left",
            width: "40%"
          }, {
              name : "adapterId",
              header : "<fmt:message>igate.adapter</fmt:message>",
              align : "left",
              width: "20%"
          }, {
            name : "serviceGroup",
            header : "<fmt:message>head.group</fmt:message>",
            align : "left",
            width: "20%"
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
		    	serviceId : null,
	            serviceName : null,
	            serviceType : null,
	            privilegeId : null,
	            serviceGroup : null,
	        	privateYn: null,
	    		adapterId: null,
	    		operationId: null,
	    		serviceActivity: null,
	    		metaDomain: null,
	    		requestRecordId: null,
	    		responseRecordId: null,
	    		requestRecordName: null,
	    		responseRecordName: null,
	    		serviceDesc: null,
	    		selectedRowService : null,
	    	},
	        panelMode : null,
	        privateYnList: [{value: 'Y', name: 'Y'}, {value: 'N', name: 'N'}],
	        serviceTypes : [],
	        privilegeIds : [],
	        metaDomains : [],
	        serviceProperties : []
	      },
	      created : function() {
	    	PropertyImngObj.getProperties('Property.Service', true, function(properties) {
	    		this.serviceProperties = properties ;    		
		    }.bind(this)) ;  
	        
	    	PropertyImngObj.getProperties('List.Service.ServiceType', true, function(properties) {
	          this.serviceTypes = properties ;
	        }.bind(this)) ;
	    	
	    	$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(privilegeIdData) {
	    		this.privilegeIds = privilegeIdData.object;	
			}.bind(this));
	    	
	    	$.getJSON("<c:url value='/igate/fieldMeta/groups.json'/>", function(metaDomainData) {
				this.metaDomains = metaDomainData.object;
			}.bind(this));
	    	
	    	if (localStorage.getItem('selectedRowService')) {
	        	this.selectedRowService = JSON.parse(localStorage.getItem('selectedRowService')) ;
	          	localStorage.removeItem('selectedRowService') ;
	          	
	          	SearchImngObj.load($.param(this.selectedRowService));
	        }
	      },
      methods : {
      	loaded : function() {     		
      		window.vmServiceProperties.serviceProperties.forEach(function(serviceProperty) {
      			var property = this.serviceProperties.filter(function(property) { return serviceProperty.pk.propertyKey == property.pk.propertyKey })[0];      			
      			if(property) serviceProperty['propertyDesc'] = property.propertyDesc;          		
      		}.bind(this));
      		
      		if(this.object.requestRecordId) this.object.requestRecordName = this.object.requestRecordId + ' - ' +  this.object.requestRecordObject.recordName;
      		if(this.object.responseRecordId) this.object.responseRecordName = this.object.responseRecordId + ' - ' +  this.object.responseRecordObject.recordName;
      		
    		window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
            window.vmResouceInUse.object.updateTimestamp = this.object.updateTimestamp;
    	},
        goDetailPanel : function() {
        	panelOpen('detail', null, function() {        		
        		if (this.selectedRowService) {
            		$("#panel").find("[data-target='#panel']").trigger('click') ;
                	$("#panel").find('#panel-header').find('.ml-auto').remove() ; 
            	}
        	}.bind(this));
        },
        initDetailArea : function(object) {
        	
          if (object) {  
        	  this.object = object ;
          } else {
        	  this.object.serviceId = null ;
              this.object.serviceName = null ;
              this.object.serviceType = null ;
              this.object.privilegeId = null ;
              this.object.privateYn = null ;
        	  this.object.adapterId = null ;
              this.object.operationId = null ;
              this.object.metaDomain = null ;
              this.object.requestRecordId = null ;
              this.object.responseRecordId = null ;
              this.object.requestRecordName = null ;
              this.object.responseRecordName = null ;
              this.object.serviceDesc = null ;
              
              window.vmServiceProperties.serviceProperties = [];
              
              window.vmResouceInUse.object.lockUserId = null;
              window.vmResouceInUse.object.updateVersion = null;
              window.vmResouceInUse.object.updateUserId = null;
              window.vmResouceInUse.object.updateTimestamp = null;
          }
        },
        clickOperation : function(param) {
        	localStorage.setItem('selectedOperation', JSON.stringify({operationId : param})) ;
            window.open("<c:url value='/igate/operation.html' />") ;
        },
        clickRecord : function(param) {        	
        	localStorage.setItem('selectedMessageModel', JSON.stringify({recordId : param})) ;
			window.open("<c:url value='/igate/record.html' />") ;
        },
      },
    }) ;
    
    window.vmServiceProperties = new Vue({
	    el : '#ServiceProperties',
	    data : {
	    	serviceProperties : []
	    },
    });
    
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