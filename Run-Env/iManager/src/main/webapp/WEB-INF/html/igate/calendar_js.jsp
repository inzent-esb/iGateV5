<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('calendar');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 				'mappingDataInfo': "object.calendarId",     			'name': "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.id</fmt:message>",    'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text",  				'mappingDataInfo': "object.calendarName",   			'name': "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.name</fmt:message>",  'placeholder': "<fmt:message>head.searchName</fmt:message>"},	
		{'type': "text", 				'mappingDataInfo': "object.calendarDesc",				'name': "<fmt:message>head.description</fmt:message>",									   'placeholder': "<fmt:message>head.searchComment</fmt:message>"},	
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.holidayYear",
  				'optionFor': 'option in holidayYearList',
  				'optionValue': 'option',
  				'optionText': 'option',
  				'id': 'holidayYear',
  			},
  			'name': "<fmt:message>igate.calendar.date</fmt:message>", 
  			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
	]);
	
	createPageObj.searchConstructor();

	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasCalendarEditor,
	});
	
	createPageObj.mainConstructor();
	
	createPageObj.setTabList([
		{
			'type': 'basic',
			'id': 'MainBasic',
			'name': '<fmt:message>head.basic.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.calendarId", 'name': "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true}, 
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.saturdayYn', 'optionFor': 'option in calendarSaturday', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.calendar.saturday</fmt:message>"},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.sundayYn', 'optionFor': 'option in calendarSunday', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.calendar.sunday</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.calendarName", 'name': "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.name</fmt:message>"},
						{'type': "text", 'mappingDataInfo': "object.calendarDesc", 'name': "<fmt:message>head.description</fmt:message>"},
					]
				},
			]
		},
		{
			'type': 'property',
			'id': 'CalendarHoliday',
			'name': '<fmt:message>igate.calendar.date.detail</fmt:message>',
			'addRowFunc': 'holidayParameters',
			'removeRowFunc': 'removeHolidayParameters(index)',
			'mappingDataInfo': 'calendarHolidayShow',
			'detailList': [
				{'type': "singleDaterange", 'mappingDataInfo': {'id': 'searchSingleDaterange', 'dataDrops': 'up', 'vModel' : 'elm.pk.holidayDate'}, 'name': "<fmt:message>igate.calendar.date</fmt:message>"},
				{'type': 'text', 'mappingDataInfo': 'elm.holidayDesc', 'name': '<fmt:message>igate.calendar.date.desc</fmt:message>'}, 
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		dumpBtn: hasCalendarEditor,
		removeBtn: hasCalendarEditor,
		goModBtn: hasCalendarEditor,
		saveBtn: hasCalendarEditor,
		updateBtn: hasCalendarEditor,
		goAddBtn: hasCalendarEditor,
	});
	
	createPageObj.panelConstructor();
	
	SaveImngObj.setConfig({
    	objectUri : "<c:url value='/igate/calendar/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/igate/calendar/control.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
    			holidayYear : null,
    			calendarId : null,
    			calendarName : null,
    			calendarDesc : null
    		},
    		holidayYearList : [],
    		messageLocales : []
    	},
    	methods : {
			search : function() {
				
				if(this.object.holidayYear == ' ') this.object.holidayYear = '';
				
				if('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display')) {
					$('#' + createPageObj.getElementId('ImngListObject')).show();
					$('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide();					
				}
				
				vmList.makeGridObj.search(this);
			},
            initSearchArea: function(searchCondition) {
            	
            	if(searchCondition) {
            		for(var key in searchCondition) {
            		    this.$data[key] = searchCondition[key];
            		}            		
            	}else {
                	this.pageSize = '10';
                	this.object.holidayYear = new Date().getFullYear().toString();
            		this.object.calendarId = null;
            		this.object.calendarName = null;	
            		this.object.calendarDesc = null;            		
            	}
        		
        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#holidayYear'), this.object.holidayYear);
            }
    	},
    	mounted: function() {
    		this.initSearchArea();
    	},
    	created: function(){
    		for (var year = new Date().getFullYear() + 10; year >= new Date().getFullYear() - 10; year--) {
    			this.holidayYearList.push(year); 
    		}
    	},
    });
    
    var vmList = new Vue({
        el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        	newTabPageUrl: "<c:url value='/igate/calendar.html' />"
        },        
        methods : $.extend(true, {}, listMethodOption, {
        	initSearchArea: function() {
        		window.vmSearch.initSearchArea();
        	}
        }),
        mounted: function() {
        	
        	this.makeGridObj = getMakeGridObj();
        	
        	this.makeGridObj.setConfig({
        		elementId: createPageObj.getElementId('ImngSearchGrid'),
        		onClick: SearchImngObj.clicked,
                searchUri : "<c:url value='/igate/calendar/search.json' />",
                viewMode : "${viewMode}",
                popupResponse : "${popupResponse}",
                popupResponsePosition : "${popupResponsePosition}",
                columns : [
	                {
	                  name : "calendarId",
	                  header : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.id</fmt:message>",
	                  align : "left",
                      width: "25%",
	                },
	                {
	                  name : "calendarName",
	                  header : "<fmt:message>igate.calendar</fmt:message> <fmt:message>head.name</fmt:message>",
	                  align : "left",
                      width: "30%",
	                },
	                {
	                  name : "calendarDesc",
	                  header : "<fmt:message>head.description</fmt:message>",
	                  align : "left",
                      width: "30%",
	                },
	                {
	                  name : "saturdayYn",
	                  header : "<fmt:message>igate.calendar.saturday</fmt:message>",
	                  align : "center",
                      width: "20%",
	                },
	                {
	                  name : "sundayYn",
	                  header : "<fmt:message>igate.calendar.sunday</fmt:message>",
	                  align : "center",
                      width: "20%",
	                }
	            ]        	    
        	});
        	
        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
        	
        	this.newTabSearchGrid();
        }        
    });	    

    window.vmMain = new Vue({
    	el : '#MainBasic',
    	data : {
    		viewMode : 'Open',
    		object : {
    			calendarHoliday : []
    		},
    		calendarSaturday : [],
    		calendarSunday : [],
    		panelMode : null
    	},
    	computed : {
    		pk : function() {
    			return{
    				calendarId : this.object.calendarId
    			};
    		}
    	},
    	created : function() {
    		PropertyImngObj.getProperties('List.Yn', true, function(properties) {
    			this.calendarSaturday = properties;
    			this.calendarSunday = properties;
    		}.bind(this));
    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
				window.vmCalendarHoliday.calendarHolidayEqual();
			},
        	initDetailArea: function(object) {
        		
        		if(object) {
        			this.object=object;
        		}else { 
    				this.object.calendarName = null;
    				this.object.saturdayYn = null;
    				this.object.sundayYn = null;
    				this.object.calendarDesc = null;
    				this.object.calendarId=null;
    				
    				window.vmCalendarHoliday.calendarHolidayShow = [];
        		}
			},
        },     	
    });
    
    window.vmCalendarHoliday = new Vue({
    	el : '#CalendarHoliday',
    	data: {
    		viewMode : 'Open',
    		calendarHoliday : [],
    		calendarHolidayShow : []
    	},
    	methods : {
    		holidayParameters : function() {
    			this.calendarHolidayShow.push({
    				pk : { 
    					holidayDate : null,
    					calendarId : vmMain.object.calendarId
    				},
    			});
    			
    			this.$nextTick(function() {
    				initDatePicker(this.calendarHolidayShow[this.calendarHolidayShow.length - 1], $('#CalendarHoliday').find('#searchSingleDaterange' + (this.calendarHolidayShow.length - 1)));
    			}.bind(this));
    		},
    		removeHolidayParameters : function(index) {
    			this.calendarHoliday.forEach(function(element, deleteIndex){
   					if(this.calendarHolidayShow[index] == element) this.calendarHoliday = this.calendarHoliday.slice(0, deleteIndex).concat(this.calendarHoliday.slice(deleteIndex + 1));
   				}.bind(this));
    			
    			this.calendarHolidayShow = this.calendarHolidayShow.slice(0, index).concat(this.calendarHolidayShow.slice(index + 1));
    		},
    		calendarHolidayEqual : function() {	
				var holidayYear = window.vmSearch.object.holidayYear;	
    			
				if(holidayYear){
		   			this.calendarHolidayShow = this.calendarHoliday.filter(function(element){
	    				if(holidayYear == element.pk.holidayDate.substring(0, 4)) return element;
	    			});					
				}else{
					this.calendarHolidayShow = this.calendarHoliday;
				}
    		}
    	}
    });      

	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption, {
			updateInfo: function(){
				var copyElement = true;
				
				window.vmCalendarHoliday.calendarHolidayShow.forEach(function(elementShow, indexShow){
					this.calendarHoliday.forEach(function(element, index){
						if(element.pk.holidayDate == elementShow.pk.holidayDate) {
							copyElement = false;
							element = elementShow;
						}
	       			}.bind(this));
					
					if(copyElement)   this.calendarHoliday.push(this.calendarHolidayShow[indexShow]);
					copyElement = true;
				}.bind(window.vmCalendarHoliday));
				
				panelMethodOption.updateInfo();
		   	}
		})
	});
});

function initDatePicker(vueObj, dateRangeSelector) {
	var holidayYear = window.vmSearch.object.holidayYear;
	var paramOption = {localeFormat : 'YYYYMMDD', drops: 'up'};
	
	if(vueObj.pk.holidayDate) paramOption.startDate = vueObj.pk.holidayDate;
	
	if(vueObj.pk.holidayDate == formatDate(holidayYear)) paramOption.autoUpdate = false;
	else							  					 paramOption.autoUpdate = true;
	
	//휴일 일자에 따라 기간 지정 
	if(holidayYear){
		paramOption.minDate = new Date(holidayYear.toString(), 0, 1, 0, 0, 0, 0); 
		paramOption.maxDate = new Date(holidayYear.toString(), 11, 31, 23, 59, 59, 59); 
	}

	dateRangeSelector.customDatePicker(function(time) {
		vueObj.pk.holidayDate = time;
	}, paramOption);
}

function formatDate(selectedYear) {
	var date = new Date();
	var year = (selectedYear)? selectedYear : date.getFullYear();
    var month = (1 + date.getMonth());          
    month = month >= 10 ? month : '0' + month;     
    var day = date.getDate();                   
    day = day >= 10 ? day : '0' + day; 
    
    return  year + '/' + month + '/' + day;
}
</script>