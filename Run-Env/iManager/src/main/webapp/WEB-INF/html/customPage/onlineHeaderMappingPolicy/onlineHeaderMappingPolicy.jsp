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
			            url: '/modal/adapterModal',
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
			            url: '/modal/adapterModal',
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
			                        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.interfaceAdapterId',
			                            callBackFuncName: 'setSearchInterfaceAdapterId'
			                        },
			                        isPk: true,
			                        clickEvt: function() {
			                        	openNewTab('202030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"adapterId": window.vmMain.object.pk.interfaceAdapterId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.serviceAdapterId',
			                            callBackFuncName: 'setSearchServiceAdapterId'
			                        },
			                        isPk: true,
			                        clickEvt: function() {
			                        	openNewTab('202030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"adapterId": window.vmMain.object.pk.serviceAdapterId}));
			                        	}); 
			                        }
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
			                            url: '/modal/mappingModal',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.requestMappingId',
			                            callBackFuncName: 'setSearchRequestMappingId'
			                        },
			                        clickEvt: function() {
			                        	openNewTab('101020', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"mappingId": window.vmMain.object.requestMappingId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.responseMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.responseMappingId',
			                            callBackFuncName: 'setSearchResponseMappingId'
			                        },
			                        clickEvt: function() {
			                        	openNewTab('101020', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"mappingId": window.vmMain.object.responseMappingId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.replyMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.replyMappingId',
			                            callBackFuncName: 'setSearchReplyMappingId'
			                        },
			                        clickEvt: function() {
			                        	openNewTab('101020', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"mappingId": window.vmMain.object.replyMappingId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'search',
			                        name: '<fmt:message>igate.onlineHeaderMappingPolicy.createMappingId</fmt:message>',
			                        mappingDataInfo: {
			                            url: '/modal/mappingModal',
			                            modalTitle: '<fmt:message>igate.mapping</fmt:message>',
			                            vModel: 'object.createMappingId',
			                            callBackFuncName: 'setSearchCreateMappingId'
			                        },
			                        clickEvt: function() {
			                        	openNewTab('101020', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"mappingId": window.vmMain.object.createMappingId}));
			                        	}); 
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
			    objectUrl: '/api/entity/onlineHeaderMappingPolicy/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/onlineHeaderMappingPolicy/control',
			    dumpUrl: '/api/entity/onlineHeaderMappingPolicy/dump'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			    	object: {
			            pk: {
			                interfaceAdapterId: null,
			                serviceAdapterId: null,
			                pageSize: 10
			            }
			        },
			        letter: {
			            pk: {
			                interfaceAdapterId: 0,
			                serviceAdapterId: 0
			            }
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
			            	this.object.pageSize = 10;
			                this.object.pk.interfaceAdapterId = null;
			                this.object.pk.serviceAdapterId = null;

			                this.letter.pk.interfaceAdapterId = 0;
			                this.letter.pk.serviceAdapterId = 0;
			            }
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
			            searchUrl: '/api/entity/onlineHeaderMappingPolicy/search',
			            totalCntUrl: '/api/entity/onlineHeaderMappingPolicy/count',
			    		paging: {
			    			isUse: true,
			    			side: "server",
			    			setCurrentCnt: function(currentCnt) {
			    			    this.currentCnt = currentCnt
			    			}.bind(this)			    			
			    		},
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