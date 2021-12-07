<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div id="panel" class="panel panel-bottom" data-backdrop="false">
	<div class="panel-dialog">
		<div class="panel-content">
			<header id="panel-header" class="panel-header sub-bar">
				<a href="javascript:void(0);" class="btn btn-icon updateGroup backBtn" title="<fmt:message>common.go.back</fmt:message>" v-on:click="goPreviousPanel"><i class="icon-left"></i></a>
				<h2 class="sub-bar-tit"></h2>
				<div class="ml-auto">
					<button type="button" class="btn-icon" v-on:click="togglePanel" data-toggle="toggle" data-target="#panel" data-class="expand"><i class="icon-expand"></i></button>
					<button type="button" class="btn-icon" v-on:click="closePanel"><i class="icon-close"></i></button>
				</div>
			</header>
			
			<ul class="nav nav-tabs flex-shrink-0">
				<li class="nav-item-origin" style="display: none">
					<a class="nav-link" href="#bass-info" data-toggle="tab"></a>
				</li>
				<li class="nav-item" id="item-result-parent">
					<a class="nav-link" href="#process-result" data-toggle="tab" id="item-result" ><fmt:message>head.process.result</fmt:message></a>
				</li>
			</ul>
			
			<div class="panel-body tab-content">			
				<div class="form-group form-group-origin">
					<label class="control-label"></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" style="display: none;">
						<select class="form-control view-disabled" style="display: none;"></select>
						<textarea class="form-control view-disabled" style="display: none;"></textarea>
						<span type="password" style="width:100%; display: none;">
							<input class="form-control view-disabled" style="display: inline; width: calc(100% - 1.8rem);">
							<i class="icon-eye" style="font-size: 1.5rem;cursor: pointer;"></i>
						</span>
						<span type="datalist" style="width:100%; display: none;">
							<input type="text" class="form-control view-disabled"> 
							<datalist></datalist>			
						</span>
						<div class="input-group-append" style="display: none;">
							<button type="button" class="btn" id="lookupBtn"><i class="icon-srch"></i><fmt:message>head.search</fmt:message></button>
							<button type="button" class="btn" id="resetBtn" style="margin-left: 5px; min-width: 0px;"><i class="icon-reset" style="margin-right: 0px;"></i></button>
						</div>
					</div>
				</div>
				<div class="tab-pane" id="process-result">
					<ul id="accordionResult" class="collapse-list collapse-list-result m-0" style="display: none">
						<li class="collapse-item-origin" style="display: none">
							<button class="collapse-link collapsed" type="button" data-toggle="collapse" data-target="#collapseResult">
								<i class="iconb-compt mr-2"></i><span class="txt"></span>
							</button>
							<div id="collapseResult" class="collapse" data-parent="#accordionResult">
								<div class="collapse-content"></div>
							</div>
						</li>	
					</ul>
				</div>
			</div>
			
			<footer id="panel-footer" class="panel-footer sub-bar">
				<div class="ml-auto">
					<a href="javascript:void(0);" id="restoreMetaBtn"  class="btn btn-primary"							style="display: none;"    v-on:click="restoreMeta"><fmt:message>common.metaHistory.restore</fmt:message></a>
					<a href="javascript:void(0);" id="downloadBtn" 	   class="btn detail"							    style="display: none;"    v-on:click="downloadFile"><fmt:message>head.download</fmt:message></a>	
					<a href="javascript:void(0);" id="migrationBtn"    class="btn detail btn-primary" 					style="display: none;"    v-on:click="migration"><fmt:message>head.migration</fmt:message></a>				
					<a href="javascript:void(0);" id="guideBtn"    	   class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="guide"><fmt:message>igate.connector.guide</fmt:message></a>
					<a href="javascript:void(0);" id="startBtn"    	   class="btn viewGroup" 	    				   	style="display: none;"    v-on:click="start"><i class="icon-play"></i><fmt:message>head.execute</fmt:message></a>
					<a href="javascript:void(0);" id="stopBtn"    	   class="btn viewGroup" 	    		           	style="display: none;"    v-on:click="stop"><i class="icon-pause"></i><fmt:message>head.stop</fmt:message></a>
					<a href="javascript:void(0);" id="stopForceBtn"    class="btn viewGroup"    		        	   	style="display: none;"    v-on:click="stopForce"><i class="icon-x"></i><fmt:message>head.stop.force</fmt:message></a>
					<a href="javascript:void(0);" id="interruptBtn"    class="btn viewGroup"    			           	style="display: none;"    v-on:click="interrupt"><fmt:message>head.interrupt</fmt:message></a>
					<a href="javascript:void(0);" id="blockBtn"    	   class="btn viewGroup"    			           	style="display: none;"    v-on:click="block"><fmt:message>head.block</fmt:message></a>
					<a href="javascript:void(0);" id="unblockBtn"      class="btn viewGroup"    				       	style="display: none;"    v-on:click="unblock"><fmt:message>head.unblock</fmt:message></a>
					<a href="javascript:void(0);" id="loadBtn"    	   class="btn detail loadBtn" 				       	style="display: none;"    v-on:click="loadInfo"><fmt:message>head.load</fmt:message></a>
					<a href="javascript:void(0);" id="dumpBtn"         class="btn viewGroup dumpBtn" 				   	style="display: none;"    v-on:click="dumpInfo"><fmt:message>head.dump</fmt:message></a>	
					<a href="javascript:void(0);" id="removeBtn"       class="btn viewGroup removeBtn" 		  		   	style="display: none;"    v-on:click="removeInfo"><i class="icon-delete"></i><fmt:message>head.delete</fmt:message></a>
					<a href="javascript:void(0);" id="goModBtn"        class="btn viewGroup goModBtn" 		  		   	style="display: none;"    v-on:click="goModifyPanel"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>						
					<a href="javascript:void(0);" id="saveBtn"         class="btn btn-primary saveGroup saveBtn" 	   	style="display: none;"    v-on:click="saveInfo"><fmt:message>head.insert</fmt:message></a>
					<a href="javascript:void(0);" id="updateBtn"       class="btn btn-primary updateGroup updateBtn"   	style="display: none;"    v-on:click="updateInfo"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>
					<a href="javascript:void(0);" id="goAddBtn"        class="btn btn-primary viewGroup goAddBtn" 	 	style="display: none;"    v-on:click="goAddInfo" ><i class="icon-plus"></i><fmt:message>head.insert</fmt:message>(<fmt:message>head.copy</fmt:message>)</a>		
				</div>
			</footer>
			
		</div>
	</div>
</div>

<script type="text/javascript">
var panelMethodOption = {
	goPreviousPanel: function() {
		var rowKey = SearchImngObj.searchGrid.getFocusedCell().rowKey;
		
   		if ('number' === typeof rowKey && -1 < rowKey) {
   			SearchImngObj.clicked(SearchImngObj.searchGrid.getRow(rowKey));
   		}else {
   			panelOpen('detail');
   		}
   	},
   	goDetailPanel: function() {
   		panelOpen('detail');
   	},
   	goModifyPanel: function() {
   		panelOpen('mod');
   	},
   	goAddInfo: function() {
   		panelOpen('add',window.vmMain.object);
   	},
   	togglePanel: function() {
   		windowResizeSearchGrid();
   		
   		if(customResizeFunc)
   			customResizeFunc();
   	},
   	closePanel: function() {
   		panelClose('panel');
   	}, 	
   	dumpInfo: function() {
   		ControlImngObj.dump();
   	},
   	removeInfo: function() {
   		SaveImngObj.remove('<fmt:message>head.delete.conform</fmt:message>', '<fmt:message>head.delete.notice</fmt:message>');
   	},
   	updateInfo: function() {
   		SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
   	},
   	saveInfo: function() {
   		SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
   	}
};

new Vue({
	el: '#panel-header',
	methods : $.extend(true, {}, panelMethodOption)
});
</script>