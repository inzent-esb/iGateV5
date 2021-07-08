<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

  var searchInputGridId = 'inputGrid_tree';
  var searchOutputGridId = 'outputGrid_tree';
  
  tui.Grid.applyTheme('clean');

  $(document).ready(function() {

	  var createPageObj = getCreatePageObj();

	  createPageObj.setViewName('webservice');
	  createPageObj.setIsModal(false);

	  createPageObj.setSearchList([
		  {
			  'type': "modal",
			  'mappingDataInfo': {
				  'vModel': 'address',
			  },
			  'name': "<fmt:message>igate.webService</fmt:message>",
			  'placeholder': "<fmt:message>igate.webservice.searchWsdl</fmt:message>"
		  }, 
		  {
			  'type': "select",
			  'mappingDataInfo': {
				  'selectModel': "object.service",
				  'optionFor': "option in wsdl.serviceList",
				  'optionValue': "option.name",
				  'optionText': "option.name",
				  'id': "service",
			  },
			  'name': "<fmt:message>igate.webservice.wsdlService</fmt:message>",
			  'isHideAllOption': true,
			  'changeEvt': 'whenServiceSelected'
		  }, 
		  {
			  'type': "select",
			  'mappingDataInfo': {
				  'selectModel': "object.endpoint",
				  'optionFor': "option in service.endpointList",
				  'optionValue': "option.name",
				  'optionText': "option.name + '(' + option.endpointUrl + ')'",
				  'id': "endpoint",
			  },
			  'name': "WSDL EndPoint",
			  'isHideAllOption': true,
			  'changeEvt': 'whenEndPointSelected'
		  }, 
		  {
			  'type': "select",
			  'mappingDataInfo': {
				  'selectModel': "object.operation",
				  'optionFor': "option in service.operationList",
				  'optionValue': "option.operationName",
				  'optionText': "option.operationName + '(' + option.operationNameSpace + ')'",
				  'id': "operation",
			  },
			  'name': "WSDL Operation",
			  'placeholder': "<fmt:message>head.searchData</fmt:message>",
			  'isHideAllOption': true,
			  'changeEvt': 'whenOperationSelected'
		  }, 
	]);

    createPageObj.searchConstructor(true, function() {
    	$('#' + createPageObj.getElementId('ImngSearchObject')).find('#service, #endpoint, #operation').attr({'title': '<fmt:message>head.searchData</fmt:message>'}).parent().addClass('disabled');
    });

    createPageObj.setTabList([
    	{
    		'type': 'basic',
    		'id': 'MainBasic',
    		'name': '<fmt:message>head.basic.info</fmt:message>',
    		'detailList': [
    			{
    				'className': 'col-lg-6',
    				'detailSubList': [
    					{
    						'type': "textEvt",
    						'mappingDataInfo': "object.serviceId",
    						'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
    						'changeEvt': "whenServiceIdChanged()",
    						isPk: true
    					}, 
    					{
    						'type': "select",
    						'mappingDataInfo': {
    							'selectModel': 'object.serviceType',
    							'optionFor': 'option in serviceTypes',
    							'optionValue': 'option.pk.propertyKey',
    							'optionText': 'option.propertyValue'
    						},
    						'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.type</fmt:message>"
    					}, 
    					{
    						'type': "text",
    						'mappingDataInfo': "object.serviceName",
    						'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.name</fmt:message>"
    					}, 
    					{
    						'type': "text",
    						'mappingDataInfo': "object.serviceDesc",
    						'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.description</fmt:message>"
    					}, 
    					{
    						'type': "select",
    						'mappingDataInfo': {
    							'selectModel': 'object.metaDomain',
    							'optionFor': 'option in metaDomains',
    							'optionValue': 'option',
    							'optionText': 'option'
    						},
    						'name': "<fmt:message>igate.service.metaDomain</fmt:message>"
    					}, 
    				]
    			}, 
    			{
    				'className': 'col-lg-6',
    				'detailSubList': [
    					{
    						'type': "text",
    						'mappingDataInfo': "object.requestRecordId",
    						'name': "<fmt:message>igate.service.record.request</fmt:message>",
    						'readonly': true
    					}, 
    					{
    						'type': "text",
    						'mappingDataInfo': "object.responseRecordId",
    						'name': "<fmt:message>igate.service.record.response</fmt:message>",
    						'readonly': true
    					}, 
    					{
    						'type': 'combination',
    						'name': "<fmt:message>igate.service.group</fmt:message>",
    						'combiList': [
    							{
    								'type': "select",
    								'mappingDataInfo': {
    									'selectModel': 'object.serviceGroup',
    									'optionFor': 'option in serviceGroups',
    									'optionValue': 'option',
    									'optionText': 'option'
    								}
    							}, 
    							{
    								'type': "text",
    								'mappingDataInfo': "serviceGroupEdit"
    							}, 
    						]
    					}, 
    					{
    						'type': "select",
    						'mappingDataInfo': {
    							'selectModel': 'object.privilegeId',
    							'optionFor': 'option in executePrivilegeIds',
    							'optionValue': 'option',
    							'optionText': 'option'
    						},
    						'name': "<fmt:message>igate.service.execute.privilege</fmt:message>"
    					}, 
    					{
    						'type': "search",
    						'mappingDataInfo': {
    							'url': '/igate/adapter.html',
    							'modalTitle': '<fmt:message>igate.adapter</fmt:message>',
    							'vModel': "object.adapterId",
    							"callBackFuncName": "setSearchAdapterId"
    						},
    						'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>"
    					}, 
    				]
    			}, 
    		]
    	}, 
    	{
    		'type': 'tree',
    		'id': 'inputGrid',
    		'name': '<fmt:message>igate.service.record.request</fmt:message>',
    	}, 
    	{
    		'type': 'tree',
    		'id': 'outputGrid',
    		'name': '<fmt:message>igate.service.record.response</fmt:message>'
    	}
    ]);

    createPageObj.panelConstructor();

    window.vmSearch = new Vue({
    	el: '#' + createPageObj.getElementId('ImngSearchObject'),
    	data: {
    		object: {
    			service: null,
    			endpoint: null,
    			operation: null
    		},
    		address: null,
    		wsdl: {
    			serviceList: []
    		},
    		service: {
    			endpointList: [],
    			operationList: []
    		},
    		operation: {},
            wsdl_loaded : false,
            service_loaded : false,
            endpoint_loaded : false,    
    	},
    	methods: {
			initSearchArea: function() {
			    this.service = [];
			    this.wsdl = [];

			    this.object.service = null;
			    this.object.endpoint = null;
			    this.object.operation = null;
			    
	            this.wsdl_loaded = false;
	            this.service_loaded = false;
	            this.endpoint_loaded = false;
			},
	        openModal: function(url) {	
	        	$('#modalWSDL').on('show.bs.modal', function(e) {
	          		function step() {		          
			          	if(0 == $('#modalWSDL').length) {
			            	cancelAnimationFrame(rafId);
			            	return;
			          	}
	
			          	if(0 < $('.modal-backdrop').length) {
				        	$('.modal-backdrop').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
				            $('#modalWSDL').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;        		
			    	    	$('.spinnerBg').hide();
			           	 	cancelAnimationFrame(rafId);
			           	 	return;
			          	}
			            
			          	rafId = requestAnimationFrame(step);
		        	}
		          
		       		var rafId = requestAnimationFrame(step);
		      });      
		      
		      $('#modalWSDL').on('shown.bs.modal', function(e) {
		        stopSpinner(function() {
		          $('.spinnerBg').show() ;   
		        }) ;
		      }) ;

		      $('#modalWSDL').on('hidden.bs.modal', function(e) {
		        stopSpinner() ;
		        $('#modalWSDL').hide() ;
		      }) ;
		      
		      $('#modalWSDL').modal('show');
	        	
	        },
	        getStruct: function() {
	        	window.vmMain.initMainArea();
	        	
	        	this.address = $('#modalWSDL').find('input').val();
	        	
	            startSpinner();

	            $.ajax({
	            	type: "POST",
	            	url: "<c:url value='/igate/webservice/struct.json' />",
	            	processData: false,
	            	data: "address=" + this.address,
	            	dataType: "json",
	            	success: function(result) {
	            		
	            		if (result.error) {
	            			warnAlert({message : result.error[0].className + ((result.error[0].message)? "<hr/>" + result.error[0].message  : ""), isXSSMode : false})
	            			stopSpinner();
	            			return;
	            		}

	            		this.wsdl = result.object;
	            		this.wsdl_loaded = true;
	            		
	            		stopSpinner();
	            		
	            		$('#modalWSDL').modal("hide");
	            	}.bind(this)
	            });
	        },
	        whenServiceSelected: function() {
	        	for(var i = 0; i < this.wsdl.serviceList.length; i++) {
	        		if (this.object.service === this.wsdl.serviceList[i].name) {
	        			this.service = this.wsdl.serviceList[i];
	        			this.service_loaded = true;
	        			
	        			window.vmMain.object.service = this.wsdl.serviceList[i].name;
	        			break;
	        		}
	        	}
	        },
	        whenEndPointSelected: function() {
	            window.vmMain.object.endpoint = this.object.endpoint;
	            this.endpoint_loaded = true;
	        },
	        whenOperationSelected: function() {
	            
	        	$('#' + createPageObj.getElementId('ImngListObject')).show();

	        	var tmpService = window.vmMain.object.service;
	        	var tmpEndpoint = window.vmMain.object.endpoint;
	        	
	        	window.vmMain.reset();
	        	
	        	window.vmMain.object.service = tmpService;
	        	window.vmMain.object.endpoint = tmpEndpoint;	        	
	        	
	            var inputParameterStruct = [];
	            var outputParameterStruct = [];

	            for(var i = 0; i < this.service.operationList.length; i++) {
	            	if (this.object.operation == this.service.operationList[i].operationName) {
	            		this.operation = this.service.operationList[i];
	            		inputParameterStruct.push(_generateTreeModel(this.service.operationList[i].input.record));
	            		outputParameterStruct.push(_generateTreeModel(this.service.operationList[i].output.record));
	            		break;
	            	}
	            }

	            //tab change, operation unchange
	            $('a[href="#inputGrid"]').on('shown.bs.tab', function(e) {
	            	initGrid('inputGrid_tree', inputParameterStruct);
	            });

	            $('a[href="#outputGrid"]').on('shown.bs.tab', function(e) {
	            	initGrid('outputGrid_tree', outputParameterStruct);
	            });

	            //tab unchange, operation change
	            initGrid('inputGrid_tree', inputParameterStruct);
	            initGrid('outputGrid_tree', outputParameterStruct);

	            window.vmMain.object.operation = window.vmSearch.object.operation;
	        }
    	},
    	mounted: function() {
    		initSelectPicker($('#service'));
    		initSelectPicker($('#endpoint'));
    		initSelectPicker($('#operation'));
    	},
    	watch: {
    		address: function() {
    			if(!this.address) {
    				window.vmMain.initMainArea();
    				$('#modalWSDL').find('input').val(null)
    			}
    		}
    	},
    	updated: function() {
    		if(this.wsdl_loaded) $('#service').selectpicker('refresh').parents('.label-select').removeClass('disabled');
            else				 $('#service').selectpicker('refresh').parents('.label-select').addClass('disabled');
            
            if(this.service_loaded) $('#endpoint').selectpicker('refresh').parents('.label-select').removeClass('disabled');
            else					$('#endpoint').selectpicker('refresh').parents('.label-select').addClass('disabled');
            
            if(this.endpoint_loaded) $('#operation').selectpicker('refresh').parents('.label-select').removeClass('disabled');
            else 					 $('#operation').selectpicker('refresh').parents('.label-select').addClass('disabled');
    	}	
    });
  
    window.vmMain = new Vue({
    	el: '#' + createPageObj.getElementId('ImngListObject'),
    	data: {
    		object: {
    			service: null,
    			endpoint: null,
                operation: null,
                serviceType: null,
                serviceId: null,
                serviceName: null,
                serviceDesc: null,
                metaDomain: null,
                requestRecordId: null,
                responseRecordId: null,
                serviceGroup: null,
                privilegeId: null,
                adapterId: null
    		},
    		serviceGroupEdit: null,
    		executePrivilegeIds: [],
    		serviceGroups: [],
    		metaDomains: [],
    		serviceTypes: [],
    	},
    	created: function() {
    		$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(executePrivilegeIdData) {
    			this.executePrivilegeIds = executePrivilegeIdData.object;	
    		}.bind(this));
            	
    		$.getJSON("<c:url value='/igate/service/groups.json'/>", function(serviceGroupData) {
    			this.serviceGroups = serviceGroupData.object;	
    		}.bind(this));
            	
    		$.getJSON("<c:url value='/igate/fieldMeta/groups.json'/>", function(metaDomainData) {
    			this.metaDomains = metaDomainData.object;
    		}.bind(this));
            	
    		PropertyImngObj.getProperties("List.Service.ServiceType", true, function(properties) {
    			this.serviceTypes = properties;
    		}.bind(this));
    	},
    	methods: {
			initMainArea: function() {
				this.reset();
				$('#' + createPageObj.getElementId('ImngListObject')).hide();
				window.vmSearch.initSearchArea();
			},    		
			reset: function() {
				for(var key in this.object) {
					this.object[key] = null;
				}
				
				this.serviceGroupEdit = null;
				
				$('#accordionResult').children('.collapse-item').remove();
				$("#panel").find('.flex-shrink-0').children().first().children('a').trigger('click');
			},
			confirmRegist: function() {
				
				var backupData = this.object.serviceGroup;

				this.object.serviceGroup = (this.object.serviceGroup && this.serviceGroupEdit)? this.object.serviceGroup + "." + this.serviceGroupEdit: this.serviceGroupEdit;

				startSpinner();

				$.ajax({
					type: "POST",
					url: "<c:url value='/igate/webservice/regist.json'/>",
					processData: false,
					data: JsonImngObj.serialize($.extend({_method: 'Post'}, this.object)),
					dataType: "json",
					success: function(result) {
						if ("ok" != result.result) {
							ResultImngObj.resultErrorHandler(result);
							this.object.serviceGroup = backupData;    		
							stopSpinner();
							return;
						}
			    	  
						ResultImngObj.resultResponseHandler(result);
						
		                normalAlert({message : '<fmt:message>head.insert.notice</fmt:message>'});
						
						this.reset();
						
						$.getJSON("<c:url value='/igate/service/groups.json'/>", function(serviceGroupData) {
							this.serviceGroups = serviceGroupData.object;
						}.bind(this));
						
						stopSpinner();
					}.bind(this),
					error: function(request, status, error) {
						ResultImngObj.errorHandler(request, status, error);
						this.object.serviceGroup = backupData;
					}.bind(this)
				});
			},
    		openModal: function(url, modalTitle, callBackFuncName) {
    			createPageObj.openModal.call(this, url, modalTitle, callBackFuncName);
    		},
    		setSearchAdapterId: function(param) {
    			this.object.adapterId = param.adapterId;
    		},
    		whenServiceIdChanged: function() {
    			this.object.requestRecordId = "SFD_" + this.object.serviceId + "_I";
    			this.object.responseRecordId = "SFD_" + this.object.serviceId + "_O";
    		}
    	}
    });
  });

  function initGrid(wsdlGridId, allData) {

	  $('#' + wsdlGridId).empty();
	  var treeData = allData[0]._children;

	  var wsdlGrid = new tui.Grid({
		  el: document.getElementById(wsdlGridId),
		  data: treeData,
		  rowHeight: 30,
		  minRowHeight: 30,
		  treeColumnOptions: {
			  name: 'nodeId'
		  },
		  columns: [
			  {
				  name: 'nodeId',
				  header: "<fmt:message>head.node</fmt:message> <fmt:message>head.id</fmt:message>"
			  }, 
			  {
				  name: 'nodeType',
				  header: "<fmt:message>head.node</fmt:message> <fmt:message>head.type</fmt:message>",
				  formatter: function(value) {
					  
					  var nodeTypeStrObj = {
						  'B': "<fmt:message>igate.fieldMeta.fieldType.byte</fmt:message>" ,
						  'S': "<fmt:message>igate.fieldMeta.fieldType.short</fmt:message>" ,
						  'I': "<fmt:message>igate.fieldMeta.fieldType.int</fmt:message>" ,
						  'L': "<fmt:message>igate.fieldMeta.fieldType.long</fmt:message>" ,
						  'F': "<fmt:message>igate.fieldMeta.fieldType.float</fmt:message>" ,
						  'D': "<fmt:message>igate.fieldMeta.fieldType.double</fmt:message>" ,
						  'N': "<fmt:message>igate.fieldMeta.fieldType.numeric</fmt:message>" ,
						  'p': "<fmt:message>igate.fieldMeta.fieldType.timeStamp</fmt:message>" ,
						  'b': "<fmt:message>igate.fieldMeta.fieldType.boolean</fmt:message>" ,
						  'v': "<fmt:message>igate.fieldMeta.fieldType.individual</fmt:message>" ,
						  'A': "<fmt:message>igate.fieldMeta.fieldType.raw</fmt:message>" ,
						  'P': "<fmt:message>igate.fieldMeta.fieldType.packedDecimal</fmt:message>" ,
						  'R': "<fmt:message>igate.fieldMeta.fieldType.record</fmt:message>" ,
						  'T': "<fmt:message>igate.fieldMeta.fieldType.string</fmt:message>" ,							  
					  };
					  
					  return nodeTypeStrObj[value.row.nodeType];
				  }
			  }, 
			  {
				  name: 'nodeName',
				  header: "<fmt:message>head.node</fmt:message> <fmt:message>head.name</fmt:message>"
			  }
		]
	  });

	  wsdlGrid.expandAll();
	  
	  $('#' + wsdlGridId).data('grid_obj', wsdlGrid);
  }

  function _generateTreeModel(record) {

	  var model = {
		  nodeId: record.recordId,
		  nodeName: record.recordId,
		  nodeType: record.recordType,
		  _children: []
	  };

	  record.fields.forEach(function(value, idx) {
		  var field = {
			  nodeId: value.pk.fieldId,
			  nodeName: value.fieldName,
			  nodeType: value.fieldType,
		  };

		  if (value.recordObject) {
			  field._children = [];

			  var subRecord = _generateTreeModel(value.recordObject);

			  subRecord._children.forEach(function(subRecordVal, idx) {
				  field._children.push(subRecordVal);
			  });
		  }

		  model._children.push(field);
	  });

	  return model;
  }

  customResizeFunc = function() {
	  $("#" + searchInputGridId).width(0).width($("#" + searchInputGridId).parent().width());
	  $("#" + searchOutputGridId).width(0).width($("#" + searchOutputGridId).parent().width());

	  if($("#" + searchInputGridId).data('grid_obj'))
		  $("#" + searchInputGridId).data('grid_obj').refreshLayout();
	  
	  if($("#" + searchOutputGridId).data('grid_obj'))
		  $("#" + searchOutputGridId).data('grid_obj').refreshLayout();
  };
</script>