<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var popupId = '<c:out value="${popupId}" />';
	
	<%-- search init --%>
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('standardCodeModal');
	createPageObj.setIsModal(true);
	
	createPageObj.setSearchList([
		{'type': "modal", 'mappingDataInfo': {'url' : '/igate/adapter.html', 'modalTitle': '<fmt:message>igate.adapter</fmt:message>', 'vModel': "object.pk.adapterId", 'callBackFuncName': 'setSearchAdapterId'}, 'name': "<fmt:message>igate.standardCode</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text",  'mappingDataInfo': "object.pk.standardCode", 'name': "<fmt:message>igate.standardCode</fmt:message>", 'placeholder': "<fmt:message>head.searchCode</fmt:message>"}		
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
				 pk : {
					 adapterId : null,
					 standardCode: null,
				 }
			 }
		 },
		 methods : {
			 search : function() {
				 vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				 vmList.makeGridObj.search(this);
			 },
			 initSearchArea: function() {
				 this.pageSize = '10';
				 this.object.pk.adapterId = null;
				 this.object.pk.standardCode = null;
	        	  
				 initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			 },
			 openModal: function(url, modalTitle, callBackFuncName) {
				 createPageObj.openModal.call(this, url, modalTitle, callBackFuncName);	
			 },
			 setSearchAdapterId: function(param) {
				 this.object.pk.adapterId = param.adapterId;
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
        		searchUri : "<c:url value='/igate/standardCode/searchPopup.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "pk.adapterId",
        				header : "<fmt:message>igate.standardCode</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "pk.standardCode", 
        				header : "<fmt:message>igate.standardCode</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "message1",
        				header : "<fmt:message>igate.standardCode.message1</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "message2",
        				header : "<fmt:message>igate.standardCode.message2</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "message3",
        				header : "<fmt:message>igate.standardCode.message3</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "localCode",
        				header : "<fmt:message>igate.standardCode.localCode</fmt:message>",
        				align : "left"
        			}
				 ]	        		
        	});
        }		
	});	 	 
});
</script>