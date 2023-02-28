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
	<div id="operation" data-ready>
		<sec:authorize var="hasOperationViewer" access="hasRole('OperationViewer')"></sec:authorize>
		<sec:authorize var="hasOperationEditor" access="hasRole('OperationEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#operation').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasOperationViewer}';
			var editor = 'true' == '${hasOperationEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('operation');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.operationId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.operationName',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.operationType',
			            optionFor: 'option in operationTypeList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            optionIf: 'option.pk.propertyKey != "S"',
			            id: 'operationTypeList'
			        },
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.operationGroup',
			        name: '<fmt:message>head.group</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
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
			        mappingDataInfo: 'object.operationDesc',
			        name: '<fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>',
			        regExpType: 'desc'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCount: viewer
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
			                        mappingDataInfo: 'object.operationId',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        isPk: true
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.operationName',
			                        name: '<fmt:message>head.name</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privateYn',
			                            optionFor: 'option in privateYnList',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: 'Private'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.operationType',
			                            optionFor: 'option in operationTypeList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>common.type</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.operationLogLevel',
			                            optionFor: 'option in logLevelList',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.pk.propertyKey'
			                        },
			                        name: 'Log Level'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.xaTransactionAttribute',
			                            optionFor: 'option in xaTransactionAttributeList',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: 'XA-Transaction'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.operationGroup',
			                        name: '<fmt:message>head.group</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.privilegeId',
			                        name: '<fmt:message>common.privilege</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.operationDesc',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        height: 200
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'custom',
			        id: 'Workflow',
			        clickEvt: function () {
			            customResizeFunc();
			        },
			        name: '<fmt:message>igate.operation.workflow</fmt:message>',
			        isSubResponsive: true,
			        getDetailArea: function () {
			            return '<div id="topology"></div>';
			        }
			    },
			    {
			        type: 'custom',
			        id: 'OperationRuleStr',
			        name: 'XML',
			        isSubResponsive: true,
			        getDetailArea: function () {
			            var strHtml = '';
			            strHtml += '<div class="col-lg-12" style="min-height: 270px;">';
			            strHtml += '    <div class="form-group" style="height: 100%;">';
			            strHtml += '	       <label class="control-label"><span>XML</span></label>';
			            strHtml += '		   <div class="input-group" style="height: 100%;">';
			            strHtml += '		       <textarea class="form-control view-disabled" v-model="operationRuleStr" style="height: 100%;"></textarea>';
			            strHtml += '		   </div>';
			            strHtml += '    </div>';
			            strHtml += '</div>';

			            return strHtml;
			        }
			    },
			    {
			        type: 'basic',
			        id: 'ResourceInuseInfo',
			        name: '<fmt:message>head.resource.inuse.info</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'lockUserId',
			                        name: '<fmt:message>head.lock.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'updateVersion',
			                        name: '<fmt:message>head.updateVersion</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'updateUserId',
			                        name: '<fmt:message>head.update.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'updateTimestamp',
			                        name: '<fmt:message>head.update.timestamp</fmt:message>'
			                    }
			                ]
			            }
			        ]
			    }
			]);

			createPageObj.setPanelButtonList();

			createPageObj.panelConstructor(true);

			SaveImngObj.setConfig({
			    objectUri: '/igate/operation/object.json'
			});

			new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Operation.OperationType', orderByKey: true }, function (result) {
			    var properties = result.object;

			    window.vmSearch = new Vue({
			        el: '#' + createPageObj.getElementId('ImngSearchObject'),
			        data: {
			            pageSize: '10',
			            object: {
			                operationId: null,
			                operationName: null,
			                operationType: ' ',
			                operationGroup: null,
			                privilegeId: null,
			                operationDesc: null
			            },
			            letter: {
			                operationId: 0,
			                operationName: 0,
			                operationGroup: 0,
			                privilegeId: 0,
			                operationDesc: 0
			            },
			            operationTypeList: []
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
			                        new HttpReq('/igate/operation/rowCount.json').read(this.object, function (result) {
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

			                    this.object.operationId = null;
			                    this.object.operationName = null;
			                    this.object.operationType = ' ';
			                    this.object.operationGroup = null;
			                    this.object.privilegeId = null;
			                    this.object.operationDesc = null;

			                    this.letter.operationId = 0;
			                    this.letter.operationName = 0;
			                    this.letter.operationGroup = 0;
			                    this.letter.privilegeId = 0;
			                    this.letter.operationDesc = 0;
			                }

			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#operationTypeList'), this.object.operationType);
			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			            }
			        }),
			        created: function () {
			            this.operationTypeList = properties;
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
			                    SearchImngObj.clicked({
			                        operationId: loadParam.operationId
			                    });
			                },
			                searchUri: '/igate/operation/search.json',
			                viewMode: '${viewMode}',
			                popupResponse: '${popupResponse}',
			                popupResponsePosition: '${popupResponsePosition}',
			                columns: [
			                    {
			                        name: 'operationId',
			                        header: '<fmt:message>head.id</fmt:message>',
			                        align: 'left',
			                        width: '20%'
			                    },
			                    {
			                        name: 'operationName',
			                        header: '<fmt:message>head.name</fmt:message>',
			                        align: 'left',
			                        width: '20%'
			                    },
			                    {
			                        name: 'operationType',
			                        header: '<fmt:message>common.type</fmt:message>',
			                        align: 'center',
			                        width: '10%',
			                        formatter: function (obj) {
			                            var operationType = '';

			                            for (var i = 0; i < properties.length; i++) {
			                                if (obj.value == properties[i].pk.propertyKey) {
			                                    operationType = properties[i].propertyValue;
			                                    break;
			                                }
			                            }

			                            return operationType;
			                        }
			                    },
			                    {
			                        name: 'operationGroup',
			                        header: '<fmt:message>head.group</fmt:message>',
			                        align: 'left',
			                        width: '20%'
			                    },
			                    {
			                        name: 'privilegeId',
			                        header: '<fmt:message>common.privilege</fmt:message>',
			                        align: 'left',
			                        width: '20%'
			                    },
			                    {
			                        name: 'operationDesc',
			                        header: '<fmt:message>head.description</fmt:message>',
			                        align: 'left',
			                        width: '20%'
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
			                operationId: null,
			                operationName: null,
			                operationType: null,
			                privilegeId: null,
			                privateYn: null,
			                operationLogLevel: null,
			                xaTransactionAttribute: null,
			                operationGroup: null,
			                lockUserId: null,
			                updateVersion: null,
			                updateUserId: null,
			                updateTimestamp: null,
			                operationDesc: null,
			                operationRuleStr: null,
			                selectedOperation: null
			            },
			            letter: {
			                operationId: 0,
			                operationName: 0,
			                privilegeId: 0,
			                operationGroup: 0,
			                operationDesc: 0
			            },
			            panelMode: null,
			            operationTypeList: null,
			            privateYnList: [
			                { value: 'Y', name: 'Y' },
			                { value: 'N', name: 'N' }
			            ],
			            logLevelList: null,
			            xaTransactionAttributeList: [
			                { value: 'R', name: 'Required' },
			                { value: 'S', name: 'Supports' },
			                { value: 'M', name: 'Mandatory' },
			                { value: 'N', name: 'Requires New' },
			                { value: 'X', name: 'Not Supported' }
			            ]
			        },
			        computed: {
			            pk: function () {
			                return {
			                    operationId: this.object.operationId
			                };
			            }
			        },
			        created: function () {
			            this.operationTypeList = properties;

			            new HttpReq('/common/property/properties.json').read(
			                { propertyId: 'List.LogLevel', orderByKey: true },
			                function (result) {
			                    this.logLevelList = result.object;
			                }.bind(this)
			            );

			            if (localStorage.getItem('selectedOperation')) {
			                this.selectedOperation = JSON.parse(localStorage.getItem('selectedOperation'));
			                localStorage.removeItem('selectedOperation');

			                SearchImngObj.load($.param(this.selectedOperation));
			            }
			        },
			        methods: {
			            goDetailPanel: function () {
			                panelOpen(
			                    'detail',
			                    null,
			                    function () {
			                        if (this.selectedOperation) {
			                            $('#panel').find("[data-target='#panel']").trigger('click');
			                            $('#panel').find('#panel-header').find('.ml-auto').hide();
			                        }
			                    }.bind(this)
			                );
			            },
			            initDetailArea: function (object) {
			                if (object) {
			                    this.object = object;
			                } else {
			                    this.object.operationId = null;
			                    this.object.operationName = null;
			                    this.object.operationType = null;
			                    this.object.privilegeId = null;
			                    this.object.privateYn = null;
			                    this.object.operationLogLevel = null;
			                    this.object.xaTransactionAttribute = null;
			                    this.object.operationGroup = null;
			                    this.object.lockUserId = null;
			                    this.object.updateVersion = null;
			                    this.object.updateUserId = null;
			                    this.object.updateTimestamp = null;
			                    this.object.operationDesc = null;
			                    this.object.operationRuleStr = null;
			                }
			            },
			            loaded: function () {
			                window.vmOperationRuleStr.operationRuleStr = this.object.operationRuleStr;
			                window.vmWorkflow.jsonObj = JSON.parse(xml2json($.parseXML(this.object.operationRuleStr), ' '));

			                vmResourceInuseInfo.lockUserId = this.object.lockUserId;
			                vmResourceInuseInfo.updateVersion = this.object.updateVersion;
			                vmResourceInuseInfo.updateUserId = this.object.updateUserId;
			                vmResourceInuseInfo.updateTimestamp = this.object.updateTimestamp;
			            }
			        }
			    });

			    window.vmOperationRuleStr = new Vue({
			        el: '#OperationRuleStr',
			        data: {
			            operationRuleStr: null
			        }
			    });

			    window.vmWorkflow = new Vue({
			        el: '#Workflow',
			        data: {
			            jsonObj: null,
			            resize: null,
			            imgObj: {
			                Break: { imgName: 'break', img: null },
			                Case: { imgName: 'case', img: null },
			                Condition: { imgName: 'condition', img: null },
			                Continue: { imgName: 'continue', img: null },
			                End: { imgName: 'end', img: null },
			                FaultHandlers: { imgName: 'faultHandler', img: null },
			                ForEach: { imgName: 'for', img: null },
			                Fork: { imgName: 'fork', img: null },
			                Activity: {
			                    imgName: 'activity',
			                    img: null,
			                    imgCustom: null
			                },
			                Operation: { imgName: 'operation', img: null },
			                Query: { imgName: 'query', img: null },
			                InvokeActivity: { imgName: 'activity', img: null },
			                InvokeOperation: { imgName: 'operation', img: null },
			                ReThrow: { imgName: 'rethrow', img: null },
			                Start: { imgName: 'start', img: null },
			                Scope: { imgName: 'scope', img: null },
			                Script: { imgName: 'script', img: null },
			                Switch: { imgName: 'switch', img: null },
			                Throw: { imgName: 'throw', img: null },
			                While: { imgName: 'while', img: null },
			                Service: { imgName: 'service', img: null },
			                Response: { imgName: 'activity', img: null },
			                Default: { imgName: 'default', img: null }
			            },
			            isDetailExist: {
			                Script: true,
			                ForEach: true,
			                Operation: true,
			                InvokeOperation: true,
			                Activity: true,
			                InvokeActivity: true,
			                Fork: true,
			                Condition: true,
			                FaultHandlers: true,
			                Throw: true,
			                While: true,
			                Case: true,
			                Query: true,
			                Service: true,
			                Response: true
			            }
			        },
			        created: function () {
			            for (var key in this.imgObj) {
			                this.imgObj[key].img = new Image();
			                this.imgObj[key].img.src = '<c:url value="/img/operation/' + this.imgObj[key].imgName + '.png"/>';

			                if ('Activity' == key) {
			                    this.imgObj[key].imgCustom = new Image();
			                    this.imgObj[key].imgCustom.src = '<c:url value="/img/operation/activityCustom.png"/>';
			                }
			            }
			        },
			        watch: {
			            jsonObj: function () {
			                this.refreshWorkflow();
			            }
			        },
			        methods: {
			            refreshWorkflow: function () {
			                var cy = cytoscape({
			                    container: document.getElementById('topology')
			                });

			                var width = (height = 0);

			                var canvas = $(cy.container()).find('canvas')[2];

			                var ctx = $(cy.container()).find('canvas')[2].getContext('2d');

			                var nodes = [];
			                var edges = [];

			                var operation = this.jsonObj.Operation;

			                createTopology.call(ctx, this.jsonObj.Operation, nodes, edges);

			                edges.forEach(function (edgeInfo) {
			                    var info = nodes.filter(function (node) {
			                        return node.data.id == edgeInfo.data.source;
			                    })[0];

			                    if (
			                        'Start' == info.data.nodeType &&
			                        1 <
			                            edges.filter(function (tmpEdgeInfo) {
			                                return edgeInfo.data.source == tmpEdgeInfo.data.source;
			                            }).length
			                    ) {
			                        edgeInfo.data.value = edgeInfo.data.value ? edgeInfo.data.value : '#' + edgeInfo.data.orgData['@order'];
			                    } else if (
			                        'Script' == info.data.nodeType &&
			                        1 <
			                            edges.filter(function (tmpEdgeInfo) {
			                                return edgeInfo.data.source == tmpEdgeInfo.data.source;
			                            }).length
			                    ) {
			                        edgeInfo.data.value = edgeInfo.data.value ? edgeInfo.data.value : '#' + edgeInfo.data.orgData['@order'];
			                    } else if ('FaultHandlers' == info.data.nodeType) {
			                        edgeInfo.data.value = edgeInfo.data.value ? edgeInfo.data.value : '#' + edgeInfo.data.orgData['@order'];
			                    } else if (
			                        'Activity' == info.data.nodeType &&
			                        1 <
			                            edges.filter(function (tmpEdgeInfo) {
			                                return edgeInfo.data.source == tmpEdgeInfo.data.source;
			                            }).length
			                    ) {
			                        edgeInfo.data.value = edgeInfo.data.value ? '#' + edgeInfo.data.orgData['@order'] + ' ' + edgeInfo.data.value : '#' + edgeInfo.data.orgData['@order'];
			                    }
			                });

			                cy.add(nodes);
			                cy.add(edges);

			                cy.style()
			                    .selector('node')
			                    .style({
			                        width: function (e) {
			                            return ctx.measureText(e._private.data.name).width + 60;
			                        },
			                        height: '20',
			                        label: 'data(name)',
			                        'font-size': '12px',
			                        'text-valign': 'center',
			                        'text-halign': 'center',
			                        'background-color': '#fff',
			                        color: '#151826',
			                        'border-width': '1',
			                        'border-color': '#808080',
			                        'text-margin-x': '7px',
			                        shape: function (ele) {
			                            return 'round-rectangle';
			                        }
			                    })
			                    .selector('edge')
			                    .style({
			                        width: '1',
			                        'line-color': '#808080',
			                        'target-arrow-color': '#808080',
			                        'target-arrow-shape': 'triangle',
			                        'curve-style': 'bezier',
			                        label: 'data(value)',
			                        'font-size': '11px',
			                        color: '#151826'
			                    })
			                    .selector('node[isGroup="true"]')
			                    .style({
			                        'text-valign': 'top',
			                        'text-halign': 'center',
			                        'min-height': '150',
			                        padding: '5'
			                    })
			                    .update();

			                var activityInfoList = [];

			                var activityIdList = nodes
			                    .filter(function (node) {
			                        return 'Activity' == node.data.nodeType;
			                    })
			                    .map(function (node) {
			                        return node.data.orgData['@id'];
			                    });

			                if (0 < activityIdList.length) {
			                    $.ajax({
			                        type: 'GET',
			                        url: "<c:url value='/igate/activity/list.json' />",
			                        processData: false,
			                        data: (function () {
			                            var rtnParam = {};

			                            activityIdList.forEach(function (activityId, idx) {
			                                rtnParam['activityIdList[' + idx + ']'] = activityId;
			                            });

			                            return $.param(rtnParam);
			                        })(),
			                        dataType: 'json',
			                        success: function (result) {
			                            if ('ok' == result.result) {
			                                activityInfoList = result.object;
			                            }

			                            onRender();
			                        }
			                    });
			                } else {
			                    onRender();
			                }

			                var imgObj = this.imgObj;

			                function onRender() {
			                    cy.onRender(function () {
			                        cy.nodes().forEach(function (info) {
			                            width = Math.max(width, info._private.bodyBounds.x2 + info._private.bodyBounds.w);
			                            height = Math.max(height, info._private.bodyBounds.y2 + info._private.bodyBounds.h);
			                        });

			                        width = Math.max(width, $('#panel').find('.panel-body').width());
			                        height = Math.max(height, $('#panel').find('.panel-body').height());

			                        $('#topology').width(width).height(height);

			                        ctx.beginPath();

			                        cy.nodes().each(function (e, t) {
			                            if (e._private.data.nodeType) {
			                                var img = null;

			                                if ('Activity' == e._private.data.nodeType) {
			                                    var tmpActivityInfoList = activityInfoList.filter(function (activityInfo) {
			                                        return activityInfo.activityId == e._private.data.orgData['@id'];
			                                    });

			                                    img = 0 == tmpActivityInfoList.length || 'undefined' == typeof tmpActivityInfoList[0].activityProject ? imgObj[e._private.data.nodeType].img : imgObj[e._private.data.nodeType].imgCustom;
			                                } else {
			                                    img = imgObj[e._private.data.nodeType] ? imgObj[e._private.data.nodeType].img : imgObj['Default'].img;
			                                }

			                                ctx.drawImage(img, e._private.rscratch.labelX - e._private.rscratch.labelWidth / 2 - img.width + 5, e._private.rscratch.labelY - (0 == e._private.children.length ? img.height / 2 : img.height));
			                            }
			                        });

			                        ctx.closePath();

			                        if ($('#Workflow').hasClass('active') && 0 == $('#topology').find('canvas').width()) {
			                            setTimeout(function () {
			                                cy.resize();
			                            }, 0);
			                        }
			                    });
			                }

			                var isDetailExist = this.isDetailExist;

			                cy.on('tap', 'node', function (evt) {
			                    var nodeInfo = evt.target;

			                    var nodeType = nodeInfo._private.data.nodeType;

			                    if (!isDetailExist[nodeType]) return;

			                    if (nodeInfo.selected()) {
			                        if ('Query' == nodeInfo._private.data.nodeType || 'Service' == nodeInfo._private.data.nodeType || 'Response' == nodeInfo._private.data.nodeType) {
			                            var data = nodeInfo._private.data;
			                            var mappingId = null;

			                            for (var i = 0; i < data.orgData.Parameter.length; i++) {
			                                var desc = data.orgData.Parameter[i]['@desc'];

			                                if (-1 < desc.toLowerCase().indexOf('mapping')) {
			                                    mappingId = data.orgData.Parameter[i].Value['#cdata'];
			                                    break;
			                                }
			                            }

			                            if (mappingId) {
			                                $.ajax({
			                                    type: 'GET',
			                                    url: "<c:url value='/igate/mapping/object.json' />",
			                                    processData: false,
			                                    data: $.param({
			                                        mappingId: mappingId.substring(1, mappingId.length - 1)
			                                    }),
			                                    dataType: 'json',
			                                    success: function (result) {
			                                        if ('ok' == result.result) {
			                                            localStorage.removeItem('selectedRowMapping');
			                                            localStorage.setItem(
			                                                'selectedRowMapping',
			                                                JSON.stringify({
			                                                    mappingId: result.object.mappingId,
			                                                    mappingType: result.object.mappingType
			                                                })
			                                            );

			                                            window.open("<c:url value='/igate/mapping.html' />");
			                                        } else {
			                                            warnAlert({
			                                                message: result.error[0].className + (result.error[0].message ? '<hr/>' + result.error[0].message : ''),
			                                                isXSSMode: false
			                                            });
			                                        }
			                                    }
			                                });
			                            }
			                        } else {
			                            openModal(getDetailInfo(nodeInfo, cy));
			                        }
			                    }
			                });

			                this.resize = function () {
			                    setTimeout(function () {
			                        cy.resize();
			                    }, 0);
			                };

			                cy.userZoomingEnabled(false);
			                cy.userPanningEnabled(false);
			            }
			        }
			    });
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
			
			this.addEventListener('resize', customResizeFunc);
			
			function customResizeFunc(evt) {
			    if (window.vmWorkflow.resize) window.vmWorkflow.resize();
			}
			
			function createTopology(info, nodes, edges, parentNodeInfo) {
				var ctx = this;
				
				<%-- uuid --%>
				var uuid = (function () {
				    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
				        var r = (mathRandom() * 16) | 0,
				            v = c == 'x' ? r : (r & 0x3) | 0x8;
				        return v.toString(16);
				    });
				})();
				<%-- uuid --%>

				<%-- node --%>
				var childNodeSizeInfo = { minX: Number.MAX_SAFE_INTEGER, maxX: 0, minY: Number.MAX_SAFE_INTEGER, maxY: 0 };

				for (var key in info.Activities) {
				    var subInfo = info.Activities[key];

				    if (!subInfo) return;

				    var nodeInfoArr = Array.isArray(subInfo) ? subInfo : [subInfo];

				    nodeInfoArr.forEach(function (nodeInfo) {
				        nodes.push({
				            group: 'nodes',
				            data: {
				                id: nodeInfo['@index'] + '_' + uuid,
				                name: nodeInfo['@desc'],
				                nodeType: key,
				                orgData: $.extend(true, {}, nodeInfo)
				            },
				            position: {
				                x: Number(nodeInfo['@xPos']),
				                y: Number(nodeInfo['@yPos'])
				            }
				        });

				        if (!isNaN(nodeInfo['@index'])) {
				            nodes[nodes.length - 1].data.name += ' #' + nodeInfo['@index'];
				        }

				        nodes[nodes.length - 1].position.x += (ctx.measureText(nodes[nodes.length - 1].data.name).width + 60) / 2;
				        nodes[nodes.length - 1].position.y += 10;

				        if (nodeInfo.Activities) {
				            nodes[nodes.length - 1].position.y += 15;
				        }

				        if (parentNodeInfo) {
				            nodes[nodes.length - 1].data.parent = parentNodeInfo.data.id;
				            nodes[nodes.length - 1].position.x += parentNodeInfo.position.x;
				            nodes[nodes.length - 1].position.y += parentNodeInfo.position.y;

				            childNodeSizeInfo.minX = Math.min(childNodeSizeInfo.minX, nodes[nodes.length - 1].position.x);
				            childNodeSizeInfo.minY = Math.min(childNodeSizeInfo.minY, nodes[nodes.length - 1].position.y);
				            childNodeSizeInfo.maxX = Math.max(childNodeSizeInfo.maxX, nodes[nodes.length - 1].position.x);
				            childNodeSizeInfo.maxY = Math.max(childNodeSizeInfo.maxY, nodes[nodes.length - 1].position.y);
				        }

				        if (nodeInfo.Activities) {
				            nodes[nodes.length - 1].data.isGroup = 'true';

				            var tmpChildNodeSizeInfo = createTopology.call(ctx, nodeInfo, nodes, edges, $.extend(true, {}, nodes[nodes.length - 1]));

				            if (parentNodeInfo) {
				                childNodeSizeInfo.minX = Math.min(childNodeSizeInfo.minX, tmpChildNodeSizeInfo.minX);
				                childNodeSizeInfo.minY = Math.min(childNodeSizeInfo.minY, tmpChildNodeSizeInfo.minY);
				                childNodeSizeInfo.maxX = Math.max(childNodeSizeInfo.maxX, tmpChildNodeSizeInfo.maxX);
				                childNodeSizeInfo.maxY = Math.max(childNodeSizeInfo.maxY, tmpChildNodeSizeInfo.maxY);
				            }
				        }
				    });
				}

				if (parentNodeInfo) {
				    nodes.push({
				        group: 'nodes',
				        data: {
				            id: 'start_' + uuid,
				            name: 'Start',
				            nodeType: 'Start',
				            parent: parentNodeInfo.data.id
				        },
				        position: {
				            x: (childNodeSizeInfo.maxX + childNodeSizeInfo.minX) / 2,
				            y: parentNodeInfo.position.y
				        }
				    });

				    nodes.push({
				        group: 'nodes',
				        data: {
				            id: 'end_' + uuid,
				            name: 'End',
				            nodeType: 'End',
				            parent: parentNodeInfo.data.id
				        },
				        position: {
				            x: (childNodeSizeInfo.maxX + childNodeSizeInfo.minX) / 2,
				            y: childNodeSizeInfo.maxY + 40
				        }
				    });

				    childNodeSizeInfo.maxY += 40;
				}
				<%-- node --%>
				
				<%-- edge --%>
				if (info.Transitions) {
				    var transition = info.Transitions.Transition;

				    for (var i = 0; i < transition.length; i++) {
				        edges.push({
				            group: 'edges',
				            data: {
				                id: 'edge' + (i + 1) + '_' + uuid,
				                source: transition[i]['@from'] + '_' + uuid,
				                target: transition[i]['@to'] + '_' + uuid,
				                value: transition[i]['@desc'] ? transition[i]['@desc'] : '',
				                orgData: $.extend(true, {}, transition[i])
				            }
				        });
				    }
				}
				<%-- edge --%>
				
				if (parentNodeInfo) {
				    return childNodeSizeInfo;
				}
			}
			
			function getDetailInfo(nodeInfo, cy) {
			    var rtnObj = {
			        title: '',
			        bodyHtml: ''
			    };

			    var data = nodeInfo._private.data;

			    if ('Script' == data.nodeType) {
			        rtnObj.title = data.nodeType;
			        rtnObj.bodyHtml += '<div class="form-group">';
			        rtnObj.bodyHtml += '    <textarea class="form-control" style="width: 500px; height: 300px;" disabled="disabled">' + escapeHtml(data.orgData.Value['#cdata']) + '</textarea>';
			        rtnObj.bodyHtml += '</div>';
			    } else if ('While' == data.nodeType || 'Case' == data.nodeType) {
			        rtnObj.title = data.nodeType;
			        rtnObj.bodyHtml += '<div class="form-group">';
			        rtnObj.bodyHtml += '    <textarea class="form-control" style="width: 500px; height: 300px;" disabled="disabled">' + escapeHtml(data.orgData.Condition.Value['#cdata']) + '</textarea>';
			        rtnObj.bodyHtml += '</div>';
			    } else {
			        rtnObj.title = data.nodeType;

			        rtnObj.bodyHtml += '<div class="form-group"style="width: 700px;">';
			        rtnObj.bodyHtml += '    <div id="detailGrid"></div>';
			        rtnObj.bodyHtml += '</div>';

			        var detailGrid = null;

			        var settings = {
			            el: null,
			            data: [],
			            columns: null,
			            columnOptions: {
			                resizable: true
			            },
			            usageStatistics: false,
			            header: {
			                height: 32,
			                align: 'center'
			            },
			            onGridMounted: function () {
			                var resetColumnWidths = [];

			                detailGrid.getColumns().forEach(function (columnInfo) {
			                    if (!columnInfo.copyOptions) return;

			                    if (columnInfo.copyOptions.widthRatio) {
			                        resetColumnWidths.push($('#detailGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
			                    }
			                });

			                if (0 < resetColumnWidths.length) detailGrid.resetColumnWidths(resetColumnWidths);

			                $('#detailGrid').find('.tui-grid-column-resize-handle').removeAttr('title');
			            },
			            scrollX: false,
			            scrollY: false
			        };

			        if ('ForEach' == data.nodeType || 'Operation' == data.nodeType || 'InvokeOperation' == data.nodeType || 'Fork' == data.nodeType || 'Activity' == data.nodeType || 'InvokeActivity' == data.nodeType) {
			            settings.columns = [
			                { name: '@type', header: '<fmt:message>head.type</fmt:message>', width: '20%' },
			                { name: '@from', header: '<fmt:message>common.type</fmt:message>', width: '15%', align: 'center' },
			                { name: '@cdata', header: '<fmt:message>common.property.value</fmt:message>', width: '35%' },
			                { name: '@desc', header: '<fmt:message>common.desc</fmt:message>', width: '30%' }
			            ];

			            if ('Activity' == data.nodeType) {
			                if (data.orgData['@id']) rtnObj.title += '(id: ' + escapeHtml(data.orgData['@id']) + ')';
			            }

			            var parameterArr = Array.isArray(data.orgData.Parameter) ? data.orgData.Parameter : [data.orgData.Parameter];

			            settings.data = parameterArr.map(function (info) {
			                if (info) {
			                    info['@cdata'] = info.Value['#cdata'];
			                    return info;
			                } else {
			                    return { '@type': null, '@from': null, '@cdata': null, '@desc': null };
			                }
			            });
			        } else if ('FaultHandlers' == data.nodeType || 'Condition' == data.nodeType) {
			            var typeArr = null;

			            if ('FaultHandlers' == data.nodeType) {
			                settings.columns = [
			                    { name: '@type', header: '<fmt:message>common.type</fmt:message>', width: '30%' },
			                    { name: '@target', header: '<fmt:message>dashboard.head.target</fmt:message>', width: '30%' },
			                    { name: '@desc', header: '<fmt:message>common.desc</fmt:message>', width: '40%' }
			                ];

			                typeArr = ['Catch', 'CatchAll'];
			            } else if ('Condition' == data.nodeType) {
			                settings.columns = [
			                    { name: '@type', header: '<fmt:message>common.condition</fmt:message>', width: '30%' },
			                    { name: '@target', header: '<fmt:message>dashboard.head.target</fmt:message>', width: '30%' },
			                    { name: '@desc', header: '<fmt:message>common.desc</fmt:message>', width: '40%' }
			                ];

			                typeArr = ['When', 'Others'];
			            }

			            for (var i = 0; i < typeArr.length; i++) {
			                if (!data.orgData[typeArr[i]]) continue;

			                var orgDataArr = Array.isArray(data.orgData[typeArr[i]]) ? data.orgData[typeArr[i]] : [data.orgData[typeArr[i]]];

			                orgDataArr.forEach(function (tmpData) {
			                    var target = '';

			                    cy.edges('[source = "' + data.id + '"]').forEach(function (info) {
			                        if (tmpData['@target'] != info._private.data.target.split('_')[0]) return;

			                        var nodeInfo = cy.nodes('[id = "' + info._private.data.target + '"]');

			                        target = '[' + nodeInfo[0]._private.data.name + '] [' + nodeInfo[0]._private.data.orgData['@index'] + ']';
			                    });

			                    settings.data.push({ '@type': typeArr[i], '@target': target, '@desc': tmpData['@desc'] });
			                });
			            }
			        } else if ('Throw' == data.nodeType) {
			            settings.columns = [
			                { name: '@name', header: '<fmt:message>head.name</fmt:message>', width: '50%' },
			                { name: '@type', header: '<fmt:message>head.type</fmt:message>', width: '15%' },
			                { name: '@from', header: '<fmt:message>common.type</fmt:message>', width: '20%' },
			                { name: '@cdata', header: '<fmt:message>common.property.value</fmt:message>', width: '15%' }
			            ];

			            if (Array.isArray(data.orgData.Parameter)) {
			                rtnObj.title += ' ( <fmt:message>common.error.name</fmt:message> : ' + data.orgData.Parameter[0].Value['#cdata'] + ')';

			                settings.data = data.orgData.Parameter.slice(1).map(function (info, idx) {
			                    info['@cdata'] = info.Value['#cdata'];
			                    info['@name'] = 'arg # ' + (idx + 1) + ' [ ' + info['@type'] + ' (' + info['@desc'] + ') ] : (' + info['@from'] + ') ' + info.Value['#cdata'];
			                    return info;
			                });
			            }
			        }

			        settings.columns.forEach(function (column) {
			            if (!column.formatter) column.escapeHTML = true;

			            if (column.width && -1 < String(column.width).indexOf('%')) {
			                if (!column.copyOptions) column.copyOptions = {};

			                column.copyOptions.widthRatio = column.width.replace('%', '');

			                delete column.width;
			            }
			        });

			        rtnObj.shownCallBackFunc = function () {
			            settings.el = document.getElementById('detailGrid');

			            detailGrid = new tui.Grid(settings);

			            detailGrid.on('mouseover', function (ev) {
			                if ('cell' != ev.targetType) return;

			                var overCellElement = $(detailGrid.getElement(ev.rowKey, ev.columnName));
			                overCellElement.attr('title', overCellElement.text());
			            });
			        };
			    }

			    return rtnObj;
			}
		});	
	</script>
</body>
</html>