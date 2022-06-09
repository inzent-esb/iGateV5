<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="notice" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
	$(document).ready(function() {
		var popupId = '<c:out value="${popupId}" />';
		
		var isTrxType = false;
		
		var modalParam = $('#' + popupId).data('modalParam');
		
		if (modalParam) {
			if('T' === modalParam.instanceType) {
				isTrxType = true;
			}
		}
	
	<%-- search init --%>
	var createPageObj = getCreatePageObj();
		
	createPageObj.setViewName('instanceModal');
	createPageObj.setIsModal(true);
		
	var searchList = [
		{
			'type': "text", 
			'mappingDataInfo': "object.instanceId", 	
			'name': "<fmt:message>head.id</fmt:message>", 			
			'placeholder': "<fmt:message>head.searchId</fmt:message>",		    
			'regExpType': "searchId"
		},
		{
			'type': "text", 
			'mappingDataInfo': "object.instanceNode", 	
			'name': "<fmt:message>igate.instance.node</fmt:message>", 		
			'placeholder': "<fmt:message>head.searchData</fmt:message>",		
		},
		{
			type: 'select',
			name: "<fmt:message>common.type</fmt:message>",
			mappingDataInfo: {
				id: 'instanceTypes',
				selectModel: 'object.instanceType',
				optionFor: 'option in instanceTypes',
				optionValue: 'option.pk.propertyKey',
				optionText: 'option.propertyValue',
			},
			placeholder: '<fmt:message>head.all</fmt:message>',
		},	
	];
	
	if (isTrxType) {
		searchList[2].isHideAllOption = true;
		searchList[2].mappingDataInfo.optionIf = '"T" === option.pk.propertyKey';
		delete searchList[2].placeholder;
	}
	
	createPageObj.setSearchList(searchList);
		
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		searchInitBtn: true,
		totalCount: true,
	});
	
	createPageObj.mainConstructor();
		
	var vmSearch = new Vue({
		 el: '#' + createPageObj.getElementId('ImngSearchObject'),
		 data: {
			 pageSize: '10',
			 object: {
				 instanceId: null,
				 instanceNode: null,
				 instanceType: isTrxType? 'T' : ' ',
			 },
			 letter: {
				 instanceId: 0,
				 instanceNode: 0,
			 },
			 instanceTypes: [],
		 },
		 methods: {
			 search: function() {
				 vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				 
				 vmList.makeGridObj.search(this, function() {
					(new HttpReq("/igate/instance/rowCount.json")).read(this.object, function(result) {
						vmList.totalCount = 0 == result.object? 0 : numberWithComma(result.object);
					});
	             }.bind(this));
			 },
			 initSearchArea: function() {
				 this.pageSize = '10';
				 this.object.instanceId = null;
				 this.object.instanceNode = null;
				 this.object.instanceType = isTrxType? 'T' : ' ';
				 this.letter.instanceId = 0;
				 this.letter.instanceNode = 0;
				 
				 initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.instanceType);
				 initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
			 },
			 inputEvt: function(info) {
    			setLengthCnt.call(this, info);
    		 },
		 },
		 mounted: function() {
			 (new HttpReq('/common/property/properties.json')).read({ propertyId: 'List.Instance.InstanceType', orderByKey: true }, function(instanceTypeResult) {
				 this.instanceTypes = instanceTypeResult.object;
				 
				 this.$nextTick(function() {
					 this.initSearchArea();	 
				 }.bind(this));
			 }.bind(this));
		 }
	});
		
	var vmList = new Vue({
		el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
        	totalCount: '0',
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
        			$("#" + popupId).data('callBackFunc')(loadParam);
        			
        			$("#" + popupId).find('#modalClose').trigger('click');
        		},
        		searchUri: "/igate/instance/searchPopup.json",
        		viewMode: "${viewMode}",
        		popupResponse: "${popupResponse}",
        		popupResponsePosition: "${popupResponsePosition}",
        		columns: [
        			{
        				name: "instanceId",
        				header: "<fmt:message>head.id</fmt:message>",
        			}, 
        			{
        				name: "instanceType",
        				header: "<fmt:message>common.type</fmt:message>",
        				align: "center",
        				formatter: function(value) {
							switch (value.row.instanceType) {
								case 'T': {
									return "<fmt:message>igate.instance.type.trx</fmt:message>";
								}
								case 'A': {
									return "<fmt:message>igate.instance.type.adm</fmt:message>";
								}
								case 'L': {
									return "<fmt:message>igate.instance.type.log</fmt:message>";
								}
								case 'M': {
									return "<fmt:message>igate.instance.type.mnt</fmt:message>";
								}
							}        					
        				} 
        			}, 
        			{
        				name: "instanceAddress",
        				header: "<fmt:message>igate.instance.address</fmt:message>",
        			}, 
        			{
        				name: "instanceNode",
        				header: "<fmt:message>igate.instance.node</fmt:message>",
        			}, 
       			]	        	    
        	});
        }		
	});	
});
	</script>	
</body>
</html>