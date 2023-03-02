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

		            detailHtml += '<div class="propertyTab" style="width: 100%">';
		            detailHtml += '    <div class="form-table form-table-responsive">';
		            detailHtml += '        <div class="form-table-head">';
		            detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="addProperty();"><i class="icon-plus-circle"></i></button>';
		            detailHtml += '            <label class="col"><fmt:message>common.property.key</fmt:message></label>';
		            detailHtml += '            <label class="col"><fmt:message>common.property.value</fmt:message></label>';
		            detailHtml += '            <label class="col"><fmt:message>head.description</fmt:message></label>';
		            detailHtml += '        </div>';
		            detailHtml += '        <div class="form-table-wrap">';
		            detailHtml += '        	   <div class="form-table-body" v-for="(elm, index) in instanceProperties">';  
		            detailHtml += '                <button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require"><i class="icon-star"></i></button>';
		            detailHtml += '                <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="removeProperty(index);" v-else><i class="icon-minus-circle"></i></button>';
		            detailHtml += '                <div class="col">';
		            detailHtml += '                    <div v-if="elm.require" style="width: 100%;">';
		            detailHtml += '                        <input type="text" class="form-control readonly" list="propertyKeys" v-model="elm.pk.propertyKey" readonly>';
		            detailHtml += '                        <datalist id="propertyKeys">';
		            detailHtml += '                            <option v-for="option in propertyKeys" :value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>';
		            detailHtml += '                        </datalist>';
		            detailHtml += '                    </div>';
		            detailHtml += '                    <div class="detail-content-regExp" v-else>';
		            detailHtml += '                        <input type="text" class="regExp-text view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" :maxlength="maxLengthObj.id" @input="inputEvt(elm, \'pk.propertyKey\')" @change="changePropertyKey(index)">';
		            detailHtml += '                        <datalist id="propertyKeys">';
		            detailHtml += '                            <option v-for="option in propertyKeys" :value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>';
		            detailHtml += '                        </datalist>';
		            detailHtml += '                        <span class="letterLength"> ( {{ elm.letter.pk.propertyKey }} / {{ maxLengthObj.id }} ) </span>';
		            detailHtml += '                    </div>';
		            detailHtml += '                </div>';
		            detailHtml += '                <div class="col">';
		            detailHtml += '                    <div class="detail-content-regExp">';
		            detailHtml += '                        <input :type="elm.cipher? \'password\' : \'text\'" class="regExp-text view-disabled" v-model="elm.propertyValue" :maxlength="maxLengthObj.value" @input="inputEvt(elm, \'propertyValue\')">';
		            detailHtml += '                        <span class="letterLength"> ( {{ elm.letter.propertyValue }} / {{ maxLengthObj.value }} ) </span>';
		            detailHtml += '                    </div>';
		            detailHtml += '                </div>';
		            detailHtml += '                <div class="col">';
		            detailHtml += '                    <input type="text" class="form-control readonly" v-model="elm.propertyDesc" readonly>';
		            detailHtml += '                </div>';
		            detailHtml += '            </div>';
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
		                created: function () {
		                	this.instanceTypes = instanceTypeResult.object;
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

				                    window.vmInstanceProperties.propertyKeys = [];
				                    window.vmInstanceProperties.instanceProperties = [];
		                        }
		                    },
		                    loaded: function () {
		                    	//letter
				                this.letter.instanceId = this.object.instanceId.length;
				                this.letter.instanceAddress = this.object.instanceAddress ? this.object.instanceAddress.length : 0;
				                this.letter.instanceNode = this.object.instanceNode ? this.object.instanceNode.length : 0;
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
		                    propertyKeys: [],
					        maxLengthObj: {
					        	id: getRegExpInfo('id').maxLength,
					        	value: getRegExpInfo('value').maxLength
					        },
		                },
		                methods: {
		                    addProperty: function () {		                        
		                        this.instanceProperties.push({
					                pk: {
					                    propertyKey: ''
					                },
					                propertyValue: '',
					                propertyDesc: '',
					                letter: {
					                	pk: {
						                    propertyKey: 0,
						                },
						                propertyValue: 0,
					                }
					            });
		                    },
		                    removeProperty: function (index) {
					            this.instanceProperties.splice(index, 1);
		                    },
					        changePropertyKey: function (index) {
					        	var rowInfo = this.instanceProperties[index];
					        	
					        	// 직접 입력일 경우
					            if (
				        			!this.propertyKeys.some(function (property) {
				        				return rowInfo.pk.propertyKey === property.pk.propertyKey;
				        			})
				        		) 
					            	return;
					            
					            // 프로퍼티 키 중복 검사
					            var check = this.instanceProperties.filter(function(property, idx) {
					            	return idx !== index;
					            }).some(function(property, idx) {
					            	return rowInfo.pk.propertyKey === property.pk.propertyKey;
					            });
					            
					            if(check) {
					            	window._alert({
				    					type: 'warn',
				    					message: '<fmt:message>igate.instance.alert.overlap</fmt:message>',
				    				});

				    				this.instanceProperties[index] = {
				    					pk: {
				    						propertyKey: ''
				    					},
				    					letter : {
				    						pk: {
					    						propertyKey: 0
					    					}
				    					}
				    				};
				    				return;
					            }
					              
					            var instanceInfo = this.propertyKeys.filter(function(property) {
					            	return rowInfo.pk.propertyKey === property.pk.propertyKey
					            })[0]
					            
					            this.instanceProperties[index].propertyValue = instanceInfo.propertyValue;
			                    this.instanceProperties[index].propertyDesc = instanceInfo.propertyDesc;
			                    this.instanceProperties[index].cipher = 'Y' === instanceInfo.cipherYn;
			                    this.instanceProperties[index].require = 'Y' === instanceInfo.requireYn;
					        },
					        inputEvt: function (info, key) {
					        	//letter
					        	var regExp = getRegExpInfo('pk.propertyKey' === key? 'id' : 'value').regExp;
					        	
								if ('pk.propertyKey' === key) {
									info.pk.propertyKey = info.pk.propertyKey? info.pk.propertyKey.replace(new RegExp(regExp, 'g'), '') : '';
									info.letter.pk.propertyKey = info.pk.propertyKey ? info.pk.propertyKey.length : 0;
								} else if('propertyValue' === key) {
									info.propertyValue = info.propertyValue? info.propertyValue.replace(new RegExp(regExp, 'g'), '') : '';
									info.letter.propertyValue = info.propertyValue ? info.propertyValue.length : 0;
								}
					        },
		                },
		                mounted: function () {
		                	 new HttpReq('/igate/instance/propertyKeys.json').read(null, function (instranceListResult) {
	 			           		this.propertyKeys = instranceListResult.object;  	
	 			        	}.bind(this));
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
	</script>
</body>
</html>
