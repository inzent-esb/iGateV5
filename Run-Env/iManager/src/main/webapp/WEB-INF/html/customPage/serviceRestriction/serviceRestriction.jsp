<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
	
	<style>
		.ui-widget-header, .ui_tpicker_time_label, .ui_tpicker_time, .ui_tpicker_millisec_label, .ui_tpicker_millisec, 
		.ui_tpicker_microsec_label, .ui_tpicker_microsec, .ui_tpicker_timezone_label, .ui_tpicker_timezone {
			display: none;
		}
		
		#ui-datepicker-div .ui-timepicker-div dl dd:not(.ui_tpicker_time) {
			margin-left: 10px;
		}
	</style>
</head>
<body>
	<div id="serviceRestriction" data-ready>
		<sec:authorize var="hasServiceRestrictionViewer" access="hasRole('ServiceRestrictionViewer')"></sec:authorize>
		<sec:authorize var="hasServiceRestrictionEditor" access="hasRole('ServiceRestrictionEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#serviceRestriction').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasServiceRestrictionViewer}';
			var editor = 'true' == '${hasServiceRestrictionEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('serviceRestriction');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'daterange',
			        mappingDataInfo: {
			            daterangeInfo: [{ id: 'searchDateFrom', name: '<fmt:message>head.from</fmt:message>' }]
			        }
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>igate.transactionRestriction.enableYn</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'enableList',
			            selectModel: 'object.enableYn',
			            optionFor: 'option in enableList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'whitelistList',
			            selectModel: 'object.whitelistYn',
			            optionFor: 'option in whitelistList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    { type: 'text', mappingDataInfo: 'object.ruleId', name: '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>', placeholder: '<fmt:message>head.searchId</fmt:message>', regExpType: 'searchId' }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    addBtn: editor,			    
			    reorderBtn: editor,
			    totalCnt: viewer,
			    currentCnt: viewer,
			});

			createPageObj.mainConstructor();

			createPageObj.setTabList([
			    {
			        type: 'basic',
			        id: 'MainBasic',
			        name: '<fmt:message>head.basic.info</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        name: '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: 'object.ruleId',
			                        isPk: true,
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        name: '<fmt:message>igate.transactionRestriction.rulePriority</fmt:message>',
			                        mappingDataInfo: 'object.rulePriority',
			                        regExpType: 'num'
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>',
			                        isRequired: true,
			                        mappingDataInfo: {
			                            id: 'whitelistList',
			                            selectModel: 'object.whitelistYn',
			                            optionFor: 'option in whitelistList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        }
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'singleDaterange',
			                        name: '<fmt:message>head.from</fmt:message>',
			                        isRequired: true,
			                        mappingDataInfo: {
			                            id: 'startTime',
			                            dataDrops: 'up'
			                        }
			                    },
			                    {
			                        type: 'singleDaterange',
			                        name: '<fmt:message>head.to</fmt:message>',
			                        isRequired: true,
			                        mappingDataInfo: {
			                            id: 'endTime',
			                            dataDrops: 'up'
			                        }
			                    },
			                    {
			                        type: 'text',
			                        name: '<fmt:message>igate.transactionRestriction.message</fmt:message>',
			                        mappingDataInfo: 'object.restrictionMessage',
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.transactionRestriction.enableYn</fmt:message>',
			                        isRequired: true,
			                        mappingDataInfo: {
			                            id: 'enableList',
			                            selectModel: 'object.enableYn',
			                            optionFor: 'option in enableList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        }
			                    }
			                ]
			            }
			        ]
			    },
			    {
					'type': 'property',
					'id': 'ServiceRestrictionConds',
					'name': '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>igate.transactionRestriction.value</fmt:message>',
					'addRowFunc': 'serviceRestrictionCondAdd',
					'removeRowFunc': 'serviceRestrictionCondRemove(index)',
					'mappingDataInfo': 'serviceRestrictionConds',
					'detailList': [
						{
							'type': 'select',
							'mappingDataInfo': {
								'selectModel': 'elm.pk.restrictionType',
								'optionFor': 'option in restrictionTypes',
								'optionValue': 'option.pk.propertyKey',
								'optionText': 'option.propertyValue'
							},
							'name': '<fmt:message>head.type</fmt:message>', 
							'isPk': true
						},
						{
							'type': 'select',
							'mappingDataInfo': {
								'selectModel': 'elm.restrictionOperator',
								'optionFor': 'option in restrictionOperators',
								'optionValue': 'option.pk.propertyKey',
								'optionText': 'option.propertyValue'
							},
							'name': '<fmt:message>igate.transactionRestriction.operator</fmt:message>'
						},
						{
							'type': "text", 
							'mappingDataInfo': "elm.restrictionValue", 
							'name': "<fmt:message>igate.transactionRestriction.value</fmt:message>",
							'regExpType': 'value'
						}
					]
			    }
			]);

			createPageObj.setPanelButtonList({
			    dumpBtn: editor,
			    removeBtn: editor,
			    goModBtn: editor,
			    saveBtn: editor,
			    updateBtn: editor,
			    goAddBtn: editor
			});

			createPageObj.panelConstructor();

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/serviceRestriction/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/serviceRestriction/control',
			    dumpUrl: '/api/entity/serviceRestriction/dump'
			});

			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Yn' }, orderByKey: true }, function (serviceRestrictionYnResult) {
			    new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.ServiceRestriction.Type' }, orderByKey: true }, function (restrictionTypeListResult) {
			        new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.TransactionRestriction.Operator' }, orderByKey: true }, function (restrictionOperatorListResult) {
		                window.vmSearch = new Vue({
		                    el: '#' + createPageObj.getElementId('ImngSearchObject'),
		                    data: {
		                        object: {
		                            startTime: null,
		                            enableYn: ' ',
		                            whitelistYn: ' ',
		                            ruleId: null,
		                            pageSize: '10',
		                        },
		                        letter: {
		                            ruleId: 0
		                        },
		                        enableList: [],
		                        whitelistList: []
		                    },
		                    methods: $.extend(true, {}, searchMethodOption, {
		                        inputEvt: function (info) {
		                            setLengthCnt.call(this, info);
		                        },
		                        search: function () {
		                            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

		                            vmList.makeGridObj.search(this.object, function(info) {
						            	vmList.currentCnt = info.currentCnt;
						            	vmList.totalCnt = info.totalCnt;
						            });
						        },
		                        initSearchArea: function (searchCondition) {
		                            if (searchCondition) {
		                                for (var key in searchCondition) {
		                                    this.$data[key] = searchCondition[key];
		                                }
		                            } else {
		                                this.object.pageSize = '10';
		                                this.object.startTime = null;
		                                this.object.enableYn = ' ';
		                                this.object.whitelistYn = ' ';
		                                this.object.ruleId = null;

		                                this.letter.ruleId = 0;
		                            }

		                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#enableList'), this.object.enableYn);
		                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#whitelistList'), this.object.whitelistYn);

		                            initDateSearchPicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'));
		                        }
		                    }),
		                    created: function () {
		                        this.enableList = serviceRestrictionYnResult.object;
		                        this.whitelistList = serviceRestrictionYnResult.object;
		                    },				                    
		                    mounted: function () {
		                    	this.initSearchArea();
		                    }
		                });

		                var vmList = new Vue({
		                    el: '#' + createPageObj.getElementId('ImngListObject'),
		                    data: {
		                        makeGridObj: null,
		                        totalCnt: 0,
						        currentCnt: 0
						    },
						    methods: $.extend(true, {}, listMethodOption, {
						        initSearchArea: function () {
						            window.vmSearch.initSearchArea();
						        },
								reorder: function() {
									new HttpReq('/api/entity/serviceRestriction/reorder').update(null, function(result) {
										if ('ok' === result.result) window.vmSearch.search();
									});
								}
		                    }),
		                    mounted: function () {
		                        this.makeGridObj = getMakeGridObj();

		                        this.makeGridObj.setConfig({
		                        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
						            searchUrl: '/api/entity/serviceRestriction/search',
						            totalCntUrl: '/api/entity/serviceRestriction/count',
						    		paging: {
						    			isUse: true,
						    			side: "server",
						    			setCurrentCnt: function(currentCnt) {
						    			    this.currentCnt = currentCnt
						    			}.bind(this)						    			
						    		},
		                            columns: [
		                                {
		                                    name: 'rulePriority',
		                                    header: '<fmt:message>igate.transactionRestriction.rulePriority</fmt:message>',
		                                    align: 'center',
		                                    width: '10%'
		                                },
		                                {
		                                    name: 'startTime',
		                                    header: '<fmt:message>head.from</fmt:message>',
		                                    align: 'center',
		                                    width: '20%',
		                                    formatter: function (value) {
		                                        return changeTime(value.row.startTime, true);
		                                    }
		                                },
		                                {
		                                    name: 'endTime',
		                                    header: '<fmt:message>head.to</fmt:message>',
		                                    align: 'center',
		                                    width: '20%',
		                                    formatter: function (value) {
		                                        return changeTime(value.row.endTime, true);
		                                    }
		                                },
		                                {
		                                    name: 'enableYn',
		                                    header: '<fmt:message>igate.transactionRestriction.enableYn</fmt:message>',
		                                    align: 'center',
		                                    width: '10%',
		                                    formatter: function (value) {
		                                        return 'Y' == value.row.enableYn ? 'Yes' : 'No';
		                                    }
		                                },
		                                {
		                                    name: 'whitelistYn',
		                                    header: '<fmt:message>igate.transactionRestriction.whiteListYn</fmt:message>',
		                                    align: 'center',
		                                    width: '10%',
		                                    formatter: function (value) {
		                                        return 'Y' == value.row.enableYn ? 'Yes' : 'No';
		                                    }
		                                },
		                                {
		                                    name: 'ruleId',
		                                    header: '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>head.id</fmt:message>',
		                                    align: 'left',
		                                    width: '30%'
		                                }
		                            ],
			                        onGridMounted: function(evt) {
						            	evt.instance.on('click', function(evt) {
						            		SearchImngObj.clicked(evt.instance.getRow(evt.rowKey));
						            	});
						            }
		                        });

		                        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();

						        this.$nextTick(function () {
						        	this.newTabSearchGrid();
						        	
					                window.vmSearch.$nextTick(function () {
					                	window.vmSearch.search();
					                });
						        }.bind(this));
		                    }
		                });

		                window.vmMain = new Vue({
		                    el: '#MainBasic',
		                    data: {
		                        viewMode: 'Open',
		                        enableList: [],
		                        whitelistList: [],
		                        letter: {
		                            ruleId: 0,
		                            rulePriority: 0,
		                            restrictionMessage: 0
		                        },
		                        object: {
		                            ruleId: null,
		                            rulePriority: null,
		                            whitelistYn: ' ',
		                            startTime: null,
		                            endTime: null,
		                            restrictionMessage: null,
		                            enableYn: ' ',
		                            serviceRestrictionConds: []
		                        },
		                        openWindows: [],
		                        panelMode: null
		                    },
		                    computed: {
		                        pk: function () {
		                            return {
		                                ruleId: this.object.ruleId
		                            };
		                        }
		                    },
		                    watch: {
		                        panelMode: function () {
		                            if (this.panelMode != 'add') $('#panel').find('.warningLabel').hide();
		                        }
		                    },
		                    created: function () {},
		                    methods: {
		                        inputEvt: function (info) {
		                            setLengthCnt.call(this, info);
		                        },
		                        goDetailPanel: function () {
		                            panelOpen(
		                                'detail',
		                                null,
		                                function () {
		                                    this.object.startTime = changeTime(this.object.startTime, true);
		                                    this.object.endTime = changeTime(this.object.endTime, true);

		                                    initDateDetailPicker(this, $('#panel').find('#MainBasic').find('#startTime'), $('#panel').find('#MainBasic').find('#endTime'), 'detail');
		                                }.bind(this)
		                            );
		                        },
		                        initDetailArea: function (object) {
		                            if (object) {
		                                this.object = object;
		                            } else {
		                                this.object.ruleId = null;
		                                this.object.rulePriority = null;
		                                this.object.whitelistYn = ' ';
		                                this.object.startTime = null;
		                                this.object.endTime = null;
		                                this.object.restrictionMessage = null;
		                                this.object.enableYn = ' ';

		                                this.letter.ruleId = 0;
		                                this.letter.rulePriority = 0;
		                                this.letter.restrictionMessage = 0;
		                                
		                                window.vmServiceRestrictionConds.serviceRestrictionConds = [];
		                            }

		                            $('#panel').find('#MainBasic').find('#startTime').val('');
		                            $('#panel').find('#MainBasic').find('#endTime').val('');
		                            initDateDetailPicker(this, $('#panel').find('#MainBasic').find('#startTime'), $('#panel').find('#MainBasic').find('#endTime'));
		                        }
		                    },
		                    mounted: function () {
		                        this.enableList = serviceRestrictionYnResult.object;
		                        this.whitelistList = serviceRestrictionYnResult.object;
		                    }
		                });

		            	window.vmServiceRestrictionConds = new Vue({
		            		el: '#ServiceRestrictionConds',
		            		data: {
		            			viewMode: 'Open',
		            			serviceRestrictionConds: [],
		            			restrictionTypes: [],
		            			restrictionOperators: [],
		            			selectedIndex: null,
		            		},
		            		methods: {
		            			inputEvt: function(info, data) {
		            				setLengthCnt.call(data, info);
		            			},
		            			serviceRestrictionCondAdd: function() {
		            				this.serviceRestrictionConds.push({
		            					restrictionOperator: null,
		            					restrictionValue: null,
		            					pk: {
		            						restrictionType: null
		            					},
		            					letter: {
		            						restrictionValue: 0,
		            					}
		            				});
		            			},
		            			serviceRestrictionCondRemove: function(index) {
		            				this.serviceRestrictionConds = this.serviceRestrictionConds.slice(0, index).concat(this.serviceRestrictionConds.slice(index + 1));
		            			},
		            			validationCheck: function() {
		            				var isValidation = true;
		            				
		            				for(var i = 0; i < this.serviceRestrictionConds.length; i++) {
		            					
		            					var info = this.serviceRestrictionConds[i];
		            					
		            					if(!info || !info.pk || !info.pk.restrictionType || !info.restrictionOperator || !info.restrictionValue) {
		            						window._alert({type: 'warn', message: '<fmt:message>igate.transactionRestriction.valNullCheck</fmt:message>'});
		            						isValidation = false;
		            						break;
		            					}
		            				}
		            		   		
		            		   		return isValidation;
		            		   	}
		            		},
		            		created: function() {
		            			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.ServiceRestriction.Type' }, orderByKey: true }, function (restrictionTypesResult) {
		            				this.restrictionTypes = restrictionTypesResult.object;
		            			}.bind(this));
		            			
		            			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.TransactionRestriction.Operator' }, orderByKey: true }, function (restrictionOperatorsResult) {
		            				this.restrictionOperators = restrictionOperatorsResult.object;
		            			}.bind(this));
		            		},
		            	});
		            });
		        });
		    });

			new Vue({
			    el: '#panel-header',
			    methods: $.extend(true, {}, panelMethodOption)
			});

			new Vue({
			    el: '#panel-footer',
			    methods: $.extend(true, panelMethodOption, {
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
				        
				        if(!window.vmServiceRestrictionConds.validationCheck()) return;
				        
				        if(window.vmMain.object.startTime > window.vmMain.object.endTime) {
				        	window._alert({type: 'warn', message: '<fmt:message>igate.time.precedeWarn</fmt:message>'});
				   			return;
				   		}
				        
				   		SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
				   	},
				   	saveInfo: function() {
				   		window.vmMain.object.startTime = changeTime(window.vmMain.object.startTime);
				   		window.vmMain.object.endTime = changeTime(window.vmMain.object.endTime);
				   		
				   		if(!window.vmServiceRestrictionConds.validationCheck()) return;
				   		
				        if(window.vmMain.object.startTime > window.vmMain.object.endTime) {
				        	window._alert({type: 'warn', message: '<fmt:message>igate.time.precedeWarn</fmt:message>'});
				   			return;
				   		}
				   		
				   		SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
				   	}			    	
			    })
			});

			this.addEventListener('destroy', function (evt) {
			    $('.daterangepicker').remove();
			    $('.ui-datepicker').remove();
			    $('.backdrop').remove();
			    $('.modal').remove();
			    $('.modal-backdrop').remove();
			    $('#ct').find('script').remove();
			});
			
			function changeTime(pTime, isDisplay) {
			    if (!pTime) return;

			    if (!isDisplay) {
			        var convertTime = pTime.replace(/:/gi, '');

			        convertTime = convertTime.replace(/-/gi, '');

			        convertTime = convertTime.replace(/(\s*)/g, '');

			        return convertTime;
			    } else {
			        var dateFormat = constants.serviceRestrictionDateFormat;

			        if (14 == dateFormat.length && 6 == pTime.length) {
			            pTime = moment().format('YYYYMMDD') + pTime;
			        } else if (6 == dateFormat.length && 14 == pTime.length) {
			            pTime = pTime.substring(8);
			        }

			        var time = null;

			        if (14 == pTime.length) {
			            var date = pTime.substring(0, 8);
			            time = pTime.substring(8);

			            date = date.replace(/(.{4})/g, '$1-');
			            date = date.replace(/(.{7})/g, '$1-');
			            date = date.slice(0, -1);

			            time = time.replace(/(.{2})/g, '$1:');
			            time = time.slice(0, -1);

			            return date + ' ' + time;
			        } else if (6 == pTime.length) {
			            time = pTime.replace(/(.{2})/g, '$1:');

			            time = time.slice(0, -1);

			            return time;
			        }
			    }
			}
				
			function initDateSearchPicker(vueObj, dateSelector) {
				if ('HHmmss' == constants.serviceRestrictionDateFormat){
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
				} else {	
					var paramOption = {
						timePicker: true, 
						timePicker24Hour: true,
						timePickerSeconds: true,
						autoUpdateInput : false,
						format : 'YYYYMMDDHHmmss',
						localeFormat : 'YYYY.MM.DD HH:mm:ss',
						startDate: (function() {
							if (vueObj.object.startTime) {
								var startTime = vueObj.object.startTime;
								
								var year = startTime.substring(0, 4);
								var month = startTime.substring(4, 6);
								var day = startTime.substring(6, 8);
								var hour = startTime.substring(8, 10);
								var minute = startTime.substring(10, 12);
								var second = startTime.substring(12, 14);
								
								return new Date(year, month - 1, day, hour, minute, second).getTime();
							} else {
								var date = new Date(Date.now());

								date.setHours(0);
								date.setMinutes(0);
								date.setSeconds(0);
								date.setMilliseconds(0);
								
								return date.getTime();
							}
						})()
					};	
					
					dateSelector.customDatePicker(function(time) {
						vueObj.object.startTime = changeTime(time);
					}, paramOption);
				}	
			}
			
			function initDateDetailPicker(vueObj, dateFromSelector, dateToSelector, type) {
				if ('HHmmss' == constants.serviceRestrictionDateFormat){	
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
		});
	</script>
</body>
</html>
