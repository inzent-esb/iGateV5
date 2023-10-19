<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="calendarModal" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
	$(document).ready(function() {

		var popupId = '<c:out value="${popupId}" />';
	
		<%-- search init --%>
		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('calendarModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.calendarId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.calendarName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.calendarDesc',
		        name: '<fmt:message>head.description</fmt:message>',
		        placeholder: '<fmt:message>head.searchComment</fmt:message>',
		        regExpType: 'desc'
		    }
		]);

		createPageObj.searchConstructor();

		createPageObj.setMainButtonList({
		    searchInitBtn: true,
		    totalCnt: true,
		    currentCnt: true,
		});

		createPageObj.mainConstructor();

		var vmSearch = new Vue({
		    el: '#' + createPageObj.getElementId('ImngSearchObject'),
		    data: {
		        object: {
		            calendarId: null,
		            calendarName: null,
		            calendarDesc: null,
		            pageSize: '10',
		        },
		        letter: {
		            calendarId: 0,
		            calendarName: 0,
		            calendarDesc: 0
		        }
		    },
		    methods: $.extend(true, {}, searchMethodOption, {
		        search: function () {
		            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

		            vmList.makeGridObj.search(this.object, function(info) {
		            	vmList.currentCnt = info.currentCnt;
		            	vmList.totalCnt = info.totalCnt;
		            });
		        },
		        initSearchArea: function () {
		            this.object.pageSize = '10';
		            this.object.calendarId = null;
		            this.object.calendarName = null;
		            this.object.calendarDesc = null;
		            this.letter.calendarId = 0;
		            this.letter.calendarName = 0;
		            this.letter.calendarDesc = 0;
		        },
		        inputEvt: function (info) {
		            setLengthCnt.call(this, info);
		        }
		    }),
		    mounted: function () {
		        this.initSearchArea();
		    }
		});

		var vmList = new Vue({
		    el: '#' + createPageObj.getElementId('ImngListObject'),
		    data: {
		        makeGridObj: null,
		        totalCnt: null,
		        currentCnt: null
		    },
		    methods: {
		        initSearchArea: function () {
		            vmSearch.initSearchArea();
		        },
		    },
		    mounted: function () {
		        this.makeGridObj = getMakeGridObj();

		        this.makeGridObj.setConfig({
		        	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
		            searchUrl: '/api/entity/calendar/search',
		            totalCntUrl: '/api/entity/calendar/count',
		            paging: {
		    			isUse: true,
		    			side: "server",
		    			setCurrentCnt: function(currentCnt) {
		    			    this.currentCnt = currentCnt
		    			}.bind(this)		    			
		    		},
		            columns: [
		                {
		                    name: 'calendarId',
		                    header: '<fmt:message>head.id</fmt:message>'
		                },
		                {
		                    name: 'calendarName',
		                    header: '<fmt:message>head.name</fmt:message>'
		                },
		                {
		                    name: 'calendarDesc',
		                    header: '<fmt:message>head.description</fmt:message>'
		                },
		                {
		                    name: 'saturdayYn',
		                    header: '<fmt:message>igate.calendar.saturday</fmt:message>'
		                },
		                {
		                    name: 'sundayYn',
		                    header: '<fmt:message>igate.calendar.sunday</fmt:message>'
		                }
		            ],
		            onGridMounted: function(evt) {
		            	evt.instance.on('click', function(evt) {
		            		if ('undefined' === typeof evt.rowKey) return;
		            		
			                $('#' + popupId).data('callBackFunc')(evt.instance.getRow(evt.rowKey));
			                
			                $('#' + popupId).find('#modalClose').trigger('click');		            		
		            	})
		            }
		        }, true);
		    }
		});
		
		document.querySelector('#calendarModal').addEventListener('resize', function(evt) {
			resizeModalSearchGrid(vmList.makeGridObj.getSearchGrid());
		});		
	});
	</script>	
</body>
</html>