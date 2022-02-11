<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('interfaceRestriction');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{
			'type' : "text",
			'mappingDataInfo' : "object.ruleId",
			'name' : "<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>",
			'placeholder' : "<fmt:message>head.searchId</fmt:message>"
		},
		{
			'type': "daterange", 
			'placeholder' : "<fmt:message>head.searchDate</fmt:message>",
			'mappingDataInfo': { 
				'daterangeInfo': [{'id' :  'searchDateFrom', 'name' : "<fmt:message>head.from</fmt:message>"}] 
			}
		},
		{
			'type': "select",
			'mappingDataInfo': {
				'selectModel': "object.whitelistYn",
				'optionFor': 'option in whitelistYn',
				'optionValue': 'option.pk.propertyKey',
				'optionText': 'option.propertyValue',
				'id': 'whitelistYn'
			},
			'name': "<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
		{
			'type': "select", 
			'mappingDataInfo': {
				'selectModel': 'object.enableYn', 
				'optionFor': 'option in enableYn', 
				'optionValue': 'option.pk.propertyKey', 
				'optionText': 'option.propertyValue',
				'id': 'enableYn'
			}, 
			'name': "<fmt:message>igate.transactionRestriction.enableYn</fmt:message>",
			'placeholder': "<fmt:message>head.all</fmt:message>"
		}
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		totalCount: true,
		addBtn: hasInterfaceRestrictionEditor,
		reorderBtn: hasInterfaceRestrictionEditor,
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
						{'type': "text", 'mappingDataInfo': "object.ruleId", 'name': "<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>",isPk: true},
						{
							'type' : "select",
							'mappingDataInfo' : {
								'selectModel' : 'object.whitelistYn',
								'optionFor' : 'option in whitelistYn',
								'optionValue' : 'option.pk.propertyKey',
								'optionText' : 'option.propertyValue'
							},
							'name' : "<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>"
						},
						{'type': "text", 'mappingDataInfo': "object.rulePriority", 'name': "<fmt:message>igate.transactionRestriction.rulePriority</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.restrictionMessage", 'name': "<fmt:message>igate.transactionRestriction.message</fmt:message>"}
					]
				},{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "singleDaterange", 'mappingDataInfo': {'id': 'startTime', 'dataDrops': 'up'}, 'name': "<fmt:message>head.from</fmt:message>"},
						{'type': "singleDaterange", 'mappingDataInfo': {'id': 'endTime', 'dataDrops': 'up'}, 'name': "<fmt:message>head.to</fmt:message>"},
						{
							'type': "select", 
							'mappingDataInfo': {
								'selectModel': 'object.enableYn', 
								'optionFor': 'option in enableYn', 
								'optionValue': 'option.pk.propertyKey', 
								'optionText': 'option.propertyValue'
							}, 
							'name': "<fmt:message>igate.transactionRestriction.enableYn</fmt:message>"
						},
					]
				}					
			]
		},{
			'type' : 'property',
			'id' : 'InterfaceRestrictionConds',
			'name' : '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>igate.transactionRestriction.value</fmt:message>',
			'addRowFunc' : 'interfaceRestrictionCondAdd',
			'removeRowFunc' : 'interfaceRestrictionCondRemove(index)',
			'mappingDataInfo' : 'interfaceRestrictionConds',
			'detailList' : [
				{
				'type' : 'select',
				'mappingDataInfo' : {
					'selectModel' : 'elm.pk.restrictionType',
					'optionFor' : 'option in restrictionTypes',
					'optionValue' : 'option.pk.propertyKey',
					'optionText' : 'option.propertyValue'
				},
				'name' : '<fmt:message>head.type</fmt:message>', isPk: true
				},
				{
				'type' : 'select',
				'mappingDataInfo' : {
					'selectModel' : 'elm.restrictionOperator',
					'optionFor' : 'option in restrictionOperators',
					'optionValue' : 'option.pk.propertyKey',
					'optionText' : 'option.propertyValue'
					},
				'name' : '<fmt:message>igate.transactionRestriction.operator</fmt:message>'
				},{'type': "text", 'mappingDataInfo': "elm.restrictionValue", 'name': "<fmt:message>igate.transactionRestriction.value</fmt:message>"}
	      ]
	    }
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasInterfaceRestrictionEditor,
		removeBtn: hasInterfaceRestrictionEditor,
		goModBtn: hasInterfaceRestrictionEditor,
		saveBtn: hasInterfaceRestrictionEditor,
		updateBtn: hasInterfaceRestrictionEditor,
		goAddBtn: hasInterfaceRestrictionEditor,
	});
	
	createPageObj.panelConstructor();	

	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/interfaceRestriction/object.json' />"
	});

	ControlImngObj.setConfig({
		controlUri : "<c:url value='/igate/interfaceRestriction/control.json' />"
	});	
	
	PropertyImngObj.getProperties('List.InterfaceRestriction.Type', true, function(restrictionType){
	
		PropertyImngObj.getProperties('List.Yn', true, function(enableYn){
		
			window.vmSearch = new Vue({
				el : '#' + createPageObj.getElementId('ImngSearchObject'),
				data : {
					pageSize : '10',
					object : {
						ruleId : null,
						startTime : null
					},
					restrictionType : [],
					whitelistYn : [],
					enableYn : []
				},
				methods : {
					search : function() {
						vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
						vmList.makeGridObj.search(this, function() {
			                $.ajax({
			                    type : "GET",
			                    url : "<c:url value='/igate/interfaceRestriction/rowCount.json' />",
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
							this.object.ruleId = null;
							this.object.startTime = null;
							this.object.endTime = null;
							this.object.whitelistYn = ' ';
							this.object.enableYn = ' ';							
						}

						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#ruleId'), this.object.ruleId);
						initDateSearchPicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'));
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#whitelistYn'), this.object.whitelistYn) ;
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#enableYn'), this.object.enableYn) ;
					}
				},
				mounted: function() {
					this.initSearchArea();
				},
				created: function() {
					this.restrictionType = restrictionType;
					this.whitelistYn = enableYn;
					this.enableYn = enableYn;
				}
			});
			
			var vmList = new Vue({
				el: '#' + createPageObj.getElementId('ImngListObject'),
				data: {
					makeGridObj: null,
					newTabPageUrl: "<c:url value='/igate/interfaceRestriction.html' />",
					totalCount: '0',
				},
				methods : $.extend(true, {}, listMethodOption, {
					initSearchArea: function() {
						window.vmSearch.initSearchArea();
					},
					reorder : function(){
					  ReorderImngObj.reorder("<c:url value='/igate/interfaceRestriction/reorder.json'/>") ;
					}
				}),
				mounted: function() {
					this.makeGridObj = getMakeGridObj();

					this.makeGridObj.setConfig({
						elementId: createPageObj.getElementId('ImngSearchGrid'),
						onClick: SearchImngObj.clicked,
						searchUri : "<c:url value='/igate/interfaceRestriction/search.json' />",
						viewMode : "${viewMode}",
						popupResponse : "${popupResponse}",
						popupResponsePosition : "${popupResponsePosition}",
						columns : [
							{
								name : "rulePriority",
								header : "<fmt:message>igate.transactionRestriction.rulePriority</fmt:message>",
								align : "center",
		                        width: "6%",
							}, 
							{
								name : "ruleId",
								header : "<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>",
								align : "left",
		                        width: "15%",
							}, 
							{
								name : "restrictionMessage",
								header : "<fmt:message>igate.transactionRestriction.message</fmt:message>",
								align : "left",
		                        width: "15%",
							},
							{
								name : "whitelistYn",
								header : "<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>",
								align : "center",
		                        width: "8%",
								formatter : function(value) {
									return ('Y' == value.row.whitelistYn)? 'Yes' : 'No';
								}
							},
							{
								name : "enableYn",
								header : "<fmt:message>igate.transactionRestriction.enableYn</fmt:message>",
								align : "center",
		                        width: "8%",
								formatter : function(value) {
									return ('Y' == value.row.enableYn)? 'Yes' : 'No';
								}
							},
							{
								name : "startTime",
								header : "<fmt:message>head.from</fmt:message>",
								align : "center",
		                        width: "15%",
								formatter : function(value) {
									return changeTime(value.row.startTime, true);
								}
							}, 
							{
								name : "endTime",
								header : "<fmt:message>head.to</fmt:message>",
								align : "center",
		                        width: "15%",
								formatter : function(value) {
									return changeTime(value.row.endTime, true);
								}
							}
						]
					});

					SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
					
					this.newTabSearchGrid();
				}
			});	
		});
	});

	window.vmMain = new Vue({
		el : '#MainBasic',
		data : {
			viewMode : 'Open',
			object : {
				enableYn : "Y",
				whitelistYn : "N",
				endTime : null,
				startTime : null,
				interfaceRestrictionConds : []
			},
			restrictionType : [],
			enableYn : [],
			whitelistYn :[],
			panelMode : null
		},
		computed : {
			pk : function() {
				return {
					ruleId : this.object.ruleId
				};
			}
		},
		created : function() {
			PropertyImngObj.getProperties('List.InterfaceRestriction.Type', true, function(properties) {
				this.restrictionType = properties;
			}.bind(this));

			PropertyImngObj.getProperties('List.Yn', true, function(properties) {
				this.enableYn = properties;
				this.whitelistYn = properties;
			}.bind(this));
		},
		methods : {
			goDetailPanel: function() {
 				panelOpen('detail', null, function(){
 					this.object.startTime = changeTime(this.object.startTime, true);
 					this.object.endTime = changeTime(this.object.endTime, true);
 					
					initDateDetailPicker(this, $('#panel').find('#MainBasic').find('#startTime'), $('#panel').find('#MainBasic').find('#endTime'), 'detail');
				}.bind(this)); 
			},
			initDetailArea: function(object) {
				if(object) {
					this.object=object;
				}else {
					this.object.startTime = null;
					this.object.endTime = null;
					this.object.restrictionMessage = null;	
					this.object.ruleId = null;
					this.object.rulePriority = null;
					
					window.vmInterfaceRestrictionConds.interfaceRestrictionConds = [] ;
				}
				
				$('#panel').find('#MainBasic').find('#startTime').val('');
				$('#panel').find('#MainBasic').find('#endTime').val('');
				initDateDetailPicker(this, $('#panel').find('#MainBasic').find('#startTime'), $('#panel').find('#MainBasic').find('#endTime'));
			}
		},
	});

	new Vue({
		el: '#panel-footer',
		methods : $.extend(panelMethodOption, {
			dumpInfo: function() {				
				window.vmMain.object.startTime = changeTime(window.vmMain.object.startTime);
		   		ControlImngObj.dump();
		   	},
		   	removeInfo: function() {
		   		window.vmMain.object.startTime = changeTime(window.vmMain.object.startTime);
		   		SaveImngObj.remove('<fmt:message>head.delete.conform</fmt:message>', '<fmt:message>head.delete.notice</fmt:message>');
		   	},
		   	updateInfo: function() {
		   		window.vmSearch.object.startTime = changeTime(window.vmSearch.object.startTime);
		   		window.vmMain.object.startTime = changeTime(window.vmMain.object.startTime);
		        window.vmMain.object.endTime = changeTime(window.vmMain.object.endTime);
		        
		        if(!window.vmInterfaceRestrictionConds.validationCheck()) return;
		        
		        if(window.vmMain.object.startTime > window.vmMain.object.endTime) {
		   			warnAlert({message : '<fmt:message>igate.time.precedeWarn</fmt:message>'}) ;
		   			return;
		   		}
		        
		   		SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
		   	},
		   	saveInfo: function() {
		   		window.vmMain.object.startTime = changeTime(window.vmMain.object.startTime);
		   		window.vmMain.object.endTime = changeTime(window.vmMain.object.endTime);
		   		
		   		if(!window.vmInterfaceRestrictionConds.validationCheck()) return;
		   		
		   		if(window.vmMain.object.startTime > window.vmMain.object.endTime) {
		   			warnAlert({message : '<fmt:message>igate.time.precedeWarn</fmt:message>'}) ;
		   			return;
		   		}

		   		SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
		   	}
		})
	});

	//거래제한 값 탭
	window.vmInterfaceRestrictionConds = new Vue({
		el : '#InterfaceRestrictionConds',
		data : {
			viewMode : 'Open',
			interfaceRestrictionConds : [],
			restrictionTypes : [],
			restrictionOperators : [],
			selectedIndex : null,
		},
		methods : {
			interfaceRestrictionCondAdd : function() // 라인 추가 
			{
				this.interfaceRestrictionConds.push({
					restrictionOperator : null,
					restrictionValue : null,
					pk : {
						restrictionType : null
					}
				}) ;
			},
			interfaceRestrictionCondRemove : function(index) // 라인 삭제
			{
				this.interfaceRestrictionConds = this.interfaceRestrictionConds.slice(0, index).concat(this.interfaceRestrictionConds.slice(index + 1)) ;
			},
			validationCheck: function() {
		   		
				var isValidation = true;
				
				for(var i = 0; i < this.interfaceRestrictionConds.length; i++) {
					
					var info = this.interfaceRestrictionConds[i];
					
					if(!info || !info.pk || !info.pk.restrictionType || !info.restrictionOperator || !info.restrictionValue) {
						warnAlert({message : '<fmt:message>igate.transactionRestriction.valNullCheck</fmt:message>'}) ;
						isValidation = false;
						break;
					}
				}
		   		
		   		return isValidation;
		   	}
		},
		created : function() // 초기 세팅할 리스트 값
		{
			PropertyImngObj.getProperties('List.InterfaceRestriction.Type', true, function(restrictionTypes) 
				{
					this.restrictionTypes = restrictionTypes;
				}.bind(this));
			PropertyImngObj.getProperties('List.TransactionRestriction.Operator', false, function(restrictionOperators)
				{
					this.restrictionOperators = restrictionOperators ;
				}.bind(this)) ; 
		},
	}) ;

});

function initDateSearchPicker(vueObj, dateSelector) {
	if (${'HHmmss' == dateFormat}){	
		var startTime = '00:00:00';
		
		if(vueObj.object.startTime) {
			var hour = vueObj.object.startTime.substring(0, 2);
			var minute = vueObj.object.startTime.substring(2, 4);
			var seconds = vueObj.object.startTime.substring(4, 6);
			
			startTime = hour + ':' + minute + ':' + seconds;
		}	
		
		dateSelector.customTimePicker(function(time){
			vueObj.object.startTime = changeTime(time);
		}, {startTime: startTime});		
	}else{		
		var paramOption = {
			timePicker: true, 
			timePicker24Hour: true,
			timePickerSeconds: true,
			autoUpdateInput : false,
			format : 'YYYYMMDDHHmmss',
			localeFormat : 'YYYY.MM.DD HH:mm:ss',
		}	
		
		dateSelector.customDatePicker(function(time) {
			vueObj.object.startTime = changeTime(time);
		}, paramOption);
	}	
}

function initDateDetailPicker(vueObj, dateFromSelector, dateToSelector, type) {

	if (${'HHmmss' == dateFormat}){	
		dateFromSelector.customTimePicker(function(time){
			vueObj.object.startTime = time;
		}, {startTime : vueObj.object.startTime});

		dateToSelector.customTimePicker(function(time){
			vueObj.object.endTime = time;
		}, {startTime : vueObj.object.endTime});			

	}else{		
	    var paramOption = {
			timePicker: true, 
			timePicker24Hour: true,
			timePickerSeconds: true,
			format : 'YYYYMMDDHHmmss',
			localeFormat : 'YYYY-MM-DD HH:mm:ss',
			drops: 'up'
		}
	   
	    if(type){
	 	   paramOption.autoUpdateInput = true;
	       paramOption.startDate = vueObj.object.startTime;	    	
	    }
  
	    dateFromSelector.customDatePicker(function(time) {
			vueObj.object.startTime = time;
		}, paramOption);

	    if(type) paramOption.startDate = vueObj.object.endTime;
	    
	    dateToSelector.customDatePicker(function(time) {
	    	vueObj.object.endTime = time;
		}, paramOption); 
	}	
}

function changeTime(pTime, isDisplay) {
	if(!pTime) return;
		
	if(!isDisplay) {
		var convertTime = pTime.replace(/:/gi, '');
		
		convertTime = convertTime.replace(/-/gi, '');
		
		convertTime = convertTime.replace(/(\s*)/g, '');
		
		return convertTime;	
	}else {
		var dateFormat = '${dateFormat}';
		
		if(14 == dateFormat.length && 6 == pTime.length) {
			pTime = moment().format('YYYYMMDD') + pTime;
		}else if(6 == dateFormat.length && 14 == pTime.length) {
			pTime = pTime.substring(8);
		}		
		
		if(14 == pTime.length){
			var date = pTime.substring(0, 8);
			var time = pTime.substring(8);
			
			date = date.replace(/(.{4})/g, "$1-");
			date = date.replace(/(.{7})/g, "$1-");
			date = date.slice(0, -1);
			
			time = time.replace(/(.{2})/g, "$1:");
			time = time.slice(0, -1);

			return date + ' ' + time;
		}else if(6 == pTime.length) {
			var time = pTime.replace(/(.{2})/g, "$1:");
			
			time = time.slice(0,-1);
			
			return time;
		}
	}
}
</script>