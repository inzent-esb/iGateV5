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
	<div id="adapterControl" data-ready>
		<sec:authorize var="hasAdapterControl" access="hasRole('AdapterControl')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
	
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#adapterControl').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasAdapterControl}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('adapterControl');
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
			        name: '<fmt:message>head.queue</fmt:message> <fmt:message>head.info</fmt:message>',
			        mappingDataInfo: {
			            id: 'statusInfoList',
			            selectModel: 'object.statusInfo',
			            optionFor: 'option in statusInfoList',
			            optionValue: 'option',
			            optionText: 'option'
			        },
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>head.queue</fmt:message> <fmt:message>head.mode</fmt:message>',
			        mappingDataInfo: {
			            id: 'queueModeList',
			            selectModel: 'object.queueMode',
			            optionFor: 'option in queueModeList',
			            optionValue: 'option.value',
			            optionText: 'option.text'
			        },
			        placeholder: '<fmt:message>head.all</fmt:message>'
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
			        mappingDataInfo: 'object.adapterDesc',
			        regExpType: 'desc',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor(true);

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCount: viewer,
			    startBtn: viewer,
			    stopBtn: viewer
			});

			createPageObj.mainConstructor();

			SaveImngObj.setConfig({
			    objectUri: '/igate/adapterControl/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/adapterControl/control.json'
			});

			new HttpReq('/igate/instance/list.json').read(null, function (instanceIdResult) {
				window.vmSearch = new Vue({
				    el: '#' + createPageObj.getElementId('ImngSearchObject'),
				    data: {
				        object: {
				            instanceId: ' ',
				            statusInfo: ' ',
				            queueMode: ' ',
				            adapterId: null,
				            adapterDesc: null
				        },
				        letter: {
				            adapterId: 0,
				            adapterDesc: 0
				        },
				        instanceIdList: [],
				        statusInfoList: ['Down', 'Starting', 'Stopping', 'Fail', 'Warn', 'Normal', 'Undeployed'],
				        queueModeList: [
				            { text: 'File', value: 'F' },
				            { text: 'DB', value: 'D' },
				            { text: 'Memory', value: 'M' },
				            { text: 'Shared', value: 'S' }
				        ]
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
				                this.object.instanceId = ' ';
				                this.object.statusInfo = ' ';
				                this.object.queueMode = ' ';
				                this.object.adapterId = null;
				                this.object.adapterDesc = null;

				                this.letter.adapterId = 0;
				                this.letter.adapterDesc = 0;
				            }

				            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceIdList'), this.object.instanceId);
				            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statusInfoList'), this.object.statusInfo);
				            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#queueModeList'), this.object.queueMode);
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
				    	this.instanceIdList = instanceIdResult.object;
				    	
		                this.$nextTick(function () {
		                	this.initSearchArea();
		                }.bind(this));
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
				        },
				        start: function () {
				            ControlImngObj.gridControl('start', function (row) {
				                return { adapterId: row.queueId, instance: row.instanceId };
				            });
				        },
				        stop: function () {
				            ControlImngObj.gridControl('stop', function (row) {
				                return { adapterId: row.queueId, instance: row.instanceId };
				            });
				        }
				    }),
				    mounted: function () {
				        this.makeGridObj = getMakeGridObj();

				        this.makeGridObj.setConfig({
				            elementId: createPageObj.getElementId('ImngSearchGrid'),
				            onGridMounted: function (evt) {
				                evt.instance.on('click', function (ev) {
				                    if (' ' === ev.instance.getFormattedValue(ev.rowKey, 'processResult') || 'processResult' !== ev.columnName || 'columnHeader' == ev.targetType) return;

				                    window.$alert({
				                        type: 'normal',
				                        message: ev.instance.getFormattedValue(ev.rowKey, 'processResult')
				                    });
				                });
				            },
				            searchUri: '/igate/adapterControl/searchSnapshot.json',
				            viewMode: '${viewMode}',
				            popupResponse: '${popupResponse}',
				            popupResponsePosition: '${popupResponsePosition}',
				            rowHeaders: ['checkbox'],
				            header: {
				                height: 60,
				                complexColumns: [
				                    {
				                        name: 'consumerInfo',
				                        header: '<fmt:message>igate.adapterControl.consumerInfo</fmt:message>',
				                        childNames: ['consumerCount', 'consumerMax']
				                    },
				                    {
				                        name: 'messageInfo',
				                        header: '<fmt:message>igate.adapterControl.messageInfo</fmt:message>',
				                        childNames: ['messageCount', 'messageMax']
				                    }
				                ]
				            },
				            columns: [
				                {
				                    name: 'instanceId',
				                    header: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
				                    align: 'left',
				                    width: '10%'
				                },
				                {
				                    name: 'status',
				                    header: '<fmt:message>head.queue</fmt:message> <fmt:message>head.status</fmt:message>',
				                    align: 'center',
				                    width: '10%',
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
				                        } else if (info.row.status == 'Undeployed') {
				                            backgroundColor = '#4e464f';
				                            fontColor = 'white';
				                        }

				                        return '<div style="width:100%; height:100%; background-color:' + backgroundColor + ';color:' + fontColor + ';">' + info.row.status.toString() + '</div>';
				                    }
				                },
				                {
				                    name: 'queueMode',
				                    header: '<fmt:message>head.queue</fmt:message> <fmt:message>head.mode</fmt:message>',
				                    align: 'center',
				                    width: '5%',
				                    formatter: function (info) {
				                        if (info.row.queueMode == 'F') return 'File';
				                        else if (info.row.queueMode == 'D') return 'DB';
				                        else if (info.row.queueMode == 'M') return 'Memory';
				                        else if (info.row.queueMode == 'S') return 'Shared';
				                    }
				                },
				                {
				                    name: 'queueId',
				                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
				                    align: 'left',
				                    width: '10%'
				                },
				                {
				                    name: 'adapterDesc',
				                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>',
				                    align: 'left',
				                    width: '10%'
				                },
				                {
				                    name: 'consumerCount',
				                    header: '<fmt:message>igate.queue.consumerCount</fmt:message>',
				                    align: 'right',
				                    width: '10%',
				                    formatter: function (info) {
				                        return numberWithComma(info.row.consumerCount);
				                    }
				                },
				                {
				                    name: 'consumerMax',
				                    header: '<fmt:message>igate.queue.consumerMax</fmt:message>',
				                    align: 'right',
				                    width: '10%',
				                    formatter: function (info) {
				                        return numberWithComma(info.row.consumerMax);
				                    }
				                },
				                {
				                    name: 'messageCount',
				                    header: '<fmt:message>igate.queue.messageCount</fmt:message>',
				                    align: 'right',
				                    width: '10%',
				                    formatter: function (info) {
				                        return numberWithComma(info.row.messageCount);
				                    }
				                },
				                {
				                    name: 'messageMax',
				                    header: '<fmt:message>igate.queue.messageMax</fmt:message>',
				                    align: 'center',
				                    width: '10%',
				                    formatter: function (info) {
				                        if (info.row.messageMax == '2147483647') return 'MAX';
				                        else return numberWithComma(info.row.messageMax);
				                    }
				                },
				                {
				                    name: 'processResult',
				                    header: '<fmt:message>head.process.result</fmt:message>',
				                    defaultValue: ' ',
				                    width: '15%'
				                }
				            ]
				        });

				        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
				        
				        this.newTabSearchGrid();
				    }
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