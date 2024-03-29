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
	<div id="interfacePolicy" data-ready>
		<sec:authorize var="hasInterfacePolicyViewer" access="hasRole('InterfacePolicyViewer')"></sec:authorize>
		<sec:authorize var="hasInterfacePolicyEditor" access="hasRole('InterfacePolicyEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#interfacePolicy').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasInterfacePolicyViewer}';
			var editor = 'true' == '${hasInterfacePolicyEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('interfacePolicy');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.pk.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'select',
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>',
			        mappingDataInfo: {
			            id: 'interfaceTypes',
			            selectModel: 'object.pk.interfaceType',
			            optionFor: 'option in interfaceTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/operationModal',
			            modalTitle: '<fmt:message>igate.operation</fmt:message>',
			            vModel: 'object.operationId',
			            callBackFuncName: 'setSearchOperationId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.operation.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    totalCount: viewer,
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
			                        type: 'search',
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.adapterId',
			                            callBackFuncName: 'setSearchAdapterId'
			                        },
			                        isPk: true,
			                        regExpType: 'id',
			                        clickEvt: function() {
			                        	openNewTab('202030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"adapterId": window.vmMain.object.pk.adapterId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>common.type</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'interfaceTypes',
			                            selectModel: 'object.pk.interfaceType',
			                            optionFor: 'option in interfaceTypes',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        isPk: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.operation.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/operationModal',
			                            modalTitle: '<fmt:message>igate.operation</fmt:message>',
			                            vModel: 'object.operationId',
			                            callBackFuncName: 'setSearchOperationId'
			                        },
			                        isRequired: true,
			                        clickEvt: function() {
			                        	openNewTab('102070', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"operationId": window.vmMain.object.operationId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'traceLogInstances',
			                            selectModel: 'object.instanceId',
			                            optionFor: 'option in traceLogInstances',
			                            optionValue: 'option.instanceId',
			                            optionText: 'option.instanceId'
			                        }
			                    }
			                ]
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
			    objectUrl: '/api/entity/interfacePolicy/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/interfacePolicy/control',
			    dumpUrl: '/api/entity/interfacePolicy/dump'
			});
			
			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Interface.InterfaceType' }, orderByKey: true }, function (interfaceTypeResult) {
			    new HttpReq('/api/entity/instance/search').read({ object: {}, limit: null, next: null, reverseOrder: false }, function (instanceIdResult) {

			    	window.vmSearch = new Vue({
			            el: '#' + createPageObj.getElementId('ImngSearchObject'),
			            data: {			                
			            	object: {
			                    pk: {
			                        adapterId: null,
			                        interfaceType: ' '
			                    },
			                    instanceId: null,
			                    pageSize: 10
			                },
			                letter: {
			                    pk: {
			                        adapterId: 0
			                    },
			                    operationId: 0
			                },
			                interfaceTypes: [],
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
			                        this.object.pk.adapterId = null;
			                        this.object.pk.interfaceType = ' ';
			                        this.object.operationId = null;

			                        this.letter.pk.adapterId = 0;
			                        this.letter.operationId = 0;
			                    }

			                    initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#interfaceTypes'), this.object.pk.interfaceType);
			                },
			                openModal: function (openModalParam, regExpInfo) {
			                    if ('/modal/operationModal' == openModalParam.url) {
			                        openModalParam.modalParam = { operationType: 'I' };
			                    }

			                    createPageObj.openModal.call(this, openModalParam, regExpInfo);
			                },
			                setSearchAdapterId: function (param) {
			                    this.object.pk.adapterId = param.adapterId;
			                },
			                setSearchOperationId: function (param) {
			                    this.object.operationId = param.operationId;
			                }
			            }),
			            created: function () {
			            	this.interfaceTypes = interfaceTypeResult.object;
			            },				            
			            mounted: function () {
			            	this.initSearchArea();
			            }
			        });

			        var vmList = new Vue({
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
					            searchUrl: '/api/entity/interfacePolicy/search',
					            totalCntUrl: '/api/entity/interfacePolicy/count',
					    		paging: {
					    			isUse: true,
					    			side: "server",
					    			setCurrentCnt: function(currentCnt) {
					    			    this.currentCnt = currentCnt
					    			}.bind(this)					    			
					    		},
			                    columns: [
			                        {
			                            name: 'pk.adapterId',
			                            header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                            align: 'left',
			                            width: '35%'
			                        },
			                        {
			                            name: 'pk.interfaceType',
			                            header: '<fmt:message>common.type</fmt:message>',
			                            align: 'center',
			                            width: '30%'
			                        },
			                        {
			                            name: 'operationId',
			                            header: '<fmt:message>igate.operation.id</fmt:message>',
			                            align: 'left',
			                            width: '35%'
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
			                interfaceTypes: [],
			                traceLogInstances: [],
			                object: {
			                    pk: {
			                        adapterId: null,
			                        interfaceType: ' '
			                    },
			                    instanceId: ' ',
			                    operationId: null
			                },
			                openWindows: [],
			                panelMode: null
			            },
			            computed: {
			                pk: function () {
			                    return {
			                        'pk.adapterId': this.object.pk.adapterId,
			                        'pk.interfaceType': this.object.pk.interfaceType
			                    };
			                }
			            },
			            watch: {
			                panelMode: function () {
			                    if (this.panelMode != 'add') $('#panel').find('.warningLabel').hide();
			                }
			            },
			            methods: {
			            	clickEvt: function(strFunc) {
					    		strFunc();
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
			                        this.object.pk.adapterId = null;
			                        this.object.pk.interfaceType = ' ';
			                        this.object.instanceId = ' ';
			                        this.object.operationId = null;
			                    }
			                },
			                openModal: function (openModalParam) {
			                    if ('/modal/operationModal' == openModalParam.url) {
			                        openModalParam.modalParam = { operationType: 'I' };
			                    }

			                    createPageObj.openModal.call(this, openModalParam);
			                },
			                setSearchAdapterId: function (param) {
			                    this.object.pk.adapterId = param.adapterId;
			                },
			                setSearchOperationId: function (param) {
			                    this.object.operationId = param.operationId;
			                }
			            },
			            mounted: function () {
			                this.interfaceTypes = interfaceTypeResult.object;

			                this.traceLogInstances = instanceIdResult.object.filter(function (type) {
			                    return 'T' === type.instanceType;
			                });
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
