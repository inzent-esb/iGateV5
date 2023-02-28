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

	if (0 < searchGridEl.find('.pagination').find('li').length) {
		adjustHeight -= searchGridEl.find('.pagination').outerHeight(true);
	} else if (0 < searchGridEl.find('.tui-pagination').length) {
		adjustHeight -= searchGridEl.find('.tui-pagination').outerHeight(true);
	}

	if (!document.querySelector('.horizon') && 0 < $('#panel').length && 'none' != $('#panel').css('display')) {
		adjustHeight -= $('#panel').find('.panel-dialog').find('.panel-content').outerHeight(true);
	}

	adjustHeight -= 20;

	SearchImngObj.searchGrid.setHeight(adjustHeight);

	resizeSearchGridPagination(searchGridEl.attr('id'));
}

function resizeSearchGridPagination(gridAreaId) {
	if (0 == $('#' + gridAreaId).find('.ImngSearchGridPagination').find('li').length) return;

	var pageNumSumWidth = 0;
	var scrollLeftSize = 0;

	$('#' + gridAreaId)
		.find('.ImngSearchGridPagination')
		.find('li')
		.each(function (index, item) {
			pageNumSumWidth += $(item).outerWidth(true);

			if (0 < $(item).find('.active').length)
				scrollLeftSize =
					pageNumSumWidth -
					$(
						$('#' + gridAreaId)
							.find('.ImngSearchGridPagination')
							.find('li')[0]
					).outerWidth(true);
		});

	if ($('#' + gridAreaId).width() < pageNumSumWidth) {
		$('#' + gridAreaId)
			.find('.ImngSearchGridPagination')
			.css({ 'justify-content': 'normal', 'overflow-x': 'auto' });
		$('#' + gridAreaId)
			.find('.ImngSearchGridPagination')
			.scrollLeft(scrollLeftSize);
	} else {
		$('#' + gridAreaId)
			.find('.ImngSearchGridPagination')
			.removeAttr('style');
	}
}

function windowResizeModal() {
	$('.modal.show').each(function (index, item) {
		var modalParam = $(item).data('modalParam');

		if (modalParam && 'full' == modalParam.spinnerMode) return true;

		$(item).width(window.innerWidth);
		$(item).next().width(window.innerWidth);
	});

	setTimeout(function () {
		var width = $('#ct').outerWidth(true);

		$('.modal.show').each(function (index, item) {
			var modalParam = $(item).data('modalParam');

			if (modalParam && 'full' == modalParam.spinnerMode) return true;

			$(item).width(width).css({ left: 'auto', right: '0px' });
			$(item).next().width(width).css({ left: 'auto', right: '0px' });
		});
	}, 350);
}