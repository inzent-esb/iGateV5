$.fn.lineChart = function(createOptions) {
	
	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
	
    var chartDataArr = [];
    
    var darkmodeYn = createOptions.darkmodeYn;
    var itemId = createOptions.itemId;
    
    var fontColor = ('Y' === darkmodeYn)? '#ffffff' : '#151826';
    var filteredColor = ('Y' === darkmodeYn)? '#292e47' : '#ffffff';
    var axisLineColor = ('Y' == darkmodeYn)? '#666666' : '#f0f1f6';
    
	function lineChart() {
		
		initAppendTag();
		
		initLineChart();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpLineSkeleton").html());
		chartTag.find('.legend').hide();
	}
	
	function initLineChart() {
		
		var yAxisTickCount = 6;
		var yAxisTicksInfo = getYAxisTicksInfo(null, yAxisTickCount);
		var yAxisMaxValue = yAxisTicksInfo.maxValue;
		var yAxisStepSize = yAxisTicksInfo.stepSize;

		var xAxisMaxValue = Math.floor(Date.now() / 1000) * 1000;
		var xAxisMinValue = xAxisMaxValue - (lineChartTimeDuration * 60 * 1000);
		
		var ctx = chartTag.find('.graph').find('canvas')[0].getContext('2d');
		
		chartObj = new Chart(ctx, {
			type: 'line',
			data: {
				datasets: []
			},
			options: {
				legend: {
					display: false,
				},
				title: {
					display: false,
				},
			    animation: {
			        duration: 0,
			    },
		        hover: {
		        	mode: 'point',
		            animationDuration: 0
		        },
		        responsive: true,
		        maintainAspectRatio: false,
				responsiveAnimationDuration: 0,
				chartHoverLastEvt: null,
				onHover: function(evt) {
					this.options.chartHoverLastEvt = evt;
				},
				tooltips: {
		            enabled: false,
		            custom: function(tooltipModel) {
		            	
		            	chartTag.find('[name=chartjs-tooltip]').hide();
		            	
		                if('undefined' == typeof(tooltipModel.dataPoints)) {
		                	return;
		                }
		                
		                if(this._chart.options.chartHoverLastEvt.isTrusted) {
			            	var mousePos = getCanvasMousePos(this._chart.canvas, this._chart.options.chartHoverLastEvt);
			            	var mousePosX = mousePos.x;
			            	var mousePosY = mousePos.y;
			            	
				        	var chartArea = this._chart.chartArea;
				        	
				        	var left = chartArea.left;
				        	var right = chartArea.right;
				        	
			          		var xAxesMax = this._chart.config.options.scales.xAxes[0].ticks.max;
						    var xAxesMin = this._chart.config.options.scales.xAxes[0].ticks.min;
						    
						    var xCoorAlpha = (xAxesMax - xAxesMin) / (right - left);
						    	
						    var tmpTimeMillis = ((mousePosX - left) * xCoorAlpha) + xAxesMin;
						    
						    var tmpDataset = this._chart.data.datasets[tooltipModel.dataPoints[0].datasetIndex];
						    
						    var findDataObj = binanrySearch(tmpDataset.data, Math.floor(tmpTimeMillis / 1000) * 1000);
						    
						    if(!findDataObj)
						    	findDataObj = binanrySearch(tmpDataset.data, Math.floor((tmpTimeMillis - 1000) / 1000) * 1000);

						    if(!findDataObj)
						    	findDataObj = binanrySearch(tmpDataset.data, Math.floor((tmpTimeMillis + 1000) / 1000) * 1000);
						    
						    if(!findDataObj) {
						    	return;
						    }

						    if(null == findDataObj.dataInfo.y) 
						    	return;
						    
						    chartOptions.chartTooltipSync({
						    	standardTimeMillis: Math.floor(findDataObj.dataInfo.x / 1000) * 1000, 
						    	chartObj: chartObj, 
						    	datasetIndex: tooltipModel.dataPoints[0].datasetIndex,
						    	dataIndex: findDataObj.idx
						    });
		                }else {
		                	var standardTimeMillis = chartObj.data.datasets[tooltipModel.dataPoints[0].datasetIndex].data[tooltipModel.dataPoints[0].index].x;
		                	standardTimeMillis = Math.floor(standardTimeMillis / 1000) * 1000;
		                	
						    chartTag.find('[name=chartjs-tooltip]').empty();
						    chartTag.find('[name=chartjs-tooltip]').data('startTime', Date.now());
						    chartTag.find('[name=chartjs-tooltip]').append($("<div/>").text(moment(new Date(standardTimeMillis)).format('HH:mm:ss')));
						    
			                for(var i = 0; i < this._chart.data.datasets.length; i++) {
			                	var dataset = this._chart.data.datasets[i];
			                	
			                	var findDataObj = binanrySearch(dataset.data, standardTimeMillis);
			                	
			                	if(!findDataObj) continue;
			                	
			                	var name = escapeHtml(dataset.uniqueName);
			                	var value = convertValue(findDataObj.dataInfo.y, chartOptions.unitType, ('elapsed' == itemId)? ['ms', 's', 'm', 'h', 'd'] : null);
			                	
			                	chartTag.find('[name=chartjs-tooltip]').append(
			                			$("<div/>").append($("<div/>").width('10px').height('10px').css({'background-color': dataset.borderColor, 'display': 'inline-block', 'margin-right': '3px'})).append(name + " : " + value)
			                	);		                	
			                }
			                
			                chartTag.find('[name=chartjs-tooltip]').show();
			                
			                var position = this._chart.canvas.getBoundingClientRect();
			                
			                chartTag.find('[name=chartjs-tooltip]').css({
				                left: position.left + window.pageXOffset + tooltipModel.caretX + 10 + 'px',
				                top: position.top + window.pageYOffset + tooltipModel.caretY + 'px',
				                padding: tooltipModel.yPadding + 'px ' + tooltipModel.xPadding + 'px',
			                });			                
		                }
		            },
				},
				layout: {
					padding: {
						left: 25, 
						right: 30, 
						top: 20, 
						bottom: 30
					}
				},
				scales: {
					xAxes: [{
						display: false,
						type: 'time',
		                time: {
		                    unit: 'millisecond',
		                    stepSize: chartOptions.dataIntervalSeconds * 1000
		                },						
						ticks: {
							fontColor: fontColor,
							beginAtZero: false,
							min: xAxisMinValue,
							max: xAxisMaxValue,
							minRotation: 0,
							maxRotation: 0
						},
					}],
					yAxes: [{
						display: true,
						ticks: {
							fontColor: fontColor,
							beginAtZero: true,
							min: 0,
							max: yAxisMaxValue,
							stepSize: yAxisStepSize,
							maxTicksLimit: yAxisTickCount,
							minRotation: 0,
							maxRotation: 0,
							callback: function(value, index, values) {
								return convertValue(value, chartOptions.unitType, ('elapsed' == itemId)? ['ms', 's', 'm', 'h', 'd'] : null);
							}
						},
						gridLines: {
							color: axisLineColor,
							zeroLineColor: axisLineColor
						},						
					}]
				}
			},
			plugins: [
					 	{
					 		beforeDraw: function(chartObj, options) {
					 			
					 			var chartArea = chartObj.chartArea;
					        	
					        	var left = chartArea.left;
					        	var right = chartArea.right;
					        	
					        	var xAxesMax = chartObj.config.options.scales.xAxes[0].ticks.max;
					        	var xAxesMin = chartObj.config.options.scales.xAxes[0].ticks.min;
					        	
					        	var xCoorAlpha = (xAxesMax - xAxesMin) / (right - left);
					        	
					        	ctx.beginPath();
					        	
					        	ctx.strokeStyle = axisLineColor;
					        	
					        	ctx.font = '12px Arial';
					        	ctx.fillStyle = fontColor;
					        	ctx.textAlign = 'center';
					        	
					        	for(var i = 0; i < lineChartTimeDuration; i++) {
					        		
					        		var majorTickTime = (Math.floor(xAxesMin / (60 * 1000)) * (60 * 1000)) + ((i + 1) * 60 * 1000);
					        		var majorTickTimeXCoord = (majorTickTime - xAxesMin) / xCoorAlpha;
					        	
					        		ctx.moveTo(left + majorTickTimeXCoord, chartObj.chartArea.top);
					        		ctx.lineTo(left + majorTickTimeXCoord, chartObj.chartArea.bottom + 10);

						        	ctx.fillText(moment(new Date(majorTickTime)).format('HH : mm'), left + majorTickTimeXCoord, chartObj.chartArea.bottom + 20);			        		
					        	}
					        	
					        	ctx.stroke();
					        		
					        	ctx.closePath();
					 		}
					 	},
					 	{
					 		afterDraw: function(chartObj, options) {
							    
					 			var maxDataArr = [];
					 			
					 			chartObj.data.datasets.forEach(function(dataset) {
					 				var maxDataObj = {x: null, y: null};
					 				
					 				dataset.data.filter(function(o) { 
					 								return chartObj.config.options.scales.xAxes[0].ticks.min <= o.x && chartObj.config.options.scales.xAxes[0].ticks.max >= o.x; 
					 							})
					 							.forEach(function(dataObj) {
					 								if(null == maxDataObj.y || dataObj.y > maxDataObj.y) {
					 									maxDataObj.x = dataObj.x;
					 									maxDataObj.y = dataObj.y;
					 								}
					 							});

					 				if(null != maxDataObj.y)
					 					maxDataArr.push(maxDataObj)
					 			});
					 			
					 			if(0 == maxDataArr.length) return;
					 				
					 			var maxDataObj = {x: null, y: null};
					 			
					 			maxDataArr.forEach(function(dataObj) {
					 				if(null == maxDataObj.y || dataObj.y > maxDataObj.y) {
	 									maxDataObj.x = dataObj.x;
	 									maxDataObj.y = dataObj.y;
					 				}
					 			});
					 			
				          		var xAxesMax = chartObj.config.options.scales.xAxes[0].ticks.max;
							    var xAxesMin = chartObj.config.options.scales.xAxes[0].ticks.min;
							    var yAxesMax = chartObj.config.options.scales.yAxes[0].ticks.max;
							    var yAxesMin = chartObj.config.options.scales.yAxes[0].ticks.min;
					 			
					        	var chartArea = chartObj.chartArea;
					        	
					        	var left = chartArea.left;
					        	var right = chartArea.right;
					        	var top = chartArea.top;
					        	var bottom = chartArea.bottom;					 			
					 			
							    var xCoordAlpha = (xAxesMax - xAxesMin) / (right - left);
							    var yCoordAlpha = (yAxesMax - yAxesMin) / (bottom - top);
					        	
							    var xCoord = left + ((maxDataObj.x - xAxesMin) / xCoordAlpha);
							    var yCoord = top + ((bottom - top) - ((maxDataObj.y - yAxesMin) / yCoordAlpha));
							    
							    ctx.beginPath();

							    ctx.save();
							    ctx.strokeStyle = axisLineColor;
							    ctx.setLineDash([2, 2]);
							    ctx.moveTo(xCoord, top - 8);
							    ctx.lineTo(xCoord, bottom);
							    ctx.lineWidth = 2;
							    ctx.stroke();

					        	ctx.font = '9px Arial';
					        	ctx.fillStyle = fontColor;
					        	ctx.textAlign = 'center';
					        	ctx.fillText('Max:' + convertValue(maxDataObj.y, chartOptions.unitType, ('elapsed' == itemId)? ['ms', 's', 'm', 'h', 'd'] : null), xCoord, top - 8);
					        	ctx.restore();
					        	
					        	ctx.closePath();
					 		}
					 	}
					  ]
		});		
	}
	
	function initFunc() {

		this.addTarget = function(targetObj) {
			chartObj.data.datasets.push({
				uniqueKey: targetObj.targetId,
				uniqueName: targetObj.targetName,
				color: targetObj.color,
				label: targetObj.targetId,
				backgroundColor: Chart.helpers.color(targetObj.color).alpha(0.5).rgbString(),
				borderColor: targetObj.color,
				borderWidth: 2,
				fill: false,
				pointRadius: 1,
				data: [],				
			});
		}
		
		this.updateTarget = function(targetId, updateOption) {
			chartObj.data.datasets.forEach(function(seriesOption, index) {
				if(seriesOption.uniqueKey != targetId) return;
				
				seriesOption.color = updateOption.color;
				seriesOption.backgroundColor = Chart.helpers.color(updateOption.color).alpha(0.5).rgbString();
				seriesOption.borderColor = updateOption.color;
			});
		}
		
		this.deleteTarget = function(targetId) {
			chartObj.data.datasets.forEach(function(seriesInfo, index) {
				if(seriesInfo.uniqueKey == targetId) 
					chartObj.data.datasets.splice(index, 1);
			});
		};
		
		this.deleteTargetAll = function() {
			chartObj.data.datasets = [];
			chartTag.find('.legend').empty();
		};
		
		this.addData = function(dataArr) {
			chartDataArr = chartDataArr.concat(dataArr);
		};		
		
		this.setInterval = function(standardTime) {
			
			//x축
			var xAxisMaxValue = Math.floor(standardTime / 1000) * 1000;			
			var xAxisMinValue = xAxisMaxValue - (lineChartTimeDuration * 60 * 1000);	
			
			chartObj.options.scales.xAxes[0].ticks.min = xAxisMinValue;
			chartObj.options.scales.xAxes[0].ticks.max = xAxisMaxValue;	
			
			//y축
			chartObj.data.datasets.forEach(function(dataset) {
				for(var i = 0; i < chartDataArr.length; i++) {
					
					var chartData = chartDataArr[i];
					
					if(dataset.uniqueKey != chartData.targetId) continue;
					
					if(0 < dataset.data.length && lineChartDrawDataCycle < chartData.x - dataset.data[dataset.data.length - 1].x) {
						dataset.data.push({x: chartData.x - ((chartData.x - dataset.data[dataset.data.length - 1].x) / 2), y: null});
					}
					
					dataset.data.push({x: chartData.x, y: chartData.y});
				}
			});
			
			chartDataArr = [];
			
			var tmpMaxValue = 0;
			
			chartObj.data.datasets.forEach(function(dataset) {
				var seriesMaxValue = Math.max.apply(Math, 
						dataset.data.filter(function(o) {
							return xAxisMinValue <= o.x && xAxisMaxValue >= o.x;
						}).map(function(o) { 
							return o.y; 
						})
				);

				if(seriesMaxValue > tmpMaxValue) 
					tmpMaxValue = seriesMaxValue;  
			});

			var yAxisTickCount = 6;
			var yAxisTicksInfo = getYAxisTicksInfo(tmpMaxValue, yAxisTickCount);
			var yAxisMaxValue = yAxisTicksInfo.maxValue;
			var yAxisStepSize = yAxisTicksInfo.stepSize;
			
			chartObj.options.scales.yAxes[0].ticks.max = yAxisMaxValue;
			chartObj.options.scales.yAxes[0].ticks.stepSize = yAxisStepSize;
			chartObj.options.scales.yAxes[0].ticks.maxTicksLimit = yAxisTickCount;
			
			//차트 update
			chartObj.update();
			
			//data 정리
			chartObj.data.datasets.forEach(function(dataset) {
				dataset.data = dataset.data.filter(function(obj) {
					return xAxisMinValue - (60  * 1000) < obj.x;
				});
			});
			
			if(3000 < Date.now() - chartTag.find('[name=chartjs-tooltip]').data('startTime')) {
				chartTag.find('[name=chartjs-tooltip]').hide();
			}
		};
		
		this.filterData = function(targetId, isFiltered) {
			var selectedTarget = null;
			
			for(var i = 0; i < chartObj.data.datasets.length; i++) {
				if(targetId == chartObj.data.datasets[i].uniqueKey) {
					selectedTarget = chartObj.data.datasets[i];
					break;
				}
			}
			
			if(null == selectedTarget) return;
			
			if(isFiltered) {
				selectedTarget.backgroundColor = Chart.helpers.color(filteredColor).alpha(0.5).rgbString(),
				selectedTarget.borderColor = filteredColor;					
			}else {
				selectedTarget.backgroundColor = Chart.helpers.color(selectedTarget.color).alpha(0.5).rgbString(),
				selectedTarget.borderColor = selectedTarget.color;					
			}
			
			chartObj.update();
		};
		
		this.unload = function() {
			if(chartObj)
				chartObj.destroy();
		};
		
		this.downloadExportStart = function(pCsvFileName) {

			startSpinner();
			
			var xAxisMinValue = chartObj.options.scales.xAxes[0].ticks.min;
			var xAxisMaxValue = chartObj.options.scales.xAxes[0].ticks.max;
			
			var headerData = '';
			var bodyData = '';
			
			chartObj.data.datasets.forEach(function(dataset) {
				headerData += ',' + dataset.uniqueName;
			});
			
			var exportDataObj = {};
			
			chartObj.data.datasets.forEach(function(dataset) {
				for(var i = 0; i < dataset.data.length; i++) {
					
					var data = dataset.data[i];
					
					if(xAxisMinValue > data.x) continue;
					
					if(xAxisMaxValue < data.x) continue;
					
					var timeStamp = Math.floor(data.x / 1000) * 1000;
					
					if(exportDataObj[timeStamp]) continue; 

					exportDataObj[timeStamp] = [];
				}
			});
			
			for(var key in exportDataObj) {
				chartObj.data.datasets.forEach(function(dataset) {
					exportDataObj[key].push('');
				});
			}
			
			chartObj.data.datasets.forEach(function(dataset, datasetIdx) {
				for(var i = 0; i < dataset.data.length; i++) {
					
					var data = dataset.data[i];
					
					if(xAxisMinValue > data.x) continue;
					
					if(xAxisMaxValue < data.x) continue;
					
					var timeStamp = Math.floor(data.x / 1000) * 1000;
					
					exportDataObj[timeStamp][datasetIdx] = data.y;
				}
			});
			
			for(var key in exportDataObj) {
				bodyData += moment(new Date(Number(key))).format('HH:mm:ss') + ',' + exportDataObj[key].join(',') + ',';
			}
			
			downloadExcel({ 
				'type'       : 'line',  
				'fileName'   : pCsvFileName, 
				'headerData' : headerData,  
				'bodyData'   : bodyData, 
				'conditionData': 'targetType:'+ chartOptions.typeList.targetType + ((chartOptions.typeList.inputType)? ',inputType:' + chartOptions.typeList.inputType : '')
			});
			
			stopSpinner();
		};
		
		this.draw = function() {
			chartObj.update();
			
			chartTag.find('.legend').empty();
			
			if('Y' == chartOptions.remarkYn) {
				chartObj.data.datasets.forEach(function(dataset) {
					chartTag.find('.legend').append(
						$('<span/>').addClass('status').append($("<i/>").addClass('dot').css({'background-color': dataset.borderColor})).append($("<span/>").text(dataset.uniqueName))
					)
				});
				
				chartTag.find('.legend').show();
			}
		};
		
		this.getChartObj = function() {
			return chartObj; 
		};
	}
	
	return new lineChart();
}