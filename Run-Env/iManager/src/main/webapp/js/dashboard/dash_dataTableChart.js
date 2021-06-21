$.fn.dataTableChart = function(createOptions) {

	var chartOptions = createOptions;
	
    var chartTag = chartOptions.chartTag;
    
    var dataTableGrid = null;
    
    var originWidth = null;
    
    delete chartOptions['chartTag'];
   
    var componentId = chartOptions.componentId;
    var datatableRowCnt = (null == localStorage.getItem('datatableRowCnt_' + componentId))? datatableDefaultRowCnt : localStorage.getItem('datatableRowCnt_' + componentId);
    
	function dataTableChart() {
		
		initAppendTag();
	
		initFunc.call(this);
	}
	
	function initAppendTag() {
		
		$(chartTag).css({'overflow-y': 'auto'});
		
		chartTag.append($("#tmpDataTable").html());
		
		var settings = {
			el : chartTag.find('.datatable')[0],
			data: null,
			columns : [
						{
							name : "status",		 	
							header : dashboardGrid_status,	
							width: '5%',	
							align : "center",
							formatter: function(obj) {
								if('M' == obj.value) 		return '<span style="color: #ffc107">'+ dashboardLabel_warn +'</span>';
								else if('L' == obj.value)   return '<span style="color: #ed3137">'+ dashboardLabel_serious +'</span>';
								else 						return '<span style="color: #28a745">'+ dashboardLabel_success +'</span>'; 
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
							width: '15%'
						},
						{
							name : "transactionName", 	 
							header : dashboardGrid_transactionName,
							width: '15%'
						},
						{
							name : "adapterId", 		 
							header : dashboardGrid_adapterId,
							width: '15%'
						},
						{
							name : "instanceId", 		 
							header : dashboardGrid_instanceId,
							width: '10%',
						},
						{
							name : "snapshotTimestamp", 
							header : dashboardGrid_snapshotTimestamp,   
							width: '15%',
							align : "center",
							formatter: function(obj) {
								return moment(new Date(obj.value)).format('HH:mm:ss');
							}
						},
					  ],
			columnOptions : {
				resizable : true
			},
			usageStatistics : false,
			header: {
				height: 30,
				align: 'center'
			},
			onGridMounted : function() {
	        	var resetColumnWidths = [];
	        	
	        	dataTableGrid.getColumns().forEach(function(columnInfo) {
	        		if(!columnInfo.copyOptions) return;

	        		if(columnInfo.copyOptions.widthRatio) {
	        			resetColumnWidths.push(chartTag.find('.datatable').width() * (columnInfo.copyOptions.widthRatio / 100));
	        		}
	        	});
	        	
	        	if(0 < resetColumnWidths.length)
	        		dataTableGrid.resetColumnWidths(resetColumnWidths);
	        	
	        	chartTag.find('.datatable').find('.tui-grid-column-resize-handle').removeAttr('title');	        	
	        },
			minRowHeight: 30,
			rowHeight: 30,
			minBodyHeight: 0,
			bodyHeight: 0,
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
		
		dataTableGrid = new tui.Grid(settings);
	      
		dataTableGrid.on('mouseover', function(ev) {
			if('cell' != ev.targetType) return;
	    	  
			var overCellElement = $(dataTableGrid.getElement(ev.rowKey, ev.columnName));    	  
			overCellElement.attr('title', overCellElement.text());
		});
		
		dataTableGrid.on('click', function(ev) {
			if(!ev.rowKey) return;
			localStorage.setItem('selectedRowDashboard', dataTableGrid.getRow(ev.rowKey).uuid);			
			window.open(contextPath + '/igate/traceLog.html');
		});		
	}
	
	function initFunc() {
		
		this.setInterval = function(standardTime) {
			this.resizeFunc();
		};
		
		this.addData = function(dataArr) {
			
			if(0 == dataArr.length) {
				dataTableGrid.setBodyHeight(0);
				return;
			}
			
			dataTableGrid.setBodyHeight(dataArr.length * 30);
			dataTableGrid.resetData(dataArr);
		};
		
		this.resizeFunc = function() {
			if(originWidth != chartTag.width()) {
				dataTableGrid.refreshLayout();
				originWidth = chartTag.width();
			}
		};
		
		this.downloadExportStart = function(pCsvFileName) {
			
			startSpinner();
			
			var bodyData = '';
			
			var headerData = dataTableGrid.getColumns().map(function(column) {
				return column.header;
			}).join(',');
			
			for(var i = 0; i < dataTableGrid.getData().length; i++) {
				
				var data = dataTableGrid.getData()[i];
				
				var status = ('M' == data.status)? dashboardLabel_warn : ('L' == data.status)? dashboardLabel_serious : dashboardLabel_success;
				var uuid = data.uuid;
				var transactionId = data.transactionId;
				var transactionName = data.transactionName;
				var adapterId = data.adapterId;
				var instanceId = data.instanceId;
				var snapshotTimestamp = moment(new Date(data.snapshotTimestamp)).format('HH:mm:ss');
				
				bodyData += status + ',' + uuid + ',' + transactionId + ',' + transactionName + ',' + adapterId + ',' + instanceId + ',' + snapshotTimestamp + ',';
			}
			
			downloadExcel({ 
				'type'       : 'dataTable',  
				'fileName'   : pCsvFileName, 
				'headerData' : headerData,  
				'bodyData'   : bodyData, 
				'conditionData':  'targetType:'+ chartOptions.typeList.targetType + ',' + 'inputType:' + chartOptions.typeList.inputType + ',' + 'datatableRowCnt:' + datatableRowCnt
			});
			
			stopSpinner();
		};
	}

	return new dataTableChart();
}