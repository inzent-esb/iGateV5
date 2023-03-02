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
	<div id="mapping" data-ready>
		<sec:authorize var="hasMappingViewer" access="hasRole('MappingViewer')"></sec:authorize>
		<sec:authorize var="hasMappingEditor" access="hasRole('MappingEditor')"></sec:authorize>
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
			<div class="col-lg-6" v-show="object.mappingList">
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
			<div class="col-lg-6" v-show="object.mappingList">
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
			<div class="col-lg-12" v-show="object.mappingList">
				<div class="form-group" style="margin-bottom: 16px;">
					<table class="migration-table" width="100%">
						<colgroup>
							<col width="50%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr align="center" style="background-color: #f5f6fb;">
								<th><fmt:message>igate.mapping</fmt:message></th>
								<th><fmt:message>igate.migration.includeList</fmt:message></th>
							</tr>
						</thead>
						<tr v-for="mapping in object.mappingList">
							<td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>
							<td valign='top'>
								<table width="100%">
									<tr>
										<td width="20%" ><fmt:message>igate.mapping</fmt:message></td>
										<td>
											<table width="100%">
												<tr>
													<td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>
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
		document.querySelector('#mapping').addEventListener('ready', function(evt) {
			var viewer = 'true' == '${hasMappingViewer}';
			var editor = 'true' == '${hasMappingEditor}' && 'true' == '${hasMigrationEditor}';

			var data = null;
			var targetIdList = [];
			var makeData = '';

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('mapping');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'text',
			        mappingDataInfo: 'object.mappingId',
			        name: '<fmt:message>head.id</fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>',
			        regExpType: 'searchId'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.mappingName',
			        name: '<fmt:message>head.name</fmt:message>',
			        placeholder: '<fmt:message>head.searchName</fmt:message>',
			        regExpType: 'name'
			    },
			    {
			        type: 'text',
			        mappingDataInfo: 'object.mappingGroup',
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
			        mappingDataInfo: 'object.mappingDesc',
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
			                    detailHtml += '		       <th style="height: 32px;"><fmt:message>igate.mapping</fmt:message></th>';
			                    detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.includeList</fmt:message></th>';
			                    detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.referList</fmt:message></th>';
			                    detailHtml += '	       </tr>';
			                    detailHtml += '	   </thead>';
			                    detailHtml += '	   <tr v-for="mapping in object.mappingList" style="height: 28px;">';
			                    detailHtml += '	       <td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>';
			                    detailHtml += '        <td valign="top">';
			                    detailHtml += '            <table width="100%">';
			                    detailHtml += '                <tr>';
			                    detailHtml += '                    <td width="20%"><fmt:message>igate.mapping</fmt:message></td>';
			                    detailHtml += '                    <td>';
			                    detailHtml += '                        <table width="100%">';
			                    detailHtml += '                            <tr>';
			                    detailHtml += '                                <td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>';
			                    detailHtml += '                            </tr>';
			                    detailHtml += '                        </table>';
			                    detailHtml += '                    </td>';
			                    detailHtml += '               </tr>';
			                    detailHtml += '           </table>';
			                    detailHtml += '       </td>';
			                    detailHtml += '       <td valign="top">';
			                    detailHtml += '           <table width="100%">';
			                    detailHtml += '               <tr v-if="mapping.referRecords.length">';
			                    detailHtml += '                   <td width="30%"><fmt:message>igate.record</fmt:message></td>';
			                    detailHtml += '                   <td>';
			                    detailHtml += '                       <table width="100%">';
			                    detailHtml += '                           <tr v-for="referRecord in mapping.referRecords">';
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

			window.vmSearch = new Vue({
			    el: '#' + createPageObj.getElementId('ImngSearchObject'),
			    data: {
			        letter: {
			            mappingId: 0,
			            mappingName: 0,
			            mappingGroup: 0,
			            privilegeId: 0,
			            mappingDesc: 0
			        },
			        object: {
			            mappingId: null,
			            mappingName: null,
			            mappingGroup: null,
			            privilegeId: null,
			            mappingDesc: null
			        },
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
			                this.object.mappingId = null;
			                this.object.mappingName = null;
			                this.object.mappingGroup = null;
			                this.object.privilegeId = null;
			                this.object.mappingDesc = null;

			                this.letter.mappingId = 0;
			                this.letter.mappingName = 0;
			                this.letter.mappingGroup = 0;
			                this.letter.privilegeId = 0;
			                this.letter.mappingDesc = 0;
			            }
			        }
			    }),
			    mounted: function () {
			        new HttpReq('/common/privilege/list.json').read(
			            { privilegeType: 'b' },
			            function (result) {
			                this.privilegeList = result.object;
			            }.bind(this)
			        );

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
			                targetIdList[idx] = item.mappingId;
			                makeData = makeData + 'targetIds=' + item.mappingId + '&';
			            });

			            if (0 == targetIdList.length) {
			                window._alert({ type: 'warn', message: '<fmt:message>igate.migration.selectError</fmt:message>' });
			            } else {
			                MigrationImngObj.makeSubmit('/igate/migration/mapping/make.json', targetIdList, '<fmt:message>igate.migration.make</fmt:message>', function (result) {
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
			            searchUri: '/igate/migration/mapping/list.json',
			            viewMode: '${viewMode}',
			            popupResponse: '${popupResponse}',
			            popupResponsePosition: '${popupResponsePosition}',
			            rowHeaders: ['checkbox'],
			            columns: [
			                {
			                    name: 'mappingId',
			                    header: '<fmt:message>head.id</fmt:message>',
			                    align: 'left',
			                    width: '20%'
			                },
			                {
			                    name: 'mappingName',
			                    header: '<fmt:message>head.name</fmt:message>',
			                    align: 'left',
			                    width: '20%'
			                },
			                {
			                    name: 'mappingGroup',
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
			                    name: 'mappingDesc',
			                    header: '<fmt:message>head.description</fmt:message>',
			                    align: 'left',
			                    width: '20%'
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
			            var url = "<c:url value='/igate/migration/mapping/down.json?' />" + makeData;
			            myForm.action = url;
			            myForm.method = 'post';
			            myForm.target = 'hiddenframe';
			            myForm.submit();
			        },
			        migration: function () {
			            MigrationImngObj.makeSubmit('/igate/migration/mapping/send.json', targetIdList, '<fmt:message>igate.migration.migration</fmt:message>', function (result) {
			                window.vmMake.object = result.object;
			            });
			        }
			    }
			});

			window.vmImport = new Vue({
			    el: '#Import',
			    data: {
			        object: {
			            mappingList: null
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
			                url: "<c:url value='/igate/migration/mapping/import.json?_method=POST' />",
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