<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="<c:url value='/custom/css/jquery-ui.min.css' />">
	
	<style>
		.ui-widget-header, .ui_tpicker_time_label, .ui_tpicker_time, .ui_tpicker_millisec_label, .ui_tpicker_millisec, 
		.ui_tpicker_microsec_label, .ui_tpicker_microsec, .ui_tpicker_timezone_label, .ui_tpicker_timezone {
			display: none;
		}
		
		#ui-datepicker-div .ui-timepicker-div dl dd:not(.ui_tpicker_time) {
			margin-left: 10px;
		}
	</style>
	
	<script type="text/javascript" src="<c:url value='/custom/js/jquery-ui-timepicker-addon.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/custom/js/jquery-ui-timepicker-addon-i18n.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/custom/js/jquery-ui-timepicker-addon-i18n-ext.js' />"></script>
	
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="interfaceRestriction" data-ready>
		<sec:authorize var="hasInterfaceRestrictionViewer" access="hasRole('InterfaceRestrictionViewer')"></sec:authorize>
		<sec:authorize var="hasInterfaceRestrictionEditor" access="hasRole('InterfaceRestrictionEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#interfaceRestriction').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasInterfaceRestrictionViewer}';
			var editor = 'true' == '${hasInterfaceRestrictionEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('interfaceRestriction');
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
			    totalCount: viewer,
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    addBtn: editor
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
			                        mappingDataInfo: {
			                            id: 'startTime',
			                            dataDrops: 'up'
			                        }
			                    },
			                    {
			                        type: 'singleDaterange',
			                        name: '<fmt:message>head.to</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'endTime',
			                            dataDrops: 'up'
			                        }
			                    },
			                    {
			                        type: 'text',
			                        name: '<fmt:message>igate.transactionRestriction.message</fmt:message>',
			                        mappingDataInfo: 'object.restrictionMessage'
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.transactionRestriction.enableYn</fmt:message>',
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
			        type: 'property',
			        id: 'InterfaceRestrictionConds',
			        name: '<fmt:message>igate.transactionRestriction</fmt:message> <fmt:message>igate.transactionRestriction.value</fmt:message>',
			        mappingDataInfo: 'interfaceRestrictionConds',
			        detailList: [
			            {
			                type: 'select',
			                name: '<fmt:message>common.type</fmt:message>',
			                mappingDataInfo: {
			                    id: 'restrictionTypeList',
			                    selectModel: 'elm.pk.restrictionType',
			                    optionFor: 'option in restrictionTypeList',
			                    optionValue: 'option.pk.propertyKey',
			                    optionText: 'option.propertyValue'
			                }
			            },
			            {
			                type: 'select',
			                name: '<fmt:message>igate.transactionRestriction.operator</fmt:message>',
			                mappingDataInfo: {
			                    id: 'restrictionOperatorList',
			                    selectModel: 'elm.restrictionOperator',
			                    optionFor: 'option in restrictionOperatorList',
			                    optionValue: 'option.pk.propertyKey',
			                    optionText: 'option.propertyValue'
			                }
			            },
			            {
			                type: 'text',
			                name: '<fmt:message>igate.transactionRestriction.value</fmt:message>',
			                mappingDataInfo: 'elm.restrictionValue'
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
			    objectUri: '/igate/interfaceRestriction/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/interfaceRestriction/control.json'
			});

			new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Yn', orderByKey: true }, function (interfaceRestrictionYnResult) {
			    new HttpReq('/common/property/properties.json').read({ propertyId: 'List.InterfaceRestriction.Type', orderByKey: true }, function (restrictionTypeListResult) {
			        new HttpReq('/common/property/properties.json').read({ propertyId: 'List.TransactionRestriction.Operator', orderByKey: true }, function (restrictionOperatorListResult) {
			            new HttpReq('/igate/interfaceRestriction/dateFormat.json').read(null, function (dateFormatResult) {
			                window.vmSearch = new Vue({
			                    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			                    data: {
			                        pageSize: '10',
			                        enableList: [],
			                        whitelistList: [],
			                        letter: {
			                            ruleId: 0
			                        },
			                        object: {
			                            startTime: null,
			                            enableYn: ' ',
			                            whitelistYn: ' ',
			                            ruleId: null
			                        }
			                    },
			                    methods: $.extend(true, {}, searchMethodOption, {
			                        inputEvt: function (info) {
			                            setLengthCnt.call(this, info);
			                        },
			                        search: function () {
			                            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

			                            vmList.makeGridObj.search(
			                                this,
			                                function () {
			                                    new HttpReq('/igate/interfaceRestriction/rowCount.json').read(this.object, function (result) {
			                                        vmList.totalCount = 0 == result.object ? 0 : numberWithComma(result.object);
			                                    });
			                                }.bind(this)
			                            );
			                        },
			                        initSearchArea: function (searchCondition) {
			                            if (searchCondition) {
			                                for (var key in searchCondition) {
			                                    this.$data[key] = searchCondition[key];
			                                }
			                            } else {
			                                this.pageSize = '10';
			                                this.object.startTime = null;
			                                this.object.enableYn = ' ';
			                                this.object.whitelistYn = ' ';
			                                this.object.ruleId = null;

			                                this.letter.ruleId = 0;
			                            }

			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#enableList'), this.object.enableYn);
			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#whitelistList'), this.object.whitelistYn);

			                            initDateSearchPicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), dateFormatResult.object);
			                        }
			                    }),
			                    mounted: function () {
			                        this.enableList = interfaceRestrictionYnResult.object;
			                        this.whitelistList = interfaceRestrictionYnResult.object;

			                        this.$nextTick(
			                            function () {
			                                this.initSearchArea();
			                            }.bind(this)
			                        );
			                    }
			                });

			                var vmList = new Vue({
			                    el: '#' + createPageObj.getElementId('ImngListObject'),
			                    data: {
			                        makeGridObj: null,
			                        totalCount: '0'
			                    },
			                    methods: $.extend(true, {}, listMethodOption, {
			                        initSearchArea: function () {
			                            window.vmSearch.initSearchArea();
			                        },
			                        reorder: function () {}
			                    }),
			                    mounted: function () {
			                        this.makeGridObj = getMakeGridObj();

			                        this.makeGridObj.setConfig({
			                            elementId: createPageObj.getElementId('ImngSearchGrid'),
			                            onClick: function (loadParam, ev) {
			                                SearchImngObj.clicked({ ruleId: loadParam['ruleId'] });
			                            },
			                            searchUri: '/igate/interfaceRestriction/search.json',
			                            viewMode: '${viewMode}',
			                            popupResponse: '${popupResponse}',
			                            popupResponsePosition: '${popupResponsePosition}',
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
			                            ]
			                        });

			                        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();

			                        if (!this.newTabSearchGrid()) {
			                            this.$nextTick(function () {
			                                window.vmSearch.search();
			                            });
			                        }
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
			                            interfaceRestrictionConds: []
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
			                            }

			                            $('#panel').find('#MainBasic').find('#startTime').val('');
			                            $('#panel').find('#MainBasic').find('#endTime').val('');
			                            initDateDetailPicker(this, $('#panel').find('#MainBasic').find('#startTime'), $('#panel').find('#MainBasic').find('#endTime'));
			                        }
			                    },
			                    mounted: function () {
			                        this.enableList = interfaceRestrictionYnResult.object;
			                        this.whitelistList = interfaceRestrictionYnResult.object;
			                    }
			                });

			                window.vmInterfaceRestrictionConds = new Vue({
			                    el: '#InterfaceRestrictionConds',
			                    data: {
			                        interfaceRestrictionConds: [],
			                        restrictionTypeList: [],
			                        restrictionOperatorList: []
			                    },
			                    mounted: function () {
			                        this.restrictionTypeList = restrictionTypeListResult.object;
			                        this.restrictionOperatorList = restrictionOperatorListResult.object;
			                    }
			                });
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
			    methods: $.extend(true, {}, panelMethodOption)
			});

			this.addEventListener('destroy', function (evt) {
			    $('.daterangepicker').remove();
			    $('.ui-datepicker').remove();
			    $('.backdrop').remove();
			    $('.modal').remove();
			    $('.modal-backdrop').remove();
			    $('#ct').find('script').remove();
			});
		});
		
		function changeTime(pTime, isDisplay) {
		    if (!pTime) return;

		    if (!isDisplay) {
		        var convertTime = pTime.replace(/:/gi, '');

		        convertTime = convertTime.replace(/-/gi, '');

		        convertTime = convertTime.replace(/(\s*)/g, '');

		        return convertTime;
		    } else {
		        var dateFormat = '${dateFormat}';

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
			
		function initDateSearchPicker(vueObj, dateSelector, dateFormat) {
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
					localeFormat : 'YYYY.MM.DD HH:mm:ss'
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
	</script>
</body>
</html>
