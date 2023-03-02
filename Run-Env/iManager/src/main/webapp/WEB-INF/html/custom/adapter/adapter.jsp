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
	<div id="adapter" data-ready>
		<sec:authorize var="hasAdapterViewer" access="hasRole('AdapterViewer')"></sec:authorize>
		<sec:authorize var="hasAdapterEditor" access="hasRole('AdapterEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
		
		<%@ include file="/WEB-INF/html/custom/adapter/detail.jsp"%>
	</div>
	<script>
		document.querySelector('#adapter').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasAdapterViewer}';
			var editor = 'true' == '${hasAdapterEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('adapter');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    { type: 'text', mappingDataInfo: 'object.adapterId', name: '<fmt:message>head.id</fmt:message>', placeholder: '<fmt:message>head.searchId</fmt:message>', regExpType: 'searchId' },
			    { type: 'text', mappingDataInfo: 'object.adapterName', name: '<fmt:message>head.name</fmt:message>', placeholder: '<fmt:message>head.searchName</fmt:message>', regExpType: 'name' },
			    {
			        type: 'select',
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'adapterTypeList',
			            selectModel: 'object.adapterType',
			            optionFor: 'option in adapterTypeList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>head.queue</fmt:message> <fmt:message>head.mode</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'queueModeList',
			            selectModel: 'object.queueMode',
			            optionFor: 'option in queueModeList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    { type: 'text', mappingDataInfo: 'object.adapterDesc', name: '<fmt:message>head.description</fmt:message>', placeholder: '<fmt:message>head.searchComment</fmt:message>', regExpType: 'desc' }
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
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: 'object.adapterId',
			                        isPk: true,
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        name: '<fmt:message>head.name</fmt:message>',
			                        mappingDataInfo: 'object.adapterName',
			                        regExpType: 'name'
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>common.type</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'adapterTypeList',
			                            selectModel: 'object.adapterType',
			                            optionFor: 'option in adapterTypeList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue',
			                            changeEvt: 'changeAdapterType'
			                        },
			                        warning: '<fmt:message>igate.connector.alert.type.empty</fmt:message>'
			                    },
			                    {
			                        type: 'datalist',
			                        name: '<fmt:message>igate.adapter.charset</fmt:message>',
			                        mappingDataInfo: {
			                            dataListId: 'adapterChartsetList',
			                            vModel: 'object.charset',
			                            dataListFor: 'option in adapterChartsetList',
			                            dataListText: 'option.propertyValue'
			                        },
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.adapter.endian</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'adapterEndianList',
			                            selectModel: 'object.endian',
			                            optionFor: 'option in adapterEndianList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.adapter.queue.mode</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'adapterQueueModeList',
			                            selectModel: 'object.queueMode',
			                            optionFor: 'option in adapterQueueModeList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>head.queue</fmt:message> <fmt:message>head.log.level</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'queueLogLevelList',
			                            selectModel: 'object.queueLogLevel',
			                            optionFor: 'option in queueLogLevelList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.adapter.telegramHandler</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/activityModal.html',
			                            modalTitle: '<fmt:message>igate.activity</fmt:message>',
			                            vModel: 'object.telegramHandler',
			                            callBackFuncName: 'setSearchTelegramHandlerId'
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.adapter.structure.request</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/recordModal.html',
			                            modalTitle: '<fmt:message>igate.record</fmt:message>',
			                            vModel: 'object.requestStructure',
			                            callBackFuncName: 'setSearchRequestStructureId'
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.adapter.structure.response</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/recordModal.html',
			                            modalTitle: '<fmt:message>igate.record</fmt:message>',
			                            vModel: 'object.responseStructure',
			                            callBackFuncName: 'setSearchResponseStructureId'
			                        }
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        mappingDataInfo: 'object.adapterDesc',
			                        height: 200,
			                        regExpType: 'desc'
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'property',
			        id: 'AdapterOperations',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>igate.operation</fmt:message>',
			        addRowFunc: 'addOperation',
			        removeRowFunc: 'removeOperation(index)',
			        mappingDataInfo: 'adapterOperations',
			        detailList: [
			            {
			                type: 'select',
			                name: '<fmt:message>igate.adapter.event</fmt:message>',
			                mappingDataInfo: {
			                    id: 'adapterEventList',
			                    selectModel: 'elm.pk.adapterEvent',
			                    optionFor: 'option in adapterEventList',
			                    optionValue: 'option.pk.propertyKey',
			                    optionText: 'option.propertyValue'
			                },
			                changeEvt: 'adapterEventChange(elm.pk.adapterEvent, index)'
			            },
			            {
			                type: 'search',
			                name: '<fmt:message>igate.operation</fmt:message>',
			                mappingDataInfo: {
			                    url: '/modal/operationModal.html',
			                    modalTitle: '<fmt:message>igate.operation</fmt:message>',
			                    vModel: 'elm.operationId',
			                    callBackFuncName: 'setOperationId'
			                },
			            },
			            {
			                type: 'customModal',
			                name: '<fmt:message>igate.adapter.cronExpression</fmt:message>',
			                mappingDataInfo: {
			                    modalTitle: '<fmt:message>igate.adapter.cronExpression</fmt:message>',
			                    vModel: 'elm.cronExpression',
			                    bodyHtml: '#cronExpression'
			                },
			                regExpType: 'cron'
			            },
			            {
			                type: 'search',
			                name: '<fmt:message>igate.calendar</fmt:message>',
			                mappingDataInfo: {
			                    url: '/modal/calendarModal.html',
			                    modalTitle: '<fmt:message>igate.calendar</fmt:message>',
			                    vModel: 'elm.calendarId',
			                    callBackFuncName: 'setCalendarId'
			                }
			            },
			            {
			                type: 'select',
			                name: '<fmt:message>igate.adapter.disabledYn</fmt:message>',
			                mappingDataInfo: {
			                    id: 'adapterDisabledYnList',
			                    selectModel: 'elm.disabledYn',
			                    optionFor: 'option in adapterDisabledYnList',
			                    optionValue: 'option.pk.propertyKey',
			                    optionText: 'option.propertyValue'
			                }
			            }
			        ]
			    },
			    {
			        type: 'custom',
			        id: 'AdapterProperties',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.property</fmt:message>',
			        getDetailArea: function () {
			            var detailHtml = '';

			            detailHtml += '<div class="propertyTab" style="width: 100%">';
			            detailHtml += '    <div class="form-table form-table-responsive">';
			            detailHtml += '        <div class="form-table-head">';
			            detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="addProperty();"><i class="icon-plus-circle"></i></button>';
			            detailHtml += '            <label class="col"><fmt:message>common.property.key</fmt:message></label>';
			            detailHtml += '            <label class="col"><fmt:message>common.property.value</fmt:message></label>';
			            detailHtml += '            <label class="col"><fmt:message>head.description</fmt:message></label>';
			            detailHtml += '        </div>';			            
			            detailHtml += '        <div class="form-table-wrap">';
			            detailHtml += '        	   <div class="form-table-body" v-for="(elm, index) in adapterProperties">';  
			            detailHtml += '                <button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require"><i class="icon-star"></i></button>';
			            detailHtml += '                <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="removeProperty(index);" v-else><i class="icon-minus-circle"></i></button>';
			            detailHtml += '                <div class="col">';
			            detailHtml += '                    <div v-if="elm.require" style="width: 100%;">';
			            detailHtml += '                        <input type="text" class="form-control readonly" list="propertyKeys" v-model="elm.pk.propertyKey" readonly>';
			            detailHtml += '                        <datalist id="propertyKeys">';
			            detailHtml += '                            <option v-for="option in propertyKeys" :value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>';
			            detailHtml += '                        </datalist>';
			            detailHtml += '                    </div>';
			            detailHtml += '                    <div class="detail-content-regExp" v-else>';
			            detailHtml += '                        <input type="text" class="regExp-text view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" :maxlength="maxLengthObj.id" @input="inputEvt(elm, \'pk.propertyKey\')" @change="changePropertyKey(index)">';
			            detailHtml += '                        <datalist id="propertyKeys">';
			            detailHtml += '                            <option v-for="option in propertyKeys" :value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>';
			            detailHtml += '                        </datalist>';
			            detailHtml += '                        <span class="letterLength"> ( {{ elm.letter.pk.propertyKey }} / {{ maxLengthObj.id }} ) </span>';
			            detailHtml += '                    </div>';
			            detailHtml += '                </div>';
			            detailHtml += '                <div class="col">';
			            detailHtml += '                    <div class="detail-content-regExp">';
			            detailHtml += '                        <input :type="elm.cipher? \'password\' : \'text\'" class="regExp-text view-disabled" v-model="elm.propertyValue" :maxlength="maxLengthObj.value" @input="inputEvt(elm, \'propertyValue\')">';
			            detailHtml += '                        <span class="letterLength"> ( {{ elm.letter.propertyValue }} / {{ maxLengthObj.value }} ) </span>';
			            detailHtml += '                    </div>';
			            detailHtml += '                </div>';
			            detailHtml += '                <div class="col">';
			            detailHtml += '                    <input type="text" class="form-control readonly" v-model="elm.propertyDesc" readonly>';
			            detailHtml += '                </div>';
			            detailHtml += '            </div>';
			            detailHtml += '        </div>';
			            detailHtml += '    </div>';
			            detailHtml += '</div>';			            

			            return detailHtml;
			        }
			    },
			    {
			        type: 'custom',
			        id: 'Connectors',
			        name: '<fmt:message>igate.connector</fmt:message>',
			        getDetailArea: function () {
			            var detailHtml = '';

			            detailHtml += '    <div class="col-lg-6">';
			            detailHtml += '        <div class="form-group">';
			            detailHtml += '            <label class="control-label">';
			            detailHtml += '                <span><fmt:message>igate.connector</fmt:message> ID</span>';
			            detailHtml += '            </label>';
			            detailHtml += '        </div>';
			            detailHtml += '        <div class="form-group" v-for="index in connectors">';
			            detailHtml += '            <div class="input-group">';
			            detailHtml += '                <input type="text" class="form-control view-disabled readonly disabled" v-model="index" disabled readonly>';
			            detailHtml += '            </div>';
			            detailHtml += '        </div>';
			            detailHtml += '    </div>';

			            return $(detailHtml);
			        }
			    },
			    {
			        type: 'custom',
			        id: 'AdapterQueueDeploies',
			        name: '<fmt:message>igate.adapter.queue.deploies</fmt:message>',
			        getDetailArea: function () {
			            var detailHtml = '';

			            detailHtml += '<ul class="list-group" style="width: 100%;">';
			            detailHtml += '    <li class="list-group-item" v-for="(elm, index) in instanceList">';
			            detailHtml += '        <label class="custom-control custom-checkbox">';
			            detailHtml += '            <input type="checkbox" class="custom-control-input view-disabled" v-model="adapterSubDeploies[index]" @change="push(elm.instanceId, $event)">';
			            detailHtml += '            <span class="custom-control-label">{{elm.instanceId}}</span>';
			            detailHtml += '        </label>';
			            detailHtml += '    </li>';
			            detailHtml += '</ul>';

			            return detailHtml;
			        }
			    }
			]);

			createPageObj.setPanelButtonList({
			    guideBtn: editor,
			    externalGuideBtn: editor,
			    startBtn: editor,
			    stopBtn: editor,
			    dumpBtn: editor,
			    removeBtn: editor,
			    goModBtn: editor,
			    saveBtn: editor,
			    updateBtn: editor,
			    goAddBtn: editor
			});

			createPageObj.panelConstructor();

			SaveImngObj.setConfig({
			    objectUri: '/igate/adapter/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/adapter/control.json'
			});

	        new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Adapter.Type', orderByKey: true }, function (adapterListResult) {
	        	new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Adapter.Queuemode', orderByKey: true }, function (queueModeListResult) {
	        		window.vmSearch = new Vue({
					    el: '#' + createPageObj.getElementId('ImngSearchObject'),
					    data: {
					        pageSize: '10',
					        adapterTypeList: [],
					        queueModeList: [],
					        letter: {
					            adapterId: 0,
					            adapterName: 0,
					            adapterDesc: 0
					        },
					        object: {
					            adapterId: null,
					            adapterName: null,
					            adapterType: ' ',
					            queueMode: ' ',
					            adapterDesc: null
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
					                    new HttpReq('/igate/adapter/rowCount.json').read(this.object, function (result) {
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
					                this.object.adapterId = null;
					                this.object.adapterName = null;
					                this.object.adapterType = ' ';
					                this.object.queueMode = ' ';
					                this.object.adapterDesc = null;
	
					                this.letter.adapterId = 0;
					                this.letter.adapterName = 0;
					                this.letter.adapterDesc = 0;
					            }
	
					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#adapterTypeList'), this.object.adapterType);
					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#queueModeList'), this.object.queueMode);
					        }
					    }),
					    created: function () {
					    	this.adapterTypeList = adapterListResult.object;
					    	this.queueModeList = queueModeListResult.object;
					    },				    
					    mounted: function () {
					    	this.initSearchArea();				    	
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
					        }
					    }),
					    mounted: function () {
					        this.makeGridObj = getMakeGridObj();
	
					        this.makeGridObj.setConfig({
					            elementId: createPageObj.getElementId('ImngSearchGrid'),
					            onClick: function (loadParam, ev) {
					                SearchImngObj.clicked({ adapterId: loadParam.adapterId });
					            },
					            searchUri: '/igate/adapter/search.json',
					            viewMode: '${viewMode}',
					            popupResponse: '${popupResponse}',
					            popupResponsePosition: '${popupResponsePosition}',
					            columns: [
					                {
					                    name: 'adapterId',
					                    header: '<fmt:message>head.id</fmt:message>',
					                    width: '20%'
					                },
					                {
					                    name: 'adapterName',
					                    header: '<fmt:message>head.name</fmt:message>',
					                    width: '30%'
					                },
					                {
					                    name: 'adapterType',
					                    header: '<fmt:message>common.type</fmt:message>',
					                    align: 'center',
					                    width: '10%',
					                    formatter: function (info) {
			                                var findAdapterType = window.vmSearch.adapterTypeList.find(function (typeInfo) {
			                                    return typeInfo.pk.propertyKey === info.row.adapterType;
			                                });

			                                return findAdapterType ? escapeHtml(findAdapterType.propertyValue) : '';
			                            }
					                },
					                {
					                    name: 'queueMode',
					                    header: '<fmt:message>head.queue</fmt:message> <fmt:message>head.mode</fmt:message>',
					                    align: 'center',
					                    width: '10%',
					                    formatter: function (info) {
			                                var findQueueMode = window.vmSearch.queueModeList.find(function (queueModeinfo) {
			                                    return queueModeinfo.pk.propertyKey === info.row.queueMode;
			                                });

			                                return findQueueMode ? escapeHtml(findQueueMode.propertyValue) : '';
			                            }
					                },
					                {
					                    name: 'adapterDesc',
					                    header: '<fmt:message>head.description</fmt:message>',
					                    width: '30%'
					                }
					            ]
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
					        adapterTypeList: [],
					        adapterChartsetList: [],
					        adapterEndianList: [],
					        adapterQueueModeList: [],
					        queueLogLevelList: [],
					        letter: {
					            adapterId: 0,
					            adapterName: 0,
					            adapterDesc: 0
					        },
					        object: {
					            adapterId: null,
					            adapterName: null,
					            adapterType: ' ',
					            charset: ' ',
					            endian: ' ',
					            queueMode: ' ',
					            queueLogLevel: ' ',
					            telegramHandler: null,
					            requestStructure: null,
					            responseStructure: null,
					            adapterDesc: null,
					            adapterOperations: [],
					            adapterProperties: [],
					            adapterQueueDeploies: []
					        },
					        openWindows: [],
					        panelMode: null
					    },
					    computed: {
					        pk: function () {
					            return {
					                adapterId: this.object.adapterId,
					                adapterName: this.object.adapterName
					            };
					        }
					    },
					    watch: {
					        panelMode: function () {
					        	if (this.panelMode !== 'add') $('#panel').find('.warningLabel').hide();
		
					            window.vmAdapterOperations.operationElmHide();
					        }
					    },
					    methods: {
					        changeAdapterType: function () {
					        	// telegram handler
					            new HttpReq('/common/property/properties.json').read({ propertyId: 'Telegram.Adapter.' + this.object.adapterType, orderByKey: true },
					                function (telegramHandlerResult) {
					                    if ('ok' !== telegramHandlerResult.result) throw telegramHandlerResult;
		
					                    this.object.telegramHandler = 0 < telegramHandlerResult.object.length ? telegramHandlerResult.object[0].propertyValue : '';
					                }.bind(this)
					            );
		
					            // charset
					            new HttpReq('/common/property/properties.json').read({ propertyId: 'Charset.Adapter.' + this.object.adapterType, orderByKey: true },
					                function (charsetResult) {
					                    if ('ok' !== charsetResult.result) throw charsetResult;
		
					                    this.object.charset = 0 < charsetResult.object.length ? charsetResult.object[0].propertyValue : '';
					                }.bind(this)
					            );
					            
					            window.vmAdapterProperties.changeAdapterType();
					        },
					        inputEvt: function (info) {
					            setLengthCnt.call(this, info);
					        },
					        goDetailPanel: function () {
					            panelOpen('detail');
					        },
					        initDetailArea: function (object) {
					            if (object) {
					                this.object = object;
					            } else {
					                this.object.adapterId = null;
					                this.object.adapterName = null;
					                this.object.adapterType = ' ';
					                this.object.charset = ' ';
					                this.object.endian = ' ';
					                this.object.queueMode = ' ';
					                this.object.queueLogLevel = ' ';
					                this.object.telegramHandler = null;
					                this.object.requestStructure = null;
					                this.object.responseStructure = null;
					                this.object.adapterDesc = null;
		
					                this.letter.adapterId = 0;
					                this.letter.adapterName = 0;
					                this.letter.adapterDesc = 0;
		
					                window.vmAdapterOperations.adapterOperations = [];
					                window.vmAdapterProperties.adapterProperties = [];
					                window.vmAdapterQueueDeploies.adapterSubDeploies = [];
					                vmConnectors.connectors = [];
					            }
					        },
					        openModal: function (openModalParam, regExpInfo) {
					            if ('/modal/activityModal.html' == openModalParam.url) {
					                openModalParam.modalParam = { activityType: 'H' };
					            }
		
					            createPageObj.openModal.call(this, openModalParam, regExpInfo);
					        },
					        setSearchTelegramHandlerId: function (param) {
					            this.object.telegramHandler = param.activityId;
					        },
					        setSearchRequestStructureId: function (param) {
					            this.object.requestStructure = param.recordId;
					        },
					        setSearchResponseStructureId: function (param) {
					            this.object.responseStructure = param.recordId;
					        },
					        loaded: function () {
					        	//property
					        	window.vmAdapterProperties.adapterProperties = this.object.adapterProperties;
					        	
				                if(this.object.adapterType) window.vmAdapterProperties.setPropertyKeys();
					        	
					            //deploies
					            var deploies = window.vmAdapterQueueDeploies;
		
					            deploies.adapterSubDeploies = [];
					            deploies.instanceList.forEach(function (element) {
					                var value = -1;
		
					                for (var i = 0; i < deploies.adapterQueueDeploies.length; i++) {
					                    if (deploies.adapterQueueDeploies[i].pk.instanceId === element.instanceId) {
					                        value = i;
					                        break;
					                    }
					                }
		
					                if (value != -1) deploies.adapterSubDeploies.push(true);
					                else deploies.adapterSubDeploies.push(false);
					            });
		
					            // connectors
					            vmConnectors.connectors = this.object.connectors;
					            
					            //letter
				                this.letter.adapterId = this.object.adapterId.length;
				                this.letter.adapterName = this.object.adapterName ? this.object.adapterName.length : 0;
				                this.letter.adapterDesc = this.object.adapterDesc ? this.object.adapterDesc.length : 0;
					        }
					    },
					    created: function () {
					    	this.adapterTypeList = adapterListResult.object;
					    	this.adapterQueueModeList = queueModeListResult.object;
	
					        new HttpReq('/common/property/properties.json').read(
					            { propertyId: 'Property.Adapter.Chartset', orderByKey: true },
					            function (result) {
					                this.adapterChartsetList = result.object;
					            }.bind(this)
					        );
					        new HttpReq('/common/property/properties.json').read(
					            { propertyId: 'List.Adapter.Endian', orderByKey: true },
					            function (result) {
					                this.adapterEndianList = result.object;
					            }.bind(this)
					        );
					        new HttpReq('/common/property/properties.json').read(
					            { propertyId: 'List.LogLevel', orderByKey: true },
					            function (result) {
					                this.queueLogLevelList = result.object;
					            }.bind(this)
					        );
					    }
					});
	
					window.vmAdapterOperations = new Vue({
					    el: '#AdapterOperations',
					    data: {
					        viewMode: 'Open',
					        adapterOperations: [],
					        adapterEventList: [],
					        adapterDisabledYnList: [],
					        selectedIdx: null,
					        isDisabled: false,
					        evtNameArr: ['request.extract', 'process.open', 'process.close', 'process.pause', 'process.resume']
					    },
					    methods: {
					        addOperation: function () {
					            this.adapterOperations.push({
					                operationId: null,
					                cronExpression: null,
					                calendarId: null,
					                disabledYn: 'N',
					                pk: {}
					            });
		
					            window.vmAdapterOperations.operationElmHide();
					        },
					        removeOperation: function (index) {
					            this.adapterOperations = this.adapterOperations.slice(0, index).concat(this.adapterOperations.slice(index + 1));
		
					            window.vmAdapterOperations.operationElmHide();
					        },
					        openModal: function (openModalParam, selectedIdx) {
					            if ('/modal/operationModal.html' == openModalParam.url) {
					                openModalParam.modalParam = { operationType: 'A' };
					            }
		
					            this.selectedIdx = selectedIdx;
		
					            createPageObj.openModal.call(this, openModalParam);
					        },
					        adapterEventChange: function (param, idx) {
					            var rtnObj = this.adapterOperations[idx];
		
					            rtnObj.isDisabled = -1 === this.evtNameArr.indexOf(rtnObj.pk.adapterEvent) ? true : false;
		
					            if (rtnObj.isDisabled) {
					                rtnObj.cronExpression = null;
					                rtnObj.calendarId = null;
					                rtnObj.disabledYn = 'N';
					            }
		
					            this.adapterOperations[idx] = rtnObj;
		
					            window.vmAdapterOperations.operationElmHide();
					        },
					        setOperationId: function (param) {
					            this.adapterOperations[this.selectedIdx].operationId = param.operationId;
					        },
					        operationClickEvt: function (param) {
					            if (!param) return;
		
					            localStorage.setItem('selectedOperation', JSON.stringify({ operationId: param }));
					            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '102000', '102070']));
		
					            window.open(location.href);
					        },
					        setCalendarId: function (param) {
					            this.adapterOperations[this.selectedIdx].calendarId = param.calendarId;
					        },
					        operationElmHide: function () {
					            this.$nextTick(function () {
					                $('#AdapterOperations')
					                    .find('.form-table-wrap')
					                    .find('.form-table-body')
					                    .each(
					                        function (index, bodyElement) {
					                            var findEvtName = this.evtNameArr.find(function (evtName) {
					                                return evtName === $(bodyElement).find('.col').eq(0).find('select').val();
					                            });
		
					                            for (var i = 2; i < 5; i++) {
					                                $(bodyElement).find('.col').eq(i).children()[findEvtName ? 'show' : 'hide']();
					                            }
					                        }.bind(this)
					                    );
					            });
					        },
					        openCustomModal: function (modalInfo, modalIdx) {
					            var astro = '*';
					            var slash = '/';
					            var hyphen = '-';
					            var question = '?';
					            var comma = ',';
					            var hash = '#';
		
					            var cron = null;
					            var regexr =
					                /^\s*($|#|\w+\s*=|(\?|\*|(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?(?:,(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?)*)\s(\?|\*|(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?(?:,(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?)*)\s(\?|\*|(?:[01]?\d|2[0-3])(?:(?:-|\/|\,)(?:[01]?\d|2[0-3]))?(?:,(?:[01]?\d|2[0-3])(?:(?:-|\/|\,)(?:[01]?\d|2[0-3]))?)*)\s(\?|\*|(?:0?[1-9]|[12]\d|3[01])(?:(?:-|\/|\,)(?:0?[1-9]|[12]\d|3[01]))?(?:,(?:0?[1-9]|[12]\d|3[01])(?:(?:-|\/|\,)(?:0?[1-9]|[12]\d|3[01]))?)*)\s(\?|\*|(?:[1-9]|1[012])(?:(?:-|\/|\,)(?:[1-9]|1[012]))?(?:L|W)?(?:,(?:[1-9]|1[012])(?:(?:-|\/|\,)(?:[1-9]|1[012]))?(?:L|W)?)*|\?|\*|(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(?:(?:-)(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))?(?:,(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(?:(?:-)(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))?)*)\s(\?|\*|(?:[0-6])(?:(?:-|\/|\,|#)(?:[0-6]))?(?:,(?:[0-6])(?:(?:-|\/|\,|#)(?:[0-6]))?)*|\?|\*|(?:MON|TUE|WED|THU|FRI|SAT|SUN)(?:(?:-)(?:MON|TUE|WED|THU|FRI|SAT|SUN))?(?:,(?:MON|TUE|WED|THU|FRI|SAT|SUN)(?:(?:-)(?:MON|TUE|WED|THU|FRI|SAT|SUN))?)*))$/i;
		
					            if (this.adapterOperations[modalIdx].cronExpression) {
					                cron = this.adapterOperations[modalIdx].cronExpression.split(' ');
		
					                if (!regexr.test(this.adapterOperations[modalIdx].cronExpression) || cron[3] == cron[5]) {
					                    window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                    return;
					                }
					            } else {
					                cron = '* * * * * ?'.split(' ');
					            }
		
					            var cronResults;
					            var cloneElement = $('#cronExpression').clone();
		
					            cloneElement.find('#cronVue').attr('id', 'cronVueJob');
					            cloneElement.find('#gridDiv').attr('id', 'gridDivJob');
		
					            cloneElement.find('.tab-pane').each(function (index, element) {
					                $(element).attr({ id: $(element).attr('id') + 'JobDiv' });
					            });
		
					            modalInfo.bodyHtml = cloneElement.html();
		
					            modalInfo.shownCallBackFunc = function () {
					                // Cron Expression Shown Modal
		
					                cronResults = new Vue({
					                    el: '#cronVueJob',
					                    created: function () {
					                        // 사용자 외부 입력값에 따른 모달 라디오 버튼 설정
					                        if (cron[0].indexOf(comma) != -1) {
					                            this.secondCheckValue = 4;
		
					                            this.secondResult5 = cron[0];
					                        } else if (cron[0].indexOf(astro) != -1) {
					                            this.secondCheckValue = 1;
					                        } else if (cron[0].indexOf(slash) != -1) {
					                            this.secondCheckValue = 2;
		
					                            secondSelect = cron[0].split(slash);
					                            this.secondResult1 = secondSelect[0];
					                            this.secondResult2 = secondSelect[1];
					                        } else if (cron[0].indexOf(hyphen) != -1) {
					                            this.secondCheckValue = 3;
		
					                            secondSelect = cron[0].split(hyphen);
					                            this.secondResult3 = secondSelect[0];
					                            this.secondResult4 = secondSelect[1];
					                        } else {
					                            this.secondCheckValue = 4;
		
					                            this.secondResult5 = cron[0];
					                        }
		
					                        if (cron[1].indexOf(comma) != -1) {
					                            this.minuteCheckValue = 4;
		
					                            this.minuteResult5 = cron[1];
					                        } else if (cron[1].indexOf(astro) != -1) {
					                            this.minuteCheckValue = 1;
					                        } else if (cron[1].indexOf(slash) != -1) {
					                            this.minuteCheckValue = 2;
		
					                            minuteSelect = cron[1].split(slash);
					                            this.minuteResult1 = minuteSelect[0];
					                            this.minuteResult2 = minuteSelect[1];
					                        } else if (cron[1].indexOf(hyphen) != -1) {
					                            this.minuteCheckValue = 3;
		
					                            minuteSelect = cron[1].split(hyphen);
					                            this.minuteResult3 = minuteSelect[0];
					                            this.minuteResult4 = minuteSelect[1];
					                        } else {
					                            this.minuteCheckValue = 4;
		
					                            this.minuteResult5 = cron[1];
					                        }
		
					                        if (cron[2].indexOf(comma) != -1) {
					                            this.hourCheckValue = 4;
		
					                            this.hourResult5 = cron[2];
					                        } else if (cron[2].indexOf(astro) != -1) {
					                            this.hourCheckValue = 1;
					                        } else if (cron[2].indexOf(slash) != -1) {
					                            this.hourCheckValue = 2;
		
					                            hourSelect = cron[2].split(slash);
					                            this.hourResult1 = hourSelect[0];
					                            this.hourResult2 = hourSelect[1];
					                        } else if (cron[2].indexOf(hyphen) != -1) {
					                            this.hourCheckValue = 3;
		
					                            hourSelect = cron[2].split(hyphen);
					                            this.hourResult3 = hourSelect[0];
					                            this.hourResult4 = hourSelect[1];
					                        } else {
					                            this.hourCheckValue = 4;
		
					                            this.hourResult5 = cron[2];
					                        }
		
					                        if (cron[3].indexOf(comma) != -1) {
					                            this.dayCheckValue = 3;
		
					                            this.dayResult1 = cron[3];
					                        } else if (cron[3].indexOf(astro) != -1) {
					                            this.dayCheckValue = 1;
					                        } else if (cron[3].indexOf(question) != -1) {
					                            this.dayCheckValue = 2;
					                        } else {
					                            this.dayCheckValue = 3;
		
					                            this.dayResult1 = cron[3];
					                        }
		
					                        if (cron[4].indexOf(comma) != -1) {
					                            this.monthCheckValue = 4;
		
					                            this.monthResult5 = cron[4];
					                        } else if (cron[4].indexOf(astro) != -1) {
					                            this.monthCheckValue = 1;
					                        } else if (cron[4].indexOf(slash) != -1) {
					                            this.monthCheckValue = 2;
		
					                            monthSelect = cron[4].split(slash);
					                            this.monthResult1 = monthSelect[0];
					                            this.monthResult2 = monthSelect[1];
					                        } else if (cron[4].indexOf(hyphen) != -1) {
					                            this.monthCheckValue = 3;
		
					                            monthSelect = cron[4].split(hyphen);
					                            this.monthResult3 = monthSelect[0];
					                            this.monthResult4 = monthSelect[1];
					                        } else {
					                            this.monthCheckValue = 4;
		
					                            this.monthResult5 = cron[4];
					                        }
		
					                        if (cron[5].indexOf(question) != -1) {
					                            this.weekCheckValue = 1;
					                        } else if (cron[5].indexOf(astro) != -1 || cron[5].indexOf(slash) != -1 || cron[5].indexOf(hyphen) != -1 || cron[5].indexOf(comma) != -1 || cron[5].indexOf(hash) != -1) {
					                            this.weekCheckValue = 3;
		
					                            this.weekResult2 = cron[5];
					                        } else {
					                            this.weekCheckValue = 2;
		
					                            if (cron[5] === '0' || cron[5] === 'SUN' || cron[5] === 'sun' || cron[5] === 'Sun') this.weekResult1 = 'Sun';
					                            else if (cron[5] === '1' || cron[5] === 'MON' || cron[5] === 'mon' || cron[5] === 'Mon') this.weekResult1 = 'Mon';
					                            else if (cron[5] === '2' || cron[5] === 'TUE' || cron[5] === 'tue' || cron[5] === 'Tue') this.weekResult1 = 'Tue';
					                            else if (cron[5] === '3' || cron[5] === 'WED' || cron[5] === 'wed' || cron[5] === 'Wed') this.weekResult1 = 'Wed';
					                            else if (cron[5] === '4' || cron[5] === 'THU' || cron[5] === 'thu' || cron[5] === 'Thu') this.weekResult1 = 'Thu';
					                            else if (cron[5] === '5' || cron[5] === 'FRI' || cron[5] === 'fri' || cron[5] === 'Fri') this.weekResult1 = 'Fri';
					                            else if (cron[5] === '6' || cron[5] === 'SAT' || cron[5] === 'sat' || cron[5] === 'Sat') this.weekResult1 = 'Sat';
					                        }
					                    },
					                    data: {
					                        items: [
					                            { id: 'secondTabJob', name: '<fmt:message>igate.job.second</fmt:message>' },
					                            { id: 'minuteTabJob', name: '<fmt:message>igate.job.minute</fmt:message>' },
					                            { id: 'hourTabJob', name: '<fmt:message>igate.job.hour</fmt:message>' },
					                            { id: 'dayTabJob', name: '<fmt:message>igate.job.dayOfMonth</fmt:message>' },
					                            { id: 'monthTabJob', name: '<fmt:message>igate.job.month</fmt:message>' },
					                            { id: 'weekTabJob', name: '<fmt:message>igate.job.dayOfWeek</fmt:message>' }
					                        ],
					                        columns: [
					                            {
					                                header: '<fmt:message>igate.job.second</fmt:message>',
					                                name: 'second',
					                                align: 'center'
					                            },
					                            {
					                                header: '<fmt:message>igate.job.minute</fmt:message>',
					                                name: 'minute',
					                                align: 'center'
					                            },
					                            {
					                                header: '<fmt:message>igate.job.hour</fmt:message>',
					                                name: 'hour',
					                                align: 'center'
					                            },
					                            {
					                                header: '<fmt:message>igate.job.dayOfMonth</fmt:message>',
					                                name: 'dayOfMonth',
					                                align: 'center'
					                            },
					                            {
					                                header: '<fmt:message>igate.job.month</fmt:message>',
					                                name: 'month',
					                                align: 'center'
					                            },
					                            {
					                                header: '<fmt:message>igate.job.dayOfWeek</fmt:message>',
					                                name: 'dayOfWeek',
					                                align: 'center'
					                            }
					                        ],
					                        secondCheckValue: '',
					                        minuteCheckValue: '',
					                        hourCheckValue: '',
					                        dayCheckValue: '',
					                        monthCheckValue: '',
					                        weekCheckValue: '',
					                        secondResult1: '',
					                        secondResult2: '',
					                        secondResult3: '',
					                        secondResult4: '',
					                        secondResult5: '',
					                        minuteResult1: '',
					                        minuteResult2: '',
					                        minuteResult3: '',
					                        minuteResult4: '',
					                        minuteResult5: '',
					                        hourResult1: '',
					                        hourResult2: '',
					                        hourResult3: '',
					                        hourResult4: '',
					                        hourResult5: '',
					                        dayResult1: '',
					                        monthResult1: '',
					                        monthResult2: '',
					                        monthResult3: '',
					                        monthResult4: '',
					                        monthResult5: '',
					                        weekResult1: '',
					                        weekResult2: '',
					                        gridView: [],
					                        hideIE: true,
					                        resultData: null,
					                        secondSelect: null,
					                        minuteSelect: null,
					                        hourSelect: null,
					                        monthSelect: null
					                    },
					                    mounted: function () {
					                        this.gridView = new tui.Grid({
					                            // Modal Tui Grid Create
					                            el: document.getElementById('gridDivJob'),
					                            data: this.dataset,
					                            scrollX: false,
					                            scrollY: false,
					                            columns: this.columns
					                        });
		
					                        // Browser Check
					                        var agt = navigator.userAgent.toLowerCase();
					                        this.hideIE = !((navigator.appName == 'Netscape' && agt.indexOf('trident') != -1) || agt.indexOf('msie') != -1);
					                    },
					                    methods: {
					                        tabClick: function () {
					                            // Tab 클릭 시, Cron Expression 정규식 테스트
		
					                            $('#cronVueJob')
					                                .find('a[data-toggle="tab"]')
					                                .off('show.bs.tab')
					                                .on('show.bs.tab', function (e) {
					                                    var reg1 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-z|A-Z|.~!?@;:\#$\\\%<>^&\()\=+_\’`]/;
					                                    var reg2 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-z|A-Z|.~!@;:\#$\\\%<>^&\()\=+_\’`]/;
					                                    var reg3 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|.~!?@;:\#$\\\%<>^&\()\=+_\’`]/;
					                                    var reg4 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|.~!@;:\$\\\%<>^&\()\=+_\’`]/;
		
					                                    var rowInfo = cronResults.gridView.getRowAt(0);
					                                    var cronTabCheck = rowInfo.second + ' ' + rowInfo.minute + ' ' + rowInfo.hour + ' ' + rowInfo.dayOfMonth + ' ' + rowInfo.month + ' ' + rowInfo.dayOfWeek;
		
					                                    if (reg1.test(rowInfo.second) || reg1.test(rowInfo.minute) || reg1.test(rowInfo.hour)) {
					                                        window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                                        e.preventDefault();
					                                    } else if (reg2.test(rowInfo.dayOfMonth)) {
					                                        window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                                        e.preventDefault();
					                                    } else if (reg3.test(rowInfo.month)) {
					                                        window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                                        e.preventDefault();
					                                    } else if (reg4.test(rowInfo.dayOfWeek)) {
					                                        window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                                        e.preventDefault();
					                                    } else if (!regexr.test(cronTabCheck)) {
					                                        window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                                        e.preventDefault();
					                                    }
					                                });
					                        },
					                        gridData: function (param) {
					                            // Tui Grid 표 데이터 변경
		
					                            var newDataObj = {
					                                second: astro,
					                                minute: astro,
					                                hour: astro,
					                                dayOfMonth: astro,
					                                month: astro,
					                                dayOfWeek: question
					                            };
		
					                            var rowInfo = this.gridView.getRowAt(0);
		
					                            if (null != rowInfo) {
					                                for (var key in newDataObj) {
					                                    newDataObj[key] = rowInfo[key];
					                                }
					                            }
		
					                            for (var key in param) {
					                                newDataObj[key] = param[key];
					                            }
		
					                            this.gridView.resetData([newDataObj]);
					                        }
					                    },
					                    watch: {
					                        // 라디오 버튼에 따른 값 변경
					                        secondCheckValue: function () {
					                            if (this.secondCheckValue == 1) this.resultData = astro;
					                            else if (this.secondCheckValue == 2) this.resultData = this.secondResult1 + slash + this.secondResult2;
					                            else if (this.secondCheckValue == 3) this.resultData = this.secondResult3 + hyphen + this.secondResult4;
					                            else if (this.secondCheckValue == 4) this.resultData = this.secondResult5;
		
					                            this.gridData({ second: this.resultData });
					                        },
					                        secondResult1: function () {
					                            this.gridData({ second: this.secondResult1 + slash + this.secondResult2 });
					                        },
					                        secondResult2: function () {
					                            this.gridData({ second: this.secondResult1 + slash + this.secondResult2 });
					                        },
					                        secondResult3: function () {
					                            this.gridData({ second: this.secondResult3 + hyphen + this.secondResult4 });
					                        },
					                        secondResult4: function () {
					                            this.gridData({ second: this.secondResult3 + hyphen + this.secondResult4 });
					                        },
					                        secondResult5: function () {
					                            this.gridData({ second: this.secondResult5 });
					                        },
					                        minuteCheckValue: function () {
					                            if (this.minuteCheckValue == 1) this.resultData = astro;
					                            else if (this.minuteCheckValue == 2) this.resultData = this.minuteResult1 + slash + this.minuteResult2;
					                            else if (this.minuteCheckValue == 3) this.resultData = this.minuteResult3 + hyphen + this.minuteResult4;
					                            else if (this.minuteCheckValue == 4) this.resultData = this.minuteResult5;
		
					                            this.gridData({ minute: this.resultData });
					                        },
					                        minuteResult1: function () {
					                            this.gridData({ minute: this.minuteResult1 + slash + this.minuteResult2 });
					                        },
					                        minuteResult2: function () {
					                            this.gridData({ minute: this.minuteResult1 + slash + this.minuteResult2 });
					                        },
					                        minuteResult3: function () {
					                            this.gridData({ minute: this.minuteResult3 + hyphen + this.minuteResult4 });
					                        },
					                        minuteResult4: function () {
					                            this.gridData({ minute: this.minuteResult3 + hyphen + this.minuteResult4 });
					                        },
					                        minuteResult5: function () {
					                            this.gridData({ minute: this.minuteResult5 });
					                        },
					                        hourCheckValue: function () {
					                            if (this.hourCheckValue == 1) this.resultData = astro;
					                            else if (this.hourCheckValue == 2) this.resultData = this.hourResult1 + slash + this.hourResult2;
					                            else if (this.hourCheckValue == 3) this.resultData = this.hourResult3 + hyphen + this.hourResult4;
					                            else if (this.hourCheckValue == 4) this.resultData = this.hourResult5;
		
					                            this.gridData({ hour: this.resultData });
					                        },
					                        hourResult1: function () {
					                            this.gridData({ hour: this.hourResult1 + slash + this.hourResult2 });
					                        },
					                        hourResult2: function () {
					                            this.gridData({ hour: this.hourResult1 + slash + this.hourResult2 });
					                        },
					                        hourResult3: function () {
					                            this.gridData({ hour: this.hourResult3 + hyphen + this.hourResult4 });
					                        },
					                        hourResult4: function () {
					                            this.gridData({ hour: this.hourResult3 + hyphen + this.hourResult4 });
					                        },
					                        hourResult5: function () {
					                            this.gridData({ hour: this.hourResult5 });
					                        },
					                        dayCheckValue: function () {
					                            if (this.dayCheckValue == 1) {
					                                this.resultData = astro;
		
					                                if (this.weekCheckValue != 1) {
					                                    this.weekCheckValue = 1;
					                                    this.gridData({ dayOfWeek: question });
					                                }
					                            } else if (this.dayCheckValue == 2) {
					                                this.resultData = question;
		
					                                if (this.weekCheckValue == 1) {
					                                    this.weekCheckValue = 3;
					                                    this.weekResult2 = astro;
					                                    this.gridData({ dayOfWeek: astro });
					                                }
					                            } else if (this.dayCheckValue == 3) {
					                                this.resultData = this.dayResult1;
		
					                                if (this.weekCheckValue != 1) {
					                                    this.weekCheckValue = 1;
					                                    this.gridData({ dayOfWeek: question });
					                                }
					                            }
		
					                            this.gridData({ dayOfMonth: this.resultData });
					                        },
					                        dayResult1: function () {
					                            this.gridData({ dayOfMonth: this.dayResult1 });
					                        },
					                        monthCheckValue: function () {
					                            if (this.monthCheckValue == 1) this.resultData = astro;
					                            else if (this.monthCheckValue == 2) this.resultData = this.monthResult1 + slash + this.monthResult2;
					                            else if (this.monthCheckValue == 3) this.resultData = this.monthResult3 + hyphen + this.monthResult4;
					                            else if (this.monthCheckValue == 4) this.resultData = this.monthResult5;
		
					                            this.gridData({ month: this.resultData });
					                        },
					                        monthResult1: function () {
					                            this.gridData({ month: this.monthResult1 + slash + this.monthResult2 });
					                        },
					                        monthResult2: function () {
					                            this.gridData({ month: this.monthResult1 + slash + this.monthResult2 });
					                        },
					                        monthResult3: function () {
					                            this.gridData({ month: this.monthResult3 + hyphen + this.monthResult4 });
					                        },
					                        monthResult4: function () {
					                            this.gridData({ month: this.monthResult3 + hyphen + this.monthResult4 });
					                        },
					                        monthResult5: function () {
					                            this.gridData({ month: this.monthResult5 });
					                        },
					                        weekCheckValue: function () {
					                            if (this.weekCheckValue == 1) {
					                                this.resultData = question;
		
					                                if (this.dayCheckValue == 2) {
					                                    this.dayCheckValue = 1;
					                                    this.gridData({ dayOfMonth: astro });
					                                }
					                            } else if (this.weekCheckValue == 2) {
					                                this.resultData = this.weekResult1;
		
					                                if (this.dayCheckValue != 2) {
					                                    this.dayCheckValue = 2;
					                                    this.gridData({ dayOfMonth: question });
					                                }
					                            } else if (this.weekCheckValue == 3) {
					                                this.resultData = this.weekResult2;
		
					                                if (this.dayCheckValue != 2) {
					                                    this.dayCheckValue = 2;
					                                    this.gridData({ dayOfMonth: question });
					                                }
					                            }
		
					                            this.gridData({ dayOfWeek: this.resultData });
					                        },
					                        weekResult1: function () {
					                            this.gridData({ dayOfWeek: this.weekResult1 });
					                        },
					                        weekResult2: function () {
					                            this.gridData({ dayOfWeek: this.weekResult2 });
					                        }
					                    }
					                });
					            };
		
					            modalInfo.okCallBackFunc = function () {
					                // Cron Expression Modal Ok Click Function
					                var rowInfo = cronResults.gridView.getRowAt(0);
					                var objectResult = rowInfo.second + ' ' + rowInfo.minute + ' ' + rowInfo.hour + ' ' + rowInfo.dayOfMonth + ' ' + rowInfo.month + ' ' + rowInfo.dayOfWeek;
		
					                if (!regexr.test(objectResult)) {
					                    window.$alert({ type: 'normal', message: '<fmt:message>igate.job.error</fmt:message>' });
					                    return;
					                }
		
					                window.vmAdapterOperations.adapterOperations[modalIdx].cronExpression = objectResult;
		
					                $('#adapterModalSearch').modal('hide');
					            };
		
					            createPageObj.openCustomModal.call(this, modalInfo);
					        }
					    },
					    created: function () {
					        new HttpReq('/common/property/properties.json').read(
					            { propertyId: 'List.Adapter.Event', orderByKey: true },
					            function (result) {
					                this.adapterEventList = result.object;
					            }.bind(this)
					        );
		
					        new HttpReq('/common/property/properties.json').read(
					            { propertyId: 'List.Yn', orderByKey: true },
					            function (result) {
					                this.adapterDisabledYnList = result.object;
					            }.bind(this)
					        );
					    }
					});
	
					window.vmAdapterProperties = new Vue({
					    el: '#AdapterProperties',
					    data: {
					        viewMode: 'Open',
					        object: {
					            pk: {}
					        },
					        adapterProperties: [],
					        propertyKeys: [],
					        uri: '',
					        maxLengthObj: {
					        	id: getRegExpInfo('id').maxLength,
					        	value: getRegExpInfo('value').maxLength
					        }			        
					    },
					    methods: {
					        addProperty: function () {
					            this.adapterProperties.push({
					                pk: {
					                    propertyKey: ''
					                },
					                propertyValue: '',
					                propertyDesc: '',
					                letter: {
					                	pk: {
						                    propertyKey: 0
						                },
						                propertyValue: 0,
					                }
					            });
					        },
					        removeProperty: function (index) {
					            this.adapterProperties.splice(index, 1);
					        },
					        changeAdapterType: function () { // 기본정보 > 어댑터 타입 변경 이벤트
					        	this.setPropertyKeys();
					        	
					            new HttpReq('/common/property/properties.json').read(
					                {
					                    propertyId: 'Property.Adapter.' + vmMain.object.adapterType,
					                    orderByKey: true
					                },
					                function (adapterTypeListResult) {
					                	this.adapterProperties = adapterTypeListResult.object
					                	.filter(function (adapterPropertyInfo) {
		                                    return 'Y' === adapterPropertyInfo.requireYn;
		                                })
					                	.map(function (adapterPropertyInfo) {
			                                return {
		                                		pk: {
		                                            propertyKey: adapterPropertyInfo.pk.propertyKey
		                                        },
		                                        propertyValue: adapterPropertyInfo.propertyValue,
		                                        propertyDesc: adapterPropertyInfo.propertyDesc,
			                                	cache: 'Y' === adapterPropertyInfo.cacheYn,
		                                        cipher: 'Y' === adapterPropertyInfo.cipherYn,
		                                        require: 'Y' === adapterPropertyInfo.requireYn,
			                                	letter: {
			                                    	pk: {
			                                            propertyKey: adapterPropertyInfo.pk.propertyKey? adapterPropertyInfo.pk.propertyKey.length : 0
			                                        },
			                                        propertyValue: adapterPropertyInfo.propertyValue? adapterPropertyInfo.propertyValue.length : 0
			                                    }
			                                }
			                            });
					                }.bind(this)
					            );
					        },
					        setPropertyKeys: function() { //프로퍼티 키 datalist 불러오기
					        	new HttpReq('/igate/adapter/propertyKeys.json').read(
			                        {
			                        	adapterType: vmMain.object.adapterType,
			                            orderByKey: true
			                        },
			                        function (adapterKeyListResult) {
			                            this.propertyKeys = adapterKeyListResult.object;
			                        }.bind(this)
			                    );
					        },
					        changePropertyKey: function (index) { //프로퍼티 키 datalist 값 선택
					            var rowInfo = this.adapterProperties[index];
		
					            // 직접 입력일 경우
					            if (
				        			!this.propertyKeys.some(function (property) {
				        				return rowInfo.pk.propertyKey === property.pk.propertyKey;
				        			})
				        		) 
					            	return;
					            
					            // 프로퍼티 키 중복 검사
					            var check = this.adapterProperties.filter(function(property, idx) {
					            	return idx !== index;
					            }).some(function(property, idx) {
					            	return rowInfo.pk.propertyKey === property.pk.propertyKey;
					            });
					            
					            if(check) {
					            	window._alert({
				    					type: 'warn',
				    					message: '<fmt:message>igate.adapter.alert.overlap</fmt:message>',
				    				});
		
				    				this.adapterProperties[index] = {
				    					pk: {
				    						propertyKey: ''
				    					},
				    					letter : {
				    						pk: {
					    						propertyKey: 0
					    					}
				    					}
				    				};
		
				    				return;
					            }
					            
					            new HttpReq('/common/property/properties.json').read(
					                {
					                    propertyId: 'Property.Adapter.' + vmMain.object.adapterType,
					                    propertyKey: rowInfo.pk.propertyKey,
					                    orderByKey: true
					                },
					                function (adapterResult) {
					                    var adapterInfo = adapterResult.object[0];
		
					                    this.adapterProperties[index].propertyValue = adapterInfo.propertyValue;
					                    this.adapterProperties[index].propertyDesc = adapterInfo.propertyDesc;
					                    this.adapterProperties[index].cipher = 'Y' === adapterInfo.cipherYn;
					                    this.adapterProperties[index].require = 'Y' === adapterInfo.requireYn;
					                }.bind(this)
					            );
					        },
					        inputEvt: function (info, key) {
					        	var regExp = getRegExpInfo('pk.propertyKey' === key? 'id' : 'value').regExp;
					        	
								if ('pk.propertyKey' === key) {
									info.pk.propertyKey = info.pk.propertyKey? info.pk.propertyKey.replace(new RegExp(regExp, 'g'), '') : '';
									info.letter.pk.propertyKey = info.pk.propertyKey ? info.pk.propertyKey.length : 0;
								} else if('propertyValue' === key) {
									info.propertyValue = info.propertyValue? info.propertyValue.replace(new RegExp(regExp, 'g'), '') : '';
									info.letter.propertyValue = info.propertyValue ? info.propertyValue.length : 0;
								}
					        },
					    }
					});
	
					var vmConnectors = new Vue({
					    el: '#Connectors',
					    data: {
					        viewMode: 'Open',
					        object: {},
					        connectors: []
					    }
					});
	
					window.vmAdapterQueueDeploies = new Vue({
					    el: '#AdapterQueueDeploies',
					    data: {
					        instanceList: [],
					        adapterQueueDeploies: [],
					        adapterSubDeploies: []
					    },
					    created: function () {
					    	
					        new HttpReq('/igate/instance/list.json').read(
					            null,
					            function (instanceResult) {
					                if ('ok' != instanceResult.result) return;
		
					                this.instanceList = instanceResult.object.filter(function (instance) {
					                    return 'T' == instance.instanceType;
					                });
					            }.bind(this)
					        );
					    },
					    computed: {
					        pk: function () {
					            return {
					                'pk.adapterId': this.adapterQueueDeploies.pk.adapterId,
					                'pk.instanceId': this.adapterQueueDeploies.pk.instanceId
					            };
					        }
					    },
					    methods: {
					        push: function (value, e) {
					            if (e.target.checked) {
					                //check true
					                this.adapterQueueDeploies.push({
					                    pk: {
					                        adapterId: window.vmMain.object.adapterId,
					                        instanceId: value
					                    }
					                });
					            } else {
					                //check false
					                for (var i = 0; i < this.adapterQueueDeploies.length; i++) {
					                    if (this.adapterQueueDeploies[i].pk.instanceId === value) {
					                        this.adapterQueueDeploies.splice(i, 1);
		
					                        break;
					                    }
					                }
					            }
					        }
					    }
					});
				});
	        });

			new Vue({
			    el: '#panel-header',
			    methods: $.extend(true, {}, panelMethodOption)
			});

			new Vue({
			    el: '#panel-footer',
			    methods: $.extend(true, {}, panelMethodOption, {
			        guide: function () {
			            window.open("<c:url value='/manual/Property Reference.htm' />", '_blank', 'height=886, width=785,resizable=yes, toolbar=no, menubar=no, location=no, scrollbars=yes, status=no');
			        },
			        externalGuide: function () {
			            window.open("<c:url value='/manual/External Guide.htm' />", '_blank', 'height=886, width=785,resizable=yes, toolbar=no, menubar=no, location=no, scrollbars=yes, status=no');
			        },
			        start: function () {
			            ControlImngObj.control('start', $.param({ adapterId: window.vmMain.object.adapterId, instance: null }, null));
			        },
			        stop: function () {
			            ControlImngObj.control('stop', $.param({ adapterId: window.vmMain.object.adapterId, instance: null }, null));
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
		});
	</script>
</body>
</html>
