$.fn.columnChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var darkmodeYn = createOptions.darkmodeYn;
    var itemId = createOptions.itemId;
    var isUseClickEvt = createOptions.isUseClickEvt;
    var componentFilterDataFunc = createOptions.componentFilterDataFunc;
    
    var fontColor = ('Y' === darkmodeYn)? '#ffffff' : '#151826';
    var filteredColor = ('Y' === darkmodeYn)? '#292e47' : '#ffffff';
    var axisLineColor = ('Y' == darkmodeYn)? '#666666' : '#f0f1f6';
    
	function columnChart() {
	
		initAppendTag();
	
		initColumnChart();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("<canvas/>"));
	}	
	
	function initColumnChart() {
		
		var yAxisTickCount = 6;
		var yAxisTicksInfo = getYAxisTicksInfo(null, yAxisTickCount);
		var yAxisMaxValue = yAxisTicksInfo.maxValue;
		var yAxisStepSize = yAxisTicksInfo.stepSize;
		
		var ctx = chartTag.find('canvas')[0].getContext('2d');
		
		chartObj = new Chart(ctx, {
			type: 'bar',
			data: {
				targetInfoList: [],
				labels: [],
				datasets: [
					{
						label: '',
						backgroundColor: [], 
						borderColor: [],
						borderWidth: 1,
						data: [],
					}
				]				
			},
			options: {
				onHover: function(evt) {
					if(!isUseClickEvt) return;
					
					var hoverPos = getCanvasMousePos(this.ctx.canvas, evt);
					
					var isPointer = false;
					
					var chartInstance = this.chart;
					
		            this.data.datasets.forEach(function (dataset, i) {
		                chartInstance.controller.getDatasetMeta(i).data.forEach(function (bar, index) {
		                	var startX = bar._model.x - (bar._model.width / 2);
		                	var endX = startX + bar._model.width;
		                	
		                	var startY = 0;
		                	var endY = bar._chart.height;
		                	
		                	if(startX <= hoverPos.x && endX >= hoverPos.x && 0 <= hoverPos.y && bar._chart.height >= hoverPos.y){
		                		isPointer = true;
		                	}
		                });
		            });
		            
		            chartInstance.canvas.style.cursor = (isPointer)? 'pointer' : 'default';
				},
				onClick: function(evt) {
					if(!isUseClickEvt) return;
					
					var clickedPos = getCanvasMousePos(this.ctx.canvas, evt);

					var chartInstance = this.chart;
					
		            this.data.datasets.forEach(function (dataset, i) {
		                chartInstance.controller.getDatasetMeta(i).data.forEach(function (bar, index) {
		                	var startX = bar._model.x - (bar._model.width / 2);
		                	var endX = startX + bar._model.width;
		                	
		                	var startY = 0;
		                	var endY = bar._chart.height;
		                	
		                	if(startX <= clickedPos.x && endX >= clickedPos.x && 0 <= clickedPos.y && bar._chart.height >= clickedPos.y) {
		                		componentFilterDataFunc(chartObj.data.targetInfoList[bar._index].targetId);
		                	}
		                });
		            });
				},
				legend: {
					display: false,
				},
				title: {
					display: false,
				},
				animation: {
					duration: 1,
			        onComplete: function () {
			            
			        	var chartInstance = this.chart;
			            
			        	ctx.beginPath();
			        	
			            ctx.textAlign = 'center';
			            
			            this.data.datasets.forEach(function (dataset, i) {
			                chartInstance.controller.getDatasetMeta(i).data.forEach(function (bar, index) {
			                	ctx.fillStyle = fontColor;
			                    ctx.fillText(convertValue(dataset.data[index], chartOptions.unitType, ('elapsed' == itemId)? ['ms', 's', 'm', 'h', 'd'] : null), bar._model.x, bar._model.y - 5);
			                    
			                    if(chartObj.data.targetInfoList[index].isFiltered) {
				                    ctx.fillStyle = Chart.helpers.color(filteredColor).alpha(0.8).rgbString();
				                    ctx.fillRect(bar._model.x - (bar._model.width / 2), 0, bar._model.width, bar._chart.height);			                    	
			                    }
			                });
			            });
			        }
				},
		        hover: {
		            animationDuration: 0
		        },				
				responsive: true,
				maintainAspectRatio: false,
				responsiveAnimationDuration: 0,
				tooltips: {
					enabled: false
				},				
				layout: {
					padding: {
						left: 25, 
						right: 30, 
						top: 20, 
						bottom: 5
					}
				},
				scales: {
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
					}],
					xAxes: [{
						ticks: {
							fontColor: fontColor
						}
					}]
				}
			}
		});		
	}
	
	function initFunc() {
		
		this.addTarget = function(targetObj) {
			chartObj.data.targetInfoList.push({targetId: targetObj.targetId, isFiltered: false, color: targetObj.color});
			chartObj.data.labels.push(targetObj.targetName);
			chartObj.data.datasets[0].backgroundColor.push(Chart.helpers.color(targetObj.color).alpha(0.6).rgbString());
			chartObj.data.datasets[0].borderColor.push(targetObj.color);
		}
		
		this.updateTarget = function(targetId, updateOption) {
			var updateIdx = null;
			
			for(var i = 0; i < chartObj.data.targetInfoList.length; i++) {
				if(targetId == chartObj.data.targetInfoList[i].targetId) {
					updateIdx = i;
					break;
				}
			}
			
			if(null == updateIdx) return;
			
			chartObj.data.targetInfoList[updateIdx].color = updateOption.color;
			chartObj.data.datasets[0].backgroundColor[updateIdx] = Chart.helpers.color(updateOption.color).alpha(0.6).rgbString();
			chartObj.data.datasets[0].borderColor[updateIdx] = updateOption.color;
		}
		
		this.deleteTarget = function(targetId) {
			var deleteIdx = null;
			
			for(var i = 0; i < chartObj.data.targetInfoList.length; i++) {
				if(targetId == chartObj.data.targetInfoList[i].targetId) {
					deleteIdx = i;
					break;
				}
			}
			
			if(null == deleteIdx) return;
			
			chartObj.data.targetInfoList.splice(deleteIdx, 1);
			chartObj.data.labels.splice(deleteIdx, 1);
			chartObj.data.datasets[0].backgroundColor.splice(deleteIdx, 1);
			chartObj.data.datasets[0].borderColor.splice(deleteIdx, 1);
			chartDataArr.splice(deleteIdx, 1);
			chartObj.data.datasets[0].data.splice(deleteIdx, 1);
		};
		
		this.deleteTargetAll = function() {
			chartObj.data.targetInfoList = [];
			chartObj.data.labels = [];
			chartObj.data.datasets[0].backgroundColor = [];
			chartObj.data.datasets[0].borderColor = [];
			chartDataArr = [];
			chartObj.data.datasets[0].data = [];
		};
		
		this.addData = function(dataArr) {
			chartDataArr = dataArr;
		}
		
		this.setInterval = function(standardTime) {
			
			if(0 == chartDataArr.length) return;
			
			var tmpData = [];
			
			chartObj.data.targetInfoList.forEach(function(targetInfo) {
				
				var targetId = targetInfo.targetId;
				
				var tmpChartDataArr = chartDataArr.filter(function(chartData) { return chartData.targetId == targetId; });
				
				tmpData.push((0 < tmpChartDataArr.length)? tmpChartDataArr[0].y : null);
			});
			
			chartObj.data.datasets[0].data = tmpData;
			
			var currentMaxValue = Math.max.apply(null, chartDataArr.map(function(chartData) { return chartData.y; }));
			
			var yAxisTickCount = 6;
			var yAxisTicksInfo = getYAxisTicksInfo(currentMaxValue, yAxisTickCount);
			var yAxisMaxValue = yAxisTicksInfo.maxValue;
			var yAxisStepSize = yAxisTicksInfo.stepSize;			
			
			chartObj.options.scales.yAxes[0].ticks.max = yAxisMaxValue;
			chartObj.options.scales.yAxes[0].ticks.stepSize = yAxisStepSize;
			chartObj.options.scales.yAxes[0].ticks.maxTicksLimit = yAxisTickCount;
			
			chartObj.update();
			
			chartDataArr = [];
		};
		
		this.filterData = function(targetId, isFiltered) { 
			var selectedTarget = null;
			
			for(var i = 0; i < chartObj.data.targetInfoList.length; i++) {
				if(chartObj.data.targetInfoList[i].targetId == targetId) {
					selectedTarget = chartObj.data.targetInfoList[i];
					break;
				}
			}
			
			if(null == selectedTarget) return;
			
			selectedTarget.isFiltered = isFiltered; 
			
			chartObj.update();
		};
		
		this.unload = function() {
			if(chartObj)
				chartObj.destroy();
		};
		
		this.draw = function() {
			chartObj.update();
		}
	}

	return new columnChart();
}