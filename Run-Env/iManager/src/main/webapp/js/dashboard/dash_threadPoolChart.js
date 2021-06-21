$.fn.threadPoolChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var targetInfoList = [];
    
	function threadPoolChart() {
	
		initAppendTag();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpThreadPoolSummarySkeleton").html());
		
		if('Y' == chartOptions.remarkYn) chartTag.find('.d-flex-space').show();
		else							 chartTag.find('.d-flex-space').hide();
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
				
				var statusClass = "";
								
				if('Normal' == dataInfo.status)    		statusClass = "bg-normal";
				if('Warn' == dataInfo.status)   		statusClass = "bg-warn";
				else								    statusClass = "bg-normal";
				
				targetInfo.element.find('[name=instanceStatus]').removeClass().addClass('status').addClass(statusClass);
				targetInfo.element.find('[name=instanceActiveThreadGraph]').width((((dataInfo.threadActive / (dataInfo.threadActive + dataInfo.threadIdle)) * 100) || 0).toFixed(2) + '%');
				targetInfo.element.find('[name=instanceActiveThreadNum]').text(dataInfo.threadActive);
				targetInfo.element.find('[name=instanceIdleThreadGraph]').width((((dataInfo.threadIdle / (dataInfo.threadActive + dataInfo.threadIdle)) * 100) || 0).toFixed(2) + '%');
				targetInfo.element.find('[name=instanceIdleThreadNum]').text(dataInfo.threadIdle);
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
			$(chartTag).find('.col-6').empty();
			
			targetInfoList.forEach(function(targetInfo, index) {
				
				var element = $($("#tmpThreadPoolSummaryContent").html());
				
				$(chartTag.find('.col-6')[index % 2]).append(element);
				
				targetInfo.element = element;
				
				element.find('[name=instanceId]').css({'cursor': 'pointer'}).attr('title', targetInfo.targetId).data('targetId', targetInfo.targetId).text(targetInfo.targetId);
				element.find('[name=instanceActiveThreadGraph]').width('0%');
				element.find('[name=instanceActiveThreadNum]').text('0');
				element.find('[name=instanceIdleThreadGraph]').width('0%');
				element.find('[name=instanceIdleThreadNum]').text('0');
			});
			
			initEvtChartBind();
		}
	}
	
	function initEvtChartBind() {
		chartTag.find('[name=instanceId]').on('click', function() {
			chartOptions.componentFilterDataFunc($(this).data('targetId'));
		});
	}	

	return new threadPoolChart();
}