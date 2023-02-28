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
	<div id="exceptionLog" data-ready>
		<sec:authorize var="hasExceptionLogViewer" access="hasRole('ExceptionLogViewer')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#exceptionLog').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasExceptionLogViewer}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('exceptionLog');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'daterange',
			        mappingDataInfo: {
			            daterangeInfo: [
			                {
			                    id: 'fromExceptionDateTime',
			                    name: '<fmt:message>head.from</fmt:message>'
			                },
			                {
			                    id: 'toExceptionDateTime',
			                    name: '<fmt:message>head.to</fmt:message>'
			                }
			            ]
			        }
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.transactionId',
			        regExpType: 'searchId',
			        name: '<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
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
			        mappingDataInfo: 'object.pk.exceptionId',
			        name: '<fmt:message>igate.exceptionLog</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.exceptionCode',
			        name: '<fmt:message>igate.exceptionCode</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/interfaceModal.html',
			            modalTitle: '<fmt:message>igate.interface</fmt:message>',
			            vModel: 'object.interfaceId',
			            callBackFuncName: 'setSearchInterfaceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/serviceModal.html',
			            modalTitle: '<fmt:message>igate.service</fmt:message>',
			            vModel: 'object.serviceId',
			            callBackFuncName: 'setSearchServiceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/instanceModal.html',
			            modalTitle: '<fmt:message>igate.instance</fmt:message>',
			            vModel: 'object.instanceId',
			            callBackFuncName: 'setSearchInstanceId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/connectorModal.html',
			            modalTitle: '<fmt:message>igate.connector</fmt:message>',
			            vModel: 'object.connectorId',
			            callBackFuncName: 'setSearchConnectorId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/activityModal.html',
			            modalTitle: '<fmt:message>igate.activity</fmt:message>',
			            vModel: 'object.activityId',
			            callBackFuncName: 'setSearchActivityId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    refreshArea: viewer,
			    searchInitBtn: viewer,
			    downloadBtn: viewer,
			    refreshBtn: viewer,
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
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.pk.exceptionDateTime',
			                        name: '<fmt:message>igate.exceptionLog.exceptionDateTime</fmt:message>',
			                        isPk: true,
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.pk.exceptionLog',
			                        name: '<fmt:message>igate.exceptionLog</fmt:message> <fmt:message>head.id</fmt:message>',
			                        isPk: true,
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.exceptionCode',
			                        name: '<fmt:message>igate.exceptionCode</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.instanceId',
			                        name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'textEvt',
			                        mappingDataInfo: 'object.transactionId',
			                        name: '<fmt:message>igate.exceptionLog.transactionId</fmt:message>',
			                        clickEvt: 'clickTransactionId({"transactionId" : object.transactionId})',
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.messageId',
			                        name: '<fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.interfaceId',
			                        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceId',
			                        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-4',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.adapterId',
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.connectorId',
			                        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.activityId',
			                        name: '<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.exceptionText',
			                        name: '<fmt:message>igate.exceptionLog.exceptionText</fmt:message>',
			                        regExpType: 'desc',
			                        height: 100
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'basic',
			        id: 'ExceptionStack',
			        name: '<fmt:message>igate.exceptionLog.exceptionStack</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.exceptionStack',
			                        name: '<fmt:message>igate.exceptionLog.exceptionText</fmt:message>',
			                        height: 300
			                    }
			                ]
			            }
			        ]
			    }
			]);

			createPageObj.setPanelButtonList();

			createPageObj.panelConstructor(true);

			SaveImngObj.setConfig({
			    objectUri: '/igate/exceptionLog/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/exceptionLog/control.json'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			        pageSize: '10',
			        object: {
			            pk: {
			                exceptionId: null
			            },
			            fromExceptionDateTime: null,
			            toExceptionDateTime: null,
			            transactionId: null,
			            adapterId: null,
			            exceptionCode: null,
			            interfaceId: null,
			            serviceId: null,
			            instanceId: null,
			            connectorId: null,
			            activityId: null
			        },
			        letter: {
			            pk: {
			                exceptionId: 0
			            },
			            transactionId: 0,
			            adapterId: 0,
			            exceptionCode: 0,
			            interfaceId: 0,
			            serviceId: 0,
			            instanceId: 0,
			            connectorId: 0,
			            activityId: 0
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
			                    new HttpReq('/igate/exceptionLog/rowCount.json').read(this.object, function (result) {
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

			                this.object.pk.exceptionId = null;
			                this.object.fromExceptionDateTime = null;
			                this.object.toExceptionDateTime = null;
			                this.object.transactionId = null;
			                this.object.adapterId = null;
			                this.object.exceptionCode = null;
			                this.object.interfaceId = null;
			                this.object.serviceId = null;
			                this.object.instanceId = null;
			                this.object.connectorId = null;
			                this.object.activityId = null;

			                this.letter.pk.exceptionId = 0;
			                this.letter.fromExceptionDateTime = 0;
			                this.letter.toExceptionDateTime = 0;
			                this.letter.transactionId = 0;
			                this.letter.adapterId = 0;
			                this.letter.exceptionCode = 0;
			                this.letter.interfaceId = 0;
			                this.letter.serviceId = 0;
			                this.letter.instanceId = 0;
			                this.letter.connectorId = 0;
			                this.letter.activityId = 0;
			            }

			            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);

			            this.initDatePicker();
			        },
			        initDatePicker: function () {
			            var fromExceptionDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#fromExceptionDateTime');
			            var toExceptionDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#toExceptionDateTime');

			            fromExceptionDateTime.customDateRangePicker(
			                'from',
			                function (fromExceptionDateTime) {
			                    this.object.fromExceptionDateTime = fromExceptionDateTime;

			                    toExceptionDateTime.customDateRangePicker(
			                        'to',
			                        function (toExceptionDateTime) {
			                            this.object.toExceptionDateTime = toExceptionDateTime;
			                        }.bind(this),
			                        {
			                            startDate: this.object.toExceptionDateTime,
			                            minDate: fromExceptionDateTime
			                        }
			                    );
			                }.bind(this),
			                {
			                    startDate: this.object.fromExceptionDateTime
			                }
			            );
			        },
			        openModal: function (openModalParam, regExpInfo) {
			            if (-1 < openModalParam.vModel.indexOf('instanceId')) {
			                openModalParam.modalParam = {
			                    instanceType: 'T'
			                };
			            }

			            createPageObj.openModal.call(this, openModalParam, regExpInfo);
			        },
			        setSearchAdapterId: function (param) {
			            this.object.adapterId = param.adapterId;
			        },
			        setSearchConnectorId: function (param) {
			            this.object.connectorId = param.connectorId;
			        },
			        setSearchInterfaceId: function (param) {
			            this.object.interfaceId = param.interfaceId;
			        },
			        setSearchServiceId: function (param) {
			            this.object.serviceId = param.serviceId;
			        },
			        setSearchInstanceId: function (param) {
			            this.object.instanceId = param.instanceId;
			        }
			    }),
			    mounted: function () {
			        this.initSearchArea();
			    }
			});

			var vmList = new Vue({
			    el: '#' + createPageObj.getElementId('ImngListObject'),
			    data: {
			        makeGridObj: null,
			        totalCount: '0',
			        timerSeconds: 60,
			        displayTimerSeconds: 60,
			        timerSecondsList: [10, 20, 30, 40, 50, 60],
			        isStartRefresh: false,
			        refreshIntervalId: null,
			        exportArr: ['fromExceptionDateTime', 'toExceptionDateTime', 'transactionId', 'adapterId', 'exceptionCode', 'interfaceId', 'serviceId', 'logCode', 'instanceId', 'connectorId', 'activityId']
			    },
			    methods: $.extend(true, {}, listMethodOption, {
			        initSearchArea: function () {
			            window.vmSearch.initSearchArea();
			        },
			        downloadFile: function () {
			            var excelForm = document.createElement('form');

			            this.exportArr.forEach(function (key) {
			                var hiddenField = document.createElement('input');

			                hiddenField.setAttribute('type', 'hidden');
			                hiddenField.setAttribute('name', key);

			                var object = window.vmSearch.object;
			                var value = null;

			                if ('object' === typeof object[key]) object = object[key];
			                else value = object[key];

			                hiddenField.setAttribute('value', null === value ? '' : value);

			                excelForm.appendChild(hiddenField);
			            });

			            var data = new FormData(excelForm);

			            window.$startSpinner();

			            var req = new XMLHttpRequest();

			            req.open('POST', '${prefixUrl}/igate/exceptionLog/exportExcel.json', true);

			            var csrfToken = JSON.parse(localStorage.getItem('csrfToken'));
			            req.setRequestHeader(csrfToken.headerName, csrfToken.token);

			            req.withCredentials = true;

			            req.responseType = 'blob';
			            req.send(data);

			            req.onload = function () {
			                window.$stopSpinner();

			                var blob = req.response;
			                var file_name = '<fmt:message>igate.exceptionLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_' + Date.now() + '.xlsx';

			                if (blob.size <= 0) {
			                    window._alert({
			                        type: 'warn',
			                        message: '<fmt:message>head.fail.notice</fmt:message>'
			                    });
			                    return;
			                }

			                if (window.navigator && window.navigator.msSaveOrOpenBlob) {
			                    window.navigator.msSaveOrOpenBlob(blob, file_name);
			                } else {
			                    var link = document.createElement('a');
			                    link.href = window.URL.createObjectURL(blob);
			                    link.download = file_name;
			                    link.click();
			                    URL.revokeObjectURL(link.href);
			                    link.remove();
			                }
			            };
			        },
			        refresh: function () {
			            this.isStartRefresh = !this.isStartRefresh;
			            if (this.isStartRefresh) {
			                this.displayTimerSeconds = this.timerSeconds;

			                this.refreshIntervalId = setInterval(
			                    function () {
			                        if (0 == $('#' + createPageObj.getElementId('ImngListObject')).length) {
			                            clearInterval(this.refreshIntervalId);
			                            return;
			                        }

			                        if (0 >= this.displayTimerSeconds) {
			                            this.displayTimerSeconds = this.timerSeconds;
			                            window.vmSearch.search();
			                        } else {
			                            --this.displayTimerSeconds;
			                        }
			                    }.bind(this),
			                    1000
			                );
			            } else {
			                clearInterval(this.refreshIntervalId);
			            }
			        }
			    }),
			    mounted: function () {
			        this.makeGridObj = getMakeGridObj();

			        this.makeGridObj.setConfig({
			            elementId: createPageObj.getElementId('ImngSearchGrid'),
			            onClick: function (loadParam) {
			                SearchImngObj.clicked({
			                    'pk.exceptionDateTime': loadParam['pk.exceptionDateTime'],
			                    'pk.exceptionId': loadParam['pk.exceptionId']
			                });
			            },
			            searchUri: '/igate/exceptionLog/search.json',
			            viewMode: '${viewMode}',
			            popupResponse: '${popupResponse}',
			            popupResponsePosition: '${popupResponsePosition}',
			            columns: [
			                {
			                    name: 'pk.exceptionDateTime',
			                    header: '<fmt:message>igate.exceptionLog.exceptionDateTime</fmt:message>'
			                },
			                {
			                    name: 'transactionId',
			                    header: '<fmt:message>igate.exceptionLog.transactionId</fmt:message>'
			                },
			                {
			                    name: 'adapterId',
			                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'exceptionCode',
			                    header: '<fmt:message>igate.exceptionCode</fmt:message>'
			                },
			                {
			                    name: 'interfaceId',
			                    header: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'serviceId',
			                    header: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'instanceId',
			                    header: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'connectorId',
			                    header: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'activityId',
			                    header: '<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>'
			                },
			                {
			                    name: 'exceptionText',
			                    header: '<fmt:message>igate.exceptionLog.exceptionText</fmt:message>'
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
			            pk: {
			                exceptionDateTime: null,
			                exceptionId: null
			            },
			            transactionId: null,
			            adapterId: null,
			            exceptionCode: null,
			            interfaceId: null,
			            serviceId: null,
			            instanceId: null,
			            connectorId: null,
			            activityId: null
			        },
			        letter: {
			            pk: {
			                exceptionDateTime: null,
			                exceptionId: null
			            },
			            transactionId: null,
			            adapterId: null,
			            exceptionCode: null,
			            interfaceId: null,
			            serviceId: null,
			            instanceId: null,
			            connectorId: null,
			            activityId: null
			        },
			        panelMode: null
			    },
			    computed: {
			        pk: function () {
			            return {
			                'pk.exceptionDateTime': this.object.pk.exceptionDateTime,
			                'pk.exceptionId': this.object.pk.exceptionId
			            };
			        }
			    },
			    created: function () {
			        if (localStorage.getItem('selectedExceptionLog')) {
			            this.selectedExceptionLog = JSON.parse(localStorage.getItem('selectedExceptionLog'));
			            localStorage.removeItem('selectedExceptionLog');

			            SearchImngObj.load($.param(this.selectedExceptionLog));
			        }
			    },
			    methods: {
			        loaded: function () {
			            window.vmExceptionStack.object.exceptionStack = this.object.exceptionStack;
			        },
			        goDetailPanel: function () {
			            panelOpen(
			                'detail',
			                null,
			                function () {
			                    if (this.selectedExceptionLog) {
			                        if (localStorage.getItem('selectedExceptionInfo')) {
			                            localStorage.removeItem('selectedExceptionInfo');
			                            $('#panel').find("[data-target='#panel']").trigger('click');
			                        }

			                        $('.underlineTxt').each(function (index, element) {
			                            $(element)
			                                .parent()
			                                .css('cursor', $(element).val().length < 1 ? 'auto' : 'pointer');
			                        });
			                    }
			                }.bind(this)
			            );
			        },
			        initDetailArea: function (object) {
			            if (object) {
			                this.object = object;
			            } else {
			                this.object.pk.exceptionId = null;
			                this.object.fromExceptionDateTime = null;
			                this.object.toExceptionDateTime = null;
			                this.object.transactionId = null;
			                this.object.adapterId = null;
			                this.object.exceptionCode = null;
			                this.object.interfaceId = null;
			                this.object.serviceId = null;
			                this.object.instanceId = null;
			                this.object.connectorId = null;
			                this.object.activityId = null;
			            }
			        },
			        clickTransactionId: function (transactionInfo) {
			            localStorage.setItem('searchObj', JSON.stringify(transactionInfo));
			            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '103000', '103020']));

			            window.open(location.href);
			        }
			    }
			});

			window.vmExceptionStack = new Vue({
			    el: '#ExceptionStack',
			    data: {
			        object: {
			            exceptionStack: null
			        },
			        letter: {
			            exceptionStack: null
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