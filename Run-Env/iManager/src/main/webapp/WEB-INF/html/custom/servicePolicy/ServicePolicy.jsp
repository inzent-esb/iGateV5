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
			            url: '/modal/adapterModal.html',
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
			            url: '/modal/activityModal.html',
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
			                        type: 'search',
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal.html',
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
			                            url: '/modal/activityModal.html',
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
			    objectUri: '/igate/servicePolicy/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/servicePolicy/control.json'
			});

			new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Service.ServiceType', orderByKey: true }, function (serviceTypeResult) {
			    window.vmSearch = new Vue({
			        el: '#' + createPageObj.getElementId('ImngSearchObject'),
			        data: {
			            pageSize: '10',
			            object: {
			                pk: {
			                    adapterId: null,
			                    serviceType: ' '
			                },
			                activityId: null
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

			                vmList.makeGridObj.search(
			                    this,
			                    function () {
			                        new HttpReq('/igate/servicePolicy/rowCount.json').read(this.object, function (result) {
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
			                    this.object.pk.adapterId = null;
			                    this.object.pk.serviceType = ' ';
			                    this.object.activityId = null;

			                    this.letter.pk.adapterId = 0;
			                    this.letter.activityId = 0;
			                }

			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#serviceTypes'), this.object.pk.serviceType);
			            },
			            openModal: function (openModalParam, regExpInfo) {
			                if ('/modal/activityModal.html' == openModalParam.url) {
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
			            totalCount: '0'
			        },
			        methods: $.extend(true, {}, listMethodOption, {
			            initSearchArea: function () {
			                window.vmSearch.initSearchArea();
			            }
			        }),
			        mounted: function () {
			            var serviceTypes = serviceTypeResult.object;

			            this.makeGridObj = getMakeGridObj();

			            this.makeGridObj.setConfig({
			                elementId: createPageObj.getElementId('ImngSearchGrid'),
			                onClick: function (loadParam) {
			                    SearchImngObj.clicked({ 'pk.adapterId': loadParam['pk.adapterId'], 'pk.serviceType': loadParam['pk.serviceType'] });
			                },
			                searchUri: '/igate/servicePolicy/search.json',
			                viewMode: '${viewMode}',
			                popupResponse: '${popupResponse}',
			                popupResponsePosition: '${popupResponsePosition}',
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
			                if ('/modal/activityModal.html' == openModalParam.url) {
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
