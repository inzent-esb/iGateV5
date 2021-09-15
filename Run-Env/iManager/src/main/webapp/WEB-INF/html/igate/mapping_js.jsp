<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
var mappingRuleGrid = null;
var targetGrid = null;
var sourceGrid = null;

$(document).ready(function() {
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('mapping');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.mappingId", 'name': "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.mappingName", 'name': "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>", 'placeholder': "<fmt:message>head.searchName</fmt:message>"}
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
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
						{'type': "text", 'mappingDataInfo': "object.mappingId", 'name': "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.mappingName", 'name': "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.privilegeId", 'name': "<fmt:message>common.privilege</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privateYn', 'optionFor': 'option in privateYnList', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "Private"},
						{'type': "text", 'mappingDataInfo': "object.mappingGroup", 'name': "<fmt:message>head.group</fmt:message>"},
					]
				},	
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.mappingDesc", 'name': "<fmt:message>igate.operation.description</fmt:message>", 'height': 200},							
					]
				},	
			]
		},
		{
			'type': 'custom',
			'id': 'MappingInfo',
			'name': '<fmt:message>igate.mapping</fmt:message> <fmt:message>head.info</fmt:message>',
			'clickEvt': function() {
				vmMappingInfo.resize();
			},
			'getDetailArea': function() {
				var strHtml = '';
					strHtml +='<div id="mappingRuleArea" class="col-lg-2" style="padding: 0px; margin: 0px;">';
					strHtml +='    <button type="button" id="mappingRuleAreaHideBtn" class="btn-icon" v-on:click="setMappingRuleToggle" style="float: right"><i class="icon-hamburger-back"></i></button>';
					strHtml +='    <div id="mappingRuleGrid"></div>';
					strHtml +='</div>';
					strHtml +='<div id="mappingArea" class="col-lg-10" style="padding: 0px; margin: 0px;">';
					strHtml +='    <button type="button" id="mappingRuleAreaShowBtn" class="btn-icon" v-on:click="setMappingRuleToggle" style="float: left; transform: scaleX(-1);display: none;"><i class="icon-hamburger-back"></i></button>';
					strHtml += '   <ul>';
					strHtml += '       <li style="float: left;width: 35%;">';
					strHtml += '           <div id="sourceGrid"></div>';
					strHtml += '       </li>';
					strHtml += '       <li style="float: left;width: 30%;">';
					strHtml += '           <canvas id="mappingCanvas"></canvas>';
					strHtml += '       </li>';
					strHtml += '       <li style="float: left;width: 35%;">';
					strHtml += '           <div id="targetGrid"></div>';
					strHtml += '       </li>';
					strHtml += '   </ul>';
				return strHtml;
			}
		},
		{
			'type': 'basic',
			'id': 'ResourceInuseInfo',
			'name': '<fmt:message>head.resource.inuse.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "lockUserId", 'name': "<fmt:message>head.lock.userId</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "updateVersion", 'name': "<fmt:message>head.updateVersion</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "updateUserId", 'name': "<fmt:message>head.update.userId</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "updateTimestamp", 'name': "<fmt:message>head.update.timestamp</fmt:message>"},
					]
				}				
			]
		},
	]);
	
	createPageObj.setPanelButtonList();
	
	createPageObj.panelConstructor(true);	
    
	SaveImngObj.setConfig({
		objectUri: "<c:url value='/igate/mapping/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri: "<c:url value='/igate/mapping/control.json' />"
    });

    window.vmSearch = new Vue({
    	el: '#' + createPageObj.getElementId('ImngSearchObject'),
    	data: {
    		pageSize: '10',
    		object: {
    			mappingId: null,
    			mappingName: null,
    		}
    	},
    	methods: {
			search: function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this);
			},
            initSearchArea: function(searchCondition) {
            	if(searchCondition) {
            		for(var key in searchCondition) {
            		    this.$data[key] = searchCondition[key];
            		}
            	}else {
        			this.object.mappingId = null;
        			this.object.mappingName = null;
                	this.pageSize = '10';
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
        	newTabPageUrl: "<c:url value='/igate/mapping.html' />"
        },
        methods: $.extend(true, {}, listMethodOption, {
        	initSearchArea: function() {
        		window.vmSearch.initSearchArea();
        	}
        }),
        mounted: function() {
        	this.makeGridObj = getMakeGridObj();
        	
        	this.makeGridObj.setConfig({
        		elementId: createPageObj.getElementId('ImngSearchGrid'),
        		onClick: SearchImngObj.clicked,
        		searchUri: "<c:url value='/igate/mapping/search.json' />",
        		viewMode: "${viewMode}",
        		popupResponse: "${popupResponse}",
        		popupResponsePosition: "${popupResponsePosition}",
        		columns: [
        			{
        				name: "mappingId",
        	        	header: "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>",
        	        	align: "left",
                        width: "40%",
        			}, 
        			{
        				name: "mappingName",
        	        	header: "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>",
        	        	align: "left",
                        width: "40%",
        			},
        			{
        	        	name: "privilegeId",
        	        	header: "<fmt:message>common.privilege</fmt:message>",
        	        	align: "left",
                        width: "20%",
        			}
        		]        	    
        	});
        	
        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
        	
        	this.newTabSearchGrid();
        }        
    });    
    
    window.vmMain = new Vue({
    	el: '#MainBasic',
    	data: {
    		viewMode: 'Open',
    		object: {
    			mappingId: null,
    			mappingName: null,
    			privilegeId: null,
    			privateYn: null,
    			mappingGroup: null,
    			lockUserId: null,
    			updateVersion: null,
    			updateUserId: null,
    			updateTimestamp: null,
    		},
    		selectedRowMapping: null,
    		panelMode: null,
    		privateYnList: [{value: 'Y', name: 'Y'}, {value: 'N', name: 'N'}],
    	},
    	computed: {
    		pk: function() {
    			return { 
    				mappingId: this.object.mappingId 
    			};
    		}
    	},
    	created: function() {
    		if(localStorage.getItem('selectedRowMapping')) {
    			this.selectedRowMapping = JSON.parse(localStorage.getItem('selectedRowMapping'));
    			localStorage.removeItem('selectedRowMapping');
    			
    			SearchImngObj.load($.param(this.selectedRowMapping));
    		}
    	},
        methods: {
			goDetailPanel: function() {
				panelOpen('detail', null, function() {
					if(this.selectedRowMapping) {
						$("#panel").find("[data-target='#panel']").trigger('click');
						$("#panel").find('#panel-header').find('.ml-auto').remove();
					}
				}.bind(this));
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object = object;
        		}else {        			
        			this.object.mappingId = null;
        			this.object.mappingName = null;
        			this.object.privilegeId = null;
        			this.object.privateYn = null;
        			this.object.mappingGroup = null;
        			this.object.lockUserId = null;
        			this.object.updateVersion = null;
        			this.object.updateUserId = null;
        			this.object.updateTimestamp = null;
        		}	
			},
			loaded: function() {
				vmMappingInfo.mappingDetails = this.object.mappingDetails;
				
				vmMappingInfo.initMappingInfo();
				
				vmResourceInuseInfo.lockUserId = this.object.lockUserId;
				vmResourceInuseInfo.updateVersion = this.object.updateVersion;
				vmResourceInuseInfo.updateUserId = this.object.updateUserId;
				vmResourceInuseInfo.updateTimestamp = this.object.updateTimestamp;
			}
        },    	
    }); 
    
    var vmMappingInfo = new Vue({
    	el: '#MappingInfo',
    	data: {
    		mappingDetails: null,
    		selectedRuleIdx: 0,
    	},
    	mounted: function() {
    		$('#MappingInfo').height('100%');
    		$('#MappingInfo').find('.row').height('100%');
    		
    		this.initMappingSourceGrid();
    		
    		this.initMappingTargetGrid();
    		
    		this.initMappingRuleGrid();
    	},
    	methods: {
    		resize: function() {
				setTimeout(function() {
					if(mappingRuleGrid) {
						
    					mappingRuleGrid.refreshLayout();
        				
   			        	var resetColumnWidths = [];
   			        	
   			        	mappingRuleGrid.getColumns().forEach(function(columnInfo) {
   			        		if(!columnInfo.copyOptions) return;
   		
   			        		if(columnInfo.copyOptions.widthRatio) {
   			        			resetColumnWidths.push($('#mappingRuleGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
   			        		}
   			        	});
   			        	
   			        	if(0 < resetColumnWidths.length)
   			        		mappingRuleGrid.resetColumnWidths(resetColumnWidths); 						
					}
					
	    			if(sourceGrid) {
	    				sourceGrid.refreshLayout();
	    			}
					
	    			if(targetGrid) {
	    				targetGrid.refreshLayout();
	    			}
	    			
	    			$('#mappingCanvas').attr({'width': $('#mappingCanvas').parent().width(), 'height':  ($('#sourceGrid').height() < $('#targetGrid').height())? $('#targetGrid').height() : $('#sourceGrid').height() });	
    				
    				drawArrow(this.mappingDetails[this.selectedRuleIdx]);
				}.bind(this), 0);
    		},
    		initMappingInfo: function() {
    			mappingRuleGrid.resetData(
   	    			this.mappingDetails.map(function(info) {
   	    				return {
   	    					mappingId: info.pk.mappingId,
   	    					mappingOrder: info.pk.mappingOrder,
   	    					targetForm: info.targetForm,
   	    					mappingDetailDesc: info.mappingDetailDesc,
   	    				}
   	    			})
    			);
    			
    			sourceGrid.resetData([]);
    			
    			targetGrid.resetData([]);
    			
    			if(0 < this.mappingDetails.length)
    				initSourceTargetGrid(this.mappingDetails[0]);    
    			
    			customResizeFunc();
    		},
    		setMappingRuleToggle: function() {
    			if('none' != $('#mappingRuleArea').css('display')){
    				$('#mappingRuleAreaHideBtn').hide();
    				$('#mappingRuleAreaShowBtn').show();
    				$('#mappingRuleArea').hide();
    				$('#mappingArea').removeClass().addClass('col-lg-12');
    				$('#mappingArea').find('#mappingCanvas').parent().width('calc(30% - 32px)');
    			}else{
    				$('#mappingRuleAreaHideBtn').show();
    				$('#mappingRuleAreaShowBtn').hide();
    				$('#mappingRuleArea').show();
    				$('#mappingArea').removeClass().addClass('col-lg-10');
    				$('#mappingArea').find('#mappingCanvas').parent().width('30%');
    			}
    			
    			this.resize();
    		},
    		initMappingRuleGrid: function() {
    			var settings = {
   					el : document.getElementById('mappingRuleGrid'),
   					data: null,
   					columns : [
   						{
   							name: 'mappingId&Order',
   							header: "Mapping ID & Order",
   							width: '50%',
   							formatter: function(info) {
   								return info.row.mappingId + "$" + info.row.mappingOrder;
   							}
   						},
   						{
   							name: 'targetForm',
   							header: "Target Form",
   							width: '25%',
   						},
   						{
   							name: 'mappingDetailDesc',
   							header: "Description",
   							width: '25%',
   							align: 'right'
   						}
   					],
   					columnOptions : {
   						resizable : true
   					},
   					usageStatistics : false,
   					header: {
   						height: 32,
   						align: 'center'
   					},
   					onGridMounted: function() {
   						$('#mappingRuleGrid').find('.tui-grid-column-resize-handle').removeAttr('title');
   			        },
   			    	scrollX: false,
   			    	scrollY: false,
   	  			};
   	    			
   	   			settings.columns.forEach(function(column) {
   	   				if(!column.formatter) 
   	   					column.escapeHTML = true;  

   	   				if(column.width && -1 < String(column.width).indexOf('%')) {
   	   					if(!column.copyOptions) 
   	   						column.copyOptions = {};
   	   		    		  
   	   					column.copyOptions.widthRatio = column.width.replace('%', '');
   	   		    		  
   	   					delete column.width;
   	   				}
   	   			});	
   	    			
   				mappingRuleGrid = new tui.Grid(settings);
   				
   				mappingRuleGrid.on('mouseover', function(ev) {
   					if('cell' != ev.targetType) return;
   			    	  
   					var overCellElement = $(mappingRuleGrid.getElement(ev.rowKey, ev.columnName));    	  
   					overCellElement.attr('title', overCellElement.text());
   				});
   				
   				mappingRuleGrid.on('click', function(ev) {
   					var rowInfo = mappingRuleGrid.getRow(ev.rowKey);
   					
   					var mappingDetailInfo = null;
   					
   					for(var i = 0; i < this.mappingDetails.length; i++) {
   						var info = this.mappingDetails[i];
   						
						if(rowInfo.mappingId == info.pk.mappingId && rowInfo.mappingOrder == info.pk.mappingOrder){
							this.selectedRuleIdx = i;
							mappingDetailInfo = info;
							break;
						}
   					}
   					
   					initSourceTargetGrid(mappingDetailInfo, function() {
   						drawArrow(mappingDetailInfo);
   					});
   				}.bind(this));  
    		},
    		initMappingSourceGrid: function() {
    			sourceGrid = new tui.Grid({
    		    	el: document.getElementById('sourceGrid'),
    		    	data: [],
    		        treeColumnOptions: {
    		        	name: 'fieldId',
    		        },	
    		        columns: [
    		        	{
    		        		header: 'id',
    		        		hidden: true
    		        	},
    		        	{
    		        		header: 'FIELD_ID',
    		        		name: 'fieldId',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},          
    		        	{
    		        		header: 'FIELD_TYPE',
    		        		name: 'fieldType',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},
    		        	{
    		        		header: 'FIELD_NAME',
    		        		name: 'fieldName',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},          
    		        ]
    		    });
    			
    			var _this = this;
    			
   				sourceGrid.on('mouseover', function(ev) {
   					if('cell' != ev.targetType) return;
   			    	  
   					var overCellElement = $(sourceGrid.getElement(ev.rowKey, ev.columnName));    	  
   					overCellElement.attr('title', overCellElement.text());
   				});
   				
    			sourceGrid.on('expand', function() {
    				setTimeout(function() {
    					drawArrow(_this.mappingDetails[_this.selectedRuleIdx])	
    				}, 200);
    			});

    			sourceGrid.on('collapse', function() {
    				setTimeout(function() {
    					drawArrow(_this.mappingDetails[_this.selectedRuleIdx])	
    				}, 200);
    			});
    			
		        sourceGrid.on('click', function(ev) {
		        	if (ev.rowKey != null) {
		        		sourceGrid.store.data.rawData.forEach(function(data) {
		        			sourceGrid.removeRowClassName(data.rowKey, "row-selected");
		        		});        

		        		sourceGrid.addRowClassName(ev.rowKey, "row-selected");
		        	}
		        });
    		},
    		initMappingTargetGrid: function(data) {
    			targetGrid = new tui.Grid({
    		    	el: document.getElementById('targetGrid'),
    		    	data: [],
    		        treeColumnOptions: {
    		        	name: 'fieldId',
    		        },	
    		        columns: [
    		        	{
    		        		header: 'id',
    		        		hidden: true
    		        	},
    		        	{
    		        		header: 'FIELD_ID',
    		        		name: 'fieldId',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},          
    		        	{
    		        		header: 'FIELD_TYPE',
    		        		name: 'fieldType',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},
    		        	{
    		        		header: 'FIELD_NAME',
    		        		name: 'fieldName',
    		        		resizable: true,
    		        		escapeHTML: true,
    		        	},          
    		        ]
    		    });
    			
    			var _this = this;

    			targetGrid.on('dblclick', function(ev) {
    				var mappingDetailInfo = _this.mappingDetails[_this.selectedRuleIdx];
    				
    				var mappingArr = mappingDetailInfo.mappingRuleObject.mappingRuleDetails.map(function(info) {
    					return {
    						sourceId: info.mappingExpression.replace('[i1]', ''),
    						targetId: info.targetFieldPath.replace('[i1]', ''),
    						simpleMappingYn: info.simpleMappingYn,
    						targetFieldPath: info.targetFieldPath,
    						mappingExpression: info.mappingExpression,
    						arraySizeParameter: info.arraySizeParameter
    					};
    				}).filter(function(info) {
    					return info.targetId == targetGrid.getRow(ev.rowKey).id;
    				});
    				
    				if(0 < mappingArr.length) {
    					var tmpBodyHtml = '';
    					
    					tmpBodyHtml += ' Target Field: ' + escapeHtml(mappingArr[0].targetFieldPath);
    					tmpBodyHtml += '\n\n Mapping Expression: ' + escapeHtml(mappingArr[0].mappingExpression);
    					
    					if(mappingArr[0].arraySizeParameter)
    						tmpBodyHtml += '\n\n Array Reference: ' + escapeHtml(mappingArr[0].arraySizeParameter);
    					
    					openModal({
    						title: '<fmt:message>igate.mapping</fmt:message> Rule <fmt:message>head.detail</fmt:message>',
    						bodyHtml: '<div class="form-group">' +
    								  '    <textarea class="form-control" style="width: 500px; height: 200px;" readonly>' + tmpBodyHtml + '</textarea>' +
    								  '</div>'	
    					});		
    				}
    			});
    			
   				targetGrid.on('mouseover', function(ev) {
   					if('cell' != ev.targetType) return;
   			    	  
   					var overCellElement = $(targetGrid.getElement(ev.rowKey, ev.columnName));    	  
   					overCellElement.attr('title', overCellElement.text());
   				});
   				
    			targetGrid.on('expand', function() {
    				setTimeout(function() {
    					drawArrow(_this.mappingDetails[_this.selectedRuleIdx])	
    				}, 200);
    			});

    			targetGrid.on('collapse', function() {
    				setTimeout(function() {
    					drawArrow(_this.mappingDetails[_this.selectedRuleIdx])	
    				}, 200);
    			});    			
    			
		        targetGrid.on('click', function(ev) {
		        	if (ev.rowKey != null) {
		        		targetGrid.store.data.rawData.forEach(function(data) {
		        			targetGrid.removeRowClassName(data.rowKey, "row-selected");
		        		});        

		        		targetGrid.addRowClassName(ev.rowKey, "row-selected");
		        	}
		        });    			
    		}
    	}
    });
    
    var vmResourceInuseInfo = new Vue({
    	el: '#ResourceInuseInfo',
    	data: {
			lockUserId: null,
			updateVersion: null,
			updateUserId: null,
			updateTimestamp: null
    	}
    });
    
	new Vue({
		el: '#panel-footer',
		methods: $.extend(true, {}, panelMethodOption)
	});
	
	function getRecordData(recordId, callBackFunc) {
		$.ajax({
			type : "GET",
		    url : "<c:url value='/igate/record/object.json' />",
		    processData : false,
		    data : $.param({
		    	'recordId' :  recordId
		    }),
		    dataType : "json",
		    success : function(result) { 
		    	if(callBackFunc)
		    		callBackFunc(result.object);
		    }  
	    });
	}
	
	function initSourceTargetGrid(mappingDetailInfo, callbackFunc) {
		var isSourceGridFlag = false;
		var isTargetGridFlag = false;
		
		var isSourceGridCompleteIdx = 0;
		
		<%-- source --%>
		sourceGrid.resetData([]);
  			
		var sourceGridDataArr = [];
		var sourceRecordInfoArr = mappingDetailInfo.mappingRuleObject.mappingRuleSources.map(function(info) { return { parameterOrder: info.pk.parameterOrder, recordId: info.recordId }; });
		
		if(0 < sourceRecordInfoArr.length) {
			for(var i = 0; i < sourceRecordInfoArr.length; i++) {
				(function(recordId, parameterOrder) {
					getRecordData(recordId, function(data) {
						
						var tmpData = { id: '$' + parameterOrder, fieldId: data.recordId, fieldType: 'Group', fieldName: data.recordName };

						if(data.fields && 0 < data.fields.length)
							tmpData._children = initTreeData(tmpData.id, data.fields);   
	  						
						sourceGridDataArr.push(tmpData);
						
						isSourceGridCompleteIdx += 1;
	  						
						if(isSourceGridCompleteIdx == sourceRecordInfoArr.length) {
							sourceGridDataArr.sort(function(a, b) {
								return (a.fieldId < b.fieldId)? -1 : (a.fieldId > b.fieldId)? 1 : 0; 
							});
							
							sourceGrid.resetData(sourceGridDataArr);
							sourceGrid.expandAll(); 
							
							isSourceGridFlag = true;
							
							startDrawArrow();
						}
					});					
				})(sourceRecordInfoArr[i].recordId, sourceRecordInfoArr[i].parameterOrder);
			}			
		}else{
			isSourceGridFlag = true;
			startDrawArrow();
		}

		<%-- source --%>
		
		<%-- target --%>
		targetGrid.resetData([]);

		var targetRecordId = mappingDetailInfo.mappingRuleObject.recordId;
		
		if(targetRecordId){
			getRecordData(targetRecordId, function(data) {
				var tmpData = { id: '', fieldId: data.recordId, fieldType: 'Group', fieldName: data.recordName };
					
				if(data.fields && 0 < data.fields.length)
					tmpData._children = initTreeData(tmpData.id, data.fields); 
				
				targetGrid.resetData([tmpData]);
				
				targetGrid.expandAll();
				
				isTargetGridFlag = true;
				
				startDrawArrow();
			});			
		}else{
			isTargetGridFlag = true;
			startDrawArrow();
		}

		<%-- target --%>
		
		function startDrawArrow() {
			if(!(isSourceGridFlag && isTargetGridFlag)) 
				return;
			
			if(callbackFunc)
				setTimeout(function() {
					callbackFunc();	
				}, 0);
		}
	}
	
	var fieldTypeTranslateObj = {
		'B': 'Byte',
		'S': 'Short',
	 	'I': 'Int',
		'L': 'Long',
		'F': 'Float',
		'D': 'Double',
		'T': 'String',
		'N': 'Numeric',
		'P': 'Decimal',
		'A': 'Raw',
		'p': 'Timestamp',
		'b': 'Boolean',
		'R': 'Record',
		'v': 'Individual',
	};
	
	function initTreeData(parentId, fields) {
		var rtnArr = [];
		
		fields.forEach(function(field) {
			var id = parentId + '\\' + field.fieldId;
			
			rtnArr.push({
				id: id,
				fieldId: field.fieldId,
				fieldType: null,
				fieldName: field.fieldName
			});
			
			if(field.recordObject) {
				rtnArr[rtnArr.length - 1].fieldType = 'Group(' + field.recordObject.recordType + ')';
				
				if('N' != field.arrayType) {
					rtnArr[rtnArr.length - 1].fieldType += '[' + field.arrayType + ']';
				}
				
				rtnArr[rtnArr.length - 1]._children = initTreeData(rtnArr[rtnArr.length - 1].id, field.recordObject.fields);
			}else{
				rtnArr[rtnArr.length - 1].fieldType = fieldTypeTranslateObj[field.fieldType] + '(' + field.fieldLength + ')';
				
				if('N' != field.arrayType) {
					rtnArr[rtnArr.length - 1].fieldType += '[' + field.arrayType + ']';
				}
			}
		});
		
		return rtnArr;
	}
	
	function drawArrow(mappingDetailInfo) {
		var mappingArr = mappingDetailInfo.mappingRuleObject.mappingRuleDetails.map(function(info) {
			return {
				sourceId: info.mappingExpression.replace('[i1]', ''),
				targetId: info.targetFieldPath.replace('[i1]', ''),
				simpleMappingYn: info.simpleMappingYn
			};
		});
		
		var sourceGridData = sourceGrid.getData();
		var targetGridData = targetGrid.getData();
		
		var ctx = document.getElementById('mappingCanvas').getContext('2d');
		
		ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
		
		mappingArr.forEach(function(info) {
			var startYPos = null, startY1Pos = null;
			
			for(var i = 0; i < sourceGridData.length; i++) {
				var data = sourceGridData[i];
				
				if(data.id == info.sourceId) {
					while(null == startYPos) {
						if(0 == $('#sourceGrid').find('td[data-row-key=' + data.rowKey + ']').length){
							data = sourceGrid.getRow(data._attributes.tree.parentRowKey); 						
						}else{
							var tmpIdx = $('#sourceGrid').find('td[data-row-key=' + data.rowKey + ']').parent().prevAll().length;
							startYPos = 41 + (40 * tmpIdx + 1) + (40 / 2 - 1);
						}
					}
					
					break;						
				}
			}
			
			for(var i = 0; i < targetGridData.length; i++) {
				var data = targetGridData[i];
				
				if(data.id == info.targetId) {
					while(null == startY1Pos) {
						if(0 == $('#targetGrid').find('td[data-row-key=' + data.rowKey + ']').length){
							data = targetGrid.getRow(data._attributes.tree.parentRowKey); 						
						}else{
							var tmpIdx = $('#targetGrid').find('td[data-row-key=' + data.rowKey + ']').parent().prevAll().length;
							startY1Pos = 41 + (40 * tmpIdx + 1) + (40 / 2 - 1);
						}
					}
					
					break;
				}
			}
		
			function drawLineBoth() {
				ctx.beginPath();
				ctx.moveTo(0,  startYPos);
				ctx.lineTo(50, startYPos);
				ctx.lineTo(ctx.canvas.width - 50, startY1Pos);
				ctx.lineTo(ctx.canvas.width, startY1Pos);
				ctx.strokeStyle = 'gray';
				ctx.stroke();
				ctx.closePath();

				ctx.beginPath();
				ctx.moveTo(0, startYPos - 5);
				ctx.lineTo(0, startYPos + 5);
				ctx.lineTo(10, startYPos + 5);
				ctx.lineTo(10, startYPos - 5);
				ctx.lineTo(0, startYPos - 5);
				ctx.fillStyle = 'gray';
				ctx.fill();
				ctx.closePath();		
				
				ctx.beginPath();
				ctx.moveTo(ctx.canvas.width, startY1Pos);
				ctx.lineTo(ctx.canvas.width - 8, startY1Pos - 8);
				ctx.lineTo(ctx.canvas.width - 8, startY1Pos + 8);
				ctx.lineTo(ctx.canvas.width, startY1Pos);
				ctx.fillStyle = 'gray';
				ctx.fill();
				ctx.closePath();					
			}
			
			function drawLineTarget() {
				ctx.beginPath();
				ctx.fillStyle = 'gray';
				ctx.fillText('|F|', ctx.canvas.width - (ctx.canvas.width / 3) - 14, startY1Pos + 3);
				ctx.closePath();
				
				ctx.beginPath();
				ctx.moveTo(ctx.canvas.width - (ctx.canvas.width / 3), startY1Pos);
				ctx.lineTo(ctx.canvas.width, startY1Pos);
				ctx.save();
				ctx.setLineDash([5, 5]);
				ctx.strokeStyle = 'gray';
				ctx.stroke();
				ctx.restore();
				ctx.closePath();	
				
				ctx.beginPath();
				ctx.moveTo(ctx.canvas.width, startY1Pos);
				ctx.lineTo(ctx.canvas.width - 8, startY1Pos - 8);
				ctx.lineTo(ctx.canvas.width - 8, startY1Pos + 8);
				ctx.lineTo(ctx.canvas.width, startY1Pos);
				ctx.fillStyle = 'gray';
				ctx.fill();
				ctx.closePath();
			}
			
			if('Y' == info.simpleMappingYn){
				if(null != startYPos)		 
					drawLineBoth();
				else if(null != startY1Pos)	  
					drawLineTarget();
			}else{
				if(null != startY1Pos) 
					drawLineTarget();
			}
		});		
	}
	
	customResizeFunc = function() {
		if(vmMappingInfo.resize) {
			setTimeout(function() {
				vmMappingInfo.resize();
			}, 350)
		}
	};	
});
</script>