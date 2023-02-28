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
		
		var modalParam = $("#" + popupId).data('modalParam');
	
		<%-- search init --%>
		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('activityModal');
		createPageObj.setIsModal(true);
		
		var modalActivityType = modalParam && modalParam.activityType? modalParam.activityType : ' ';

		var searchList = [
		    {
		        type: 'text',
		        mappingDataInfo: 'object.activityId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.activityName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    },
		    {
		        type: 'select',
		        name: '<fmt:message>common.type</fmt:message>',
		        mappingDataInfo: {
		            id: 'activityTypes',
		            selectModel: 'object.activityType',
		            optionFor: 'option in activityTypes',
		            optionValue: 'option.pk.propertyKey',
		            optionText: 'option.propertyValue',
		            optionIf: modalActivityType.trim() ?  '"' + modalActivityType + '" === option.pk.propertyKey' : '',		            
		        },
		        isHideAllOption : modalActivityType.trim(),
		        placeholder: '<fmt:message>head.all</fmt:message>'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.activityGroup',
		        name: '<fmt:message>head.group</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.activityDesc',
		        name: '<fmt:message>head.description</fmt:message>',
		        placeholder: '<fmt:message>head.searchComment</fmt:message>',
		        regExpType: 'desc'
		    }
		];
		
		if (modalParam && modalParam.activityType) {
			searchList.splice(3, 1);
			searchList.splice(1, 1);
		}

		createPageObj.setSearchList(searchList);

		createPageObj.searchConstructor();

		createPageObj.setMainButtonList({
		    searchInitBtn: true,
		    totalCount: true
		});

		createPageObj.mainConstructor();

		new HttpReq('/common/property/properties.json').read({ propertyId: 'List.Activity.ActivityType', orderByKey: true }, function (activityTypeResult) {
		    var vmSearch = new Vue({
		        el: '#' + createPageObj.getElementId('ImngSearchObject'),
		        data: {
		            pageSize: '10',
		            object: {
		                activityId: null,
		                activityName: null,
		                activityType: modalActivityType,
		                activityGroup: null,
		                activityDesc: null
		            },
		            letter: {
		                activityId: 0,
		                activityName: 0,
		                activityGroup: 0,
		                activityDesc: 0
		            },
		            activityTypes: []
		        },
		        methods: $.extend(true, {}, searchMethodOption, {
		            search: function () {
		                vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

		                vmList.makeGridObj.search(
		                    this,
		                    function () {
		                        new HttpReq('/igate/activity/rowCount.json').read(this.object, function (result) {
		                            vmList.totalCount = 0 == result.object ? 0 : numberWithComma(result.object);
		                        });
		                    }.bind(this)
		                );
		            },
		            initSearchArea: function () {
		                this.pageSize = '10';
		                this.object.activityId = null;
		                this.object.activityName = null;
		                this.object.activityType = modalActivityType;
		                this.object.activityGroup = null;
		                this.object.activityDesc = null;

		                this.letter.activityId = 0;
		                this.letter.activityName = 0;
		                this.letter.activityGroup = 0;
		                this.letter.activityDesc = 0;

		                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes'), this.object.activityType);
		            },
		            inputEvt: function (info) {
		                setLengthCnt.call(this, info);
		            }
		        }),
		        mounted: function () {
		            this.activityTypes = activityTypeResult.object;

		            this.$nextTick(function () {
		                this.initSearchArea();
		            });
		        }
		    });

		    var vmList = new Vue({
		        el: '#' + createPageObj.getElementId('ImngListObject'),
		        data: {
		            makeGridObj: null,
		            totalCount: '0',
		        },
		        methods: {
		            initSearchArea: function () {
		                vmSearch.initSearchArea();
		            }
		        },
		        mounted: function () {
		        	this.makeGridObj = getMakeGridObj();
		        	
		            var gridData = {
		                isModal: true,
		                elementId: createPageObj.getElementId('ImngSearchGrid'),
		                onClick: function (loadParam) {
		                    $('#' + popupId).data('callBackFunc')(loadParam);

		                    $('#' + popupId)
		                        .find('#modalClose')
		                        .trigger('click');
		                },
		                searchUri: '/igate/activity/searchPopup.json',
		                viewMode: '${viewMode}',
		                popupResponse: '${popupResponse}',
		                popupResponsePosition: '${popupResponsePosition}',		    
		                columns: [
		                    {
		                        name: 'activityId',
		                        header: '<fmt:message>head.id</fmt:message>',
		                        width: '20%'
		                    },
		                    {
		                        name: 'activityName',
		                        header: '<fmt:message>head.name</fmt:message>',
		                        width: '20%'
		                    },
		                    {
		                        name: 'activityType',
		                        header: '<fmt:message>common.type</fmt:message>',
		                        align: 'center',
		                        width: '15%',
		                        formatter: function (value) {
		                            switch (value.row.activityType) {
		                                case 'F':
		                                    return '<fmt:message>igate.activity.type.control</fmt:message>';
		                                case 'A':
		                                    return '<fmt:message>igate.activity.type.activity</fmt:message>';
		                                case 'S':
		                                    return '<fmt:message>igate.activity.type.service</fmt:message>';
		                                case 'C':
		                                    return '<fmt:message>igate.activity.type.codec</fmt:message>';
		                                case 'T':
		                                    return '<fmt:message>igate.activity.type.transform</fmt:message>';
		                                case 'I':
		                                    return '<fmt:message>igate.activity.type.internal</fmt:message>';
		                                case 'H':
		                                    return '<fmt:message>igate.activity.type.telegram.handler</fmt:message>';
		                            }
		                        }
		                    },
		                    {
		                        name: 'activityGroup',
		                        header: '<fmt:message>head.group</fmt:message>',
		                        width: '20%'
		                    },
		                    {
		                        name: 'activityDesc',
		                        header: '<fmt:message>head.description</fmt:message>',
		                        width: '20%'
		                    }
		                ]
		            }
		            
		            if(modalActivityType.trim()) {
		            	gridData.columns.splice(2, 2);
		            }
		            
		            this.makeGridObj.setConfig(gridData);
		        }
		    });
		});
	});
	</script>	
</body>
</html>