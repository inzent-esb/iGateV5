<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
function normalAlert(alertMessage, spinnerMode) {
	var modalHtml = '';
	
	modalHtml += '<div id="modal1" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '	      <div class="modal-content">';
	modalHtml += '		      <div class="modal-body">';
	modalHtml += '			      <i class="iconb-compt"></i>';
	modalHtml += '				  <p id="normalAlert-text" class="alert-text">' + escapeHtml(alertMessage) + '</p>';
	modalHtml += '			  </div>';
	modalHtml += '			  <div class="modal-footer">';
	modalHtml += '			      <button type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '			  </div>';
	modalHtml += '	      </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';	

	$('#modal1').remove();

	$("body").append($(modalHtml));
	
	initModalArea('modal1', spinnerMode);
	
	$('#modal1').modal('show');
}

function warnAlert(alertMessage, spinnerMode) {
	var modalHtml = '';
	
	modalHtml += '<div id="modal2" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-body">';
	modalHtml += '                <i class="iconb-warn"></i>';
	modalHtml += '                <p id="warnAlert-text" class="alert-text">' + escapeHtml(alertMessage) + '</p>';
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml += '                <button type="button" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';
	
	$('#modal2').remove();
	
	$("body").append($(modalHtml));
	
	initModalArea('modal2', spinnerMode);
	
	$('#modal2').modal('show');
}

function normalConfirm(confirmMessage, callBackFunc, spinnerMode) {
	var modalHtml = '';
	
	modalHtml += '<div id="modal3" class="modal fade" tabindex="-1" role="dialog" style="position: absolute; width: 100%; height: 100%; z-index: 9998;">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-body">';
	modalHtml += '                <i class="iconb-warn"></i>';
	modalHtml += '                <p id="normalConfirm-text" class="alert-text">' + escapeHtml(confirmMessage) + '</p>';
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
	
	initModalArea('modal3', spinnerMode);
	
	$('#modal3').modal('show');
	
	$("#modal3").find('#ok').off().on('click', function() {
		if(callBackFunc) callBackFunc();
		else			 SaveImngObj.deleteSubmit(window.vmMain.pk, modal.message);
	});
}

function initModalArea(modalId, spinnerMode) {
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