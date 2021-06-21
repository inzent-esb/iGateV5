self.onmessage = function(e) {
	
	var data = e.data;
	
	var dataArr = data.dataArr;
	var startFilterTime = data.startFilterTime;
	var endFilterTime = data.endFilterTime; 
	var startFilterValue = data.startFilterValue;
	var endFilterValue = data.endFilterValue;
	var yAxisMaxValue = data.yAxisMaxValue;

	var filterDataArr = dataArr.filter(function(data) {
		if(yAxisMaxValue < endFilterValue) return startFilterTime <= data.x && endFilterTime >= data.x && startFilterValue <= data.y;	
		else							   return startFilterTime <= data.x && endFilterTime >= data.x && startFilterValue <= data.y && endFilterValue >= data.y;
	});	
	
	if(Object.keys(data.adapterFilterObj).length > 0 || Object.keys(data.instanceFilterObj).length > 0 || data.transactionFilter.length > 0) {
		filterDataArr = filterDataArr.filter(function(filterData) {
			var isAdapterFilter = (0 < Object.keys(data.adapterFilterObj).length)? data.adapterFilterObj[filterData.adapterId] : true;  
			
			var isInstanceFilter = (0 < Object.keys(data.instanceFilterObj).length)? data.instanceFilterObj[filterData.instanceId] : true;
			
			var isTransactionFilter = (0 < data.transactionFilter.length)? data.transactionFilter == filterData.transactionId : true;
			
			return isAdapterFilter && isInstanceFilter && isTransactionFilter;
		});
	}
	
	if(data.isSort) {
		filterDataArr.sort(function(a, b) { 
			return b.y - a.y;
		});
	}
	
	var rtnObj = {
		mod: data.mod,
		dataArr: filterDataArr	
	};
	
	if ('export' == rtnObj.mod) {
		rtnObj.csvFileName = data.csvFileName;
	}
	
	postMessage(rtnObj);
};