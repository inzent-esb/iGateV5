<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="panel" class="panel panel-bottom" data-backdrop="false">
	<div class="panel-dialog">
		<div class="panel-content">
			<div class="resize-bar"></div>
			
			<header id="panel-header" class="panel-header sub-bar">
				<a href="javascript:void(0);" class="btn btn-icon updateGroup backBtn" title="<fmt:message>common.go.back</fmt:message>" v-on:click="goPreviousPanel"><i class="icon-left"></i></a>
				<h2 class="sub-bar-tit"></h2>
				<div class="ml-auto">
					<button type="button" class="btn-change-layout-horizon btn-icon" v-on:click="changeLayout('vertical')" title="<fmt:message>common.detail.horizontal.view</fmt:message>">
						<img src="${prefixFileUrl}/img/horizontal.svg" class="center-block" />
					</button>
					<button type="button" class="btn-change-layout-vertical btn-icon" v-on:click="changeLayout('horizon')" title="<fmt:message>common.detail.vertical.view</fmt:message>">
						<img src="${prefixFileUrl}/img/vertical.svg" class="center-block" />
					</button>				
					<button type="button" class="btn-icon" v-on:click="togglePanel" data-toggle="toggle" data-target="#panel" data-class="expand"><i class="icon-expand"></i></button>
					<button type="button" class="btn-icon" v-on:click="closePanel"><i class="icon-close"></i></button>
				</div>
			</header>
			
			<ul class="nav nav-tabs flex-shrink-0">
				<li class="nav-item-origin" style="display: none">
					<a class="nav-link" href="#bass-info" data-toggle="tab"></a>
				</li>
				<li class="nav-item" id="item-result-parent">
					<a class="nav-link" href="#process-result" data-toggle="tab" id="item-result" ><fmt:message>head.executionResult</fmt:message></a>
				</li>
			</ul>
			
			<div class="panel-body tab-content">			
				<div class="form-group form-group-origin">
					<label class="control-label"></label>
					<div class="input-group">
						<input type="text" class="form-control view-disabled" style="display: none;">
						<input type="radio" class="form-control view-disabled" style="display: none;">
						<input type="checkbox" class="form-control view-disabled" style="display: none;">
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
						<div type="radio" style="display: none;" />
						<div type="checkbox" style="display: none;" />
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
								<i class="iconb-compt mr-2"></i>
								<span class="txt"></span>
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
					<a href="javascript:void(0);" id="guideBtn"    	   class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="guide"		title="<fmt:message>igate.connector.guide</fmt:message>"><fmt:message>igate.connector.guide</fmt:message></a>
					<a href="javascript:void(0);" id="externalGuideBtn"class="btn viewGroup saveGroup updateGroup"	    style="display: none;"    v-on:click="externalGuide"title="<fmt:message>igate.external.guide</fmt:message>"><fmt:message>igate.external.guide</fmt:message></a>
					<a href="javascript:void(0);" id="dumpBtn"   	   class="btn viewGroup"    		        	   	style="display: none;"    v-on:click="dump"		 	title="<fmt:message>head.dump</fmt:message>"><fmt:message>head.dump</fmt:message></a>
					<a href="javascript:void(0);" id="startBtn"        class="viewGroup btn btn-m"    				    style="display: none;" 	  v-on:click="start" 		title="<fmt:message>head.execute</fmt:message>"><i class="icon-play"></i><fmt:message>head.execute</fmt:message></a>			
					<a href="javascript:void(0);" id="stopBtn"    	   class="btn viewGroup" 	    		           	style="display: none;"    v-on:click="stop"		 	title="<fmt:message>head.stop</fmt:message>"><i class="icon-pause"></i><fmt:message>head.stop</fmt:message></a>
					<a href="javascript:void(0);" id="stopForceBtn"    class="btn viewGroup"    		        	   	style="display: none;"    v-on:click="stopForce" 	title="<fmt:message>head.stop.force</fmt:message>"><i class="icon-x"></i><fmt:message>head.stop.force</fmt:message></a>
					<a href="javascript:void(0);" id="interruptBtn"    class="viewGroup btn btn-m"    				 	style="display: none;" 	  v-on:click="interrupt" 	title="<fmt:message>head.interrupt</fmt:message>"><fmt:message>head.interrupt</fmt:message></a>
					<a href="javascript:void(0);" id="blockBtn" 	   class="viewGroup btn btn-m"    				 	style="display: none;" 	  v-on:click="block"		title="<fmt:message>head.block</fmt:message>"><fmt:message>head.block</fmt:message></a>
					<a href="javascript:void(0);" id="unblockBtn" 	   class="viewGroup btn btn-m"   				 	style="display: none;" 	  v-on:click="unblock" 		title="<fmt:message>head.unblock</fmt:message>"><fmt:message>head.unblock</fmt:message></a>					
					<a href="javascript:void(0);" id="removeBtn"       class="btn viewGroup removeBtn" 		  		   	style="display: none;"    v-on:click="removeInfo"	title="<fmt:message>head.delete</fmt:message>"><i class="icon-delete"></i><fmt:message>head.delete</fmt:message></a>
					<a href="javascript:void(0);" id="goModBtn"        class="btn viewGroup goModBtn" 		  		   	style="display: none;"    v-on:click="goModifyPanel"title="<fmt:message>head.update</fmt:message>"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>						
					<a href="javascript:void(0);" id="saveBtn"         class="btn btn-primary saveGroup saveBtn" 	   	style="display: none;"    v-on:click="saveInfo"		title="<fmt:message>head.insert</fmt:message>"><fmt:message>head.insert</fmt:message></a>
					<a href="javascript:void(0);" id="updateBtn"       class="btn btn-primary updateGroup updateBtn"   	style="display: none;"    v-on:click="updateInfo"	title="<fmt:message>head.update</fmt:message>"><i class="icon-edit"></i><fmt:message>head.update</fmt:message></a>
					<a href="javascript:void(0);" id="goAddBtn"        class="btn btn-primary viewGroup goAddBtn" 	 	style="display: none;"    v-on:click="goAddInfo" 	title="<fmt:message>head.insert</fmt:message>"><i class="icon-plus"></i><fmt:message>head.insert</fmt:message>(<fmt:message>head.copy</fmt:message>)</a>		
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
   		panelOpen('modify');
   	},
   	goAddInfo: function() {
   		panelOpen('add', window.vmMain.object);
   	},
   	togglePanel: function() {
		beforeDragEvt = null;

		if (document.querySelector('#panel').classList.contains('horizon')) {
			panelContentStyle.width = null;
			panelContentStyle['margin-left'] = null;

			document.querySelector('#panel .panel-content').style.width = null;
			document.querySelector('#panel .panel-content').style['margin-left'] = null;
			
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';
		} else {
			panelContentStyle.height = null;
			
			document.querySelector('#panel .panel-content').style.height = null;
		}
		
		localStorage.setItem(
			'detailLayoutInfo_' + menuId,
			JSON.stringify({
				panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
				panelContentStyle: panelContentStyle,
				screenType: screenType,
			})
		);
		
   		$('#panel').toggleClass('expand');
		
   		windowResizeSearchGrid();
   	},
   	closePanel: function() {
   		panelClose('panel');
   		
		if (document.querySelector('#panel').classList.contains('horizon')) {
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';	
		}   		
   	}, 	
   	removeInfo: function() {
   		SaveImngObj.remove('<fmt:message>dashboard.delete.warn</fmt:message>', '<fmt:message>dashboard.delete.success</fmt:message>', this.closePanel);
   	},
   	updateInfo: function() {
   		SaveImngObj.update('<fmt:message>head.update.notice</fmt:message>');
   	},
   	saveInfo: function() {
   		SaveImngObj.insert('<fmt:message>head.insert.notice</fmt:message>');
   	},
   	load: function() {
   		ControlImngObj.load();
   	},
   	dump: function() {
   		ControlImngObj.dump();
   	},
   	changeLayout: function(type) {
   		beforeDragEvt = null;
   		
		document.querySelector('#panel').classList.remove('horizon', 'vertical');
		document.querySelector('#panel').classList.add('vertical' === type ? 'vertical' : 'horizon');
		
		panelContentStyle.width = null;
		panelContentStyle.height = null;
		panelContentStyle['margin-left'] = null;
		
		document.querySelector('#panel .panel-content').style.width = panelContentStyle.width;
		document.querySelector('#panel .panel-content').style.height = panelContentStyle.height;
		document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];
	
		var isModMode = $('body').hasClass('panel-open-mod');
		
		if (document.querySelector('#panel .sub-bar-tit'))
			document.querySelector('#panel .sub-bar-tit').style.width = 'calc(100% - ' + (isModMode ? 170 : 125) + 'px)';
		
		if (document.querySelector('#panel .sub-bar-selected-tit'))
			document.querySelector('#panel .sub-bar-selected-tit').style.width = 'calc(100% - ' + (isModMode ? 80 : 65) + 'px)';	 	
		
		if (document.querySelector('#panel').classList.contains('vertical')) {
			document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
			document.querySelector('.customLayout > [data-ready]').style.width = null;				
		} else {
			document.querySelector('.customLayout > [data-ready]').classList.add('horizon');
			document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';
		}		
		
		localStorage.setItem(
			'detailLayoutInfo_' + menuId,
			JSON.stringify({
				panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
				panelContentStyle: panelContentStyle,
				screenType: screenType,
			})
		);
		
		windowResizeSearchGrid();
		
		$('[data-ready]').each(function (index, element) {
			element.dispatchEvent(new CustomEvent('resize'));
		});		
   	}
};

document.querySelector('#panel').addEventListener('detailReady', detailReady);
document.querySelector('#panel').addEventListener('detailDestroy', detailDestroy);	

var panelContentStyle = { 'width': null, 'height': null, 'margin-left': null };
var beforeDragEvt = null;
var screenType = null;
var selectedMenuPathIdList = JSON.parse(sessionStorage.getItem('selectedMenuPathIdList'));
var menuId = selectedMenuPathIdList[selectedMenuPathIdList.length - 1].split('_')[0];

function detailReady() {
	screenType = 991 < window.innerWidth ? 'pc' : 767 < window.innerWidth ? 'tablet' : 'mobile';
	
	if (localStorage.getItem('detailLayoutInfo_' + menuId)) {
		var detailLayoutInfo = JSON.parse(localStorage.getItem('detailLayoutInfo_' + menuId));

		if (screenType !== detailLayoutInfo.screenType) {
			initDefaultDetailLayoutInfo();
		} else {
			document.querySelector('#panel').classList.remove('horizon', 'vertical');
			document.querySelector('#panel').classList.add('vertical' === detailLayoutInfo.panelLayoutDirection? 'vertical' : 'horizon');
			
			panelContentStyle = detailLayoutInfo.panelContentStyle;
			
			document.querySelector('#panel .panel-content').style.width = panelContentStyle.width? panelContentStyle.width + 'px' : null;
			document.querySelector('#panel .panel-content').style.height = panelContentStyle.height? panelContentStyle.height + 'px' : null;
			document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left']? panelContentStyle['margin-left'] : null;
			
			if (document.querySelector('#panel').classList.contains('vertical')) {
				document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
				document.querySelector('.customLayout > [data-ready]').style.width = null;				
			} else {
				document.querySelector('.customLayout > [data-ready]').classList.add('horizon');
				document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - (null === panelContentStyle.width? 500 : panelContentStyle.width) + 'px';
			}			
		}
	} else {
		initDefaultDetailLayoutInfo();
	}	

	document.body.removeEventListener('mousedown', mousedown);
	document.body.removeEventListener('resize', bodyResize);
	
	document.body.addEventListener('mousedown', mousedown);
	document.body.addEventListener('resize', bodyResize);
}

function detailDestroy() {
	document.body.removeEventListener('mousedown', mousedown);
	document.body.removeEventListener('resize', bodyResize);	
}

function mousedown(evt) {
	if (!evt.target.classList.contains('resize-bar')) return;

	var mouseup = function() {
		document.body.removeEventListener('mousemove', mousemove);
		document.body.removeEventListener('mouseup', mouseup);
		document.body.removeEventListener('mouseleave', mouseleave);
	};

	var mousemove = function(evt) {
		detailResize(evt);
		evt.preventDefault();
	};

	var mouseleave = function() {
		document.body.removeEventListener('mousemove', mousemove);
		document.body.removeEventListener('mouseup', mouseup);
		document.body.removeEventListener('mouseleave', mouseleave);
	};

	document.body.addEventListener('mousemove', mousemove);
	document.body.addEventListener('mouseup', mouseup);
	document.body.addEventListener('mouseleave', mouseleave);
}

function detailResize(evt) {
	if (document.querySelector('#panel').classList.contains('vertical')) {
		if (0 === evt.clientY) return;

		if (null !== panelContentStyle.width) panelContentStyle.width = null;
		
		if (null !== panelContentStyle['margin-left']) panelContentStyle['margin-left'] = null;

		if (!beforeDragEvt) {
			beforeDragEvt = evt;
			panelContentStyle.height = document.querySelector('#panel .panel-content').clientHeight;
		} else if (evt.clientY < beforeDragEvt.clientY) {
			panelContentStyle.height = panelContentStyle.height + (beforeDragEvt.clientY - evt.clientY);
		} else {
			panelContentStyle.height = panelContentStyle.height - (evt.clientY - beforeDragEvt.clientY);
		}
		
		if (document.body.clientHeight - (992 <= window.innerWidth ? 72 : 50) <= panelContentStyle.height) {
			panelContentStyle.height = document.body.clientHeight - (992 <= window.innerWidth ? 72 : 50);
			return;
		}

		if (panelContentStyle.height < 100) {
			panelContentStyle.height = 100;
			return;
		}
	} else {
		if (0 === evt.clientX) return;

		if (null !== panelContentStyle.height) panelContentStyle.height = null;

		if (!beforeDragEvt) {
			beforeDragEvt = evt;
			panelContentStyle.width = document.querySelector('#panel .panel-content').clientWidth;
		} else if (evt.clientX < beforeDragEvt.clientX) {
			panelContentStyle.width = panelContentStyle.width + (beforeDragEvt.clientX - evt.clientX);
		} else {
			panelContentStyle.width = panelContentStyle.width - (evt.clientX - beforeDragEvt.clientX);
		}
		
		if (document.body.clientWidth - 240 <= panelContentStyle.width) {
			panelContentStyle.width = document.body.clientWidth - 240;
			return;
		}

		if (panelContentStyle.width < 240) {
			panelContentStyle.width = 240;
			return;
		}
		
		panelContentStyle['margin-left'] = 'calc(100% - ' + panelContentStyle.width + 'px)';
		document.querySelector('.customLayout > [data-ready]').style.width = document.querySelector('#ct').clientWidth - 48 - document.querySelector('#panel .panel-content').clientWidth + 'px';		
	}

	document.querySelector('#panel .panel-content').style.width = panelContentStyle.width? panelContentStyle.width + 'px' : null;
	document.querySelector('#panel .panel-content').style.height = panelContentStyle.height? panelContentStyle.height + 'px' : null;
	document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left']? panelContentStyle['margin-left'] : null;
	
	beforeDragEvt = evt;
	
	windowResizeSearchGrid();
	
	document.querySelector('#panel').classList.remove('expand');

	localStorage.setItem(
		'detailLayoutInfo_' + menuId,
		JSON.stringify({
			panelLayoutDirection: document.querySelector('#panel').classList.contains('horizon') ? 'horizon' : 'vertical',
			panelContentStyle: panelContentStyle,
			screenType: screenType,
		})
	);	
	
	windowResizeSearchGrid();
	
	$('[data-ready]').each(function (index, element) {
		element.dispatchEvent(new CustomEvent('resize'));
	});		
}

function bodyResize(evt) {
	var isChangeVerticalLayout = false;

	if (991 < window.innerWidth) {
		if ('pc' !== screenType) isChangeVerticalLayout = true;
		else if (document.querySelector('#panel').classList.contains('horizon'))  {
			beforeDragEvt = null;
			
			if (panelContentStyle.width && document.body.clientWidth - 240 <= panelContentStyle.width) {
				panelContentStyle.width = document.body.clientWidth - 240;
				panelContentStyle['margin-left'] = 'calc(100% - ' + panelContentStyle.width + 'px)';
				
				document.querySelector('#panel .panel-content').style.width = panelContentStyle.width + 'px';
				document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];
				
				localStorage.setItem(
					'detailLayoutInfo_' + menuId,
					JSON.stringify({
						panelLayoutDirection: 'horizon',
						panelContentStyle: panelContentStyle,
						screenType: screenType,
					})
				);				
			}

			var adjustWidth = window.innerWidth - ($('#ct').innerWidth() - $('#ct').width());
			
			if (992 <= window.innerWidth && !$('body').hasClass('sidebar-toggled') && 0 < $('#sidebar').length) {
				adjustWidth -= $('#sidebar').outerWidth(true);
			}
			
			if (document.querySelector('.horizon') && 'block' === document.querySelector('#panel').style.display) {
				adjustWidth -= getNumFromStr(getComputedStyle(document.querySelector('.horizon .panel-content')).width);
			}
	
			document.querySelector('.customLayout > [data-ready]').style.width = adjustWidth + 'px';
		}
	} else {
		if (document.querySelector('#panel').classList.contains('horizon')) isChangeVerticalLayout = true;
		else if (767 < window.innerWidth) isChangeVerticalLayout = 'tablet' !== screenType;
		else if (767 >= window.innerWidth) isChangeVerticalLayout = 'mobile' !== screenType;
	}

	screenType = 991 < window.innerWidth ? 'pc' : 767 < window.innerWidth ? 'tablet' : 'mobile';

	if (isChangeVerticalLayout) panelMethodOption.changeLayout('vertical');			
}

function initDefaultDetailLayoutInfo() {
	document.querySelector('#panel').classList.remove('horizon', 'vertical');
	document.querySelector('#panel').classList.add('vertical');

	panelContentStyle.width = null;
	panelContentStyle.height = null;
	panelContentStyle['margin-left'] = null;

	document.querySelector('#panel .panel-content').style.width = panelContentStyle.width;
	document.querySelector('#panel .panel-content').style.height = panelContentStyle.height;
	document.querySelector('#panel .panel-content').style['margin-left'] = panelContentStyle['margin-left'];

	document.querySelector('.customLayout > [data-ready]').classList.remove('horizon');
	document.querySelector('.customLayout > [data-ready]').style.width = null;
	
 	localStorage.setItem(
		'detailLayoutInfo_' + menuId,
		JSON.stringify({
			panelLayoutDirection: 'vertical',
			panelContentStyle: panelContentStyle,
			screenType: screenType,
		})
	);
}
</script>