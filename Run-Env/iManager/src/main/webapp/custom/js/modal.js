function _alert(alertObj) {
	var type = 'warn' === alertObj.type ? 'warn' : 'compt';
	var message = alertObj.hasOwnProperty('isXSSMode') && !alertObj.isXSSMode ? alertObj.message : escapeHtml(alertObj.message);
	var modalHtml = '';

	modalHtml += '<div id="modal1" class="customType modal fade" tabindex="-1" role="dialog" data-backdrop="static">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '	      <div class="modal-content">';
	modalHtml += '		      <div class="modal-body">';
	modalHtml += '			      <i class="iconb-' + type + '"></i>';
	modalHtml += '				  <p  class="alert-text">' + message + '</p>';
	modalHtml += '			  </div>';
	modalHtml += '			  <div class="modal-footer">';
	modalHtml += '			      <button id="ok" type="button" class="btn" data-dismiss="modal">' + closeBtn + '</button>';
	modalHtml += '			  </div>';
	modalHtml += '	      </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';

	$('#modal1').remove();

	$('body').append($(modalHtml));

	initModalArea('modal1', alertObj.backdropMode);

	$('#modal1').modal('show');

	$('#modal1')
		.find('#ok')
		.off()
		.on('click', function () {
			if (alertObj.callBackFunc) alertObj.callBackFunc();
		});
}

function _confirm(confirmObj) {
	var type = 'normal' === confirmObj.type ? 'compt' : 'warn';
	var message = confirmObj.hasOwnProperty('isXSSMode') && !confirmObj.isXSSMode ? confirmObj.message : escapeHtml(confirmObj.message);
	var modalHtml = '';

	modalHtml += '<div id="modal2" class="customType modal fade" tabindex="-1" role="dialog" data-backdrop="static">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-dialog-alert">';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-body">';
	modalHtml += '                <i class="iconb-' + type + '"></i>';
	modalHtml += '                <p class="alert-text">' + message + '</p>';
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml += '                <button id="cancel" type="button" class="btn" data-dismiss="modal">' + cancelBtn + '</button>';
	modalHtml += '                <button id="ok" type="button" class="btn btn-primary" data-dismiss="modal">' + okBtn + '</button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';

	$('#modal2').remove();

	$('body').append($(modalHtml));

	initModalArea('modal2', confirmObj.backdropMode);

	$('#modal2').modal('show');

	$('#modal2')
		.find('#ok')
		.off()
		.on('click', function () {
			confirmObj.callBackFunc();
		});
}

function openModal(modalParam) {
	var viewModalName = '#' + modalParam.name + 'ModalSearch';

	var callBackFunc = modalParam.callBackFunc;
	var isMultiCheck = modalParam.isMultiCheck;
	var modalSize = '';
	var styleArr = [];

	if (modalParam) {
		if (modalParam.size) {
			var size = modalParam.size;
			modalSize = 'small' === size ? '-sm' : 'extraLarge' === size ? '-xl' : 'large' === size ? '-lg' : '';
			modalSize = modalSize.trim().length > 0 ? 'modal' + modalSize : '';			
		}

		if (modalParam.width) {
			styleArr.push('max-width: ' + modalParam.width);
		}
	}
	
	var buttonList = modalParam.buttonList;
	var customBtnHtml = '';
	
	if(buttonList){
		for(var i=0; i < buttonList.length; i++) {
			customBtnHtml += '<button type="button" class="btn btn-primary" id="' + buttonList[i].customBtnId + '">' + buttonList[i].customBtn + '</button>';
		}	
	}	
	
	var modalHtml = '';
	modalHtml += '<div id="' + modalParam.name + 'ModalSearch"  class="customType modal fade" tabindex="-1" role="dialog">';
	modalHtml += '    <div class="modal-dialog modal-dialog-centered ' + modalSize + ' modal-dialog-scrollable"' + ((styleArr.length > 0) ? 'style="' + styleArr.join(';') + '"' : ' ') + '>';
	modalHtml += '        <div class="modal-content">';
	modalHtml += '            <div class="modal-header">';
	modalHtml += '                <h2 class="modal-title">' + modalParam.title + '</h2>';
	modalHtml += '                <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-body">';
	modalHtml += 			      modalParam.bodyHtml;
	modalHtml += '            </div>';
	modalHtml += '            <div class="modal-footer">';
	modalHtml +=                  customBtnHtml;
	modalHtml += '				  <button type="button" class="btn btn-primary" id="modalCustomBtn" style="display: none;"></button>';
	modalHtml += '                <button type="button" class="btn" data-dismiss="modal" id="modalClose">' + (buttonList ? cancelBtn : closeBtn) + '</button>';
	modalHtml += '            </div>';
	modalHtml += '        </div>';
	modalHtml += '    </div>';
	modalHtml += '</div>';

	$(viewModalName).remove();

	$('body').append($(modalHtml));

	if (isMultiCheck) {
		$(viewModalName).data('isMultiCheck', true);
		$(viewModalName).find('#modalConfirm').show();
	}

	window.$startSpinner(modalParam.spinnerMode ? modalParam.spinnerMode : null);

	initModalArea(
		modalParam.name + 'ModalSearch', 
		modalParam.spinnerMode? modalParam.spinnerMode : null, 
		modalParam.shownCallBackFunc? modalParam.shownCallBackFunc : null
	);
	
	$(viewModalName).find('button.btn-primary').on('click', function(e) {
		for(var i=0; i < buttonList.length; i++) {
			if(buttonList[i].customBtnId === e.target.id) buttonList[i].customBtnAction();
		}		
	});
	
	$(viewModalName).find('button')
	
	$(viewModalName).on('shown.bs.modal', function (e) {
		window.$stopSpinner();
	});

	$(viewModalName).on('hidden.bs.modal', function (e) {
		window.$stopSpinner();
		$(viewModalName).remove();
	});

	$(viewModalName).data('callBackFunc', callBackFunc);

	if (modalParam && modalParam.param) $(viewModalName).data('modalParam', modalParam.param);

	$(viewModalName).modal('show');
}

function initModalArea(modalId, spinnerMode, shownCallBackFunc) {
	if (spinnerMode) $('#' + modalId).data('modalParam', { spinnerMode: spinnerMode });

	$('#' + modalId).on('show.bs.modal', function (e) {
		function step() {
			if (0 == $('#' + modalId).length) {
				cancelAnimationFrame(rafId);
				return;
			}

			var nextItem = $('#' + modalId).next();

			if (0 < nextItem.length && nextItem.hasClass('modal-backdrop')) {
				if (!spinnerMode) {
					var ctWidth = $('#ct').outerWidth(true);
					nextItem.width(ctWidth).css({ left: 'auto', right: '0px' });
					$('#' + modalId)
						.width(ctWidth)
						.css({ left: 'auto', right: '0px' });
				}

				$('.spinnerBg').hide();
				cancelAnimationFrame(rafId);
				return;
			}

			rafId = requestAnimationFrame(step);
		}

		var rafId = requestAnimationFrame(step);
	});
	
	$('#' + modalId).on('shown.bs.modal', function (e) {
		if (shownCallBackFunc) shownCallBackFunc();

		window.$stopSpinner(function () {
			$('.spinnerBg').show();
		});
	});

	$('#' + modalId).on('hidden.bs.modal', function (e) {
		$('#' + modalId).remove();
	});
}