<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
function normalAlert(alertObj) {

	var message = (alertObj.hasOwnProperty('isXSSMode') && !alertObj.isXSSMode)? alertObj.message : escapeHtml(alertObj.message);
	var modalHtml = '';
	
	modalHtml += '<div id="modal1" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '	      <div class="modal-content">';
	modalHtml += '		      <div class="modal-body">';
	modalHtml += '			      <i class="iconb-compt"></i>';
	modalHtml += '				  <p id="normalAlert-text" class="alert-text">' + message + '</p>';
	modalHtml += '			  </div>';
	modalHtml += '			  <div class="modal-footer">';
	modalHtml += '			      <button type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '			  </div>';
	modalHtml += '	      </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';	

	$('#modal1').remove();

	$("body").append($(modalHtml));

	initModalArea('modal1', alertObj.isSpinnerMode);

	$('#modal1').modal('show');
}

function warnAlert(alertObj) {

	var message = (alertObj.hasOwnProperty('isXSSMode') && !alertObj.isXSSMode)? alertObj.message : escapeHtml(alertObj.message);
	var modalHtml = '';
	
	modalHtml += '<div id="modal2" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-body">';
	modalHtml += '                <i class="iconb-warn"></i>';
	modalHtml += '                <p id="warnAlert-text" class="alert-text">' + message + '</p>';
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml += '                <button type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';
	
	$('#modal2').remove();
	
	$("body").append($(modalHtml));
	
	initModalArea('modal2', alertObj.isSpinnerMode);
	
	$('#modal2').modal('show');
}

function normalConfirm(confirmObj) {

	var message = (confirmObj.hasOwnProperty('isXSSMode') && !confirmObj.isXSSMode)? confirmObj.message : escapeHtml(confirmObj.message);
	var modalHtml = '';
	
	modalHtml += '<div id="modal3" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-body">';
	modalHtml += '                <i class="iconb-warn"></i>';
	modalHtml += '                <p id="normalConfirm-text" class="alert-text">' + message + '</p>';
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml += '                <button id="cancel" type="button" class="btn" data-dismiss="modal"><fmt:message>head.cancel</fmt:message></button>';
	modalHtml += '                <button id="ok" type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';
	
	$('#modal3').remove();
	
	$("body").append($(modalHtml));
	
	initModalArea('modal3', confirmObj.isSpinnerMode);

	$('#modal3').modal('show');
	
	$("#modal3").find('#ok').off().on('click', function() {
		if(confirmObj.callBackFunc) confirmObj.callBackFunc();
		else			 SaveImngObj.deleteSubmit(window.vmMain.pk, modal.message);
	});
}

function openModal(modalInfo) {
	var title = modalInfo.title;
	var bodyHtml = modalInfo.bodyHtml;
	var spinnerMode = modalInfo.spinnerMode;
	
	var okCallBackFunc = modalInfo.okCallBackFunc;
	var shownCallBackFunc = modalInfo.shownCallBackFunc;
	
	var modalHtml = '';
	
	modalHtml += '<div id="modal" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" style="max-width: fit-content;">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '        	  <div class="modal-header">';
	modalHtml += '		          <h2 class="modal-title">' + escapeHtml(title) + '</h2>';
	modalHtml += '            </div>';	
	modalHtml += '            <div class="modal-body"></div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml += '                <button id="cancel" type="button" class="btn" data-dismiss="modal"><fmt:message>head.cancel</fmt:message></button>';
	modalHtml += '                <button id="ok" type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';
	
	$('#modal').remove();
	
	$("body").append($(modalHtml));

	$('#modal').find('.modal-body').append($(bodyHtml));
	
	initModalArea('modal', spinnerMode, shownCallBackFunc);
	
	$('#modal').modal('show');
	
	if(okCallBackFunc){
		$("#modal").find('#ok').off().on('click', function() {
			if(okCallBackFunc) 
				okCallBackFunc();
		});			
	}else{
		$("#modal").find('#ok').remove();
	}
}

function initModalArea(modalId, spinnerMode, shownCallBackFunc) {
	if(spinnerMode)
		$('#' + modalId).data('modalParam', {spinnerMode: spinnerMode});
	
	$('#' + modalId).on('show.bs.modal', function(e) {
		function step() {
			if(0 == $('#' + modalId).length) {
				cancelAnimationFrame(rafId);
				return;
			}
			
			var nextItem = $('#' + modalId).next();
			
			if((0 < nextItem.length) && nextItem.hasClass('modal-backdrop')) { 
				if(!spinnerMode) {
					var ctWidth = $("#ct").outerWidth(true);
					nextItem.width(ctWidth).css({'left': 'auto', 'right': '0px'});
					$('#' + modalId).width(ctWidth).css({'left': 'auto', 'right': '0px'});
				}
       	  
				$('.spinnerBg').hide();
				cancelAnimationFrame(rafId);
				return;
			}
          
			rafId = requestAnimationFrame(step);
		}
        
		var rafId = requestAnimationFrame(step);
	});
    
	$('#' + modalId).on('shown.bs.modal', function(e) {
		if(shownCallBackFunc)
			shownCallBackFunc();	
		
		stopSpinner(function() {
			$('.spinnerBg').show();   
		});
	});
      
 	$('#' + modalId).on('hidden.bs.modal', function(e) {
 		stopSpinner();
 		$('#' + modalId).remove();
 	});
}
</script>