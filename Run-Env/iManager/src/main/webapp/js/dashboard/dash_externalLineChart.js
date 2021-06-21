$.fn.externalLineChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    delete chartOptions['chartTag'];
    
    var chartObj = null;
    
    var chartDataArr = [];
    
    var targetInfoList = [];
    
	function externalLineChart() {
	
		initAppendTag();
		
		initFunc.call(this);
	}
	
	function initAppendTag() {
		chartTag.append($("#tmpExternalLine").html());
		
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
					return targetInfo.targetId == dataInfo.externalLineId; 
				})[0];
				
				if(!targetInfo) return;
					
				var statusClass = "";
				
				if('Normal' == dataInfo.status)    			statusClass = "bg-normal";
				else if('Warn' == dataInfo.status)   		statusClass = "bg-warn";
				else if('Error' == dataInfo.status)   		statusClass = "bg-cht-1";
				else if('Fatal' == dataInfo.status)   		statusClass = "bg-danger";
				else if('Down' == dataInfo.status)   		statusClass = "bg-down";
				else								    	statusClass = "bg-normal";
				
				targetInfo.element.find('[name=externalLineStatus]').removeClass().addClass('status').addClass(statusClass);
				targetInfo.element.find('[name=externalLineName]').text(dataInfo.externalLineName+ " ("+dataInfo.active+"/"+dataInfo.total+")");				
			});
		};	
		
		this.draw = function() {
			$(chartTag).find('.row-label').empty();
			
			targetInfoList.forEach(function(targetInfo, index) {

				var element = $($("#tmpExternalLineContent").html());					
				
				targetInfo.element = element;	
				
				$(chartTag.find('.row-label')).append(element);		
				
				element.find('[name=externalLineStatus]').removeClass().addClass('status').addClass("bg-down");
				element.find('[name=externalLineName]').text("Loading...");
			});
		};
	}

	return new externalLineChart();
}