<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {

	var popupId = '<c:out value="${popupId}" />';

	var modalParam = $("#" + popupId).data('modalParam');
	
	<%-- search init --%>
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('queryModal');
	createPageObj.setIsModal(true);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.queryId", 'name': "<fmt:message>igate.query</fmt:message> <fmt:message>head.id</fmt:message>", 'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text", 'mappingDataInfo': "object.queryName", 'name': "<fmt:message>igate.query</fmt:message> <fmt:message>head.name</fmt:message>", 'placeholder': "<fmt:message>head.searchName</fmt:message>"}
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
				queryId: null,
				queryName: null
			}
		},
		methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this);
			},
			initSearchArea: function() {
				this.pageSize = '10';
				this.object.queryId = null;
				this.object.queryName = null; 
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
        		searchUri : "<c:url value='/igate/query/searchPopup.json' />",
        		viewMode : "${viewMode}",
        		popupResponse : "${popupResponse}",
        		popupResponsePosition : "${popupResponsePosition}",
        		columns : [
        			{
        				name : "queryId",
        				header : "<fmt:message>igate.query</fmt:message> <fmt:message>head.id</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "queryName",
        				header : "<fmt:message>igate.query</fmt:message> <fmt:message>head.name</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "queryDesc",
        				header : "<fmt:message>igate.query</fmt:message><fmt:message>head.description</fmt:message>",
        				align : "left"
        			}, 
        			{
        				name : "queryType",
        				header : "<fmt:message>igate.query</fmt:message> <fmt:message>head.type</fmt:message>",
        				align : "left",
        	            formatter : function(value)
        	               {
        	                 if (value.row.queryType == "F")
        	                   return "Single Select" ;
        	                 else if (value.row.queryType == "S")
        	                	 return "Multi Select" ;
        	                 else if (value.row.queryType == "U")
        	                	 return "Single Update/Delete";
        	                 else if (value.row.queryType == "B")
        	                	 return "Multi Update/Delete";
        	                 else
        	                	 return escapeHtml(value.row.recordType);
        	               }
        			}
        		]		        		
        	});
        }		
	});	 
});
</script>