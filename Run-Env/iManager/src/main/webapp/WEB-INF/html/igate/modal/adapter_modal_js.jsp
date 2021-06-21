<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var popupId = '<c:out value="${popupId}" />';
	
	<%-- search init --%>
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('adapterModal');
	createPageObj.setIsModal(true);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.adapterId", 	'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 			'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.adapterName", 	'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.name</fmt:message>", 		'placeholder': "<fmt:message>head.searchName</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.adapterDesc", 	'name': "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>", 'placeholder': "<fmt:message>head.searchComment</fmt:message>"}		
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
				 adapterId : null,
				 adapterName : null,
				 adapterDesc : null,
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
				 this.object.adapterId = null;
				 this.object.adapterName = null;
				 this.object.adapterDesc = null;
				 
				 initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			 }			 
		 },
		 mounted: function() {
			 this.initSearchArea();
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
        		searchUri : "<c:url value='/igate/adapter/searchPopup.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "adapterId",
        				header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "adapterName",
        				header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.name</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "adapterDesc",
        				header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "requestStructure",
        				header : "<fmt:message>igate.adapter.structure.request</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "responseStructure",
        				header : "<fmt:message>igate.adapter.structure.response</fmt:message>",
        				align : "left"
        			}
       			]	        	    
        	});
        }		
	});	
});
</script>