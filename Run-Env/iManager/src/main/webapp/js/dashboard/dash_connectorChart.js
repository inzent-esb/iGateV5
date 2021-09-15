$.fn.connectorChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var targetInfoList = [];
    
	function connectorChart() {
	
		initAppendTag();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpConnectorSummarySkeleton").html());
		
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
				
				if('Normal' == dataInfo.status)     		statusClass = "bg-normal";
				else if('Warn' == dataInfo.status)   		statusClass = "bg-warn";
				else if('Error' == dataInfo.status)			statusClass = "bg-cht-1";
				else if('Fail' == dataInfo.status)			statusClass = "bg-danger";
				else if('Starting' == dataInfo.status)		statusClass = "bg-cht-2";
				else if('Stoping' == dataInfo.status)		statusClass = "bg-cht-3";
				else if('Blocking' == dataInfo.status)		statusClass = "bg-cht-4";
				else if('Down' == dataInfo.status)			statusClass = "bg-down";
				else										statusClass = "bg-danger";		
				
				targetInfo.element.find('[name=instanceStatus]').removeClass().addClass('status').addClass(statusClass);
				targetInfo.element.find('[name=instanceActiveSessionInuseGraph]').width((((dataInfo.sessionInuse / (dataInfo.sessionInuse + dataInfo.sessionWait)) * 100) || 0).toFixed(2) + '%');
				targetInfo.element.find('[name=instanceActiveSessionInuseNum]').text(dataInfo.sessionInuse);
				targetInfo.element.find('[name=instanceSessionWaitGraph]').width((((dataInfo.sessionWait / (dataInfo.sessionInuse + dataInfo.sessionWait)) * 100)|| 0).toFixed(2) + '%'|| 0);
				targetInfo.element.find('[name=instanceSessionWaitNum]').text(dataInfo.sessionWait);				
				targetInfo.element.find('[name=instanceThreadInuseGraph]').width((((dataInfo.threadInuse / (dataInfo.threadInuse + dataInfo.threadWait)) * 100)|| 0).toFixed(2) + '%' || 0);
				targetInfo.element.find('[name=instanceThreadInuseNum]').text(dataInfo.threadInuse);
				targetInfo.element.find('[name=instanceThreadWaitGraph]').width((((dataInfo.threadWait / (dataInfo.threadInuse + dataInfo.threadWait)) * 100)|| 0).toFixed(2) + '%' || 0);
				targetInfo.element.find('[name=instanceThreadWaitNum]').text(dataInfo.threadWait);				
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
				
				var element = $($("#tmpConnectorSummaryContent").html());
				
				$(chartTag.find('.col-6')[index % 2]).append(element);
				
				targetInfo.element = element;
				
				element.find('[name=instanceId]').css({'cursor': 'pointer'}).attr('title', targetInfo.targetId).data('targetId', targetInfo.targetId).text(targetInfo.targetId);
				element.find('[name=instanceActiveSessionInuseGraph]').width('0%');
				element.find('[name=instanceActiveSessionInuseNum]').text('0');
				element.find('[name=instanceSessionWaitGraph]').width('0%');
				element.find('[name=instanceSessionWaitNum]').text('0');
				element.find('[name=instanceThreadInuseGraph]').width('0%');
				element.find('[name=instanceThreadInuseNum]').text('0');
				element.find('[name=instanceThreadWaitGraph]').width('0%');
				element.find('[name=instanceThreadWaitNum]').text('0');
			});
			
			initEvtChartBind();
		}
	}
	
	function initEvtChartBind() {
		chartTag.find('[name=instanceId]').off('click').on('click', function() {
			chartOptions.componentFilterDataFunc($(this).data('targetId'));
		});
	}	

	return new connectorChart();
}