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
	<div id="servicePolicy" data-ready>
		<sec:authorize var="hasServicePolicyViewer" access="hasRole('ServicePolicyViewer')"></sec:authorize>
		<sec:authorize var="hasServicePolicyEditor" access="hasRole('ServicePolicyEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#servicePolicy').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasServicePolicyViewer}';
			var editor = 'true' == '${hasServicePolicyEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('servicePolicy');
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
			            id: 'serviceTypes',
			            selectModel: 'object.pk.serviceType',
			            optionFor: 'option in serviceTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
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
			        name: '<fmt:message>igate.activity.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    addBtn: editor,
			    totalCnt: viewer,
			    currentCnt: viewer,
			    importDataBtn: viewer
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
			                        regExpType: 'id'
			                    },
			                    {
			                        type: 'select',
			                        name: '<fmt:message>common.type</fmt:message>',
			                        mappingDataInfo: {
			                            id: 'serviceTypes',
			                            selectModel: 'object.pk.serviceType',
			                            optionFor: 'option in serviceTypes',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        isPk: true
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.activity.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/activityModal',
			                            modalTitle: '<fmt:message>igate.activity</fmt:message>',
			                            vModel: 'object.activityId',
			                            callBackFuncName: 'setSearchActivityId'
			                        },
			                        isRequired: true
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
			    objectUrl: '/api/entity/servicePolicy/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/servicePolicy/control',
			    dumpUrl: '/api/entity/servicePolicy/dump'
			});
			
			new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Service.ServiceType' }, orderByKey: true }, function (serviceTypeResult) {

				window.vmSearch = new Vue({
			        el: '#' + createPageObj.getElementId('ImngSearchObject'),
			        data: {
			            object: {
			                pk: {
			                    adapterId: null,
			                    serviceType: ' '
			                },
			                activityId: null,
			                pageSize: '10'
			            },
			            letter: {
			                pk: {
			                    adapterId: 0
			                },
			                activityId: 0
			            },
			            serviceTypes: []
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
				        importData: function() {
				        	vmList.makeGridObj.importData(this.object, function(info) {
				        		vmList.currentCnt = info.currentCnt;
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
			                    this.object.pk.serviceType = ' ';
			                    this.object.activityId = null;

			                    this.letter.pk.adapterId = 0;
			                    this.letter.activityId = 0;
			                }

			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#serviceTypes'), this.object.pk.serviceType);
			            },
			            openModal: function (openModalParam, regExpInfo) {
			                if ('/modal/activityModal' == openModalParam.url) {
			                    openModalParam.modalParam = { activityType: 'S' };
			                }

			                createPageObj.openModal.call(this, openModalParam, regExpInfo);
			            },
			            setSearchAdapterId: function (param) {
			                this.object.pk.adapterId = param.adapterId;
			            },
			            setSearchActivityId: function (param) {
			                this.object.activityId = param.activityId;
			            }
			        }),
			        created: function () {
			        	this.serviceTypes = serviceTypeResult.object;
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
				        importData: function() {
				        	window.vmSearch.importData();
				        }
				    }),
			        mounted: function () {
			            var serviceTypes = serviceTypeResult.object;

			            this.makeGridObj = getMakeGridObj();

			            this.makeGridObj.setConfig({
			                el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
				            searchUrl: '/api/entity/servicePolicy/search',
				            totalCntUrl: '/api/entity/servicePolicy/count',
				    		paging: {
				    			isUse: true,
				    			side: "server"
				    		},
			                columns: [
			                    {
			                        name: 'pk.adapterId',
			                        header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        align: 'left',
			                        width: '40%'
			                    },
			                    {
			                        name: 'pk.serviceType',
			                        header: '<fmt:message>common.type</fmt:message>',
			                        align: 'center',
			                        width: '20%',
			                        formatter: function (info) {
			                            return serviceTypes.filter(function (type) {
			                                return info.value === type.pk.propertyKey;
			                            })[0].propertyValue;
			                        }
			                    },
			                    {
			                        name: 'activityId',
			                        header: '<fmt:message>igate.activity.id</fmt:message>',
			                        align: 'left',
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
			            serviceTypes: [],
			            object: {
			                pk: {
			                    adapterId: null,
			                    serviceType: ' '
			                },
			                activityId: null
			            },
			            openWindows: [],
			            panelMode: null
			        },
			        computed: {
			            pk: function () {
			                return {
			                    'pk.adapterId': this.object.pk.adapterId,
			                    'pk.serviceType': this.object.pk.serviceType
			                };
			            }
			        },
			        methods: {
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
			                    this.object.pk.serviceType = ' ';
			                    this.object.instanceId = ' ';
			                    this.object.activityId = null;
			                }
			            },
			            openModal: function (openModalParam) {
			                if ('/modal/activityModal' == openModalParam.url) {
			                    openModalParam.modalParam = { activityType: 'S' };
			                }

			                createPageObj.openModal.call(this, openModalParam);
			            },
			            setSearchAdapterId: function (param) {
			                this.object.pk.adapterId = param.adapterId;
			            },
			            setSearchActivityId: function (param) {
			                this.object.activityId = param.activityId;
			            }
			        },
			        mounted: function () {
			            this.serviceTypes = serviceTypeResult.object;
			        }
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
