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
	<div id="instance" data-ready>
		<sec:authorize var="hasInstanceViewer" access="hasRole('InstanceViewer')"></sec:authorize>
		<sec:authorize var="hasInstanceEditor" access="hasRole('InstanceEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
	document.querySelector('#instance').addEventListener('ready', function(evt) {
		var viewer = 'true' == '${hasInstanceViewer}';
		var editor = 'true' == '${hasInstanceEditor}';

		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('instance');
		createPageObj.setIsModal(false);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.instanceId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'select',
		        name: '<fmt:message>common.type</fmt:message>',
		        placeholder: '<fmt:message>head.all</fmt:message>',
		        mappingDataInfo: {
		            id: 'instanceTypes',
		            selectModel: 'object.instanceType',
		            optionFor: 'option in instanceTypes',
		            optionValue: 'option.pk.propertyKey',
		            optionText: 'option.propertyValue'
		        }
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.instanceNode',
		        name: '<fmt:message>igate.instance.node</fmt:message>',
		        placeholder: '<fmt:message>head.searchData</fmt:message>'
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
		                        type: 'text',
		                        name: '<fmt:message>head.id</fmt:message>',
		                        mappingDataInfo: 'object.instanceId',
		                        isPk: true,
		                        regExpType: 'id'
		                    },
		                    {
		                        type: 'select',
		                        name: '<fmt:message>common.type</fmt:message>',
		                        mappingDataInfo: {
		                            id: 'instanceTypes',
		                            selectModel: 'object.instanceType',
		                            optionFor: 'option in instanceTypes',
		                            optionValue: 'option.pk.propertyKey',
		                            optionText: 'option.propertyValue'
		                        },
		                        isRequired: true
		                    },
		                    {
		                        type: 'select',
		                        name: '<fmt:message>head.log.level</fmt:message>',
		                        mappingDataInfo: {
		                            id: 'instanceLoglevels',
		                            selectModel: 'object.logLevel',
		                            optionFor: 'option in instanceLoglevels',
		                            optionValue: 'option.pk.propertyKey',
		                            optionText: 'option.propertyValue',
		                            optionDisabled: "'N/A' === option.propertyValue"
		                        },
		                        isRequired: true
		                    }
		                ]
		            },
		            {
		                className: 'col-lg-6',
		                detailSubList: [
		                    {
		                        type: 'text',
		                        name: '<fmt:message>igate.instance.address</fmt:message>',
		                        mappingDataInfo: 'object.instanceAddress',
		                        isRequired: true
		                    },
		                    {
		                        type: 'text',
		                        name: '<fmt:message>igate.instance.node</fmt:message>',
		                        mappingDataInfo: 'object.instanceNode',
		                        isRequired: true
		                    },
		                    {
		                        type: 'select',
		                        name: '<fmt:message>igate.instance.downStatus</fmt:message>',
		                        mappingDataInfo: {
		                            id: 'instanceDownStatus',
		                            selectModel: 'object.downStatus',
		                            optionFor: 'option in instanceDownStatus',
		                            optionValue: 'option.pk.propertyKey',
		                            optionText: 'option.propertyValue'
		                        },
		                        isRequired: true
		                    }
		                ]
		            }
		        ]
		    },
		    {
		        type: 'custom',
		        id: 'InstanceProperties',
		        name: '<fmt:message>head.property</fmt:message>',
		        getDetailArea: function () {
		            var detailHtml = '';

		            detailHtml += '<div class="form-table form-table-responsive">';
		            detailHtml += '    <div class="form-table-wrap">';
		            detailHtml += '        <div class="form-table-head">';
		            detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyAdd();"><i class="icon-plus-circle"></i></button>';
		            detailHtml += '			   <label class="col"><fmt:message>common.property.key</fmt:message></label>';
		            detailHtml += '			   <label class="col"><fmt:message>common.property.value</fmt:message></label>';
		            detailHtml += '			   <label class="col"><fmt:message>head.description</fmt:message></label>';
		            detailHtml += '        </div>';
		            detailHtml += '        <div class="form-table-body" v-for="(elm,index) in instanceProperties">';
		            detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require == true"><i class="icon-star"></i></button>';
		            detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyRemove(index);" v-if="elm.require == false || elm.require == null"><i class="icon-minus-circle"></i></button>';
		            detailHtml += '        		<div class="col" v-if="elm.require == true">';
		            detailHtml += '        			<input type="text" class="form-control view-disabled propertyKey" list="propertyKeys" v-model="elm.pk.propertyKey" readonly="readonly" disabled="disabled">';
		            detailHtml += '        			<datalist id="propertyKeys">';
		            detailHtml += '        				<option v-for="et in propertyKeys">{{et}}</option>';
		            detailHtml += '        			</datalist>';
		            detailHtml += '        		</div>';
		            detailHtml += '        		<div class="col" v-if="elm.require != true">';
		            detailHtml += '        			<input type="text" class="form-control view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" @change="searchPropertyKey(index);">';
		            detailHtml += '        			<datalist id="propertyKeys">';
		            detailHtml += '        				<option v-for="et in propertyKeys">{{et}}</option>';
		            detailHtml += '        			</datalist>';
		            detailHtml += '        		</div>';
		            detailHtml += '        		<div class="col" v-if="elm.cipher == true">';
		            detailHtml += '        			<input type="password" class="form-control view-disabled" v-model="elm.propertyValue">';
		            detailHtml += '        		</div>';
		            detailHtml += '        		<div class="col" v-if="elm.cipher == false || elm.cipher == null">';
		            detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.propertyValue">';
		            detailHtml += '        		</div>';
		            detailHtml += '        		<div class="col">';
		            detailHtml += '        			<input type="text" class="form-control view-disabled propertyKey" v-model="elm.propertyDesc"  readonly="readonly" disabled="disabled">';
		            detailHtml += '        		</div>';
		            detailHtml += '        </div>';
		            detailHtml += '    </div>';
		            detailHtml += '</div>';

		            return detailHtml;
		        }
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
		    objectUri: '/igate/instance/object.json'
		});

		ControlImngObj.setConfig({
		    controlUri: '/igate/instance/control.json'
		});

		new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Instance.InstanceType', orderByKey: true }, function (instanceTypeResult) {
		    new HttpReq('/common/property/properties.json').read({ propertyId: 'List.LogLevel', orderByKey: false }, function (logLevelResult) {
		        new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Yn', orderByKey: false }, function (downStatusResult) {
		            window.vmSearch = new Vue({
		                el: '#' + createPageObj.getElementId('ImngSearchObject'),
		                data: {
		                    pageSize: '10',
		                    instanceTypes: [],
		                    letter: {
		                        instanceId: 0,
		                        instanceNode: 0
		                    },
		                    object: {
		                        instanceId: null,
		                        instanceType: ' ',
		                        instanceNode: null
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
		                                new HttpReq('/igate/instance/rowCount.json').read(this.object, function (result) {
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
		                            this.object.instanceId = null;
		                            this.object.instanceType = ' ';
		                            this.object.instanceNode = null;

		                            this.letter.instanceId = 0;
		                            this.letter.instanceNode = 0;
		                        }

		                        initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		                        initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.object.instanceType);
		                    }
		                }),
		                mounted: function () {
		                    this.instanceTypes = instanceTypeResult.object;

		                    this.$nextTick(
		                        function () {
		                            this.initSearchArea();
		                        }.bind(this)
		                    );
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
		                                instanceId: loadParam['instanceId']
		                            });
		                        },
		                        searchUri: '/igate/instance/search.json',
		                        viewMode: '${viewMode}',
		                        popupResponse: '${popupResponse}',
		                        popupResponsePosition: '${popupResponsePosition}',
		                        columns: [
		                            {
		                                name: 'instanceId',
		                                header: '<fmt:message>head.id</fmt:message>',
		                                align: 'left',
		                                width: '45%'
		                            },
		                            {
		                                name: 'instanceType',
		                                header: '<fmt:message>common.type</fmt:message>',
		                                align: 'center',
		                                width: '10%',
		                                formatter: function (value) {
		                                    switch (value.row.instanceType) {
		                                        case 'T': {
		                                            return this.$t('igate.instance.type.trx');
		                                        }
		                                        case 'A': {
		                                            return this.$t('igate.instance.type.adm');
		                                        }
		                                        case 'L': {
		                                            return this.$t('igate.instance.type.log');
		                                        }
		                                        case 'M': {
		                                            return this.$t('igate.instance.type.mnt');
		                                        }
		                                    }
		                                }
		                            },
		                            {
		                                name: 'instanceNode',
		                                header: '<fmt:message>igate.instance.node</fmt:message>',
		                                width: '45%'
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
		                    instanceTypes: [],
		                    instanceLoglevels: [],
		                    instanceDownStatus: [],
		                    letter: {
		                        instanceId: 0,
		                        instanceAddress: 0,
		                        instanceNode: 0
		                    },
		                    object: {
		                        instanceId: null,
		                        instanceType: ' ',
		                        logLevel: ' ',
		                        instanceAddress: null,
		                        instanceNode: null,
		                        downStatus: ' '
		                    },
		                    openWindows: [],
		                    panelMode: null
		                },
		                computed: {
		                    pk: function () {
		                        return {
		                            instanceId: this.object.instanceId
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
		                            this.object.instanceId = null;
		                            this.object.instanceType = ' ';
		                            this.object.logLevel = ' ';
		                            this.object.instanceAddress = null;
		                            this.object.instanceNode = null;
		                            this.object.downStatus = ' ';

		                            this.letter.instanceId = 0;
		                            this.letter.instanceAddress = 0;
		                            this.letter.instanceNode = 0;

		                            window.vmInstanceProperties.instanceProperties = [];
		                        }
		                    }
		                },
		                mounted: function () {
		                    this.instanceTypes = instanceTypeResult.object;
		                    this.instanceLoglevels = logLevelResult.object;
		                    this.instanceDownStatus = downStatusResult.object;
		                }
		            });

		            window.vmInstanceProperties = new Vue({
		                el: '#InstanceProperties',
		                data: {
		                    instanceProperties: [],
		                    propertyKeys: []
		                },
		                methods: {
		                    onClickPlus: function () {
		                        var jsonLoad = [
		                            {
		                                uri: "<c:url value='/igate/instance/propertyKeys.json' />",
		                                attributeName: this.propertyKeys
		                            }
		                        ];
		                        getPropertyList(jsonLoad);
		                    },
		                    propertyAdd: function () {
		                        onCheckPropertyCount();
		                        this.onClickPlus();
		                        this.instanceProperties.push({
		                            pk: {}
		                        });
		                    },
		                    propertyRemove: function (index) {
		                        if (onCheckPropertyCount()) --propertyCount;
		                        this.instanceProperties = this.instanceProperties.slice(0, index).concat(this.instanceProperties.slice(index + 1));
		                    }
		                },
		                mounted: function () {
		                    var self = this;
		                    $.getJSON(this.executePrivilegeIdsUri, function (data) {
		                        self.executePrivilegeIds = data.object;
		                    });
		                }
		            });
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
	
	//Flag에 의해 최초 프로퍼티 개수 Count
	function onCheckPropertyCount() {
	    var firstTemplateMode = true;
	    if (firstTemplateMode) {
	        firstTemplateMode = false;
	        propertyCount = window.vmInstanceProperties.instanceProperties.length;
	        return true;
	    }

	    return false;
	}

	function getPropertyList(jsonLoad) {
	    jsonLoad.forEach(function (value, idx) {
	        $.ajax({
	            type: 'GET',
	            url: value.uri,
	            data: {},
	            dataType: 'json',
	            success: function (result) {
	                //onChangeTypeValue 에서 호출된 경우,
	                if (typeof value.attributeName == 'undefined') window.vmMain.object.instanceProperties = result.object;
	                //필수 값인 항목들 표시 용도
	                //onClickPlus 에서 호출된 경우,
	                else {
	                    var propertyKey = [];
	                    for (key in result.object) propertyKey[key] = result.object[key].pk.propertyKey;

	                    window.vmInstanceProperties.propertyKeys = propertyKey; //프로퍼티 키 필드에 보이는 리스트 용도
	                }
	            },
	            error: function (request, status, error) {
	                ResultImngObj.errorHandler(request, status, error);
	            }
	        });
	    });
	}

	//프로퍼티 키 필드의 값 변경 시, onchange 이벤트
	function searchPropertyKey(index) {
	    onCheckPropertyCount();

	    var paramPropertyKey = window.vmInstanceProperties.instanceProperties[index]; // Property Key
	    var propertyValue = '';
	    var propertyDesc = '';

	    // #으로 시작하는 경우, 설명 : 갱신
	    if (paramPropertyKey.pk.propertyKey.startsWith('#')) window.vmInstanceProperties.instanceProperties[index].propertyDesc = propertyDesc;
	    // #으로 시작하는 옵션이 아닌경우, 기본값 & 설명 : 갱신 가능
	    else {
	        $.ajax({
	            type: 'GET',
	            url: "<c:url value='/common/property/properties.json' />",
	            data: {
	                propertyId: 'Property.Instance',
	                propertyKey: paramPropertyKey.pk.propertyKey,
	                orderByKey: true
	            },
	            dataType: 'json',
	            success: function (result) {
	                if (result.result == 'ok') {
	                    // propertyKey가 "" 공백으로 다 건 조회되는 경우 회피.
	                    if (result.object.length == 1) {
	                        propertyValue = result.object[0].propertyValue;
	                        propertyDesc = result.object[0].propertyDesc;
	                    }

	                    //(+) 신규 추가 된 옵션인 경우, 기본값 갱신
	                    if (propertyCount < index + 1) window.vmInstanceProperties.instanceProperties[index].propertyValue = propertyValue;

	                    window.vmInstanceProperties.instanceProperties[index].propertyDesc = propertyDesc;
	                }
	            },
	            error: function (request, status, error) {
	                ResultImngObj.errorHandler(request, status, error);
	            }
	        });
	    }
	}

	function checkOverlap() {
	    var checkPropertyArray = window.vmInstanceProperties.instanceProperties.map(function (element) {
	        return element.pk.propertyKey;
	    });
	    var overlapElement;

	    checkPropertyArray.forEach(function (element, index) {
	        if (checkPropertyArray.indexOf(element) != index) overlapElement = element;
	    });

	    if (overlapElement) {
	        warnAlert({
	            message: '<fmt:message key="igate.instance.alert.overlap"><fmt:param value="' + overlapElement + '" /></fmt:message>'
	        });
	        return false;
	    }

	    return true;
	}
	</script>
</body>
</html>
