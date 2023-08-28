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
	<div id="serviceRecognize" data-ready>
		<sec:authorize var="hasServiceViewer" access="hasRole('ServiceViewer')"></sec:authorize>
		<sec:authorize var="hasServiceEditor" access="hasRole('ServiceEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#serviceRecognize').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasServiceViewer}';
			var editor = 'true' == '${hasServiceEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('serviceRecognize');
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
			        regExpType: 'id',
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.pk.telegramValue',
			        name: '<fmt:message>igate.telegramValue</fmt:message>',
			        placeholder: '<fmt:message>head.searchTelegram</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/serviceModal',
			            modalTitle: '<fmt:message>igate.service</fmt:message>',
			            vModel: 'object.serviceId',
			            callBackFuncName: 'setSearchServiceId'
			        },
			        regExpType: 'id',
			        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
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
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.adapterId',
			                            callBackFuncName: 'setSearchAdapterId'
			                        },
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        warning: '<fmt:message>igate.serviceRecognize.changeWarn</fmt:message>',
			                        isPk: true,
			                        clickEvt: function() {			                        	
			                        	openNewTab('202030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"adapterId": window.vmMain.object.pk.adapterId}));
			                        	}); 
			                        }
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.pk.telegramValue',
			                        name: '<fmt:message>igate.telegramValue</fmt:message>',
			                        isPk: true,
			                        regExpType: 'name'
			                    },
			                    {
			                        type: 'search',
			                        mappingDataInfo: {
			                            url: '/modal/serviceModal',
			                            modalTitle: '<fmt:message>igate.service</fmt:message>',
			                            vModel: 'object.serviceId',
			                            callBackFuncName: 'setSearchServiceId'
			                        },
			                        name: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			                        isRequired: true,
			                        clickEvt: function() {			                        	
			                        	openNewTab('101030', function() {			                        		
			                        		localStorage.removeItem("searchObj");
											localStorage.setItem("searchObj", JSON.stringify({"serviceId": window.vmMain.object.serviceId}));
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
			    objectUrl: '/api/entity/serviceRecognize/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/serviceRecognize/control',
			    dumpUrl: '/api/entity/serviceRecognize/dump'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			        letter: {
			            serviceId: 0,
			            pk: {
			                adapterId: 0,
			                telegramValue: 0
			            }
			        },
			        object: {
			            serviceId: null,
			            pk: {
			                adapterId: null,
			                telegramValue: null
			            },
			            pageSize: 10,
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
			                this.object.pk.adapterId = null;
			                this.object.pk.telegramValue = null;
			                this.object.serviceId = null;
			                this.letter.pk.adapterId = 0;
			                this.letter.pk.telegramValue = 0;
			            }
			        },
			        openModal: function (openModalParam, regExpInfo) {
			            createPageObj.openModal.call(this, openModalParam, regExpInfo);
			        },
			        setSearchAdapterId: function (param) {
			            this.object.pk.adapterId = param.adapterId;
			        },
			        setSearchServiceId: function (param) {
			            this.object.serviceId = param.serviceId;
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
			        currentCnt: null
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
			            searchUrl: '/api/entity/serviceRecognize/search',
			            totalCntUrl: '/api/entity/serviceRecognize/count',
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
			                    width: '25%',
			                },
			                {
			                    name: 'pk.telegramValue',
			                    header: '<fmt:message>igate.telegramValue</fmt:message>',
			                    width: '50%',
			                },
			                {
			                    name: 'serviceId',
			                    header: '<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>',
			                    width: '25%'
			                }
			            ],
			            onGridMounted: function(evt) {
			            	evt.instance.on('click', function(evt) {
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
			        letter: {
			            pk: {
			                telegramValue: 0
			            }
			        },
			        object: {
			            serviceId: null,
			            pk: {
			                adapterId: null,
			                telegramValue: null
			            }
			        },
			        openWindows: [],
			        panelMode: null
			    },
			    computed: {
			        pk: function () {
			            return {
			                'pk.adapterId': this.object.pk.adapterId,
			                'pk.telegramValue': this.object.pk.telegramValue
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
			        loaded: function () {
			            this.letter.pk.telegramValue = this.object.pk.telegramValue.length;
			        },
			        initDetailArea: function (object) {
			            if (object) {
			                this.object = object;
			            } else {
			                this.object.serviceId = null;
			                this.object.pk.adapterId = null;
			                this.object.pk.telegramValue = null;

			                this.letter.pk.telegramValue = 0;
			            }
			        },
			        openModal: function (openModalParam) {
			            if ('/igate/service' == openModalParam.url) {
			                openModalParam.modalParam = {
			                    searchAdapter: window.vmMain.object.pk.adapterId
			                };
			            }

			            createPageObj.openModal.call(this, openModalParam);
			        },
			        setSearchAdapterId: function (param) {
			            this.object.pk.adapterId = param.adapterId;
			            this.object.serviceId = null;
			        },
			        setSearchServiceId: function (param) {
			            this.object.serviceId = param.serviceId;
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