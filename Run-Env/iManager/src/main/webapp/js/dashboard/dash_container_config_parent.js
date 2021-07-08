function DashContainerConfigParent() {
	
	var _this = this;
	
	DashContainerParent.call(_this);

	DashContainerConfigParent.prototype.mod = null;
	
	DashContainerConfigParent.prototype.containerHistoryList = [];
	
	DashContainerConfigParent.prototype.currentContainerHistory = {};
	
	DashContainerConfigParent.prototype.initDashConfigSubBar = function(buttonElementList, callBackFunc) {
		
		var standardButtonElementList = [
			$('<button/>').addClass('custom-control custom-switch btn-widget').attr({'type': 'button'}).append($('<span/>').addClass('custom-control-label').text(dashboardLabel_addWidget)),
			$('<a/>').addClass('btn').attr({'id': 'redoContainer', 'href': 'javascript:void(0);', 'disabled': true}).append($('<i/>').addClass('icon-left')).append($('<span/>').text(dashboardBtn_backward)),
			$('<a/>').addClass('btn').attr({'id': 'undoContainer', 'href': 'javascript:void(0);', 'disabled': true}).append($('<i/>').addClass('icon-right')).append($('<span/>').text(dashboardBtn_forward)),
			$('<a/>').addClass('btn').attr({'id': 'resetContainer', 'href': 'javascript:void(0);'}).append($('<i/>').addClass('icon-reset')).append($('<span/>').text(dashboardLabel_initialize))
		];
		
		Array.prototype.push.apply(standardButtonElementList, buttonElementList);
		
		_this.initDashSubBar(
			standardButtonElementList,
			function() {
				$('#dashBar').find('.ml-auto').before(
					$('<a/>').addClass('btn btn-icon').attr({'id': 'backBtn', 'href': 'javascript:void(0);', 'title': escapeHtml(dashboardBtn_back)}).append($('<i/>').addClass('icon-left'))
				);
				
				if(callBackFunc) callBackFunc();
			}
		);
	};
	
	DashContainerConfigParent.prototype.initDashConfigArea = function(callBackFunc) {
    	
		_this.initDashArea(function() {
			
			$('#dashboard').addClass('edit-mode widget-set-mode');
			
			$('#dashboard').find('#containerBody').append($(_this.getDashboardEmptyElement()));
			
			var strHtml = '';
		    	strHtml += '<div id="widget" class="card">';
		    	strHtml += '	<h2 class="h2 flex-shrink-0">'+ dashboardLabel_addWidget +'</h2>';
		    	strHtml += '	<section class="widget">';
		    	strHtml += '		<header class="sub-bar flex-shrink-0">';
		    	strHtml += '			<h3 class="sub-bar-text">'+ dashboardLabel_widget +'</h3>';
		    	strHtml += '		</header>';
		    	strHtml += '		<ul id="perfItemList" class="widget-item-list scrollbar-inner"></ul>';
		    	strHtml += '	</section>';
		    	strHtml += '	<section class="flex-shrink-0">';
		    	strHtml += '		<header class="sub-bar mb-2">';
		    	strHtml += '			<h3 class="sub-bar-text">'+ dashboardLabel_setting +'</h3>';
		    	strHtml += '		</header>';
		    	strHtml += '		<div class="form-group">';
		    	strHtml += '			<div class="control-label">'+ dashboardLabel_theme +'</div>';
		    	strHtml += '			<label class="custom-control custom-radio custom-control-inline">';
		    	strHtml += '				<input type="radio" name="theme" value="light" class="custom-control-input">';
		    	strHtml += '				<span class="custom-control-label">'+ dashboardLabel_themeLight +'</span>';
		    	strHtml += '			</label>';
		    	strHtml += '			<label class="custom-control custom-radio custom-control-inline">';
		    	strHtml += '				<input type="radio" name="theme" value="dark" class="custom-control-input">';
		    	strHtml += '				<span class="custom-control-label">'+ dashboardLabel_themeDark +'</span>';
		    	strHtml += '			</label>';
		    	strHtml += '		</div>';
		    	strHtml += '		<div class="form-group">';
		    	strHtml += '			<div class="control-label">'+ dashboardLabel_legend +'</div>';
		    	strHtml += '			<label class="custom-control custom-radio custom-control-inline">';
		    	strHtml += '				<input type="radio" name="legend" value="on" class="custom-control-input">';
		    	strHtml += '				<span class="custom-control-label">'+ dashboardLabel_legendOn +'</span>';
		    	strHtml += '			</label>';
		    	strHtml += '			<label class="custom-control custom-radio custom-control-inline">';
		    	strHtml += '				<input type="radio" name="legend" value="off" class="custom-control-input">';
		    	strHtml += '				<span class="custom-control-label">'+ dashboardLabel_legendOff +'</span>';
		    	strHtml += '			</label>';
		    	strHtml += '		</div>';
		    	strHtml += '	</section>';
		    	strHtml += '</div>';			
			
		    $('#dashboard').append($(strHtml));
		    	
		    if(callBackFunc) callBackFunc();
		});
	};
	
	DashContainerConfigParent.prototype.setPerfItemConfigList = function(callBackFunc) {
		_this.setPerfItemList(function() {
        	$("#perfItemList").empty();
        	
        	_this.perfItemList.forEach(function(perfItemObj) {
        		perfItemObj.itemName = dashboardWidget[perfItemObj.itemId];
        		
        		var perfItemLi = $("<li/>").addClass('nav-link').data('itemId', perfItemObj.itemId).attr('title', escapeHtml(dashboardWidget[perfItemObj.itemId] + '\n' + dashboardWidgetDesc[perfItemObj.itemId]));
        		
        		perfItemLi.append($("<i/>").addClass(perfItemObj.itemIcon));
        		perfItemLi.append(escapeHtml(perfItemObj.itemName));
        		
        		$("#perfItemList").append(perfItemLi);
        	});
        	
        	//성능 항목
            $("#perfItemList").find('li').draggable({cursor: 'pointer', revert: true, scroll: false, helper: 'clone', appendTo: $(_this.element.dashContainer).parent()});
            
    		if(callBackFunc) callBackFunc();
		});
	};
	
	DashContainerConfigParent.prototype.initDashConfigEvent = function(callBackFunc) {

		//뒤로 가기
		$("#backBtn").on('click', function() {
			_this.changeContainer('view');
    	});
		
    	//위젯 추가
		$('.btn-widget').on('click', function() {
    		$(this).toggleClass('checked');
    		$('#widget').toggleClass('open');
		});
		
		$("#redoContainer, #undoContainer").on('click', function() {    	
    		setContainerState.call(this);
    	});
    	
    	//설정 테마
		$('[name="theme"]').on('change', function(evt) {
    		if('dark' == $('[name="theme"]:checked').val()){
    			_this.containerInfo.darkmodeYn = 'Y';	
    			$(_this.element.dashContainer).parent().addClass('dark');
    		}else{
    			_this.containerInfo.darkmodeYn = 'N';
    			$(_this.element.dashContainer).parent().removeClass('dark');
    		}			
		});
		
    	//설정 범례
    	$('[name="legend"]').change(function(){
    		_this.containerInfo.remarkYn = ('on' == $('[name="legend"]:checked').val())? 'Y' : 'N';
    	});
		
    	//대시보드 body
    	$("#containerBody").droppable({
            drop: function(event, ui) {

            	if(_this.componentList.length) return false;
                
                //root
                _this.componentList.push(_this.getBasicComponentStruct());
                
                var rootDataObj = _this.componentList[_this.componentList.length - 1];
                
                rootDataObj.componentId = getUUID();
                rootDataObj.pComponentId = '-1';
                rootDataObj.componentOrder = 1;
                rootDataObj.componentWidth = '100%';
                rootDataObj.componentHeight = '100%';
                rootDataObj.componentType = 'G';
                
                var rootDiv = $("<div/>").attr({'id': 'root'}).css({'width': rootDataObj.componentWidth, 'height': rootDataObj.componentHeight}).data('dataObj', rootDataObj);
                
                //component
                _this.componentList.push(_this.getBasicComponentStruct());
                
                var newComponentDataObj = _this.componentList[_this.componentList.length - 1];
                
                newComponentDataObj.componentId = getUUID();
                newComponentDataObj.pComponentId = rootDataObj.componentId;
                newComponentDataObj.componentOrder = 1;
                newComponentDataObj.componentWidth = '100%';
                newComponentDataObj.componentHeight = '100%';
                newComponentDataObj.componentType = 'C';
                newComponentDataObj.itemId = $(ui.draggable).data('itemId');
                
                var perfItemInfo = _this.perfItemList.filter(function(perfItemInfo) { return perfItemInfo.itemId == newComponentDataObj.itemId })[0];
                
                newComponentDataObj.componentName = perfItemInfo.itemName;
                
                var defaultTypeObj = getDefaultType(perfItemInfo);
                newComponentDataObj.chartType = defaultTypeObj.chartType;
                newComponentDataObj.targetType = defaultTypeObj.targetType;
                newComponentDataObj.unitType = defaultTypeObj.unitType;
                newComponentDataObj.inoutType = defaultTypeObj.inoutType;
                
                var newComponentDiv = initNewComponent(newComponentDataObj).css({'width': newComponentDataObj.componentWidth, 'height': newComponentDataObj.componentHeight}).data('dataObj', newComponentDataObj);
                
                //component append
                rootDiv.append(newComponentDiv);
                
                //component append
                $("#containerBody").append(rootDiv);
                
                //dashboardEmpty Element remove
                $('#dashboardEmpty').remove();
                
                //component event bind
                _this.initDroppable(newComponentDiv);
                _this.initResizable(newComponentDiv);
                _this.initDelete(newComponentDiv);
                _this.initChange(newComponentDiv);
            	                
                newComponentDiv.find("[name=targetType]").trigger('change');
            }
        });  
    	
    	//containerHistoryList에 초기 상태 저장
		setContainerHistory();
		
		if(callBackFunc) callBackFunc();
	};

	DashContainerConfigParent.prototype.changeContainer = function(mod, pDashContainerOption) {
    	$(_this.element.dashContainer).removeClass('ct-dashboard');
    	$(_this.element.dashContainer).parent().removeClass('dark');
    	
    	$("#dashBar").remove();
    	$("#dashboard").remove();
    	
		_this.containerHistoryList.splice(0, _this.containerHistoryList.length);
    	
		for(var key in _this.currentContainerHistory) {
			delete _this.currentContainerHistory[key];
		}
		
    	var dashContainerOption = {mod: mod};
    	
    	if('view' == mod) dashContainerOption.websocketUrl = websocketUrl;
    	
    	if(pDashContainerOption) {
    		dashContainerOption = $.extend(true, {}, dashContainerOption, pDashContainerOption);
    	}
    	
    	$(_this.element.dashContainer).dashContainer(dashContainerOption);
    };
	
	DashContainerConfigParent.prototype.initDroppable = function(componentDiv) {
    	if($(componentDiv).droppable()) {
    		$(componentDiv).droppable('destroy');
    	}
    	
        $(componentDiv).find('.componentDroppable').droppable({
            tolerance: 'pointer',
            drop: function(event, ui) {
            	var type = $(this).data('type');
            	var componentTypeDirection = $(this).parent().parent().data('dataObj').componentTypeDirection;
            	var itemId = $(ui.draggable).data('itemId');
            	
            	if('l' == type || 'r' == type){
            		if(!componentTypeDirection || 'h' == componentTypeDirection){
            			initSameDirection.call($(this).parent(), type, 'h', itemId);
            		}else{
            			initDifferentDirection.call($(this).parent(), type, 'h', itemId);
            		}
            	}else{
            		if(!componentTypeDirection || 'v' == componentTypeDirection){
            			initSameDirection.call($(this).parent(), type, 'v', itemId);
            		}else{
            			initDifferentDirection.call($(this).parent(), type, 'v', itemId);
            		}
            	}
            }
        });
        
        function initSameDirection(type, componentTypeDirection, itemId){
        	
        	var component = $(this);
        	var componentDataObj = component.data('dataObj');
        	
        	var group = component.parent();
        	var groupDataObj = group.data('dataObj');
        	
        	groupDataObj.componentTypeDirection = componentTypeDirection;
        	
            _this.componentList.push(_this.getBasicComponentStruct());
            
            var newComponentDataObj = _this.componentList[_this.componentList.length - 1];
            
            newComponentDataObj.componentId = getUUID();
            newComponentDataObj.pComponentId = groupDataObj.componentId;
            newComponentDataObj.componentType = 'C';
            newComponentDataObj.itemId = itemId;
            
            var perfItemInfo = _this.perfItemList.filter(function(perfItemInfo) { return perfItemInfo.itemId == newComponentDataObj.itemId })[0];
            
            newComponentDataObj.componentName = perfItemInfo.itemName;
            
            var defaultTypeObj = getDefaultType(perfItemInfo);
            newComponentDataObj.chartType = defaultTypeObj.chartType;
            newComponentDataObj.targetType = defaultTypeObj.targetType;
            newComponentDataObj.unitType = defaultTypeObj.unitType;
            newComponentDataObj.inoutType = defaultTypeObj.inoutType;
            
            var newComponentDiv = initNewComponent(newComponentDataObj).data('dataObj', newComponentDataObj);        	
            
            //component append
            if('l' == type || 't' == type)  component.before(newComponentDiv);
            else 						    component.after(newComponentDiv);     
            
            //group > componentList set width height
            var childrenElementList = group.children().not('.ui-resizable-handle');

            var adjustWidth  = ('h' == componentTypeDirection)?  (componentDataObj.componentWidth.replace(/[^.0-9]/g, "") / 2).toFixed(4) + '%' : '100%';
            var adjustHeight = ('h' == componentTypeDirection)? '100%' 																	  : (componentDataObj.componentHeight.replace(/[^.0-9]/g, "") / 2).toFixed(4) + '%';
            
            component.data('dataObj').componentWidth = adjustWidth;
            component.data('dataObj').componentHeight = adjustHeight;
            
            newComponentDiv.data('dataObj').componentWidth = adjustWidth;
            newComponentDiv.data('dataObj').componentHeight = adjustHeight;
            
            for(var index = 0; index < childrenElementList.length; index++){
            	var childrenElement = childrenElementList[index];
            	
            	var childDataObj = $(childrenElement).data('dataObj');
            	
            	childDataObj.componentOrder = index + 1;
            	
            	$(childrenElement).css({'width': childDataObj.componentWidth, 'height': childDataObj.componentHeight});
            }
            
            //component event bind
            _this.initDroppable(newComponentDiv);
            _this.initResizable(newComponentDiv);
            _this.initDelete(newComponentDiv);
            _this.initChange(newComponentDiv);
            
            newComponentDiv.find("[name=targetType]").trigger('change');
        }
        
        function initDifferentDirection(type, componentTypeDirection, itemId) {
        	
        	var component = $(this);
        	var componentDataObj = component.data('dataObj');
        	
        	var group = component.parent();
        	var groupDataObj = group.data('dataObj');
        	
            //group
        	_this.componentList.push(_this.getBasicComponentStruct());
        	
        	var newGroupDataObj = _this.componentList[_this.componentList.length - 1];
        	
            newGroupDataObj.componentId = getUUID();
            newGroupDataObj.pComponentId = componentDataObj.pComponentId;
            newGroupDataObj.componentOrder = componentDataObj.componentOrder;
            newGroupDataObj.componentWidth = componentDataObj.componentWidth;
            newGroupDataObj.componentHeight = componentDataObj.componentHeight;
            newGroupDataObj.componentTypeDirection = componentTypeDirection;
            newGroupDataObj.componentType = 'G';
            
            var newGroupDiv = $("<div/>").addClass('component-' + (('h' == componentTypeDirection)? 'horizontal' : 'vertical')).css({'width': newGroupDataObj.componentWidth, 'height': newGroupDataObj.componentHeight}).data('dataObj', newGroupDataObj);

            //component element
            componentDataObj.pComponentId = newGroupDataObj.componentId;
            
            component.find('.ui-droppable-active').removeClass('ui-droppable-active');
            
            //new component element
            _this.componentList.push(_this.getBasicComponentStruct());
            
            var newComponentDataObj = _this.componentList[_this.componentList.length - 1];
            
            newComponentDataObj.componentId = getUUID();
            newComponentDataObj.pComponentId = newGroupDataObj.componentId;
            newComponentDataObj.componentType = 'C';
            newComponentDataObj.itemId = itemId;
            
            var perfItemInfo = _this.perfItemList.filter(function(perfItemInfo) { return perfItemInfo.itemId == newComponentDataObj.itemId })[0];
            
            newComponentDataObj.componentName = perfItemInfo.itemName;
            
            var defaultTypeObj = getDefaultType(perfItemInfo);
            newComponentDataObj.chartType = defaultTypeObj.chartType;
            newComponentDataObj.targetType = defaultTypeObj.targetType;
            newComponentDataObj.unitType = defaultTypeObj.unitType;
            newComponentDataObj.inoutType = defaultTypeObj.inoutType;
            
            var newComponentDiv = initNewComponent(newComponentDataObj).data('dataObj', newComponentDataObj);            

        	//parent append
            component.before(newGroupDiv);
            
        	//group append component element, new component element
            if('l' == type || 't' == type)  newGroupDiv.append(newComponentDiv).append(component);
            else							newGroupDiv.append(component).append(newComponentDiv);
            
            //group > componentList set width height
            var childrenElementList = newGroupDiv.children().not('.ui-resizable-handle');
            
            var adjustWidth  = ('h' == componentTypeDirection)?  '50%' : '100%';
            var adjustHeight = ('h' == componentTypeDirection)? '100%'	: '50%';
        	
            for(var index = 0; index < childrenElementList.length; index++){
            	var childrenElement = childrenElementList[index];
            	
            	var childDataObj = $(childrenElement).data('dataObj');
            	
            	childDataObj.componentWidth = adjustWidth;
            	childDataObj.componentHeight = adjustHeight;
            	childDataObj.componentOrder = index + 1;
            	
            	$(childrenElement).css({'width': childDataObj.componentWidth, 'height': childDataObj.componentHeight});
            }

            //group event bind
            _this.initResizable(newGroupDiv);
            
            //component event bind
            _this.initDroppable(component);
            _this.initResizable(component);
            _this.initDelete(component);
            _this.initChange(component);
            
            //new component event bind
            _this.initDroppable(newComponentDiv);
            _this.initResizable(newComponentDiv);
            _this.initDelete(newComponentDiv);
            _this.initChange(newComponentDiv);
            
            newComponentDiv.find("[name=targetType]").trigger('change');
        }
    };

    DashContainerConfigParent.prototype.initResizable = function(componentDiv) {
    	
        var totalOrgWidth = null;
        var totalOrgHeight = null;

        if($(componentDiv).resizable()) {
        	$(componentDiv).resizable('destroy');
        }

        $(componentDiv).resizable({
            handles: "w, n",
            start: function(event, ui) {
                	var component = $(this);
                	var componentDataObj = component.data('dataObj');
                	
                	var prevComponentList = $(this).prevAll().not('.ui-resizable-handle');
                	var prevComponent = $(prevComponentList[0]); 
                	var prevComponentDataObj = prevComponent.data('dataObj');                	
                	
                    totalOrgWidth = Number(componentDataObj.componentWidth.replace(/[^.0-9]/g, "")) + Number(prevComponentDataObj.componentWidth.replace(/[^.0-9]/g, ""));
                    totalOrgHeight = Number(componentDataObj.componentHeight.replace(/[^.0-9]/g, "")) + Number(prevComponentDataObj.componentHeight.replace(/[^.0-9]/g, ""));
                    
                    var axis = component.data('ui-resizable').axis;
                    var comoponentTooltip = $('<span/>').addClass('resize-tooptip');
                    var preComoponentTooltip = $('<span/>').addClass('resize-tooptip');
                    
                    component.append( 
                    		$('<div/>').attr('id', 'componentHover').addClass('componentHover componentHover')
                    				   .css({ 'width': component.width() - 10, 'height': component.height() - 5 })
                    				   .append(comoponentTooltip)
                    );
                    
                    prevComponent.append( 
                    		$('<div/>').attr('id', 'prevCompoentHover').addClass('componentHover prevCompoentHover')
                    				   .css({ 'width': component.width() - 10, 'height': prevComponent.height() - 5 })
                    				   .append(preComoponentTooltip)
                    );
                    
                    if('w' == axis) {                    	
                    	var resizeTooltipTop = ($(this).parent().innerHeight() <= event.offsetY + $('.resize-tooptip').outerHeight(true))? event.offsetY - $('.resize-tooptip').outerHeight(true) : event.offsetY;
                    	comoponentTooltip.css({'top' : resizeTooltipTop, 'left': '5px'}).text(parseFloat(Number(prevComponentDataObj.componentWidth) * 100 / totalOrgWidth).toFixed(2) + '%');
                    	preComoponentTooltip.css({'top' : resizeTooltipTop, 'right': '5px'}).text(parseFloat(Number(componentDataObj.componentWidth) * 100 / totalOrgWidth).toFixed(2) + '%');
                    } else if ('n' == axis) {
                    	var resizeTooltipLeft = ($(this).parent().innerWidth() <= event.offsetX + $('.resize-tooptip').outerWidth(true))? event.offsetX - $('.resize-tooptip').outerWidth(true) : event.offsetX;
                    	comoponentTooltip.css({'left' : resizeTooltipLeft, 'top': '5px'}).text(parseFloat(Number(prevComponentDataObj.componentHeight) * 100 / totalOrgHeight).toFixed(2) + '%');
                    	preComoponentTooltip.css({'left' : resizeTooltipLeft, 'bottom': '5px'}).text(parseFloat(Number(componentDataObj.componentHeight) * 100 / totalOrgHeight).toFixed(2) + '%');
                    }
            },
            stop: function( event, ui ) {
            	$('#prevCompoentHover').remove();
            	$('#componentHover').remove();
            	setContainerHistory();
            },
            resize: function(event, ui) {
            	componentResize();
            }
            
        });
        
        $(componentDiv).children('.ui-resizable-handle').dblclick(function() {
        	 componentResize(50);
        	 setContainerHistory();
        });
        
        function componentResize(sizePer) {
        	var component = $(componentDiv);
        	var componentDataObj = component.data('dataObj');
            var axis = component.data('ui-resizable').axis;
            
        	var prevComponentList = $(componentDiv).prevAll().not('.ui-resizable-handle');
        	var prevComponent = $(prevComponentList[0]); 
        	var prevComponentDataObj = prevComponent.data('dataObj');
            
        	if(sizePer) {
        		totalOrgWidth = Number(componentDataObj.componentWidth.replace(/[^.0-9]/g, "")) + Number(prevComponentDataObj.componentWidth.replace(/[^.0-9]/g, ""));
                totalOrgHeight = Number(componentDataObj.componentHeight.replace(/[^.0-9]/g, "")) + Number(prevComponentDataObj.componentHeight.replace(/[^.0-9]/g, ""));
        	}
        	
            if('w' == axis){

                var prevWidthPer = null;	
            	
                if(sizePer) {
            	   prevWidthPer = sizePer;
            	} else {
            	   var currentWidth = component.width();
                   var prevWidth = prevComponent.width();
                   var totalWidth = currentWidth + prevWidth;

                   prevWidthPer = (prevWidth * 100) / totalWidth;
                   prevWidthPer = (30 > prevWidthPer)? 30 : (70 < prevWidthPer)? 70 : prevWidthPer;
                }
            	
                var prevWidthVal = totalOrgWidth * (prevWidthPer / 100);
                
                prevComponentDataObj.componentWidth = prevWidthVal.toFixed(4) + '%';
                prevComponent.css({'width': prevComponentDataObj.componentWidth});
                
                componentDataObj.componentWidth = (totalOrgWidth - prevWidthVal).toFixed(4) + '%';
                component.css({'width': componentDataObj.componentWidth});
                
                if(sizePer) return;
                	
                $("#prevCompoentHover").css({ 'width' : prevComponent.width() - 10 });
                $("#prevCompoentHover").children('.resize-tooptip').text(prevWidthPer.toFixed(2) + '%');
                
                $("#componentHover").css({ 'width' : component.width() - 10 });
                $("#componentHover").children('.resize-tooptip').text((100 - prevWidthPer).toFixed(2) + '%');
                
            } else if ('n' == axis) {

            	var prevHeightPer = null;
            	
            	if(sizePer) {
            		prevHeightPer = sizePer;
            	} else {
            		var currentHeight = component.height();
                    var prevHeight = prevComponent.height();
                    var totalHeight = currentHeight + prevHeight;

                    var prevHeightPer = (prevHeight * 100) / totalHeight;
                    prevHeightPer = (30 > prevHeightPer)? 30 : (70 < prevHeightPer)? 70 : prevHeightPer;
            	}
            	
                var prevHeightVal = totalOrgHeight * (prevHeightPer / 100);
                
                prevComponentDataObj.componentHeight = prevHeightVal.toFixed(4) + '%';
                prevComponent.css({'height': prevComponentDataObj.componentHeight});
               
                componentDataObj.componentHeight = (totalOrgHeight - prevHeightVal).toFixed(4) + '%';
                component.css({'height': componentDataObj.componentHeight});

                if(sizePer) return;
                
                $("#prevCompoentHover").css({ 'height' : prevComponent.height() - 5 });
                $("#prevCompoentHover").children('.resize-tooptip').text(prevHeightPer.toFixed(2) + '%');
                
                $("#componentHover").css({ 'height' : component.height() - 5 });
                $("#componentHover").children('.resize-tooptip').text((100 - prevHeightPer).toFixed(2) + '%');
            }
        }
                
        //컴포넌트 1개이고 resize할 때 에러가 나는 경우 false
        function initBeforeResizable() {
        	
        	var axis = $(this).data('ui-resizable').axis;
        	var componentTypeDirection = $(this).parent().data('dataObj').componentTypeDirection;
        	var prevComponentList = $(this).prevAll().not('.ui-resizable-handle');
        	
        	return (('n' === axis && 'v' === componentTypeDirection) || ('w' === axis && 'h' === componentTypeDirection)) && (0 < prevComponentList.length);
        }
    };   
    
    DashContainerConfigParent.prototype.initDelete = function(componentDiv) {
    	
    	$(componentDiv).find('.componentDelete').off('click').on('click', function() {
    		
        	var component = $(this).parent();
        	var componentDataObj = component.data('dataObj');
        	
        	var group = component.parent();
        	var groupDataObj = group.data('dataObj');
    		var componentTypeDirection = groupDataObj.componentTypeDirection; 
    		
    		if('root' != group.attr('id') && 1 == group.children().not('.ui-resizable-handle').length - 1) {
    			
    			var anotherElement = null;
    			var anotherElementDataObj = null;
    			
    			var childrenElementList = group.children().not('.ui-resizable-handle');
    			
    			for(var i = 0; i < childrenElementList.length; i++){
    				if(childrenElementList[i] != component[0]) {
    					anotherElement = $(childrenElementList[i]);
    					anotherElementDataObj = $(childrenElementList[i]).data('dataObj'); 
    					break;
    				}
    			}
    			
    			var groupElementSize = { 
    				componentWidth: anotherElement.parent().data('dataObj').componentWidth, 
    				componentHeight: anotherElement.parent().data('dataObj').componentHeight 
        		};
	  			
    			//another component
    			anotherElementDataObj.pComponentId = groupDataObj.pComponentId;

    			//append another component
                group.before(anotherElement);
                
                //group, component remove
                component.remove();
                group.remove();
                
                var filterComponentList = _this.componentList.filter(function(component) { return component.componentId != componentDataObj.componentId })
                											 .filter(function(component) { return component.componentId != groupDataObj.componentId });            
                
                _this.componentList.splice(0, _this.componentList.length);
                
                Array.prototype.push.apply(_this.componentList, filterComponentList);

                //group > componentList set width height
                var tmpGroup = anotherElement.parent();
                var tmpDataObj = tmpGroup.data('dataObj');
                var tmpComponentTypeDirection = tmpDataObj.componentTypeDirection; 
                
                var childrenElementList = tmpGroup.children().not('.ui-resizable-handle');
                
                var adjustWidth  = ('h' == tmpComponentTypeDirection)?  groupElementSize.componentWidth : '100%';
                var adjustHeight = ('h' == tmpComponentTypeDirection)? '100%'							: groupElementSize.componentHeight;

                anotherElement.data('dataObj').componentWidth = adjustWidth;
                anotherElement.data('dataObj').componentHeight = adjustHeight;
                
                for(var index = 0; index < childrenElementList.length; index++){
                	var childrenElement = childrenElementList[index];
                	
                	var childDataObj = $(childrenElement).data('dataObj');
                	
                	childDataObj.componentOrder = index + 1;
                	
                	$(childrenElement).css({'width': childDataObj.componentWidth, 'height': childDataObj.componentHeight});
                }
                
    		}else{
    			
    			var componentElementSize = { 
    				componentWidth: componentDataObj.componentWidth.replace(/[^.0-9]/g, ""), 
        			componentHeight: componentDataObj.componentHeight.replace(/[^.0-9]/g, "")
        		};

    			component.remove();
    			
                var filterComponentList = _this.componentList.filter(function(component) { return component.componentId != componentDataObj.componentId });
    			
                _this.componentList.splice(0, _this.componentList.length);
                
                Array.prototype.push.apply(_this.componentList, filterComponentList);
    			
    			var childrenElementList = group.children().not('.ui-resizable-handle');
    			
    			var adjustWidth  = ('h' == componentTypeDirection)?  ((componentElementSize.componentWidth / childrenElementList.length).toFixed(4)) : 100;
                var adjustHeight = ('h' == componentTypeDirection)? 100 																			 : ((componentElementSize.componentHeight / childrenElementList.length).toFixed(4));

                for(var index = 0; index < childrenElementList.length; index++){
                	
                	var childrenElement = childrenElementList[index];
                	
                	var childDataObj = $(childrenElement).data('dataObj');
                	 
                	childDataObj.componentWidth = (adjustWidth == 100)? adjustWidth + '%' : (Number(childDataObj.componentWidth.replace(/[^.0-9]/g, "")) + Number(adjustWidth)) + '%';
                	childDataObj.componentHeight = (adjustHeight == 100)? adjustHeight + '%' : (Number(childDataObj.componentHeight.replace(/[^.0-9]/g, "")) + Number(adjustHeight)) + '%';
                	childDataObj.componentOrder = index + 1;
                	
                	$(childrenElement).css({'width': childDataObj.componentWidth, 'height': childDataObj.componentHeight});
                }
                
                if('root' == group.attr('id') && (0 == group.children().not('.ui-resizable-handle').length)){
                	_this.componentList.splice(0, _this.componentList.length);
    				
                	group.remove();

    				$("#containerBody").append($(_this.getDashboardEmptyElement()));
                }
    		}
    		
    		setContainerHistory();
    	});
    };
    
    DashContainerConfigParent.prototype.initChange = function(componentDiv) {

        $(componentDiv).find('.card-body').find('[name=componentName]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').componentName = $(this).val();
        	setContainerHistory();
        });

        $(componentDiv).find('.card-body').find('[name=chartType]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').chartType = $(this).val();
        	setContainerHistory();
        });
        
        $(componentDiv).find('.card-body').find('[name=targetType]').off('change').on('change', function(evt) {
        	var targetType = $(this).val();
        	
        	$(componentDiv).data('dataObj').targetType = targetType;
    		
    		if('EXTERNALLINE' == targetType) {
    			$(componentDiv).data('dataObj').monitorComponentTargets = [];
        		$(this).parent().find('[name=selectedTarget]').remove();
        		setContainerHistory();
    		}else if('INSTANCE' != targetType) {
        		
        		var selectedTarget = $("<select/>").attr({'name': 'selectedTarget'}).addClass('form-control');
        		
        		if('ADAPTER' == targetType) {
        			_this.adapterList.forEach(function(adapterInfo) { 
        				selectedTarget.append($("<option/>").attr({'value': adapterInfo.adapterId}).text(adapterInfo.adapterId)); 
        			});
        		}else if('CONNECTOR' == targetType)	{
        			_this.connectorList.forEach(function(connectorInfo) { 
        				selectedTarget.append($("<option/>").attr({'value': connectorInfo.connectorId}).text(connectorInfo.connectorId)); 
        			});
        		}
        		else if('QUEUE' == targetType) {
        			_this.queueList.forEach(function(queueInfo) { 
        				selectedTarget.append($("<option/>").attr({'value': queueInfo.adapterId}).text(queueInfo.adapterId)); 
        			});        			
        		}
        		else if('THREAD' == targetType) {
        			_this.threadList.forEach(function(threadInfo) { 
        				selectedTarget.append($("<option/>").attr({'value': threadInfo.threadPoolId}).text(threadInfo.threadPoolId)); 
        			});
        		}
        		
        		selectedTarget.on('change', function(evt, param1) {
        			$(this).attr({'title': escapeHtml($(this).val())});
        			$(componentDiv).data('dataObj').monitorComponentTargets = [{pk: {componentId: $(componentDiv).data('dataObj').componentId, componentTargetId: $(this).val()}}];

        			if('undefined' == typeof param1 || 0 == param1) setContainerHistory();
        		});
        		
        		$(this).after(selectedTarget);
        		
        		selectedTarget.trigger('change', [$(componentDiv).find('.card-body').find('[name=inoutType]').length]);
        		
    			$(componentDiv).find('.card-body').find('[name=inoutType]').prop('disabled', false);
    			$(componentDiv).find('.card-body').find('[name=inoutType]').trigger('change');
        		
        	}else if('INSTANCE' == targetType) {
        		$(componentDiv).data('dataObj').monitorComponentTargets = [];
        		$(this).parent().find('[name=selectedTarget]').remove();
        		
        		if(0 == $(componentDiv).find('.card-body').find('[name=inoutType]').length) setContainerHistory();
        		
    			$(componentDiv).find('.card-body').find('[name=inoutType]').val('IN');
    			$(componentDiv).find('.card-body').find('[name=inoutType]').prop('disabled', true);
    			$(componentDiv).find('.card-body').find('[name=inoutType]').trigger('change');
        	}
        });
        
        $(componentDiv).find('.card-body').find('[name=inoutType]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').inoutType = $(this).val();
        	//targetType을 변경할 때 가장 마지막에 실행되는 inoutType Change 이벤트에서 이력 저장
        	setContainerHistory();
        });
        
        $(componentDiv).find('.card-body').find('[name=selectedTarget]').off('change').on('change', function() {
        	$(this).attr({'title': escapeHtml($(this).val())});
        	$(componentDiv).data('dataObj').monitorComponentTargets = [{pk: {componentId: $(componentDiv).data('dataObj').componentId, componentTargetId: $(this).val()}}];
        	setContainerHistory();
        });
        
        $(componentDiv).find('.card-body').find('[name=xViewYAxisMax]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').xViewYAxisMax = $(this).val();
        	setContainerHistory();
		});
        
        $(componentDiv).find('.card-body').find('[name=xViewTrans]').off('change').on('change', function() {
        	if($.isNumeric($(this).val())) $(this).val(Number($(this).val()).toFixed(1));
        	$(componentDiv).data('dataObj').xViewTrans = $(this).val();
        	setContainerHistory();
		});
        
        $(componentDiv).find('.card-body').find('[name=xViewMinData]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').xViewMinData = $(this).val();
        	setContainerHistory();
		});
        
        $(componentDiv).find('.card-body').find('[name=datatableRowCnt]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').datatableRowCnt = $(this).val();
        	setContainerHistory();
		});
        
        $(componentDiv).find('.card-body').find('[name=instanceSummaryColCnt]').off('change').on('change', function() {
        	$(componentDiv).data('dataObj').instanceSummaryColCnt = $(this).val();
        	setContainerHistory();
		});        
    };    
	
	function initNewComponent(componentDataObj) {
    	
        var componentDiv = $("<div/>").addClass('component');

        var card = $("<section/>").addClass('card');

        var perfItemInfo = _this.perfItemList.filter(function(perfItem) { return perfItem.itemId == componentDataObj.itemId })[0];

        var cardHeader = $("<h2/>").addClass('card-header');
        
		var perfItemLi = $("<li/>").addClass('nav-link');
		
		perfItemLi.append($("<i/>").addClass(perfItemInfo.itemIcon));
		perfItemLi.append(escapeHtml(perfItemInfo.itemName));
		
		cardHeader.append(perfItemLi);
        
        var perfItemInfo = _this.perfItemList.filter(function(perfItemInfo) { return perfItemInfo.itemId == componentDataObj.itemId })[0];
        var typeList = _this.getTypeList(perfItemInfo);
        
        var detailInfoHtml = '';
        
        detailInfoHtml += '<div class="widget-set">';
        detailInfoHtml += '	<div class="row">';
        detailInfoHtml += '		<div class="col-6">';
        detailInfoHtml += '			<div class="form-group">';
        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_name +'</label>';
        detailInfoHtml += '				<input type="text" name="componentName" class="form-control" value="' + componentDataObj.componentName + '">';
        detailInfoHtml += '			</div>';
        detailInfoHtml += '			<div class="form-group">';
        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_chartType +'</label>';
        detailInfoHtml += '				<select name="chartType" class="form-control">';
        
        typeList.chartTypeList.forEach(function(chartType) {
        	detailInfoHtml += '				<option value="' + chartType.value + '"  ' + ((chartType.value == componentDataObj.chartType)? 'selected' : '' ) + ' >' + escapeHtml(chartType.name) + '</option>';
        });
        
        detailInfoHtml += '				</select>';
        detailInfoHtml += '			</div>';
        detailInfoHtml += '		</div>';
        detailInfoHtml += '		<div class="col-6">';
        detailInfoHtml += '			<div class="form-group">';
        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_target +'</label>';
        detailInfoHtml += '				<select name="targetType" class="form-control">';
        
        typeList.targetTypeList.forEach(function(targetType) {
        	detailInfoHtml += '				<option value="' + targetType.value + '"  ' + ((targetType.value == componentDataObj.targetType)? 'selected' : '' ) + '  >' + escapeHtml(targetType.name) + '</option>';
        });
        
        detailInfoHtml += '				</select>';
        detailInfoHtml += '			</div>';
        
        if(0 < typeList.inoutTypeList.length) {
            detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_inoutType +'</label>';
            detailInfoHtml += '				<select name="inoutType" class="form-control">';
            typeList.inoutTypeList.forEach(function(inoutType) {
            	detailInfoHtml += '				<option value="' + inoutType.value + '"  ' + ((inoutType.value == 'IN')? 'selected' : '')+ '  >' + escapeHtml(inoutType.name) + '</option>';
            });            
            detailInfoHtml += '				</select>';
            detailInfoHtml += '			</div>';        	
        }
        
        if('XVIEW' == componentDataObj.chartType) {
            if(localStorage.getItem('xViewYAxisMax_' + componentDataObj.componentId)) componentDataObj.xViewYAxisMax = localStorage.getItem('xViewYAxisMax_' + componentDataObj.componentId);
	        else															     	  componentDataObj.xViewYAxisMax = xViewDefaultYAxisMax;
            
            if(localStorage.getItem('xViewTrans_' + componentDataObj.componentId)) componentDataObj.xViewTrans = localStorage.getItem('xViewTrans_' + componentDataObj.componentId);
	        else															   	   componentDataObj.xViewTrans = xViewDefaultTrans;
            
            if(localStorage.getItem('xViewMinData_' + componentDataObj.componentId)) componentDataObj.xViewMinData = localStorage.getItem('xViewMinData_' + componentDataObj.componentId);
	        else															   	     componentDataObj.xViewMinData = xViewDefaultxMinData;
            
        	detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewYAxisMax +'</label>';
            detailInfoHtml += '				<input type="text" name="xViewYAxisMax" class="form-control" maxlength="8" value="'+ componentDataObj.xViewYAxisMax +'">';
            detailInfoHtml += '			</div>';
            
            detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewTrans +'</label>';
            detailInfoHtml += '				<input type="text" name="xViewTrans" class="form-control" value="'+ componentDataObj.xViewTrans.toFixed(1) +'">';
            detailInfoHtml += '			</div>';
            
        	detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewMinData +'</label>';
            detailInfoHtml += '				<input type="text" name="xViewMinData" class="form-control" maxlength="8" value="'+ componentDataObj.xViewMinData +'">';
            detailInfoHtml += '			</div>';
        }
        
        if('DATATABLE' == componentDataObj.chartType) {
        	if(localStorage.getItem('datatableRowCnt_' + componentDataObj.componentId)) componentDataObj.datatableRowCnt = localStorage.getItem('datatableRowCnt_' + componentDataObj.componentId);
	        else															     	 	componentDataObj.datatableRowCnt = datatableDefaultRowCnt;
        	
        	detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_datatableRowCnt +'</label>';
            detailInfoHtml += '				<input type="text" name="datatableRowCnt" class="form-control" maxlength="2" value="'+ componentDataObj.datatableRowCnt +'">';
            detailInfoHtml += '			</div>';
        }
        
        if('INSTANCE' == componentDataObj.chartType) {
        	if(localStorage.getItem('instanceSummaryColCnt_' + componentDataObj.componentId)) componentDataObj.instanceSummaryColCnt = localStorage.getItem('instanceSummaryColCnt_' + componentDataObj.componentId);
	        else																	     	  componentDataObj.instanceSummaryColCnt = instanceSummaryDefaultColCnt;
        	
        	detailInfoHtml += '			<div class="form-group">';
            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_colCnt +'</label>';
            detailInfoHtml += '				<input type="text" name="instanceSummaryColCnt" class="form-control" maxlength="1" value="'+ componentDataObj.instanceSummaryColCnt +'">';
            detailInfoHtml += '			</div>';
        }
        
        detailInfoHtml += '		</div>';
        detailInfoHtml += '	</div>';
        detailInfoHtml += '</div>';        
        
        var cardBody = $("<div/>").addClass('card-body');
        
        $(cardBody).append($(detailInfoHtml));
        
        componentDiv.append(card.append(cardHeader).append(cardBody));

        componentDiv.append($("<div/>").addClass('componentDelete'));

        componentDiv.append($("<div/>").addClass('componentDroppable top').data('type', 't'));

        componentDiv.append($("<div/>").addClass('componentDroppable bottom').data('type', 'b'));

        componentDiv.append($("<div/>").addClass('componentDroppable left').data('type', 'l'));

        componentDiv.append($("<div/>").addClass('componentDroppable right').data('type', 'r'));
        
        return componentDiv;
    }    
	
    DashContainerConfigParent.prototype.initPlaceComponent = function() {
	    	
    	$("#containerBody").empty();
    	
		if(0 == _this.componentList.length) {
			$('#dashboard').find('#containerBody').append($(_this.getDashboardEmptyElement()));
    		return;
		}
		
		appendComponentTag(_this.componentList.filter(function(componentObj) { return '-1' == componentObj.pComponentId })[0], $("#containerBody"));
		
		appendComponentEvtBind($("#root"));
		
	    function appendComponentTag(pComponentObj, parentTag) {
	    	
	    	var appendDiv = null;
	    	
	    	var componentWidth = pComponentObj.componentWidth;
	    	var componentHeight = pComponentObj.componentHeight; 
	    	var componentType = pComponentObj.componentType;
	    	
	    	if('-1' == pComponentObj.pComponentId) {
	    		appendDiv = $("<div/>").attr({'id': 'root'}).css({'width': componentWidth, 'height': componentHeight}).data('dataObj', pComponentObj);
	    		parentTag.append(appendDiv);
	    	}else if('h' == pComponentObj.componentTypeDirection || 'v' == pComponentObj.componentTypeDirection) {
	    		appendDiv = $("<div/>").addClass('component-' + (('h' == pComponentObj.componentTypeDirection)? 'horizontal' : 'vertical')).css({'width': componentWidth, 'height': componentHeight}).data('dataObj', pComponentObj);
	    		parentTag.append(appendDiv);
	    	}
	    	
	    	var childComponentList = _this.componentList.filter(function(childComponent) { return childComponent.pComponentId == pComponentObj.componentId })
	    								                .sort(function(a, b) { return a.componentOrder - b.componentOrder; });
	    	
	    	if(0 < childComponentList.length) {
	    		childComponentList.forEach(function(childComponent) {
	    			if('G' == childComponent.componentType) {
	    				appendComponentTag(childComponent, appendDiv);
	    			}else{
	
	    		        var componentDiv = $("<div/>").addClass('component').css({'width': childComponent.componentWidth, 'height': childComponent.componentHeight}).data('dataObj', childComponent);
	    		        
	    		        var card = $("<section/>").addClass('card');
	    		        
	    		        var perfItemInfo = _this.perfItemList.filter(function(perfItem) { return perfItem.itemId == childComponent.itemId })[0];
	    		        
	    		        var cardHeader = $("<h2/>").addClass('card-header');
	    		        
	    				var perfItemLi = $("<li/>").addClass('nav-link');
	    				
	    				perfItemLi.append($("<i/>").addClass(perfItemInfo.itemIcon));
	    				
	    				if('modify' == _this.mod) {
	    					var originComponent = _this.containerHistoryList[0].saveComponentList.filter(function(component){ return component.componentId == childComponent.componentId; })[0];	    					
		    				perfItemLi.append($("<span/>").text((originComponent)? originComponent.componentName : perfItemInfo.itemName));
	    				} else if('add' == _this.mod) {
		    				perfItemLi.append($("<span/>").text(perfItemInfo.itemName));
	    				}
	    				
	    				cardHeader.append(perfItemLi);    		        
	    		        
	    		        var perfItemInfo = _this.perfItemList.filter(function(perfItemInfo) { return perfItemInfo.itemId == childComponent.itemId })[0];
	    		        
	    		        var typeList = _this.getTypeList(perfItemInfo);
	    		        
	    		        var detailInfoHtml = '';
	    		        
	    		        detailInfoHtml += '<div class="widget-set">';
	    		        detailInfoHtml += '	<div class="row">';
	    		        detailInfoHtml += '		<div class="col-6">';
	    		        detailInfoHtml += '			<div class="form-group">';
	    		        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_name +'</label>';
	    		        detailInfoHtml += '				<input type="text" name="componentName" class="form-control" value="' + childComponent.componentName + '">';
	    		        detailInfoHtml += '			</div>';
	    		        detailInfoHtml += '			<div class="form-group">';
	    		        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_chartType +'</label>';
	    		        detailInfoHtml += '				<select name="chartType" class="form-control">';
	    		        
	    		        typeList.chartTypeList.forEach(function(chartType) {
	    		        	detailInfoHtml += '				<option value="' + chartType.value + '"  ' + ((chartType.value == childComponent.chartType)? 'selected' : '') + ' >' + escapeHtml(chartType.name) + '</option>';
	    		        });
	    		        
	    		        detailInfoHtml += '				</select>';
	    		        detailInfoHtml += '			</div>';
	    		        detailInfoHtml += '		</div>';
	    		        detailInfoHtml += '		<div class="col-6">';
	    		        detailInfoHtml += '			<div class="form-group">';
	    		        detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_target +'</label>';
	    		        detailInfoHtml += '				<select name="targetType" class="form-control">';
	    		        
	    		        typeList.targetTypeList.forEach(function(targetType) {
	    		        	detailInfoHtml += '				<option value="' + targetType.value + '"  ' + ((targetType.value == childComponent.targetType)? 'selected' : '') + ' >' + escapeHtml(targetType.name) + '</option>';
	    		        });
	    		        
	    		        detailInfoHtml += '				</select>';        		        
	    		       
	    		        if('EXTERNALLINE' == childComponent.targetType) {
	    	    			detailInfoHtml += '';
	    	    		}else if('INSTANCE' != childComponent.targetType) {
	
	        		        detailInfoHtml += '				<select name="selectedTarget" class="form-control" title="' + escapeHtml(childComponent.monitorComponentTargets[0].pk.componentTargetId) + '">';
	        		        
	                		if('ADAPTER' == childComponent.targetType) {
	                			_this.adapterList.forEach(function(adapterInfo) { 
	                				detailInfoHtml += '			<option value="' + adapterInfo.adapterId + '"  ' + ((adapterInfo.adapterId == childComponent.monitorComponentTargets[0].pk.componentTargetId)? 'selected' : '') + ' >' + escapeHtml(adapterInfo.adapterId) + '</option>';
	                			});
	                		}else if('CONNECTOR' == childComponent.targetType)	{
	                			_this.connectorList.forEach(function(connectorInfo) { 
	                				detailInfoHtml += '			<option value="' + connectorInfo.connectorId + '"  ' + ((connectorInfo.connectorId == childComponent.monitorComponentTargets[0].pk.componentTargetId)? 'selected' : '') + ' >' + escapeHtml(connectorInfo.connectorId) + '</option>';
	                			});
	                		}
	                		else if('QUEUE' == childComponent.targetType) {
	                			_this.queueList.forEach(function(queueInfo) { 
	                				detailInfoHtml += '			<option value="' + queueInfo.adapterId + '"  ' + ((queueInfo.adapterId == childComponent.monitorComponentTargets[0].pk.componentTargetId)? 'selected' : '') + ' >' + escapeHtml(queueInfo.adapterId) + '</option>';
	                			});        			
	                		}
	                		else if('THREAD' == childComponent.targetType) {
	                			_this.threadList.forEach(function(threadInfo) { 
	                				detailInfoHtml += '			<option value="' + threadInfo.threadPoolId + '"  ' + ((threadInfo.threadPoolId == childComponent.monitorComponentTargets[0].pk.componentTargetId)? 'selected' : '') + ' >' + escapeHtml(threadInfo.threadPoolId) + '</option>';
	                			});
	                		}        		        
	        		        
	        		        detailInfoHtml += '				</select>';
	    		        }
	    		        
	    		        detailInfoHtml += '			</div>';
	    		        
	    		        if(0 < typeList.inoutTypeList.length) {
	    		            detailInfoHtml += '			<div class="form-group">';
	    		            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_inoutType +'</label>';
	    		            
	    		            if('INSTANCE' == childComponent.targetType) {
	    		            	detailInfoHtml += '				<select name="inoutType" class="form-control" disabled="disabled">';
	    		            }else{
	    		            	detailInfoHtml += '				<select name="inoutType" class="form-control">';	
	    		            }
	    		            
	    		            typeList.inoutTypeList.forEach(function(inoutType) {
	    		            	detailInfoHtml += '				<option value="' + inoutType.value + '"  ' + ((inoutType.value == childComponent.inoutType)? 'selected' : '') + ' >' + escapeHtml(inoutType.name) + '</option>';
	    		            });            
	    		            
	    		            detailInfoHtml += '				</select>';
	    		            detailInfoHtml += '			</div>';        	
	    		        }
	    		        
	    		        if('XVIEW' == childComponent.chartType) {
	    		        	
	    		        	if('modify' == _this.mod) {
	    		        		if(!childComponent.xViewYAxisMax) 		 childComponent.xViewYAxisMax = (localStorage.getItem('xViewYAxisMax_' + childComponent.componentId))? localStorage.getItem('xViewYAxisMax_' + childComponent.componentId) : xViewDefaultYAxisMax;
		    		        	if(!childComponent.xViewTrans) 			 childComponent.xViewTrans = (localStorage.getItem('xViewTrans_' + childComponent.componentId))? localStorage.getItem('xViewTrans_' + childComponent.componentId) : xViewDefaultTrans;
		    		        	if(!childComponent.xViewDefaultxMinData) childComponent.xViewMinData = (localStorage.getItem('xViewMinData_' + childComponent.componentId))? localStorage.getItem('xViewMinData_' + childComponent.componentId) : xViewDefaultxMinData;;
		    				} 
	    		        	
	    		        	detailInfoHtml += '			<div class="form-group">';
	    		            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewYAxisMax +'</label>';
	    		            detailInfoHtml += '				<input type="text" name="xViewYAxisMax" class="form-control" maxlength="8" value="'+ childComponent.xViewYAxisMax +'">';
	    		            detailInfoHtml += '			</div>';
	
	    		        	detailInfoHtml += '			<div class="form-group">';
	    		            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewTrans +'</label>';
	    		            detailInfoHtml += '				<input type="text" name="xViewTrans" class="form-control" value="'+ Number(childComponent.xViewTrans).toFixed(1) +'">';
	    		            detailInfoHtml += '			</div>';
	    		            
	    		        	detailInfoHtml += '			<div class="form-group">';
	    		            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_xViewMinData +'</label>';
	    		            detailInfoHtml += '				<input type="text" name="xViewMinData" class="form-control" maxlength="8" value="'+ childComponent.xViewMinData +'">';
	    		            detailInfoHtml += '			</div>';
	    		        }
	    		        
	    		        if('DATATABLE' == childComponent.chartType) {
	    		            
	    		        	if('modify' == _this.mod && !childComponent.datatableRowCnt) 
	    		        		childComponent.datatableRowCnt = (localStorage.getItem('datatableRowCnt_' + childComponent.componentId))? localStorage.getItem('datatableRowCnt_' + childComponent.componentId) : datatableDefaultRowCnt;
	    		        	
	    		        	detailInfoHtml += '			<div class="form-group">';
	    		            detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_datatableRowCnt +'</label>';
	    		            detailInfoHtml += '				<input type="text" name="datatableRowCnt" class="form-control" maxlength="2" value="'+ childComponent.datatableRowCnt +'">';
	    		            detailInfoHtml += '			</div>';
	    		        }
	    		        
	    		        if('INSTANCE' == childComponent.chartType) {
	    		        	
	    		        	if('modify' == _this.mod && !childComponent.instanceSummaryColCnt) 
	    		        		childComponent.instanceSummaryColCnt = (localStorage.getItem('instanceSummaryColCnt_' + childComponent.componentId))? localStorage.getItem('instanceSummaryColCnt_' + childComponent.componentId) : instanceSummaryDefaultColCnt;
	    		        	
	    		        	detailInfoHtml += '			<div class="form-group">';
	    		        	detailInfoHtml += '				<label class="control-label">'+ dashboardLabel_colCnt +'</label>';
	    		        	detailInfoHtml += '				<input type="text" name="instanceSummaryColCnt" class="form-control" maxlength="1" value="'+ childComponent.instanceSummaryColCnt +'">';
	    		        	detailInfoHtml += '			</div>';	    		        	
	    		        }
	    		        
	    		        detailInfoHtml += '		</div>';
	    		        detailInfoHtml += '	</div>';
	    		        detailInfoHtml += '</div>';        
	    		        
	    		        var cardBody = $("<div/>").addClass('card-body').css('padding-top', 0);
	    		        
	    		        $(cardBody).append($(detailInfoHtml));
	    		        
	    		        componentDiv.append(card.append(cardHeader).append(cardBody));
	    		        
	    		        componentDiv.append($("<div/>").addClass('componentDelete'));
	
	    		        componentDiv.append($("<div/>").addClass('componentDroppable top').data('type', 't'));
	
	    		        componentDiv.append($("<div/>").addClass('componentDroppable bottom').data('type', 'b'));
	
	    		        componentDiv.append($("<div/>").addClass('componentDroppable left').data('type', 'l'));
	
	    		        componentDiv.append($("<div/>").addClass('componentDroppable right').data('type', 'r'));
	    				
	    				appendDiv.append(componentDiv);
	    			}
	    		});
	    	}
	    }
	    
	    function appendComponentEvtBind(parentTag) {
	    	$.each(parentTag.children(), function(index, element) {
				if($(element).hasClass('component-vertical') || $(element).hasClass('component-horizontal')) {
					_this.initResizable($(element));
					
					if(0 < parentTag.children().length) {
						appendComponentEvtBind($(element));
					}
				}else if($(element).hasClass('component')) {
		            _this.initDroppable($(element));
		            _this.initResizable($(element));
		            _this.initDelete($(element));
		            _this.initChange($(element));
				}
			});
	    }
	}
    
	function getDefaultType(perfItemObj) {
    	
    	var chartType = 'NONE';
    	var targetType = 'NONE';
    	var unitType = perfItemObj.unitType;
    	var inoutType = 'NONE'
    	
    	//chart
        var chartTypeArr = ['LINE', 'COLUMN', 'INSTANCE', 'CONNECTOR', 'QUEUE', 'THREAD', 'SPEEDBAR', 'EXTERNALLINE', 'DATATABLE', 'XVIEW'];
        
        for(var i = 0; i < chartTypeArr.length; i++) {
        	
        	var tmpChartTypeArr = perfItemObj.monitorChartGroup.filter(function(chartGroupInfo) {
        		return chartTypeArr[i] == chartGroupInfo.pk.chartType;
        	});
        	
        	if(0 == tmpChartTypeArr.length) continue;
        	
        	chartType = tmpChartTypeArr[0].pk.chartType;
       
        	break;
        }
        
        //target
        var targetTypeArr = ['INSTANCE', 'ADAPTER', 'CONNECTOR', 'QUEUE', 'THREAD', 'EXTERNALLINE', 'DATATABLE'];
        
        for(var i = 0; i < targetTypeArr.length; i++) {
        	
        	var tmpTargetTypeArr = perfItemObj.monitorTargetGroup.filter(function(targetGroupInfo) {
        		return targetTypeArr[i] == targetGroupInfo.pk.targetType;
        	});
        	
        	if(0 == tmpTargetTypeArr.length) continue;
        	
        	targetType = tmpTargetTypeArr[0].pk.targetType;
        	
        	break;
        }
        
    	//in out
    	if('Y' == perfItemObj.inOutExistYn) {
    		inoutType = 'IN';
    	}
        
        return {
        	chartType: chartType, 
        	targetType: targetType, 
        	unitType: unitType, 
        	inoutType: inoutType
        };
    }
	
    function setContainerHistory() {    	
    	var sortedContainerStateList = _this.containerHistoryList.map(function(containerState) { return $.extend(true, {}, containerState); })
		   												       .sort(function(a, b){ return a.saveTime - b.saveTime });    	

    	var findIndex = sortedContainerStateList.findIndex(function(containerState) {
    		return containerState.saveTime == _this.currentContainerHistory.saveTime;
    	});
    	
    	if(-1 < findIndex && findIndex != _this.containerHistoryList.length - 1) {
    		_this.containerHistoryList.splice(findIndex + 1);
    		$('#undoContainer').attr('disabled', true);
    	}
    	
    	_this.containerHistoryList.push({
			'saveTime': Date.now(),
			'saveComponentList': _this.componentList.map(function(component) { return $.extend(true, {}, component); })
    	});
    	
    	if(containerStateCnt == _this.containerHistoryList.length) 
    		_this.containerHistoryList.shift();
    	
    	$('#redoContainer').attr('disabled', 1 >= _this.containerHistoryList.length);

    	if(_this.currentContainerHistory.saveComponentList)
    		_this.currentContainerHistory.saveComponentList.splice(0, _this.currentContainerHistory.saveComponentList.length);
    	
    	$.extend(true, _this.currentContainerHistory, _this.containerHistoryList[_this.containerHistoryList.length - 1]);
    }
    
    function setContainerState() {
    	var btnId = $(this).attr('id');

    	var sortedContainerStateList = _this.containerHistoryList.map(function(containerState) { return $.extend(true, {}, containerState); })
    														   .sort(function(a, b){ return a.saveTime - b.saveTime });
    	
    	var findIndex = sortedContainerStateList.findIndex(function(containerState) {
    		return containerState.saveTime == _this.currentContainerHistory.saveTime;
    	});
    	
    	$('#redoContainer').attr('disabled', ('redoContainer' == btnId)?  (0 == findIndex - 1)  : false);
    	$('#undoContainer').attr('disabled', ('redoContainer' == btnId)?  false 				: (sortedContainerStateList.length - 1 == findIndex + 1)); 

    	var tmpCurrentSaveContainer = ('redoContainer' == btnId)? sortedContainerStateList[findIndex - 1] : sortedContainerStateList[findIndex + 1];

    	if(_this.currentContainerHistory.saveComponentList)
    		_this.currentContainerHistory.saveComponentList.splice(0, _this.currentContainerHistory.saveComponentList.length);
    	
    	$.extend(true, _this.currentContainerHistory, tmpCurrentSaveContainer);
    	
    	_this.componentList.splice(0, _this.componentList.length);
    	
    	Array.prototype.push.apply(_this.componentList, _this.currentContainerHistory.saveComponentList.map(function(component) { return $.extend(true, {}, component); }));
    	
    	_this.initPlaceComponent();
    }
}

DashContainerConfigParent.prototype = Object.create(DashContainerParent.prototype);
DashContainerConfigParent.prototype.constructor = DashContainerConfigParent;