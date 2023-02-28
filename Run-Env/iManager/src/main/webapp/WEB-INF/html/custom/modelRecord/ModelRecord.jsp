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
	<div id="modelRecord" data-ready>
		<sec:authorize var="hasRecordViewer" access="hasRole('RecordViewer')"></sec:authorize>
		<sec:authorize var="hasRecordEditor" access="hasRole('RecordEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
		document.querySelector('#modelRecord').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasRecordViewer}';
			var editor = 'true' == '${hasRecordEditor}';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('ModelRecord');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.recordId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.recordName',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'select',
			        mappingDataInfo: {
			            selectModel: 'object.recordType',
			            optionFor: 'option in recordTypes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue',
			            optionIf: "'H' === option.pk.propertyKey || 'R' === option.pk.propertyKey",
			            id: 'recordTypes'
			        },
			        name: '<fmt:message>common.type</fmt:message>',
			        placeholder: '<fmt:message>head.all</fmt:message>'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.recordGroup',
			        name: '<fmt:message>head.group</fmt:message>',
			        placeholder: '<fmt:message>head.searchData</fmt:message>',
			        regExpType: 'name'
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
			        mappingDataInfo: 'object.recordDesc',
			        name: '<fmt:message>head.description</fmt:message>',
			        placeholder: '<fmt:message>head.searchComment</fmt:message>',
			        regExpType: 'desc'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCount: viewer
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
			                        mappingDataInfo: 'object.recordId',
			                        name: '<fmt:message>head.id</fmt:message>',
			                        isPk: true
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.recordName',
			                        name: '<fmt:message>head.name</fmt:message>'
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.privateYn',
			                            optionFor: 'option in privateYnList',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: 'Private',
			                        isRequired: true
			                    },
			                    {
			                        type: 'select',
			                        mappingDataInfo: {
			                            selectModel: 'object.recordType',
			                            optionFor: 'option in recordTypes',
			                            optionValue: 'option.value',
			                            optionText: 'option.name'
			                        },
			                        name: '<fmt:message>head.type</fmt:message>',
			                        isRequired: true
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.metaDomain',
			                        name: '<fmt:message>igate.record.metaDomain</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.recordGroup',
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
			                        mappingDataInfo: 'object.recordDesc',
			                        name: '<fmt:message>head.description</fmt:message>',
			                        height: 200
			                    }
			                ]
			            }
			        ]
			    },
			    {
			        type: 'tree',
			        id: 'ModelInfo',
			        name: '<fmt:message>head.model.info</fmt:message>'
			    },
			    {
			        type: 'property',
			        id: 'RecordProperties',
			        name: '<fmt:message>head.extend.info</fmt:message>',
			        mappingDataInfo: 'recordProperties',
			        detailList: [
			            {
			                type: 'text',
			                mappingDataInfo: 'elm.propertyKey',
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
			    objectUri: '/igate/record/object.json'
			});

			ControlImngObj.setConfig({
			    controlUri: '/igate/record/control.json'
			});

	        new HttpReq('/common/privilege/list.json').read({ privilegeType: 'b' }, function (privilegeListresult) {
		        new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Record.Type', orderByKey: true }, function (recordTypeResult) {
					window.vmSearch = new Vue({
					    el: '#' + createPageObj.getElementId('ImngSearchObject'),
					    data: {
					        pageSize: '10',
					        letter: {
					            recordId: 0,
					            recordName: 0,
					            privilegeId: 0,
					            recordGroup: 0,
					            recordDesc: 0
					        },
					        object: {
					            recordId: null,
					            recordName: null,
					            recordType: ' ',
					            privilegeId: null,
					            recordGroup: null,
					            recordDesc: null
					        },
					        recordTypes: [],
					        privilegeList: []
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
					                    new HttpReq('/igate/record/rowCount.json').read(this.object, function (result) {
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

					                this.object.recordId = null;
					                this.object.recordName = null;
					                this.object.recordType = ' ';
					                this.object.privilegeId = null;
					                this.object.recordGroup = null;
					                this.object.recordDesc = null;

					                this.letter.recordId = 0;
					                this.letter.recordName = 0;
					                this.letter.privilegeId = 0;
					                this.letter.recordGroup = 0;
					                this.letter.recordDesc = 0;
					            }

					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#recordTypes'), this.object.recordType);
					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
					        }
					    }),
					    mounted: function () {
					    	this.privilegeList = privilegeListresult.object;
					    	this.recordTypes = recordTypeResult.object;
					    	
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
					                SearchImngObj.clicked({ recordId: loadParam.recordId });
					            },
					            searchUri: '/igate/record/search.json',
					            viewMode: '${viewMode}',
					            popupResponse: '${popupResponse}',
					            popupResponsePosition: '${popupResponsePosition}',
					            columns: [
					                {
					                    name: 'recordId',
					                    header: '<fmt:message>head.id</fmt:message>',
					                    align: 'left',
					                    width: '20%'
					                },
					                {
					                    name: 'recordName',
					                    header: '<fmt:message>head.name</fmt:message>',
					                    align: 'left',
					                    width: '20%'
					                },
					                {
					                    name: 'recordType',
					                    header: '<fmt:message>common.type</fmt:message>',
					                    align: 'center',
					                    width: '10%',
					                    formatter: function (info) {
					                        var value = info.value;
					                        return 'H' === value ? 'header' : 'I' === value ? 'indivi' : 'R' === value ? 'refer' : 'c' === value ? 'common' : 'embed';
					                    }
					                },
					                {
					                    name: 'recordGroup',
					                    header: '<fmt:message>head.group</fmt:message>',
					                    align: 'left',
					                    width: '20%'
					                },
					                {
					                    name: 'privilegeId',
					                    header: '<fmt:message>common.privilege</fmt:message>',
					                    align: 'left',
					                    width: '10%'
					                },
					                {
					                    name: 'recordDesc',
					                    header: '<fmt:message>head.description</fmt:message>',
					                    align: 'left',
					                    width: '30%'
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
		        });
	        });

			window.vmMain = new Vue({
			    el: '#MainBasic',
			    data: {
			        viewMode: 'Open',
			        object: {
			            recordId: null,
			            recordName: null,
			            recordType: null,
			            privilegeId: null,
			            recordGroup: null,
			            privateYn: null,
			            adapterId: null,
			            operationId: null,
			            activityId: null,
			            metaDomain: null,
			            requestRecordId: null,
			            responseRecordId: null,
			            recordDesc: null,
			            selectedMessageModel: null
			        },
			        letter: {
			            recordId: 0,
			            recordName: 0,
			            metaDomain: 0,
			            recordGroup: 0,
			            recordDesc: 0
			        },
			        panelMode: null,
			        privateYnList: [
			            { value: 'Y', name: 'Y' },
			            { value: 'N', name: 'N' }
			        ],
			        recordTypes: [
			            { value: 'C', name: 'Common data-model' },
			            { value: 'H', name: 'Header data-model' },
			            { value: 'R', name: 'Reference data-model' },
			            { value: 'I', name: 'Individual data-model' },
			            { value: 'E', name: 'Embedded data-model' }
			        ],
			        privilegeIds: [],
			        recordProperties: []
			    },
			    computed: {
			        pk: function () {
			            return {
			                recordId: this.object.recordId
			            };
			        }
			    },
			    created: function () {
			        $('a[href="#ModelInfo"]')
			            .off('shown.bs.tab')
			            .on('shown.bs.tab', function (e) {
			                if (window.vmModelInfo) {
			                    window.vmModelInfo.refresh();
			                }
			            });

			        new HttpReq('/common/property/properties.json').read(
			            { propertyId: 'Property.Record', orderByKey: true },
			            function (result) {
			                this.recordProperties = result.object;
			            }.bind(this)
			        );

			        new HttpReq('/common/auth/businessPrivileges.json').read(
			            null,
			            function (result) {
			                this.privilegeIds = result.object;
			            }.bind(this)
			        );

			        if (localStorage.getItem('selectedMessageModel')) {
			            this.selectedMessageModel = JSON.parse(localStorage.getItem('selectedMessageModel'));
			            localStorage.removeItem('selectedMessageModel');

			            SearchImngObj.load($.param(this.selectedMessageModel));
			        }
			    },
			    methods: {
			        loaded: function () {
			            vmModelInfo.initRecordGridData(this.object.fields);

			            window.vmResouceInUse.object.lockUserId = this.object.lockUserId;
			            window.vmResouceInUse.object.updateVersion = this.object.updateVersion;
			            window.vmResouceInUse.object.updateUserId = this.object.updateUserId;
			            window.vmResouceInUse.object.updateTimestamp = changeDateFormat(this.object.updateTimestamp);

			            if (!this.object.recordOptions) {
			                window.vmRecordProperties.recordProperties = [];
			                return false;
			            }

			            var recordProperties = this.object.recordOptions.split(',');

			            window.vmRecordProperties.recordProperties = recordProperties.map(
			                function (recordProperty) {
			                    var property = recordProperty.split('=');

			                    var obj = {};
			                    obj.propertyKey = property[0];
			                    obj.propertyValue = property[1];

			                    if (this.recordProperties[0].pk.propertyKey === obj.propertyKey) {
			                        obj.propertyDesc = this.recordProperties[0].propertyDesc;
			                    }

			                    obj.letter = {
			                        propertyKey: obj.propertyKey.length,
			                        propertyValue: obj.propertyValue.length,
			                        propertyDesc: obj.propertyDesc.length
			                    };

			                    return obj;
			                }.bind(this)
			            );
			        },
			        goDetailPanel: function () {
			            panelOpen(
			                'detail',
			                null,
			                function () {
			                    if (this.selectedMessageModel) {
			                        $('#panel').find("[data-target='#panel']").trigger('click');
			                        $('#panel').find('#panel-header').find('.ml-auto').hide();
			                    }
			                }.bind(this)
			            );
			        },
			        initDetailArea: function (object) {
			            if (object) {
			                this.object = object;
			            } else {
			                this.object.recordId = null;
			                this.object.recordName = null;
			                this.object.recordType = null;
			                this.object.privilegeId = null;
			                this.object.privateYn = null;
			                this.object.metaDomain = null;
			                this.object.recordDesc = null;

			                window.vmRecordProperties.recordProperties = [];

			                window.vmResouceInUse.object.lockUserId = null;
			                window.vmResouceInUse.object.updateVersion = null;
			                window.vmResouceInUse.object.updateUserId = null;
			                window.vmResouceInUse.object.updateTimestamp = null;
			            }
			        }
			    }
			});
		    
			window.vmModelInfo = new Vue({
			    el: '#ModelInfo',
			    data: {
			        recordTreeGrid: null
			    },
			    methods: {
			        initRecordGrid: function (extendColumnInfo) {
			            var bodyHeight = 230;

			            if ($('.panel-body').height() > 350) bodyHeight = $('.panel-body').height() - 50;

			            $('#ModelInfo').empty();

			            var settings = {
			                el: document.getElementById('ModelInfo'),
			                bodyHeight: bodyHeight,
			                columnOptions: { resizable: true },
			                onGridMounted: function () {
			                    $('#ModelInfo').find('.tui-grid-column-resize-handle').removeAttr('title');
			                },
			                header: {
			                    height: 60,
			                    complexColumns: []
			                },
			                treeColumnOptions: {
			                    name: 'fieldId'
			                },
			                columns: []
			            };

			            extendColumnInfo.forEach(function (complexColumnInfo) {
			                var complexColumn = { name: complexColumnInfo['@label'], header: complexColumnInfo['@label'], childNames: [] };

			                complexColumnInfo.Column.forEach(function (columnInfo) {
			                    var column = { name: columnInfo['@name'], header: columnInfo['@label'], width: columnInfo['@width'], align: columnInfo['@align'] };

			                    if ('checkbox' == columnInfo['@editType']) {
			                        column.align = 'center';
			                        column.formatter = function (value) {
			                            return '<input type="checkbox" name="' + columnInfo['@name'] + '"' + ('Y' == value.value ? 'checked' : '') + ' onclick="return false;">';
			                        };
			                    } else if ('select' == columnInfo['@editType']) {
			                        column.formatter = function (value) {
			                            var selectDiv = "<select class='panel-form-control' name='" + columnInfo['@name'] + "' style='width: 100%; text-overflow: ellipsis;'>";
			                            selectDiv += "		<option value=''></option>";

			                            columnInfo['@availableValue'].split(',').forEach(function (option) {
			                                var optionInfo = option.split('=');
			                                selectDiv += "<option value='" + optionInfo[0] + "' " + (optionInfo[0] == value.value ? 'selected' : '') + '>' + escapeHtml(optionInfo[1]) + '</option>';
			                            });

			                            selectDiv += '</select>';

			                            return selectDiv;
			                        };
			                    } else {
			                        column.escapeHTML = true;
			                    }

			                    settings.columns.push(column);
			                    complexColumn.childNames.push(columnInfo['@name']);
			                });

			                settings.header.complexColumns.push(complexColumn);
			            });

			            this.recordTreeGrid = new tui.Grid(settings);
			        },
			        initRecordGridData: function (recordTreeGridData) {
			            if (!this.recordTreeGrid) {
			                $.ajax({
			                    type: 'GET',
			                    url: "<c:url value='/iToolsConfig.xml'/>",
			                    dataType: 'xml',
			                    success: function (result) {
			                        var config = JSON.parse(xml2json(result, ' '));
			                        this.initRecordGrid(config.Configuration.Record.GroupHeaders.GroupHeader);
			                        this.recordTreeGrid.resetData(this.initTreeData(recordTreeGridData));
			                    }.bind(this)
			                });
			            } else {
			                this.recordTreeGrid.resetData(this.initTreeData(recordTreeGridData));
			            }
			        },
			        refresh: function () {
			            var bodyHeight = 230;

			            if ($('.panel-body').height() > 350) bodyHeight = $('.panel-body').height() - 50;

			            if (this.recordTreeGrid) {
			                this.recordTreeGrid.setBodyHeight(bodyHeight);
			                this.recordTreeGrid.refreshLayout();
			            }
			        },
			        initTreeData: function (fields) {
			            var rtnArr = [];

			            fields.forEach(
			                function (field) {
			                    rtnArr.push(field);

			                    if (field['options']) {
			                        for (var key in field['options']) {
			                            rtnArr[rtnArr.length - 1][key] = field['options'][key] ? field['options'][key] : 'Y';
			                        }
			                    }

			                    if (field.recordObject) {
			                        field.fieldType = 'R';
			                        field._attributes = { expanded: true };
			                        rtnArr[rtnArr.length - 1]._children = this.initTreeData(field.recordObject.fields);
			                    }
			                }.bind(this)
			            );

			            return rtnArr;
			        }
			    }
			});

			window.vmRecordProperties = new Vue({
			    el: '#RecordProperties',
			    data: {
			        recordProperties: []
			    }
			});

			window.vmResouceInUse = new Vue({
			    el: '#ResouceInUse',
			    data: {
			        letter: {
			            lockUserId: 0,
			            updateVersion: 0,
			            updateUserId: 0,
			            updateTimestamp: 0
			        },
			        object: {
			            lockUserId: null,
			            updateVersion: null,
			            updateUserId: null,
			            updateTimestamp: null
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