<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  var searchInputGridId = 'inputGrid_tree';
  var searchOutputGridId = 'outputGrid_tree';
  
  var inputParameterStruct = [];
  var outputParameterStruct = [];
  
  tui.Grid.applyTheme('clean') ;
  
  $(document).ready(function() {
	  
	  var createPageObj = getCreatePageObj();

	  createPageObj.setViewName('sapService');
	  createPageObj.setIsModal(false);

	  createPageObj.setSearchList([
		  {
			  'type': "text", 
			  'mappingDataInfo': "object.ashost",
			  'name': "<fmt:message>igate.sap.ashost</fmt:message>",
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.sysnr",
			  'name': "<fmt:message>igate.sap.sysnr</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.client",
			  'name': "<fmt:message>igate.sap.client</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.user",
			  'name': "<fmt:message>igate.sap.user</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.passwd",
			  'name': "<fmt:message>igate.sap.passwd</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.gwhost",
			  'name': "<fmt:message>igate.sap.gwhost</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.gwserv",
			  'name': "<fmt:message>igate.sap.gwserv</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.lang",
			  'name': "<fmt:message>igate.sap.lang</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  },
		  {
			  'type': "text",  
			  'mappingDataInfo': "object.functionName",
			  'name': "<fmt:message>igate.sap.functionName</fmt:message>", 
			  'placeholder': "<fmt:message>head.searchData</fmt:message>"
		  }
	]);

    createPageObj.searchConstructor();

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
							'changeEvt': "whenServiceIdChanged",
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
				ashost: null,
				sysnr: null,
				client: null,
				lang: null,
				user: null,
				passwd: null,
				functionName: null,
				gwhost: null,
				gwserv: null
			},
			reset: false
		},
		computed: {
			address: function() {
				var addressObj = {}; 
				
				for(var key in this.object) {
					if('gwserv'== key || 'gwhost' == key) continue;
					addressObj[key] = this.object[key];	
				}

				if(this.object.gwserv) {
					addressObj.gwserv = this.object.gwserv;
					addressObj.gwhost = this.object.gwhost;
				}
				
				return $.param(addressObj);
			}
		},
		mounted: function() {
			this.initSearchArea();
		},
		methods: {
			initSearchArea: function() {
				for(var key in this.object) {
					this.object[key] = null;
				}
			},
			getStruct: function() {

				startSpinner();
				
				$.ajax({
					type: "POST",
					url: "<c:url value='/igate/sapService/struct.json' />",
					processData: false,
					data: this.address,
					success: function(result) {
						if (result.error) {
							warnAlert({message : '<fmt:message>igate.sap.error</fmt:message>'});
							stopSpinner();
							return;
						}
						
						stopSpinner();
				
						$('#' + createPageObj.getElementId('ImngListObject')).show();
						
						window.vmMain.reset();
				
						inputParameterStruct.push(_generateTreeModel(result.object.requestRecordObject));
						outputParameterStruct.push(_generateTreeModel(result.object.responseRecordObject));
				
						//tab change, operation unchange
						$('a[href="#inputGrid"]').on('shown.bs.tab', function(e) {
							initGrid('inputGrid_tree', inputParameterStruct, (inputParameterStruct.length != 0)? true : false);
						});
				
						$('a[href="#outputGrid"]').on('shown.bs.tab', function(e) {
							initGrid('outputGrid_tree', outputParameterStruct, (outputParameterStruct.length != 0)? true : false);
						});
						
						//tab unchange change
						initGrid('inputGrid_tree', inputParameterStruct, true);
						initGrid('outputGrid_tree', outputParameterStruct, true);
					},
					error: function(request, status, error) {

					}
				});
			}	
		},
	});

	window.vmMain = new Vue({
		el: '#' + createPageObj.getElementId('ImngListObject'),
		data: {
			object: {
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
			executePrivilegeIdsUri: "<c:url value='/common/auth/businessPrivileges.json'/>",
			serviceGroupsUri: "<c:url value='/igate/service/groups.json'/>",
			metaDomainsUri: "<c:url value='/igate/fieldMeta/groups.json'/>",
		},
		mounted: function() {
			$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(executePrivilegeIdData) {
				this.executePrivilegeIds = executePrivilegeIdData.object;	
			}.bind(this));
			
			$.getJSON("<c:url value='/igate/service/groups.json'/>", function(serviceGroupData) {
				this.serviceGroups = serviceGroupData.object;	
			}.bind(this));
			
			$.getJSON("<c:url value='/igate/fieldMeta/groups.json'/>", function(metaDomainData) {
				this.metaDomains = metaDomainData.object;	
			}.bind(this));
			
			PropertyImngObj.getProperties("List.Service.ServiceType", true, function(serviceTypes) {
				this.serviceTypes = serviceTypes;	
			}.bind(this));
		},
		methods: {
			initSearchArea: function() {
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
				
				this.object.serviceGroup = (this.object.serviceGroup && this.serviceGroupEdit)? this.object.serviceGroup + "." + this.serviceGroupEdit : this.serviceGroupEdit;

				startSpinner();

				$.ajax({
					type: "POST",
					url: "<c:url value='/igate/sapService/regist.json'/>",
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
						
						inputParameterStruct = [];
						outputParameterStruct = [];
						
						stopSpinner();
						
					}.bind(this),
					error: function(request, status, error) {
						ResultImngObj.errorHandler(request, status, error);
						this.object.serviceGroup = backupData;
						stopSpinner();
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

  // Generate Request & Response record Grid
  function initGrid(wsdlGridId, allData, initialize) {
	  
	  $('#' + wsdlGridId).empty();

	  var treeData ="";

	  if (initialize)
			treeData = allData[0]._children;
		
	  var wsdlGrid = new tui.Grid({
		  el: document.getElementById(wsdlGridId),
		  data: treeData,
		  rowHeight: 30,
		  minRowHeight: 30,
		  treeColumnOptions: {
			  name: 'fieldId'
		  },
		  columns: [
			  {
				  name: 'fieldId',
				  header: "<fmt:message>head.field</fmt:message> <fmt:message>head.id</fmt:message>"
			  }, 
			  {
				name: 'fieldType',
				header: "<fmt:message>head.field</fmt:message> <fmt:message>head.type</fmt:message>",
				formatter: function(value) {
					var fieldTypeStrObj = {
						'B': "<fmt:message>igate.fieldMeta.fieldType.byte</fmt:message>",
						'S': "<fmt:message>igate.fieldMeta.fieldType.short</fmt:message>",
						'I': "<fmt:message>igate.fieldMeta.fieldType.int</fmt:message>",
						'L': "<fmt:message>igate.fieldMeta.fieldType.long</fmt:message>",
						'F': "<fmt:message>igate.fieldMeta.fieldType.float</fmt:message>",
						'D': "<fmt:message>igate.fieldMeta.fieldType.double</fmt:message>",
						'N': "<fmt:message>igate.fieldMeta.fieldType.numeric</fmt:message>",
						'p': "<fmt:message>igate.fieldMeta.fieldType.timeStamp</fmt:message>",
						'b': "<fmt:message>igate.fieldMeta.fieldType.boolean</fmt:message>",
						'v': "<fmt:message>igate.fieldMeta.fieldType.individual</fmt:message>",
						'A': "<fmt:message>igate.fieldMeta.fieldType.raw</fmt:message>",
						'P': "<fmt:message>igate.fieldMeta.fieldType.packedDecimal</fmt:message>",
						'R': "<fmt:message>igate.fieldMeta.fieldType.record</fmt:message>",
						'T': "<fmt:message>igate.fieldMeta.fieldType.string</fmt:message>"
					};
					
					return fieldTypeStrObj[value.row.fieldType];
				}
			  }, 
			  {
				  name: 'fieldName',
				  header: "<fmt:message>head.field</fmt:message> <fmt:message>head.name</fmt:message>"
			  }
 		 ],
 		 onGridMounted: function() {
 			 customResizeFunc();
 		 }
	  });

	  wsdlGrid.expandAll();
	  
	  $('#' + wsdlGridId).data('grid_obj', wsdlGrid);
  };

  // Generate TreeModel
  function _generateTreeModel(record) {
	
	  var model = {
		  fieldId: record.recordId,
		  fieldName: record.recordName,
		  fieldType: record.recordType,
		  _children: []
	  };

	  record.fields.forEach(function(value, idx) {
		  var field = {
			  fieldId: value.pk.fieldId,
			  fieldName: value.fieldName,
			  fieldType: value.fieldType,
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