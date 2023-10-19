if (!window.resizeFunc) {
	window.resizeFunc = function (evt) {
		windowResizeSearchGrid();

		windowResizeModal();

		$('[data-ready]').each(function (index, element) {
			element.dispatchEvent(new CustomEvent('resize'));
		});
	};
}

document.body.removeEventListener('resize', window.resizeFunc);
document.body.addEventListener('resize', window.resizeFunc);

function windowResizeSearchGrid() {
	if (null == SearchImngObj.searchGrid) return;

	resizeSearchGrid();
}

function resizeSearchGrid() {
	//width
	var adjustWidth = window.innerWidth - ($('#ct').innerWidth() - $('#ct').width());

	if (992 <= window.innerWidth && !$('body').hasClass('sidebar-toggled') && 0 < $('#sidebar').length) {
		adjustWidth -= $('#sidebar').outerWidth(true);
	}
	
	if (document.querySelector('.horizon') && 'block' === document.querySelector('#panel').style.display) {
		adjustWidth -= getNumFromStr(getComputedStyle(document.querySelector('.horizon .panel-content')).width);
	}

	SearchImngObj.searchGrid.setWidth(adjustWidth);

	$('#' + window.mainListAreaId).find('.table-responsive').width(adjustWidth);

	//height
	var adjustHeight = 0;

	adjustHeight += window.innerHeight - ($('#ct').innerHeight() - $('#ct').height());

	adjustHeight -= $('#' + window.mainSearchAreaId).outerHeight(true);

	$.each($('#' + window.mainListAreaId).children().not('.table-responsive, .empty'), function (index, element) {
		adjustHeight -= $(element).outerHeight(true);
	});

	var searchGridEl = $(SearchImngObj.searchGrid.el);

	if (0 < searchGridEl.find('.tui-pagination').length) {
		adjustHeight -= searchGridEl.find('.tui-pagination').outerHeight(true);
	}

	if (!document.querySelector('.horizon') && 0 < $('#panel').length && 'none' != $('#panel').css('display')) {
		adjustHeight -= $('#panel').find('.panel-dialog').find('.panel-content').outerHeight(true);
	}

	adjustHeight -= 20;

	SearchImngObj.searchGrid.setHeight(adjustHeight);
	
	setTimeout(function() {
		var rsideAreaElement = SearchImngObj.searchGrid.el.querySelector('.tui-grid-rside-area');
		var bodyClientHeight = rsideAreaElement.querySelector('.tui-grid-body-area').clientHeight;
		var scrollbarYInnerBorderClientHeight = rsideAreaElement.querySelector('.tui-grid-scrollbar-y-inner-border').clientHeight;
		
		if (bodyClientHeight !== scrollbarYInnerBorderClientHeight) {
			rsideAreaElement.querySelector('.tui-grid-scrollbar-y-inner-border').style.height = bodyClientHeight + 'px';
		}		
	}, 0);
}

function windowResizeModal() {
	var width = $('#ct').outerWidth(true);

	$('.modal.show').each(function (index, item) {
		var modalParam = $(item).data('modalParam');

		if (modalParam && 'full' == modalParam.spinnerMode) return true;

		$(item).width(width).css({ left: 'auto', right: '0px' });
		$(item).next().width(width).css({ left: 'auto', right: '0px' });
	});
}

function resizeModalSearchGrid(grid) {
	if (!grid) return;
	
	var modalBody = grid.el.closest('.modal-body');

	if (!modalBody) return;
	
	var modalBodyComputedStyle = getComputedStyle(modalBody);

	var modalBodyPaddingLeft = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-left'));
	var modalBodyPaddingRight = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-right'));
	var modalBodyPaddingTop = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-top'));
	var modalBodyPaddingBottom = getNumFromStr(modalBodyComputedStyle.getPropertyValue('padding-bottom'));

	var adjustWidth = modalBody.clientWidth - modalBodyPaddingLeft - modalBodyPaddingRight;

	grid.setWidth(adjustWidth);
	
	var ctHeaderHeight = modalBody.querySelector('.ct-header').offsetHeight;
	var subBarHeight = modalBody.querySelector('.sub-bar').offsetHeight;

	var pagination = modalBody.querySelector('.tui-grid-pagination');
	var paginationComputedStyle = getComputedStyle(pagination);
	var paginationMarginTop = getNumFromStr(paginationComputedStyle.getPropertyValue('margin-top'));
	var paginationMarginBottom = getNumFromStr(paginationComputedStyle.getPropertyValue('margin-bottom'));

	var paginationHeight = pagination.offsetHeight;

	var adjustHeight = modalBody.clientHeight - modalBodyPaddingTop - modalBodyPaddingBottom - ctHeaderHeight - subBarHeight - paginationHeight - paginationMarginTop - paginationMarginBottom;

	grid.setHeight(adjustHeight);
}