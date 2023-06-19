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
	
		<%-- search init --%>
		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('mappingModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.mappingId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    }
		]);

		createPageObj.searchConstructor();

		createPageObj.setMainButtonList({
		    searchInitBtn: true,
		    totalCnt: true,
		    currentCnt: true,
		    importDataBtn: true
		});

		createPageObj.mainConstructor();

		var vmSearch = new Vue({
		    el: '#' + createPageObj.getElementId('ImngSearchObject'),
		    data: {		        
		        object: {
		            mappingId: null,
		            pageSize: 10
		        },
		        letter: {
		            mappingId: 0
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
		        importData: function() {
		        	vmList.makeGridObj.importData(this.object, function(info) {
		        		vmList.currentCnt = info.currentCnt;
		        	});			        	
		        },
		        initSearchArea: function () {
		            this.object.pageSize = 10;
		            this.object.mappingId = null;
		            this.letter.mappingId = 0;
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
		        importData: function() {
		        	vmSearch.importData();
		        }
		    },
		    mounted: function () {
		        this.makeGridObj = getMakeGridObj();

		        this.makeGridObj.setConfig({
		            el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
		            searchUrl: '/api/entity/mapping/search',
		            totalCntUrl: '/api/entity/mapping/count',
		            paging: {
		    			isUse: true,
		    			side: "server"
		    		},
		            columns: [
		                {
		                    name: 'mappingId',
		                    header: '<fmt:message>head.id</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'mappingName',
		                    header: '<fmt:message>head.name</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'mappingDesc',
		                    header: '<fmt:message>head.description</fmt:message>',
		                    align: 'left'
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
	});
	</script>	
</body>
</html>