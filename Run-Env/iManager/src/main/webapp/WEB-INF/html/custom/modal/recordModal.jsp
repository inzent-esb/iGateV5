<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="record" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
	$(document).ready(function() {

		var popupId = '<c:out value="${popupId}" />';
	
		<%-- search init --%>
		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('recordModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.recordId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.recordName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    }
		]);

		createPageObj.searchConstructor();

		createPageObj.setMainButtonList({
		    searchInitBtn: true,
		    totalCount: true
		});

		createPageObj.mainConstructor();

		var vmSearch = new Vue({
		    el: '#' + createPageObj.getElementId('ImngSearchObject'),
		    data: {
		        pageSize: '10',
		        object: {
		            recordId: null,
		            recordName: null
		        },
		        letter: {
		            recordId: 0,
		            recordName: 0
		        }
		    },
		    methods: $.extend(true, {}, searchMethodOption, {
		        search: function () {
		            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

		            vmList.makeGridObj.search(
		                this,
		                function () {
		                    new HttpReq('/igate/record/rowCount.json').read(this.object, function (result) {
		                        vmList.totalCount = 0 == result.object ? 0 : numberWithComma(result.object);
		                    });
		                }.bind(this)
		            );
		        },
		        initSearchArea: function () {
		            this.pageSize = '10';
		            this.object.recordId = null;
		            this.object.recordName = null;

		            this.letter.recordId = 0;
		            this.letter.recordName = 0;

		            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
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
		        totalCount: '0'
		    },
		    methods: {
		        initSearchArea: function () {
		            vmSearch.initSearchArea();
		        }
		    },
		    mounted: function () {
		        this.makeGridObj = getMakeGridObj();

		        this.makeGridObj.setConfig({
		            isModal: true,
		            elementId: createPageObj.getElementId('ImngSearchGrid'),
		            onClick: function (loadParam) {
		                $('#' + popupId).data('callBackFunc')(loadParam);

		                $('#' + popupId)
		                    .find('#modalClose')
		                    .trigger('click');
		            },
		            searchUri: '/igate/record/searchPopup.json',
		            viewMode: '${viewMode}',
		            popupResponse: '${popupResponse}',
		            popupResponsePosition: '${popupResponsePosition}',
		            columns: [
		                {
		                    name: 'recordId',
		                    header: '<fmt:message>head.id</fmt:message>',
		                    width: '40%'
		                },
		                {
		                    name: 'recordName',
		                    header: '<fmt:message>head.name</fmt:message>',
		                    width: '40%'
		                },
		                {
		                    name: 'privilegeId',
		                    header: '<fmt:message>common.privilege</fmt:message>',
		                    width: '20%'
		                }
		            ]
		        });
		    }
		});
	});
	</script>	
</body>
</html>