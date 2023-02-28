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

		createPageObj.setViewName('threadPoolModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.threadPoolId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
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
		            threadPoolId: null
		        },
		        letter: {
		            threadPoolId: 0
		        }
		    },
		    methods: $.extend(true, {}, searchMethodOption, {
		        search: function () {
		            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

		            vmList.makeGridObj.search(
		                this,
		                function () {
		                    new HttpReq('/igate/threadPool/rowCount.json').read(this.object, function (result) {
		                        vmList.totalCount = 0 == result.object ? 0 : numberWithComma(result.object);
		                    });
		                }.bind(this)
		            );
		        },
		        initSearchArea: function () {
		            this.pageSize = '10';
		            this.object.threadPoolId = null;

		            this.letter.threadPoolId = 0;

		            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
		        },
		        inputEvt: function (info) {
		            setLengthCnt.call(this, info);
		        }
		    }),
		    mounted: function () {
		        this.$nextTick(function () {
		            this.initSearchArea();
		        });
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
		            searchUri: '/igate/threadPool/searchPopup.json',
		            viewMode: '${viewMode}',
		            popupResponse: '${popupResponse}',
		            popupResponsePosition: '${popupResponsePosition}',
		            columns: [
		                {
		                    name: 'threadPoolId',
		                    header: '<fmt:message>head.id</fmt:message>',
		                    align: 'left',
		                    width: '20%'
		                },
		                {
		                    name: 'rejectPolicy',
		                    header: '<fmt:message>igate.threadPool.rejectPolicy</fmt:message>',
		                    align: 'center',
		                    width: '16%',
		                    formatter: function (info) {
		                        switch (info.row.rejectPolicy) {
		                            case 'A':
		                                return 'abort';
		                            case 'C':
		                                return 'caller runs';
		                            case 'D':
		                                return 'discard';
		                            case 'O':
		                                return 'discard oldes';
		                        }
		                    }
		                },
		                {
		                    name: 'threadMin',
		                    header: '<fmt:message>igate.threadPool.min</fmt:message>',
		                    align: 'right',
		                    width: '16%',
		                    formatter: function (info) {
		                        return numberWithComma(info.row.threadMin);
		                    }
		                },
		                {
		                    name: 'threadMax',
		                    header: '<fmt:message>igate.threadPool.max</fmt:message>',
		                    align: 'right',
		                    width: '16%',
		                    formatter: function (info) {
		                        return numberWithComma(info.row.threadMax);
		                    }
		                },
		                {
		                    name: 'threadIdle',
		                    header: '<fmt:message>igate.threadPool.idle</fmt:message>',
		                    align: 'right',
		                    width: '16%',
		                    formatter: function (info) {
		                        return numberWithComma(info.row.threadIdle);
		                    }
		                },
		                {
		                    name: 'threadThreshold',
		                    header: '<fmt:message>igate.threadPool.threshold</fmt:message>',
		                    align: 'right',
		                    width: '16%',
		                    formatter: function (info) {
		                        return numberWithComma(info.row.threadThreshold);
		                    }
		                }
		            ]
		        });
		    }
		});
	});
	</script>	
</body>
</html>