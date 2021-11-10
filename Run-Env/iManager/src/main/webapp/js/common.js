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
  
  $(document).on('click', '[data-toggle="collapse"]', function()
  {
    windowResizeSearchGrid();	  
  });

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
	//width
	var adjustWidth = window.innerWidth - ($('#ct').innerWidth() - $('#ct').width());
	
	if(992 <= window.innerWidth && !$('body').hasClass('sidebar-toggled') && 0 < $('#sidebar').length){
		adjustWidth -= $('#sidebar').outerWidth(true);
	}

	SearchImngObj.searchGrid.setWidth(adjustWidth);
	
    $("#" + window.mainListAreaId).find(".table-responsive").width(adjustWidth);
	
	//height
	var adjustHeight = 0;
	
	adjustHeight += window.innerHeight - ($('#ct').innerHeight() - $('#ct').height());
	
	adjustHeight -= $('#' + window.mainSearchAreaId).outerHeight(true);
	
	$.each($("#" + window.mainListAreaId).children().not('.table-responsive, .empty'), function(index, element) {
		adjustHeight -= $(element).outerHeight(true);
	});
	
	if(0 < $("#" + window.mainSearchGridId).find('.pagination').find('li').length){
		adjustHeight -= $("#" + window.mainSearchGridId).find('.pagination').outerHeight(true);
	}else if(0 < $("#" + window.mainSearchGridId).find('.tui-pagination').length){
		adjustHeight -= $("#" + window.mainSearchGridId).find('.tui-pagination').outerHeight(true);
	}
	
    if(0 < $("#panel").length && 'none' != $("#panel").css('display')){
        adjustHeight -= $("#panel").find(".panel-dialog").find(".panel-content").outerHeight(true);
    }

    adjustHeight -= 20;
	    
	SearchImngObj.searchGrid.setHeight(adjustHeight);
	
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
  if(992 <= window.innerWidth && $('body').hasClass('sidebar-toggled'))
  {
    setTimeout(function() {
    	$('.modal.show').each(function(index, item) {
    		var modalParam = $(item).data('modalParam') ;
        	
    		if(!(modalParam && 'full' == modalParam.spinnerMode)){
    			$(item).width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
    			$(item).next().width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
    		}
    	}) ;  	
    }, 210);
  }
  else 
  {
  	$('.modal.show').each(function(index, item) {
  		var modalParam = $(item).data('modalParam') ;
    	
		if(!(modalParam && 'full' == modalParam.spinnerMode)){
			$(item).width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
			$(item).next().width($('#ct').outerWidth(true)).css({'left': 'auto', 'right': '0px'}) ;
		}
	}) ; 
  }
}

function windowResizeSpinner()
{	
  if(992 <= window.innerWidth && $('body').hasClass('sidebar-toggled'))
  {
    setTimeout(function()
    {
      var spinnerMode = $("#spinnerDiv").data('spinnerMode') ;
		
      if(!(spinnerMode && 'full' == spinnerMode)) 
      {
        $("#spinnerDiv").width($("#ct").outerWidth(true)).height($("#ct").outerHeight(true)) ;
      }	  
    }, 210) ;	  
  }	  
  else
  {
    var spinnerMode = $("#spinnerDiv").data('spinnerMode') ;
		
    if(!(spinnerMode && 'full' == spinnerMode)) 
    {
      $("#spinnerDiv").width($("#ct").outerWidth(true)).height($("#ct").outerHeight(true)) ;
    }	  
  }
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

function downloadJson(pJsonFileName, pJsonData) {
	var jsonFileName = pJsonFileName + ".json";
	
	var jsonData = pJsonData;
	
	if (window.navigator && window.navigator.msSaveOrOpenBlob) {
		var blob = new Blob([jsonData], {type: 'text/json;charset=utf8'});
		window.navigator.msSaveOrOpenBlob(blob, jsonFileName);
	} else {
		var downloadLink = document.createElement('a');
		
		var blob = new Blob([jsonData], {type: 'text/json;charset=utf-8;'});
		
		downloadLink.href = URL.createObjectURL(blob);
		downloadLink.download = jsonFileName;
		
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

function encryptPassword(password) {
	if(!password) return null;
	
	var key = (function() {
		var characters ='ABCDEF0123456789';
		
	    var result = '';
	    
	    for (var i = 0; i < 32; i++) {
	        result += characters.charAt(Math.floor(Math.random() * characters.length));
	    }

	    return result;
    })();	
	
	var encrypt = CryptoJS.AES.encrypt(password, CryptoJS.enc.Hex.parse(key), { iv: CryptoJS.enc.Hex.parse(key) });
	
	return '{jst}' + btoa(key + encrypt.toString());
}