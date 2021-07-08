function DashContainerModify(dashContainerElement, dashContainerOptions) {
	
	var _this = this;
	
	DashContainerConfigParent.call(_this);
		
	_this.initDashMode = function() {
		
		_this.mod = 'modify';
		
		$(dashContainerElement).removeClass().addClass('ct-dashboard');
		
		_this.element.dashContainer = dashContainerElement;
		
		$.extend(true, _this.containerInfo, {
    		containerId: dashContainerOptions.containerId,		
    		containerName: dashContainerOptions.containerName,
    		containerWidth: dashContainerOptions.containerWidth,
    		containerHeight: dashContainerOptions.containerHeight,
    		remarkYn: dashContainerOptions.remarkYn,
    		darkmodeYn: dashContainerOptions.darkmodeYn,
    		monitorContainerUsers: dashContainerOptions.monitorContainerUsers			
		});
		
		Array.prototype.push.apply(_this.componentList, dashContainerOptions.componentList.map(function(component) { return $.extend(true, {}, component); }));
		
		_this.initDashConfigSubBar(
			[
				$('<a/>').addClass('btn btn-primary').attr({'id': 'modifyContainer', 'href': 'javascript:void(0);'}).text(dashboardBtn_modify)					
			],
			function() {
				initDashConfigSubBarModifyModeEvent();
			}
		);
		
		_this.initDashConfigArea();
		
		_this.setTargetInfo(function() {
			_this.setPerfItemConfigList(function() {
				_this.initDashConfigEvent(function() {
					$('[name="theme"][value="' + (('Y' == _this.containerInfo.darkmodeYn)? 'dark' : 'light') + '"]').trigger('click');
					$('[name="legend"][value="' + (('Y' == _this.containerInfo.remarkYn)? 'on' : 'off') + '"]').trigger('click');

					_this.initPlaceComponent();	
				});
			});
		});
	};
   
    function initDashConfigSubBarModifyModeEvent() {

    	$("#modifyContainer").on('click', function() {
    		
    		if(0 == _this.componentList.length) {
    			warnAlert({message : dashboardMsg_deployNoComponent});
    			return false;
    		}

    		var checkNormal = true;
    		var warnAlertMsg = null;
    		
    		for(var i = 0; i < _this.componentList.length; i++) {
    			
    			var component = _this.componentList[i];
    			
    			if('XVIEW' != component.chartType && 'DATATABLE' != component.chartType) continue;

    			if('XVIEW' == component.chartType) {
        			var xViewYAxisMax = component.xViewYAxisMax;
        			var xViewTrans = component.xViewTrans;
        			var xViewMinData = component.xViewMinData;

        			if(!$.isNumeric(xViewYAxisMax) || !$.isNumeric(xViewTrans) || !$.isNumeric(xViewMinData)) {
        				warnAlertMsg = dashboardMsg_xViewNumerialCheck;
        				checkNormal = false;
        				break;
        			}
        			
        			if(xViewTrans < 0.1 || xViewTrans > 1.0) {
        				warnAlertMsg = dashboardMsg_xViewRangeCheck;
        				checkNormal = false;
        				break;
        			}    				
    			}

    			if('DATATABLE' == component.chartType) {
    				
    				var datatableRowCnt = component.datatableRowCnt;
    				
        			if(!$.isNumeric(datatableRowCnt)) {
        				warnAlertMsg = dashboardMsg_enterNumber;
        				checkNormal = false;
        				break;
        			}
    			}
    			
    			if('INSTANCE' == component.chartType) {
    				
    				var instanceSummaryColCnt = component.instanceSummaryColCnt;
    				
        			if(!$.isNumeric(instanceSummaryColCnt)) {
        				warnAlertMsg = dashboardMsg_enterNumber;
        				checkNormal = false;
        				break;
        			}
    			}    			
    		}
    		
    		if(!checkNormal) {
    			warnAlert({message : warnAlertMsg});
    			return false;
    		}
    		
        	$.ajax({
				type: 'PUT',
				url: contextPath + '/igate/monitoring/dashboard/container.json',
		        contentType: 'application/json; charset=utf-8',
		        data: JSON.stringify({
	            	containerId: _this.containerInfo.containerId,
	            	containerName: _this.containerInfo.containerName,
	            	containerWidth: _this.containerInfo.containerWidth,
	            	containerHeight: _this.containerInfo.containerHeight,
	            	remarkYn: _this.containerInfo.remarkYn,
	            	darkmodeYn: _this.containerInfo.darkmodeYn,
	            	monitorComponents: _this.componentList,
	            	monitorContainerUsers: _this.containerInfo.monitorContainerUsers
		        }),
		        dataType: "json",
		        success: function(result) {
		        	if('ok' != result.result) return;
		        	
		        	normalAlert({message : dashboardMsg_modifySuccess});
		        	
		        	setLocalStorage();
		        	
		        	_this.changeContainer('view');
		        }
		    });    		
    		
    	});

    	$("#resetContainer").on('click', function() {	
    
    		for(var key in _this.currentContainerHistory) {
    			delete _this.currentContainerHistory[key];
    		}
    		
    		$('#redoContainer').attr('disabled', true);
    		$('#undoContainer').attr('disabled', true);
         	_this.componentList.splice(0, _this.componentList.length);
            Array.prototype.push.apply(_this.componentList, dashContainerOptions.componentList.map(function(component) { return $.extend(true, {}, component); }));
           	_this.containerHistoryList.splice(0, _this.containerHistoryList.length);
           	_this.containerHistoryList.push({'saveTime': Date.now(), 'saveComponentList': _this.componentList.map(function(component) { return $.extend(true, {}, component); })})
    		_this.initPlaceComponent();
    	});
    }
    
    function setLocalStorage() {
		_this.componentList.forEach(function(component){
    		if('XVIEW' == component.chartType) {
	            localStorage.setItem('xViewYAxisMax_' + component.componentId, component.xViewYAxisMax);
	            localStorage.setItem('xViewTrans_' + component.componentId, component.xViewTrans);
	            localStorage.setItem('xViewMinData_' + component.componentId, component.xViewMinData);
			}	
    		
			if('DATATABLE' == component.chartType) {
	            localStorage.setItem('datatableRowCnt_' + component.componentId, component.datatableRowCnt);
			}
			
			if('INSTANCE' == component.chartType) {
	            localStorage.setItem('instanceSummaryColCnt_' + component.componentId, component.instanceSummaryColCnt);
			}			
    	});
		
		var originComponent = dashContainerOptions.componentList.map(function(originComponent){ 
			return originComponent.componentId; 
		});
		
		var changeComponent = _this.componentList.map(function(changeComponent){ 
			return changeComponent.componentId;
		});
		
		for(var i = 0; i < originComponent.length; i++) {
			
			if(-1 != changeComponent.indexOf(originComponent[i])) continue;
			
			localStorage.removeItem('xViewYAxisMax_' + originComponent[i]);
			localStorage.removeItem('xViewTrans_' + originComponent[i]);
			localStorage.removeItem('xViewMinData_' + originComponent[i]);
			localStorage.removeItem('datatableRowCnt_' + originComponent[i]);
			localStorage.removeItem('instanceSummaryColCnt_' + originComponent[i]);
		}
    }		
}

DashContainerModify.prototype = Object.create(DashContainerConfigParent.prototype);
DashContainerModify.prototype.constructor = DashContainerModify;