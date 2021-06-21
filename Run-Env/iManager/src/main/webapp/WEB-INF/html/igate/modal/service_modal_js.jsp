<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var popupId = '<c:out value="${popupId}" />';

	var modalParam = $("#" + popupId).data('modalParam');
	
	<%-- search init --%>
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('serviceModal');
	createPageObj.setIsModal(true);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.serviceId", 'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.serviceName", 'name': "<fmt:message>igate.service</fmt:message> <fmt:message>head.name</fmt:message>", 'placeholder': "<fmt:message>head.searchName</fmt:message>"}
	]);
	
	createPageObj.searchConstructor();	
	
	createPageObj.setMainButtonList({
		searchInitBtn: true
	});
	
	createPageObj.mainConstructor();
	
	var vmSearch = new Vue({
		el : '#' + createPageObj.getElementId('ImngSearchObject'),
		data : {
			pageSize : '10',
			object : {
				serviceId: null,
				serviceName: null
			}
		},
		methods : {
			search : function() {
				if('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display')) {
					$('#' + createPageObj.getElementId('ImngListObject')).show();
					$('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide();					
				}
				 
				vmList.makeGridObj.search(this);
			},
			initSearchArea: function() {
				this.pageSize = '10';
				this.object.serviceId = null;
				this.object.serviceName = null; 
				initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			}	
		 },
		 mounted: function() {
			 this.initSearchArea();
		 },
		 created: function() {
			 if(modalParam && modalParam.searchAdapter) {
				 this.object.adapterId = modalParam.searchAdapter;
			 }
		 }
	});	
	
	var vmList = new Vue({
		el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        },			
		methods: {
			initSearchArea: function() {
				vmSearch.initSearchArea();
			},
		},
        mounted: function() {
        	
        	this.makeGridObj = getMakeGridObj();
        	
        	this.makeGridObj.setConfig({
        		isModal: true,
        		elementId: createPageObj.getElementId('ImngSearchGrid'),
        		onClick: function(loadParam) {
        			
        			startSpinner();
        			
        			$("#" + popupId).data('callBackFunc')(loadParam);
        			
        			$("#" + popupId).find('#modalClose').trigger('click');
        		},
        		searchUri : "<c:url value='/igate/service/searchPopup.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "serviceId",
        				header : "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "serviceName",
        				header : "<fmt:message>igate.service</fmt:message> <fmt:message>head.name</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "serviceDesc",
        				header : "<fmt:message>igate.service</fmt:message><fmt:message>head.description</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "serviceType",
        				header : "<fmt:message>igate.service</fmt:message> <fmt:message>head.type</fmt:message>",
        				align : "left"
        			}
        		]		        		
        	});
        }		
	});	 
});
</script>