$.fn.instanceChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var componentId = chartOptions.componentId;
    var instanceSummaryColCnt = (null == localStorage.getItem('instanceSummaryColCnt_' + componentId))? instanceSummaryDefaultColCnt : localStorage.getItem('instanceSummaryColCnt_' + componentId);
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var targetInfoList = [];
    
	function instanceChart() {
	
		initAppendTag();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpInstanceSummary").html());

		for(var i = 0; i < instanceSummaryColCnt; i++) {
			chartTag.find('.row').append($("<div/>").addClass('col').height('100%').width((100 / instanceSummaryColCnt) + '%'));
		}
		
		if('Y' == chartOptions.remarkYn) chartTag.find('.legend').show();
		else							 chartTag.find('.legend').hide();
	}	
	
	function initFunc() {
		
		this.addTarget = function(targetObj) {
			targetInfoList.push(targetObj);
		};
		
		this.deleteTarget = function(targetId) {
			var findIndex = targetInfoList.map(function(targetInfo) { return targetInfo.targetId; }).indexOf(targetId);

			if(-1 == findIndex) return;
			
			targetInfoList[findIndex].element.remove();
			targetInfoList.splice(findIndex, 1);
		};
				
		this.addData = function(dataArr) {
			dataArr.forEach(function(dataInfo) {
				var targetInfo = targetInfoList.filter(function(targetInfo) {
					return targetInfo.targetId == dataInfo.instanceId; 
				})[0];
				
				if(!targetInfo) return;
				
				targetInfo.element.find('[name=instanceCpuGraph]').height(Math.ceil(dataInfo.cpuUsage) + '%');
				targetInfo.element.find('[name=instanceCpuGraph]').attr('title',Math.ceil(dataInfo.cpuUsage) + '%');
				targetInfo.element.find('[name=instanceCpu]').text(Math.ceil(dataInfo.cpuUsage) + '%');
				targetInfo.element.find('[name=instanceMemoryGraph]').height(Math.ceil(dataInfo.heapUsage) + '%');
				targetInfo.element.find('[name=instanceMemoryGraph]').attr('title',Math.ceil(dataInfo.heapUsage) + '%');
				targetInfo.element.find('[name=instanceMemory]').text(Math.ceil(dataInfo.heapUsage) + '%');
				targetInfo.element.find('[name=instanceDiskGraph1]').height(Math.ceil(dataInfo.fileMainUsage) + '%');
				targetInfo.element.find('[name=instanceDiskGraph1]').attr('title',Math.ceil(dataInfo.fileMainUsage) + '%');
				targetInfo.element.find('[name=instanceDisk1]').text(Math.ceil(dataInfo.fileMainUsage) + '%');
				targetInfo.element.find('[name=instanceDiskGraph2]').height(Math.ceil(dataInfo.fileQueueUsage) + '%');
				targetInfo.element.find('[name=instanceDiskGraph2]').attr('title',Math.ceil(dataInfo.fileQueueUsage) + '%');
				targetInfo.element.find('[name=instanceDisk2]').text(Math.ceil(dataInfo.fileQueueUsage) + '%');
			});
		};
		
		this.filterData = function(targetId, isFiltered) {
			var filterTargetInfoList = targetInfoList.filter(function(targetInfo) {
				return targetInfo.targetId == targetId; 
			});
			
			if(0 == filterTargetInfoList.length) return;
			
			filterTargetInfoList[0].element.css({'opacity': (isFiltered)? '0.2' : '1.0'});
		};
		
		this.draw = function() {

			$(chartTag).find('.col').empty();
			
			targetInfoList.forEach(function(targetInfo, index) {
				
				var element = $($("#tmpInstanceSummaryContent").html());
				
				$(chartTag.find('.col')[index % instanceSummaryColCnt]).append(element);
				
				targetInfo.element = element;					
				
				element.find('[name=instanceId]').css({'cursor': 'pointer'}).data('targetId', targetInfo.targetId).text(targetInfo.targetId);
				element.find('[name=instanceCpuGraph]').height('0%');
				element.find('[name=instanceCpuGraph]').attr('title','0%');
				element.find('[name=instanceCpu]').text('0%');
				element.find('[name=instanceMemoryGraph]').height('0%');
				element.find('[name=instanceMemoryGraph]').attr('title','0%');
				element.find('[name=instanceMemory]').text('0%');
				element.find('[name=instanceDiskGraph1]').height('0%');
				element.find('[name=instanceDiskGraph1]').attr('title','0%');
				element.find('[name=instanceDisk1]').text('0%');
				element.find('[name=instanceDiskGraph2]').height('0%');
				element.find('[name=instanceDiskGraph2]').attr('title','0%');
				element.find('[name=instanceDisk2]').text('0%');
			});
			
			initEvtChartBind();
		}
	}
	
	function initEvtChartBind() {
		chartTag.find('[name=instanceId]').off('click').on('click', function() {
			chartOptions.componentFilterDataFunc($(this).data('targetId'));
		});
	}

	return new instanceChart();
}