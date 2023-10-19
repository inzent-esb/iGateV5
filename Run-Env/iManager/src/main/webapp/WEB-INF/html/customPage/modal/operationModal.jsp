<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="operationModal" data-ready>
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

		createPageObj.setViewName('operationModal');
		createPageObj.setIsModal(true);

		var searchList = [
		    {
		        type: 'text',
		        mappingDataInfo: 'object.operationId',
		        name: '<fmt:message>head.id</fmt:message>',
		        placeholder: '<fmt:message>head.searchId</fmt:message>',
		        regExpType: 'searchId'
		    },
		    {
		        type: 'text',
		        mappingDataInfo: 'object.operationName',
		        name: '<fmt:message>head.name</fmt:message>',
		        placeholder: '<fmt:message>head.searchName</fmt:message>',
		        regExpType: 'name'
		    },
		    {
		        type: 'select',
		        mappingDataInfo: {
		            id: 'operationTypeList',
		            selectModel: 'object.operationType',
		            optionFor: 'option in operationTypeList',
		            optionValue: 'option.pk.propertyKey',
		            optionText: 'option.propertyValue'
		        },
		        name: '<fmt:message>common.type</fmt:message>',
		        placeholder: '<fmt:message>head.all</fmt:message>'
		    }
		];

		if (modalParam) {
		    var operationTypeParam = modalParam.operationType;

		    searchList[2].isHideAllOption = true;
		    searchList[2].mappingDataInfo.optionIf = 'I' === operationTypeParam ? '"I" === option.pk.propertyKey' : 'A' === operationTypeParam ? '"A" === option.pk.propertyKey' : '';
		    delete searchList[2].placeholder;
		}

		createPageObj.setSearchList(searchList);

		createPageObj.searchConstructor();

		createPageObj.setMainButtonList({
		    searchInitBtn: true,
		    totalCnt: true,
		    currentCnt: true,
		});

		createPageObj.mainConstructor();

		new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Operation.OperationType' }, orderByKey: true }, function (operationTypeResult) {
		    var vmSearch = new Vue({
		        el: '#' + createPageObj.getElementId('ImngSearchObject'),
		        data: {
		            
		            operationTypeList: [],
		            object: {
		                operationId: null,
		                operationName: null,
		                operationType: operationTypeParam ? operationTypeParam : ' ',
		                pageSize: 10
		            },
		            letter: {
		                operationId: 0,
		                operationName: 0
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
		            initSearchArea: function () {
		                this.object.pageSize = 10;
		                this.object.operationId = null;
		                this.object.operationName = null;
		                this.object.operationType = operationTypeParam ? operationTypeParam : ' ';
		                this.letter.operationId = 0;
		                this.letter.operationName = 0;

		                initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#operationTypeList'), this.object.operationType);
		            },
		            inputEvt: function (info) {
		                setLengthCnt.call(this, info);
		            }
		        }),
		        mounted: function () {
		            this.operationTypeList = operationTypeResult.object;

		            this.$nextTick(function () {
		                this.initSearchArea();
		            });
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
		        },
		        mounted: function () {
		            this.makeGridObj = getMakeGridObj();

		            this.makeGridObj.setConfig({
		            	el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
			            searchUrl: '/api/entity/operation/search',
			            totalCntUrl: '/api/entity/operation/count',
			            paging: {
			    			isUse: true,
			    			side: "server",
			    			setCurrentCnt: function(currentCnt) {
			    			    this.currentCnt = currentCnt
			    			}.bind(this)			    			
			    		},
		                columns: [
		                    {
		                        name: 'operationId',
		                        header: '<fmt:message>head.id</fmt:message>',
		                        align: 'left'
		                    },
		                    {
		                        name: 'operationName',
		                        header: '<fmt:message>head.name</fmt:message>',
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
		    
			document.querySelector('#operationModal').addEventListener('resize', function(evt) {
				resizeModalSearchGrid(vmList.makeGridObj.getSearchGrid());
			});		    
		});
	});
	</script>	
</body>
</html>