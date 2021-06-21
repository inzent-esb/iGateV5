$.fn.queueChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var targetInfoList = [];
    
	function queueChart() {
	
		initAppendTag();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpQueueSummarySkeleton").html());
		
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
		
		this.deleteTargetAll = function() {
			targetInfoList = [];
			$(chartTag).find('.col-6').empty();
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
				targetInfo.element.find('[name=instanceMessageGraph]').width((((dataInfo.messageCount / (dataInfo.messageCount + dataInfo.consumerCount)) * 100) || 0).toFixed(2) + '%');
				targetInfo.element.find('[name=instanceMessageNum]').text(dataInfo.messageCount);
				targetInfo.element.find('[name=instanceConsumerGraph]').width((((dataInfo.consumerCount / (dataInfo.messageCount + dataInfo.consumerCount)) * 100) || 0).toFixed(2) + '%');
				targetInfo.element.find('[name=instanceConsumerNum]').text(dataInfo.consumerCount);

				if('Y' == dataInfo.messageWarningYn) targetInfo.element.find('[name=messageWarning]').show();
				else								 targetInfo.element.find('[name=messageWarning]').hide();		
				
				if('Y' == dataInfo.consumerWarningYn) targetInfo.element.find('[name=consumerWarning]').show();
				else 								  targetInfo.element.find('[name=consumerWarning]').hide();
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
				
				var element = $($("#tmpQueueSummaryContent").html());
				
				$(chartTag.find('.col-6')[index % 2]).append(element);
				
				targetInfo.element = element;
				
				element.find('[name=instanceId]').css({'cursor': 'pointer'}).attr('title', targetInfo.targetId).data('targetId', targetInfo.targetId).text(targetInfo.targetId);
				element.find('[name=instanceMessageGraph]').width('0%');
				element.find('[name=instanceMessageNum]').text('0');
				element.find('[name=instanceConsumerGraph]').width('0%');
				element.find('[name=instanceConsumerNum]').text('0');

			});
			
			initEvtChartBind();
		};
	}
	
	function initEvtChartBind() {
		chartTag.find('[name=instanceId]').off('click').on('click', function() {
			chartOptions.componentFilterDataFunc($(this).data('targetId'));
		});
	}

	return new queueChart();
}