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
	<div id="record" data-ready>
		<sec:authorize var="hasRecordViewer" access="hasRole('RecordViewer')"></sec:authorize>
		<sec:authorize var="hasRecordEditor" access="hasRole('RecordEditor')"></sec:authorize>
		<sec:authorize var="hasMigrationEditor" access="hasRole('MigrationEditor')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
		
		<form name="popForm">
			<iframe width=0 height=0 type="hidden" name='hiddenframe' value="openPop" style='display: none;'></iframe>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form>
		
		<span id="fileResult" style="display: none;">
			<div class="col-lg-12">
				<div class="form-group" style="margin-bottom: 16px;">
					<label class="control-label"><span><fmt:message>head.file</fmt:message> <fmt:message>head.select</fmt:message></span></label>
					<div class="input-group">
						<input class="form-control view-disabled" type="text" v-model="fileName" readonly="readonly" placeholder="<fmt:message>igate.migration.fileSelectError</fmt:message>" />
						<button type="button" class="btn" v-on:click="selectFile" style="margin-left: 5px; margin-right: 5px;">
							<fmt:message>head.file</fmt:message>
							<fmt:message>head.select</fmt:message>
						</button>
						<button type="button" class="btn btn-primary" v-on:click="uploadFile">
							<fmt:message>head.upload</fmt:message>
						</button>
					</div>
				</div>
			</div>
			<div class="col-lg-12" v-show="errorMessage">
				<div class="form-group" style="margin-bottom: 16px;">
					<label class="control-label"><span><fmt:message>head.exception</fmt:message></span></label>
					<div class="input-group">
						<textarea class="form-control view-disabled" v-model="errorMessage" readonly="readonly" rows="10" readonly="readonly"></textarea>
					</div>
				</div>
			</div>
			<div class="col-lg-6" v-show="object.records">
				<div class="form-group">
					<label class="control-label"><span><fmt:message>igate.migration.userId</fmt:message></span></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" v-model="object.userId" disabled="disabled">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label"><span><fmt:message>igate.migration.name</fmt:message></span></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" v-model="object.name" disabled="disabled">
					</div>
				</div>
			</div>
			<div class="col-lg-6" v-show="object.records">
				<div class="form-group">
					<label class="control-label"><span><fmt:message>igate.migration.migrationDate</fmt:message></span></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" v-model="object.migrationDate" disabled="disabled">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label"><span><fmt:message>igate.migration.migrationTime</fmt:message></span></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" v-model="object.migrationTime" disabled="disabled">
					</div>
				</div>
			</div>
			<div class="col-lg-12" v-show="object.records">
				<div class="form-group" style="margin-bottom: 16px;">
					<table class="migration-table" width="100%">
						<colgroup>
							<col width="50%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr align="center" style="background-color: #f5f6fb;">
								<th><fmt:message>igate.record</fmt:message></th>
								<th><fmt:message>igate.migration.includeList</fmt:message></th>
							</tr>
						</thead>
						<tr v-for="record in object.records">
							<td>{{record.record.recordId}}({{record.record.recordName}})</td>
							<td valign='top'>
								<table width="100%">
									<tr>
										<td width="20%" ><fmt:message>igate.record</fmt:message></td>
										<td>
											<table width="100%">
												<tr>
													<td>{{record.record.recordId}}({{record.record.recordName}})</td>
												<tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</span>			
	</div>
	<script>
		document.querySelector('#record').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasRecordViewer}';
			var editor = 'true' == '${hasRecordEditor}' && 'true' == '${hasMigrationEditor}';

			var data = null;
			var targetIdList = [];
			var makeData = '';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('record');
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
			        placeholder: '<fmt:message>head.searchData</fmt:message>'
			    },
			    {
			        type: 'datalist',
			        mappingDataInfo: {
			            dataListId: 'privilegeList',
			            vModel: 'object.privilegeId',
			            dataListFor: 'privilege in privilegeList',
			            dataListText: 'privilege.privilegeId'
			        },
			        name: '<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
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

			createPageObj.searchConstructor(true);

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    totalCount: viewer,
			    importBtn: editor,
			    makeBtn: editor
			});

			createPageObj.mainConstructor();

			createPageObj.setTabList([
			    {
			        type: 'basic',
			        id: 'Make',
			        name: '<fmt:message>head.make</fmt:message>',
			        detailList: [
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.userId',
			                        name: '<fmt:message>igate.migration.userId</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.name',
			                        name: '<fmt:message>igate.migration.name</fmt:message>'
			                    }
			                ]
			            },
			            {
			                className: 'col-lg-6',
			                detailSubList: [
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.migrationDate',
			                        name: '<fmt:message>igate.migration.migrationDate</fmt:message>'
			                    },
			                    {
			                        type: 'text',
			                        mappingDataInfo: 'object.migrationTime',
			                        name: '<fmt:message>igate.migration.migrationTime</fmt:message>'
			                    }
			                ]
			            }
			        ],
			        appendAreaList: [
			            {
			                getDetailArea: function () {
			                    var detailHtml = '';

			                    detailHtml += '<div style="width: 100%; padding-left:0.75rem; padding-right: 0.75rem;">';
			                    detailHtml += '<table class="migration-table" width="100%">';
			                    detailHtml += '    <colgroup>';
			                    detailHtml += '        <col width="33%">';
			                    detailHtml += '        <col width="33%">';
			                    detailHtml += '        <col width="34%">';
			                    detailHtml += '    </colgroup>';
			                    detailHtml += '    <thead>';
			                    detailHtml += '	       <tr align="center" style="background-color: #f5f6fb;">';
			                    detailHtml += '		       <th style="height: 32px;"><fmt:message>igate.record</fmt:message></th>';
			                    detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.includeList</fmt:message></th>';
			                    detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.referList</fmt:message></th>';
			                    detailHtml += '	       </tr>';
			                    detailHtml += '	   </thead>';
			                    detailHtml += '	   <tr v-for="record in object.records" style="height: 28px;">';
			                    detailHtml += '	       <td>{{record.record.recordId}}({{record.record.recordName}})</td>';
			                    detailHtml += '        <td valign="top">';
			                    detailHtml += '            <table width="100%">';
			                    detailHtml += '                <tr>';
			                    detailHtml += '                    <td width="20%"><fmt:message>igate.record</fmt:message></td>';
			                    detailHtml += '                    <td>';
			                    detailHtml += '                        <table width="100%">';
			                    detailHtml += '                            <tr>';
			                    detailHtml += '                                <td>{{record.record.recordId}}({{record.record.recordName}})</td>';
			                    detailHtml += '                            </tr>';
			                    detailHtml += '                        </table>';
			                    detailHtml += '                    </td>';
			                    detailHtml += '               </tr>';
			                    detailHtml += '           </table>';
			                    detailHtml += '       </td>';
			                    detailHtml += '       <td valign="top">';
			                    detailHtml += '           <table width="100%">';
			                    detailHtml += '               <tr v-if="record.referRecords.length">';
			                    detailHtml += '                   <td width="30%"><fmt:message>igate.record</fmt:message></td>';
			                    detailHtml += '                   <td>';
			                    detailHtml += '                       <table width="100%">';
			                    detailHtml += '                           <tr v-for="referRecord in record.referRecords">';
			                    detailHtml += '                              <td>{{referRecord.recordId}}({{referRecord.recordName}})</td>';
			                    detailHtml += '                           </tr>';
			                    detailHtml += '                       </table>';
			                    detailHtml += '                   </td>';
			                    detailHtml += '              </tr>';
			                    detailHtml += '          </table>';
			                    detailHtml += '      </td>';
			                    detailHtml += '    </tr>';
			                    detailHtml += '</table>';
			                    detailHtml += '</div>';

			                    if (editor) {
			                        detailHtml += '<div class="col-lg-12">';
			                        detailHtml += '    <a href="javascript:void(0);" id="migrationBtn" class="btn detail btn-primary viewGroup" style="float: right;" v-on:click="migration"><fmt:message>head.migration</fmt:message></a>';
			                        detailHtml += '    <a href="javascript:void(0);" id="downloadBtn" class="btn detail viewGroup" style="float: right; right: 10px;" v-on:click="downloadFile"><fmt:message>head.download</fmt:message></a>';
			                        detailHtml += '</div>';
			                    }

			                    return $(detailHtml);
			                }
			            }
			        ]
			    },
			    {
			        type: 'custom',
			        id: 'Import',
			        name: '<fmt:message>head.import</fmt:message>',
			        getDetailArea: function () {
			            return $('#fileResult').html();
			        }
			    }
			]);

			createPageObj.setPanelButtonList(null);

			createPageObj.panelConstructor(true);

			var MigrationImngObj = {
			    makeSubmit: function (url, data, message, callback, modalMode) {
			        new HttpReq(url).update({ targetIds: data }, function (result) {
			            ResultImngObj.resultResponseHandler(result);

			            window._alert({ type: 'warn', message: message });

			            callback(result);

			            $('#Make-tab').tab('show');
			        });
			    }
			};

	        new HttpReq('/common/privilege/list.json').read({ privilegeType: 'b' }, function (privilegeListresult) {
		        new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Record.Type', orderByKey: true }, function (recordTypeResult) {
					window.vmSearch = new Vue({
					    el: '#' + createPageObj.getElementId('ImngSearchObject'),
					    data: {
					        letter: {
					            recordId: 0,
					            recordName: 0,
					            recordGroup: 0,
					            privilegeId: 0,
					            recordDesc: 0
					        },
					        object: {
					            recordId: null,
					            recordName: null,
					            recordType: ' ',
					            recordGroup: null,
					            privilegeId: null,
					            recordDesc: null
					        },
					        privilegeList: [],
					        recordTypes: []
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
					                    vmList.totalCount = numberWithComma(vmList.makeGridObj.getSearchGrid().getRowCount());
					                }.bind(this)
					            );
					        },
					        initSearchArea: function (searchCondition) {
					            if (searchCondition) {
					                for (var key in searchCondition) {
					                    this.$data[key] = searchCondition[key];
					                }
					            } else {
					                this.object.recordId = null;
					                this.object.recordName = null;
					                this.object.recordType = ' ';
					                this.object.recordGroup = null;
					                this.object.privilegeId = null;
					                this.object.recordDesc = null;

					                this.letter.recordId = 0;
					                this.letter.recordName = 0;
					                this.letter.recordGroup = 0;
					                this.letter.privilegeId = 0;
					                this.letter.recordDesc = 0;
					            }

					            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#recordTypes'), this.object.recordType);
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
					        },
					        goImport: function () {
					            window.vmImport.fileName = '';
					            window.vmImport.errorMessage = '';
					            window.vmImport.object = {};

					            data = null;

					            panelOpen('detail');

					            $("a[href='#Import']").trigger('click');
					        },
					        make: function () {
					            targetIdList = [];
					            makeData = '';

					            $.each(SearchImngObj.searchGrid.getCheckedRows(), function (idx, item) {
					                targetIdList[idx] = item.recordId;
					                makeData = makeData + 'targetIds=' + item.recordId + '&';
					            });

					            if (0 == targetIdList.length) {
					                window._alert({ type: 'warn', message: '<fmt:message>igate.migration.selectError</fmt:message>' });
					            } else {
					                MigrationImngObj.makeSubmit('/igate/migration/record/make.json', targetIdList, '<fmt:message>igate.migration.make</fmt:message>', function (result) {
					                    window.vmMake.object = result.object;
					                    panelOpen('detail');
					                });
					            }
					        }
					    }),
					    mounted: function () {
					        this.makeGridObj = getMakeGridObj();

					        this.makeGridObj.setConfig({
					            elementId: createPageObj.getElementId('ImngSearchGrid'),
					            onClick: function () {},
					            searchUri: '/igate/migration/record/list.json',
					            viewMode: '${viewMode}',
					            popupResponse: '${popupResponse}',
					            popupResponsePosition: '${popupResponsePosition}',
					            rowHeaders: ['checkbox'],
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
					                    header: '<fmt:message>head.type</fmt:message>',
					                    align: 'center',
					                    width: '10%',
					                    formatter: function (value) {
					                        if (value.row.recordType == 'H') return 'Header';
					                        else if (value.row.recordType == 'R') return 'Reference';
					                    }
					                },
					                {
					                    name: 'recordGroup',
					                    header: '<fmt:message>head.group</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'privilegeId',
					                    header: '<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>',
					                    align: 'left',
					                    width: '15%'
					                },
					                {
					                    name: 'recordDesc',
					                    header: '<fmt:message>head.description</fmt:message>',
					                    align: 'left',
					                    width: '20%'
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
			    data: {
			        object: {}
			    }
			});

			window.vmMake = new Vue({
			    el: '#Make',
			    data: {
			        data: null,
			        object: {
			            userId: null,
			            name: null,
			            migrationDate: null,
			            migrationTime: null
			        },
			        letter: {
			            userId: 0,
			            name: 0,
			            migrationDate: 0,
			            migrationTime: 0
			        }
			    },
			    methods: {
			        downloadFile: function () {
			            var myForm = document.popForm;
			            var url = "<c:url value='/igate/migration/record/down.json?' />" + makeData;
			            myForm.action = url;
			            myForm.method = 'post';
			            myForm.target = 'hiddenframe';
			            myForm.submit();
			        },
			        migration: function () {
			            MigrationImngObj.makeSubmit('/igate/migration/record/send.json', targetIdList, '<fmt:message>igate.migration.migration</fmt:message>', function (result) {
			                window.vmMake.object = result.object;
			            });
			        }
			    }
			});

			window.vmImport = new Vue({
			    el: '#Import',
			    data: {
			        object: {
			            records: null
			        },
			        fileName: '',
			        errorMessage: ''
			    },
			    methods: {
			        selectFile: function () {
			            var fileEle = $('<input/>').attr({ type: 'file' });

			            fileEle.on('change', function (evt) {
			                data = new FormData();
			                data.append('body', this.files[0]);
			                window.vmImport.fileName = this.files[0].name;
			            });

			            fileEle.trigger('click');
			        },
			        uploadFile: function () {
			            if (null == data) {
			                window._alert({ type: 'warn', message: '<fmt:message>igate.migration.fileSelectError</fmt:message>' });
			                return;
			            }

			            $.ajax({
			                url: "<c:url value='/igate/migration/record/import.json?_method=POST' />",
			                data: data,
			                cache: false,
			                contentType: false,
			                processData: false,
			                method: 'POST',
			                beforeSend: function (request) {
			                    window.$startSpinner();

			                    request.setRequestHeader('X-IMANAGER-WINDOW', sessionStorage.getItem('X-IMANAGER-WINDOW'));

			                    var csrfToken = JSON.parse(localStorage.getItem('csrfToken'));
			                    request.setRequestHeader(csrfToken.headerName, csrfToken.token);
			                },
			                success: function (data) {
			                    window.$stopSpinner();

			                    if (data.object !== undefined) {
			                        window.vmImport.object = data.object;
			                        window.vmImport.errorMessage = '';
			                        window._alert({ type: 'warn', message: '<fmt:message>head.upload</fmt:message> <fmt:message>head.success</fmt:message>' });
			                    } else {
			                        window._alert({ type: 'warn', message: '<fmt:message>head.upload</fmt:message> <fmt:message>head.fail</fmt:message>' });
			                        window.vmImport.errorMessage = data.error[0].className + (data.error[0].message ? '\n' + data.error[0].message : '');
			                    }
			                }
			            });
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