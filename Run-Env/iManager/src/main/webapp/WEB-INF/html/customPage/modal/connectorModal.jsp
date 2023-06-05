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

		createPageObj.setViewName('connectorModal');
		createPageObj.setIsModal(true);

		createPageObj.setSearchList([
		    {
		        type: 'text',
		        mappingDataInfo: 'object.connectorId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.connectorName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    },
		    {
		        type: 'select',
		        mappingDataInfo: {
		            id: 'connectorTypes',
		            selectModel: 'object.connectorType',
		            optionFor: 'option in connectorTypes',
		            optionValue: 'option.pk.propertyKey',
		            optionText: 'option.propertyValue'
		        },
		        name: '<fmt:message>common.type</fmt:message>',
		        placeholder: '<fmt:message>head.all</fmt:message>'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.connectorDesc',
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
	            connectorTypes: [],
	            object: {
	                connectorId: null,
	                connectorName: null,
	                connectorType: ' ',
	                connectorDesc: null,
	                pageSize: 10,
	            },
	            letter: {
	                connectorId: 0,
	                connectorName: 0,
	                connectorDesc: 0
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
	                this.object.connectorId = null;
	                this.object.connectorName = null;
	                this.object.connectorType = ' ';
	                this.object.connectorDesc = null;
	                this.letter.connectorId = 0;
	                this.letter.connectorName = 0;
	                this.letter.connectorDesc = 0;

	                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorTypes'), this.object.connectorType);
	                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
	            },
	            inputEvt: function (info) {
	                setLengthCnt.call(this, info);
	            }
	        }),
	        mounted: function () {
	        	new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Connector.Type' }, orderByKey: true }, function (connectorTypeResult) {
	        		this.connectorTypes = connectorTypeResult.object;

	                this.$nextTick(function () {
		                this.initSearchArea();
	                }.bind(this));
	            }.bind(this));
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
		            searchUrl: '/api/entity/connector/search',
		            totalCntUrl: '/api/entity/connector/count',
		            paging: {
		    			isUse: true,
		    			side: "server"
		    		},
	                columns: [
	                    {
	                        name: 'connectorId',
	                        header: '<fmt:message>head.id</fmt:message>',
	                        align: 'left'
	                    },
	                    {
	                        name: 'connectorName',
	                        header: '<fmt:message>head.name</fmt:message>',
	                        align: 'left'
	                    },
	                    {
	                        name: 'connectorDesc',
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