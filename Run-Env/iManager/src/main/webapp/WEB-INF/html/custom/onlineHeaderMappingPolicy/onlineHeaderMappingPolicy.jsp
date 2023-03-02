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
	<div id="onlineHeaderMappingPolicy" data-ready>
		<sec:authorize var="hasOnlineHeaderMappingPolicyViewer" access="hasRole('OnlineHeaderMappingPolicyViewer')"></sec:authorize>
		<sec:authorize var="hasOnlineHeaderMappingPolicyEditor" access="hasRole('OnlineHeaderMappingPolicyEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#onlineHeaderMappingPolicy').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasOnlineHeaderMappingPolicyViewer}';
			var editor = 'true' == '${hasOnlineHeaderMappingPolicyEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('onlineHeaderMappingPolicy');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal.html',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.pk.interfaceAdapterId',
			            callBackFuncName: 'setSearchInterfaceAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal.html',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.pk.serviceAdapterId',
			            callBackFuncName: 'setSearchServiceAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
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
			                        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal.html',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.interfaceAdapterId',
			                            callBackFuncName: 'setSearchInterfaceAdapterId'
			                        },
			                        isPk: true
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal.html',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.serviceAdapterId',
			                            callBackFuncName: 'setSearchServiceAdapterId'
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
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.requestMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal.html',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.requestMappingId',
			                            callBackFuncName: 'setSearchRequestMappingId'
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.responseMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal.html',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.responseMappingId',
			                            callBackFuncName: 'setSearchResponseMappingId'
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.replyMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal.html',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.replyMappingId',
			                            callBackFuncName: 'setSearchReplyMappingId'
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.createMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal.html',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.createMappingId',
			                            callBackFuncName: 'setSearchCreateMappingId'
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
			    objectUri: '/igate/onlineHeaderMappingPolicy/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/onlineHeaderMappingPolicy/control.json'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			        pageSize: '10',
			        letter: {
			            pk: {
			                interfaceAdapterId: 0,
			                serviceAdapterId: 0
			            }
			        },
			        object: {
			            pk: {
			                interfaceAdapterId: null,
			                serviceAdapterId: null
			            }
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
			                    new HttpReq('/igate/onlineHeaderMappingPolicy/rowCount.json').read(this.object, function (result) {
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
			                this.object.pk.interfaceAdapterId = null;
			                this.object.pk.serviceAdapterId = null;

			                this.letter.pk.interfaceAdapterId = 0;
			                this.letter.pk.serviceAdapterId = 0;
			            }

			            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			        },
			        openModal: function (openModalParam, regExpInfo) {
			            createPageObj.openModal.call(this, openModalParam, regExpInfo);
			        },
			        setSearchInterfaceAdapterId: function (param) {
			            this.object.pk.interfaceAdapterId = param.adapterId;
			        },
			        setSearchServiceAdapterId: function (param) {
			            this.object.pk.serviceAdapterId = param.adapterId;
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
			            onClick: function (loadParam) {
			                SearchImngObj.clicked({
			                    'pk.interfaceAdapterId': loadParam['pk.interfaceAdapterId'],
			                    'pk.serviceAdapterId': loadParam['pk.serviceAdapterId']
			                });
			            },
			            searchUri: '/igate/onlineHeaderMappingPolicy/search.json',
			            viewMode: '${viewMode}',
			            popupResponse: '${popupResponse}',
			            popupResponsePosition: '${popupResponsePosition}',
			            columns: [
			                {
			                    name: 'pk.interfaceAdapterId',
			                    header: '<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                    align: 'left'
			                },
			                {
			                    name: 'pk.serviceAdapterId',
			                    header: '<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                    align: 'left'
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
			        object: {
			            pk: {
			                interfaceAdapterId: null,
			                serviceAdapterId: null
			            },
			            requestMappingId: null,
			            responseMappingId: null,
			            replyMappingId: null,
			            createMappingId: null
			        },
			        openWindows: [],
			        panelMode: null
			    },
			    computed: {
			        pk: function () {
			            return {
			                'pk.interfaceAdapterId': this.object.pk.interfaceAdapterId,
			                'pk.serviceAdapterId': this.object.pk.serviceAdapterId
			            };
			        }
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
			            panelOpen('detail');
			        },
			        initDetailArea: function (object) {
			            if (object) {
			                this.object = object;
			            } else {
			                this.object.pk.interfaceAdapterId = null;
			                this.object.pk.serviceAdapterId = null;
			                this.object.requestMappingId = null;
			                this.object.responseMappingId = null;
			                this.object.replyMappingId = null;
			                this.object.createMappingId = null;
			            }
			        },
			        openModal: function (openModalParam) {
			            createPageObj.openModal.call(this, openModalParam);
			        },
			        setSearchInterfaceAdapterId: function (param) {
			            this.object.pk.interfaceAdapterId = param.adapterId;
			        },
			        setSearchServiceAdapterId: function (param) {
			            this.object.pk.serviceAdapterId = param.adapterId;
			        },
			        setSearchRequestMappingId: function (param) {
			            this.object.requestMappingId = param.mappingId;
			        },
			        setSearchResponseMappingId: function (param) {
			            this.object.responseMappingId = param.mappingId;
			        },
			        setSearchReplyMappingId: function (param) {
			            this.object.replyMappingId = param.mappingId;
			        },
			        setSearchCreateMappingId: function (param) {
			            this.object.createMappingId = param.mappingId;
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