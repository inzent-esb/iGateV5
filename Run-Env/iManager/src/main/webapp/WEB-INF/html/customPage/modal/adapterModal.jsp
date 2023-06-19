<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="adapter" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
	</div>
	<script>
	$(document).ready(function() {
		var popupId = '<c:out value="${popupId}" />';
	
		<%-- search init --%>
		var createPageObj = getCreatePageObj();

		createPageObj.setViewName('adapterModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.adapterId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.adapterName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.adapterDesc',
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
		    importDataBtn: true
		});

		createPageObj.mainConstructor();

		var vmSearch = new Vue({
		    el: '#' + createPageObj.getElementId('ImngSearchObject'),
		    data: {
		        object: {
		            adapterId: null,
		            adapterName: null,
		            adapterDesc: null,
		            pageSize: 10
		        },
		        letter: {
		            adapterId: 0,
		            adapterName: 0,
		            adapterDesc: 0
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
		            this.pageSize = 10;
		            this.object.adapterId = null;
		            this.object.adapterName = null;
		            this.object.adapterDesc = null;
		            this.letter.adapterId = 0;
		            this.letter.adapterName = 0;
		            this.letter.adapterDesc = 0;
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
		            searchUrl: '/api/entity/adapter/search',
		            totalCntUrl: '/api/entity/adapter/count',
		    		paging: {
		    			isUse: true,
		    			side: "server"
		    		},		        	
		            columns: [
		                {
		                    name: 'adapterId',
		                    header: '<fmt:message>head.id</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'adapterName',
		                    header: '<fmt:message>head.name</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'adapterDesc',
		                    header: '<fmt:message>head.description</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'requestStructure',
		                    header: '<fmt:message>igate.adapter.structure.request</fmt:message>',
		                    align: 'left'
		                },
		                {
		                    name: 'responseStructure',
		                    header: '<fmt:message>igate.adapter.structure.response</fmt:message>',
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