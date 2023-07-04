<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="interface" data-ready>
		<sec:authorize var="hasInterfaceViewer" access="hasRole('InterfaceViewer')"></sec:authorize>
		<sec:authorize var="hasInterfaceEditor" access="hasRole('InterfaceEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>				
	</div>
	<script>
		document.querySelector('#interface').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasInterfaceViewer}';
			var editor = 'true' == '${hasInterfaceEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('interface');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.interfaceId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.interfaceName',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.interfaceType',
			            optionFor: 'option in interfaceTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            id: 'interfaceTypes'
			        },
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.scheduleType',
			            optionFor: 'option in scheduleTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            id: 'scheduleTypes'
			        },
			        name: '<fmt:message>head.schedule</fmt:message> <fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.disabledYn',
			            optionFor: 'option in disabledYns',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            id: 'disabledYns'
			        },
			        name: '<fmt:message>igate.interface.disabledYn</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.usedYn',
			            optionFor: 'option in usedYns',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            id: 'usedYns'
			        },
			        name: '<fmt:message>igate.interface.transaction.history</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.interfaceGroup',
			        name: '<fmt:message>head.group</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'datalist',
			        mappingDataInfo: {
			            dataListId: 'privilegeList',
			            vModel: 'object.privilegeId',
			            dataListFor: 'privilege in privilegeList',
			            dataListText: 'privilege.privilegeId'
			        },
			        name: '<fmt:message>common.privilege</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.interfaceDesc',
			        name: '<fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>',
			        regExpType: 'desc'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    downloadBtn: viewer,
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
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.interfaceId',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        isPk: true
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.interfaceName',
			                        name: '<fmt:message>head.name</fmt:message>',
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privateYn',
			                            optionFor: 'option in privateYnList',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: '<fmt:message>head.private</fmt:message>',
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.interfaceType',
			                            optionFor: 'option in interfaceTypes',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: ' <fmt:message>common.type</fmt:message>',
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.metaDomain',
			                        name: '<fmt:message>igate.fieldMeta.metaDomain</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.adapterId',
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.interfaceOperation',
			                        name: '<fmt:message>igate.operation</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.scheduleType',
			                            optionFor: 'option in scheduleTypes',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>head.schedule</fmt:message>  <fmt:message>common.type</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.cronExpression',
			                        name: '<fmt:message>igate.interface.cronExpression</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.calendarId',
			                        name: '<fmt:message>igate.calendar</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.disabledYn',
			                            optionFor: 'option in disabledYns',
			    			            optionValue: 'option.pk.propertyKey',
			    			            optionText: 'option.propertyValue',
			                        },
			                        name: '<fmt:message>igate.interface.disabledYn</fmt:message>',
			                    },
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.interfaceGroup',
			                        name: '<fmt:message>head.group</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privilegeId',
			                            optionFor: 'option in privilegeIds',
			                            optionValue: 'option.privilegeId',
			                            optionText: 'option.privilegeId'
			                        },
			                        name: '<fmt:message>common.privilege</fmt:message>',
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.interfaceDesc',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        height: 200
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'basic',
			        id: 'InputOutputInfo',
			        name: '<fmt:message>head.inoutput.info</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.metaDomain',
			                        name: '<fmt:message>igate.record.metaDomain</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'textEvt',
			                        mappingDataInfo: 'object.requestRecordName',
			                        name: '<fmt:message>igate.service.request.model</fmt:message>',
			                        btnClickEvt: 'clickRecord(object.requestRecordId)'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        id: 'responseRecordId',
			                        mappingDataInfo: {
			                            selectModel: 'object.responseRecordId',
			                            optionFor: 'option in object.interfaceResponses',
			                            optionValue: 'option.pk.recordId',
			                            optionText: 'option.recordObject.recordName'
			                        },
			                        name: '<fmt:message>igate.service.response.model</fmt:message>',
			                        clickEvt: "clickRecord('responseRecordId')"
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [{ type: 'grid', id: 'ModelInfo' }]
			            }
			        ]
			    },
			    {
			        type: 'property',
			        id: 'InterfaceProperties',
			        name: '<fmt:message>head.extend.info</fmt:message>',
			        mappingDataInfo: 'interfaceProperties',
			        detailList: [
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.pk.propertyKey',
			                name: '<fmt:message>common.property.key</fmt:message>'
			            },
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.propertyValue',
			                name: '<fmt:message>common.property.value</fmt:message>'
			            },
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.propertyDesc',
			                name: '<fmt:message>head.description</fmt:message>'
			            }
			        ]
			    },
			    {
			        type: 'basic',
			        id: 'ResouceInUse',
			        name: '<fmt:message>head.resource.inuse.info</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.lockUserId',
			                        name: '<fmt:message>head.lock.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateVersion',
			                        name: '<fmt:message>head.updateVersion</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateUserId',
			                        name: '<fmt:message>head.update.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateTimestamp',
			                        name: '<fmt:message>head.update.timestamp</fmt:message>'
			                    }
			                ]
			            }
			        ]
			    }
			]);

			createPageObj.setPanelButtonList({
			    dumpBtn: editor
			});

			createPageObj.panelConstructor();

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/interface/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/interface/control',
			    dumpUrl: '/api/entity/interface/dump'
			});

			new HttpReq('/api/entity/privilege/search').read({ object: { privilegeType: 'b' }, limit: null, next: null, reverseOrder: false }, function (privilegeResult) {
			    new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Interface.InterfaceType' }, orderByKey: true }, function (interfaceTypeResult) {
			        new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Interface.ScheduleType' }, orderByKey: true }, function (scheduleTypeResult) {
			            new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Yn' }, orderByKey: true }, function (ynResult) {
			                window.vmSearch = new Vue({
			                    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			                    data: {
			                    	object: {
			                            interfaceId: null,
			                            interfaceName: null,
			                            adapterId: null,
			                            interfaceType: ' ',
			                            scheduleType: ' ',
			                            disabledYn: ' ',
			                            usedYn: ' ',
			                            privilegeId: null,
			                            interfaceGroup: null,
			                            interfaceDesc: null,
			                            pageSize: '10'
			                        },
			                        letter: {
			                            interfaceId: 0,
			                            interfaceName: 0,
			                            adapterId: 0,
			                            privilegeId: 0,
			                            interfaceGroup: 0,
			                            interfaceDesc: 0
			                        },
			                        interfaceTypes: [],
			                        scheduleTypes: [],
			                        disabledYns: [],
			                        usedYns: [],
			                        privilegeList: []
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

			                                this.object.interfaceId = null;
			                                this.object.interfaceName = null;
			                                this.object.adapterId = null;
			                                this.object.interfaceType = ' ';
			                                this.object.scheduleType = ' ';
			                                this.object.disabledYn = ' ';
			                                this.object.usedYn = ' ';
			                                this.object.privilegeId = null;
			                                this.object.interfaceGroup = null;
			                                this.object.interfaceDesc = null;

			                                this.letter.interfaceId = 0;
			                                this.letter.interfaceName = 0;
			                                this.letter.adapterId = 0;
			                                this.letter.privilegeId = 0;
			                                this.letter.interfaceGroup = 0;
			                                this.letter.interfaceDesc = 0;
			                            }

			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#interfaceTypes'), this.object.interfaceType);
			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#scheduleTypes'), this.object.scheduleType);
			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#disabledYns'), this.object.disabledYn);
			                            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#usedYns'), this.object.usedYn);
			                        },
			                        openModal: function (openModalParam, regExpInfo) {
			                            createPageObj.openModal.call(this, openModalParam, regExpInfo);
			                        },
			                        setSearchAdapterId: function (param) {
			                            this.object.adapterId = param.adapterId;
			                        }
			                    }),
			                    created: function () {
			                        this.privilegeList = privilegeResult.object;
			                        this.interfaceTypes = interfaceTypeResult.object;
			                        this.scheduleTypes = scheduleTypeResult.object;
			                        this.disabledYns = ynResult.object;
			                        this.usedYns = ynResult.object;
			                    },			                    
			                    mounted: function () {
			                        this.initSearchArea();
			                    }
			                });

			                var vmList = new Vue({
			                    el: '#' + createPageObj.getElementId('ImngListObject'),
			                    data: {
			                        makeGridObj: null,
			                        totalCnt: '0',
			                        currentCnt: '0'
			                    },
			                    methods: $.extend(true, {}, listMethodOption, {
			                        initSearchArea: function () {
			                            window.vmSearch.initSearchArea();
			                        },
			                        downloadFile: function () {
			                        	downloadFileFunc({ 
						        			url : '/api/entity/interface/download',  
						        			param : window.vmSearch.object,
						        			fileName : "<fmt:message>igate.interface</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx"
						        		});
			                        }
			                    }),
			                    mounted: function () {
			                        this.makeGridObj = getMakeGridObj();

			                        this.makeGridObj.setConfig({
			                        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
			    			            searchUrl: '/api/entity/interface/search',
			    			            totalCntUrl: '/api/entity/interface/count',
			    			    		paging: {
			    			    			isUse: true,
			    			    			side: "server",
			    			    			setCurrentCnt: function(currentCnt) {
			    			    			    this.currentCnt = currentCnt
			    			    			}.bind(this)			    			    			
			    			    		},			                        	
			                            columns: [
			                                {
			                                    name: 'interfaceId',
			                                    header: '<fmt:message>head.id</fmt:message>',
			                                    align: 'left',
			                                    width: '10%'
			                                },
			                                {
			                                    name: 'interfaceName',
			                                    header: '<fmt:message>head.name</fmt:message>',
			                                    align: 'left',
			                                    width: '20%'
			                                },
			                                {
			                                    name: 'adapterId',
			                                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                                    align: 'left',
			                                    width: '20%'
			                                },
			                                {
			                                    name: 'interfaceType',
			                                    header: '<fmt:message>common.type</fmt:message>',
			                                    align: 'center',
			                                    width: '10%',
			                                    formatter: function (info) {
			                                        var rtnValue = null;

			                                        var interfaceTypes = interfaceTypeResult.object;

			                                        for (var i = 0; i < interfaceTypes.length; i++) {
			                                            if (interfaceTypes[i].pk.propertyKey === info.value) {
			                                                rtnValue = interfaceTypes[i].propertyValue;
			                                                break;
			                                            }
			                                        }

			                                        return escapeHtml(rtnValue);
			                                    }
			                                },
			                                {
			                                    name: 'scheduleType',
			                                    header: '<fmt:message>head.schedule</fmt:message> <fmt:message>common.type</fmt:message>',
			                                    align: 'center',
			                                    width: '10%',
			                                    formatter: function (info) {
			                                        var rtnValue = null;

			                                        var scheduleTypes = scheduleTypeResult.object;

			                                        for (var i = 0; i < scheduleTypes.length; i++) {
			                                            if (scheduleTypes[i].pk.propertyKey === info.value) {
			                                                rtnValue = scheduleTypes[i].propertyValue;
			                                                break;
			                                            }
			                                        }

			                                        return escapeHtml(rtnValue);
			                                    }
			                                },
			                                {
			                                    name: 'interfaceGroup',
			                                    header: '<fmt:message>head.group</fmt:message>',
			                                    align: 'left',
			                                    width: '10%'
			                                },
			                                {
			                                    name: 'privilegeId',
			                                    header: '<fmt:message>common.privilege</fmt:message>',
			                                    align: 'left',
			                                    width: '15%'
			                                },
			                                {
			                                    name: 'interfaceDesc',
			                                    header: '<fmt:message>head.description</fmt:message>',
			                                    align: 'left',
			                                    width: '20%'
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
			                        object: {
			                            interfaceId: null,
			                            interfaceName: null,
			                            interfaceType: null,
			                            privilegeId: null,
			                            interfaceGroup: null,
			                            privateYn: null,
			                            adapterId: null,
			                            interfaceOperation: null,
			                            scheduleType: null,
			                            metaDomain: null,
			                            cronExpression: null,
			                            disabledYn: null,
			                            interfaceDesc: null
			                        },
			                        letter: {
			                            interfaceId: 0,
			                            interfaceName: 0,
			                            interfaceGroup: 0,
			                            adapterId: 0,
			                            interfaceOperation: 0,
			                            calendarId: 0,
			                            cronExpression: 0,
			                            disabledYn: 0,
			                            interfaceDesc: 0
			                        },
			                        panelMode: null,
			                        privateYnList: [
			                            { value: 'Y', name: 'Yes' },
			                            { value: 'N', name: 'No' }
			                        ],
			                        interfaceTypes: [],
			                        scheduleTypes: [],
			                        privilegeIds: [],
			                        calendarList: [],
			                        usedYns: [],
			                        disabledYns: [],
			                        interfaceProperties: []
			                    },
			                    computed: {
			                        pk: function () {
			                            return {
			                                interfaceId: this.object.interfaceId
			                            };
			                        }
			                    },
			                    created: function () {
			                        this.interfaceTypes = interfaceTypeResult.object;
			                        this.usedYns = ynResult.object;
			                        this.scheduleTypes = scheduleTypeResult.object;			                        
			                        this.privilegeIds = privilegeResult.object;
			                        this.calendarList = scheduleTypeResult.object;
			                        this.disabledYns = ynResult.object;

			                        new HttpReq('/api/page/properties').read({ pk : { propertyId: 'Property.Interface' }, orderByKey: true }, function (result) {
		                                this.interfaceProperties = result.object;
		                            }.bind(this));
			                    },
			                    methods: {
			                        loaded: function () {
			                            window.vmInterfaceProperties.interfaceProperties.forEach(
			                                function (interfaceProperty) {
			                                    var property = this.interfaceProperties.filter(function (property) {
			                                        return interfaceProperty.pk.propertyKey == property.pk.propertyKey;
			                                    })[0];
			                                    if (property) interfaceProperty['propertyDesc'] = property.propertyDesc;
			                                }.bind(this)
			                            );

			                            window.vmInputOutputInfo.object.requestRecordName = this.object.requestRecordId ? this.object.requestRecordId + ' - ' + this.object.requestRecordObject.recordName : '';
			                            window.vmInputOutputInfo.object.requestRecordId = this.object.requestRecordId;
			                            window.vmInputOutputInfo.object.metaDomain = this.object.metaDomain;
			                            window.vmInputOutputInfo.object.interfaceServices = this.object.interfaceServices;
			                            window.vmInputOutputInfo.modelModel();

			                            window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
			                            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
			                            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
			                            window.vmResouceInUse.object.updateTimestamp = changeDateFormat(this.object.updateTimestamp);
			                            window.vmResouceInUse.object.usedTimestamp = this.object.usedTimestamp;
			                        },
			                        goDetailPanel: function () {
			                            panelOpen('detail', null, function () {
			                                $('#InputOutputInfo').find('#responseRecordId').attr('readonly', false).css({
			                                    'background-color': '#f5f6fb'
			                                });

			                                if ($('a[href="#InputOutputInfo"]').hasClass('active')) {
			                                    $('a[href="#InputOutputInfo"]').removeClass('active');
			                                    $('a[href="#InputOutputInfo"]').tab('show');
			                                }
			                            });
			                        },
			                        initDetailArea: function (object) {
			                            if (object) {
			                                this.object = object;
			                            } else {
			                                this.object.interfaceId = null;
			                                this.object.interfaceName = null;
			                                this.object.interfaceType = null;
			                                this.object.privilegeId = null;
			                                this.object.privateYn = null;
			                                this.object.adapterId = null;
			                                this.object.interfaceOperation = null;
			                                this.object.scheduleType = null;
			                                this.object.metaDomain = null;
			                                this.object.cronExpression = null;
			                                this.object.disabledYn = null;
			                                this.object.interfaceDesc = null;

			                                window.vmInputOutputInfo.object.requestRecordName = null;
			                                window.vmInputOutputInfo.object.interfaceServices = [];

			                                window.vmInterfaceProperties.interfaceProperties = [];

			                                window.vmResouceInUse.object.lockUserId = null;
			                                window.vmResouceInUse.object.updateVersion = null;
			                                window.vmResouceInUse.object.updateUserId = null;
			                                window.vmResouceInUse.object.updateTimestamp = null;
			                                window.vmResouceInUse.object.usedTimestamp = null;
			                            }
			                        }
			                    }
			                });
			            });
			        });
			    });
			});

			window.vmInputOutputInfo = new Vue({
			    el: '#InputOutputInfo',
			    data: {
			        object: {
			            metaDomain: null,
			            requestRecordName: null,
			            requestRecordId: null,
			            responseRecordId: null,
			            interfaceServices: []
			        },
			        letter: {
			            metaDomain: 0,
			            requestRecordName: 0
			        }
			    },
			    methods: {
			        modelModel: function () {
			            $('a[href="#InputOutputInfo"]')
			                .off()
			                .on(
			                    'shown.bs.tab',
			                    function (e) {
			                        if (vmMain.object.interfaceResponses) {
			                            $('#InputOutputInfo').find('#responseRecordId').empty();

			                            vmMain.object.interfaceResponses.forEach(function (responseObj) {
			                                $('#InputOutputInfo')
			                                    .find('#responseRecordId')
			                                    .append($('<option value="' + responseObj.pk.recordId + '">' + (responseObj.recordObject.recordId + ' - ' + responseObj.recordObject.recordName) + '</option>'));
			                            });
			                        }

			                        var bodyHeight = 150;

			                        if ($('.panel-body').height() > 350) bodyHeight = $('.panel-body').height() - 50;

			                        $('#ModelInfo').empty();

			                        interfaceGrid = new tui.Grid({
			                            el: document.getElementById('ModelInfo'),
			                            data: this.object.interfaceServices,
			                            bodyHeight: bodyHeight,
			                            onGridMounted: function () {
			                                $('#ModelInfo').find('.tui-grid-column-resize-handle').removeAttr('title');
			                            },
			                            columnOptions: {
			                                resizable: true
			                            },
			                            columns: [
			                                {
			                                    name: 'pk',
			                                    header: '<fmt:message>igate.service</fmt:message>',
			                                    formatter: function (value) {
			                                        return '<span class="underlineTxt">' + escapeHtml(value.value.serviceId) + '</span>';
			                                    }
			                                },
			                                {
			                                    name: 'requestMappingObject',
			                                    header: '<fmt:message>igate.interface.requestMapping</fmt:message>',
			                                    formatter: function (value) {
			                                        return value.value ? '<span class="underlineTxt">' + escapeHtml(value.value.mappingId) + '</span><br>(' + escapeHtml(value.value.mappingName) + ')' : '';
			                                    }
			                                },
			                                {
			                                    name: 'responseMappingObject',
			                                    header: '<fmt:message>igate.interface.responseMapping</fmt:message>',
			                                    formatter: function (value) {
			                                        return value.value ? '<span class="underlineTxt">' + escapeHtml(value.value.mappingId) + '</span><br>(' + escapeHtml(value.value.mappingName) + ')' : '';
			                                    }
			                                },
			                                {
			                                    name: 'cronExpression',
			                                    header: '<fmt:message>igate.interface.cronExpression</fmt:message>',
			                                    escapeHTML: true
			                                },
			                                {
			                                    name: 'calendarId',
			                                    header: '<fmt:message>igate.calendar</fmt:message>',
			                                    formatter: function (value) {
			                                        var selectDiv = "<select class='panel-form-control' name='calendarId' style='width: 100%; text-overflow: ellipsis;'>";
			                                        selectDiv += "		<option value=''></option>";

			                                        vmMain.calendarList.forEach(function (option) {
			                                            selectDiv += "<option value='" + option.calendarId + "' " + (option.calendarId == value.value ? 'selected' : '') + '>' + escapeHtml(option.calendarId) + '</option>';
			                                        });

			                                        selectDiv += '</select>';

			                                        return selectDiv;
			                                    }
			                                },
			                                {
			                                    name: 'conditionExpression',
			                                    header: '<fmt:message>igate.interface.conditionExpression</fmt:message>',
			                                    escapeHTML: true
			                                }
			                            ]
			                        });

			                        interfaceGrid.on('click', function (ev) {
			                            var row = interfaceGrid.getRow(ev.rowKey);
			                            var menu = null;
			                            var loadParam = {};

			                            switch (interfaceGrid.getFocusedCell().columnName) {
			                                case 'requestMappingObject':
			                                    menu = 'mapping';
			                                    loadParam = {
			                                        itemName: 'selectedRowMapping',
			                                        selectedMenuPathIdList: ['100000', '101000', '101020'],
			                                        param: {
			                                            mappingId: row.requestMappingId,
			                                            mappingType: row.requestMappingObject.mappingType
			                                        }
			                                    };
			                                    break;
			                                case 'responseMappingObject':
			                                    menu = 'mapping';
			                                    loadParam = {
			                                        itemName: 'selectedRowMapping',
			                                        selectedMenuPathIdList: ['100000', '101000', '101020'],
			                                        param: {
			                                            mappingId: row.responseMappingId,
			                                            mappingType: row.responseMappingObject.mappingType
			                                        }
			                                    };
			                                    break;
			                                case 'pk':
			                                    menu = 'service';
			                                    loadParam = {
			                                        itemName: 'selectedRowService',
			                                        selectedMenuPathIdList: ['100000', '101000', '101030'],
			                                        param: {
			                                            serviceId: row.pk.serviceId
			                                        }
			                                    };
			                                    break;
			                            }

			                            if (!menu) return;

			                            localStorage.setItem(loadParam.itemName, JSON.stringify(loadParam.param));
			                            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(loadParam.selectedMenuPathIdList));
			                            window.open(location.href);
			                        });
			                    }.bind(this)
			                );
			        },
			        clickRecord: function (param) {
			            if ('responseRecordId' == param) param = $('#InputOutputInfo').find('#responseRecordId option:selected').val();

			            if (!param) return;

			            localStorage.setItem('selectedMessageModel', JSON.stringify({ recordId: param }));
			            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '101000', '101010']));

			            window.open(location.href);
			        }
			    }
			});

			window.vmInterfaceProperties = new Vue({
			    el: '#InterfaceProperties',
			    data: {
			        interfaceProperties: []
			    }
			});

			window.vmResouceInUse = new Vue({
			    el: '#ResouceInUse',
			    data: {
			        object: {
			            lockUserId: null,
			            updateVersion: null,
			            updateUserId: null,
			            updateTimestamp: null,
			            usedTimestamp: null
			        },
			        letter: {
			            lockUserId: 0,
			            updateVersion: 0,
			            updateUserId: 0,
			            updateTimestamp: 0,
			            usedTimestamp: 0
			        }
			    }
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
	</script>
</body>
</html>