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
	<div id="connectorControl" data-ready>
		<sec:authorize var="hasConnectorControl" access="hasRole('ConnectorControl')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
	
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#connectorControl').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasConnectorControl}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('connectorControl');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'select',
			        name: '<fmt:message>igate.instance</fmt:message>',
			        mappingDataInfo: {
			            id: 'instanceIdList',
			            selectModel: 'object.instanceId',
			            optionFor: 'option in instanceIdList',
			            optionValue: 'option.instanceId',
			            optionText: 'option.instanceId',
			            optionIf: 'option.instanceType == "T"'
			        },
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>head.status</fmt:message> <fmt:message>head.info</fmt:message>',
			        mappingDataInfo: {
			            id: 'statusInfoList',
			            selectModel: 'object.statusInfo',
			            optionFor: 'option in statusInfoList',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        },
			        placeholder: '<fmt:message>head.all</fmt:message>'
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
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/connectorModal',
			            modalTitle: '<fmt:message>igate.connector</fmt:message>',
			            vModel: 'object.connectorId',
			            callBackFuncName: 'setSearchConnectorId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.connectorName',
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.socketAddress',
			        regExpType: 'searchId',
			        name: 'Socket Address',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.socketPortSnapshot',
			        regExpType: 'searchId',
			        name: 'Socket Port',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.connectorDesc',
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor(true);

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCnt: viewer,
			    startBtn: viewer,
			    stopBtn: viewer,
			    stopForceBtn: viewer,
			    interruptBtn: viewer,
			    blockBtn: viewer,
			    unblockBtn: viewer
			});

			createPageObj.mainConstructor();

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/connector/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/connector/control',
			    dumpUrl: '/api/entity/connector/dump'
			});
			
			
			new HttpReq('/api/entity/instance/search').read({ object: {}, limit: null, next: null, reverseOrder: false }, function (instanceIdResult) {
				new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Connector.StatusInfo' }, orderByKey: true }, function (statusInfoResult) {
	    			window.vmSearch = new Vue({
	    			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
	    			    data: {
	    			        object: {
	    			            instanceId: ' ',
	    			            statusInfo: ' ',
	    			            adapterId: null,
	    			            connectorId: null,
	    			            connectorName: null,
	    			            socketAddress: null,
	    			            socketPortSnapshot: null
	    			        },
	    			        letter: {
	    			            adapterId: 0,
	    			            connectorId: 0,
	    			            connectorName: 0,
	    			            socketAddress: 0,
	    			            socketPortSnapshot: 0
	    			        },
	    			        instanceIdList: [],
	    			        statusInfoList: []
	    			    },
	    			    methods: $.extend(true, {}, searchMethodOption, {
	    			        inputEvt: function (info) {
	    			            setLengthCnt.call(this, info);
	    			        },
	    			        search: function () {
	    			            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

	    			            vmList.makeGridObj.search(this.object, function(info) {
	    			            	vmList.totalCnt = numberWithComma(info.totalCnt);
	    			            });
	    			        },
	    			        initSearchArea: function (searchCondition) {
	    			            if (searchCondition) {
	    			                for (var key in searchCondition) {
	    			                    this.$data[key] = searchCondition[key];
	    			                }
	    			            } else {
	    			                this.object.instanceId = ' ';
	    			                this.object.statusInfo = ' ';
	    			                this.object.adapterId = null;
	    			                this.object.connectorId = null;
	    			                this.object.connectorName = null;
	    			                this.object.socketAddress = null;
	    			                this.object.socketPortSnapshot = null;

	    			                this.letter.adapterId = 0;
	    			                this.letter.connectorId = 0;
	    			                this.letter.connectorName = 0;
	    			                this.letter.socketAddress = 0;
	    			                this.letter.socketPortSnapshot = 0;
	    			            }

	    			            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceIdList'), this.object.instanceId);
	    			            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statusInfoList'), this.object.statusInfo);
	    			        },
	    			        openModal: function (openModalParam, regExpInfo) {
	    			            createPageObj.openModal.call(this, openModalParam, regExpInfo);
	    			        },
	    			        setSearchInstanceId: function (param) {
	    			            this.object.instanceId = param.instanceId;
	    			        },
	    			        setSearchAdapterId: function (param) {
	    			            this.object.adapterId = param.adapterId;
	    			        },
	    			        setSearchConnectorId: function (param) {
	    			            this.object.connectorId = param.connectorId;
	    			        }
	    			    }),
	    			    mounted: function () {
	                        this.instanceIdList = instanceIdResult.object;
	                        this.statusInfoList = statusInfoResult.object;
	                        
	                        this.$nextTick(function() {
	                        	this.initSearchArea();	
	                        }.bind(this));
	    			    }
	    			});

	    			window.vmList = new Vue({
	    			    el: '#' + createPageObj.getElementId('ImngListObject'),
	    			    data: {
	    			        makeGridObj: null,
	    			        totalCnt: null,
	    			        searchUrl: '/api/entity/connector/snapshot',
	    			        controlParams: function (row) {
	    			            return { connectorId: row.connectorId, instance: row.instanceId };
	    			        }
	    			    },
	    			    methods: $.extend(true, {}, listMethodOption, {
	    			        initSearchArea: function () {
	    			            window.vmSearch.initSearchArea();
	    			        },
	    			        start: function () {
	    			            ControlImngObj.gridControl('start', this.controlParams);
	    			        },
	    			        stop: function () {
	    			            ControlImngObj.gridControl('stop', this.controlParams);
	    			        },
	    			        block: function () {
	    			            ControlImngObj.gridControl('block', this.controlParams);
	    			        },
	    			        unblock: function () {
	    			            ControlImngObj.gridControl('unblock', this.controlParams);
	    			        },
	    			        interrupt: function () {
	    			            ControlImngObj.gridControl('interrupt', this.controlParams);
	    			        },
	    			        stopForce: function () {
	    			        	window._confirm({
	    			                type: 'warn',
	    			                message: '<fmt:message>igate.control.stopForce.alert</fmt:message>',
	    			                callBackFunc: function () {
	    			                    ControlImngObj.gridControl('stopForce', this.controlParams);
	    			                }.bind(this)
	    			            });
	    			        }
	    			    }),
	    			    mounted: function () {
	    			        this.makeGridObj = getMakeGridObj();

	    			        this.makeGridObj.setConfig({
	    			        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
	    			            searchUrl: this.searchUrl,
	    			    		paging: {
	    			    			isUse: false
	    			    		},	    			            
	    			            rowHeaders: ['checkbox'],
	    			            header: {
	    			                height: 60,
	    			                complexColumns: [
	    			                    {
	    			                        name: 'sessioninfo',
	    			                        header: '<fmt:message>igate.connectorControl.session</fmt:message> <fmt:message>head.info</fmt:message>',
	    			                        childNames: ['sessionCount', 'sessionInuse', 'sessionMaxCount']
	    			                    },
	    			                    {
	    			                        name: 'threadinfo',
	    			                        header: '<fmt:message>igate.connectorControl.threadInfo</fmt:message>',
	    			                        childNames: ['threadCount', 'threadInuse', 'threadMax']
	    			                    }
	    			                ]
	    			            },
	    			            columns: [
	    			                {
	    			                    name: 'instanceId',
	    			                    header: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
	    			                    align: 'left',
	    			                    width: '7%'
	    			                },
	    			                {
	    			                    name: 'status',
	    			                    header: '<fmt:message>head.status</fmt:message> <fmt:message>head.info</fmt:message>',
	    			                    align: 'center',
	    			                    width: '7%',
	    			                    formatter: function (info) {
	    			                        var backgroundColor = '';
	    			                        var fontColor = '#151826';

	    			                        if (info.row.status == 'Down') {
	    			                            backgroundColor = '';
	    			                        } else if (info.row.status == 'Normal') {
	    			                            backgroundColor = '#62d36f';
	    			                            fontColor = 'white';
	    			                        } else if (info.row.status == 'Starting') {
	    			                            backgroundColor = '';
	    			                        } else if (info.row.status == 'Stoping') {
	    			                            backgroundColor = '';
	    			                        } else if (info.row.status == 'Error') {
	    			                            backgroundColor = '#ed3137';
	    			                            fontColor = 'white';
	    			                        } else if (info.row.status == 'Fail') {
	    			                            backgroundColor = '#9932a1';
	    			                            fontColor = 'white';
	    			                        } else if (info.row.status == 'Warn') {
	    			                            backgroundColor = '#b7bf22';
	    			                            fontColor = 'white';
	    			                        } else if (info.row.status == 'Blocking') {
	    			                            backgroundColor = '#4e464f';
	    			                            fontColor = 'white';
	    			                        }
	    			                        
	    			                        var titleArr = [];
	    			                        
	    			                        if (info.row.statusCause) {
	    			                        	info.row.statusCause.split('\n').forEach(function(msg) {
	    			                        		titleArr.push(escapeHtml(msg));
	    			                        	});
	    			                        }

	    			                        return '<div title="' + titleArr.join('\n') + '" style="width:100%; height:100%; background-color:' + backgroundColor + ';color:' + fontColor + ';">' + info.row.status.toString() + '</div>';
	    			                    }
	    			                },
	    			                {
	    			                    name: 'adapterId',
	    			                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
	    			                    align: 'left',
	    			                    width: '7%'
	    			                },
	    			                {
	    			                    name: 'connectorId',
	    			                    header: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
	    			                    align: 'left',
	    			                    width: '11%'
	    			                },
	    			                {
	    			                    name: 'connectorName',
	    			                    header: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>',
	    			                    align: 'left',
	    			                    width: '10%'
	    			                },
	    			                {
	    			                    name: 'socketAddress',
	    			                    header: 'Socket Address',
	    			                    align: 'left',
	    			                    width: '10%'
	    			                },
	    			                {
	    			                    name: 'socketPort',
	    			                    header: 'Socket Port',
	    			                    align: 'center',
	    			                    width: '5%'
	    			                },
	    			                {
	    			                    name: 'connectorDesc',
	    			                    header: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>',
	    			                    align: 'left',
	    			                    width: '10%'
	    			                },
	    			                {
	    			                    name: 'sessionCount',
	    			                    header: '<fmt:message>igate.connectorControl.create</fmt:message>',
	    			                    align: 'right',
	    			                    width: '3%',
	    			                    formatter: function (info) {
	    			                        return numberWithComma(info.row.sessionCount);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'sessionInuse',
	    			                    header: '<fmt:message>igate.connectorControl.inuse</fmt:message>',
	    			                    align: 'right',
	    			                    width: '5%',
	    			                    formatter: function (info) {
	    			                        return numberWithComma(info.row.sessionInuse);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'sessionMaxCount',
	    			                    header: '<fmt:message>igate.connectorControl.max</fmt:message>',
	    			                    align: 'right',
	    			                    width: '3%',
	    			                    formatter: function (info) {
	    			                        if (info.row.sessionMaxCount == '2147483647') return 'MAX';
	    			                        else return numberWithComma(info.row.sessionMaxCount);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'threadCount',
	    			                    header: '<fmt:message>igate.connectorControl.create</fmt:message>',
	    			                    align: 'right',
	    			                    width: '3%',
	    			                    formatter: function (info) {
	    			                        return numberWithComma(info.row.threadCount);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'threadInuse',
	    			                    header: '<fmt:message>igate.connectorControl.inuse</fmt:message>',
	    			                    align: 'right',
	    			                    width: '3%',
	    			                    formatter: function (info) {
	    			                        return numberWithComma(info.row.threadInuse);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'threadMax',
	    			                    header: '<fmt:message>igate.connectorControl.max</fmt:message>',
	    			                    align: 'right',
	    			                    width: '3%',
	    			                    formatter: function (info) {
	    			                        if (info.row.threadMax == '2147483647') return 'MAX';
	    			                        else return numberWithComma(info.row.threadMax);
	    			                    }
	    			                },
	    			                {
	    			                    name: 'processResult',
	    			                    header: '<fmt:message>head.process.result</fmt:message>',
	    			                    defaultValue: ' ',
	    			                    width: '15%'
	    			                }
	    			            ],
	    			            onGridMounted: function (evt) {
	    			                displayBlock();

	    			                evt.instance.on('checkAll', function (ev) {
	    			                    displayBlock(ev.instance.getCheckedRows());
	    			                });

	    			                evt.instance.on('uncheckAll', function () {
	    			                    displayBlock();
	    			                });

	    			                evt.instance.on('click', function (ev) {
	    			                    if ('columnHeader' === ev.targetType) return;

	    			                    displayBlock(ev.instance.getCheckedRows());

	    			                    if ('processResult' !== ev.columnName || ' ' === ev.instance.getFormattedValue(ev.rowKey, 'processResult')) return;

	    			                    window._alert({
	    			                        type: 'normal',
	    			                        message: ev.instance.getFormattedValue(ev.rowKey, 'processResult')
	    			                    });
	    			                });

	    			                function displayBlock(rows) {
	    			                    var checkedRows = rows ? rows : [];
	    			                    var display =
	    			                        0 === checkedRows.length
	    			                            ? false
	    			                            : checkedRows.every(function (info) {
	    			                                  return 'O' === info.requestDirection || 'B' === info.requestDirection;
	    			                              });

	    			                    $('#' + createPageObj.getElementId('ImngListObject'))
	    			                        .find('#blockBtn')
	    			                        .css('display', display ? 'block' : 'none');
	    			                    $('#' + createPageObj.getElementId('ImngListObject'))
	    			                        .find('#unblockBtn')
	    			                        .css('display', display ? 'block' : 'none');
	    			                }
	    			            },
	    			        });

	    			        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
	    			        SearchImngObj.searchUrl = this.searchUrl;

	    			        this.newTabSearchGrid();
	    			    }
	    			});	        			
	        	});
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