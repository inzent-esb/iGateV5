function DashContainerView(dashContainerElement, dashContainerOptions) {

	var containerList = [];

	var intervalId = null;
	var rafId = null;
	var refreshTimeoutId = null;
	
	var dataIntervalSeconds = 5;

	var monitorSocket = null;

	var minContainerWidth = 1280;
	var minContainerHeight = 1024;
		
	//"ws://localhost:9090/iMonitor/message"
	var messageUrl = dashContainerOptions.websocketUrl + "/message"; 
	
	var noticeGrid = null;
	var noticeDataList = [];
	var noticeDataHistoryList = [];
		
	//대상 동기화 시간.
	var targetSyncRefreshTime = null;		

	var _this = this;
	
	DashContainerParent.call(_this);
	
	_this.initDashMode = function() {
		
		$(dashContainerElement).removeClass().addClass('ct-dashboard');
		
		_this.element.dashContainer = dashContainerElement;

		_this.initDashSubBar(
			[
				$('<button type="button" id="viewNoticeBtn" class="custom-control custom-switch btn-widget"></button>').append($('<span class="custom-control-label">' + dashboardNotificationSettings + '</span>')),
				$('<a href="javascript:void(0);" id="evtHistoryListBtn" class="btn" data-toggle="modal"><i class="icon-list"></i>'+ dashboardNotificationHistoryList +'</a>'),
				$('<a href="javascript:void(0);" id="previewContainerMode" class="btn" data-toggle="modal"><i class="icon-eye"></i>'+ dashboardLabel_fullScreen +'</a>'),
				$('<a href="javascript:void(0);" id="shareContainerMode" class="btn" data-toggle="modal"><i class="icon-share"></i>'+ dashboardBtn_share +'</a>'),
				$('<a href="javascript:void(0);" id="migrationContainerMode" class="btn" data-toggle="modal"><i class="icon-model"></i>'+ dashboardLabel_migration +'</a>'),
				$('<a href="javascript:void(0);" id="copyContainerMode" class="btn"><i class="icon-plus"></i>'+ dashboardBtn_copy +'</a>'),
				$('<a href="javascript:void(0);" id="modifyContainerMode" class="btn"><i class="icon-edit"></i>'+ dashboardBtn_modify +'</a>'),
				$('<a href="javascript:void(0);" id="deleteContainer" class="btn"><i class="icon-delete"></i>'+ dashboardBtn_delete +'</a>'),
				$('<a href="javascript:void(0);" id="saveContainerMode" class="btn btn-primary" data-toggle="modal"><i class="icon-plus"></i>'+ dashboardLabel_addDashboard +'</a>')
			],
			function() {
				$('#dashBar').find('.ml-auto').before(
					$('<div class="form-inline"></div>').append($('<select id="containerList" class="form-control" style="max-width: 300px;text-overflow: ellipsis;"></select>'))
				);

				if(!hasDashBoardEditor) {
					$('#shareContainerMode').hide();
					$('#migrationContainerMode').hide();
					$('#copyContainerMode').hide();
					$('#modifyContainerMode').hide();
					$('#deleteContainer').hide();
					$('#saveContainerMode').hide();
				}
			}
		);			
		
		_this.initDashArea();
		
		_this.initDashModal();
		
		_this.initDashModalLarge();
		
		initDashViewNotice();
		
		getContainerList(function() {
			initDashViewModeEvtBind();
			
			_this.setTargetInfo(function() {
		        _this.instanceList.forEach(function(instance, index) {
		        	instance.color = COLORS[index];
		        	instance.isFiltered = false;
		        });					
				
				_this.setPerfItemList(function() {
					$("#containerList").trigger('change');		
				});
			});
		});
	};
	
	_this.customResizeCallBackFunc = function() {
		if(screen.width == window.innerWidth && screen.height == window.innerHeight) return;
		
    	$("#dashContextMenu").remove();
    	$("#dashContextSetting").remove();
	};
	
	function initDashViewNotice() {
		
		var strHtml = '';
		
		strHtml += '<section id="noticeArea" class="card" style="width: ' + noticeAreaWidth + 'px; height: ' + noticeAreaHeight + 'px; display: none;">';
		strHtml += '	<h2 class="card-header" style="padding: 0px;">';
		strHtml += '		<ul>';
		strHtml += '			<li class="nav-link"><i class="gicon-txns"></i><span>' + dashboardNotification + '</span></li>';
		strHtml += '			<li class="nav-link export-nav-link close" style="padding: 0 0.8rem 0 0; cursor: pointer;"><i class="icon-close"></i></li>';
		strHtml += '		</ul>';
		strHtml += '	</h2>';
		strHtml += '	<div class="card-body" style="padding-top: 0px; overflow-y: auto;">';
		strHtml += '		<div id="noticeGrid"></div>';
		strHtml += '	</div>';
		strHtml += '</section>';

		$(dashContainerElement).append($(strHtml));
		
		var settings = {
			el : document.getElementById('noticeGrid'),
			data: null,
			columns : [
						{
							name : "noticeDateTime", 
							header : dashboardNotificationTime, 
							align : "center",
							width: noticeDateTimeColWidth
						},
						{
							name : "instanceId",     
							header : dashboardNotificationInstanceId, 
							width: noticeInstanceIdColWidth
						},
						{
							name : "message",     	  
							header : dashboardNotificationMessage, 
							width: noticeMessageColWidth
						},
						{
							name : "status",     	  
							header : dashboardNotificationHeadStatus, 
							align : "center",
							width: noticeStatusColWidth
						},
					  ],
			columnOptions : {
				resizable : true
			},
			usageStatistics : false,
			header: {
				height: 32,
				align: 'center'
			},
			onGridMounted : function() {
	        	var resetColumnWidths = [];
	        	
	        	noticeGrid.getColumns().forEach(function(columnInfo) {
	        		if(!columnInfo.copyOptions) return;

	        		if(columnInfo.copyOptions.widthRatio) {
	        			var paddingLeft = Number($("#noticeArea").find('.card-body').css('padding-left').replace(/[^0-9]/g, ""));
	        			var paddingRight = Number($("#noticeArea").find('.card-body').css('padding-right').replace(/[^0-9]/g, ""));
	        			
	        			resetColumnWidths.push((noticeAreaWidth - (paddingLeft + paddingRight)) * (columnInfo.copyOptions.widthRatio / 100));
	        		}
	        	});

	        	if(0 < resetColumnWidths.length)
	        		noticeGrid.resetColumnWidths(resetColumnWidths);
	        	
	        	$('#noticeGrid').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
	        },			
	    	scrollX: false,
	    	scrollY: false				
		};
		
		settings.columns.forEach(function(column) {
			if(!column.formatter) 
				column.escapeHTML = true;  

			if(column.width && -1 < String(column.width).indexOf('%')) {
				if(!column.copyOptions) 
					column.copyOptions = {};

				column.copyOptions.widthRatio = column.width.replace('%', '');
	    		  
				delete column.width;
			}
		});	
		
		noticeGrid = new tui.Grid(settings);
	}
	
	function getContainerList(callBackFunc) {
		$.ajax({
			type : 'GET',
			url : contextPath + '/igate/monitoring/dashboard/container.json',
			data : null,
			dataType : "json",
			success : function(res) {
				if('ok' != res.result) return;
				
				containerList = res.object;
				
				$("#containerList").empty().append($("<option/>").attr({'value' : '-'}).text(dashboardMsg_selectContainer));
				
				containerList.forEach(function(container, index) {
					
					var option = $("<option/>").attr({'value' : container.containerId}).text(container.containerName);
					
					if (!localStorage.getItem('selectedContainerId') && 0 == index)
						localStorage.setItem('selectedContainerId', container.containerId);
					
					if(localStorage.getItem('selectedContainerId') == container.containerId)
						option.prop('selected', true);
					
					$("#containerList").append(option);
				});					
				
				if(callBackFunc) callBackFunc();
			},
			error : function(request, status, error) {
				console.log(request)
				console.log(error)
			}
		});
	}

	function initDashViewModeEvtBind() {

		$("#containerList").on('change', function() {
			
			$(dashContainerElement).parent().removeClass('dark');

			unloadContainer();

	    	if ('-' == $(this).val()) {
	    		$(this).removeAttr('title');
	    		$("#viewNoticeBtn").hide();
	    		$("#containerBody").empty();
	    		return false;
	    	}
	    	
	    	if('none' == $("#viewNoticeBtn").css('display')) 
				$("#viewNoticeBtn").show();

	    	var selectedContainerId = $(this).val();

	    	var selectedContainerInfo = containerList.filter(function(container) {
	    		return container.containerId == selectedContainerId;
	    	})[0];
	    	
	    	$.extend(true, _this.containerInfo, {
				containerId : selectedContainerInfo.containerId,
				containerName : selectedContainerInfo.containerName,
				containerWidth : selectedContainerInfo.containerWidth,
				containerHeight : selectedContainerInfo.containerHeight,
				remarkYn : selectedContainerInfo.remarkYn,
				darkmodeYn : selectedContainerInfo.darkmodeYn,
				monitorContainerUsers : selectedContainerInfo.monitorContainerUsers			
			});		    	

			_this.customResizeFunc();

			if(localStorage.getItem('isDashBoardWindowOpen') && 'Y' == localStorage.getItem('isDashBoardWindowOpen')) {
				localStorage.setItem('selectedContainerId', localStorage.getItem('beforeSelectedContainerId'));
				localStorage.removeItem('isDashBoardWindowOpen');
				localStorage.removeItem('beforeSelectedContainerId');
			}else{
				localStorage.setItem('selectedContainerId', _this.containerInfo.containerId);	
			}

	    	if('Y' == _this.containerInfo.darkmodeYn)
	    		$(dashContainerElement).parent().addClass('dark');

	    	if(noticeGrid) noticeGrid.clear();
	    	
	    	$("#noticeArea").hide();
	    	
	    	$("#noticeArea").removeData('temporaryCloseStartTime');
	    	
			if('true' == localStorage.getItem('isViewNotice_' + _this.containerInfo.containerId)) $('#viewNoticeBtn').addClass('checked');
			else																			      $('#viewNoticeBtn').removeClass('checked');
			
			_this.componentList.splice(0, _this.componentList.length);
			
			Array.prototype.push.apply(_this.componentList, selectedContainerInfo.monitorComponents.map(function(monitorComponent) { return $.extend(true, {}, monitorComponent); }));

	    	$(this).attr({'title': selectedContainerInfo.containerName});
			
	    	$("#containerBody").empty();

	    	appendComponentTag(_this.componentList.filter(function(componentObj) { return '-1' == componentObj.pComponentId })[0], $("#containerBody"));
	    	
	    	initChartEvtBind();
	    	
	    	initChartTargetInfo();
	      
	    	initRealTime();
	    	
	    	initRefresh();
		});

		$("#shareContainerMode").on('click', function() {
    	
	    	if(!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectShareDashboard});
	    		return;
	    	}

	    	var strHtml = '';
	        strHtml += '<div class="modal-header">';
	        strHtml += '    <h2 class="modal-title">'+ dashboardBtn_share +'</h2>';
	        strHtml += '    <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	        strHtml += '</div>';
	        strHtml += '<div class="modal-body py-0">';
	        strHtml += '	<div class="sub-bar" style="padding-top: 0px;">';
	        strHtml += '		<div class="form-inline m-full" style="width: 100%">';
	        strHtml += '			<input id="searchShareUser" type="text" class="form-control input-search" placeholder="'+ dashboardMsg_shareSearch +'" autocomplete="off" style="width: 100%">';
	        strHtml += '		</div>';
	        strHtml += '	</div>';
	        strHtml += '	<div id="shareUserListGrid"></div>';
	        strHtml += '</div>';
	        strHtml += '<div class="modal-footer">';
	        strHtml += '    <button type="button" id="closeShareBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	        strHtml += '    <button type="button" id="confirmShareBtn" class="btn btn-primary">'+ checkBtn +'</button>';
	        strHtml += '</div>';

	        $('#dashModal').find('.modal-content').empty();
	        $('#dashModal').find('.modal-content').append($(strHtml));
	        $('#dashModal').modal('show');
	        
	        var shareUserListGrid = null;
	        
	        $('#dashModal').off('shown.bs.modal').on('shown.bs.modal', function() {
				var settings = {
					el : document.getElementById('shareUserListGrid'),
					bodyHeight: 200,
					rowHeaders: ['checkbox'],
					columns : [
						{
							name : 'userId', 
							header : dashboardMsg_shareUserId, 
							formatter: function(info) {
								return escapeHtml(info.row.userId);
							}
						},
					],
					columnOptions : {
						hidden: true,
					},
					pageOptions: {
						useClient: true,
						type: 'scroll',
						perPage: 10
				   },
					usageStatistics : false,
					header: {
						height: 32,
						align: 'center'
					},
					onGridMounted : function() {
			        	var resetColumnWidths = [];
			        	
			        	shareUserListGrid.getColumns().forEach(function(columnInfo) {
			        		if(!columnInfo.copyOptions) return;

			        		if(columnInfo.copyOptions.widthRatio) {
			        			resetColumnWidths.push($('#shareUserListGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
			        		}
			        	});
			        	
			        	if(0 < resetColumnWidths.length)
			        		shareUserListGrid.resetColumnWidths(resetColumnWidths);
			        	
			        	$('#shareUserListGrid').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
			        },				
			    	scrollX: false,
			    	scrollY: true,
				};
				
				settings.columns.forEach(function(column) {
					if(!column.formatter) 
						column.escapeHTML = true;  

					if(column.width && -1 < String(column.width).indexOf('%')) {
						if(!column.copyOptions) 
							column.copyOptions = {};
			    		  
						column.copyOptions.widthRatio = column.width.replace('%', '');
			    		  
						delete column.width;
					}
				});
				
				shareUserListGrid = new tui.Grid(settings);
				
				shareUserListGrid.on('mouseover', function(ev) {
					if('cell' != ev.targetType) return;
			    	  
					var overCellElement = $(shareUserListGrid.getElement(ev.rowKey, ev.columnName));    	  
					overCellElement.attr('title', overCellElement.text());
				});
				
				shareUserListGrid.on('click', function(evt) {
					if('rowHeader' != evt.targetType) return;

					setTimeout(function() {
						if(-1 < shareUserListGrid.getCheckedRowKeys().indexOf(evt.rowKey)){
							shareUserListGrid.addRowClassName(evt.rowKey, "row-selected");
						}else{
							shareUserListGrid.removeRowClassName(evt.rowKey, "row-selected");
						}
					}, 0);
				});
				
				shareUserListGrid.on('checkAll', function(ev) {
					var allRows = shareUserListGrid.getData(); 
					
					for(var i = 0; i < allRows.length; i++){
						shareUserListGrid.addRowClassName(allRows[i].rowKey, "row-selected");
						shareUserListGrid.check(allRows[i].rowKey);
					}
				});
				
				shareUserListGrid.on('uncheckAll', function(ev) {
					var allRows = shareUserListGrid.getData(); 
					
					for(var i = 0; i < allRows.length; i++){
						shareUserListGrid.removeRowClassName(allRows[i].rowKey, "row-selected");
						shareUserListGrid.uncheck(allRows[i].rowKey);
					}
				});

				$.ajax({
		        	type : 'GET',
		        	url : contextPath + '/igate/monitoring/dashboard/user.json',
		        	data : {
		        		containerId : _this.containerInfo.containerId
		        	},
		        	dataType : "json",
		        	success : function(res) {
		        		if ('ok' != res.result) return;

		        		var allUserList = res.object.allUserList;
		        		var registerDashUserList = res.object.registerDashUserList;

		        		shareUserListGrid.resetData(allUserList);
		        	
		        		allUserList.forEach(function(userInfo, index) {
		            
		        			var isRegisterUser = 0 < registerDashUserList.filter(function(registerDashUser) { return registerDashUser.pk.containerUserId == userInfo.userId }).length;		        			
		        			
		        			if(isRegisterUser) {
		        				var rowKey = shareUserListGrid.getRowAt(index).rowKey;
		        				shareUserListGrid.check(rowKey);
		        				shareUserListGrid.addRowClassName(rowKey, "row-selected");
		        			}
		        		});
		        		
		        		$('#dashModal').find('#searchShareUser').on('keyup', function(key) {
		 		        	if(13 == key.keyCode) {
		 		        		var data = $(this).val();
		 		        		shareUserListGrid.resetData(allUserList.filter(function(row) { return row.userId.indexOf(data) > -1; }));
		 		        	}
		 		        });
		        	}
		        });
			});
	        
	        $('#dashModal').on('hidden.bs.modal', function(e) {
	        	shareUserListGrid.destroy();
	        }) ;
	        
	        $('#dashModal').find('#confirmShareBtn').off('click').on('click', function() {

	        	var shareParam = {
	        		_method: 'PUT',
					containerId : _this.containerInfo.containerId,
		            containerName : _this.containerInfo.containerName,
		            containerWidth : _this.containerInfo.containerWidth,
		            containerHeight : _this.containerInfo.containerHeight,
		            darkmodeYn : _this.containerInfo.darkmodeYn,
		            remarkYn : _this.containerInfo.remarkYn,
		            monitorComponents : _this.componentList,
		            monitorContainerUsers : (function() {
		            	var monitorContainerUsers = [];
		            	
		            	shareUserListGrid.getCheckedRows().forEach(function(shareUserInfo) {
		            		monitorContainerUsers.push({
		            			pk : {
		            				containerId : _this.containerInfo.containerId,
		            				containerUserId : shareUserInfo.userId
		            			}
		            		});
		            	})
		            
		            	return monitorContainerUsers;
		            })()		        			
	        	};

	        	$.ajax({
	        		type : 'POST',
	        		url : contextPath + '/igate/monitoring/dashboard/container.json',
	        		processData : false,
	        		data : JsonImngObj.serialize(shareParam),
	        		dataType : "json",
	        		success : function(result) {
	        			if ('ok' != result.result) return;
        	    	
			        	normalAlert({message : dashboardMsg_shareSuccess});
        	    	
	        			changeContainer('view');
	        		},
	        	});
	        });
		});

		$('#migrationContainerMode').on('click', function() {

			var strHtml = '';

	    	strHtml += '<div class="modal-header">';
	        strHtml += '    <h2 class="modal-title">'+ dashboardLabel_migration +'</h2>';
	        strHtml += '    <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	        strHtml += '</div>';
	        strHtml += '<div class="modal-body py-0">';
	        strHtml += '	<ul class="nav nav-tabs flex-shrink-0">';
	        strHtml += '		<li class="nav-item"><a class="nav-link active" href="#download" data-toggle="tab">' + dashboardLabel_download + '</a></li>';
	        strHtml += '		<li class="nav-item"><a class="nav-link" href="#migration" data-toggle="tab">' + dashboardLabel_migration + '</a></li>';
	        strHtml += '	</ul>';
	        strHtml += '	<div class="modal-body tab-content py-4" style="padding-top: 1.0rem !important;">';
	        strHtml += '		<div id="download" class="tab-pane active">';
	        strHtml += '			<div class="sub-bar" style="padding-top: 0px;">';
	        strHtml += '				<div class="ml-auto form-inline m-full">';
	        strHtml += '					<a id="migrationDownloadBtn" href="javascript:void(0);" class="btn btn-m"><i class="icon-export"></i><span class="hide">' + dashboardLabel_download + '</span></a>';
	        strHtml += '				</div>';
	        strHtml += '			</div>';
	        strHtml += '			<div id="dashModalLargeGrid"></div>';
	        strHtml += '		</div>';
	        strHtml += '		<div id="migration" class="tab-pane">';
	        strHtml += '			<div class="row frm-row">';
	        strHtml += '				<div class="col-lg-12">';
	        strHtml += '					<div class="form-group">';
	        strHtml += '						<label class="control-label">' + dashboardLabel_fileSelect + '</label>';
	        strHtml += '						<div class="input-group">';
	        strHtml += '							<input class="form-control view-disabled" id="fileName" type="text" readonly="readonly" placeholder="' + dashboardMsg_fileSelectError + '" />';
	        strHtml += '							<button type="button" id="fileSelectBtn" class="btn" style="margin-left: 5px; margin-right: 5px;">' + dashboardLabel_fileSelect + '</button>';
	        strHtml += '							<button type="button" id="fileUploadBtn" class="btn btn-primary">' + dashboardLabel_upload + '</button>';
	        strHtml += '						</div>';
	        strHtml += '					</div>';
	        strHtml += '				</div>';	        
	        strHtml += '			</div>';
	        strHtml += '		</div>';	        
	        strHtml += '	</div>';
	        strHtml += '</div>';
	        strHtml += '<div class="modal-footer">';
	        strHtml += '    <button type="button" id="closeMigrationBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	        strHtml += '</div>';

	        $('#dashModalLarge').find('.modal-content').empty();
	        $('#dashModalLarge').find('.modal-content').append($(strHtml));
	        $('#dashModalLarge').modal('show');
	        
	        var dashModalLargeGrid = null;
	        
	        $('#dashModalLarge').off('shown.bs.modal').on('shown.bs.modal', function() {
				var settings = {
					el : document.getElementById('dashModalLargeGrid'),
					bodyHeight: 200,
					data: containerList.map(function(containerInfo) {
		        		return {
		        			containerId: containerInfo.containerId,
		        			containerName: containerInfo.containerName,
		        			resolution : containerInfo.containerWidth + ' X ' + containerInfo.containerHeight
		        		}
		        	}),
		        	rowHeaders : ['checkbox'],
					columns : [
						{
							name : "containerName", 
							header : dashboardLabel_dashboard + ' ' + dashboardLabel_name, 
							width: '70%'
						},
						{
							name : "resolution",     
							header : dashboardLabel_resolution,
							align : "center",
							width: '30%'
						},
						{
							name : "containerId",
							hidden: true,
						},						
					],
					columnOptions : {
						resizable : true
					},
					usageStatistics : false,
					header: {
						height: 32,
						align: 'center'
					},
					onGridMounted : function() {
			        	var resetColumnWidths = [];
			        	
			        	dashModalLargeGrid.getColumns().forEach(function(columnInfo) {
			        		if(!columnInfo.copyOptions) return;

			        		if(columnInfo.copyOptions.widthRatio) {
			        			resetColumnWidths.push($('#dashModalLargeGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
			        		}
			        	});
			        	
			        	if(0 < resetColumnWidths.length)
			        		dashModalLargeGrid.resetColumnWidths(resetColumnWidths);
			        	
			        	$('#dashModalLargeGrid').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
			        },				
			    	scrollX: false,
			    	scrollY: true,
				};
				
				settings.columns.forEach(function(column) {
					if(!column.formatter) 
						column.escapeHTML = true;  

					if(column.width && -1 < String(column.width).indexOf('%')) {
						if(!column.copyOptions) 
							column.copyOptions = {};
			    		  
						column.copyOptions.widthRatio = column.width.replace('%', '');
			    		  
						delete column.width;
					}
				});				
				
				var dashModalLargeGrid = new tui.Grid(settings);
				
				dashModalLargeGrid.on('mouseover', function(ev) {
					if('cell' != ev.targetType) return;
			    	  
					var overCellElement = $(dashModalLargeGrid.getElement(ev.rowKey, ev.columnName));    	  
					overCellElement.attr('title', overCellElement.text());
				});
				
				dashModalLargeGrid.on('click', function(evt) {
					if('rowHeader' != evt.targetType) return;

					setTimeout(function() {
						if(-1 < dashModalLargeGrid.getCheckedRowKeys().indexOf(evt.rowKey)){
							dashModalLargeGrid.addRowClassName(evt.rowKey, "row-selected");
						}else{
							dashModalLargeGrid.removeRowClassName(evt.rowKey, "row-selected");
						}
					}, 0);
				});
				
				dashModalLargeGrid.on('checkAll', function(ev) {
					var allRows = dashModalLargeGrid.getData(); 
					
					for(var i = 0; i < allRows.length; i++){
						dashModalLargeGrid.addRowClassName(allRows[i].rowKey, "row-selected");
					}
				});
				
				dashModalLargeGrid.on('uncheckAll', function(ev) {
					var allRows = dashModalLargeGrid.getData(); 
					
					for(var i = 0; i < allRows.length; i++){
						dashModalLargeGrid.removeRowClassName(allRows[i].rowKey, "row-selected");
					}
				});				
				
				$('#migrationDownloadBtn').off('click').on('click', function() {
					if(0 == dashModalLargeGrid.getCheckedRowKeys().length){
						warnAlert({message: dashboardMsg_selectNoDashboard});
						return;
					}
					
					var exportContainerList = [];
					
					dashModalLargeGrid.getCheckedRowKeys().forEach(function(rowKey) {
						var filterContainerList = containerList.filter(function(containerInfo) {
							return containerInfo.containerId == dashModalLargeGrid.getRow(rowKey).containerId; 
						});

						var exportContainerInfo = $.extend(true, {}, filterContainerList[0]);
						
						delete exportContainerInfo.monitorContainerUsers;
						
						for(var i = 0; i < exportContainerInfo.monitorComponents.length; i++){
							delete exportContainerInfo.monitorComponents[i].monitorComponentTargets;
						}
						
						exportContainerList.push(exportContainerInfo);
					});
					
					var jsonFileName = 'DashBoardMigration_' + moment(new Date()).format('YYYY-MM-DD hh-mm-ss') + '_' + getUUID();
					var jsonData = JSON.stringify(exportContainerList);
					
					downloadJson(jsonFileName, jsonData);
				});
				
				var importContainerList = null;
				
				$('#fileSelectBtn').off('click').on('click', function() {
					importContainerList = null;
					
					var fileEle = $("<input/>").attr({'type': 'file'}).hide();
					
					fileEle.on('change', function(evt){
						var fileName = this.files[0].name;
						
						if('json' != fileName.substring(fileName.length - 4)){
							warnAlert({message: dashboardMsg_jsonFileFormatOnly});
							return;
						}
						
						$('#fileName').val(escapeHtml(fileName));
						
						var reader = new FileReader();
				        
				        reader.readAsText(this.files[0], 'utf-8');
				        
						reader.onload = function() {
							importContainerList = JSON.parse(reader.result);
				        };
					});
					
					fileEle.trigger('click');
				});
				
				$('#fileUploadBtn').off('click').on('click', function() {
					if(null == importContainerList){
						warnAlert({message: dashboardMsg_fileSelectError});
						return;
					}

					var resultArr = [];
					
					importContainerList.forEach(function(importContainerInfo) {
						importContainerInfo.monitorComponents.forEach(function(component, index) {
			    			for(var key in component){
			    				importContainerInfo['monitorComponents[' + index + '].' + key] = component[key];	
			    			}
			    		});
						
						delete importContainerInfo.monitorComponents;
					});
					
					var allCompleteFunc = function() {
						if(resultArr.length != importContainerList.length) return;
						
		        		importContainerList = null;
		        		
		        		$('#fileName').val('');
		        		
		        		var alertMsg = '';
		        		
		        		resultArr.forEach(function(resultObj, idx) {
		        			alertMsg += ((0 == idx)? '' : '<br/>') + escapeHtml(resultObj.message);
		        		});
		        		
		        		normalAlert({message: alertMsg, isXSSMode: false});
		        		
		        		$('#dashModalLarge').find('#closeMigrationBtn').trigger('click');
		        		
		        		getContainerList();
					};
					
					importContainerList.forEach(function(containerInfo) {
						var importContainerInfo = $.extend(true, {}, containerInfo);
							
			    		$.ajax({
			    			type : 'GET',
			    			url : contextPath + '/igate/monitoring/dashboard/existEqualsContainerName.json',
			    			data : {
			    				containerName: $.trim(importContainerInfo.containerName),
			    			},
			    			dataType : "json",
			    			success : function(res) {
			    				if('ok' != res.result) return;
			    				
			    				if (res.object) {
						        	resultArr.push({
						        		message: importContainerInfo.containerName + " : " + dashboardMsg_overlapWarn
						        	});
						        	
						        	allCompleteFunc();
			    				} else {
			    					importContainerInfo._method = 'POST';

									$.ajax({
										type: 'POST',
								        url: contextPath + '/igate/monitoring/dashboard/container.json',
								        processData : false,
								        data: JsonImngObj.serialize(importContainerInfo),
								        dataType: "json",
								        success: function(result) {
								        	resultArr.push({
								        		message: importContainerInfo.containerName + " : " + (('ok' == result.result)? dashboardMsg_migrationMake : result.error[0].message)
								        	});
								        },
								        error: function() {
								        	resultArr.push({
								        		message: importContainerInfo.containerName + " : Unknown Error"
								        	});					        	
								        },
								        complete: function(jqXHR, textStatus) {
								        	allCompleteFunc();
								        },
								    });
			    				}
			    			}
			    		});
					});
				});
	        });
	        
			$('#dashModalLarge').off('hidden.bs.modal').on('hidden.bs.modal', function () {
				if(dashModalLargeGrid)
					dashModalLargeGrid.destroy();
			});
		});
		
		$("#saveContainerMode").on('click', function() {
    	
	    	var strHtml = '';

	    	strHtml += '<div class="modal-header">';
	    	strHtml += '    <h2 class="modal-title">'+ dashboardLabel_addDashboard +'</h2>';
	    	strHtml += '    <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-body">';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_name +'<b class="icon-star"></b></label>';
	    	strHtml += '        <input type="text" id="containerName" class="form-control" placeholder="'+ dashboardMsg_enterName +'" required>';
	    	strHtml += '    </div>';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_resolution +'<b class="icon-star"></b></label>';
	    	strHtml += '        <div class="input-group">';
	    	strHtml += '            <input type="text" id="containerWidth" class="form-control" maxlength="4" placeholder="' + minContainerWidth + '" value=' + ((screen.width)? screen.width : minContainerWidth) + ' required>';
	    	strHtml += '            <i class="icon-close mx-1"></i>';
	    	strHtml += '            <input type="text" id="containerHeight" class="form-control" maxlength="4" placeholder="' + minContainerHeight + '" value=' + ((screen.height)? screen.height : minContainerHeight) + ' required>';
	    	strHtml += '        </div>';
	    	strHtml += '    </div>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-footer">';
	    	strHtml += '    <button type="button" id="closeNewDashBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	    	strHtml += '    <button type="button" id="confirmNewDashBtn" class="btn btn-primary">'+ checkBtn +'</button>';
	    	strHtml += '</div>';

	    	$('#dashModal').find('.modal-content').empty();
	    	$('#dashModal').find('.modal-content').append($(strHtml));
	    	$('#dashModal').modal('show');

	    	$('#dashModal').find('#confirmNewDashBtn').off('click').on('click', function() {
	    		
	    		if(!validationDashConfigModal()) return;
	    		
	    		var containerName = $('#dashModal').find('#containerName').val();
	    		var containerWidth = $('#dashModal').find('#containerWidth').val();
	    		var containerHeight = $('#dashModal').find('#containerHeight').val();
	    		
	    		existEqualsContainerName(
	    			{
	    				containerName: $.trim(containerName)
	    			}, 
	    			function() {
	    				changeContainer('add', {
	    					containerId : getUUID(),
	    					containerName : $.trim(containerName),
	    					containerWidth : Number(containerWidth),
	    					containerHeight : Number(containerHeight),
	    					darkmodeYn : 'Y',
	    					remarkYn : 'Y'
	    				});
	    			}
	    		);
	    	});
		});

		$("#deleteContainer").on('click', function() {

			if (!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectDeleteDashboard});
	    		return;
	    	}
      
	    	normalConfirm({message : dashboardMsg_deleteWarn, callBackFunc : function() {
	    		$.ajax({
	    			type : 'POST',
	    			url : contextPath + '/igate/monitoring/dashboard/container.json',
	    			data : JsonImngObj.serialize({
	    				_method: 'DELETE',
	    				containerId: _this.containerInfo.containerId
	    			}),
	    			dataType : "json",
	    			success : function(result) {
	    				if ('ok' != result.result) return;

	    				normalAlert({message : dashboardMsg_deleteSuccess});

	    				setLocalStorage();
	    				
	    				changeContainer('view');
	    				
	    				setDashContainer('view');
	    			}
	    		});
	    	}});
		});

		$("#modifyContainerMode").on('click', function() {
    	
	    	if (!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectModifyDashboard});
	    		return;
	    	}

	    	var strHtml = '';

	    	strHtml += '<div class="modal-header">';
	    	strHtml += '    <h2 class="modal-title">'+ dashboardLabel_modifyDashboard +'</h2>';
	    	strHtml += '    <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-body">';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_name +'<b class="icon-star"></b></label>';
	    	strHtml += '        <input type="text" id="containerName" class="form-control" placeholder="'+ dashboardMsg_enterName +'" value="' + _this.containerInfo.containerName + '" required>';
	    	strHtml += '    </div>';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_resolution +'<b class="icon-star"></b></label>';
	    	strHtml += '        <div class="input-group">';
	    	strHtml += '            <input type="text" id="containerWidth" class="form-control" maxlength="4" placeholder="' + minContainerWidth + '" value=' + _this.containerInfo.containerWidth + ' required>';
	    	strHtml += '            <i class="icon-close mx-1"></i>';
	    	strHtml += '            <input type="text" id="containerHeight" class="form-control" maxlength="4" placeholder="' + minContainerHeight + '" value=' + _this.containerInfo.containerHeight + ' required>';
	    	strHtml += '        </div>';
	    	strHtml += '    </div>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-footer">';
	    	strHtml += '    <button type="button" id="closeModifyDashBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	    	strHtml += '    <button type="button" id="confirmModifyDashBtn" class="btn btn-primary">'+ checkBtn +'</button>';
	    	strHtml += '</div>';

	    	$('#dashModal').find('.modal-content').empty();
	    	$('#dashModal').find('.modal-content').append($(strHtml));
	    	$('#dashModal').modal('show');
	    	
	    	$('#dashModal').find('#confirmModifyDashBtn').off('click').on('click', function() {
    		
	    		if(!validationDashConfigModal()) return;
    		
	    		var containerName = $('#dashModal').find('#containerName').val();
	    		var containerWidth = $('#dashModal').find('#containerWidth').val();
	    		var containerHeight = $('#dashModal').find('#containerHeight').val();
	    		
	    		existEqualsContainerName(
					{
	    				containerName: $.trim(containerName),
	    				containerId: _this.containerInfo.containerId
	    			}, 
	    			function() {
	    	    		changeContainer('modify', {
	    	    			containerId : _this.containerInfo.containerId,
	    	    			containerName : $.trim(containerName),
	    	    			containerWidth : Number(containerWidth),
	    	    			containerHeight : Number(containerHeight),
	    	    			remarkYn : _this.containerInfo.remarkYn,
	    	    			darkmodeYn : _this.containerInfo.darkmodeYn,
	    	    			componentList : _this.componentList.map(function(component) {
	    	    				var cloneComponent = $.extend(true, {}, component);
	    	    				
	    	    				delete cloneComponent.chart;
	    	    				
	    	    				return cloneComponent; 
	    	    			}),
	    	    			monitorContainerUsers : _this.containerInfo.monitorContainerUsers
	    	    		});
	    			}
	    		);
	    	});
		});
    
	    $("#copyContainerMode").on('click', function() {
	    	
	    	if (!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectCopyDashboard});
	    		return;
	    	};
    
	    	var strHtml = '';

	    	strHtml += '<div class="modal-header">';
	    	strHtml += '    <h2 class="modal-title">'+ dashboardLabel_copyDashboard +'</h2>';
	    	strHtml += '    <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-body">';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_name +'<b class="icon-star"></b></label>';
	    	strHtml += '        <input type="text" id="containerName" class="form-control" placeholder="'+ dashboardMsg_enterName +'" value="' + _this.containerInfo.containerName + '" required>';
	    	strHtml += '    </div>';
	    	strHtml += '    <div class="form-group">';
	    	strHtml += '        <label class="control-label">'+ dashboardLabel_resolution +'<b class="icon-star"></b></label>';
	    	strHtml += '        <div class="input-group">';
	    	strHtml += '            <input type="text" id="containerWidth" class="form-control" maxlength="4" placeholder="' + minContainerWidth + '" value=' + _this.containerInfo.containerWidth + ' required>';
	    	strHtml += '            <i class="icon-close mx-1"></i>';
	    	strHtml += '            <input type="text" id="containerHeight" class="form-control" maxlength="4" placeholder="' + minContainerHeight + '" value=' + _this.containerInfo.containerHeight + ' required>';
	    	strHtml += '        </div>';
	    	strHtml += '    </div>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-footer">';
	    	strHtml += '    <button type="button" id="closeModifyDashBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	    	strHtml += '    <button type="button" id="confirmCopyDashBtn" class="btn btn-primary">'+ checkBtn +'</button>';
	    	strHtml += '</div>';
	    	
	    	$('#dashModal').find('.modal-content').empty();
	    	$('#dashModal').find('.modal-content').append($(strHtml));
	    	$('#dashModal').modal('show');
    	
	    	$('#dashModal').find('#confirmCopyDashBtn').off('click').on('click', function() {
	    		
	    		if(!validationDashConfigModal()) return;
    		
	    		var containerName = $('#dashModal').find('#containerName').val();
	    		var containerWidth = $('#dashModal').find('#containerWidth').val();
	    		var containerHeight = $('#dashModal').find('#containerHeight').val();
	    		
	    		existEqualsContainerName(
					{
						containerName: $.trim(containerName)
					}, 
					function() {
						var copyContainerInfo = {
				    		containerId: getUUID(),		
				    		containerName: $.trim(containerName),
				    		containerWidth: Number(containerWidth),
				    		containerHeight: Number(containerHeight),
				    		remarkYn: _this.containerInfo.remarkYn,
				    		darkmodeYn: _this.containerInfo.darkmodeYn,
				    	};
						
			    		var basicComponentStruct = _this.getBasicComponentStruct();
			    		
			    		var parentComponentIdList = _this.componentList.map(function(component) { 
			    			return { beforeChangeId : component.componentId }; 
			    		});
			    		
			    		var copyComponentList = _this.componentList.map(function(component) { 
			    			var beforeComponentId = component.componentId;
			                component.componentId = getUUID();
			                component.containerId = copyContainerInfo.containerId;
			                
			                parentComponentIdList.forEach(function(parentComponentObj) {
			                	if(parentComponentObj.beforeChangeId == beforeComponentId) parentComponentObj.afterChangeId = component.componentId;
			                });
			    			
			                var newCompoent = {};
			                
			                Object.keys(basicComponentStruct).forEach(function(key) {
			                	newCompoent[key] = component[key];
			                });
			                
			                if('XVIEW' == component.chartType) {	
			                    if(localStorage.getItem('xViewYAxisMax_' + beforeComponentId)) newCompoent.xViewYAxisMax = localStorage.getItem('xViewYAxisMax_' + beforeComponentId);
			        	        else														   newCompoent.xViewYAxisMax = xViewDefaultYAxisMax;
			                    
			                    if(localStorage.getItem('xViewTrans_' + beforeComponentId)) newCompoent.xViewTrans = localStorage.getItem('xViewTrans_' + beforeComponentId);
			        	        else														newCompoent.xViewTrans = xViewDefaultTrans;
			                    
			                    if(localStorage.getItem('xViewMinData_' + beforeComponentId)) newCompoent.xViewMinData = localStorage.getItem('xViewMinData_' + beforeComponentId);
			        	        else														  newCompoent.xViewMinData = xViewDefaultxMinData;
			                }
			                
			                if('DATATABLE' == component.chartType) {
			                	if(localStorage.getItem('datatableRowCnt_' + beforeComponentId)) newCompoent.datatableRowCnt = localStorage.getItem('datatableRowCnt_' + beforeComponentId);
			        	        else															 newCompoent.datatableRowCnt = datatableDefaultRowCnt;
			                }
			                
			                if('INSTANCE' == component.chartType) {
			                	if(localStorage.getItem('instanceSummaryColCnt_' + beforeComponentId)) newCompoent.instanceSummaryColCnt = localStorage.getItem('instanceSummaryColCnt_' + beforeComponentId);
			        	        else															 	   newCompoent.instanceSummaryColCnt = instanceSummaryDefaultColCnt;
			                }			                
			                
			                return newCompoent;
			    		});
			    
			    		copyComponentList.forEach(function(component) {
			    			parentComponentIdList.forEach(function(parentComponentObj) {
	    	                	if(parentComponentObj.beforeChangeId == component.pComponentId) {
	    	                		component.pComponentId = parentComponentObj.afterChangeId;
	    	                	}
	    	                });
			    			
			    			component.monitorComponentTargets.forEach(function(monitorComponentTarget, index) {
			    				monitorComponentTarget.pk.componentId = component.componentId;
			    			});
			    		});
			    		
			    		copyContainerInfo.monitorComponents = copyComponentList;
			    		
			    		copyContainerInfo._method = 'POST';
			    		
			    		$.ajax({
							type: 'POST',
					        url: contextPath + '/igate/monitoring/dashboard/container.json',
					        data: JsonImngObj.serialize(copyContainerInfo),
					        dataType: "json",
					        success: function(result) {
					        	if('ok' != result.result) return;
					        	
			    				normalAlert({message : dashboardMsg_addSuccess});
					        	
					        	changeContainer('view');
					        	
					        	copyComponentList.forEach(function(component, index) {
					    			if('XVIEW' == component.chartType) {
					    	            localStorage.setItem('xViewYAxisMax_' + component.componentId, component.xViewYAxisMax);
					    	            localStorage.setItem('xViewTrans_' + component.componentId, component.xViewTrans);
					    	            localStorage.setItem('xViewMinData_' + component.componentId, component.xViewMinData);
					    			}
					    			
					    			if('DATATABLE' == component.chartType) {
					    	            localStorage.setItem('datatableRowCnt_' + component.componentId, component.datatableRowCnt);
					    			}
					    			
					    			if('INSTANCE' == component.chartType) {
					    	            localStorage.setItem('instanceSummaryColCnt_' + component.componentId, component.instanceSummaryColCnt);
					    			}					    			
					    		});
					        	
					        	localStorage.setItem('selectedContainerId', copyContainerInfo.containerId);
					        },
					    }); 
					}
				);
	    	});
	    });
    
	    $("#previewContainerMode").on('click', function(evt) {
	    	
	    	if (!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectNoDashboard});
	    		return;
	    	};
	    	
	    	var element = document.documentElement;
	    	
	    	if(element.requestFullScreen) 			    element.requestFullScreen();
			else if(element.webkitRequestFullScreen)    element.webkitRequestFullScreen();
			else if(element.mozRequestFullScreen)		element.mozRequestFullScreen();
			else if (element.msRequestFullscreen)		element.msRequestFullscreen();
	    });
    
	    $("#dashboard").on('contextmenu', function(evt) {
		
	    	if(!(screen.width == window.innerWidth && screen.height == window.innerHeight)) return;
	    	
	    	$("#dashContextMenu").remove();
		 	$("#dashContextSetting").remove();
	 	
			var strHtml = '';
		
			strHtml += '<ul id="dashContextMenu" style="position: absolute;">';
			strHtml += '	<li id="dashChangeMenu"> <i class="icon-result"></i> '+ dashboardLabel_contextChangeDash +'<div style="float: right"><i class="icon-right"></i></div></li>';
			strHtml += '	<li id="fullscreenExitMenu"> <i class="icon-eye"></i> '+ dashboardLabel_contextExitFullscreen +'</li>';
			strHtml += '</ul>';
			strHtml += '<div id="dashContextSetting" class="row frm-row" style="display: none; position: absolute;">';
			strHtml += '	<div class="col-lg-12">';
			strHtml += '		<div class="form-group">';
			strHtml += '			<label class="control-label">';
			strHtml += '				<span>'+ dashboardLabel_dashboard +'</span>';
			strHtml += '				<button type="button" class="btn-icon" style="position: absolute;right: 9px;height:1.3rem;">';
			strHtml += '					<i class="icon-close" style="font-size:0.75rem;"></i>';
			strHtml += '				</button>';
			strHtml += '			</label>';
			strHtml += '			<div class="input-group">';
			strHtml += '				<select id="contextMenuContainerList" class="form-control" size=9></select>';
			strHtml += '			</div>';
			strHtml += '		</div>';		
			strHtml += '		<div class="form-group">';
			strHtml += '			<label class="control-label"><span>'+ dashboardLabel_movementForm +'</span></label>';
			strHtml += '			<div class="input-group">';
			strHtml += '				<select id="contextMenuMoveType" class="form-control">';
			strHtml += '					<option value="current">'+ dashboardLabel_moveTypeCurrent +'</option>';
			strHtml += '					<option value="new">'+ dashboardLabel_moveTypeNew +'</option>';
			strHtml += '				</select>';
			strHtml += '				<div class="input-group-append">';
			strHtml += '					<button type="button" class="btn" id="containerMoveBtn">'+ dashboardBtn_move +'</button>';
			strHtml += '				</div>';		
			strHtml += '			</div>';		
			strHtml += '		</div>';
			strHtml += '		<div class="form-group">';
			strHtml += '			<div class="input-group">';
			strHtml += '				<div class="input-group-append" style="width: 100%; margin-left: 0px;">';
			strHtml += '					<button type="button" class="btn" id="containerCloseBtn" style="width: 100%;">'+ dashboardBtn_closeCurrentDashboard +'</button>';
			strHtml += '				</div>';		
			strHtml += '			</div>';		
			strHtml += '		</div>';		
			strHtml += '	</div>';
			strHtml += '</div>';
	
			$("#dashboard").append($(strHtml));
		
			var dashContextLeft = null;
			var dashContextTop = null;
		
			$("#dashContextMenu").show(0, function() {
				dashContextTop = (window.innerHeight <= evt.clientY + $("#dashContextMenu").outerHeight(true))? evt.clientY - $("#dashContextMenu").outerHeight(true) : evt.clientY;
				dashContextLeft = (window.innerWidth <= evt.clientX + $("#dashContextMenu").outerWidth(true))? window.innerWidth - $("#dashContextMenu").outerWidth(true) : evt.clientX;
				
				$(this).css({'top': dashContextTop, 'left': dashContextLeft});
			});
			
			$("#dashContextMenu li").on('click', function() {
				if('fullscreenExitMenu' != $(this).attr("id")) return false;
				
				if(!document.fullscreenElement && screen.width == window.innerWidth && screen.height == window.innerHeight) {
					$("#dashContextMenu").remove();
					warnAlert({message : dashboardLabel_contextFullscreenMsg});
					return false;					
				}
				
				if(document.exitFullscreen) 			 document.exitFullscreen();
		        else if (document.webkitExitFullscreen)  document.webkitExitFullscreen();
		        else if (document.mozCancelFullScreen)   document.mozCancelFullScreen();
		        else if (document.msExitFullscreen)      document.msExitFullscreen();
			});
		
			$("#dashContextMenu li").hover(function(event) {
				var selectMenuDiv = $(this).parent();
				var dashChangeDiv = $("#dashContextSetting");
				
				if($(this).attr("id") == 'dashChangeMenu') {
			    	var contextMenuTop = (window.innerHeight <= evt.clientY + dashChangeDiv.outerHeight(true))? dashContextTop - dashChangeDiv.outerHeight(true) + 30 : dashContextTop;
					var contextMenuLeft = (window.innerWidth <= (evt.clientX + selectMenuDiv.outerWidth(true) + dashChangeDiv.outerWidth(true)))? dashContextLeft - dashChangeDiv.outerWidth(true) - 20 : dashContextLeft + selectMenuDiv.outerWidth(true) + 20;
			    	
			    	$("#dashContextSetting").css({left : contextMenuLeft, top : contextMenuTop}).show();
			    	$(this).addClass('contextMenuHover');
				} else {
		    		$("#dashContextSetting").hide();
					$(this).parent().find("#dashChangeMenu").removeClass('contextMenuHover'); 
				}
			});
	
			containerList.forEach(function(container, index) {
				var tmpContainerListOption = $("<option/>").attr({'value' : container.containerId}).text(container.containerName);
				
				if(0 == index) tmpContainerListOption.prop('selected', true);
				
				$("#dashContextSetting").find('#contextMenuContainerList').append(tmpContainerListOption);
			});
	
			$("#dashContextSetting").find("#contextMenuMoveType, #contextMenuContainerList").on('click', function() {
				return false;
			});
		
			$("#dashContextSetting").find("#containerMoveBtn").on('click', function() {
		
				if(!$("#dashContextSetting").find("#contextMenuContainerList").val()) {
					warnAlert({message : dashboardMsg_selectNoDashboard});
					return;
				}
			
				if(_this.containerInfo.containerId == $("#dashContextSetting").find("#contextMenuContainerList").val()) {
					warnAlert({message : dashboardMsg_moveNoSameDashboard});
					return;
				}
			
				var beforeSelectedContainerId = localStorage.getItem('selectedContainerId');
			
				var selectedContextMenuMoveType = $("#dashContextSetting").find("#contextMenuMoveType").val();
				var selectedContextMenuContainerList = $("#dashContextSetting").find("#contextMenuContainerList").val();
			
				localStorage.setItem('selectedContainerId', selectedContextMenuContainerList);
			
				if('current' == selectedContextMenuMoveType) {
					unloadContainer();
					$("#containerList").val(localStorage.getItem('selectedContainerId'));
					$("#containerList").trigger('change');
				}else{
					localStorage.setItem('beforeSelectedContainerId', beforeSelectedContainerId);
					localStorage.setItem('isDashBoardWindowOpen', 'Y');
					window.open(contextPath + '/igate/monitoring/dashboard.html');
				}
			});
		
			$("#dashContextSetting").find("#containerCloseBtn").on('click', function() {
				if(!window.opener) warnAlert({message : dashboardMsg_closeNewDashboard});
				else			   window.close();	
			});
				
			return false;
	    });
    
	    $(".ct-dashboard").on('click', function() {
	    	$("#dashContextMenu").remove();
	    	$("#dashContextSetting").remove();
	    });
    
	    $('#viewNoticeBtn').click(function() {
	    	$(this).toggleClass('checked');
	    	
	    	if(!$(this).hasClass('checked')) $("#noticeArea").hide();
	    	
	    	localStorage.setItem('isViewNotice_' + _this.containerInfo.containerId, $(this).hasClass('checked'));
	    	
	    	$("#noticeArea").removeData('temporaryCloseStartTime');
		});   

		$("#noticeArea").find('.close').on('click', function() {
			$("#noticeArea").hide();
			$("#noticeArea").data('temporaryCloseStartTime', Date.now());
		});
		
		$('#evtHistoryListBtn').on('click', function(evt) {

			if (!_this.containerInfo.containerId || '-' == $("#containerList").val()) {
	    		warnAlert({message : dashboardMsg_selectNoDashboard});
	    		return;
	    	};
    
	    	var dashModalLargeGrid = null;
	    	
	    	var strHtml = '';

	    	strHtml += '<div class="modal-header">';
	    	strHtml += '    <h2 class="modal-title">'+ dashboardNotificationHistoryList +'<span name="refreshTime" style="font-size: 0.8rem;"></span></h2>';
	    	strHtml += '	<ul>';
	    	strHtml += '		<li style="float: left;">';
	    	strHtml += '    		<button type="button" class="btn-icon" name="refreshBtn" title="' + dashboardRefresh + '"><i class="icon-play"></i></button>';
	    	strHtml += '		</li>';
	    	strHtml += '		<li style="float: left;">';
	    	strHtml += '    		<button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	    	strHtml += '		</li>';
	    	strHtml += '	</ul>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-body">';
	    	strHtml += '	<div id="dashModalLargeGrid"></div>';
	    	strHtml += '</div>';
	    	strHtml += '<div class="modal-footer">';
	    	strHtml += '    <button type="button" id="closeModifyDashBtn" class="btn" data-dismiss="modal">'+ cancelBtn +'</button>';
	    	strHtml += '</div>';
	    	
	    	$('#dashModalLarge').find('.modal-content').empty();
	    	$('#dashModalLarge').find('.modal-content').append($(strHtml));
	    	
	    	$('#dashModalLarge').find('.modal-content').find('.modal-header').find('[name=refreshBtn]').off('click').on('click', function(evt) {
	    		if(dashModalLargeGrid)
	    			dashModalLargeGrid.destroy();
	    		
	    		var tmpNoticeDataHistoryList = noticeDataHistoryList.slice(0).reverse();
	    		
	    		$('#dashModalLarge').find('.modal-content').find('.modal-header').find('[name=refreshTime]').text(' (' + moment(new Date()).format('YYYY-MM-DD hh:mm:ss') + ')');
	    		
	    		var perPage = 20;
				var scrollEndIdx = 1;
				
				var settings = {
					el : document.getElementById('dashModalLargeGrid'),
					bodyHeight: 250,
					data: tmpNoticeDataHistoryList.slice(0, perPage),
					columns : [
								{
									name : "noticeDateTime", 
									header : dashboardNotificationTime, 
									align : "center",
									width: noticeDateTimeColWidth
								},
								{
									name : "instanceId",     
									header : dashboardNotificationInstanceId, 
									width: noticeInstanceIdColWidth
								},
								{
									name : "message",     	  
									header : dashboardNotificationMessage, 
									width: noticeMessageColWidth
								},
								{
									name : "status",     	  
									header : dashboardNotificationHeadStatus, 
									align : "center",
									width: noticeStatusColWidth
								},								
							  ],
					columnOptions : {
						resizable : true
					},
					usageStatistics : false,
					header: {
						height: 32,
						align: 'center'
					},
					onGridMounted : function() {
			        	var resetColumnWidths = [];
			        	
			        	dashModalLargeGrid.getColumns().forEach(function(columnInfo) {
			        		if(!columnInfo.copyOptions) return;

			        		if(columnInfo.copyOptions.widthRatio) {
			        			resetColumnWidths.push($('#dashModalLargeGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
			        		}
			        	});
			        	
			        	if(0 < resetColumnWidths.length)
			        		dashModalLargeGrid.resetColumnWidths(resetColumnWidths);
			        	
			        	$('#dashModalLargeGrid').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
			        },				
			    	scrollX: false,
			    	scrollY: true,
				};
				
				settings.columns.forEach(function(column) {
					if(!column.formatter) 
						column.escapeHTML = true;  

					if(column.width && -1 < String(column.width).indexOf('%')) {
						if(!column.copyOptions) 
							column.copyOptions = {};
			    		  
						column.copyOptions.widthRatio = column.width.replace('%', '');
			    		  
						delete column.width;
					}
				});			
				
				dashModalLargeGrid = new tui.Grid(settings);
				
				dashModalLargeGrid.on('mouseover', function(ev) {
					if('cell' != ev.targetType) return;
			    	  
					var overCellElement = $(dashModalLargeGrid.getElement(ev.rowKey, ev.columnName));    	  
					overCellElement.attr('title', overCellElement.text());
				});			
				
				dashModalLargeGrid.on('scrollEnd', function() {
					if(scrollEndIdx > Math.ceil(tmpNoticeDataHistoryList.length / perPage)) return;
					
					dashModalLargeGrid.appendRows(tmpNoticeDataHistoryList.slice(perPage * scrollEndIdx, perPage * (scrollEndIdx + 1)));
					scrollEndIdx += 1;
				});
	    	});
	    	
	    	$('#dashModalLarge').off('shown.bs.modal').on('shown.bs.modal', function() {
	    		$('#dashModalLarge').find('.modal-content').find('.modal-header').find('[name=refreshBtn]').trigger('click');
	    	});

			$('#dashModalLarge').off('hidden.bs.modal').on('hidden.bs.modal', function () {
				if(dashModalLargeGrid)
					dashModalLargeGrid.destroy();
				
				tmpNoticeDataHistoryList = null;
			});
	    	
			$('#dashModalLarge').modal('show');
		});
	}
	  
	function setLocalStorage() {
		_this.componentList.forEach(function(component) {
			localStorage.removeItem('xViewYAxisMax_' + component.componentId);
			localStorage.removeItem('xViewTrans_' + component.componentId);
			localStorage.removeItem('xViewMinData_' + component.componentId);
			localStorage.removeItem('xViewadapterFilter_' + component.componentId);
			localStorage.removeItem('xViewInstanceFilter_' + component.componentId);
			localStorage.removeItem('xViewtransactionFilter_' + component.componentId);
			localStorage.removeItem('datatableRowCnt_' + component.componentId);
			localStorage.removeItem('instanceSummaryColCnt_' + component.componentId);
		});

		localStorage.removeItem('isViewNotice_' + _this.containerInfo.containerId);
		  
		if (localStorage.getItem('selectedContainerId') == _this.containerInfo.containerId)
			localStorage.removeItem('selectedContainerId');
	}
		
	function appendComponentTag(pComponentObj, parentTag) {

		var appendDiv = null;

		var componentWidth = pComponentObj.componentWidth;
		var componentHeight = pComponentObj.componentHeight;
		var componentType = pComponentObj.componentType;
		  
		if ('-1' == pComponentObj.pComponentId)						appendDiv = $("<div/>").attr({'id' : 'root'}).css({'width' : componentWidth, 'height' : componentHeight});
		else if ('h' == pComponentObj.componentTypeDirection)		appendDiv = $("<div/>").addClass('component-horizontal').css({'width' : componentWidth, 'height' : componentHeight});
		else if ('v' == pComponentObj.componentTypeDirection)		appendDiv = $("<div/>").addClass('component-vertical').css({'width' : componentWidth, 'height' : componentHeight});
		  
		var childComponentList = _this.componentList.filter(function(childComponent) { return childComponent.pComponentId == pComponentObj.componentId })
												    .sort(function(a, b) { return a.componentOrder - b.componentOrder; });

		if (0 < childComponentList.length) {
			  
			childComponentList.forEach(function(childComponent) {
				if ('G' == childComponent.componentType) {
					appendComponentTag(childComponent, appendDiv);
				}else{
					var componentDiv = $("<div/>").addClass('component').css({'width' : childComponent.componentWidth, 'height' : childComponent.componentHeight}).data('dataObj', childComponent);

					var card = $("<section/>").addClass('card');

					var perfItemInfo = _this.perfItemList.filter(function(perfItem) { return perfItem.itemId == childComponent.itemId })[0];

					var cardHeader = $("<h2/>").addClass('card-header');
					  
					var perfItemUl = $("<ul/>");
					  
					var perfItemLi = $("<li/>").addClass('nav-link');
					perfItemLi.append($("<i/>").addClass(perfItemInfo.itemIcon));
					perfItemLi.append($("<span/>").text(childComponent.componentName));

					perfItemUl.append(perfItemLi);
					  
					var typeList = null;
					  
					if ('LINE' === childComponent.chartType || "XVIEW" == childComponent.chartType || "DATATABLE" == childComponent.chartType) {
						var infoList = _this.getTypeList(perfItemInfo);
						  
						var targetType = infoList.targetTypeList.filter(function(info) { return info.value == childComponent.targetType; })[0].name;
						  
						if('INSTANCE' != childComponent.targetType) {
							targetType += '-';
						        
							if('ADAPTER' == childComponent.targetType) {
								if(0 < childComponent.monitorComponentTargets.length){
									_this.adapterList.forEach(function(adapterInfo) { 
										if(adapterInfo.adapterId == childComponent.monitorComponentTargets[0].pk.componentTargetId) targetType += adapterInfo.adapterId;
									});									
								}
							}else if('CONNECTOR' == childComponent.targetType)	{
								if(0 < childComponent.monitorComponentTargets.length){
									_this.connectorList.forEach(function(connectorInfo) { 
										if(connectorInfo.connectorId == childComponent.monitorComponentTargets[0].pk.componentTargetId) 
											targetType += connectorInfo.connectorId;
									});									
								}
							}else if('QUEUE' == childComponent.targetType) {
								if(0 < childComponent.monitorComponentTargets.length){
									_this.queueList.forEach(function(queueInfo) { 
										if(queueInfo.connectorId == childComponent.monitorComponentTargets[0].pk.componentTargetId) 
											targetType += queueInfo.connectorId;
									});									
								}
							}else if('THREAD' == childComponent.targetType) {
								if(0 < childComponent.monitorComponentTargets.length){
									_this.threadList.forEach(function(threadInfo) { 
										if(threadInfo.threadPoolId == childComponent.monitorComponentTargets[0].pk.componentTargetId) 
											targetType += threadInfo.threadPoolId;
									});									
								}
							}
						}
						  
						var inoutType = '';
						
						if('NONE' != childComponent.inoutType) {
							inoutType = infoList.inoutTypeList.filter(function(info) {
								return info.value == childComponent.inoutType;
							})[0].name;							  
						}
						  
						typeList = {targetType: targetType, inputType: inoutType};
						  
						var perfItemExportLi = $("<li/>").addClass('nav-link export-nav-link');
						  
						if("XVIEW" == childComponent.chartType) perfItemExportLi.append($("<i/>").addClass('icon-set').attr({'name': 'filterSetIcon', 'title': 'Filter Set'}).data('componentId', childComponent.componentId));
						
						perfItemExportLi.append($("<i/>").addClass('icon-export').attr({'name': 'exportIcon', 'title': 'Export'}).data('componentId', childComponent.componentId));
						  
						perfItemUl.append(perfItemExportLi);
					}

					cardHeader.append(perfItemUl);

					var cardBody = $("<div/>").addClass('card-body').css('padding-top', 0);

					componentDiv.append(card.append(cardHeader).append(cardBody));

					appendDiv.append(componentDiv);

					if ('LINE' === childComponent.chartType) {

						childComponent.chart = $(componentDiv).lineChart({
							chartTag : cardBody, 
							unitType : childComponent.unitType, 
							darkmodeYn : _this.containerInfo.darkmodeYn, 
							itemId : childComponent.itemId, 
							remarkYn : _this.containerInfo.remarkYn, 
							dataIntervalSeconds: dataIntervalSeconds, 
							typeList: typeList,
							chartTooltipSync: chartTooltipSync
						});
						
					}else if ('COLUMN' === childComponent.chartType) {
						var isUseClickEvt = ('elapsed' == childComponent.itemId || 'deal' == childComponent.itemId)? false : true; 
						childComponent.chart = $(componentDiv).columnChart({chartTag : cardBody, unitType : childComponent.unitType, darkmodeYn : _this.containerInfo.darkmodeYn, remarkYn : _this.containerInfo.remarkYn, itemId : childComponent.itemId, isUseClickEvt: isUseClickEvt, componentFilterDataFunc : componentFilterDataFunc});
					}else if ('SPEEDBAR' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).speedBarChart({chartTag : cardBody, darkmodeYn : _this.containerInfo.darkmodeYn, remarkYn : _this.containerInfo.remarkYn, dataIntervalSeconds: dataIntervalSeconds});
					}else if ('CONNECTOR' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).connectorChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn, componentFilterDataFunc : componentFilterDataFunc});
					}else if ('QUEUE' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).queueChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn, componentFilterDataFunc : componentFilterDataFunc});
					}else if ('THREAD' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).threadPoolChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn, componentFilterDataFunc : componentFilterDataFunc});
					}else if ('INSTANCE' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).instanceChart({
							chartTag : cardBody, 
							remarkYn : _this.containerInfo.remarkYn, 
							componentId : childComponent.componentId,
							componentFilterDataFunc : componentFilterDataFunc
						});
					}else if ('EXTERNALLINE' === childComponent.chartType) {
						childComponent.chart = $(componentDiv).externalLineChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn});
					}else if ("DATATABLE" == childComponent.chartType){
						childComponent.chart = $(componentDiv).dataTableChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn, componentId : childComponent.componentId, typeList: typeList});
					}else if ("XVIEW" == childComponent.chartType) {
						childComponent.chart = $(componentDiv).xViewChart({chartTag : cardBody, remarkYn : _this.containerInfo.remarkYn, darkmodeYn : _this.containerInfo.darkmodeYn, componentId : childComponent.componentId, componentName: childComponent.componentName});
					}
				}
			});
		}

		parentTag.append(appendDiv);
	}
  
	function componentFilterDataFunc(targetId, isParamApplyFiltered) {
		var isApplyFiltered = false;
	  
		for (var i = 0; i < _this.instanceList.length; i++) {
			var instanceInfo = _this.instanceList[i];

			if (instanceInfo.instanceId == targetId) {
				instanceInfo.isFiltered = ('undefined' == typeof(isParamApplyFiltered))? !instanceInfo.isFiltered : isParamApplyFiltered;
				isApplyFiltered = instanceInfo.isFiltered; 
				break;
			}
		}
	  
		for (var i = 0; i < _this.componentList.length; i++) {
			var component = _this.componentList[i];
			
			if (!component.chart) continue;

			if (!component.chart.filterData) continue;

			if ('elapsed' == component.itemId || 'deal' == component.itemId) continue; 
		  
			if ('INSTANCE' == component.targetType || 'CONNECTOR' == component.chartType || 'QUEUE' == component.chartType || 'THREAD' == component.chartType || 'INSTANCE' == component.chartType) {
				component.chart.filterData(targetId, isApplyFiltered);
			}
		}

		if (monitorSocket)
			monitorSocket.send(getWebsocketSendParam());
	}
		
	function chartTooltipSync(paramObj) {
		for (var i = 0; i < _this.componentList.length; i++) {
			var component = _this.componentList[i];
			
			if (!component.chart) continue;
			
			if('LINE' != component.chartType) continue;

			var findDataSetIdx = null;
			var findDataObjIdx = null;
			
			var chartObj = component.chart.getChartObj();
			
			if(chartObj.canvas == paramObj.chartObj.canvas) {
				findDataSetIdx = paramObj.datasetIndex;
				findDataObjIdx = paramObj.dataIndex;
			}else {
				for(var j = 0; j < chartObj.data.datasets.length; j++) {
					var dataset = chartObj.data.datasets[j];
					
					var findDataObj = binanrySearch(dataset.data, paramObj.standardTimeMillis);
				
					if(!findDataObj) continue;
					
					findDataSetIdx = j;
					findDataObjIdx = findDataObj.idx;
					
					break;
				}
			}
			
			if(null == findDataSetIdx || null == findDataObjIdx) continue;
			
			var tmpDataset = chartObj.data.datasets[findDataSetIdx];
			
			var _view = tmpDataset._meta[Object.keys(tmpDataset._meta)[0]].data[findDataObjIdx]._view;

			if(!_view.x || !_view.y) continue;
			
			var rect = chartObj.canvas.getBoundingClientRect();
			
			chartObj.canvas.dispatchEvent(new MouseEvent('mousemove', {clientX: rect.left, clientY: rect.top}));
			chartObj.canvas.dispatchEvent(new MouseEvent('mousemove', {clientX: rect.left + _view.x, clientY: rect.top + _view.y}));
		}
	}
  
	function initChartEvtBind() {
		$("#dashboard").find('.component').find('[name=exportIcon]').off('click').on('click', function() {
			var componentObj = null;
		  
			for (var i = 0; i < _this.componentList.length; i++) {
				if (_this.componentList[i].componentId == $(this).data('componentId')) {
					componentObj = _this.componentList[i];
					break;
				}
			}
		  
			if (null == componentObj) return;
		  
			if ('LINE' != componentObj.chartType && "XVIEW" != componentObj.chartType && "DATATABLE" != componentObj.chartType) return false;
		  
			if (!componentObj.chart.downloadExportStart) return; 
		  
			componentObj.chart.downloadExportStart(componentObj.componentName);
		});
		
		$("#dashboard").find('.component').find('[name=filterSetIcon]').off('click').on('click', function() {
			
			var componentObj = null;
			  
			for (var i = 0; i < _this.componentList.length; i++) {
				if (_this.componentList[i].componentId == $(this).data('componentId')) {
					componentObj = _this.componentList[i];
					break;
				}
			}
		  
			if (null == componentObj || "XVIEW" != componentObj.chartType) return;
		
			componentObj.chart.dataFilterSetting({			
				adapterList : _this.adapterList.map(function(adapter) { return {adapterId : adapter.adapterId} }),
				instanceList : _this.instanceList.map(function(instance) { return {instanceId : instance.instanceId} })
			});
		});
	}

	function initChartTargetInfo() {
	  
		for (var i = 0; i < _this.componentList.length; i++) {
		  
			if (!_this.componentList[i].chart) continue;
			  
			var component = _this.componentList[i];
		  
			if ('elapsed' == component.itemId || 'deal' == component.itemId) {
				var seriesArr = null;

				if('elapsed' == component.itemId) {
					seriesArr = [{id : 'elapsedMax', name : dashboardLabel_max, color : COLORS[0]}, 
								 {id : 'elapsedMin', name : dashboardLabel_min, color : COLORS[1]}, 
			  		   		     {id : 'elapsedAvg', name : dashboardLabel_avg, color : COLORS[2]}];
				}else if ('deal' == component.itemId) {
					seriesArr = [{id : 'success', name : dashboardLabel_success,    color : '#62d36f'}, 
								{id : 'timeout', name : dashboardLabel_timeout,    color : '#efc402'},	   
								{id : 'error',   name : dashboardLabel_error,      color : '#ed3137'}];				  
				}
			  
				seriesArr.forEach(function(seriesObj, seriesIndex) {
					if(component.chart.addTarget)
						component.chart.addTarget({targetId : seriesObj.id, targetName : seriesObj.name, color : seriesObj.color});
				});
			}else if ('INSTANCE' == component.targetType) {
				_this.instanceList.forEach(function(instanceInfo, index) {
					if(component.chart.addTarget)
						component.chart.addTarget({targetId : instanceInfo.instanceId, targetName : instanceInfo.instanceId, color : instanceInfo.color});
				});
			}else if ('ADAPTER' == component.targetType) {
				component.monitorComponentTargets.forEach(function(componentInfo, index) {
					if(component.chart.addTarget)
						component.chart.addTarget({targetId : componentInfo.pk.componentTargetId, targetName : componentInfo.pk.componentTargetId, color : COLORS[index]});
				});
			}else if ('CONNECTOR' == component.targetType) {
				component.monitorComponentTargets.forEach(function(componentInfo, index) {
					var connectorObj = _this.connectorList.filter(function(connector) {
						return connector.connectorId == componentInfo.pk.componentTargetId;
					})[0];
				  
					if(connectorObj) {
						connectorObj.instanceList.forEach(function(instanceObj, index) {
							if(component.chart.addTarget)
								component.chart.addTarget({targetId : instanceObj.pk.instanceId, targetName : instanceObj.pk.instanceId});
						});					  
					}
				});
			}else if ('QUEUE' == component.targetType) {
				component.monitorComponentTargets.forEach(function(componentInfo, index) {
					var queueObj = _this.queueList.filter(function(queue) {
						return queue.adapterId == componentInfo.pk.componentTargetId;
					})[0];
	
					if(queueObj) {
						queueObj.instanceList.forEach(function(instanceObj, index) {
							if(component.chart.addTarget)
								component.chart.addTarget({targetId : instanceObj.pk.instanceId, targetName : instanceObj.pk.instanceId});  
						});	    			  
					}
				});
			}else if ('THREAD' == component.targetType) {
				var filterInstanceList = _this.instanceList.filter(function(instance) {
					return 'T' == instance.instanceType;
				});
			  
				filterInstanceList.forEach(function(instanceInfo, index) {
					if(component.chart.addTarget)
						component.chart.addTarget({targetId : instanceInfo.instanceId, targetName : instanceInfo.instanceId});
				});
			}else if ('EXTERNALLINE' == component.targetType) {
				_this.externalLineList.forEach(function(externalInfo, index) {
					if(component.chart.addTarget)
						component.chart.addTarget({targetId : externalInfo.externalLineId, targetName : externalInfo.externalLineName});
				});
			}
			
			if(component.chart.draw)
				component.chart.draw();
		}
	}

	function initRealTime() {
	  
		var isFirstRecvStandardTime = false;

		var recvStandardTime = null;
		var measurementTime = null;
		var sendTime = null;
	  
		intervalId = setInterval(function() {

			if(0 === $("#dashboard").length) {
				unloadContainer();
				return;
			}

			if (!isFirstRecvStandardTime) {
				sendTime = Date.now();
			}else{
				if (!measurementTime) {
					sendTime = recvStandardTime;
					measurementTime = Date.now();
				}else{
					recvStandardTime += (Date.now() - measurementTime);
					sendTime = recvStandardTime;
					measurementTime = Date.now();
				}
			}

			_this.componentList.forEach(function(component) {
				if (component.chart && component.chart.setInterval)
					component.chart.setInterval(sendTime, isFirstRecvStandardTime);
			});
		  
			//대상 동기화.
			setSyncTarget();
		  
			//알림 부분.
			setNotice();
		}, 1000);
		
		//requestAnimationFrame
		function step(timestamp) {
		  
			if (0 === $("#dashboard").length) {
				unloadContainer();
				return;
			}

			_this.componentList.forEach(function(component) {
				if (component.chart && component.chart.requestAnimationFrame)
					component.chart.requestAnimationFrame(timestamp);
			});
		  
			rafId = requestAnimationFrame(step);
		}
	  
		rafId = requestAnimationFrame(step);
	  
		//webSocket
		initWebSocket();
	  
		function initWebSocket() {

			monitorSocket = new WebSocket(messageUrl);

			monitorSocket.onopen = function(event) {
				monitorSocket.send(getWebsocketSendParam());
			};

			monitorSocket.onerror = function(event) {
				console.log('WebSocket onerror');
			};

			monitorSocket.onmessage = function(event) {
			  
				if (0 === $("#dashboard").length) {
					unloadContainer();
					return;
				}
    		
				var bodyObj = JSON.parse(event.data);
			  
				if (!isFirstRecvStandardTime) {
					isFirstRecvStandardTime = true;
					recvStandardTime = bodyObj.standardTime;
				}else {
					recvStandardTime += (Date.now() - measurementTime);
				}
				
				sendTime = recvStandardTime;
				measurementTime = Date.now();
			  
				if(1 == Object.keys(bodyObj).length) return;
			  
				if('true' == localStorage.getItem('isViewNotice_' + _this.containerInfo.containerId)) {
					Array.prototype.push.apply(noticeDataList, bodyObj.noticeMessage);
				}
				
				Array.prototype.push.apply(noticeDataHistoryList, bodyObj.noticeMessage);
				
				if(noticeDataHistoryListMaxCnt < noticeDataHistoryList.length) {
					noticeDataHistoryList.splice(0, noticeDataHistoryList.length - noticeDataHistoryListMaxCnt);
				}
				
				for (var i = 0; i < _this.componentList.length; i++) {

					if (!_this.componentList[i].chart) continue;

					var component = _this.componentList[i];
				  
					var dataArr = [];
				  
					if ('elapsed' == component.itemId || 'deal' == component.itemId) {

						var seriesArr = ('elapsed' == component.itemId) ? ['elapsedMax', 'elapsedMin', 'elapsedAvg'] : ['success', 'error', 'timeout'];

						if ('INSTANCE' == component.targetType) {
    					
							var dataObj = ('IN' == component.inoutType) ? bodyObj.instance_trafficIn : bodyObj.instance_trafficOut;

							if ("LINE" == component.chartType || "COLUMN" == component.chartType) {
								seriesArr.forEach(function(seriesId, seriesIndex) {
									dataArr.push({targetId : seriesId, x : sendTime, y : dataObj[seriesId]});
								});
							}
						  
							dataObj = null;
    					
						}else if ('ADAPTER' == component.targetType) {
							if(0 < component.monitorComponentTargets.length){
								var recvDataArr = ('IN' == component.inoutType) ? bodyObj.adapter_trafficIn : bodyObj.adapter_trafficOut;

								var dataObj = recvDataArr.filter(function(recvData) {
									return recvData.adapterId == component.monitorComponentTargets[0].pk.componentTargetId;
								})[0];
	    					
								if ("LINE" == component.chartType || "COLUMN" == component.chartType) {
									seriesArr.forEach(function(seriesId, seriesIndex) {
										dataArr.push({targetId : seriesId, x : sendTime, y : dataObj[seriesId]});
									});
								}
							  
								dataObj = null;
								recvDataArr = null;								
							}
						}
					  
					}else if ('INSTANCE' == component.targetType) {

						if ("LINE" == component.chartType || "COLUMN" == component.chartType) {
							bodyObj.instance.forEach(function(data) {
								dataArr.push({targetId : data.instanceId, x : sendTime, y : data[component.itemId]});
							});
						}else if ("INSTANCE" == component.chartType) {
							bodyObj.instance.forEach(function(data) { 
								dataArr.push(data);
							});
						}else if ("SPEEDBAR" == component.chartType) {

							var speedbar_traffic_obj = ('IN' == component.inoutType) ? bodyObj.instance_trafficIn : bodyObj.instance_trafficOut;

							dataArr.push({
								rps : speedbar_traffic_obj.rps,
								tps : speedbar_traffic_obj.tps,
								tpsShort : speedbar_traffic_obj.tpsShort,
								tpsMiddle : speedbar_traffic_obj.tpsMiddle,
								tpsLong : speedbar_traffic_obj.tpsLong,
								activeShort : speedbar_traffic_obj.activeShort,
								activeMiddle : speedbar_traffic_obj.activeMiddle,
								activeLong : speedbar_traffic_obj.activeLong,
							});
						  
							speedbar_traffic_obj = null;
						  
						} else if ("DATATABLE" == component.chartType) {
    					
							var transaction_obj = ('IN' == component.inoutType) ? bodyObj.instance_activeTransactionIn : bodyObj.instance_activeTransactionOut;
						  
							var datatableRowCnt = localStorage.getItem('datatableRowCnt_' + component.componentId);
						  
							datatableRowCnt = (datatableRowCnt)? datatableRowCnt : datatableDefaultRowCnt;

							transaction_obj.forEach(function(data, index) {
								if(index <= datatableRowCnt - 1) {
									dataArr.push({
										status : data.elapsedType,
										uuid : data.transactionId,
										transactionId : data.interfaceServiceId,
										transactionName : data.interfaceServiceName,
										adapterId : data.adapterId,
										instanceId : data.instanceId,
										snapshotTimestamp : data.snapshotTimestamp
									});						
								}
							});
						  
							transaction_obj = null;
					  
						}else if ("XVIEW" == component.chartType) {
							(function() {
								var drawMinData = (null == localStorage.getItem('xViewMinData_' + component.componentId))? xViewDefaultxMinData : localStorage.getItem('xViewMinData_' + component.componentId);

								var data = null;
							  
								for(var tmpIdx = 0; tmpIdx < bodyObj.instance_finishedTransaction.length; tmpIdx++) {
								  
									data = bodyObj.instance_finishedTransaction[tmpIdx];
								  
									if(!data.snapshotTimestamp) continue;
								  
									if(drawMinData > data.elapsedTime) continue;
								  
									dataArr.push({
										targetId : data.instanceId,
										x : data.snapshotTimestamp,
										y : data.elapsedTime,
										type : ('Y' == data.errorYn) ? 2 : ('Y' == data.timeoutYn) ? 1 : 0,
										uuid : data.transactionId,
										transactionId : data.interfaceServiceId,
										transactionName : data.interfaceServiceName,
										adapterId : data.adapterId,
										instanceId : data.instanceId,
										snapshotTimestamp : data.snapshotTimestamp
									});
								}
							  
								dataArr.sort(function(a, b) { return a.x - b.x; });
							})();
						}
					  
					}else if ('ADAPTER' == component.targetType) {
						
						if ("SPEEDBAR" == component.chartType) {

							if(0 < component.monitorComponentTargets.length){
								var speedbar_traffic_arr = ('IN' == component.inoutType) ? bodyObj.adapter_trafficIn : bodyObj.adapter_trafficOut;

								var speedbar_traffic_obj = speedbar_traffic_arr.filter(function(speedbar_traffic_data) {
									return speedbar_traffic_data.adapterId == component.monitorComponentTargets[0].pk.componentTargetId;
								})[0];
	    					
								dataArr.push({
									rps : speedbar_traffic_obj.rps,
									tps : speedbar_traffic_obj.tps,
									tpsShort : speedbar_traffic_obj.tpsShort,
									tpsMiddle : speedbar_traffic_obj.tpsMiddle,
									tpsLong : speedbar_traffic_obj.tpsLong,
									activeShort : speedbar_traffic_obj.activeShort,
									activeMiddle : speedbar_traffic_obj.activeMiddle,
									activeLong : speedbar_traffic_obj.activeLong,
								});
							  
								speedbar_traffic_obj = null;
								speedbar_traffic_arr = null;								
							}
						  
						}else if ("DATATABLE" == component.chartType) {

							var transaction_obj = ('IN' == component.inoutType) ? bodyObj.adapter_activeTransactionIn : bodyObj.adapter_activeTransactionOut;

							var datatableRowCnt = localStorage.getItem('datatableRowCnt_' + component.componentId);
						  
							datatableRowCnt = (datatableRowCnt)? datatableRowCnt : datatableDefaultRowCnt;
						  
							transaction_obj.forEach(function(data, index) {
								if(index <= datatableRowCnt - 1) {
									dataArr.push({
										status : data.elapsedType,
										uuid : data.transactionId,
										transactionId : data.interfaceServiceId,
										transactionName : data.interfaceServiceName,
										adapterId : data.adapterId,
										instanceId : data.instanceId,
										snapshotTimestamp : data.snapshotTimestamp
									});							  
								}
							});
						  
							transaction_obj = null;
						}
					  
					}else if ('THREAD' == component.targetType) {
						if ("THREAD" == component.chartType) {
							if (bodyObj.thread && 0 < component.monitorComponentTargets.length) {
								bodyObj.thread[component.monitorComponentTargets[0].pk.componentTargetId].forEach(function(data) {
									dataArr.push({status : data.status, threadActive : data.threadActive, threadIdle : data.threadIdle, instanceId : data.instanceId});
								});
							}
						}
					}else if ('CONNECTOR' == component.targetType) {

						if ("CONNECTOR" == component.chartType) {
							if (bodyObj.connector && 0 < component.monitorComponentTargets.length) {
								bodyObj.connector[component.monitorComponentTargets[0].pk.componentTargetId].forEach(function(data) {
									dataArr.push({
										instanceId : data.instanceId,
										sessionInuse : data.sessionInuse,
										sessionWait : data.sessionWait,
										threadInuse : data.threadInuse,
										threadWait : data.threadWait,
										idleWarningYn : data.idleWarningYn,
										sessionCountWarningYn : data.sessionCountWarningYn,
										sessionInuseWarningYn : data.sessionInuseWarningYn,
										sessionWaitWarningYn : data.sessionWaitWarningYn,
										threadCountWarningYn : data.threadCountWarningYn,
										threadInuseWarningYn : data.threadInuseWarningYn,
										status : data.status,
									});
								});
							}
						}
					  
					}else if ('QUEUE' == component.targetType) {
						if ("QUEUE" == component.chartType) { 
							if (bodyObj.queue && 0 < component.monitorComponentTargets.length) {
								bodyObj.queue[component.monitorComponentTargets[0].pk.componentTargetId].forEach(function(data) {
									dataArr.push({
										instanceId : data.instanceId,
										messageCount : data.messageCount,
										consumerCount : data.consumerCount,
									  	messageWarningYn : data.messageWarningYn,
									  	consumerWarningYn : data.consumerWarningYn,
									  	status : data.status
									});
								});
							}
						}
					} else if ('EXTERNALLINE' == component.targetType) {
						bodyObj.externalLine.forEach(function(data) {
							dataArr.push({
								externalLineId : data.externalLineId,
								externalLineName : data.externalLineName,
								status : data.status,
								active : data.active,
								total : data.total
							});
						});
					}
				  
					if(component.chart.addData)
						component.chart.addData(dataArr);
					 
					dataArr = null;
				}

	            for (var i = 0; i < _this.componentList.length; i++) {
	                if (!_this.componentList[i].chart) continue;
	                
	                var component = _this.componentList[i];
	                
	                if ('INSTANCE' != component.chartType && 'CONNECTOR' != component.chartType && 'THREAD' != component.chartType && 'QUEUE' != component.chartType) continue;
	                
	                _this.instanceList.forEach(function(instanceInfo, index) {
	                	var filterInstanceList = bodyObj.instance.filter(function(info) {
	                		return info.instanceId == instanceInfo.instanceId;
	                	});

	                    if(component.chart.updateTarget)
	                    	component.chart.updateTarget(instanceInfo.instanceId, {isDataEmpty: 0 == filterInstanceList.length, downStatus: instanceInfo.downStatus});	                	
	                });
	            }
			  
				bodyObj = null;
			}
		}
	}
  
	function initRefresh() {
		var refreshDay = new Date(Date.now());
		refreshDay.setDate(refreshDay.getDate() + 1);
		refreshDay.setHours(4);
		refreshDay.setMinutes(0);
		refreshDay.setSeconds(0);
		refreshDay.setMilliseconds(0);
	  
		refreshTimeoutId = setTimeout(function() {
			if(0 === $("#dashboard").length) {
				unloadContainer();
				return;
			}
		  
			location.reload();
		  
		}, refreshDay.getTime() - Date.now());
	}

	function getWebsocketSendParam() {
	  
		var adapters = [];
		var threads = [];
		var connectors = [];
		var queues = [];
		var externalLine = null;

		var topCount = datatableDefaultRowCnt;
	  
		_this.componentList.forEach(function(componentInfo) {
			if ("ADAPTER" === componentInfo.targetType) {
				componentInfo.monitorComponentTargets.forEach(function(monitorComponentTarget) {
					adapters.push(monitorComponentTarget.pk.componentTargetId);
				});
			}else if ("THREAD" === componentInfo.targetType) {
				componentInfo.monitorComponentTargets.forEach(function(monitorComponentTarget) {
					threads.push({
						threadId : monitorComponentTarget.pk.componentTargetId,
						instanceIds : _this.instanceList.filter(function(instance) {
							return 'T' === instance.instanceType;
						}).map(function(instance) {
							return instance.instanceId;
						})
					});
				});
			}else if ("CONNECTOR" === componentInfo.targetType) {
				componentInfo.monitorComponentTargets.forEach(function(monitorComponentTarget) {
					connectors.push({
						connectorId : monitorComponentTarget.pk.componentTargetId,
						instanceIds : (function() {
									       var connectorInfo = _this.connectorList.filter(function(connectorInfo) {
									    	   return connectorInfo.connectorId == monitorComponentTarget.pk.componentTargetId;
									       })[0];
						  				
									       if(connectorInfo) {
									    	   return connectorInfo.instanceList.map(function(instanceInfo) {
									    		   return instanceInfo.pk.instanceId;
									    	   });
									       }else{
									    	   return null;
									       }
					  			    
						})()
					});
				});
			}else if ("QUEUE" == componentInfo.targetType) {
				componentInfo.monitorComponentTargets.forEach(function(monitorComponentTarget) {
					queues.push({
						queueId : monitorComponentTarget.pk.componentTargetId,
						instanceIds : (function() {
						  			       var queueInfo = _this.queueList.filter(function(queueInfo) {
						  			    	   return queueInfo.adapterId == monitorComponentTarget.pk.componentTargetId;
						  			       })[0];
						  				
						  			       if(queueInfo){
						  			    	   return queueInfo.instanceList.map(function(instanceInfo) {
						  			    		   return instanceInfo.pk.instanceId;
						  			    	   });
						  			       }else{
						  			    	   return null;
						  			       }
						})()
					});
				});
			} else if ("EXTERNALLINE" == componentInfo.targetType) {
				externalLine = 1;
			}
		  
			if('DATATABLE' == componentInfo.chartType) {
				if(topCount < Number(localStorage.getItem('datatableRowCnt_' + componentInfo.componentId))) {
					topCount = Number(localStorage.getItem('datatableRowCnt_' + componentInfo.componentId));
				}
			}
		});
	  
		return JSON.stringify({
			duration : dataIntervalSeconds,
			filter : {
				instances : _this.instanceList.filter(function(instanceInfo) {
								return !instanceInfo.isFiltered;
							}).map(function(instanceInfo) {
								return instanceInfo.instanceId;
							})
			},
			adapters : (0 < adapters.length) ? adapters : null,
			threads : (0 < threads.length) ? threads : null,
			connectors : (0 < connectors.length) ? connectors : null,
			queues : (0 < queues.length) ? queues : null,
			externalLine : externalLine,
			topCount: topCount,
		});
	}

	function setSyncTarget() {
	  
		if(null != targetSyncRefreshTime && (Date.now() - targetSyncRefreshTime) < targetSyncRefreshStandardTime) return;
	  
		targetSyncRefreshTime = Date.now();
	  
		var oldInstanceList = [];
		var oldAdapterList = [];
		var oldConnectorList = [];
		var oldQueueList = [];
		var oldExternalLineList = [];

		Array.prototype.push.apply(oldInstanceList, _this.instanceList);
		Array.prototype.push.apply(oldAdapterList, _this.adapterList);
		Array.prototype.push.apply(oldConnectorList, _this.connectorList);
		Array.prototype.push.apply(oldQueueList, _this.queueList);
		Array.prototype.push.apply(oldExternalLineList, _this.externalLineList);
		
		_this.setTargetInfo(function() {
	        _this.instanceList.forEach(function(instance, index) {
	        	instance.color = COLORS[index];
	        	
	        	var isFiltered = false;
	        	
	        	for(var i = 0; i < oldInstanceList.length; i++) {
	        		if(oldInstanceList[i].instanceId == instance.instanceId) {
	        			isFiltered = oldInstanceList[i].isFiltered;
	        		}
	        	}
	        	
	        	instance.isFiltered = isFiltered;
	        });
	        
	        if(!_this.componentList) return;
			  
	        var isChangeFlag = false;
			  
	        //instnace, thread도 같이.
	        var addInstanceList = _this.instanceList.filter(function(instanceInfo) {
	        	return -1 == oldInstanceList.map(function(oldInstanceInfo) { return oldInstanceInfo.instanceId }).indexOf(instanceInfo.instanceId);
	        });	
			  
	        var deleteInstanceList = oldInstanceList.filter(function(oldInstanceInfo) {
	        	return -1 == _this.instanceList.map(function(instanceInfo) { return instanceInfo.instanceId }).indexOf(oldInstanceInfo.instanceId);
	        });
			  
	        //adapter
	        var addAdapterList = _this.adapterList.filter(function(adapterInfo) {
	        	return -1 == oldAdapterList.map(function(oldAdapterInfo) { return oldAdapterInfo.adapterId }).indexOf(adapterInfo.adapterId);
	        });
			  
	        var deleteAdapterList = oldAdapterList.filter(function(oldAdapterInfo) {
	        	return -1 == _this.adapterList.map(function(adapterInfo) { return adapterInfo.adapterId }).indexOf(oldAdapterInfo.adapterId);
	        }); 
			  
	        //externalLine
	        var addExternalLineList = _this.externalLineList.filter(function(externalInfo) {
	        	return -1 == oldExternalLineList.map(function(oldExternalInfo) { return oldExternalInfo.externalLineId }).indexOf(externalInfo.externalLineId);
	        });
			  
	        var deleteExternalLineList = oldExternalLineList.filter(function(oldExternalInfo) {
	        	return -1 == _this.externalLineList.map(function(externalInfo) { return externalInfo.externalLineId }).indexOf(oldExternalInfo.externalLineId);
	        });

	        for (var i = 0; i < _this.componentList.length; i++) {
				  
	        	if (!_this.componentList[i].chart) continue;
				  
	        	var component = _this.componentList[i];
				
	        	if ('elapsed' == component.itemId || 'deal' == component.itemId) continue;
				  
	        	if ('INSTANCE' == component.targetType) {
	        		if(0 < deleteInstanceList.length) {
	        			deleteInstanceList.forEach(function(instanceInfo, index) {
	        				if(component.chart.deleteTarget)
	        					component.chart.deleteTarget(instanceInfo.instanceId);
	        			});
	        		}

	        		if(0 < addInstanceList.length) {
	        			addInstanceList.forEach(function(instanceInfo, index) {
	        				if(component.chart.addTarget)
	        					component.chart.addTarget({targetId : instanceInfo.instanceId, targetName : instanceInfo.instanceId, color : ''});
	        			});
	        		}
					  
	        		if(0 < deleteInstanceList.length || 0 < addInstanceList.length) {
	        			isChangeFlag = true;
						  
	        			_this.instanceList.forEach(function(instanceInfo, index) {
	        				if(component.chart.updateTarget)
	        					component.chart.updateTarget(instanceInfo.instanceId, {color : instanceInfo.color});
	        			});
						  
	        			if(component.chart.draw)
	        				component.chart.draw();
	        		}
	        	} else if ('CONNECTOR' == component.targetType) {
	        		component.monitorComponentTargets.forEach(function(componentTargetInfo, index) {
	        			if (-1 == _this.connectorList.map(function(connectorInfo) { return connectorInfo.connectorId; }).indexOf(componentTargetInfo.pk.componentTargetId)) {
	        				isChangeFlag = true;
							  
	        				if(component.chart.deleteTargetAll)
	        					component.chart.deleteTargetAll();
	        			} else {
	        				var filterConnectorInfo = _this.connectorList.filter(function(connectorInfo) { 
	        					return connectorInfo.connectorId == componentTargetInfo.pk.componentTargetId; 
	        				})[0];
							  
	        				var filterOldConnectorInfo = oldConnectorList.filter(function(oldConnectorInfo) { 
	        					return oldConnectorInfo.connectorId == componentTargetInfo.pk.componentTargetId; 
	        				})[0];
							  
	        				var currInstanceList = filterConnectorInfo.instanceList;
	        				var oldInstanceList = filterOldConnectorInfo.instanceList;
							  
	        				var deleteInstanceList = oldInstanceList.filter(function(oldInstanceInfo) {
	        					return -1 == currInstanceList.map(function(instanceInfo) { return instanceInfo.pk.instanceId }).indexOf(oldInstanceInfo.pk.instanceId);
	        				});
							  
	        				var addInstanceList = currInstanceList.filter(function(instanceInfo) {
	        					return -1 == oldInstanceList.map(function(oldInstanceInfo) { return oldInstanceInfo.pk.instanceId }).indexOf(instanceInfo.pk.instanceId);
	        				});
							  
	        				if(0 < deleteInstanceList.length) {
	        					deleteInstanceList.forEach(function(instanceObj) {
	        						if(component.chart.deleteTarget)
	        							component.chart.deleteTarget(instanceObj.pk.instanceId);
	        					});									  
	        				}

	        				if(0 < addInstanceList.length) {
	        					addInstanceList.forEach(function(instanceObj) {
	        						if(component.chart.addTarget)
	        							component.chart.addTarget({targetId : instanceObj.pk.instanceId, targetName : instanceObj.pk.instanceId});
	        					});									  
	        				}
							  
	        				if(0 < deleteInstanceList.length || 0 < addInstanceList.length) {
	        					isChangeFlag = true;
								  
	        					if(component.chart.draw)
	        						component.chart.draw();
	        				}
	        			}
	        		});
	        	} else if ('QUEUE' == component.targetType) {
	        		component.monitorComponentTargets.forEach(function(componentTargetInfo, index) {
	        			if (-1 == _this.queueList.map(function(queueInfo) { return queueInfo.adapterId; }).indexOf(componentTargetInfo.pk.componentTargetId)) {
	        				isChangeFlag = true;
							  
	        				if(component.chart.deleteTargetAll)
	        					component.chart.deleteTargetAll();
	        			} else {
	        				var filterQueueInfo = _this.queueList.filter(function(queueInfo) { 
	        					return queueInfo.adapterId == componentTargetInfo.pk.componentTargetId; 
	        				})[0];
							  
	        				var filterOldQueueInfo = oldQueueList.filter(function(oldQueueInfo) { 
	        					return oldQueueInfo.adapterId == componentTargetInfo.pk.componentTargetId; 
	        				})[0];
							  
	        				var currInstanceList = filterQueueInfo.instanceList;
	        				var oldInstanceList = filterOldQueueInfo.instanceList;
							  
	        				var deleteInstanceList = oldInstanceList.filter(function(oldInstanceInfo) {
	        					return -1 == currInstanceList.map(function(instanceInfo) { return instanceInfo.pk.instanceId }).indexOf(oldInstanceInfo.pk.instanceId);
	        				});
							  
	        				var addInstanceList = currInstanceList.filter(function(instanceInfo) {
	        					return -1 == oldInstanceList.map(function(oldInstanceInfo) { return oldInstanceInfo.pk.instanceId }).indexOf(instanceInfo.pk.instanceId);
	        				});
							  
	        				if(0 < deleteInstanceList.length) {
	        					deleteInstanceList.forEach(function(instanceObj) {
	        						if(component.chart.deleteTarget)
	        							component.chart.deleteTarget(instanceObj.pk.instanceId);
	        					});									  
	        				}

	        				if(0 < addInstanceList.length) {
	        					addInstanceList.forEach(function(instanceObj) {
	        						if(component.chart.addTarget)
	        							component.chart.addTarget({targetId : instanceObj.pk.instanceId, targetName : instanceObj.pk.instanceId});
	        					});									  
	        				}
							  
	        				if(0 < deleteInstanceList.length || 0 < addInstanceList.length) {
	        					isChangeFlag = true;
								  
	        					if(component.chart.draw)
	        						component.chart.draw();
	        				}
	        			}
	        		});						  
	        	} else if ('THREAD' == component.targetType) {
	        		if(0 < deleteInstanceList.length) {
	        			deleteInstanceList.filter(function(instance) {
	        				return 'T' === instance.instanceType;
	        			}).forEach(function(instanceInfo, index) {
	        				if(component.chart.deleteTarget)
	        					component.chart.deleteTarget(instanceInfo.instanceId);
	        			});
	        		}
					  
	        		if(0 < addInstanceList.length) {
	        			addInstanceList.filter(function(instance) {
	        				return 'T' === instance.instanceType;
	        			}).forEach(function(instanceInfo, index) {
	        				if(component.chart.addTarget)
	        					component.chart.addTarget({targetId : instanceInfo.instanceId, targetName : instanceInfo.instanceId});
	        			});
	        		}
					  
	        		if(0 < deleteInstanceList.length || 0 < addInstanceList.length) {
	        			isChangeFlag = true;
						  
	        			if(component.chart.draw)
	        				component.chart.draw();
	        		}
	        	} else if ('EXTERNALLINE' == component.targetType) {
	        		deleteExternalLineList.forEach(function(externalInfo, index) {
	        			if(component.chart.deleteTarget)
	        				component.chart.deleteTarget(externalInfo.externalLineId);
	        		});
					  
	        		addExternalLineList.forEach(function(externalInfo, index) {
	        			if(component.chart.addTarget)
	        				component.chart.addTarget({targetId : externalInfo.externalLineId, targetName : externalInfo.externalLineName});
	        		});
					  
	        		if(0 < addExternalLineList.length) {
	        			if(component.chart.draw)
	        				component.chart.draw();
	        		}				  
	        	}
	        }

	        if(isChangeFlag) {
	        	_this.instanceList.forEach(function(instanceInfo) {
	        		componentFilterDataFunc(instanceInfo.instanceId, false);
	        	});			  
	        } else {
	        	if (monitorSocket)
	        		monitorSocket.send(getWebsocketSendParam());
	        }
	        
	        oldInstanceList.splice(0, oldInstanceList.length);
	        oldAdapterList.splice(0, oldAdapterList.length);
	        oldConnectorList.splice(0, oldConnectorList.length);
	        oldQueueList.splice(0, oldQueueList.length);
	        oldExternalLineList.splice(0, oldExternalLineList.length);
	        
			oldInstanceList = null;
			oldAdapterList = null;
			oldConnectorList = null;
			oldQueueList = null;
			oldExternalLineList = null;
		});
	}
	
	function setNotice() {
		if('true' == localStorage.getItem('isViewNotice_' + _this.containerInfo.containerId)) {
			if(noticeGrid) {
				noticeGrid.getData().forEach(function(dataInfo) {
					if(Date.now() - dataInfo.showTime <= noticeDataHoldingTime * 1000) return;
					noticeGrid.removeRow(dataInfo.rowKey);
				});

				var sortNoticeDataList = noticeDataList.sort(function(a, b) {
					return new Date(a.noticeDateTime).getTime() - new Date(b.noticeDateTime).getTime(); 
				});

				if(0 < sortNoticeDataList.length) {
					sortNoticeDataList.forEach(function(dataInfo) {
						dataInfo.showTime = Date.now();
						noticeGrid.prependRow(cloneObject(dataInfo));  
					});
				}
			  
				var temporaryCloseStartTime = $("#noticeArea").data('temporaryCloseStartTime');
			  
				if(!temporaryCloseStartTime || (temporaryCloseStartTime && (Date.now() - temporaryCloseStartTime) >= noticeTemporaryCloseStartTime * 1000)) {
				  
					if(temporaryCloseStartTime) 
						$("#noticeArea").removeData('temporaryCloseStartTime');

					if(0 < noticeGrid.getData().length) {
						$("#noticeArea").show(0, function() {
							noticeGrid.refreshLayout();
						});					  
					}else{
						$("#noticeArea").hide();
					}
				}
			}
		  
			noticeDataList = [];
		} else {
			if(noticeGrid && 0 < noticeGrid.getData().length) 
				noticeGrid.clear();
		  
			if('none' != $("#noticeArea").css('display')) 
				$("#noticeArea").hide();
		  
			if(0 < noticeDataList.length) 
				noticeDataList = [];
		}	
	}
  
	function changeContainer(mod, pDashContainerOption) {
	  
		unloadContainer();
	  
		$(dashContainerElement).removeClass('ct-dashboard');
		$(dashContainerElement).parent().removeClass('dark');

		$("#dashContextMenu").remove();
		$("#dashContextSetting").remove();
		$("#dashBar").remove();
		$("#dashboard").remove();
	  
		$('#dashModal').on('hidden.bs.modal', function() {
			$('#dashModal').remove();
			setDashContainer(mod, pDashContainerOption);
		});
		$('#dashModal').modal('hide');

		$('#dashModalLarge').on('hidden.bs.modal', function() {
			$('#dashModalLarge').remove();
			setDashContainer(mod, pDashContainerOption);
		});
		$('#dashModalLarge').modal('hide');
		
		$("#noticeArea").remove();
	}
	
	function setDashContainer(mod, pDashContainerOption) {
		$('#dashModal, #dashModalLarge').remove();
		
		var dashContainerOption = {mod : mod};
		  
		if('view' == mod) dashContainerOption.websocketUrl = websocketUrl;
    
		if (pDashContainerOption) {
			dashContainerOption = $.extend(true, {}, dashContainerOption, pDashContainerOption);
		}
	  
		$(dashContainerElement).dashContainer(dashContainerOption);			
	}	
  
	function unloadContainer() {
	  
		if(null != intervalId) {
			clearInterval(intervalId);
			intervalId = null;
		}
	  
		if(null != rafId) {
			cancelAnimationFrame(rafId);
			rafId = null;
		}
	  
		if(null != monitorSocket) {
			monitorSocket.close();
			monitorSocket = null;
		}
	  
		if(null != refreshTimeoutId) {
			clearTimeout(refreshTimeoutId);
		  	refreshTimeoutId = null;
		}
	  
		if(_this.componentList) {
		  
			for(var i = 0; i < _this.componentList.length; i++) {

				var component = _this.componentList[i];
				
				if(!component.chart) continue;
			  	
				if(!component.chart.unload) continue;
			  
				component.chart.unload();
			}
			
			_this.componentList.splice(0, _this.componentList.length);
		}
	  
		noticeDataList = [];
		noticeDataHistoryList = [];
	}

	function validationDashConfigModal() {

		var containerName = $('#dashModal').find('#containerName').val();
		var containerWidth = $('#dashModal').find('#containerWidth').val();
		var containerHeight = $('#dashModal').find('#containerHeight').val();

		if (0 == $.trim(containerName).length) {
			warnAlert({message : dashboardMsg_enterName});
			return false;
		}

		if (0 == $.trim(containerWidth).length || 0 == $.trim(containerHeight).length) {
			warnAlert({message : dashboardMsg_enterResolution});
			return false;
		}

		if (0 == $.trim(containerWidth.replace(/[^0-9]/g, "")).length || 0 == $.trim(containerHeight.replace(/[^0-9]/g, "")).length) {
			warnAlert({message : dashboardMsg_enterNumber});
			return false;
		}
		
		return true;
	}
	
	function existEqualsContainerName(paramObj, callBackFunc) {
		$.ajax({
			type : 'GET',
			url : contextPath + '/igate/monitoring/dashboard/existEqualsContainerName.json',
			data : {
				containerName: $.trim(paramObj.containerName),
				containerId: paramObj.containerId,
			},
			dataType : "json",
			success : function(res) {
				if('ok' != res.result) return;

				if(res.object) {
					warnAlert({message : dashboardMsg_overlapWarn});
					return;
				}
			  
				if(callBackFunc) callBackFunc();
			}
		});	  
	}
}

DashContainerView.prototype = Object.create(DashContainerParent.prototype);
DashContainerView.prototype.constructor = DashContainerView;