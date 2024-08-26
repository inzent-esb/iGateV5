<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="panel" class="panel panel-bottom" data-backdrop="false">
	<div class="panel-dialog">
		<div class="panel-content">
			<div class="resize-bar"></div>
			
			<header id="panel-header" class="panel-header sub-bar">
				<a href="javascript:void(0);" class="btn btn-icon updateGroup backBtn" title="<fmt:message>common.go.back</fmt:message>" v-on:click="goPreviousPanel"><i class="icon-left"></i></a>
				<h2 class="sub-bar-tit"></h2>
				<div class="ml-auto">
					<button type="button" class="btn-change-layout-horizon btn-icon" v-on:click="changeLayout('vertical')" title="<fmt:message>common.detail.horizontal.view</fmt:message>">
						<img src="${prefixFileUrl}/img/horizontal.svg" class="center-block" />
					</button>
					<button type="button" class="btn-change-layout-vertical btn-icon" v-on:click="changeLayout('horizon')" title="<fmt:message>common.detail.vertical.view</fmt:message>">
						<img src="${prefixFileUrl}/img/vertical.svg" class="center-block" />
					</button>				
					<button type="button" class="btn-icon" v-on:click="togglePanel" data-toggle="toggle" data-target="#panel" data-class="expand"><i class="icon-expand"></i></button>
					<button type="button" class="btn-icon" v-on:click="closePanel"><i class="icon-close"></i></button>
				</div>
			</header>
			
			<ul class="nav nav-tabs flex-shrink-0">
				<li class="nav-item-origin" style="display: none">
					<a class="nav-link" href="#bass-info" data-toggle="tab"></a>
				</li>
				<li class="nav-item" id="item-result-parent">
					<a class="nav-link" href="#process-result" data-toggle="tab" id="item-result" ><fmt:message>head.executionResult</fmt:message></a>
				</li>
			</ul>
			
			<div class="panel-body tab-content">			
				<div class="form-group form-group-origin">
					<label class="control-label"></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" style="display: none;">
						<input type="radio" class="form-control view-disabled" style="display: none;">
						<input type="checkbox" class="form-control view-disabled" style="display: none;">
						<select class="form-control view-disabled" style="display: none;"></select>
						<textarea class="form-control view-disabled" style="display: none;"></textarea>
						<span type="password" style="width:100%; display: none;">
							<input class="form-control view-disabled" style="display: inline; width: calc(100% - 1.8rem);">
							<i class="icon-eye" style="font-size: 1.5rem;cursor: pointer;"></i>
						</span>
						<span type="datalist" style="width:100%; display: none;">
							<input type="text" class="form-control view-disabled"> 
							<datalist></datalist>			
						</span>
						<div type="radio" style="display: none;"></div>
						<div type="checkbox" style="display: none;"></div>
						<div class="input-group-append" style="display: none;">
							<button type="button" class="btn" id="lookupBtn"><i class="icon-srch"></i><fmt:message>head.search</fmt:message></button>
							<button type="button" class="btn" id="resetBtn" style="margin-left: 5px; min-width: 0px;"><i class="icon-reset" style="margin-right: 0px;"></i></button>
						</div>
					</div>
				</div>
				<div class="tab-pane" id="process-result">
					<ul id="accordionResult" class="collapse-list collapse-list-result m-0" style="display: none">
						<li class="collapse-item-origin" style="display: none">
							<button class="collapse-link collapsed" type="button" data-toggle="collapse" data-target="#collapseResult">
								<i class="iconb-compt mr-2"></i>
								<span class="txt"></span>
							</button>
							<div id="collapseResult" class="collapse" data-parent="#accordionResult">
								<div class="collapse-content"></div>
							</div>
						</li>	
					</ul>
				</div>
			</div>
			
			<footer id="panel-footer" class="panel-footer sub-bar">
				<div class="ml-auto">				
					<a href="javascript:void(0);" id="referenceBtn"    class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="goReferenceModal"	title="<fmt:message>head.referenceTreeInfo</fmt:message>"><i class="icon-result"></i><fmt:message>head.referenceTreeInfo</fmt:message></a>
					<a href="javascript:void(0);" id="guideBtn"    	   class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="guide"			title="<fmt:message>igate.connector.guide</fmt:message>"><fmt:message>igate.connector.guide</fmt:message></a>
					<a href="javascript:void(0);" id="externalGuideBtn"class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="externalGuide"	title="<fmt:message>igate.external.guide</fmt:message>"><fmt:message>igate.external.guide</fmt:message></a>
					<a href="javascript:void(0);" id="dumpBtn"   	   class="btn viewGroup"    		        	   	style="display: none;"    v-on:click="dump"		 		title="<fmt:message>head.dump</fmt:message>"><fmt:message>head.dump</fmt:message></a>
					<a href="javascript:void(0);" id="startBtn"        class="viewGroup btn btn-m"    				    style="display: none;" 	  v-on:click="start" 			title="<fmt:message>head.execute</fmt:message>"><i class="icon-play"></i><fmt:message>head.execute</fmt:message></a>			
					<a href="javascript:void(0);" id="stopBtn"    	   class="btn viewGroup" 	    		           	style="display: none;"    v-on:click="stop"		 		title="<fmt:message>head.stop</fmt:message>"><i class="icon-pause"></i><fmt:message>head.stop</fmt:message></a>
					<a href="javascript:void(0);" id="stopForceBtn"    class="btn viewGroup"    		        	   	style="display: none;"    v-on:click="stopForce" 		title="<fmt:message>head.stop.force</fmt:message>"><i class="icon-x"></i><fmt:message>head.stop.force</fmt:message></a>
					<a href="javascript:void(0);" id="interruptBtn"    class="viewGroup btn btn-m"    				 	style="display: none;" 	  v-on:click="interrupt" 		title="<fmt:message>head.interrupt</fmt:message>"><fmt:message>head.interrupt</fmt:message></a>
					<a href="javascript:void(0);" id="blockBtn" 	   class="viewGroup btn btn-m"    				 	style="display: none;" 	  v-on:click="block"			title="<fmt:message>head.block</fmt:message>"><fmt:message>head.block</fmt:message></a>
					<a href="javascript:void(0);" id="unblockBtn" 	   class="viewGroup btn btn-m"   				 	style="display: none;" 	  v-on:click="unblock" 			title="<fmt:message>head.unblock</fmt:message>"><fmt:message>head.unblock</fmt:message></a>					
					<a href="javascript:void(0);" id="removeBtn"       class="btn viewGroup removeBtn" 		  		   	style="display: none;"    v-on:click="removeInfo"		title="<fmt:message>head.delete</fmt:message>"><i class="icon-delete"></i><fmt:message>head.delete</fmt:message></a>
					<a href="javascript:void(0);" id="goModBtn"        class="btn viewGroup goModBtn" 		  		   	style="display: none;"    v-on:click="goModifyPanel"	title="<fmt:message>head.update</fmt:message>"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>						
					<a href="javascript:void(0);" id="saveBtn"         class="btn btn-primary saveGroup saveBtn" 	   	style="display: none;"    v-on:click="saveInfo"			title="<fmt:message>head.insert</fmt:message>"><fmt:message>head.insert</fmt:message></a>
					<a href="javascript:void(0);" id="updateBtn"       class="btn btn-primary updateGroup updateBtn"   	style="display: none;"    v-on:click="updateInfo"		title="<fmt:message>head.update</fmt:message>"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>
					<a href="javascript:void(0);" id="goAddBtn"        class="btn btn-primary viewGroup goAddBtn" 	 	style="display: none;"    v-on:click="goAddInfo" 		title="<fmt:message>head.insert</fmt:message>"><i class="icon-plus"></i><fmt:message>head.insert</fmt:message> (<fmt:message>head.copy</fmt:message>)</a>		
				</div>
			</footer>
			
		</div>
	</div>
</div>

<script type="text/javascript">
var panelMethodOption = {
	goPreviousPanel: function() {
		var rowKey = SearchImngObj.searchGrid.getFocusedCell().rowKey;
		
   		if ('number' === typeof rowKey && -1 < rowKey) {
   			SearchImngObj.clicked(SearchImngObj.searchGrid.getRow(rowKey));
   		}else {
   			panelOpen('detail');
   		}
   	},
   	goDetailPanel: function() {
   		panelOpen('detail');
   	},
   	goModifyPanel: function() {
   		panelOpen('modify');
   	},
   	goAddInfo: function() {
   		panelOpen('add', window.vmMain.object);
   	},
   	togglePanel: function() {
		beforeDragEvt = null;

		if (document.querySelector('#panel').classList.contains('horizon')) {
			panelContentStyle.width = null;
			panelContentStyle['margin-left'] = null;

			document.querySelector('#panel .panel-content').style.width = null;
			document.querySelector('#panel .panel-content').style['margin-left'] = null;
			
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';
		} else {
			panelContentStyle.height = null;
			
			document.querySelector('#panel .panel-content').style.height = null;
		}
		
		localStorage.setItem(
			'detailLayoutInfo_' + menuId,
			JSON.stringify({
				panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
				panelContentStyle: panelContentStyle,
				screenType: screenType
			})
		);
		
   		$('#panel').toggleClass('expand');
		
   		windowResizeSearchGrid();
   	},
   	closePanel: function() {
   		panelClose('panel');
   		
		if (document.querySelector('#panel').classList.contains('horizon')) {
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';	
		}   		
   	}, 	
   	removeInfo: function() {
   		SaveImngObj.remove('<fmt:message>dashboard.delete.warn</fmt:message>', '<fmt:message>dashboard.delete.success</fmt:message>', this.closePanel);
   	},
   	updateInfo: function() {
   		SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
   	},
   	saveInfo: function() {
   		SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
   	},
   	load: function() {
   		ControlImngObj.load();
   	},
   	dump: function() {
   		ControlImngObj.dump();
   	},
   	changeLayout: function(type) {
   		beforeDragEvt = null;
   		
		document.querySelector('#panel').classList.remove('horizon', 'vertical');
		document.querySelector('#panel').classList.add('vertical' === type ? 'vertical' : 'horizon');
		
		panelContentStyle.width = null;
		panelContentStyle.height = null;
		panelContentStyle['margin-left'] = null;
		
		document.querySelector('#panel .panel-content').style.width = panelContentStyle.width;
		document.querySelector('#panel .panel-content').style.height = panelContentStyle.height;
		document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];
	
		var isModMode = $('body').hasClass('panel-open-mod');
		
		if (document.querySelector('#panel .sub-bar-tit'))
			document.querySelector('#panel .sub-bar-tit').style.width = 'calc(100% - ' + (isModMode ? 170 : 125) + 'px)';
		
		if (document.querySelector('#panel .sub-bar-selected-tit'))
			document.querySelector('#panel .sub-bar-selected-tit').style.width = 'calc(100% - ' + (isModMode ? 80 : 65) + 'px)';	 	
		
		if (document.querySelector('#panel').classList.contains('vertical')) {
			document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
			document.querySelector('.customLayout > [data-ready]').style.width = null;				
		} else {
			document.querySelector('.customLayout > [data-ready]').classList.add('horizon');
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';
		}		
		
		localStorage.setItem(
			'detailLayoutInfo_' + menuId,
			JSON.stringify({
				panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
				panelContentStyle: panelContentStyle,
				screenType: screenType
			})
		);
		
		windowResizeSearchGrid();
		
		$('[data-ready]').each(function (index, element) {
			element.dispatchEvent(new CustomEvent('resize'));
		});		
   	},
	goReferenceModal: function(referenceParam, className) {
		var resourceTypeList = {
			'com.inzent.igate.repository.meta.FieldMeta': {
				label: '<fmt:message>igate.fieldMeta</fmt:message>',
				dataId: 'fieldId'
			},
			'com.inzent.igate.repository.meta.Adapter': {
				label: '<fmt:message>igate.adapter</fmt:message>',
				dataId: 'adapterId',
				menuId: '202030',
				searchData: 'adapterId'
			},
			'com.inzent.igate.repository.meta.Interface': {
				label: '<fmt:message>igate.interface</fmt:message>',
				dataId: 'interfaceId',
				menuId: '101050',
				searchData: 'interfaceId'
			},
			'com.inzent.igate.repository.meta.InterfacePolicy': {
				label: '<fmt:message>igate.interfacePolicy</fmt:message>',
				isPkData: true,
				dataId: 'adapterId',
				menuId: '202030',
				searchData: 'adapterId'
			},
			'com.inzent.igate.repository.meta.InterfaceRecognize': {
				label: '<fmt:message>igate.interfaceRecognize</fmt:message>',
				isPkData: true,
				dataId: 'adapterId',
				menuId: '101060',
				searchData: 'pk.adapterId'
			},
			'com.inzent.igate.repository.meta.Job': {
				label: '<fmt:message>igate.job</fmt:message>',
				dataId: 'jobId',
				menuId: '204010',
				searchData: 'jobId'
			},
			'com.inzent.igate.repository.meta.Mapping': {
				label: '<fmt:message>igate.mapping</fmt:message>',
				dataId: 'mappingId',
				menuId: '101020',
				searchData: 'mappingId'
			},
			'com.inzent.igate.repository.meta.OnlineHeaderMappingPolicy': {
				label: '<fmt:message>igate.onlineHeaderMappingPolicy</fmt:message>',
				isPkData: true,
				dataId: ['interfaceAdapterId', 'serviceAdapterId'],
				menuId: '203010',
				searchData: ['pk.interfaceAdapterId', 'pk.serviceAdapterId'],
				searchLabel: ['<fmt:message>igate.interface</fmt:message>', '<fmt:message>igate.service</fmt:message>']
			},
			'com.inzent.igate.repository.meta.Operation': {
				label: '<fmt:message>igate.operation</fmt:message>',
				dataId: 'operationId',
				menuId: '102070',
				searchData: 'operationId'
			},
			'com.inzent.igate.repository.meta.Query': {
				label: '<fmt:message>igate.query</fmt:message>',
				dataId: 'queryId',
				menuId: '101070',
				searchData: 'queryId'
			},
			'com.inzent.igate.repository.meta.Record': {
				label: '<fmt:message>igate.modelRecord</fmt:message>',
				dataId: 'recordId',
				menuId: '101010',
				searchData: 'recordId'
			},
			'com.inzent.igate.repository.log.ReplyEmulate': {
				label: '<fmt:message>igate.service.replyemulate</fmt:message>',
				isPkData: true,
				dataId: 'replyId'
			},
			'com.inzent.igate.repository.meta.Service': {
				label: '<fmt:message>igate.service</fmt:message>',
				dataId: 'serviceId',
				menuId: '101030',
				searchData: 'serviceId'
			},
			'com.inzent.igate.repository.meta.ServicePolicy': {
				label: '<fmt:message>igate.servicePolicy</fmt:message>',
				isPkData: true,
				dataId: 'adapterId',
				menuId: '202030',
				searchData: 'adapterId'
			},
			'com.inzent.igate.repository.meta.ServiceRecognize': {
				label: '<fmt:message>igate.serviceRecognize</fmt:message>',
				isPkData: true,
				dataId: 'adapterId',
				menuId: '101040',
				searchData: 'pk.adapterId'
			},
			'com.inzent.igate.repository.log.TestCase': {
				label: '<fmt:message>igate.testcase</fmt:message>',
				isPkData: true,
				dataId: 'testCaseId'
			},
			'com.inzent.igate.repository.log.TestSuite': {
				label: '<fmt:message>igate.testsuite</fmt:message>',
				dataId: 'testSuiteId'
			}
		};
				
		var modalHtml = '';
		
		modalHtml += '	<div id="referenceTreeInfoCt">';
		modalHtml += '		<div class="table-responsive">';
		modalHtml += '			<div id="referenceGrid"></div>';
		modalHtml += '		</div>';
		modalHtml += '	</div>';
		
		var vmLicenseExpiration = null;
		
		openModal({
			name: 'referenceTreeInfo',
			title: '<fmt:message>head.referenceTreeInfo</fmt:message>',
			width: '900px',
			bodyHtml: modalHtml,
			buttonList: [
				{
					customBtnId: 'exportBtn',
					customBtn: '<fmt:message>head.excel.output</fmt:message>',
					customBtnAction: function() {
						if (null === vmLicenseExpiration) return;
						
						var grid = vmLicenseExpiration.makeGridObj.getSearchGrid();
						
						var headerInfo = {};
																		
						grid.getColumns().forEach(function(column) {
							if (column.hidden) return;
							
							headerInfo[column.name] = column.header;
						})
						
						var workbook = XLSX.utils.book_new();
						
						var exportData = grid.getData();	
						
						var sheetData = exportData.map(function(data) {
							var className = resourceTypeList[data.className].label;
							var resourceName = data.resourceName;
							var updateUserId = data.updateUserId;
							var updateTimestamp = data.updateTimestamp;
							
							return { 
								className: className, 
								resourceName: resourceName, 
								updateUserId: updateUserId, 
								updateTimestamp: updateTimestamp 
							}
						});
																		
						sheetData.unshift(headerInfo)
						
						var firstSheet = XLSX.utils.json_to_sheet( sheetData, { header: Object.keys(headerInfo), skipHeader: true });
							
						firstSheet['!cols'] = [{ wpx: 120 }, { wpx: 250 }, { wpx: 150 }, { wpx: 150 }];
						
						XLSX.utils.book_append_sheet(workbook, firstSheet, '<fmt:message>head.referenceTreeInfo</fmt:message>');

						XLSX.writeFile(workbook, 'Reference_' + moment(new Date()).format('YYYYMMDD_HHmmss') + '.xlsx');
					}
				}
			],
			shownCallBackFunc: function(btnList) {
				vmLicenseExpiration = new Vue({
					el: document.getElementById('referenceTreeInfoCt'),
					data: {
						makeGridObj: null
					},
					mounted: function() {						
						this.makeGridObj = getMakeGridObj();
						this.makeGridObj.setConfig({
							el: document.getElementById('referenceGrid'),
							data: [],
							width: '900px',
							bodyHeight: 500,
							treeColumnOptions: {
								name: 'className'
							},
							columns: [
								{
									name: 'resourceObject',
									hidden: true
								},
								{
									name: 'className',
									header: '<fmt:message>head.publishLog.resource.type</fmt:message>',
									width: '25%',
									formatter: function(val) {
										return resourceTypeList[val.row.className].label;
									}
								},
								{
									name: 'resourceName',
									header: '<fmt:message>head.name</fmt:message>',
									width: '35%',
									formatter: function(val) {
										var resourceName = '';
										
										if (resourceTypeList[val.row.className].searchLabel) {
											resourceTypeList[val.row.className].searchLabel.forEach(function(label, idx) {
												resourceName += '<span' + 0 === val.row.rowKey ? '' : 'class="link-new-tab"' + '>' + label + '<fmt:message>igate.adapter</fmt:message>' + escapeHtml(val.row.resourceName.split(',')[idx]) + '</span>';
											})
										} else {
											var spanStyle = 0 === val.row.rowKey || 0 === val.row.className.indexOf('com.inzent.igate.repository.log') ? '': 'class="link-new-tab"' 
											
											resourceName = '<span ' + spanStyle + '>' + escapeHtml(val.row.resourceName) + '</span>'
										}
										
										return resourceName;
									}
								},
								{
									name: 'updateTimestamp',
									header: '<fmt:message>igate.notice.created.date</fmt:message>',
									width: '20%',
									align: 'center'
								},
								{
									name: 'updateUserId',
									header: '<fmt:message>igate.notice.writer</fmt:message>',
									width: '20%'
								}
							],
							onGridUpdated: function(evt) {
				            	setTimeout(function() {
				            		evt.instance.expand(0, false);				            		
				            	}, 0)
							},
							onGridMounted: function(evt) {
				            	evt.instance.on('click', function(evt) {
				            		if(!evt.nativeEvent.target.classList.contains('link-new-tab')) return;
				            		
				            		var rowInfo = evt.instance.getRow(evt.rowKey);
				            		var resourceInfo = resourceTypeList[rowInfo.className];
				            										
									var searchResourceData = { _pageSize: '10' };
									
									if (-1 !== rowInfo.resourceName.indexOf(',')) {
										rowInfo.resourceName.split(',').forEach(function(data, idx) {
											searchResourceData[resourceInfo.searchData[idx]] = data.trim();
										});
									} else searchResourceData[resourceInfo.searchData] = rowInfo.resourceName;
									
									openNewTab(resourceInfo.menuId, function() {
										localStorage.removeItem('searchObj');
										localStorage.removeItem('detailObj');
										
										localStorage.setItem('searchObj', JSON.stringify(searchResourceData));
										localStorage.setItem('detailObj', JSON.stringify(rowInfo.resourceObject));
				            		});      		
				            	});
				            	
				            	evt.instance.on('expand', function(evt) {
				            		resize();
				            	});
				            	
				            	evt.instance.on('collapse', function(evt) {
				            		resize();
				            	});
				            }
						}, true)
						
						var grid = this.makeGridObj.getSearchGrid();
						
						setTimeout(function() {
							new HttpReq('/api/reference/entity').read({'object': referenceParam, 'className': className }, function (res) {
								
								if('ok' !== res.result) {
									window._alert({ type: 'warn', message: res.error[0].message });
									return;
								}
								
								var resData = res.object ;
								
						        grid.resetData([initTreeData(resData)]);
							});
						}, 0);
					},
				});
			}
		})
		
		var setResourceName = function(record, parentName) {
			var resourceTypeData = resourceTypeList[record.className];

			return 'object' === typeof resourceTypeData.dataId
				? Object.values(record.object.pk).join(',')
				: record.className.startsWith('com.inzent.igate.repository.log')
				? parentName + '@' + record.object.pk[resourceTypeData.dataId]
				: resourceTypeData.isPkData
				? record.object.pk[resourceTypeData.dataId]
				: record.object[resourceTypeData.dataId];
		};
		
		var initTreeData = function(record, parentName) {
			var treeData = {
					resourceObject: record.object,
					className: record.className,
					resourceName: setResourceName(record, parentName),
					updateUserId: record.object.updateUserId ? record.object.updateUserId : '-',
					updateTimestamp: record.object.updateTimestamp ? changeDateFormat(record.object.updateTimestamp) : '-'
				};
			
			if (record.referencing && 0 < record.referencing.length) {
				treeData._children = [];

				record.referencing.forEach(function(field) {
					var subTreeData = {
						resourceObject: field.object,
						className: field.className,
						resourceName: setResourceName(field, treeData.resourceName),
						updateUserId: field.object.updateUserId ? field.object.updateUserId : '-',
						updateTimestamp: field.object.updateTimestamp ? changeDateFormat(field.object.updateTimestamp) : '-'
					};
					

 					if (field.referencing && 0 < field.referencing.length) {
						if (!subTreeData._children) {
							subTreeData._children = [];
						}

						field.referencing.forEach(function(reference ) {
							subTreeData._children.splice(subTreeData._children, 0, initTreeData(reference, subTreeData.resourceName))
						});
					}

					treeData._children.splice(treeData._children.length, 0, subTreeData);
				});
			}
			
			return treeData ;
		}
   	
		var resize = function() {
			setTimeout(function () {
				var grid = vmLicenseExpiration.makeGridObj.getSearchGrid();
				
				if (!this.grid) return;
				
				var modalBody = document.querySelector('.modal-body');

				var modalBodyComputedStyle = getComputedStyle(modalBody);

				var modalBodyPaddingLeft = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-left'));
				var modalBodyPaddingRight = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-right'));
				var modalBodyPaddingTop = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-top'));
				var modalBodyPaddingBottom = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-bottom'));

				this.grid.setWidth(modalBody.clientWidth - modalBodyPaddingLeft - modalBodyPaddingRight);
				this.grid.setHeight(modalBody.clientHeight - modalBodyPaddingTop - modalBodyPaddingBottom);
                  }, 0);
		}
	}
};

document.querySelector('#panel').addEventListener('detailReady', detailReady);
document.querySelector('#panel').addEventListener('detailDestroy', detailDestroy);	

var panelContentStyle = { 'width': null, 'height': null, 'margin-left': null };
var beforeDragEvt = null;
var screenType = null;
var selectedMenuPathIdList = JSON.parse(sessionStorage.getItem('selectedMenuPathIdList'));
var menuId = selectedMenuPathIdList[selectedMenuPathIdList.length - 1].split('_')[0];

function detailReady() {
	screenType = 991 < window.innerWidth ? 'pc' : 767 < window.innerWidth ? 'tablet' : 'mobile';
	
	if (localStorage.getItem('detailLayoutInfo_' + menuId)) {
		var detailLayoutInfo = JSON.parse(localStorage.getItem('detailLayoutInfo_' + menuId));

		if (screenType !== detailLayoutInfo.screenType) {
			initDefaultDetailLayoutInfo();
		} else {
			document.querySelector('#panel').classList.remove('horizon', 'vertical');
			document.querySelector('#panel').classList.add('vertical' === detailLayoutInfo.panelLayoutDirection? 'vertical' : 'horizon');
			
			panelContentStyle = detailLayoutInfo.panelContentStyle;
			
			document.querySelector('#panel .panel-content').style.width = panelContentStyle.width? panelContentStyle.width + 'px' : null;
			document.querySelector('#panel .panel-content').style.height = panelContentStyle.height? panelContentStyle.height + 'px' : null;
			document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left']? panelContentStyle['margin-left'] : null;
			
			if (document.querySelector('#panel').classList.contains('vertical')) {
				document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
				document.querySelector('.customLayout > [data-ready]').style.width = null;				
			} else {
				document.querySelector('.customLayout > [data-ready]').classList.add('horizon');
				document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - (null === panelContentStyle.width? 500 : panelContentStyle.width) + 'px';
			}			
		}
	} else {
		initDefaultDetailLayoutInfo();
	}	

	document.body.removeEventListener('mousedown', mousedown);
	document.body.removeEventListener('resize', bodyResize);
	
	document.body.addEventListener('mousedown', mousedown);
	document.body.addEventListener('resize', bodyResize);
}

function detailDestroy() {
	document.body.removeEventListener('mousedown', mousedown);
	document.body.removeEventListener('resize', bodyResize);	
}

function mousedown(evt) {
	if (!evt.target.classList.contains('resize-bar')) return;

	var mouseup = function() {
		document.body.removeEventListener('mousemove', mousemove);
		document.body.removeEventListener('mouseup', mouseup);
		document.body.removeEventListener('mouseleave', mouseleave);
	};

	var mousemove = function(evt) {
		detailResize(evt);
		evt.preventDefault();
	};

	var mouseleave = function() {
		document.body.removeEventListener('mousemove', mousemove);
		document.body.removeEventListener('mouseup', mouseup);
		document.body.removeEventListener('mouseleave', mouseleave);
	};

	document.body.addEventListener('mousemove', mousemove);
	document.body.addEventListener('mouseup', mouseup);
	document.body.addEventListener('mouseleave', mouseleave);
}

function detailResize(evt) {
	if (document.querySelector('#panel').classList.contains('vertical')) {
		if (0 === evt.clientY) return;

		if (null !== panelContentStyle.width) panelContentStyle.width = null;
		
		if (null !== panelContentStyle['margin-left']) panelContentStyle['margin-left'] = null;

		if (!beforeDragEvt) {
			beforeDragEvt = evt;
			panelContentStyle.height = document.querySelector('#panel .panel-content').clientHeight;
		} else if (evt.clientY < beforeDragEvt.clientY) {
			panelContentStyle.height = panelContentStyle.height + (beforeDragEvt.clientY - evt.clientY);
		} else {
			panelContentStyle.height = panelContentStyle.height - (evt.clientY - beforeDragEvt.clientY);
		}
		
		if (document.body.clientHeight - (992 <= window.innerWidth ? 72 : 50) <= panelContentStyle.height) {
			panelContentStyle.height = document.body.clientHeight - (992 <= window.innerWidth ? 72 : 50);
			return;
		}

		if (panelContentStyle.height < 100) {
			panelContentStyle.height = 100;
			return;
		}
	} else {
		if (0 === evt.clientX) return;

		if (null !== panelContentStyle.height) panelContentStyle.height = null;

		if (!beforeDragEvt) {
			beforeDragEvt = evt;
			panelContentStyle.width = document.querySelector('#panel .panel-content').clientWidth;
		} else if (evt.clientX < beforeDragEvt.clientX) {
			panelContentStyle.width = panelContentStyle.width + (beforeDragEvt.clientX - evt.clientX);
		} else {
			panelContentStyle.width = panelContentStyle.width - (evt.clientX - beforeDragEvt.clientX);
		}
		
		if (document.body.clientWidth - 240 <= panelContentStyle.width) {
			panelContentStyle.width = document.body.clientWidth - 240;
			return;
		}

		if (panelContentStyle.width < 240) {
			panelContentStyle.width = 240;
			return;
		}
		
		panelContentStyle['margin-left'] = 'calc(100% - ' + panelContentStyle.width + 'px)';
		document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';		
	}

	document.querySelector('#panel .panel-content').style.width = panelContentStyle.width? panelContentStyle.width + 'px' : null;
	document.querySelector('#panel .panel-content').style.height = panelContentStyle.height? panelContentStyle.height + 'px' : null;
	document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left']? panelContentStyle['margin-left'] : null;
	
	beforeDragEvt = evt;
	
	windowResizeSearchGrid();
	
	document.querySelector('#panel').classList.remove('expand');

	localStorage.setItem(
		'detailLayoutInfo_' + menuId,
		JSON.stringify({
			panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
			panelContentStyle: panelContentStyle,
			screenType: screenType
		})
	);	
	
	windowResizeSearchGrid();
	
	$('[data-ready]').each(function (index, element) {
		element.dispatchEvent(new CustomEvent('resize'));
	});		
}

function bodyResize(evt) {
	var isChangeVerticalLayout = false;

	if (991 < window.innerWidth) {
		if ('pc' !== screenType) isChangeVerticalLayout = true;
		else if (document.querySelector('#panel').classList.contains('horizon'))  {
			beforeDragEvt = null;
			
			if (panelContentStyle.width && document.body.clientWidth - 240 <= panelContentStyle.width) {
				panelContentStyle.width = document.body.clientWidth - 240;
				panelContentStyle['margin-left'] = 'calc(100% - ' + panelContentStyle.width + 'px)';
				
				document.querySelector('#panel .panel-content').style.width = panelContentStyle.width + 'px';
				document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];
				
				localStorage.setItem(
					'detailLayoutInfo_' + menuId,
					JSON.stringify({
						panelLayoutDirection: 'horizon',
						panelContentStyle: panelContentStyle,
						screenType: screenType
					})
				);				
			}

			var adjustWidth = window.innerWidth - ($('#ct').innerWidth() - $('#ct').width());
			
			if (992 <= window.innerWidth && !$('body').hasClass('sidebar-toggled') && 0 < $('#sidebar').length) {
				adjustWidth -= $('#sidebar').outerWidth(true);
			}
			
			if (document.querySelector('.horizon') && 'block' === document.querySelector('#panel').style.display) {
				adjustWidth -= getNumFromStr(getComputedStyle(document.querySelector('.horizon .panel-content')).width);
			}
	
			document.querySelector('.customLayout > [data-ready]').style.width = adjustWidth + 'px';
		}
	} else {
		if (document.querySelector('#panel').classList.contains('horizon')) isChangeVerticalLayout = true;
		else if (767 < window.innerWidth) isChangeVerticalLayout = 'tablet' !== screenType;
		else if (767 >= window.innerWidth) isChangeVerticalLayout = 'mobile' !== screenType;
	}

	screenType = 991 < window.innerWidth ? 'pc' : 767 < window.innerWidth ? 'tablet' : 'mobile';

	if (isChangeVerticalLayout) panelMethodOption.changeLayout('vertical');		
	
	if (document.querySelector('#panel').classList.contains('vertical')) {
		if (document.body.clientHeight < document.querySelector('#panel .panel-content').clientHeight) {
			panelMethodOption.changeLayout('vertical');
		}
	}
}

function initDefaultDetailLayoutInfo() {
	document.querySelector('#panel').classList.remove('horizon', 'vertical');
	document.querySelector('#panel').classList.add('vertical');

	panelContentStyle.width = null;
	panelContentStyle.height = null;
	panelContentStyle['margin-left'] = null;

	document.querySelector('#panel .panel-content').style.width = panelContentStyle.width;
	document.querySelector('#panel .panel-content').style.height = panelContentStyle.height;
	document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];

	document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
	document.querySelector('.customLayout > [data-ready]').style.width = null;
	
 	localStorage.setItem(
		'detailLayoutInfo_' + menuId,
		JSON.stringify({
			panelLayoutDirection: 'vertical',
			panelContentStyle: panelContentStyle,
			screenType: screenType
		})
	);
}
</script>