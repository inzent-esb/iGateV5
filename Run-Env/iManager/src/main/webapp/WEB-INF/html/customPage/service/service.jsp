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
	<div id="service" data-ready>
		<sec:authorize var="hasServiceViewer" access="hasRole('ServiceViewer')"></sec:authorize>
		<sec:authorize var="hasServiceEditor" access="hasRole('ServiceEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>		
	</div>
	<script>
		document.querySelector('#service').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasServiceViewer}';
			var editor = 'true' == '${hasServiceEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('service');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.serviceId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.serviceName',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.serviceType',
			            optionFor: 'option in serviceTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            id: 'serviceTypes'
			        },
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/adapterModal',
			            modalTitle: '<fmt:message>igate.adapter</fmt:message>',
			            vModel: 'object.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.serviceGroup',
			        name: '<fmt:message>head.group</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },
			    {
			        type: 'datalist',
			        mappingDataInfo: {
			            dataListId: 'privilegeList',
			            vModel: 'object.privilegeId',
			            dataListFor: 'privilege in privilegeList',
			            dataListText: 'privilege.privilegeId'
			        },
			        name: '<fmt:message>common.privilege</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.serviceDesc',
			        name: '<fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>',
			        regExpType: 'desc'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    downloadBtn: viewer,
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
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceId',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        isPk: true
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceName',
			                        name: '<fmt:message>head.name</fmt:message>',
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.serviceType',
			                            optionFor: 'option in serviceTypes',
			                            optionValue: 'option.pk.propertyKey',
			                            optionText: 'option.propertyValue'
			                        },
			                        name: '<fmt:message>common.type</fmt:message>',
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.adapterId',
			                        name: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>'
			                    },
			                    {
			                        type: 'textEvt',
			                        mappingDataInfo: 'object.operationId',
			                        name: '<fmt:message>igate.operation</fmt:message>',
			                        clickEvt: 'clickOperation(object.operationId)'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceActivity',
			                        name: '<fmt:message>igate.activity</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.metaDomain',
			                            optionFor: 'option in metaDomains',
			                            optionValue: 'option',
			                            optionText: 'option'
			                        },
			                        name: '<fmt:message>igate.fieldMeta.metaDomain</fmt:message>'
			                    },
			                    {
			                        type: 'textEvt',
			                        mappingDataInfo: 'object.requestRecordName',
			                        name: '<fmt:message>igate.service.request.model</fmt:message>',
			                        clickEvt: 'clickRecord(object.requestRecordId)'
			                    },
			                    {
			                        type: 'textEvt',
			                        mappingDataInfo: 'object.responseRecordName',
			                        name: '<fmt:message>igate.service.response.model</fmt:message>',
			                        clickEvt: 'clickRecord(object.responseRecordId)'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-3',
			                detailSubList: [
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privateYn',
			                            optionFor: 'option in privateYnList',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: '<fmt:message>head.private</fmt:message>',
			                        isRequired: true
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.serviceGroup',
			                        name: '<fmt:message>head.group</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privilegeId',
			                            optionFor: 'option in privilegeIds',
			                            optionValue: 'option',
			                            optionText: 'option'
			                        },
			                        name: '<fmt:message>common.privilege</fmt:message>',
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-12',
			                detailSubList: [
			                    {
			                        type: 'textarea',
			                        mappingDataInfo: 'object.serviceDesc',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        height: 200
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'property',
			        id: 'ServiceProperties',
			        name: '<fmt:message>head.extend.info</fmt:message>',
			        mappingDataInfo: 'serviceProperties',
			        detailList: [
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.pk.propertyKey',
			                name: '<fmt:message>common.property.key</fmt:message>'
			            },
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.propertyValue',
			                name: '<fmt:message>common.property.value</fmt:message>'
			            },
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.propertyDesc',
			                name: '<fmt:message>head.description</fmt:message>'
			            }
			        ]
			    },
			    {
			        type: 'basic',
			        id: 'ResouceInUse',
			        name: '<fmt:message>head.resource.inuse.info</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.lockUserId',
			                        name: '<fmt:message>head.lock.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateVersion',
			                        name: '<fmt:message>head.updateVersion</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateUserId',
			                        name: '<fmt:message>head.update.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.updateTimestamp',
			                        name: '<fmt:message>head.update.timestamp</fmt:message>'
			                    }
			                ]
			            }
			        ]
			    }
			]);

			createPageObj.setPanelButtonList({
			    dumpBtn: editor
			});

			createPageObj.panelConstructor();

			SaveImngObj.setConfig({
			    objectUrl: '/api/entity/service/object'
			});

			ControlImngObj.setConfig({
			    controlUrl: '/api/entity/service/control',
			    dumpUrl: '/api/entity/service/dump'
			});
			
			new HttpReq('/api/entity/privilege/search').read({ object: { privilegeType: 'b' }, limit: null, next: null, reverseOrder: false }, function (privilegeListresult) {
				new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Service.ServiceType' }, orderByKey: true }, function (serviceTypeResult) {
					window.vmSearch = new Vue({
					    el: '#' + createPageObj.getElementId('ImngSearchObject'),
					    data: {
					    	object: {
					            serviceId: null,
					            serviceName: null,
					            serviceType: ' ',
					            adapterId: null,
					            serviceGroup: null,
					            privilegeId: null,
					            serviceDesc: null,
					            pageSize: '10',
					        },
					        letter: {
					            serviceId: 0,
					            serviceName: 0,
					            adapterId: 0,
					            serviceGroup: 0,
					            privilegeId: 0,
					            serviceDesc: 0
					        },
					        privilegeList: [],
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
					        initSearchArea: function (searchCondition) {
					            if (searchCondition) {
					                for (var key in searchCondition) {
					                    this.$data[key] = searchCondition[key];
					                }
					            } else {
					                this.object.pageSize = '10';

					                this.object.serviceId = null;
					                this.object.serviceName = null;
					                this.object.serviceType = ' ';
					                this.object.adapterId = null;
					                this.object.serviceGroup = null;
					                this.object.privilegeId = null;
					                this.object.serviceDesc = null;

					                this.letter.serviceId = 0;
					                this.letter.serviceName = 0;
					                this.letter.adapterId = 0;
					                this.letter.serviceGroup = 0;
					                this.letter.privilegeId = 0;
					                this.letter.serviceDesc = 0;
					            }

					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#serviceTypes'), this.object.serviceType);
					        },
					        openModal: function (openModalParam, regExpInfo) {
					            createPageObj.openModal.call(this, openModalParam, regExpInfo);
					        },
					        setSearchAdapterId: function (param) {
					            this.object.adapterId = param.adapterId;
					        }
					    }),
					    created: function () {
					    	this.privilegeList = privilegeListresult.object;
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
					        currentCnt: 0,
					    },
					    methods: $.extend(true, {}, listMethodOption, {
					        initSearchArea: function () {
					            window.vmSearch.initSearchArea();
					        },
					        downloadFile: function () {
					        	downloadFileFunc({ 
				        			url : '/api/entity/service/download',  
				        			param : window.vmSearch.object,
				        			fileName : "<fmt:message>igate.service</fmt:message>_<fmt:message>head.excel.output</fmt:message>_" + Date.now() + ".xlsx"
				        		});					        	
					        }
					    }),
					    mounted: function () {
					        this.makeGridObj = getMakeGridObj();

					        this.makeGridObj.setConfig({
					        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
					            searchUrl: '/api/entity/service/search',
					            totalCntUrl: '/api/entity/service/count',
					            paging: {
					    			isUse: true,
					    			side: "server",
					    			setCurrentCnt: function(currentCnt) {
					    			    this.currentCnt = currentCnt
					    			}.bind(this)					    			
					    		},					            
					            columns: [
					                {
					                    name: 'serviceId',
					                    header: '<fmt:message>head.id</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'serviceName',
					                    header: '<fmt:message>head.name</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'serviceType',
					                    header: '<fmt:message>common.type</fmt:message>',
					                    align: 'center',
					                    width: '10%',
					                    formatter: function (info) {
					                        var rtnValue = null;

					                        var serviceTypes = window.vmSearch.serviceTypes;

					                        for (var i = 0; i < serviceTypes.length; i++) {
					                            if (serviceTypes[i].pk.propertyKey === info.value) {
					                                rtnValue = serviceTypes[i].propertyValue;
					                                break;
					                            }
					                        }

					                        return escapeHtml(rtnValue);
					                    }
					                },
					                {
					                    name: 'adapterId',
					                    header: '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'serviceGroup',
					                    header: '<fmt:message>head.group</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'privilegeId',
					                    header: '<fmt:message>common.privilege</fmt:message>',
					                    align: 'left',
					                    width: '10%'
					                },
					                {
					                    name: 'serviceDesc',
					                    header: '<fmt:message>head.description</fmt:message>',
					                    align: 'left',
					                    width: '20%'
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
					        object: {
					            serviceId: null,
					            serviceName: null,
					            serviceType: null,
					            privilegeId: null,
					            serviceGroup: null,
					            privateYn: null,
					            adapterId: null,
					            operationId: null,
					            serviceActivity: null,
					            metaDomain: null,
					            requestRecordId: null,
					            responseRecordId: null,
					            requestRecordName: null,
					            responseRecordName: null,
					            serviceDesc: null,
					            selectedRowService: null
					        },
					        letter: {
					            serviceId: 0,
					            serviceName: 0,
					            serviceGroup: 0,
					            adapterId: 0,
					            operationId: 0,
					            serviceActivity: 0,
					            requestRecordName: 0,
					            responseRecordName: 0,
					            serviceDesc: 0
					        },
					        panelMode: null,
					        privateYnList: [
					            { value: 'Y', name: 'Y' },
					            { value: 'N', name: 'N' }
					        ],
					        serviceTypes: [],
					        privilegeIds: [],
					        metaDomains: [],
					        serviceProperties: []
					    },
					    created: function () {
					        new HttpReq('/api/page/properties').read({ pk : { propertyId: 'Property.Service' }, orderByKey: true }, function (result) {
				                this.serviceProperties = result.object;
				            }.bind(this));
		
					        this.serviceTypes = serviceTypeResult.object;
					        this.privilegeIds = privilegeListresult.object;
		
					        new HttpReq('/api/entity/fieldMeta/group/search').read(null, function (result) {
				                this.metaDomains = result.object;
				            }.bind(this));
		
					        if (localStorage.getItem('selectedRowService')) {
					            this.selectedRowService = JSON.parse(localStorage.getItem('selectedRowService'));
					            localStorage.removeItem('selectedRowService');
		
					            SearchImngObj.load(this.selectedRowService);
					        }
					    },
					    computed: {
					        pk: function () {
					            return {
					                serviceId: this.object.serviceId
					            };
					        }
					    },
					    methods: {
					        loaded: function () {
					            window.vmServiceProperties.serviceProperties.forEach(
					                function (serviceProperty) {
					                    var property = this.serviceProperties.filter(function (property) {
					                        return serviceProperty.pk.propertyKey == property.pk.propertyKey;
					                    })[0];
		
					                    if (property) {
					                        serviceProperty.propertyDesc = property.propertyDesc;
					                    }
		
					                    serviceProperty.letter = {
					                        pk: {
					                            propertyKey: serviceProperty.pk.propertyKey.length
					                        },
					                        propertyValue: serviceProperty.propertyValue.length,
					                        propertyDesc: property ? serviceProperty.propertyDesc.length : 0
					                    };
					                }.bind(this)
					            );
		
					            if (this.object.requestRecordId) {
					                this.object.requestRecordName = this.object.requestRecordId + (this.object.requestRecordObject.recordName ? ' - ' + this.object.requestRecordObject.recordName : '');
		
					                if (this.object.requestRecordId == this.object.responseRecordId) this.object.responseRecordObject = $.extend(true, {}, this.object.requestRecordObject);
					            }
		
					            if (this.object.responseRecordId) this.object.responseRecordName = this.object.responseRecordId + (this.object.responseRecordObject.recordName ? ' - ' + this.object.responseRecordObject.recordName : '');
		
					            window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
					            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
					            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
					            window.vmResouceInUse.object.updateTimestamp = changeDateFormat(this.object.updateTimestamp);
					        },
					        goDetailPanel: function () {
					            panelOpen(
					                'detail',
					                null,
					                function () {
					                    if (this.selectedRowService) {
					                        $('#panel').find("[data-target='#panel']").trigger('click');
					                        $('#panel').find('#panel-header').find('.ml-auto').remove();
					                    }
		
					                    $('.underlineTxt').each(function (index, element) {
					                        $(element)
					                            .parent()
					                            .css('cursor', $(element).val().length < 1 ? 'auto' : 'pointer');
					                    });
					                }.bind(this)
					            );
					        },
					        initDetailArea: function (object) {
					            if (object) {
					                this.object = object;
					            } else {
					                this.object.serviceId = null;
					                this.object.serviceName = null;
					                this.object.serviceType = null;
					                this.object.privilegeId = null;
					                this.object.privateYn = null;
					                this.object.adapterId = null;
					                this.object.operationId = null;
					                this.object.metaDomain = null;
					                this.object.requestRecordId = null;
					                this.object.responseRecordId = null;
					                this.object.requestRecordName = null;
					                this.object.responseRecordName = null;
					                this.object.serviceDesc = null;
		
					                window.vmServiceProperties.serviceProperties = [];
		
					                window.vmResouceInUse.object.lockUserId = null;
					                window.vmResouceInUse.object.updateVersion = null;
					                window.vmResouceInUse.object.updateUserId = null;
					                window.vmResouceInUse.object.updateTimestamp = null;
					            }
					        },
					        clickOperation: function (param) {
					            if (!param) return;
		
					            localStorage.setItem('selectedOperation', JSON.stringify({ operationId: param }));
					            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '102000', '102070']));
		
					            window.open(location.href);
					        },
					        clickRecord: function (param) {
					            if (!param) return;
		
					            localStorage.setItem('selectedMessageModel', JSON.stringify({ recordId: param }));
					            localStorage.setItem('selectedMenuPathIdListNewTab', JSON.stringify(['100000', '101000', '101010']));
		
					            window.open(location.href);
					        }
					    }
					});
				});
	        });	

			window.vmServiceProperties = new Vue({
			    el: '#ServiceProperties',
			    data: {
			        serviceProperties: []
			    }
			});

			window.vmResouceInUse = new Vue({
			    el: '#ResouceInUse',
			    data: {
			        object: {
			            lockUserId: null,
			            updateVersion: null,
			            updateUserId: null,
			            updateTimestamp: null
			        },
			        letter: {
			            lockUserId: 0,
			            updateVersion: 0,
			            updateUserId: 0,
			            updateTimestamp: 0
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