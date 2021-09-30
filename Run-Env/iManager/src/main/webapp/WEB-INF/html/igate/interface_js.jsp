<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

var interfaceGrid = null;

$(document).ready(function() {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('interface') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([
    	{
		   'type' : "text",
		   'mappingDataInfo' : "object.interfaceId",
		   'name' :  "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
		   'placeholder' : "<fmt:message>head.searchId</fmt:message>"
		}, {
		    'type' : "text",
		    'mappingDataInfo' : "object.interfaceName",
		    'name' :  "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>",
		    'placeholder' : "<fmt:message>head.searchName</fmt:message>"
		}, {
	      	'type' : "modal",
	      	'mappingDataInfo' : {
		      	'url' : '/igate/adapter.html',
		      	'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
		      	'vModel' : "object.adapterId",
		      	"callBackFuncName" : "setSearchAdapterId"
			},
		    'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
		    'placeholder' : "<fmt:message>head.searchId</fmt:message>"
		}, {
		    'type' : "text",
		    'mappingDataInfo' : "object.interfaceGroup",
		    'name' :  "<fmt:message>head.group</fmt:message>",
		    'placeholder' : "<fmt:message>head.searchId</fmt:message>"
		}, {
	      	'type' : "select",
	      	'mappingDataInfo' : {
		        'selectModel' : "object.usedYn",
		        'optionFor' : 'option in usedYns',
		        'optionValue' : 'option.pk.propertyKey',
		        'optionText' : 'option.propertyValue',
	        	'id' : 'usedYns'
	      	},
	      	'name' :  "<fmt:message>igate.interface.usedYn</fmt:message>",
		    'placeholder' : "<fmt:message>head.all</fmt:message>"
		}
	]) ;

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
					{'type': "text",   'mappingDataInfo': 'object.interfaceId',  'name': "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>", isPk : true},
					{'type': "text",   'mappingDataInfo': 'object.interfaceName', 'name': "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>"},					
					{'type': "select", 'mappingDataInfo': {'selectModel': 'object.interfaceType', 'optionFor': 'option in interfaceTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.interface</fmt:message>  <fmt:message>head.type</fmt:message>"},					
				]
			},
			{
				'className': 'col-lg-3',
				'detailSubList': [
					{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privilegeId', 'optionFor': 'option in privilegeIds', 'optionValue': 'option', 'optionText': 'option' }, 'name': "<fmt:message>common.privilege</fmt:message>"},				
					{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privateYn', 'optionFor': 'option in privateYnList', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "<fmt:message>head.private</fmt:message>"},
					{'type': "text",   'mappingDataInfo': 'object.interfaceGroup',  'name': "<fmt:message>head.group</fmt:message>"},	
					
				]
			},
			{
				'className': 'col-lg-3',
				'detailSubList': [
					{'type': "text", 'mappingDataInfo': "object.adapterId", 'name': "<fmt:message>igate.adapter</fmt:message>"},
					{'type': "text", 'mappingDataInfo': "object.interfaceOperation", 'name': "<fmt:message>igate.operation</fmt:message>"},
					{'type': "text", 'mappingDataInfo': "object.calendarId", 'name': "<fmt:message>igate.calendar</fmt:message>"},
				]
			},
			{
				'className': 'col-lg-3',
				'detailSubList': [
					{'type': "select", 'mappingDataInfo': {'selectModel': 'object.scheduleType', 'optionFor': 'option in scheduleTypes', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.calendar</fmt:message>  <fmt:message>head.type</fmt:message>"},
					{'type': "text", 'mappingDataInfo': "object.cronExpression", 'name': "<fmt:message>igate.interface.cronExpression</fmt:message>"},
					{'type': "text", 'mappingDataInfo': "object.disabledYn", 'name': "Disabled"},
					
				]
			},
			{
				'className': 'col-lg-12',
				'detailSubList': [
					{'type': "textarea", 'mappingDataInfo': "object.interfaceDesc", 'name': "<fmt:message>igate.interface.description</fmt:message>", 'height': 200},							
				]
			},
		]
    }, 
    {
        'type' : 'basic',
        'id' : 'InputOutputInfo',
        'name' : '<fmt:message>head.inoutput.info</fmt:message>',
        'detailList': [
    	    {'className': 'col-lg-4', 'detailSubList': [{'type': "text",   'mappingDataInfo': 'object.metaDomain',  'name': "<fmt:message>igate.interface.metaDomain</fmt:message>"}] },
			{'className': 'col-lg-4', 'detailSubList': [{'type': "textEvt",'mappingDataInfo': 'object.requestRecordName',  'name': "<fmt:message>igate.service.request.model</fmt:message>", 'btnClickEvt' : 'clickRecord(object.requestRecordId)'}] },	
    	    {'className': 'col-lg-4', 'detailSubList': [{'type': "select", 'id' : 'responseRecordId', 'mappingDataInfo': {'selectModel': 'object.responseRecordId', 'optionFor': 'option in object.interfaceResponses', 'optionValue': 'option.pk.recordId', 'optionText': 'option.recordObject.recordName'}, 'name': "<fmt:message>igate.service.response.model</fmt:message>", 'clickEvt' : "clickRecord('responseRecordId')"}] },
			{'className': 'col-lg-12', 'detailSubList': [{'type': "grid",   'id': 'ModelInfo'}] },
  		]
    }, 
    {
		'type': 'property',
		'id': 'InterfaceProperties',
		'name': '<fmt:message>head.extend.info</fmt:message>',
		'mappingDataInfo': 'interfaceProperties',
		'detailList': [
			{'type': 'text', 'mappingDataInfo': 'elm.pk.propertyKey',	'name': '<fmt:message>common.property.key</fmt:message>'}, 
			{'type': 'text', 'mappingDataInfo': 'elm.propertyValue',	'name': '<fmt:message>common.property.value</fmt:message>'}, 
			{'type': 'text', 'mappingDataInfo': 'elm.propertyDesc',		'name': '<fmt:message>head.description</fmt:message>'}
		]
	}, 
	{
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
					{'type': "text",   'mappingDataInfo': 'object.usedTimestamp',  'name': "<fmt:message>igate.interface.usedTimestamp</fmt:message>"},
				]
			},									
 		]
     }]) ;

    createPageObj.setPanelButtonList({
    	dumpBtn: hasInterfaceEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/interface/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/interface/control.json'/>"
    }) ;

    PropertyImngObj.getProperties('List.Yn', true, function(usedYns) {
	    window.vmSearch = new Vue({
	      el : '#' + createPageObj.getElementId('ImngSearchObject'),
	      data : {
	        pageSize : '10',
	        object : {
	          interfaceId : null,
	          interfaceName : null,
	          adapterId : null,
	    	  interfaceGroup : null,
	    	  usedYn : ' '
	        },
	        usedYns : [],
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
	            this.object.interfaceId = null ;
	            this.object.interfaceName = null ;
	            this.object.adapterId = null ;
	        	this.object.interfaceGroup = null;
	        	this.object.usedYn = ' ';
	          }	  
	
	          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
	          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#usedYns'), this.object.usedYn) ;
	        },
	        openModal : function(openModalParam) {
	     		createPageObj.openModal.call(this, openModalParam) ;
	    	},
	        setSearchAdapterId : function(param){
	          	this.object.adapterId = param.adapterId ;
	        },
	      },
	      mounted : function() {
	        this.initSearchArea() ;
	      },
	      created : function(){
	        this.usedYns = usedYns ;
	      }
	    }) ;
    });

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
			
       		$("[name=interfaceId]").val(window.vmSearch.object.interfaceId);
       	  	$("[name=interfaceName]").val(window.vmSearch.object.interfaceName);
       	  	$("[name=adapterId]").val(window.vmSearch.object.adapterId);
       	  	$("[name=interfaceGroup]").val(window.vmSearch.object.interfaceGroup);
       	 	$("[name=usedYn]").val(window.vmSearch.object.usedYn);
       	 
       	  	var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no,    scrollorbars=no, resizable=no") ;
       	  	myForm.target = "hiddenframe";
       	  	myForm.submit();
		}
      }),
      mounted : function() {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/interface/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "interfaceId",
            header : "<fmt:message>igate.interface</fmt:message><fmt:message>head.id</fmt:message>",
            align : "left",
            width: "15%"
          }, {
            name : "interfaceName",
            header : "<fmt:message>igate.interface</fmt:message><fmt:message>head.name</fmt:message>",
            align : "left",
            width: "30%"
          }, 
          {
              name : "adapterId",
              header : "<fmt:message>igate.adapter</fmt:message>",
              align : "left",
              width: "15%"
          }, 
          {
            name : "interfaceGroup",
            header : "<fmt:message>head.group</fmt:message>",
            align : "left",
            width: "10%"
          },
		  {
	      	name : "updateTimestamp",
	        header : "<fmt:message>igate.interface.updateTimestamp</fmt:message>",
	        align : "left",
	        width: "15%"
		  },
		  {
	      	name : "usedTimestamp",
	        header : "<fmt:message>igate.interface.usedTimestamp</fmt:message>",
	        align : "left",
	        width: "15%"
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
        	interfaceId : null,
        	interfaceName : null,
        	interfaceType : null,
            privilegeId : null,
            interfaceGroup : null,
        	privateYn: null,
    		adapterId: null,
    		interfaceOperation: null,
    		scheduleType: null,
    		metaDomain: null,
    		cronExpression: null,
    		disabledYn: null,
    		interfaceDesc: null,
        },
        panelMode : null,
        privateYnList: [{value: 'Y', name: 'Y'}, {value: 'N', name: 'N'}],
        interfaceTypes : [],
        scheduleTypes : [],
        privilegeIds : [],
        calendarList : [],
        usedYns : [],
        interfaceProperties : []
      },
	  computed: {
		  pk: function() {
			  return { 
				  interfaceId: this.object.interfaceId 
			  };
		  }
	  },
      created : function() {
          PropertyImngObj.getProperties('List.Interface.InterfaceType', true, function(properties) {
          this.interfaceTypes = properties ;
        }.bind(this)) ;
          
        PropertyImngObj.getProperties('List.Yn', true, function(properties){
          this.usedYns = properties;
        }.bind(this)) ;
          
        PropertyImngObj.getProperties('Property.Interface', true, function(properties) {
          this.interfaceProperties = properties ;
        }.bind(this)) ;
          
          PropertyImngObj.getProperties("List.Interface.ScheduleType", true, function(properties) {
          this.scheduleTypes = properties ;
        }.bind(this)) ;
          
      	$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(privilegeIdData) {
    		this.privilegeIds = privilegeIdData.object;	
		}.bind(this));
      	
        $.ajax({
            type : "GET",
            url : "<c:url value='/igate/calendar/search.json' />",
            success: function(calendarList) {
               this.calendarList = calendarList.object.page;
            }.bind(this)
         });
      },
      methods : {
    	loaded : function() {
    		
    		window.vmInterfaceProperties.interfaceProperties.forEach(function(interfaceProperty) {
      			var property = this.interfaceProperties.filter(function(property) { return interfaceProperty.pk.propertyKey == property.pk.propertyKey })[0];      			
      			if(property) interfaceProperty['propertyDesc'] = property.propertyDesc;          		
      		}.bind(this));
    		
    		window.vmInputOutputInfo.object.requestRecordName = (this.object.requestRecordId)? (this.object.requestRecordId + ' - ' +  this.object.requestRecordObject.recordName) : '';    		
    		window.vmInputOutputInfo.object.requestRecordId = this.object.requestRecordId;
    		window.vmInputOutputInfo.object.metaDomain = this.object.metaDomain
    		window.vmInputOutputInfo.object.interfaceServices = this.object.interfaceServices; ;       	
    		window.vmInputOutputInfo.modelModel();
            
    		window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
            window.vmResouceInUse.object.updateTimestamp = this.object.updateTimestamp;
            window.vmResouceInUse.object.usedTimestamp = this.object.usedTimestamp;
    	},
        goDetailPanel : function() {
        	panelOpen('detail', null, function() {        	  
          		$("#InputOutputInfo").find('#responseRecordId').attr('readonly', false).css({'background-color' : '#f5f6fb'});
          		
          		if($('a[href="#InputOutputInfo"]').hasClass('active')) {
        	  		$('a[href="#InputOutputInfo"]').removeClass('active');
        	  		$('a[href="#InputOutputInfo"]').tab('show');
        		}
        	});
        },
        initDetailArea : function(object)
        {
          if (object) {  
        	  this.object = object ;
          } else {
        	  this.object.interfaceId = null ;
              this.object.interfaceName = null ;
              this.object.interfaceType = null ;
              this.object.privilegeId = null ;
              this.object.privateYn = null ;
        	  this.object.adapterId = null ;
              this.object.interfaceOperation = null ;
              this.object.scheduleType = null ;
              this.object.metaDomain = null ;
              this.object.cronExpression = null ;
              this.object.disabledYn = null ;
              this.object.interfaceDesc = null ;
              
              window.vmInputOutputInfo.object.requestRecordName = null ;
              window.vmInputOutputInfo.object.interfaceServices = [];
              
              window.vmInterfaceProperties.interfaceProperties = [];
              
              window.vmResouceInUse.object.lockUserId = null;
              window.vmResouceInUse.object.updateVersion = null;
              window.vmResouceInUse.object.updateUserId = null;
              window.vmResouceInUse.object.updateTimestamp = null;
              window.vmResouceInUse.object.usedTimestamp = null;
          }
        },
      },
    }) ;
    
    window.vmInputOutputInfo = new Vue({
	    el : '#InputOutputInfo',
	    data : {
			object : {
		    	metaDomain : null,
		    	requestRecordName: null,
		    	requestRecordId : null,
		    	responseRecordId : null,
		    	interfaceServices : []
			},
	    },
	    methods : {
            modelModel : function() {

            	$('a[href="#InputOutputInfo"]').off().on('shown.bs.tab', function(e) {
            		
                 	if(vmMain.object.interfaceResponses) {
                 		
                 		$('#InputOutputInfo').find('#responseRecordId').empty();
                 		
                 		vmMain.object.interfaceResponses.forEach(function(responseObj) {
                 			$('#InputOutputInfo').find('#responseRecordId').append($('<option value="'+ responseObj.pk.recordId +'">'+(responseObj.recordObject.recordId + ' - ' +  responseObj.recordObject.recordName)+"</option>"));
                 		});
                 	}
            		
            		var bodyHeight = 150 ;
            		
   	             	if ($('.panel-body').height() > 350)
   	               		bodyHeight = $('.panel-body').height() - 50 ;
	   	
	   	             $('#ModelInfo').empty() ;
	   	             
	   	             interfaceGrid = new tui.Grid({
	   	             	el : document.getElementById('ModelInfo'),
	   	               	data : this.object.interfaceServices,
	   	               	bodyHeight : bodyHeight,
		   	           	onGridMounted: function() {
	   	          			$('#ModelInfo').find('.tui-grid-column-resize-handle').removeAttr('title');
	   	          		},
	   	               	columnOptions: {
	   	               		resizable : true
	   	               	},
	   	               	columns : [{
	   	                 name : 'pk',
	   	                 header : "<fmt:message>igate.service</fmt:message>",
	   	                 formatter : function(value) {
	   	                	 return '<span class="underlineTxt">' + escapeHtml(value.value.serviceId) + '</span>';
	   	                 }
	   	               	}, {
						 name : 'requestMappingObject',
						 header : "<fmt:message>igate.interface.requestMapping</fmt:message>",
						 formatter: function(value) {
							 return (value.value)? '<span class="underlineTxt">'+ escapeHtml(value.value.mappingId) +'</span><br>('+ escapeHtml(value.value.mappingName) +')' : '';
						 }
						}, {
						 name : 'responseMappingObject',
						 header : "<fmt:message>igate.interface.responseMapping</fmt:message>",
						 formatter: function(value) {
							 return (value.value)? '<span class="underlineTxt">'+ escapeHtml(value.value.mappingId) +'</span><br>('+ escapeHtml(value.value.mappingName) +')' : '';
						 }
						}, {
						 name : 'cronExpression',
						 header : "<fmt:message>igate.interface.cronExpression</fmt:message>",	
						 escapeHTML : true,
						}, {
						 name : 'calendarId',
						 header : "<fmt:message>igate.calendar</fmt:message>",		
						 formatter : function(value) {							 
							 var selectDiv = "<select class='panel-form-control' name='calendarId' style='width : 100%; text-overflow: ellipsis;'>";
           	   				 selectDiv += "		<option value=''></option>";
           	   				 
           	   				 vmMain.calendarList.forEach(function(option) {
              	   				selectDiv += "<option value='"+ option.calendarId + "' " +((option.calendarId == value.value)? 'selected': '') + ">"+ escapeHtml(option.calendarId) +"</option>";
              	   			 });
              		   		
              		   		 selectDiv += '</select>';
          	   				
          	   				 return selectDiv;
						 }
						}, {
						 name : 'conditionExpression',
						 header : "<fmt:message>igate.interface.conditionExpression</fmt:message>",
						 escapeHTML : true,
						}]
	   	        	}) ;
	   	          
	   	       	  interfaceGrid.on('click', function(ev) {
	   	       		
	   	       		var row = interfaceGrid.getRow(ev.rowKey);
	   	       		var menu = null;
	   	       		var loadParam = {};
	   	       		
	   	       		switch(interfaceGrid.getFocusedCell().columnName) {
	   	       			case 'requestMappingObject':   menu = 'mapping';  loadParam = { 'itemName' : 'selectedRowMapping', param : {mappingId : row.requestMappingId, mappingType: row.requestMappingObject.mappingType} }; break;
	   	       			case 'responseMappingObject':  menu = 'mapping';  loadParam = { 'itemName' : 'selectedRowMapping', param : {mappingId : row.responseMappingId, mappingType: row.responseMappingObject.mappingType} }; break;
		   	       		case 'pk':					   menu = 'service'; loadParam = { 'itemName' : 'selectedRowService', param : {serviceId : row.pk.serviceId} }; break;									
	   	       		}
	   	       		
 	              	if (!menu) return ;
 	              	
	   	       		localStorage.setItem(loadParam.itemName , JSON.stringify(loadParam.param));
                	window.open("<c:url value='/igate/"+ menu +".html' />") ;
 	              	
 	              });
            	}.bind(this));
         	},
            clickRecord : function(param) {         
            	
            	if('responseRecordId' == param) param = $('#InputOutputInfo').find('#responseRecordId option:selected').val();

            	if(!param) return;
            	
				localStorage.setItem('selectedMessageModel', JSON.stringify({recordId : param})) ;
      			window.open("<c:url value='/igate/record.html' />") ;
            },
	    }
    }) ;
    
    window.vmInterfaceProperties = new Vue({
	    el : '#InterfaceProperties',
	    data : {
	    	interfaceProperties : []
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
            usedTimestamp : null,
       	}
       },
    }) ;
   
    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
    
	customResizeFunc = function() {		
		if(interfaceGrid) {
			setTimeout(function() {
				interfaceGrid.refreshLayout();
			}, 350);
		}
	};
  }) ;
</script>