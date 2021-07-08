$.fn.dashContainer = function(option) {
	
	var dashObj = null;
	
	var dashContainerElement = this;
	
    function DashContainer() {
    	
    	if('add' == option.mod)			 dashObj = new DashContainerAdd(dashContainerElement, option);
    	else if('modify' == option.mod)	 dashObj = new DashContainerModify(dashContainerElement, option);
    	else if('view' == option.mod)	 dashObj = new DashContainerView(dashContainerElement, option);
    	
    	if(null == dashObj)	throw new Error('error >>>> not exist dashObj');
    	
    	if('undefined' == typeof(dashObj.initDashMode)) throw new Error('error >>>> not exist initDashMode');
    	
    	dashObj.initDashMode();
    }
    
    customResizeFunc = function() {
    	if(!dashObj.customResizeFunc) return;
    	dashObj.customResizeFunc();
    };
    
    return new DashContainer();
}