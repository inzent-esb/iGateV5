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
	<div id="connector" data-ready>
		<sec:authorize var="hasConnectorViewer" access="hasRole('ConnectorViewer')"></sec:authorize>
		<sec:authorize var="hasConnectorEditor" access="hasRole('ConnectorEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
	
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#connector').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasConnectorViewer}';
			var editor = 'true' == '${hasConnectorEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('connector');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.connectorId',
			        regExpType: 'searchId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.connectorName',
			        regExpType: 'name',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.socketAddress',
			        name: 'Socket Address',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.socketPortSnapshot',
			        regExpType: 'num',
			        name: 'Socket Port',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>common.type</fmt:message>',
			        mappingDataInfo: {
			            id: 'connectorTypeList',
			            selectModel: 'object.connectorType',
			            optionFor: 'option in connectorTypeList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        },
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.connectorDesc',
			        regExpType: 'desc',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    addBtn: editor,
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
			                        mappingDataInfo: 'object.connectorId',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        isPk: true,
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.connectorName',
			                        name: '<fmt:message>head.name</fmt:message>',
			                        regExpType: 'name'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.connectorType',
			                            optionFor: 'option in connectorTypeList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue',
			                            changeEvt: 'changeConnectorType'
			                        },
			                        name: '<fmt:message>common.type</fmt:message>',
			                        warning: '<fmt:message>igate.connector.alert.type.empty</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.connectorLogLevel',
			                            optionFor: 'option in connectorLogLevelList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>head.log.level</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.connectorStartYn',
			                            optionFor: 'option in connectorStartYnList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>igate.connector.startYn</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.requestDirection',
			                            optionFor: 'option in requestDirectionList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>igate.connector.requestDirection</fmt:message>'
			                    },
			                    {
			                        type: 'search',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.adapterId',
			                            callBackFuncName: 'setAdapterId'
			                        },
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>'
			                    },
			                    {
			                        type: 'search',
			                        mappingDataInfo: {
			                            url: '/modal/threadPoolModal',
			                            modalTitle: '<fmt:message>igate.threadPool</fmt:message>',
			                            vModel: 'object.threadPoolId',
			                            callBackFuncName: 'setThreadPoolId'
			                        },
			                        name: '<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.connectorDesc',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        height: 200
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'custom',
			        id: 'ConnectorProperties',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.property</fmt:message>',
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
			            detailHtml += '        	   <div class="form-table-body" v-for="(elm, index) in connectorProperties">';  
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
			        type: 'property',
			        id: 'ConnectorAdapters',
			        name: '<fmt:message>igate.adapter</fmt:message>',
			        addRowFunc: 'addConnectorAdapter',
			        removeRowFunc: 'removeConnectorAdapter(index)',
			        mappingDataInfo: 'connectorAdapters',
			        detailList: [
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.pk.adapterId',
			                name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                readonly: true
			            }
			        ]
			    },
			    {
			        type: 'custom',
			        id: 'ConnectorDeploies',
			        name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
			        getDetailArea: function () {
			        	var detailHtml = '';

			            detailHtml += '<ul class="list-group" style="width: 100%;">';
			            detailHtml += '    <li class="list-group-item" v-for="(element, index) in instanceList">';
			            detailHtml += '        <label class="custom-control custom-checkbox">';
			            detailHtml += '            <input type="checkbox" class="custom-control-input view-disabled" v-model="connectorCheckList[index]" @change="setPropertyList(element.instanceId, $event)">';			            
			            detailHtml += '            <span class="custom-control-label">{{element.instanceId}}</span>';
			            detailHtml += '        </label>';
			            detailHtml += '    </li>';
			            detailHtml += '</ul>';

			            return detailHtml;
			        }
			    }
			]);

			createPageObj.setPanelButtonList({
			    dumpBtn: editor,
			    guideBtn: editor,
			    removeBtn: editor,
			    goModBtn: editor,
			    saveBtn: editor,
			    updateBtn: editor,
			    goAddBtn: editor,
			    startBtn: editor,
			    stopBtn: editor,
			    stopForceBtn: editor,
			    interruptBtn: editor,
			    blockBtn: editor,
			    unblockBtn: editor
			});

			createPageObj.panelConstructor();

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/connector/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/connector/control',
			    dumpUrl: '/api/entity/connector/dump'
			});
			
			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Connector.Type' }, orderByKey: true }, function (connectorTypeList) {
			    
				window.vmSearch = new Vue({
			        el: '#' + createPageObj.getElementId('ImngSearchObject'),
			        data: {
			            object: {
			                connectorId: null,
			                connectorName: null,
			                adapterId: null,
			                socketAddress: null,
			                connectorType: ' ',
			                connectorDesc: null,
			                pageSize: '10'
			            },
			            letter: {
			                connectorId: 0,
			                connectorName: 0,
			                adapterId: 0,
			                socketAddress: 0,
			                connectorDesc: 0
			            },
			            connectorTypeList: []
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
			                	this.object.pageSize = 10;

			                    this.object.connectorId = null;
			                    this.object.connectorName = null;
			                    this.object.adapterId = null;
			                    this.object.socketAddress = null;
			                    this.object.socketPortSnapshot = null;
			                    this.object.connectorType = ' ';
			                    this.object.connectorDesc = null;

			                    this.letter.connectorId = 0;
			                    this.letter.connectorName = 0;
			                    this.letter.adapterId = 0;
			                    this.letter.socketAddress = 0;
			                    this.letter.socketPortSnapshot = 0;
			                    this.letter.connectorDesc = 0;
			                }

			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorTypeList'), this.object.connectorType);
			            },
			            openModal: function (openModalParam, regExpInfo) {
			                createPageObj.openModal.call(this, openModalParam, regExpInfo);
			            },
			            setSearchInstanceId: function (param) {
			                this.object.instanceId = param.instanceId;
			            },
			            setSearchAdapterId: function (param) {
			                this.object.adapterId = param.adapterId;
			            }
			        }),
			        created: function () {
			        	this.connectorTypeList = connectorTypeList.object;
			        },				        
			        mounted: function () {
			        	this.initSearchArea();
			        }
			    });

			    window.vmList = new Vue({
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
				    }),
			        mounted: function () {
			            this.makeGridObj = getMakeGridObj();

			            this.makeGridObj.setConfig({
			                el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
				            searchUrl: '/api/entity/connector/search',
				            totalCntUrl: '/api/entity/connector/count',
				    		paging: {
				    			isUse: true,
				    			side: "server",
				    			setCurrentCnt: function(currentCnt) {
				    			    this.currentCnt = currentCnt
				    			}.bind(this)				    			
				    		},
			                columns: [
			                    {
			                        name: 'connectorId',
			                        header: '<fmt:message>head.id</fmt:message>',
			                        width: '30%'
			                    },
			                    {
			                        name: 'connectorName',
			                        header: '<fmt:message>head.name</fmt:message>',
			                        width: '40%'
			                    },
			                    {
			                        name: 'adapterId',
			                        header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        width: '30%'
			                    },
			                    {
			                        name: 'connectorType',
			                        header: '<fmt:message>common.type</fmt:message>',
			                        width: '30%',
			                        align: 'center',
			                        formatter: function (info) {
			                            var findConnectorType = window.vmSearch.connectorTypeList.find(function (typeInfo) {
			                                return typeInfo.pk.propertyKey === info.row.connectorType;
			                            });
			                            return findConnectorType ? escapeHtml(findConnectorType.propertyValue) : '';
			                        }
			                    },
			                    {
			                        name: 'connectorDesc',
			                        header: '<fmt:message>head.description</fmt:message>',
			                        width: '40%'
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
			                connectorId: null,
			                connectorName: null,
			                connectorType: null,
			                connectorLogLevel: 'N/A',
			                connectorStartYn: 'Y',
			                requestDirection: 'B',
			                adapterId: null,
			                threadPoolId: null,
			                connectorDesc: null,
			                connectorProperties: [],
			                connectorAdapters: [],
			                connectorDeploies: []
			            },
			            letter: {
			                connectorId: 0,
			                connectorName: 0,
			                connectorDesc: 0
			            },
			            connectorTypeList: [],
			            connectorLogLevelList: [],
			            connectorStartYnList: [],
			            requestDirectionList: [],
			            panelMode: null
			        },
			        computed: {
				        pk: function () {
				            return {
				            	connectorId: this.object.connectorId
				            };
				        }
				    },
			        watch: {
			            panelMode: function () {
			            	if (this.panelMode !== 'add') $('#panel').find('.warningLabel').hide();
			            }
			        },
			        methods: {
			            inputEvt: function (info) {
			                setLengthCnt.call(this, info);
			            },
			            goDetailPanel: function () {
			                panelOpen(
			                    'detail',
			                    null,
			                    function () {
			                        $('#panel')
			                            .find('#blockBtn')
			                            .css('display', 'O' === this.object.requestDirection ? 'block' : 'none');
			                        $('#panel')
			                            .find('#unblockBtn')
			                            .css('display', 'O' === this.object.requestDirection ? 'block' : 'none');
			                    }.bind(this)
			                );
			            },
			            initDetailArea: function (object) {
			                if (object) {
			                    this.object = object;
			                } else {
			                    this.object.connectorId = null;
			                    this.object.connectorName = null;
			                    this.object.connectorType = null;
			                    this.object.connectorLogLevel = 'N/A';
			                    this.object.connectorStartYn = 'Y';
			                    this.object.requestDirection = 'B';
			                    this.object.adapterId = null;
			                    this.object.threadPoolId = null;
			                    this.object.connectorDesc = null;
			                    this.object.connectorProperties = [];
			                    this.object.connectorAdapters = [];
			                    this.object.connectorDeploies = [];

			                    window.vmConnectorProperties.propertyKeys = [];
			                    window.vmConnectorProperties.connectorProperties = [];
			                    window.vmConnectorAdapters.connectorAdapters = [];
			                    window.vmConnectorDeploies.connectorDeploies = [];
			                    window.vmConnectorDeploies.connectorCheckList = [];
			                    
			                    //letter
			                    this.letter.connectorId = 0;
			                    this.letter.connectorName = 0;
			                    this.letter.connectorDesc = 0;
			                }
			            },
			            loaded: function () {
			                window.vmConnectorProperties.connectorProperties = this.object.connectorProperties;
			                window.vmConnectorAdapters.connectorAdapters = this.object.connectorAdapters;
			                window.vmConnectorDeploies.connectorDeploies = this.object.connectorDeploies;
			                
			                if(this.object.connectorType) window.vmConnectorProperties.setPropertyKeyList();

			                var deploies = this.object.connectorDeploies.map(function (info) {
			                    return info.pk.instanceId;
			                });
			                window.vmConnectorDeploies.connectorCheckList = [];

			                window.vmConnectorDeploies.instanceList.forEach(function (instanceInfo) {
			                    window.vmConnectorDeploies.connectorCheckList.push(-1 < deploies.indexOf(instanceInfo.instanceId));
			                });

			                //letter
			                this.letter.connectorId = this.object.connectorId.length;
			                this.letter.connectorName = this.object.connectorName ? this.object.connectorName.length : 0;
			                this.letter.connectorDesc = this.object.connectorDesc ? this.object.connectorDesc.length : 0;
			            },
			            changeConnectorType: function () {
			                vmConnectorProperties.changeConnectorType();
			            },
			            openModal: function (openModalParam) {
			                createPageObj.openModal.call(this, openModalParam);
			            },
			            setAdapterId: function (param) {
			                this.object.adapterId = param.adapterId;
			            },
			            setThreadPoolId: function (param) {
			                this.object.threadPoolId = param.threadPoolId;
			            }
			        },
			        mounted: function () {
			            var httpReq = new HttpReq('/api/page/properties');

			            httpReq.read(
			                { pk : { propertyId: 'List.Yn' }, orderByKey: true },
			                function (connectorStartYnListResult) {
			                    httpReq.read(
			                        {
			                            pk : {propertyId: 'List.Connector.RequestDirection' },
			                            orderByKey: true
			                        },
			                        function (requestDirectionListResult) {
			                            httpReq.read(
			                                {
			                                    pk : { propertyId: 'List.LogLevel' },
			                                    orderByKey: true
			                                },
			                                function (connectorLogLevelListResult) {
			                                    this.connectorTypeList = connectorTypeList.object;
			                                    this.connectorLogLevelList = connectorLogLevelListResult.object;
			                                    this.connectorStartYnList = connectorStartYnListResult.object;
			                                    this.requestDirectionList = requestDirectionListResult.object;
			                                }.bind(this)
			                            );
			                        }.bind(this)
			                    );
			                }.bind(this)
			            );
			        }
			    });
			});

			window.vmConnectorProperties = new Vue({
			    el: '#ConnectorProperties',
			    data: {
			        viewMode: 'Open',
			        object: {},
			        propertyKeys: [],
			        connectorProperties: [],
			        maxLengthObj: {
			        	id: getRegExpInfo('id').maxLength,
			        	value: getRegExpInfo('value').maxLength
			        }
			    },
			    methods: {
			        addProperty: function () {
			            this.connectorProperties.push({
			                pk: {
			                    propertyKey: ''
			                },
			                propertyValue: '',
			                propertyDesc: '',
			                letter: {
			                	pk: {
				                    propertyKey: 0
				                },
				                propertyValue: 0
			                }
			            });
			        },
			        removeProperty: function (index) {
			            this.connectorProperties.splice(index, 1);
			        },
			        setPropertyKeyList: function(callback) { //프로퍼티 키 datalist 불러오기
			        	new HttpReq('/api/page/properties').read(
	                        {
			                    pk : { propertyId: 'Property.Connector.' + vmMain.object.connectorType },
	                            orderByKey: true
	                        },
	                        function (connectorKeyListResult) {
	                            this.propertyKeys = connectorKeyListResult.object;
	                            
	                            if(callback) callback();
	                        }.bind(this)
	                    );
			        },
			        changeConnectorType: function () { // 기본정보 > 커넥터 타입 변경 이벤트
			        	this.setPropertyKeyList(function() {
			        		this.connectorProperties = this.propertyKeys
                            .filter(function (connectorTypeInfo) {
                                return 'Y' === connectorTypeInfo.requireYn;
                            })
                            .map(function (connectorTypeInfo) {
                                return {
                                    pk: {
                                        propertyKey: connectorTypeInfo.pk.propertyKey
                                    },
                                    propertyValue: connectorTypeInfo.propertyValue,
                                    propertyDesc: connectorTypeInfo.propertyDesc,
                                    cache: 'Y' === connectorTypeInfo.cacheYn,
                                    cipher: 'Y' === connectorTypeInfo.cipherYn,
                                    require: 'Y' === connectorTypeInfo.requireYn,
                                    letter: {
                                    	pk: {
                                            propertyKey: connectorTypeInfo.pk.propertyKey? connectorTypeInfo.pk.propertyKey.length : 0
                                        },
                                        propertyValue: connectorTypeInfo.propertyValue? connectorTypeInfo.propertyValue.length : 0
                                    }
                                };
                            });
			        	}.bind(this))
			        },
			        changePropertyKey: function (index) { //프로퍼티 키 datalist 값 선택
			            var rowInfo = this.connectorProperties[index];

			            // 직접 입력일 경우
			            if (
		        			!this.propertyKeys.some(function (property) {
		        				return rowInfo.pk.propertyKey === property.pk.propertyKey;
		        			})
		        		) 
			            	return;
			            
			            // 프로퍼티 키 중복 검사
			            var check = this.connectorProperties.filter(function(property, idx) {
			            	return idx !== index;
			            }).some(function(property, idx) {
			            	return rowInfo.pk.propertyKey === property.pk.propertyKey;
			            });
			            
			            if(check) {
			            	window._alert({
		    					type: 'warn',
		    					message: '<fmt:message>igate.connector.alert.overlap</fmt:message>'
		    				});

		    				this.connectorProperties[index] = {
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
			            
			            new HttpReq('/api/page/properties').read(
			                {
								pk : {
				                    propertyId: 'Property.Connector.' + vmMain.object.connectorType,
				                    propertyKey: rowInfo.pk.propertyKey,
								},
			                    orderByKey: true
			                },
			                function (connectorResult) {
			                    var connectorInfo = connectorResult.object[0];

			                    this.connectorProperties[index].propertyValue = connectorInfo.propertyValue;
			                    this.connectorProperties[index].propertyDesc = connectorInfo.propertyDesc;
			                    this.connectorProperties[index].cipher = 'Y' === connectorInfo.cipherYn;
			                    this.connectorProperties[index].require = 'Y' === connectorInfo.requireYn;
			                }.bind(this)
			            );
			        },
			        inputEvt: function (info, key) {
			        	//letter
			        	var regExp = getRegExpInfo('pk.propertyKey' === key? 'id' : 'value').regExp;
			        	
						if ('pk.propertyKey' === key) {
							info.pk.propertyKey = info.pk.propertyKey? info.pk.propertyKey.replace(new RegExp(regExp, 'g'), '') : '';
							info.letter.pk.propertyKey = info.pk.propertyKey ? info.pk.propertyKey.length : 0;
						} else if('propertyValue' === key) {
							info.propertyValue = info.propertyValue? info.propertyValue.replace(new RegExp(regExp, 'g'), '') : '';
							info.letter.propertyValue = info.propertyValue ? info.propertyValue.length : 0;
						}
			        }
			    }
			});

			window.vmConnectorAdapters = new Vue({
			    el: '#ConnectorAdapters',
			    data: {
			        viewMode: 'Open',
			        connectorAdapters: []
			    },
			    methods: {
			        addConnectorAdapter: function () {
			            this.openModal({
			                url: '/modal/adapterModal',
			                modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                callBackFuncName: 'setAdapterId'
			            });
			        },
			        removeConnectorAdapter: function (index) {
			            this.connectorAdapters = this.connectorAdapters.slice(0, index).concat(this.connectorAdapters.slice(index + 1));
			        },
			        openModal: function (openModalParam) {
			            createPageObj.openModal.call(this, openModalParam);
			        },
			        setAdapterId: function (param) {
			            if (
			                this.connectorAdapters.some(function (property) {
			                    return property.pk.adapterId === param.adapterId;
			                })
			            )
			                return;

			            this.connectorAdapters.push({
			                pk: {
			                    adapterId: param.adapterId
			                }
			            });
			        }
			    }
			});

			window.vmConnectorDeploies = new Vue({
			    el: '#ConnectorDeploies',
			    data: {
			        instanceList: [],
			        connectorDeploies: [],
			        connectorCheckList: []
			    },
			    computed: {
			        pk: function () {
			            return {
			                'pk.connectorId': this.connectorDeploies.pk.connectorId,
			                'pk.instanceId': this.connectorDeploies.pk.instanceId
			            };
			        }
			    },
			    mounted: function () {
			        new HttpReq('/api/entity/instance/search').read(
			        		{ object: {}, limit: null, next: null, reverseOrder: false },
			            function (instanceListResult) {
			                this.instanceList = instanceListResult.object.filter(function (instanceInfo) {
			                    return 'T' == instanceInfo.instanceType;
			                });
			            }.bind(this)
			        );
			    },
			    methods: {
			        setPropertyList: function (value, e) {
			            if (e.target.checked) {
			                this.connectorDeploies.push({
			                    pk: {
			                        connectorId: window.vmMain.object.connectorId,
			                        instanceId: value
			                    }
			                });
			            } else {
			                for (var i = 0; i < this.connectorDeploies.length; i++) {
			                    if (this.connectorDeploies[i].pk.instanceId === value) {
			                        this.connectorDeploies.splice(i, 1);
			                        break;
			                    }
			                }
			            }
			        }
			    }
			});

			new Vue({
			    el: '#panel-header',
			    methods: $.extend(true, {}, panelMethodOption)
			});

			new Vue({
			    el: '#panel-footer',
			    methods: $.extend(true, {}, panelMethodOption, {
			        guide: function () {
			            window.open("${prefixUrl}/manual/Connector Guide.htm", '_blank', 'height=886, width=785,resizable=yes, toolbar=no, menubar=no, location=no, scrollbars=yes, status=no');
			        },
			        start: function () {
			            ControlImngObj.control('start', {
			                connectorId: vmMain.object.connectorId
			            });
			        },
			        stop: function () {
			            ControlImngObj.control('stop', {
			                connectorId: vmMain.object.connectorId
			            });
			        },
			        block: function () {
			            ControlImngObj.control('block', {
			                connectorId: vmMain.object.connectorId
			            });
			        },
			        unblock: function () {
			            ControlImngObj.control('unblock', {
			                connectorId: vmMain.object.connectorId
			            });
			        },
			        interrupt: function () {
			            ControlImngObj.control('interrupt', {
			                connectorId: vmMain.object.connectorId
			            });
			        },
			        stopForce: function () {
			        	window._confirm({
			                type: 'warn',
			                message: '<fmt:message>igate.control.stopForce.alert</fmt:message>',
			                callBackFunc: function () {
			                	ControlImngObj.control('stopForce', {
			                        connectorId: vmMain.object.connectorId
			                    });
			                }.bind(this)
			            });
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