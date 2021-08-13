function DashContainerParent() {

	DashContainerParent.prototype.element = {
		dashContainer: null
	};
	
	DashContainerParent.prototype.containerInfo = {};
	DashContainerParent.prototype.componentList = [];
	
	DashContainerParent.prototype.perfItemList = [];
	
	DashContainerParent.prototype.instanceList = [];
	DashContainerParent.prototype.adapterList = [];
	DashContainerParent.prototype.connectorList = [];
	DashContainerParent.prototype.queueList = [];
	DashContainerParent.prototype.threadList = [];
	DashContainerParent.prototype.externalLineList = [];
	
	DashContainerParent.prototype.initDashSubBar = function(buttonElementList, callBackFunc) {
		var dashBar = $('<div/>').addClass('sub-bar').attr({'id': 'dashBar'});
		
		var buttonArea = $('<div/>').addClass('ml-auto form-inline');
		
		buttonElementList.forEach(function(buttonElement) {
			buttonArea.append(buttonElement);
		});
		
		$(this.element.dashContainer).append(dashBar.append(buttonArea));
		
		if(callBackFunc) callBackFunc();
	};
	
	DashContainerParent.prototype.setPerfItemList = function(callBackFunc) {
		$.ajax({
    		type: 'GET',
            url: contextPath + '/igate/monitoring/dashboard/perfItem.json',
            data: null,
            dataType: "json",
            success: function(res) {
            	if('ok' != res.result) return;
            	
            	this.perfItemList.splice(0, this.perfItemList.length);
            	
            	Array.prototype.push.apply(this.perfItemList, res.object);
            	
            	if(callBackFunc) callBackFunc();
            }.bind(this)
        });
	};
	
	DashContainerParent.prototype.setTargetInfo = function(callBackFunc) {
    	$.ajax({
    		type: 'GET',
    		url: contextPath + '/igate/monitoring/dashboard/targetInfo.json',
            data: null,
            dataType: "json",
            success: function(res) {
            	if('ok' != res.result) return;

            	this.instanceList.splice(0, this.instanceList.length);
            	this.adapterList.splice(0, this.adapterList.length);
            	this.connectorList.splice(0, this.connectorList.length);
            	this.queueList.splice(0, this.queueList.length);
            	this.threadList.splice(0, this.threadList.length);
            	this.externalLineList.splice(0, this.externalLineList.length);
            	
            	Array.prototype.push.apply(this.instanceList, res.object.instanceList);
            	Array.prototype.push.apply(this.adapterList, res.object.adapterList);
            	Array.prototype.push.apply(this.connectorList, res.object.connectorList);
            	Array.prototype.push.apply(this.queueList, res.object.queueList);
            	Array.prototype.push.apply(this.threadList, res.object.threadList);
            	Array.prototype.push.apply(this.externalLineList, res.object.externalLineList);

            	if(callBackFunc) callBackFunc();
            }.bind(this)
        });
	};
	
	DashContainerParent.prototype.initDashArea = function(callBackFunc) {
		var strHtml = '';

		strHtml += '<div id="dashboard">';
		strHtml += '    <div class="dashboard-inner">';
		strHtml += '        <div id="containerBody" style="width: 100%;height: 100%;"></div>';
		strHtml += '    </div>';
		strHtml += '</div>';

		$(this.element.dashContainer).append($(strHtml));		
		
		if(callBackFunc) callBackFunc();
	};
	
	DashContainerParent.prototype.initDashModal = function(callBackFunc) {
		var strHtml = '';

		strHtml += '<div id="dashModal" class="modal fade" tabindex="-1" role="dialog">';
		strHtml += '    <div class="modal-dialog modal-dialog-centered modal-sm">';
		strHtml += '        <div class="modal-content"></div>';
		strHtml += '    </div>';
		strHtml += '</div>';

		$('body').append($(strHtml));
		
		$('#dashModal').on('show.bs.modal', function(e) {
			function step() { 
				if(0 == $('#dashModal').length) {
					cancelAnimationFrame(rafId);
					return;
				}
				
				if(0 < $('.modal-backdrop').length) { 	  
					$('.modal-backdrop').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
					$('#dashModal').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;
					cancelAnimationFrame(rafId);
					return;
				}
           
				rafId = requestAnimationFrame(step);
			}
         
			var rafId = requestAnimationFrame(step);
		});
		
		if(callBackFunc) callBackFunc();
	};
	
	DashContainerParent.prototype.initDashModalLarge = function(callBackFunc) {
		var strHtml = '';

		strHtml += '<div id="dashModalLarge" class="modal fade" tabindex="-1" role="dialog">';
		strHtml += '    <div class="modal-dialog modal-dialog-centered modal-lg">';
		strHtml += '        <div class="modal-content"></div>';
		strHtml += '    </div>';
		strHtml += '</div>';

		$('body').append($(strHtml));
		
		$('#dashModalLarge').on('show.bs.modal', function(e) {
			function step() { 
				if(0 == $('#dashModalLarge').length) {
					cancelAnimationFrame(rafId);
					return;
				}
				
				if(0 < $('.modal-backdrop').length) { 	  
					$('.modal-backdrop').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'});
					$('#dashModalLarge').css({'width': $("#ct").outerWidth(true), 'left': 'auto', 'right': '0px'}) ;
					cancelAnimationFrame(rafId);
					return;
				}
           
				rafId = requestAnimationFrame(step);
			}
         
			var rafId = requestAnimationFrame(step);
		});
		
		if(callBackFunc) callBackFunc();
	};	
	
	DashContainerParent.prototype.customResizeFunc = function() {
		if($("#dashBar").is(':visible')) $("#containerBody").width('100%').height('100%');
		else						     $("#containerBody").width(this.containerInfo.containerWidth).height(this.containerInfo.containerHeight);
		
		if(this.customResizeCallBackFunc) this.customResizeCallBackFunc();
	};
	
	DashContainerParent.prototype.getDashboardEmptyElement = function() {
		return '<div id="dashboardEmpty" class="card w-100 h-100">' +
			   '    <div class="empty">' + 
			   '        <p>'+ dashboardMsg_dragWidget +'</p>' +
			   '		<img src="' + contextPath + '/img/empty.svg" class="center-block" alt="">' + 
			   ' 	</div>' +
			   '</div>';
	};
	
	DashContainerParent.prototype.getBasicComponentStruct = function() {
		return {
			componentId: null,
			containerId: this.containerInfo.containerId,
			itemId: null,
			pComponentId: null,
    		componentName: null,
    		componentWidth: null,
    		componentHeight: null,
    		chartType: null,
    		targetType: null,
    		unitType: null,
    		inoutType: null,
    		componentOrder: null,
    		componentType: null,
    		componentTypeDirection: null,
    		monitorComponentTargets: []
    	};
	};	
	
	DashContainerParent.prototype.getTypeList = function(perfItemObj) {

    	var chartTypeList = [];
    	var targetTypeList = [];
    	var inoutTypeList = [];
    	
    	//chart
    	var monitorChartGroup = perfItemObj.monitorChartGroup;
    	
    	var chartTypeArr = [
    		{ key: 'LINE', 			value: 'LINE', 			name: dashboardChart_lineChart }, 
    		{ key: 'COLUMN', 		value: 'COLUMN',    	name: dashboardChart_columnChart }, 
    		{ key: 'INSTANCE', 		value: 'INSTANCE',  	name: dashboardChart_instanceSummaryChart }, 
    		{ key: 'CONNECTOR', 	value: 'CONNECTOR', 	name: dashboardChart_connectorSummaryChart }, 
    		{ key: 'QUEUE', 		value: 'QUEUE',     	name: dashboardChart_queueSummaryChart }, 
    		{ key: 'THREAD', 		value: 'THREAD',    	name: dashboardChart_threadSummaryChart },
    		{ key: 'SPEEDBAR',      value: 'SPEEDBAR', 		name: dashboardChart_speedBarChart},
    		{ key: 'DATATABLE',		value: 'DATATABLE',		name: dashboardChart_dataTable},
    		{ key: 'EXTERNALLINE',	value: 'EXTERNALLINE',	name: dashboardChart_externalLine},
    		{ key: 'XVIEW',			value: 'XVIEW',			name: dashboardChart_xview},
    	];    	
    	
    	monitorChartGroup.forEach(function(chartGroupInfo) {
    		for(var i = 0; i < chartTypeArr.length; i++) {
    			if(chartGroupInfo.pk.chartType == chartTypeArr[i].key) {
    				chartTypeList.push({value: chartTypeArr[i].value, name: chartTypeArr[i].name});
    				break;
    			}
    		}
    	});
    	
    	//target
    	var monitorTargetGroup = perfItemObj.monitorTargetGroup;
    	
    	var targetTypeArr = [
    		{ key: 'INSTANCE',   	value: 'INSTANCE',    	name: dashboardTarget_instance},
    		{ key: 'ADAPTER',    	value: 'ADAPTER',     	name: dashboardTarget_adaptor}, 
    		{ key: 'CONNECTOR',  	value: 'CONNECTOR',   	name: dashboardTarget_connector}, 
    		{ key: 'QUEUE',      	value: 'QUEUE',       	name: dashboardTarget_queue}, 
    		{ key: 'THREAD',     	value: 'THREAD',      	name: dashboardTarget_thread},
    		{ key: 'EXTERNALLINE',	value: 'EXTERNALLINE',	name: dashboardTarget_externalLine},
    	];
    	
    	monitorTargetGroup.forEach(function(targetGroupInfo) {
    		for(var i = 0; i < targetTypeArr.length; i++) {
    			if(targetGroupInfo.pk.targetType == targetTypeArr[i].key) {
    				targetTypeList.push({value: targetTypeArr[i].value, name: targetTypeArr[i].name});
    				break;
    			}
    		}
    	});    	
    	
    	//in out
    	if('Y' == perfItemObj.inOutExistYn) {
    		inoutTypeList = [
        		{value: 'IN',    name: 'IN'},
        		{value: 'OUT',   name: 'OUT'}
    		];
    	}
        
        return {
        	chartTypeList : chartTypeList,
    		targetTypeList : targetTypeList,
    		inoutTypeList : inoutTypeList,        	
        };
    };	
}