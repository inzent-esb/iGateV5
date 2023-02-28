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
		
		<%@ include file="/WEB-INF/html/custom/connector/detail.jsp"%>
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
			            url: '/modal/adapterModal.html',
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
			                            url: '/modal/adapterModal.html',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.adapterId',
			                            callBackFuncName: 'setAdapterId'
			                        },
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>'
			                    },
			                    {
			                        type: 'search',
			                        mappingDataInfo: {
			                            url: '/modal/threadPoolModal.html',
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
			            return $('#connectorPropertiesTemplate').clone().html();
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
			            return $('#connectorDeploiesTemplate').clone().html();
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
			    objectUri: '/igate/connector/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/connector/control.json'
			});

			new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Connector.Type', orderByKey: true }, function (connectorTypeList) {
			    window.vmSearch = new Vue({
			        el: '#' + createPageObj.getElementId('ImngSearchObject'),
			        data: {
			            pageSize: '10',
			            object: {
			                connectorId: null,
			                connectorName: null,
			                adapterId: null,
			                socketAddress: null,
			                connectorType: ' ',
			                connectorDesc: null
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

			                vmList.makeGridObj.search(this, function () {
			                    vmList.totalCount = numberWithComma(vmList.makeGridObj.getSearchGrid().getRowCount());
			                });
			            },
			            initSearchArea: function (searchCondition) {
			                if (searchCondition) {
			                    for (var key in searchCondition) {
			                        this.$data[key] = searchCondition[key];
			                    }
			                } else {
			                    this.pageSize = '10';

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
			        mounted: function () {
			            this.connectorTypeList = connectorTypeList.object;

			            this.$nextTick(
			                function () {
			                    this.initSearchArea();
			                }.bind(this)
			            );
			        }
			    });

			    window.vmList = new Vue({
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
			                searchUri: '/igate/connector/search.json',
			                viewMode: '${viewMode}',
			                popupResponse: '${popupResponse}',
			                popupResponsePosition: '${popupResponsePosition}',
			                onClick: function (loadParam) {
			                    SearchImngObj.clicked({
			                        connectorId: loadParam['connectorId']
			                    });
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
			        watch: {
			            panelMode: function () {
			                if (this.panelMode != 'add') $('#panel').find('.warningLabel').hide();
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

			                    this.letter.connectorId = 0;
			                    this.letter.connectorName = 0;
			                    this.letter.connectorDesc = 0;

			                    window.vmConnectorProperties.curLengthArr = [];
			                    window.vmConnectorProperties.maxLengthArr = [];

			                    window.vmConnectorProperties.connectorProperties = [];
			                    window.vmConnectorAdapters.connectorAdapters = [];
			                    window.vmConnectorDeploies.connectorDeploies = [];
			                    window.vmConnectorDeploies.connectorCheckList = [];
			                }
			            },
			            loaded: function () {
			                window.vmConnectorProperties.connectorProperties = this.object.connectorProperties;
			                window.vmConnectorAdapters.connectorAdapters = this.object.connectorAdapters;
			                window.vmConnectorDeploies.connectorDeploies = this.object.connectorDeploies;

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

			                this.object.connectorProperties.forEach(
			                    function (info) {
			                        this.curLengthArr.push({
			                            'pk.propertyKey': info.pk.propertyKey ? info.pk.propertyKey.length : 0,
			                            propertyValue: info.propertyValue ? info.propertyValue.length : 0
			                        });

			                        this.maxLengthArr.push(this.maxLengthObj);
			                    }.bind(window.vmConnectorProperties)
			                );
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
			            var httpReq = new HttpReq('/common/property/properties.json');

			            httpReq.read(
			                { propertyId: 'List.Yn', orderByKey: true },
			                function (connectorStartYnListResult) {
			                    httpReq.read(
			                        {
			                            propertyId: 'List.Connector.RequestDirection',
			                            orderByKey: true
			                        },
			                        function (requestDirectionListResult) {
			                            httpReq.read(
			                                {
			                                    propertyId: 'List.LogLevel',
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
			        connectorProperties: [],
			        propertyKeys: [],
			        uri: '',
			        curLengthArr: [],
			        maxLengthArr: [],
			        maxLengthObj: {
			            'pk.propertyKey': getRegExpInfo('id').maxLength,
			            propertyValue: getRegExpInfo('value').maxLength
			        }
			    },
			    computed: {
			        detailMode: function() {
			            return 'detail' === vmMain.mode || 'done' === vmMain.mode;
			        }
			    },
			    methods: {
			        addProperty: function () {
			            this.connectorProperties.push({
			                pk: {
			                    propertyKey: ''
			                },
			                propertyValue: '',
			                propertyDesc: ''
			            });

			            this.curLengthArr.push({
			                'pk.propertyKey': 0,
			                propertyValue: 0
			            });

			            this.maxLengthArr.push(this.maxLengthObj);
			        },
			        removeProperty: function (index) {
			            this.connectorProperties.splice(index, 1);
			            this.curLengthArr.splice(index, 1);
			            this.maxLengthArr.splice(index, 1);
			        },
			        changeConnectorType: function () {
			            new HttpReq('/common/property/properties.json').read(
			                {
			                    propertyId: 'Property.Connector.' + vmMain.object.connectorType,
			                    orderByKey: true
			                },
			                function (connectorTypeListResult) {
			                    new HttpReq('/igate/connector/propertyKeys.json').read(
			                        {
			                            connectorType: vmMain.object.connectorType,
			                            orderByKey: true
			                        },
			                        function (connectorKeyListResult) {
			                            this.connectorProperties = connectorTypeListResult.object
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
			                                        require: 'Y' === connectorTypeInfo.requireYn
			                                    };
			                                });

			                            this.propertyKeys = connectorKeyListResult.object;

			                            //letter
			                            this.curLengthArr = [];
			                            this.maxLengthArr = [];

			                            this.connectorProperties.forEach(function(info) {
			                                this.curLengthArr.push({
			                                    'pk.propertyKey': info.pk.propertyKey.length,
			                                    propertyValue: info.propertyValue.length
			                                });

			                                this.maxLengthArr.push(this.maxLengthObj);			                            	
			                            }.bind(this));
			                        }.bind(this)
			                    );
			                }.bind(this)
			            );
			        },
			        inputEvt: function (key, index) {
			            //letter
			            if ('pk.propertyKey' === key) {
			                if (this.curLengthArr[index]['pk.propertyKey'] > this.maxLengthArr[index]['pk.propertyKey']) return;
			                this.curLengthArr[index]['pk.propertyKey'] = this.connectorProperties[index].pk.propertyKey.length;
			            } else {
			                if (this.curLengthArr[index].propertyValue > this.maxLengthArr[index].propertyValue) return;
			                this.curLengthArr[index].propertyValue = this.connectorProperties[index].propertyValue.length;
			            }
			        },
			        changePropertyKey: function (index) {
			            var rowInfo = this.connectorProperties[index];

			            if (
			                rowInfo.pk.propertyKey.startsWith('#') ||
			                !this.propertyKeys.some(function (property) {
			                    return rowInfo.pk.propertyKey === property.pk.propertyKey;
			                })
			            )
			                return;

			            new HttpReq('/common/property/properties.json').read(
			                {
			                    propertyId: 'Property.Connector.' + vmMain.object.connectorType,
			                    propertyKey: rowInfo.pk.propertyKey,
			                    orderByKey: true
			                },
			                function (connectorResult) {
			                    var connectorInfo = connectorResult.object[0];

			                    this.connectorProperties[index].propertyValue = connectorInfo.propertyValue;
			                    this.connectorProperties[index].propertyDesc = connectorInfo.propertyDesc;
			                    this.connectorProperties[index].cipher = 'Y' === connectorInfo.cipherYn;
			                    this.connectorProperties[index].require = 'Y' === connectorInfo.requireYn;

			                    //letter
			                    this.curLengthArr[index].propertyValue = connectorInfo.propertyValue.length;
			                }.bind(this)
			            );
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
			                url: '/modal/adapterModal.html',
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
			        uri: "<c:url value='/igate/instance/list.json' />",
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
			        new HttpReq('/igate/instance/list.json').read(
			            null,
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
			            window.open("<c:url value='/manual/Connector Guide.htm' />", '_blank', 'height=886, width=785,resizable=yes, toolbar=no, menubar=no, location=no, scrollbars=yes, status=no');
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