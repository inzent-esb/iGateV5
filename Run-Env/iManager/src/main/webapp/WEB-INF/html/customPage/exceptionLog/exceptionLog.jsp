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
			            url: '/modal/interfaceModal',
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
			            url: '/modal/serviceModal',
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
			            url: '/modal/instanceModal',
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
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/activityModal',
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
			                        clickEvt: function() {
			                        	var searchData = window.vmMain.object.transactionId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('103020', function() {	
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "transactionId": searchData }));
			                        	});
			                        },
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
			                        regExpType: 'id',
			                        clickEvt: function() {
										var searchData = window.vmMain.object.interfaceId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('101050', function() {	
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "interfaceId": searchData }));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceId',
			                        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id',
			                        clickEvt: function() {
										var searchData = window.vmMain.object.serviceId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('101030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "serviceId": searchData }));
			                        	});
			                        }
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
			                        regExpType: 'id',
			                        clickEvt: function() {
										var searchData = window.vmMain.object.adapterId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('202030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "adapterId": searchData }));
			                        	});
			                        }
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.connectorId',
			                        name: '<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id',
			                        clickEvt: function() {
										var searchData = window.vmMain.object.connectorId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('202020', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "connectorId": searchData }));
			                        	});
			                        }
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.activityId',
			                        name: '<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>',
			                        regExpType: 'id',
			                        clickEvt: function() {
										var searchData = window.vmMain.object.activityId;
										
					                	if(!searchData) {
					                		window.$alert({ type: 'warn', message: '<fmt:message>head.no.data.warn</fmt:message>' });
					                		return;
					                	}
			                        	
			                        	openNewTab('102060', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({ "activityId": searchData }));
			                        	});
			                        }
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
			    objectUrl: '/api/entity/exceptionLog/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/exceptionLog/control',
			    dumpUrl: '/api/entity/exceptionLog/dump'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
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
			            activityId: null,
			            pageSize: '10'
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
			        totalCnt: null,
		        	currentCnt: null,
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
			        	downloadFileFunc({ 
		        			url : '/api/entity/exceptionLog/download',  
		        			param : { object : window.vmSearch.object, reverseOrder : false },
		        			fileName : "<fmt:message>igate.exceptionLog</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx"
		        		});
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
			            el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),	
		        		searchUrl: '/api/entity/exceptionLog/search',
		        		totalCntUrl: '/api/entity/exceptionLog/count',
		        		paging: {
			    			isUse: true,
			    			side: "server",
			    			setCurrentCnt: function(currentCnt) {
			    			    this.currentCnt = currentCnt
			    			}.bind(this)			    			
			    		},
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
			            ],
		              	onGridMounted: function(evt) {              		
			            	evt.instance.on('click', function(evt) {
			              		if ('undefined' === typeof evt.rowKey) return;
			            		
			            		SearchImngObj.clicked(evt.instance.getRow(evt.rowKey));
			            	});
			            }
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
			    	clickEvt: function(strFunc) {
			    		strFunc();
			    	},
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