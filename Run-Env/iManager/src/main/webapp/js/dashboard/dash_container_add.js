function DashContainerAdd(dashContainerElement, dashContainerOptions) {
	
	var _this = this;
	
	DashContainerConfigParent.call(_this);
		
	_this.initDashMode = function() {
		
		_this.mod = 'add';
		
		$(dashContainerElement).removeClass().addClass('ct-dashboard');
		
		_this.element.dashContainer = dashContainerElement;
		
		$.extend(true, _this.containerInfo, {
			containerId: dashContainerOptions.containerId,		
    		containerName: dashContainerOptions.containerName,
    		containerWidth: dashContainerOptions.containerWidth,
    		containerHeight: dashContainerOptions.containerHeight,
    		remarkYn: dashContainerOptions.remarkYn,
    		darkmodeYn: dashContainerOptions.darkmodeYn,				
		});
		
		_this.initDashConfigSubBar(
			[
				$('<a/>').addClass('btn btn-primary').attr({'id': 'saveContainer', 'href': 'javascript:void(0);'}).text(dashboardBtn_save)					
			],
			function() {
				initDashConfigSubBarAddModeEvent();
			}
		);
		
		_this.initDashConfigArea();
		
		_this.initDashModal();
		
		_this.setTargetInfo(function() {
			_this.setPerfItemConfigList(function() {
				_this.initDashConfigEvent(function() {
					$('[name="theme"][value="' + (('Y' == _this.containerInfo.darkmodeYn)? 'dark' : 'light') + '"]').trigger('click');
					$('[name="legend"][value="' + (('Y' == _this.containerInfo.remarkYn)? 'on' : 'off') + '"]').trigger('click');
				});
			});	
		});
	};
	
    function initDashConfigSubBarAddModeEvent() {
    	
    	$("#saveContainer").on('click', function() {
    		
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
    		
    		_this.componentList.forEach(function(component) {
    			component.monitorComponentTargets.forEach(function(monitorComponentTarget, index) {
    				for(var key in monitorComponentTarget.pk) {
    					component['monitorComponentTargets[' + index + '].pk.' + key] = monitorComponentTarget.pk[key];	
    				}
    			});
    			
    			delete component['monitorComponentTargets'];
    		});
    		
    		_this.componentList.forEach(function(component, index) {
    			for(var key in component){
    				_this.containerInfo['monitorComponents[' + index + '].' + key] = component[key];	
    			}
    		});
    		
        	$.ajax({
				type: 'POST',
		        url: contextPath + '/igate/monitoring/dashboard/container.json',
		        data: _this.containerInfo,
		        dataType: "json",
		        success: function(result) {
		        	if('ok' != result.result) return;
		        	
		        	normalAlert({message : dashboardMsg_addSuccess});
		        	
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
    		_this.containerHistoryList.splice(0, _this.containerHistoryList.length);
           	_this.containerHistoryList.push({'saveTime': Date.now(), 'saveComponentList': _this.componentList.map(function(component) { return $.extend(true, {}, component); })})
    		$("#containerBody").empty().append($(_this.getDashboardEmptyElement()));
    	});
    }
    
    function setLocalStorage() {
    	_this.componentList.forEach(function(component, index) {
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
    	
    	localStorage.setItem('selectedContainerId', _this.containerInfo.containerId);
    }		
}

DashContainerAdd.prototype = Object.create(DashContainerConfigParent.prototype);
DashContainerAdd.prototype.constructor = DashContainerAdd;