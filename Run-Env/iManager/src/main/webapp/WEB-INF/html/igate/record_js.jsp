<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
var recordTreeGrid = null ;

$(document).ready(function() {
	
    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('record') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([
    	{
		   'type' : "text",
		   'mappingDataInfo' : "object.recordId",
		   'name' :  "<fmt:message>igate.record</fmt:message> <fmt:message>head.id</fmt:message>",
		   'placeholder' : "<fmt:message>head.searchId</fmt:message>"
		}, {
		    'type' : "text",
		    'mappingDataInfo' : "object.recordName",
		    'name' :  "<fmt:message>igate.record</fmt:message> <fmt:message>head.name</fmt:message>",
		    'placeholder' : "<fmt:message>head.searchName</fmt:message>"
		}
	]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      totalCount: true,
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
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text",   'mappingDataInfo': 'object.recordId',  'name': "<fmt:message>igate.record</fmt:message> <fmt:message>head.id</fmt:message>", isPk : true},
						{'type': "text",   'mappingDataInfo': 'object.recordName', 'name': "<fmt:message>igate.record</fmt:message> <fmt:message>head.name</fmt:message>"},					
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.recordType', 'optionFor': 'option in recordTypes', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "<fmt:message>head.type</fmt:message>"},					
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privilegeId', 'optionFor': 'option in privilegeIds', 'optionValue': 'option', 'optionText': 'option' }, 'name': "<fmt:message>common.privilege</fmt:message>"},				
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.privateYn', 'optionFor': 'option in privateYnList', 'optionValue': 'option.value', 'optionText': 'option.name' }, 'name': "Private"},		
						{'type': "text", 'mappingDataInfo': "object.metaDomain", 'name': "<fmt:message>igate.record.metaDomain</fmt:message>"},
						{'type': "text",   'mappingDataInfo': 'object.recordGroup',  'name': "<fmt:message>head.group</fmt:message>"},	
					]
				},
				{
					'className': 'col-lg-12',
					'detailSubList': [
						{'type': "textarea", 'mappingDataInfo': "object.recordDesc", 'name': "<fmt:message>igate.record.description</fmt:message>", 'height': 200},							
					]
				},
			]
	    }, 
	    {
	        'type' : 'tree',
	        'id' : 'ModelInfo',
	        'name' : '<fmt:message>head.model.info</fmt:message>',
	    }, 
	    {
			'type': 'property',
			'id': 'RecordProperties',
			'name': '<fmt:message>head.extend.info</fmt:message>',
			'mappingDataInfo': 'recordProperties',
			'detailList': [
				{'type': 'text', 'mappingDataInfo': 'elm.propertyKey',	'name': '<fmt:message>common.property.key</fmt:message>'}, 
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
					]
				},								
	 		]
    	}
	]) ;

    createPageObj.setPanelButtonList({
    	dumpBtn: hasRecordEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/record/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/record/control.json'/>"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          recordId : null,
          recordName : null,
        },
      },
      methods : {
        search : function() {
        	vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
            vmList.makeGridObj.search(this, function() {
                $.ajax({
                    type : "GET",
                    url : "<c:url value='/igate/record/rowCount.json' />",
                    data: JsonImngObj.serialize(this.object),
                    processData : false,
                    success : function(result) {
                        vmList.totalCount = result.object;
                    }
                });
            }.bind(this));
        },
        initSearchArea : function(searchCondition) {
          
        	if(searchCondition) {
	            for(var key in searchCondition) {
	              this.$data[key] = searchCondition[key];
	            }
          	} else {
            	this.pageSize = '10' ;
            	this.object.recordId = null ;
            	this.object.recordName = null ;
          	}	  

          	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam) {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchServiceId : function(param) {
          this.object.recordId = param.recordId ;
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
        totalCount: '0',
        newTabPageUrl: "<c:url value='/igate/record.html' />"
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
          searchUri : "<c:url value='/igate/record/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "recordId",
            header : "<fmt:message>igate.record</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "25%"
          }, {
            name : "recordName",
            header : "<fmt:message>igate.record</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "50%"
          }, {
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
    
    window.vmModelInfo = new Vue({
        el : '#ModelInfo',
        methods : {
        	initRecordGrid : function(extendColumnInfo) {        		
        		var bodyHeight = 230 ;

                if ($('.panel-body').height() > 350)
                  bodyHeight = $('.panel-body').height() - 50 ;

                $('#ModelInfo').empty() ;
                
                var settings = {
                	el : document.getElementById('ModelInfo'),
                   	bodyHeight : bodyHeight,
                   	columnOptions: { resizable : true },
                   	onGridMounted: function() {
                   		$('#ModelInfo').find('.tui-grid-column-resize-handle').removeAttr('title');
                   	},
                   	header: {
                   		height: 60,
                       	complexColumns: []
                    },
                    treeColumnOptions : {
                     name : 'fieldId'
                    },
                    columns : []
              	};
            
                extendColumnInfo.forEach(function(complexColumnInfo) {
            	 
            		var complexColumn = { name : complexColumnInfo['@label'], header : complexColumnInfo['@label'], childNames : [] };
            	 
            	 	complexColumnInfo.Column.forEach(function(columnInfo) {
            		 
            			var column = { name : columnInfo['@name'], header : columnInfo['@label'], width : columnInfo['@width'], align : columnInfo['@align'] };

	            		 if('checkbox' == columnInfo['@editType']) { 
	            			column.align = "center";
    	        			column.formatter = function(value) { return '<input type="checkbox" name="'+ columnInfo['@name']+'"' + (('Y' == value.value)? 'checked': '') +' onclick="return false;">'; }
              		 
        	    		 } else if('select' == columnInfo['@editType']) {
              			
        	    			column.formatter = function(value) { 
              	   				
              	   				var selectDiv = "<select class='panel-form-control' name='" + columnInfo['@name'] + "' style='width : 100%; text-overflow: ellipsis;'>";
              	   				selectDiv += "		<option value=''></option>";
              	   				
              	   		   		columnInfo['@availableValue'].split(",").forEach(function(option) {
                  	   				var optionInfo = option.split("=");
                  	   				selectDiv += "<option value='"+ optionInfo[0] + "' " +((optionInfo[0] == value.value)? 'selected': '') + ">"+ escapeHtml(optionInfo[1]) +"</option>";
                  	   			});
                  		   		
                  		   		selectDiv += '</select>';
              	   				
              	   				return selectDiv; 
              	   			}
              	   		
              	   	 	} else {
              		    	column.escapeHTML = true;
              	   	 	}
            		 
            	   		settings.columns.push(column);            	   
            	   		complexColumn.childNames.push(columnInfo['@name']);
            	 	});
            	 
            	 	settings.header.complexColumns.push(complexColumn);           
            	});
             
            	recordTreeGrid = new tui.Grid(settings);
           		 
		        recordTreeGrid.on('mouseover', function(ev) {
	           	   	if('cell' != ev.targetType) return;
	           	   	
	           	    var overCellElement = $(recordTreeGrid.getElement(ev.rowKey, ev.columnName));  

	           	    if(!(recordTreeGrid.getValue(ev.rowKey, ev.columnName) == overCellElement.text().trim())) return;

	           	    overCellElement.attr('title', overCellElement.text());	           	   	
		    	});
		        
		        recordTreeGrid.on('click', function(ev) {
		        	if (ev.rowKey != null) {
		        		recordTreeGrid.store.data.rawData.forEach(function(data) {
		        			recordTreeGrid.removeRowClassName(data.rowKey, "row-selected");
		        		});        

		        		recordTreeGrid.addRowClassName(ev.rowKey, "row-selected");
		        	}
		        });		        
	        },
          	initRecordGridData : function(recordTreeGridData) {          		
          		if (!recordTreeGrid) {
          			$.ajax({
            	   		type: "GET",
            	    	url: "<c:url value='/iToolsConfig.xml'/>",
            	       	dataType: "xml",
            	       	success: function(result) {
            	       		var config = JSON.parse(xml2json(result, ' '));
            	        	this.initRecordGrid(config.Configuration.Record.GroupHeaders.GroupHeader);
                      		recordTreeGrid.resetData(initTreeData(recordTreeGridData));
                      		recordTreeGrid.expandAll();
            	    	}.bind(this)
	              	});              		
	            } else {
	            	recordTreeGrid.resetData(initTreeData(recordTreeGridData));
              		recordTreeGrid.expandAll();
	            }
          	},
          	refresh : function() {

	        	var bodyHeight = 230 ;
	
	            if ($('.panel-body').height() > 350)
	              bodyHeight = $('.panel-body').height() - 50 ;
	
	            if (recordTreeGrid) {
	              recordTreeGrid.setBodyHeight(bodyHeight) ;
	              recordTreeGrid.refreshLayout() ;
	            }
          	}
        }
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
        	recordId : null,
        	recordName : null,
        	recordType : null,
            privilegeId : null,
            recordGroup : null,
        	privateYn: null,
    		adapterId: null,
    		operationId: null,
    		activityId: null,
    		metaDomain: null,
    		requestRecordId: null,
    		responseRecordId: null,
    		recordDesc: null,
    		selectedMessageModel : null,
        },
        panelMode : null,
        privateYnList: [{value: 'Y', name: 'Y'}, {value: 'N', name: 'N'}],
        recordTypes: [
			{value: 'C', name: 'Common data-model'},
			{value: 'H', name: 'Header data-model'},
			{value: 'R', name: 'Reference data-model'},
			{value: 'I', name: 'Individual data-model'},
			{value: 'E', name: 'Embedded data-model'},
		],
        privilegeIds : [],
        recordProperties : []
      },
      computed: {
    	  pk: function() {
    		  return {
    			  recordId: this.object.recordId  
    		  };
    	  }  
      },
      created : function() {
  	    PropertyImngObj.getProperties('Property.Record', true, function(properties) {
          this.recordProperties = properties ;
        }.bind(this)) ;  
        
    	$.getJSON("<c:url value='/common/auth/businessPrivileges.json'/>", function(privilegeIdData) {
    		this.privilegeIds = privilegeIdData.object;	
		}.bind(this));
    	
        if (localStorage.getItem('selectedMessageModel')) {
        	this.selectedMessageModel = JSON.parse(localStorage.getItem('selectedMessageModel')) ;
          	localStorage.removeItem('selectedMessageModel') ;
          	
          	SearchImngObj.load($.param(this.selectedMessageModel));
        }
      },
      methods : {
      	loaded : function() {
      	    vmModelInfo.initRecordGridData(this.object.fields);

    		window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
            window.vmResouceInUse.object.updateTimestamp = this.object.updateTimestamp;  
            
            if(!this.object.recordOptions) {
            	window.vmRecordProperties.recordProperties = [];
            	return false;
            }
            
			var recordProperties = this.object.recordOptions.split(',');
      					
      		window.vmRecordProperties.recordProperties = recordProperties.map(function(recordProperty) {
      			
      			var property = recordProperty.split('=');
      			
      			var obj = {};
      			obj.propertyKey = property[0];
      			obj.propertyValue = property[1];
      			
      			if(this.recordProperties[0].pk.propertyKey === obj.propertyKey) {
      				obj.propertyDesc = this.recordProperties[0].propertyDesc;   	
      			}
      			
      			return obj; 
      			
      		}.bind(this));
    	},
        goDetailPanel : function()
        {
          panelOpen('detail', null, function() {
        	  if (this.selectedMessageModel) {
          		  $("#panel").find("[data-target='#panel']").trigger('click') ;
    	          $("#panel").find('#panel-header').find('.ml-auto').hide() ;
              }
          }.bind(this));       
        },
        initDetailArea : function(object)
        {
          if (object) {  
        	  this.object = object ;
          } else {
        	  this.object.recordId = null ;
              this.object.recordName = null ;
              this.object.recordType = null ;
              this.object.privilegeId = null ;
              this.object.privateYn = null ;
              this.object.metaDomain = null ;
              this.object.recordDesc = null ;
              
              window.vmRecordProperties.recordProperties = [];
              
              window.vmResouceInUse.object.lockUserId = null;
              window.vmResouceInUse.object.updateVersion = null;
              window.vmResouceInUse.object.updateUserId = null;
              window.vmResouceInUse.object.updateTimestamp = null;
          }
        },
      },
    }) ;
    
    window.vmRecordProperties = new Vue({
	    el : '#RecordProperties',
	    data : {
	    	recordProperties : []
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
    }) ;
    
    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
    
	function initTreeData(fields) {
		var rtnArr = [];
		
		fields.forEach(function(field) {
			
			rtnArr.push(field);

			if(field['options']) {      
				for(var key in field['options']) {      				
					rtnArr[rtnArr.length - 1][key] = (field['options'][key])? field['options'][key] : "Y";
      			}                
      		}
			
			if(field.recordObject) {
				field.fieldType = 'R';
				rtnArr[rtnArr.length - 1]._children = initTreeData(field.recordObject.fields);
			}
		});
		
		return rtnArr;
	}
	
	customResizeFunc = function() {		
		if(recordTreeGrid) {
			setTimeout(function() {
				recordTreeGrid.refreshLayout();
			}, 350);
		}
	};
  }) ;
</script>