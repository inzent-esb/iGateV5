$.fn.customDateRangePicker = function(type, callBackFunc, paramOption) {
	var option = {
		startDate: null,
		singleDatePicker: true,
		timePicker: true,
		timePicker24Hour: true,
		timePickerSeconds: true,
		autoApply: false,
		locale: {
			format: "YYYY.MM.DD HH:mm:ss",
			separator: " ~ ",
			daysOfWeek: [weekSunday,weekMonday,weekThesday,weekWednesday, weekThurday,weekFriday,weekSaturday],
	        monthNames: [monthJanuary,monthFebruary,monthMarch,monthApril,monthMay,monthJune,monthJuly,monthAugust,monthSeptember,monthOctober,monthNovember, monthDecember],
	        cancelLabel: cancelBtn,
	        applyLabel: checkBtn
		}
	};
	
	option = $.extend({}, option, paramOption);
	
	var startDate = new Date();
	startDate.setHours(0);
	startDate.setMinutes(0);
	startDate.setSeconds(0);
	startDate.setMilliseconds(0);
	
	var endDate = new Date();
	endDate.setHours(23);
	endDate.setMinutes(59);
	endDate.setSeconds(59);
	endDate.setMilliseconds(59);
	
	if('from' == type) {	
		if(!option.startDate)
			option.startDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
		
		if(!option.maxDate) {
			option.maxDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
		}
		
	}else if('to' == type){
		if(!option.startDate)
			option.startDate = moment(endDate).format('YYYY-MM-DD HH:mm:ss');
		
		if(!option.minDate)
			option.minDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
	}
	
	this.daterangepicker(option, function(startDate, endDate, label) {
		callBackFunc(startDate.format('YYYY-MM-DD HH:mm:ss')); 		
		this.element.val(startDate.format('YYYY-MM-DD HH:mm:ss'));
	});
	
	if(callBackFunc)
		callBackFunc(option.startDate);
}

$.fn.customDatePicker = function(callBackFunc, paramOption) {
	var option = {
		singleDatePicker: true,
		autoApply: true,
		autoUpdateInput: false,
		locale: {
			daysOfWeek: [weekSunday, weekMonday, weekThesday, weekWednesday, weekThurday, weekFriday, weekSaturday],
	        monthNames: [monthJanuary, monthFebruary, monthMarch, monthApril, monthMay, monthJune, monthJuly, monthAugust, monthSeptember, monthOctober, monthNovember, monthDecember],
	        cancelLabel: cancelBtn,
	        applyLabel: checkBtn
		}
	};	
	
	option = $.extend({}, option, paramOption);
	
	if(!option.format)
		option.format = 'YYYYMMDD';
	
	if(!option.localeFormat)
		option.localeFormat = 'MM.DD';
	
	option.locale.format = option.localeFormat;
	
	if(option.startDate) {
		this.val(moment(new Date(option.startDate)).format(option.localeFormat));
	}else {
		this.val(null);
		delete option.startDate;
	}

	this.daterangepicker(option);
	
	this.on('hide.daterangepicker', function(ev, picker) {
		callBackFunc(picker.startDate.format(option.format));
		$(this).val(picker.startDate.format(option.localeFormat));
	});
	
	if(!option.autoUpdate) {
		if(option.startDate && callBackFunc) {
			callBackFunc(moment(new Date(option.startDate)).format(option.format));
		}
	}
}

$.fn.customTimePicker = function(callBackFunc, paramOption) {
	var option = {
		timeFormat: 'HH:mm:ss'
	};
	
	option = $.extend({}, option, paramOption);
	
	if(option.startTime) {
		callBackFunc((option.startTime).replace(/\B(?=(\d{2})+(?!\d))/g, ":")); 
		this.val((option.startTime).replace(/\B(?=(\d{2})+(?!\d))/g, ":"));
	}
	
	this.timepicker(option);
	
	this.on('change', function() {
		var time = $(this).val().replace(/[^0-9]/g,'');		
		time = (time.length < 6)? '00:00:00' : time.substring(0, 6).replace(/\B(?=(\d{2})+(?!\d))/g, ":");
		
		$(this).val(time);
		callBackFunc(time);
	});
}