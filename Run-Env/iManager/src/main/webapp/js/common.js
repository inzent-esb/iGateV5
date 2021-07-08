$(function()
{
  var $body = $('body'), $tooltip = $('[data-toggle="tooltip"]') ;

  $('.menu-toggler').click(function()
  {
    $(this).hasClass('d-lg-none') ? panelOpen('sidebar') : $body.toggleClass('sidebar-toggled') ;
    
    window.onresize();
  }) ;

  $(document).on('click', function(e)
  {

    var tg = '.panel-content' ;
    if (!$body.is($("[class*='panel-open']")) || $('[data-backdrop="false"]').is(':visible'))
    {
      return ;
    }
    if (!$(e.target).closest(tg).length && !$(e.target).is(tg))
    {
      panelClose($(tg + ':visible').parents('.panel').attr('id')) ;
    }

  }) ;

  $(document).on('click', '[data-toggle="tab"]', function()
  {
    if (window.vmModelInfo)
      window.vmModelInfo.refresh() ;
  }) ;

  $(document).on('click', '[data-toggle="toggle"]', function()
  {
    var $t = $(this) ;
    var txt = $t.data('class') ;
    var target = $t.data('target') || $t.attr('href') ;
    $(target).toggleClass(txt) ;

    if (window.vmModelInfo)
      window.vmModelInfo.refresh() ;
  }) ;

  // tooltip
  $tooltip.length && $tooltip.tooltip() ;

  // select
  var select = $('.selectpicker') ;
  select.length && select.selectpicker() ;
  select.on({
    'show.bs.select' : function(e)
    {
      var label = $(e.target).parents('.form-control-label') ;
      label.length && label.addClass('active') ;
    },
    'hide.bs.select' : function(e)
    {
      var label = $(e.target).parents('.form-control-label') ;
      label.length && label.removeClass('active') ;
    }
  }) ;

  $('.form-control-label:not(.label-select)').on({
    click : function()
    {
      $(this).addClass('active') ;
    },
    focusout : function()
    {
      $(this).removeClass('active') ;
    }
  }) ;

  // input
  $('th .custom-control-input').prop('indeterminate', true) ;
  $('button.custom-switch').click(function()
  {
    $(this).toggleClass('checked') ;
  }) ;

  // tab
  $('[data-tab="multi"]').click(function()
  {
    $('[data-tab-target]').removeClass('active') ;
    $('[data-tab-target="' + $(this).attr('href') + '"]').addClass('active') ;
  }) ;

  var $table = $('.form-table-responsive') ;
  $('.form-table-responsive').on('scroll', function()
  {
    $(".form-table-wrap").width($table.width() + $table.scrollLeft()) ;
  }) ;
}) ;

function initSelectPicker(element, selectedValue)
{
  if ('undefined' != typeof (selectedValue))
    $(element).selectpicker('val', selectedValue) ;
  else
    $(element).selectpicker() ;

  $(element).on({
    'show.bs.select' : function(e)
    {
      var label = $(e.target).parents('.form-control-label') ;
      label.length && label.addClass('active') ;
    },
    'hide.bs.select' : function(e)
    {
      var label = $(e.target).parents('.form-control-label') ;
      label.length && label.removeClass('active') ;
    }
  }) ;
}

// tui grid resize start
function windowResizeSearchGrid() {
  
	if(null == SearchImngObj.searchGrid) return;

	setTimeout(function() {
		resizeSearchGrid();
	}, 350);
}

function resizeSearchGrid() {
	var adjustHeight = 0;
	
	$.each($("#" + window.mainListAreaId).children().not('.table-responsive'), function(index, element) {
		adjustHeight += $(element).outerHeight(true);
	});
	
	if($("#panel").find(".panel-dialog").find(".panel-content").length)
		adjustHeight += $("#panel").find(".panel-dialog").find(".panel-content").outerHeight(true);
	
	$("#" + window.mainListAreaId).find(".table-responsive").height('calc(100% - '+ adjustHeight +'px)');
	
	var adjustWidth = 0;
	
	if($("#" + window.mainSearchGridId).parent().outerHeight(true) < $("#" + window.mainSearchGridId).outerHeight(true))
		adjustWidth += 8;
	
	$("#" + window.mainSearchGridId).width(0).width($("#" + window.mainSearchGridId).parent().width() - adjustWidth);

	SearchImngObj.searchGrid.refreshLayout();
	
	resizeSearchGridPagination(window.mainSearchGridId);
}

function resizeSearchGridPagination(gridAreaId) {
	if(0 == $("#" + gridAreaId).find('.ImngSearchGridPagination').find('li').length) return;
		
	var pageNumSumWidth = 0;
	var scrollLeftSize = 0;	
	
	$("#" + gridAreaId).find('.ImngSearchGridPagination').find('li').each(function(index, item) {
		pageNumSumWidth += $(item).outerWidth(true);
		
		if(0 < $(item).find('.active').length)
			scrollLeftSize = pageNumSumWidth - $($("#" + gridAreaId).find('.ImngSearchGridPagination').find('li')[0]).outerWidth(true);
	});
		
	if($("#" + gridAreaId).width() < pageNumSumWidth) {
		$("#" + gridAreaId).find('.ImngSearchGridPagination').css({'justify-content': 'normal', 'overflow-x': 'auto'})
		$("#" + gridAreaId).find('.ImngSearchGridPagination').scrollLeft(scrollLeftSize);
	}else{
		$("#" + gridAreaId).find('.ImngSearchGridPagination').removeAttr('style');
	}
}

function windowResizeModal() 
{
  $('.modal.show').each(function(index, item) 
  {
    var modalParam = $(item).data('modalParam') ;
	
    if(!(modalParam && 'full' == modalParam.spinnerMode))
    {
      $(item).width('100%') ;
	  $(item).next().width('100%') ;
    }
  }) ;
	  
  setTimeout(function()
  {	
    $('.modal.show').each(function(index, item) 
    {
      var modalParam = $(item).data('modalParam') ;
		    
      if(!(modalParam && 'full' == modalParam.spinnerMode))
      {
        $(item).width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
        $(item).next().width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
      }
    }) ;	  
  }, 210) ;
}

function windowResizeSpinner()
{
  var spinnerMode = $("#spinnerDiv").data('spinnerMode') ;

  if(!(spinnerMode && 'full' == spinnerMode)) 
  {
    $("#spinnerDiv").width('100%').height('100%') ;
  }

  setTimeout(function()
  {
	var spinnerMode = $("#spinnerDiv").data('spinnerMode') ;
	
    if(!(spinnerMode && 'full' == spinnerMode)) 
    {
      $("#spinnerDiv").width($("#ct").outerWidth(true)).height($("#ct").outerHeight(true)) ;
    }	  
  }, 210) ;
}

var customResizeFunc = null ;

window.onresize = function()
{
  windowResizeSearchGrid() ;

  windowResizeModal() ;
  
  windowResizeSpinner() ;
  
  if (null != customResizeFunc)
  {
    customResizeFunc() ;
  }  
} ;
// tui grid resize end

function downloadExcel(csvData) {
	
	var excelDataForm = document.excelForm;
	var key = Object.keys(csvData);
	
	for(var i = 0; i < key.length; i++) {
		var input = document.createElement('input'); 
		input.setAttribute("type", "hidden"); 
		input.setAttribute("class", 'excelFrom_TempData'); 
		input.setAttribute("name", key[i]); 
		input.setAttribute("value", csvData[key[i]]);
		
		excelDataForm.appendChild(input);
	}
	
  	var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no,    scrollorbars=no, resizable=no") ;
  	excelDataForm.target = "hiddenframe";
  	excelDataForm.submit();
  	$('.excelFrom_TempData').remove();

}

function downloadCSV(pCsvFileName, pCsvData) {
	
	var csvFileName = pCsvFileName + ".csv";
	
	var csvData = "\ufeff" + pCsvData;
	
	if (window.navigator && window.navigator.msSaveOrOpenBlob) { 
		var blob = new Blob([csvData], {type: 'text/csv;charset=utf8'});
		window.navigator.msSaveOrOpenBlob(blob, csvFileName);
	} else {
		
		if (!(window.Blob && window.URL))
			csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(chartDataArr);
		
		var downloadLink = document.createElement('a');
		
		var blob = new Blob([csvData], {type: 'text/csv;charset=utf-8;'});
		
		downloadLink.href = URL.createObjectURL(blob);
		downloadLink.download = csvFileName;
		
		document.body.appendChild(downloadLink);
		
		downloadLink.click();
		
		document.body.removeChild(downloadLink);
	}
}

function escapeHtml(text) {
	return $('<span />').text(text).html();
}

function unescapeHtml(text) {
	return $('<span />').html(text).text();
}