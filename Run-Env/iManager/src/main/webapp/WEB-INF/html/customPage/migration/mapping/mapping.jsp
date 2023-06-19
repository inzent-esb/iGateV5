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

			var fileData = null;
			var targetIdList = [];

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
			    totalCnt: viewer,
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

			new HttpReq('/api/entity/privilege/search').read({ object: { privilegeType: 'b' }, limit: null, next: null, reverseOrder: false }, function (privilegeListresult) {
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
	
				            vmList.makeGridObj.search(this.object, function(info) {
				            	vmList.totalCnt = numberWithComma(info.totalCnt);
				            });
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
				    created: function () {
				    	this.privilegeList = privilegeListresult.object;
				    },
				    mounted: function () {
				    	this.initSearchArea();
				    }
				});
	
				var vmList = new Vue({
				    el: '#' + createPageObj.getElementId('ImngListObject'),
				    data: {
				        makeGridObj: null,
				        totalCnt: '0'
				    },
				    methods: $.extend(true, {}, listMethodOption, {
				        initSearchArea: function () {
				            window.vmSearch.initSearchArea();
				        },
				        goImport: function () {
				            window.vmImport.fileName = '';
				            window.vmImport.errorMessage = '';
				            window.vmImport.object = {};
	
				            fileData = null;
	
				            panelOpen('detail');
	
				            $("a[href='#Import']").trigger('click');
				        },
				        make: function () {
				            targetIdList = [];
	
				            $.each(SearchImngObj.searchGrid.getCheckedRows(), function (idx, item) {
				                targetIdList[idx] = item.mappingId;
				            });
	
				            if (0 == targetIdList.length) {
				                window._alert({ type: 'warn', message: '<fmt:message>igate.migration.selectError</fmt:message>' });
				            } else {
				                MigrationImngObj.makeSubmit('/api/entity/mapping/migration/object', targetIdList, '<fmt:message>igate.migration.make</fmt:message>', function (result) {
				                    window.vmMake.object = result.object;
				                    panelOpen('detail');
				                });
				            }
				        }
				    }),
				    mounted: function () {
				        this.makeGridObj = getMakeGridObj();
	
				        this.makeGridObj.setConfig({
				        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
				            searchUrl: '/api/entity/mapping/migration/object',
    			    		paging: {
    			    			isUse: false
    			    		},
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
				        	downloadFileFunc({ 
			        			url : '/api/entity/mapping/migration/context',  
			        			param : { targetIds: targetIdList },
			        			fileName : this.object.name
			        		});
				        },
				        migration: function () {
				        	MigrationImngObj.makeSubmit('/api/entity/mapping/migration/send', targetIdList, '<fmt:message>igate.migration.migration</fmt:message>', function (result) {
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
				        	var fileElement = $('<input/>').attr({ type: 'file' });

				            fileElement.on('change', function (evt) {
				            	fileData = evt.target.files[0];
				                window.vmImport.fileName = fileData.name;
				            });

				            fileElement.trigger('click');
				        },
				        uploadFile: function () {
				        	if (null == fileData) {
				                window._alert({ type: 'warn', message: '<fmt:message>igate.migration.fileSelectError</fmt:message>' });
				                return;
				            }
				            
				            uploadFileFunc({ 
			        			url : '/api/entity/mapping/migration/context',  
			        			param : fileData,
			        			callback : function(req) {
			        				
			        				var result = JSON.parse(req.response);
			        				
			        				if('ok' === result.result) {
				                        window.vmImport.object = result.object;
				                        window.vmImport.errorMessage = '';
				                        window._alert({ type: 'warn', message: '<fmt:message>head.upload</fmt:message> <fmt:message>head.success</fmt:message>' });
			        				} else {
				                        window.vmImport.errorMessage = result.error[0].className + (result.error[0].message ? '\n' + result.error[0].message : '');		        					
				                        window._alert({ type: 'warn', message: '<fmt:message>head.upload</fmt:message> <fmt:message>head.fail</fmt:message>' });
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
		});
	</script>
</body>
</html>