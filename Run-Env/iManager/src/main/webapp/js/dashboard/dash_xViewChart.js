$.fn.xViewChart = function(createOptions) {
	
	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];

    var darkmodeYn = chartOptions.darkmodeYn;
    var componentId = chartOptions.componentId;
    var componentName = chartOptions.componentName;
    
    var yAxisMax = (null == localStorage.getItem('xViewYAxisMax_' + componentId))? xViewDefaultYAxisMax : localStorage.getItem('xViewYAxisMax_' + componentId);
    var trans = (null == localStorage.getItem('xViewTrans_' + componentId))? xViewDefaultTrans : localStorage.getItem('xViewTrans_' + componentId);
    
    var chartTopPadding = 20;
    var chartBottomPadding = 20;
    var chartLeftPadding = 90;
    var chartRightPadding = 40;
    
	var xAxisMaxValue = null;
	var xAxisMinValue = null;
	var chartMoveXRemainder = 0;
	var chartDrawXRemainder = 0;
	
	var yAxisMaxValue = yAxisMax;
	var yAxisTickCount = 6;
	var yAxisStepSize = (yAxisMaxValue / (yAxisTickCount - 1)).toFixed(2);
	//var yAxisTicksInfo = getYAxisTicksInfo(yAxisMaxValue, yAxisTickCount);
	//yAxisMaxValue = yAxisTicksInfo.maxValue;
	//var yAxisStepSize = yAxisTicksInfo.stepSize;
	
	var isFirstChartRecvStandardTime = false;
	
	var saveDataArr = [];
	var drawDataArr = [];

	var adapterFilterObj =  (null == localStorage.getItem('xViewadapterFilter_' + componentId))? {} : JSON.parse(localStorage.getItem('xViewadapterFilter_' + componentId));
	var instanceFilterObj =  (null == localStorage.getItem('xViewInstanceFilter_' + componentId))? {} : JSON.parse(localStorage.getItem('xViewInstanceFilter_' + componentId));
	var transactionFilter =  (null == localStorage.getItem('xViewtransactionFilter_' + componentId))? '' : localStorage.getItem('xViewtransactionFilter_' + componentId);
	
	var dragStartMousePosInfo = null;
	var dragStopMousePosInfo = null;
	
	var deleteStart = null;

	var iconBasicColor = '#8a8b92';
	
	var COLOURS = ['#62d36f', '#efc402', '#ed3137', '#666666'];
	
	var COLOURS_0 = Chart.helpers.color(COLOURS[0]).alpha(trans).rgbString();
	var COLOURS_1 = Chart.helpers.color(COLOURS[1]).alpha(trans).rgbString();
	var COLOURS_2 = Chart.helpers.color(COLOURS[2]).alpha(trans).rgbString();
	var COLOURS_FILTER = Chart.helpers.color(COLOURS[3]).alpha(trans).rgbString();
	
    var canvasBackground = null;
    var canvasBody = null;
    
    var canvasBackgroundWidth = null;
    var canvasBackgroundHeight = null;
    
    var fontColor = ('Y' == darkmodeYn)? '#ffffff' : Chart.helpers.color('#212529').alpha(0.6).rgbString();
    var axisLineColor = ('Y' == darkmodeYn)? '#666666' : '#f0f1f6';
    
    var targetInfoList = [];
    
	function xViewChart() {
		
		initAppendTag.call(this);
		
		initFunc.call(this);
		
	    dataFilterWorker.onmessage = function(e) {
	    	if('drag' == e.data.mod) {
	    		openXLogDetailModalGrid(e);
	    	}else if('export' == e.data.mod) {
	    		downloadCSVStartCallback(e);
	    	}
	    };
	}
	
	function initAppendTag() {
		
		chartTag.append($("#tmpXviewSkeleton").html());
		
		if('Y' == chartOptions.remarkYn) chartTag.find('.legend').show();
		else							 chartTag.find('.legend').hide();
		
		var filterIconColor = (Object.keys(adapterFilterObj).length > 0 || Object.keys(instanceFilterObj).length > 0 || transactionFilter.length > 0)? COLOURS[2] : iconBasicColor;
		chartTag.parent().find('[name=filterSetIcon]').css('color', filterIconColor);
		
		setTimeout(function() {
			
			canvasBackgroundWidth = chartTag.find("[name=background]").width();
			canvasBackgroundHeight = chartTag.find("[name=background]").height();
			
			canvasBackground = $("<canvas/>").attr({width: chartTag.find("[name=background]").width(), height: chartTag.find("[name=background]").height()});
			canvasBody = $("<canvas/>").attr({width: chartTag.find("[name=body]").width(), height: chartTag.find("[name=body]").height()});
			
			chartTag.find("[name=background]").append(canvasBackground);
			chartTag.find("[name=body]").append(canvasBody);
			
			initYAxis.call(this);
			
			initEvtBind.call(this);
			
		}.bind(this), 0);
	}
	
	function initDeleteDataInterval() {
		
		var findIdx = null;
		
		for(var i = 0; i < saveDataArr.length; i++) {
			if(saveDataArr[i].x >= xAxisMinValue) {
				findIdx = i;
				break;
			}
		}
		
		saveDataArr = (null != findIdx)? saveDataArr.slice(findIdx) : [];
		
		findIdx = null;
		
		for(var i = 0; i < drawDataArr.length; i++) {
			if(drawDataArr[i].x >= xAxisMinValue) {
				findIdx = i;
				break;
			}
		}
		
		drawDataArr = (null != findIdx)? drawDataArr.slice(findIdx) : [];
		
	}
	
	function initEvtBind() {
		
		canvasBody.selectable({
			start: function(event, ui) {
				dragStartMousePosInfo = getCanvasMousePos(this, event.originalEvent);
			},
			stop: function(event, ui) {
				
				dragStopMousePosInfo = getCanvasMousePos(this, event.originalEvent);
				
				var dragStartX = dragStartMousePosInfo.x;
				var dragStartY = dragStartMousePosInfo.y;
				var dragStoptX = dragStopMousePosInfo.x;
				var dragStopY = dragStopMousePosInfo.y;
				
				var startX = (dragStartX < dragStoptX)? dragStartX : dragStoptX;
				var endX = (dragStartX < dragStoptX)? dragStoptX : dragStartX;
				var startY = (dragStartY < dragStopY)? dragStartY : dragStopY;
				var endY = (dragStartY < dragStopY)? dragStopY : dragStartY;
				
				if(10 > endX - startX || 10 > endY - startY) return;
				
				startSpinner();
				
				startX -= 5;
				endX += 5;
				startY -= 5;
				endY +=5;
				
				var xCoorAlpha = (xAxisMaxValue - xAxisMinValue) / (canvasBody[0].width - (chartLeftPadding + chartRightPadding));
				var yCoordAlpha = (canvasBody[0].height - (chartTopPadding + chartBottomPadding)) / yAxisMaxValue;
				
				var startFilterTime = ((startX - chartLeftPadding) * xCoorAlpha) + xAxisMinValue;
				var endFilterTime = ((endX - chartLeftPadding) * xCoorAlpha) + xAxisMinValue;
				var endFilterValue = -((startY - chartTopPadding) - (canvasBody[0].height - (chartTopPadding + chartBottomPadding))) / yCoordAlpha;				
				var startFilterValue = -((endY - chartTopPadding) - (canvasBody[0].height - (chartTopPadding + chartBottomPadding))) / yCoordAlpha;
				
				dataFilterWorker.postMessage({
					mod: 'drag',
					isSort: true,
					dataArr: saveDataArr,
					startFilterTime: startFilterTime,
					endFilterTime: endFilterTime, 
					startFilterValue: startFilterValue,
					endFilterValue: endFilterValue,
					yAxisMaxValue: yAxisMaxValue,
					adapterFilterObj : adapterFilterObj,
					instanceFilterObj : instanceFilterObj,
					transactionFilter : $.trim(transactionFilter)
				});
			}
		});
	}
	
	function initYAxis() {
		
		var ctxBackground = canvasBackground[0].getContext('2d');
		
		var yCoordAlpha = (ctxBackground.canvas.height - (chartTopPadding + chartBottomPadding)) / yAxisMaxValue;

		ctxBackground.beginPath();
		
		ctxBackground.clearRect(0, 0, ctxBackground.canvas.width, ctxBackground.canvas.height);

		//y축 오른쪽 세로 라인
		ctxBackground.moveTo(chartLeftPadding, chartTopPadding);
		ctxBackground.lineTo(chartLeftPadding, ctxBackground.canvas.height - chartBottomPadding);
		ctxBackground.strokeStyle = axisLineColor;
		ctxBackground.stroke();
		
        ctxBackground.font = "12px Arial";
        ctxBackground.textAlign = 'right';
        ctxBackground.textBaseline = "middle";
        
        for(var i = 0; i < yAxisTickCount; i++) {
        	
        	var value = yAxisStepSize * i;
        
        	var yCoord = ((ctxBackground.canvas.height - (chartTopPadding + chartBottomPadding)) - (yCoordAlpha * value)) + chartTopPadding;
        	
        	//y축 값
        	ctxBackground.fillStyle = fontColor;
        	ctxBackground.fillText(convertValue(value, 'NUMBER'), chartLeftPadding - 15, yCoord);
        	
        	//y축 가로 라인
    		ctxBackground.moveTo(chartLeftPadding - 7, yCoord);
    		ctxBackground.lineTo(ctxBackground.canvas.width - chartRightPadding, yCoord);
    		ctxBackground.strokeStyle = axisLineColor;
    		ctxBackground.stroke();
        }
        
        ctxBackground.closePath();
	}
	
	function initXAxis() {
		
		var ctxBody = canvasBody[0].getContext('2d');
		
		var xCoorAlpha = (xAxisMaxValue - xAxisMinValue) / (ctxBody.canvas.width - (chartLeftPadding + chartRightPadding));
		
		ctxBody.clearRect(0, 0, ctxBody.canvas.width, ctxBody.canvas.height);

		ctxBody.font = '12px Arial';
		ctxBody.textAlign = 'center';
    	
    	for(var i = 0; i < xViewChartTimeDuration; i++) {
    		
    		ctxBody.beginPath();
    		
    		var majorTickTime = (Math.floor(xAxisMinValue / (60 * 1000)) * (60 * 1000)) + ((i + 1) * 60 * 1000);
    		var majorTickTimeXCoord = (majorTickTime - xAxisMinValue) / xCoorAlpha;

    		ctxBody.save();
    		ctxBody.strokeStyle = Chart.helpers.color(axisLineColor).alpha(0.5).rgbString();
    		ctxBody.lineWidth = 2;
    		ctxBody.moveTo(chartLeftPadding + majorTickTimeXCoord, chartTopPadding);
    		ctxBody.lineTo(chartLeftPadding + majorTickTimeXCoord, (ctxBody.canvas.height - chartBottomPadding) + 10);
    		ctxBody.stroke();
    		ctxBody.restore();
    		
        	ctxBody.fillStyle = fontColor;
        	ctxBody.fillText(moment(new Date(majorTickTime)).format('HH : mm'), chartLeftPadding + majorTickTimeXCoord, (ctxBody.canvas.height - chartBottomPadding) + 20);
        	
        	ctxBody.closePath();
    	}
	}

	function openXLogDetailModalGrid(e) {
		
		stopSpinner();
		
		$('#xLogDetailModal').remove();
		
		var detailModalSkeleton = $("#xLogDetailModalSkeleton").clone();
		detailModalSkeleton.find('#xLogDetail').attr('id', 'xLogDetailModal');
		$('body').append(detailModalSkeleton.html());
		
		var xLogDetailModalGrid = null;
		
		if(0 == e.data.dataArr.length) {
			normalAlert(dashboardMsg_noMatchCriteria);
			return;
		}
		
		$('#xLogDetailModal').on('show.bs.modal', function(e) {
			
			function step() { 
				if(0 == $('#xLogDetailModal').length) {
					cancelAnimationFrame(rafId);
					return;
				}
				
				if(0 < $('#xLogDetailModal').next().length) { 	  
					$('#xLogDetailModal').next().css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
					$('#xLogDetailModal').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;
					cancelAnimationFrame(rafId);
					return;
				}
           
				rafId = requestAnimationFrame(step);
			}
         
			var rafId = requestAnimationFrame(step);
		});
		
		$('#xLogDetailModal').on('shown.bs.modal', function () {

			$('#xLogDetailModal').find('.modal-body').find("#xLogDetailModalGrid").remove();
			$('#xLogDetailModal').find('.modal-body').append($("<div/>").attr({'id': 'xLogDetailModalGrid'}));
			
			var perPage = 20;
			var scrollEndIdx = 1;
			
			var settings = {
				el : document.getElementById('xLogDetailModalGrid'),
				bodyHeight: 250,
				data: (e.data.dataArr)? e.data.dataArr.slice(0, perPage) : null,
				columns : [
							{
								name : "type",		 		 
								header : dashboardGrid_status,
								width: '7%',	
								align : "center",
								formatter: function(obj) {
									if(2 == obj.value)       return '<span style="color: #ed3137">'+ dashboardLabel_error +'</span>';
									else if(1 == obj.value)  return '<span style="color: #ffc107">'+ dashboardLabel_timeout +'</span>';
									else 					 return '<span style="color: #28a745">'+ dashboardLabel_success +'</span>';    
								}
							},
							{
								name : "uuid", 			 
								header : dashboardGrid_transactionId,
								width: '13%'
							},
							{
								name : "transactionId", 	 
								header : dashboardGrid_interfaceserviceId,
								width: '10%'
							},
							{
								name : "transactionName", 	 
								header : dashboardGrid_transactionName,
								width: '15%'
							},
							{
								name : "adapterId", 		 
								header : dashboardGrid_adapterId,
								width: '20%'
							},
							{
								name : "instanceId", 		 
								header : dashboardGrid_instanceId,
								width: '10%',
							},
							{
								name : "snapshotTimestamp", 
								header : dashboardGrid_snapshotTimestamp,  
								width: '10%',
								align : "center",
								formatter: function(obj) {
									return moment(new Date(obj.value)).format('HH:mm:ss');
								}
							},
							{
								name : "y",  				 
								header : dashboardGrid_responseTime, 
								width: '10%',
								align : "right",
								formatter: function(obj) {
									return obj.value + ' ms';
								}
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
		        	
		        	xLogDetailModalGrid.getColumns().forEach(function(columnInfo) {
		        		if(!columnInfo.copyOptions) return;

		        		if(columnInfo.copyOptions.widthRatio) {
		        			resetColumnWidths.push($('#xLogDetailModalGrid').width() * (columnInfo.copyOptions.widthRatio / 100));
		        		}
		        	});
		        	
		        	if(0 < resetColumnWidths.length)
		        		xLogDetailModalGrid.resetColumnWidths(resetColumnWidths);
		        	
		        	$('#xLogDetailModalGrid').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
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
			
			xLogDetailModalGrid = new tui.Grid(settings);
			
			xLogDetailModalGrid.on('mouseover', function(ev) {
				if('cell' != ev.targetType) return;
		    	  
				var overCellElement = $(xLogDetailModalGrid.getElement(ev.rowKey, ev.columnName));    	  
				overCellElement.attr('title', overCellElement.text());
			});			
			
			xLogDetailModalGrid.on('scrollEnd', function() {
				
				if(scrollEndIdx > Math.ceil(e.data.dataArr.length / perPage)){
					return;
				}
				
				xLogDetailModalGrid.appendRows(e.data.dataArr.slice(perPage * scrollEndIdx, perPage * (scrollEndIdx + 1)));
				scrollEndIdx += 1;
			});
			
			xLogDetailModalGrid.on('click', function(ev) {
				if('undefined' == typeof ev.rowKey) return;
				localStorage.setItem('selectedRowDashboard', xLogDetailModalGrid.getRow(ev.rowKey).uuid);
				window.open(contextPath + '/igate/traceLog.html');
			});	
			
			$('#xLogDetailModal').find('.modal-header').find('[name=exportXlogDetailCsvIcon]').off('click').on('click', function() {

				startSpinner();
				
				var csvData = '';
				
				var dataArr = e.data.dataArr;
				
				if (xViewMaxExportCnt < dataArr.length) {
					csvData += dashboardMsg_xViewExportMaxCnt + '\r\n';
					dataArr = dataArr.slice(0, xViewMaxExportCnt);
				}
				
				csvData += dashboardGrid_status + ',' + dashboardGrid_uuid + ',' + dashboardGrid_transactionId + ',' + dashboardGrid_transactionName + ',' + 
						   dashboardGrid_adapterId + ',' + dashboardGrid_instanceId + ',' + dashboardGrid_snapshotTimestamp + ',' + dashboardGrid_responseTime + '\r\n'; 
				
				for(var i = 0; i < dataArr.length; i++) {
					
					var data = dataArr[i];
					
					var type = (2 == data.type)? dashboardLabel_error : (1 == data.type)? dashboardLabel_timeout : dashboardLabel_success;
					var uuid = data.uuid;
					var transactionId = data.transactionId;
					var transactionName = data.transactionName;
					var adapterId = data.adapterId;
					var instanceId = data.instanceId;
					var snapshotTimestamp = moment(new Date(data.snapshotTimestamp)).format('HH:mm:ss');
					var y = data.y;
					
					csvData += type + ',' + uuid + ',' + transactionId + ',' + transactionName + ',' + adapterId + ',' + instanceId + ',' + snapshotTimestamp + ',' + y + '\r\n';
				}

				var csvFileName = moment(new Date()).format('YYYY-MM-DD hh-mm-ss') + '_' + componentName + '_' + $('#xLogDetailModal').find('.modal-header').find('.modal-title').text() + '_' + getUUID();  
				
				downloadCSV(csvFileName, csvData);
				
				stopSpinner();
			});
		});
		
		$('#xLogDetailModal').on('hidden.bs.modal', function () {
			e.data.dataArr = null;
			xLogDetailModalGrid.destroy();
			$('#xLogDetailModal').find('.modal-body').find("#xLogDetailModalGrid").remove();
			$('#xLogDetailModal').find('.modal-header').find('[name=exportXlogDetailCsvIcon]').off('click');
			$('#xLogDetailModal').modal('dispose');
		});

	    $('#xLogDetailModal').modal('show');
	}
	
	function downloadCSVStartCallback(e) {
		
		var csvData = '';
		
		var dataArr = e.data.dataArr;
		
		if (xViewMaxExportCnt < dataArr.length) {
			csvData += dashboardMsg_xViewExportMaxCnt + '\r\n';
			dataArr = dataArr.slice(0, xViewMaxExportCnt);
		}
		
		csvData += dashboardGrid_status + ',' + dashboardGrid_uuid + ',' + dashboardGrid_transactionId + ',' + dashboardGrid_transactionName + ',' + 
				   dashboardGrid_adapterId + ',' + dashboardGrid_instanceId + ',' + dashboardGrid_snapshotTimestamp + ',' + dashboardGrid_responseTime + '\r\n'; 
		
		for(var i = 0; i < dataArr.length; i++) {
			
			var data = dataArr[i];
			
			var type = (2 == data.type)? dashboardLabel_error : (1 == data.type)? dashboardLabel_timeout : dashboardLabel_success;
			var uuid = data.uuid;
			var transactionId = data.transactionId;
			var transactionName = data.transactionName;
			var adapterId = data.adapterId;
			var instanceId = data.instanceId;
			var snapshotTimestamp = moment(new Date(data.snapshotTimestamp)).format('HH:mm:ss');
			var y = data.y;
			
			csvData += type + ',' + uuid + ',' + transactionId + ',' + transactionName + ',' + adapterId + ',' + instanceId + ',' + snapshotTimestamp + ',' + y + '\r\n';
		}
		
		downloadCSV(moment(new Date()).format('YYYY-MM-DD hh-mm-ss') + '_'  + e.data.csvFileName + '_' + getUUID(), csvData);
		
		stopSpinner();
	}

	function initFunc() {

		this.addTarget = function(targetObj, isLastTarget) { 
			targetObj.isFiltered = false;
			targetInfoList.push(targetObj);
		};
		
		this.deleteTarget = function(targetId) {
			var findIndex = targetInfoList.map(function(targetInfo) { return targetInfo.targetId; }).indexOf(targetId);

			targetInfoList.splice(findIndex, 1);
		};
		
		this.addData = function(dataArr) {
			Array.prototype.push.apply(saveDataArr, dataArr);
			
			Array.prototype.push.apply(drawDataArr, dataArr.map(function(data) { 
				return cloneObject(data);
			}));
			
			dataArr = null;
			
			if(!(Object.keys(adapterFilterObj).length > 0 || Object.keys(instanceFilterObj).length > 0 || transactionFilter.length > 0)) return;
			
			drawDataArr = drawDataArr.filter(function(data) {
				var isAdapterFilter = (0 < Object.keys(adapterFilterObj).length)? adapterFilterObj[data.adapterId] : true;  
				
				var isInstanceFilter = (0 < Object.keys(instanceFilterObj).length)? instanceFilterObj[data.instanceId] : true;
				
				var isTransactionFilter = (0 < $.trim(transactionFilter).length)? $.trim(transactionFilter) == data.transactionId : true;
				
				return isAdapterFilter && isInstanceFilter && isTransactionFilter;
			});
		};
		
		this.setInterval = function(standardTime, isFirstRecvStandardTime) {
			
			//shift chart
			if(null == xAxisMaxValue || (!isFirstChartRecvStandardTime && isFirstRecvStandardTime)) {
				xAxisMaxValue = Math.floor(standardTime / 1000) * 1000;
				xAxisMinValue = xAxisMaxValue - (xViewChartTimeDuration * 60 * 1000);
				initXAxis.call(this);
				isFirstChartRecvStandardTime = true;
			}else {
				
				var isChangeXAxisMaxValue = false;
				
				var beforeDate = new Date(xAxisMaxValue);
				var currentDate = new Date(Math.floor(standardTime / 1000) * 1000);
				
				var diffTime = currentDate.getTime() - beforeDate.getTime();
				
				isChangeXAxisMaxValue = beforeDate.getMinutes() != currentDate.getMinutes();
				
				xAxisMaxValue = Math.floor(standardTime / 1000) * 1000;
				xAxisMinValue = xAxisMaxValue - (xViewChartTimeDuration * 60 * 1000);
				
				var ctxBody = canvasBody[0].getContext('2d');
				
				if(0 == ctxBody.canvas.width || 0 == ctxBody.canvas.height) return;
				
				var xCoorAlpha = (xAxisMaxValue - xAxisMinValue) / (ctxBody.canvas.width - (chartLeftPadding + chartRightPadding));			
				
				var tmpX = Math.floor(diffTime / xCoorAlpha);
				
				chartMoveXRemainder += (diffTime / xCoorAlpha) % 1;
				chartDrawXRemainder = (diffTime / xCoorAlpha) % 1;
				
				if(1 <= chartMoveXRemainder) {
					tmpX += Math.floor(chartMoveXRemainder / 1);
					chartMoveXRemainder -= Math.floor(chartMoveXRemainder / 1);
					chartDrawXRemainder = chartMoveXRemainder; 
				}
				
				var imgData = ctxBody.getImageData(chartLeftPadding + tmpX, 0, ctxBody.canvas.width, ctxBody.canvas.height);
				
				ctxBody.beginPath();
				
				ctxBody.clearRect(0, 0, ctxBody.canvas.width, ctxBody.canvas.height);
				
				ctxBody.putImageData(imgData, chartLeftPadding, 0);
						
				ctxBody.closePath();
				
				if(isChangeXAxisMaxValue) {
					
					var majorTickTime = (Math.floor(xAxisMinValue / (60 * 1000)) * (60 * 1000)) + (xViewChartTimeDuration * 60 * 1000);
					var majorTickTimeXCoord = (majorTickTime - xAxisMinValue) / xCoorAlpha;
					
					if(chartDrawXRemainder) {
						majorTickTimeXCoord += chartDrawXRemainder; 
					}
					
					ctxBody.beginPath();
					
					ctxBody.save();
			    	ctxBody.strokeStyle = Chart.helpers.color(axisLineColor).alpha(0.5).rgbString();
			    	ctxBody.lineWidth = 2;
		    		ctxBody.moveTo(chartLeftPadding + majorTickTimeXCoord, chartTopPadding);
		    		ctxBody.lineTo(chartLeftPadding + majorTickTimeXCoord, (ctxBody.canvas.height - chartBottomPadding) + 10);
		    		ctxBody.stroke();
		    		ctxBody.restore();
		        	
		    		ctxBody.font = '12px Arial';
			    	ctxBody.textAlign = 'center';
			    	ctxBody.fillStyle = fontColor;
		        	ctxBody.fillText(moment(new Date(majorTickTime)).format('HH : mm'), chartLeftPadding + majorTickTimeXCoord, (ctxBody.canvas.height - chartBottomPadding) + 20);
		        	
		    		ctxBody.closePath();
				}
			}
			
			//chart data count
			var countInfo = {'total': 0, '0': 0, '1': 0, '2': 0};
	
			for(var i = 0; i < saveDataArr.length; i++) {
				
				if(xAxisMinValue > saveDataArr[i].x) continue;
				
				if(xAxisMaxValue < saveDataArr[i].x) break;
				
				if(0 < Object.keys(adapterFilterObj).length && !(adapterFilterObj[saveDataArr[i].adapterId])) continue;
				
				if(0 < Object.keys(instanceFilterObj).length && !(instanceFilterObj[saveDataArr[i].instanceId])) continue;
				
				if(0 < $.trim(transactionFilter).length && !($.trim(transactionFilter) == saveDataArr[i].transactionId)) continue;
				
				++countInfo[saveDataArr[i].type];
			}
			
			countInfo['total'] = countInfo['0'] + countInfo['1'] + countInfo['2'];

			for(var key in countInfo) {
				countInfo[key] = (1000 > countInfo[key])? countInfo[key] : convertValue(countInfo[key], 'NUMBER');
			}
			
			var ctxBackground = canvasBackground[0].getContext('2d');
			
			ctxBackground.beginPath();

			ctxBackground.clearRect(chartLeftPadding, chartTopPadding - 20, ctxBackground.canvas.width - (chartLeftPadding + chartRightPadding), 15);
			
			ctxBackground.font = '10px Arial';
			ctxBackground.textAlign = 'left';
			ctxBackground.textBaseline = "bottom";
			
			var fontXCoord = chartLeftPadding;
			
			ctxBackground.fillStyle = fontColor;
			ctxBackground.fillText(countInfo['total'] + ' (', fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(countInfo['total'] + ' (').width;
			
			ctxBackground.fillStyle = COLOURS[0];
			ctxBackground.fillText(countInfo['0'], fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(countInfo['0']).width;
			
			ctxBackground.fillStyle = fontColor;
			ctxBackground.fillText(', ', fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(', ').width;

			ctxBackground.fillStyle = COLOURS[1];
			ctxBackground.fillText(countInfo['1'], fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(countInfo['1']).width;
			
			ctxBackground.fillStyle = fontColor;
			ctxBackground.fillText(', ', fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(', ').width;
			
			ctxBackground.fillStyle = COLOURS[2];
			ctxBackground.fillText(countInfo['2'], fontXCoord, chartTopPadding - 5);
			fontXCoord += ctxBackground.measureText(countInfo['2']).width;

			ctxBackground.fillStyle = fontColor;
			ctxBackground.fillText(')', fontXCoord, chartTopPadding - 5);
			
			ctxBackground.closePath();
			
			//delete data
			var deleteCurrentTime = Date.now();
			
			if(!deleteStart) deleteStart = deleteCurrentTime;
			
			var deleteProgress = deleteCurrentTime - deleteStart;

			if(deleteProgress >= 15 * 1000) {
				
				deleteStart = deleteCurrentTime;

				initDeleteDataInterval.call(this);
			}
			
			//resize
		    if((null != canvasBackgroundWidth) && (null != canvasBackgroundHeight)) {
		    	if((canvasBackgroundHeight != chartTag.find("[name=background]").height()) || (canvasBackgroundWidth != chartTag.find("[name=background]").width())) {

		    		canvasBackgroundWidth = chartTag.find("[name=background]").width();
					canvasBackgroundHeight = chartTag.find("[name=background]").height();
					
					canvasBackground.attr({width: chartTag.find("[name=background]").width(), height: chartTag.find("[name=background]").height()});
					canvasBody.attr({width: chartTag.find("[name=body]").width(), height: chartTag.find("[name=body]").height()});		    		
					
					chartMoveXRemainder = 0;
					chartDrawXRemainder = 0;
					
					initYAxis.call(this);
					initXAxis.call(this);
					
		    		filterDrawData();
		    	}
		    }
		};
		
		this.filterData = function(targetId, isFiltered) {
			var filterTargetInfoList = targetInfoList.filter(function(targetInfo) {
				return targetInfo.targetId == targetId; 
			});
			
			if(0 == filterTargetInfoList.length) return;
			
			var targetInfo = filterTargetInfoList[0];
			
			targetInfo.isFiltered = isFiltered;
			
			initXAxis.call(this);
			
    		filterDrawData();
		};
		
		this.requestAnimationFrame = function(timestamp) {
			
			if(!canvasBody) return;
			
			if(0 == drawDataArr.length) return;
			
			var ctxBody = canvasBody[0].getContext('2d');
			
			var xCoorAlpha = (xAxisMaxValue - xAxisMinValue) / (ctxBody.canvas.width - (chartLeftPadding + chartRightPadding));
			var yCoordAlpha = (ctxBody.canvas.height - (chartTopPadding + chartBottomPadding)) / yAxisMaxValue;
			
			(function(beforeDrawTime) {
				
				var data = null;
				
				for(var i = 0; i < drawDataArr.length; i++) {
					
					data = drawDataArr[i];
					
					if(data.isDraw || data.x > xAxisMaxValue) {
						continue;
					}
					
					if(Date.now() - beforeDrawTime >= 3) {
						break;
					}
					
					if(data.x < xAxisMinValue) {
						data.isDraw = true;
						continue;
					}
					
					var tmpXCoord = chartLeftPadding + ((data.x - xAxisMinValue) / xCoorAlpha);
					var tmpYCoord = ((ctxBody.canvas.height - (chartTopPadding + chartBottomPadding)) - (yCoordAlpha * data.y)) + chartTopPadding;
				
					if(chartDrawXRemainder) {
						tmpXCoord += chartDrawXRemainder;
					}
					
					if(tmpYCoord < chartTopPadding) {
						tmpYCoord = chartTopPadding
					} 
					
					ctxBody.beginPath();
					
					ctxBody.lineWidth = 3;
					
					var targetInfoObj = targetInfoList.filter(function(targetInfo) {
						return targetInfo.targetId == data.targetId; 
					})[0];
					
					ctxBody.strokeStyle = (targetInfoObj && targetInfoObj.isFiltered)? COLOURS_FILTER : (0 == data.type)? COLOURS_0 : (1 == data.type)? COLOURS_1 : COLOURS_2;

					ctxBody.moveTo(tmpXCoord - 5, tmpYCoord - 5);
					ctxBody.lineTo(tmpXCoord + 5, tmpYCoord + 5);
					
					ctxBody.moveTo(tmpXCoord - 5, tmpYCoord + 5);
					ctxBody.lineTo(tmpXCoord + 5, tmpYCoord - 5);

					ctxBody.stroke();
					
					ctxBody.closePath();
					
					data.isDraw = true;
				}
				
			}).call(this, Date.now());

			var findIdx = null;
			
			for(var i = 0; i < drawDataArr.length; i++) {
				if(!drawDataArr[i].isDraw) {
					findIdx = i;
					break;
				}
			}

			drawDataArr = (null != findIdx)? drawDataArr.slice(findIdx) : [];
		}
		
		this.unload = function() {
			saveDataArr = null;
			drawDataArr = null;
		};
		
		this.downloadExportStart = function(pCsvFileName) {
			
			startSpinner();
			
			dataFilterWorker.postMessage({
				mod: 'export',
				isSort: true,
				dataArr: saveDataArr,
				startFilterTime: xAxisMinValue,
				endFilterTime: xAxisMaxValue, 
				startFilterValue: 0,
				endFilterValue: yAxisMaxValue,
				yAxisMaxValue: yAxisMaxValue,
				csvFileName: pCsvFileName,
				adapterFilterObj : adapterFilterObj,
				instanceFilterObj : instanceFilterObj,
				transactionFilter : $.trim(transactionFilter)
			});
		};
		
		this.dataFilterSetting = function(filterOptions) {
			
			$('#xLogFilterModal_' + componentId).remove();
			$('#xLogFilterDetailModal_' + componentId).remove();
			
			//append filterModal
			var filterModalSkeleton = $("#xLogFilterModalSkeleton").clone();
			filterModalSkeleton.find('#xLogFilterModal').attr('id', 'xLogFilterModal_' + componentId).addClass('filterModal');
			$('body').append(filterModalSkeleton.html());
			
			var filterModal = $('#xLogFilterModal_' + componentId);
			
			var adapterList = filterOptions.adapterList;
			var instanceList = filterOptions.instanceList;
			

			
			var modalType = null;
			var allDataGrid = null; //left Grid
			var selectDataGrid = null; //right Grid
			var perPage = 8;			

			var adapterFilterData = (Object.keys(adapterFilterObj).length > 0)? adapterList.filter(function(row) { return adapterFilterObj[row.adapterId] }) : [];
			var instanceFilterData = (Object.keys(instanceFilterObj).length > 0)? instanceList.filter(function(row) { return instanceFilterObj[row.instanceId] }) : [];
			
			filterModal.on('show.bs.modal', function(e) {
				function step() { 
					if(0 == filterModal.length) {
						cancelAnimationFrame(rafId);
						return;
					}
					
					if(0 < filterModal.next().length) { 	  
						filterModal.next().css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
						filterModal.css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;
						cancelAnimationFrame(rafId);
						return;
					}
	           
					rafId = requestAnimationFrame(step);
				}
	         
				var rafId = requestAnimationFrame(step);
			});
			
			filterModal.on('hidden.bs.modal', function(e) {
				filterModal.remove();
			});
			
			filterModal.modal('show');
			
			filterModal.find('input').val('');
			filterModal.find('input').removeAttr('title');
			
			if(Object.keys(adapterFilterObj).length > 0) {				
				filterModal.find('[name=adapterFilterInput]').attr('title', Object.keys(adapterFilterObj).join(', '));
				filterModal.find('[name=adapterFilterInput]').val(Object.keys(adapterFilterObj)[0] + ((Object.keys(adapterFilterObj).length > 1)? "( +" + String(Object.keys(adapterFilterObj).length - 1) + ")" : ""));
			}
			
			if(Object.keys(instanceFilterObj).length > 0) {
				filterModal.find('[name=instanceFilterInput]').attr('title', Object.keys(instanceFilterObj).join(', '));
				filterModal.find('[name=instanceFilterInput]').val(Object.keys(instanceFilterObj)[0] + ((Object.keys(instanceFilterObj).length > 1)? "( +" + String(Object.keys(instanceFilterObj).length - 1) + ")" : ""));
			}

			if(transactionFilter.length > 0)
				filterModal.find('[name=transactionFilterInput]').val(transactionFilter);

			//어댑터 필터 설정
			filterModal.find('#adapterFilterBtn').on('click', function() {
				var allGridSetting = {originData : adapterList, setting : {data: (adapterList)? adapterList.slice(0, perPage) : null, columns : [{ name : 'adapterId', header : dashboardLabel_adapterId }]}};	
				var selectGridSetting = {originData : adapterFilterData, setting : {data: (adapterFilterData)? adapterFilterData.slice(0, perPage) : null, columns : [{ name : 'adapterId', header : dashboardLabel_adapterId }]}};
				modalType = 'adapter';
				
				xLogFilterData(allGridSetting, selectGridSetting);
			});
				
			//인스턴스 필터 설정
			filterModal.find('#instanceFilterBtn').on('click', function() {
				var allGridSetting = {originData : instanceList, setting : {data: (instanceList)? instanceList.slice(0, perPage) : null, columns : [{ name : 'instanceId', header : dashboardLabel_instanceId }]}};			
				var selectGridSetting = {originData : instanceFilterData, setting : {data: (instanceFilterData)? instanceFilterData.slice(0, perPage) : null, columns : [{ name : 'instanceId', header : dashboardLabel_instanceId }]}};
				modalType = 'instance';
				
				xLogFilterData(allGridSetting, selectGridSetting);
			});
			
			filterModal.find('#xLogFilterSetBtn').on('click', function() {				
				
				adapterFilterObj = setFilter(adapterFilterData, 'xViewadapterFilter_', 'adapterId');
				instanceFilterObj = setFilter(instanceFilterData, 'xViewInstanceFilter_', 'instanceId');
				transactionFilter = setFilter($.trim(filterModal.find('[name=transactionFilterInput]').val()), 'xViewtransactionFilter_', 'transactionId');
				
				function setFilter(tmpFilterData, localStorageId, optionKey) {
					
					var saveFilterData = ('transactionId' == optionKey)? '' : {};
					var localStorageVal = '';
					
					if(tmpFilterData.length == 0)  {
						localStorage.removeItem(localStorageId + componentId);
						return saveFilterData;
					}
					
					if('transactionId' == optionKey){
						saveFilterData = localStorageVal = tmpFilterData;
					} else {						
						tmpFilterData.forEach(function(filterOpt) { 
							saveFilterData[filterOpt[optionKey]] = true;
						});						
						
						localStorageVal = JSON.stringify(saveFilterData);
					}

					localStorage.setItem(localStorageId + componentId, localStorageVal);
					
					return saveFilterData;
				}
				
				var filterIconColor = (Object.keys(adapterFilterObj).length > 0 || Object.keys(instanceFilterObj).length > 0 || transactionFilter.length > 0)? COLOURS[2] : iconBasicColor;
				
				chartTag.parent().find('[name=filterSetIcon]').css('color', filterIconColor);
				
				initXAxis.call(this);
				
				filterDrawData();
				
			}.bind(this));

			function xLogFilterData(allDataSetting, selectDataSetting) {
				
				//append filterDetailModal
				var filterDetailModalSkeleton = $("#xLogFilterDetailModalSkeleton").clone();
				filterDetailModalSkeleton.find('#xLogFilterDetailModal').attr('id', 'xLogFilterDetailModal_' + componentId).addClass('filterModal');
				$('body').append(filterDetailModalSkeleton.html());
				
				var filterDetailModal = $('#xLogFilterDetailModal_' + componentId);
				
				var scrollLeftEndIdx = 1;
				var scrollRightEndIdx = 1;
				var settings = {
					bodyHeight: 250,
					rowHeaders : ['checkbox'],
					columnOptions : {
						resizable : true
					},
					usageStatistics : false,
					header: {
						height: 32,
						align: 'center'
					},			
			    	scrollX: false,
			    	scrollY: true,
			    	onGridMounted: function() {			        	
			    		$('.tui-grid-column-resize-handle').removeAttr('title');
			        },
				};
				
				var allGridSetting = $.extend(allDataSetting.setting, settings) ;
				var selectGridSetting = $.extend(selectDataSetting.setting, settings) ;
				
				var allGridData = allDataSetting.originData;
				var selectGridData = selectDataSetting.originData;
				
				filterDetailModal.on('show.bs.modal', function(e) {
					filterDetailModal.find('#gridBtnArea').hide();
					
					function step() { 
						if(0 == filterDetailModal.length) {
							cancelAnimationFrame(rafId);
							return;
						}
						
						if(0 < filterDetailModal.next().length) { 	  
							filterDetailModal.next().css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
							filterDetailModal.css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;
							cancelAnimationFrame(rafId);
							return;
						}
		           
						rafId = requestAnimationFrame(step);
					}
		         
					var rafId = requestAnimationFrame(step);
				});
				
				filterDetailModal.on('shown.bs.modal', function () {
					
					filterDetailModal.find('#allGridArea').find("#allFilterDataGrid").remove();
					filterDetailModal.find('#selectGridArea').find("#selectFilterDataGrid").remove();
					filterDetailModal.find('#allGridArea').append($("<div/>").attr({'id': 'allFilterDataGrid'}));
					filterDetailModal.find('#selectGridArea').append($("<div/>").attr({'id': 'selectFilterDataGrid'}));
					
					$.extend(allGridSetting, {el : document.getElementById('allFilterDataGrid')});
					
					allGridSetting.columns.forEach(function(column){
				    	  if(!column.formatter) {
				    		  column.escapeHTML = true;  
				    	  }
				    });
					
					allDataGrid = new tui.Grid(allGridSetting);
					
					allDataGrid.on('mouseover', function(ev) {
				      	  
						if('cell' != ev.targetType) return;
			      	  
			      	  	var overCellElement = $(allDataGrid.getElement(ev.rowKey, ev.columnName));    	  
			      	  	overCellElement.attr('title', overCellElement.text());
			        });
					
					allDataGrid.on('scrollEnd', function() {
						
						if(scrollLeftEndIdx > Math.ceil(allGridData.length / perPage)){
							return;
						}
						
						allDataGrid.appendRows(allGridData.slice(perPage * scrollLeftEndIdx, perPage * (scrollLeftEndIdx + 1)));
						scrollLeftEndIdx += 1;
					});
					
					$.extend(selectGridSetting, {el : document.getElementById('selectFilterDataGrid')}) ;
					
					selectGridSetting.columns.forEach(function(column){
				    	  if(!column.formatter) {
				    		  column.escapeHTML = true;  
				    	  }
				    });
					
					selectDataGrid = new tui.Grid(selectGridSetting);
					selectDataGrid.uncheckAll();
					
					selectDataGrid.on('mouseover', function(ev) {
				     
						if('cell' != ev.targetType) return;
			      	  
			      	  	var overCellElement = $(selectDataGrid.getElement(ev.rowKey, ev.columnName));    	  
			      	  	overCellElement.attr('title', overCellElement.text());
			        });
					
					selectDataGrid.on('scrollEnd', function() {
						
						if(scrollRightEndIdx > Math.ceil(selectGridData.length / perPage)) {
							return;
						}
						
						selectDataGrid.appendRows(selectGridData.slice(perPage * scrollRightEndIdx, perPage * (scrollRightEndIdx + 1)));
						scrollRightEndIdx += 1;
					});
					
					filterDetailModal.find('#addFilter').on('click', function() {
						
						var key = ('adapter' == modalType)? 'adapterId' : ('instance' == modalType)? 'instanceId' : '';
						
						var deduplicateData = selectDataGrid.getData().map(function(row){ return row[key] });
						
						var appendRows = (allDataGrid.store.data.checkedAllRows)? allGridData: allDataGrid.getCheckedRows().filter(function(row){ return deduplicateData.indexOf(row[key]) < 0 });
						
						appendRows = appendRows.map(function(row) {
							var obj = {};  
							obj[key] = row[key];
							return obj;
						});

						selectGridData = appendRows;
						
						appendRows.slice(0, perPage).forEach(function(row) {
							selectDataGrid.appendRow(row);
						});
						
						allDataGrid.uncheckAll();
						selectDataGrid.uncheckAll();
						selectDataGrid.refreshLayout();
					});
					
					filterDetailModal.find('#deleteFilter').on('click', function() {
						selectDataGrid.removeCheckedRows();
					});
					
					filterDetailModal.find('#selectFilterBtn').on('click', function() {
						
						if('adapter' == modalType) {
							adapterFilterData = selectDataGrid.getData();
							
							if(adapterFilterData.length == 0) {
								filterModal.find('[name=adapterFilterInput]').val('');
								filterModal.find('[name=adapterFilterInput]').removeAttr('title');
								return;
							}

							filterModal.find('[name=adapterFilterInput]').val(adapterFilterData[0].adapterId + ((selectDataGrid.getRowCount() > 1)? "( +" + String(selectDataGrid.getRowCount() - 1) + ")" : ""));
							
							var titleMsg = adapterFilterData.map(function(adapter){ return adapter.adapterId }).join(', ');
							filterModal.find('[name=adapterFilterInput]').attr('title', titleMsg);
						}
						
						if('instance' == modalType) {
							instanceFilterData = selectDataGrid.getData();
							
							if(instanceFilterData.length == 0) {
								filterModal.find('[name=instanceFilterInput]').val('');
								filterModal.find('[name=instanceFilterInput]').removeAttr('title');
								return;
							}
							
							filterModal.find('[name=instanceFilterInput]').val(instanceFilterData[0].instanceId + ((selectDataGrid.getRowCount() > 1)? "( +" + String(selectDataGrid.getRowCount() - 1) + ")" : ""));
						
							var titleMsg = instanceFilterData.map(function(instance){ return instance.instanceId }).join(', ');
							filterModal.find('[name=instanceFilterInput]').attr('title', titleMsg);
						}
					});
					
					filterDetailModal.find('#gridBtnArea').show();
				});	
					
				filterDetailModal.on('hidden.bs.modal', function () {
					filterDetailModal.remove();
					allDataGrid.destroy();
					selectDataGrid.destroy();
				});
					
				filterDetailModal.modal('show');
			}
		}
		
		function filterDrawData() {
			
			drawDataArr = saveDataArr.map(function(data) { 
				return cloneObject(data);
			})
			
			if(!(Object.keys(adapterFilterObj).length > 0 || Object.keys(instanceFilterObj).length > 0 || transactionFilter.length > 0)) return;
			
			drawDataArr = drawDataArr.filter(function(data) {
				var isAdapterFilter = (0 < Object.keys(adapterFilterObj).length)? adapterFilterObj[data.adapterId] : true;  
				
				var isInstanceFilter = (0 < Object.keys(instanceFilterObj).length)? instanceFilterObj[data.instanceId] : true;
				
				var isTransactionFilter = (0 < $.trim(transactionFilter).length)? $.trim(transactionFilter) == data.transactionId : true;
				
				return isAdapterFilter && isInstanceFilter && isTransactionFilter;
			});
		}
	}
	
	return new xViewChart();
}