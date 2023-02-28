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
	<div id="interfaceRecognize" data-ready>
		<sec:authorize var="hasInterfaceViewer" access="hasRole('InterfaceViewer')"></sec:authorize>
		<sec:authorize var="hasInterfaceEditor" access="hasRole('InterfaceEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
	
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#interfaceRecognize').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasInterfaceViewer}';
			var editor = 'true' == '${hasInterfaceEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('interfaceRecognize');
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
			            url: '/modal/interfaceModal.html',
			            modalTitle: '<fmt:message>igate.interface</fmt:message>',
			            vModel: 'object.interfaceId',
			            callBackFuncName: 'setSearchInterfaceId'
			        },
			        regExpType: 'id',
			        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCount: viewer,
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
			                        mappingDataInfo: {
			                            url: '/modal/adapterModal.html',
			                            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			                            vModel: 'object.pk.adapterId',
			                            callBackFuncName: 'setSearchAdapterId'
			                        },
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                        warning: '<fmt:message>igate.interfaceRecognize.changeWarn</fmt:message>',
			                        isPk: true
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
			                            url: '/modal/interfaceModal.html',
			                            modalTitle: '<fmt:message>igate.interface</fmt:message>',
			                            vModel: 'object.interfaceId',
			                            callBackFuncName: 'setSearchInterfaceId'
			                        },
			                        name: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
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
			    objectUri: '/igate/interfaceRecognize/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/interfaceRecognize/control.json'
			});

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			        pageSize: '10',
			        letter: {
			            interfaceId: 0,
			            pk: {
			                adapterId: 0,
			                telegramValue: 0
			            }
			        },
			        object: {
			            interfaceId: null,
			            pk: {
			                adapterId: null,
			                telegramValue: null
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
			                    new HttpReq('/igate/interfaceRecognize/rowCount.json').read(this.object, function (result) {
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
			                this.object.pk.telegramValue = null;
			                this.object.interfaceId = null;
			                this.letter.pk.adapterId = 0;
			                this.letter.pk.telegramValue = 0;
			            }

			            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			        },
			        openModal: function (openModalParam, regExpInfo) {
			            createPageObj.openModal.call(this, openModalParam, regExpInfo);
			        },
			        setSearchAdapterId: function (param) {
			            this.object.pk.adapterId = param.adapterId;
			        },
			        setSearchInterfaceId: function (param) {
			            this.object.interfaceId = param.interfaceId;
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
			            onClick: function (loadParam, ev) {
			                SearchImngObj.clicked({
			                    'pk.adapterId': loadParam['pk.adapterId'],
			                    'pk.telegramValue': loadParam['pk.telegramValue']
			                });
			            },
			            searchUri: '/igate/interfaceRecognize/search.json',
			            viewMode: '${viewMode}',
			            popupResponse: '${popupResponse}',
			            popupResponsePosition: '${popupResponsePosition}',
			            columns: [
			                {
			                    name: 'pk.adapterId',
			                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			                    width: '25%'
			                },
			                {
			                    name: 'pk.telegramValue',
			                    header: '<fmt:message>igate.telegramValue</fmt:message>',
			                    width: '50%'
			                },
			                {
			                    name: 'interfaceId',
			                    header: '<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>',
			                    width: '25%'
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
			        letter: {
			            pk: {
			                telegramValue: 0
			            }
			        },
			        object: {
			            interfaceId: null,
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
			                this.object.interfaceId = null;
			                this.object.pk.adapterId = null;
			                this.object.pk.telegramValue = null;

			                this.letter.pk.telegramValue = 0;
			            }
			        },
			        openModal: function (openModalParam) {
			            if ('/igate/interface.html' == openModalParam.url) {
			                openModalParam.modalParam = {
			                    searchAdapter: window.vmMain.object.pk.adapterId
			                };
			            }

			            createPageObj.openModal.call(this, openModalParam);
			        },
			        setSearchAdapterId: function (param) {
			            this.object.pk.adapterId = param.adapterId;
			            this.object.interfaceId = null;
			        },
			        setSearchInterfaceId: function (param) {
			            this.object.interfaceId = param.interfaceId;
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