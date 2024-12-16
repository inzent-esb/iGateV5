<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="interface" data-ready>
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>

		<ul id="summaryTemplate" class="row media-dl" style="display: none;">
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/call.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.request</fmt:message></dt>
						<dd class="h1">{{ requestCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/complete.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.normal</fmt:message></dt>
						<dd class="h1">{{ successCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/warn.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.exception</fmt:message></dt>
						<dd class="h1">{{ exceptionCount }}</dd>
					</dl>
				</div>
			</li>
			<li class="col-6 col-xl-3">
				<div class="media align-items-center">
					<img src="${prefixFileUrl}/img/danger.svg" class="media-icon" />
					<dl class="media-body">
						<dt><fmt:message>head.timeout</fmt:message></dt>
						<dd class="h1">{{ timeoutCount }}</dd>
					</dl>
				</div>
			</li>
		</ul>
	</div>
	<script>
		document.querySelector('#interface').addEventListener('privilege', function(evt) {
			this.setAttribute('viewer', evt.detail.viewer);
			this.setAttribute('editor', evt.detail.editor);
		});
		
		document.querySelector('#interface').addEventListener('ready', function(evt) {
			var viewer = 'true' == this.getAttribute('viewer');

			var createPageObj = getCreatePageObj();

			createPageObj.setViewName('interface');
			createPageObj.setIsModal(false);

			createPageObj.setSearchList([
			    {
			        type: 'select',
			        name: '<fmt:message>igate.logStatistics.searchType</fmt:message>',
			        isHideAllOption: true,
			        changeEvt: 'initDatePicker',
			        mappingDataInfo: {
			            id: 'dailyTimes',
			            selectModel: 'object.searchType',
			            optionFor: 'option in dailyTimes',
			            optionValue: 'option.pk.propertyKey',
			            optionText: 'option.propertyValue'
			        }
			    },
			    {
			        type: 'daterange',
			        name: '<fmt:message>igate.logStatistics.searchType</fmt:message>',
			        mappingDataInfo: {
			            daterangeInfo: [
			                {
			                    id: 'fromDateTime',
			                    name: '<fmt:message>head.from</fmt:message>'
			                },
			                { id: 'toDateTime', name: '<fmt:message>head.to</fmt:message>' }
			            ]
			        }
			    },
			    /* 구분 검색조건 제거 - 파일검색 기능 추가시 원복
				{
					type: 'select',
					name: '<fmt:message>igate.logStatistics.classification</fmt:message>',
					placeholder: '<fmt:message>head.all</fmt:message>',
					mappingDataInfo: {
						id: 'statsTypes',
						selectModel: 'object.pk.statsType',
						optionFor: 'option in statsTypes',
						optionValue: 'option.pk.propertyKey',
						optionText: 'option.propertyValue',
					}
				},
				*/
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/apimCatalogModal',
			            modalTitle: '<fmt:message>igate.param.id <fmt:param value="Catalog" /></fmt:message>',
			            vModel: 'object.pk.adapterId',
			            callBackFuncName: 'setSearchAdapterId'
			        },
			        regExpType: 'searchId',
			        name: '<fmt:message>igate.param.id <fmt:param value="Catalog" /></fmt:message>',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    },				
			    {
			        type: 'modal',
			        mappingDataInfo: {
			            url: '/modal/apimApplicationModal',
			            modalTitle: 'API ID',
			            vModel: 'object.pk.interfaceServiceId',
			            callBackFuncName: 'setSearchinterfaceServiceId'
			        },
			        regExpType: 'searchId',
			        name: 'API ID',
			        placeholder: '<fmt:message>head.searchId</fmt:message>'
			    }
			]);

			createPageObj.searchConstructor();

			createPageObj.setMainButtonList({
			    newTabBtn: viewer,
			    searchInitBtn: viewer,
			    downloadBtn: viewer,
			    totalCnt: viewer
			});

			createPageObj.mainConstructor();

			$('.empty').after($('#summaryTemplate'));
			
			new HttpReq('/api/page/properties').read({ pk: { propertyId: 'List.LogStats.SearchType' }, orderByKey: true }, function (searchTypeResult) {
			    new HttpReq('/api/page/properties').read({ pk: { propertyId: 'List.LogStats.interface.statsDataTypes' }, orderByKey: true }, function (statsDataTypesResult) {
			       	window.vmSearch = new Vue({
			            el: '#' + createPageObj.getElementId('ImngSearchObject'),
			            data: {
			                dailyTimes: [],
			                statsTypes: [],
			                object: {
			                    searchType: 'D',
			                    fromDateTime: null,
			                    toDateTime: null,
			                    pk: {
			                        statsType: ' ',
			                        adapterId: null,
			                        interfaceServiceId: null
			                    },
			                    pageSize: '10',
			                },
			                letter: {
			                    pk: {
			                    	adapterId: 0,
			                        interfaceServiceId: 0
			                    }
			                }
			            },
			            methods: $.extend(true, {}, searchMethodOption, {
			                inputEvt: function (info) {
			                    setLengthCnt.call(this, info);
			                },
			                search: function () {
			                    $('#summaryTemplate').removeAttr('id').show();

			                    vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

			                    vmList.makeGridObj.getSearchGrid().setPerPage(Number(this.object.pageSize));

			                    var param = JSON.parse(JSON.stringify(this.object));
			                    
			                    param.fromDateTime = new Date(param.fromDateTime).getTime();
			                    param.toDateTime = new Date(param.toDateTime).getTime();

			                    vmList.makeGridObj.search(
			                    		param,
			                        function (result) {
			                            vmList.requestCount = 0;
			                            vmList.successCount = 0;
			                            vmList.exceptionCount = 0;
			                            vmList.timeoutCount = 0;
			                            
		                            	result.object.forEach(function (info) {
			                                vmList.requestCount += Number(info.requestCount);
			                                vmList.successCount += Number(info.successCount);
			                                vmList.exceptionCount += Number(info.exceptionCount);
			                                vmList.timeoutCount += Number(info.timeoutCount);
			                            });

		                            	vmList.totalCnt = numberWithComma(result.object.length);
			                            vmList.requestCount = numberWithComma(vmList.requestCount);
			                            vmList.successCount = numberWithComma(vmList.successCount);
			                            vmList.exceptionCount = numberWithComma(vmList.exceptionCount);
			                            vmList.timeoutCount = numberWithComma(vmList.timeoutCount);
			                        }.bind(this)
			                    );
			                },
			                initSearchArea: function (searchCondition) {
			                    if (searchCondition) {
			                        for (var key in searchCondition) {
			                            this.$data[key] = searchCondition[key];
			                        }
			                    } else {
			                        this.object.pageSize = '10';
			                        this.object.searchType = 'D';
			                        this.object.fromDateTime = null;
			                        this.object.toDateTime = null;
			                        this.object.pk.adapterId = null;
			                        this.object.pk.interfaceServiceId = null;
			                        this.object.pk.statsType = ' ';

			                        this.letter.pk.adapterId = 0;
			                        this.letter.pk.interfaceServiceId = 0;
			                    }

			                    initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#statsTypes'), this.object.pk.statsType);
			                    initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#dailyTimes'), this.object.searchType);

			                    this.initDatePicker();
			                },
			                initDatePicker: function () {
			                    var dateFormat = 'D' === this.object.searchType ? 'YYYY-MM-DD' : 'YYYY-MM-DD HH:mm';
			                    
			                    var agent = navigator.userAgent.toLowerCase();
			                    
			                    if ((navigator.appName == 'Netscape' && -1 != agent.indexOf('trident')) || -1 != agent.indexOf('msie')) {
			                    	dateFormat = dateFormat.replace(/-/gi, '/');
			                    }
			                    
			                    var date = new Date(this.object.fromDateTime ? this.object.fromDateTime : Date.now());

			                    date.setHours(0);
			                    date.setMinutes(0);
			                    date.setSeconds(0);
			                    date.setMilliseconds(0);

			                    this.object.fromDateTime = moment(date).format(dateFormat);

			                    var fromDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#fromDateTime');
			                    var toDateTime = $('#' + createPageObj.getElementId('ImngSearchObject')).find('#toDateTime');
			                    var datePickerInfo = {
			                        format: dateFormat,
			                        timePicker: 'D' !== this.object.searchType,
			                        timePickerSeconds: false,
			                        isMinutueFix: 'H' === this.object.searchType
			                    };

			                    fromDateTime.customDateRangePicker(
			                        'from',
			                        function (fromDateTime) {
			                            this.object.fromDateTime = fromDateTime;

			                            toDateTime.customDateRangePicker(
			                                'to',
			                                function (toDateTime) {
			                                    this.object.toDateTime = toDateTime;
			                                }.bind(this),
			                                Object.assign({
			                                        minDate: fromDateTime
			                                    },
			                                    datePickerInfo
			                                )
			                            );
			                        }.bind(this),
			                        Object.assign({
			                                startDate: this.object.fromDateTime
			                            },
			                            datePickerInfo
			                        )
			                    );
			                },
			                openModal: function (openModalParam, regExpInfo) {
			                    createPageObj.openModal.call(this, openModalParam, regExpInfo);
			                },
			                setSearchinterfaceServiceId: function (param) {
			                    this.object.pk.interfaceServiceId = param['pk.apiId'];
			                },
			                setSearchAdapterId: function (param) {
			                	this.object.pk.adapterId = param.catalogId;
			                }
			            }),
			            mounted: function () {
			                this.dailyTimes = searchTypeResult.object;
			                this.statsTypes = statsDataTypesResult.object;

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
			                requestCount: 0,
			                successCount: 0,
			                exceptionCount: 0,
			                timeoutCount: 0
			            },
			            methods: $.extend(true, {}, listMethodOption, {
			                initSearchArea: function () {
			                    window.vmSearch.initSearchArea();
			                },
			                downloadFile: function () {
			                	var param = JSON.parse(JSON.stringify(window.vmSearch.object));
			                    var agent = navigator.userAgent.toLowerCase();

			                    if ((navigator.appName == 'Netscape' && -1 != agent.indexOf('trident')) || -1 != agent.indexOf('msie')) {
			                       param.fromDateTime = param.fromDateTime.replace(/\//g, '-');
			                       param.toDateTime = param.toDateTime.replace(/\//g, '-');
			                    }
			                    
			                    
			                	downloadFileFunc({
				        			url : '/api/logStats/apimApi/interface/download',  
				        			param,
				        			fileName : '<fmt:message>igate.logStatistics.apimApiStatistics</fmt:message>_<fmt:message>head.excel.output</fmt:message>_' + Date.now() + '.xlsx'
				        		});
			                }
			            }),
			            mounted: function () {
			                this.makeGridObj = getMakeGridObj();

			                this.makeGridObj.setConfig({
			                    el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
			                    searchUrl: '/api/logStats/apimApi/interface',
					    		paging: {
					    			isUse: true,
					    			side: "client"
					    		},
			                    columns: [
			                        {
			                            name: 'pk.logDateTime',
			                            header: '<fmt:message>head.transaction</fmt:message>' + ' ' + '<fmt:message>head.date</fmt:message>',
			                            align: 'center',
			                            width: '10%',
			                            sortable: true
			                        },
			                        {
			                            name: 'pk.adapterId',
			                            header: '<fmt:message>igate.param.id <fmt:param value="Catalog" /></fmt:message>',
			                            align: 'left',
			                            width: '15%'
			                        },
			                        {
			                            name: 'pk.interfaceServiceId',
			                            header: 'API ID',
			                            align: 'left',
			                            width: '15%'
			                        },
			                        {
			                            name: 'requestCount',
			                            header: '<fmt:message>igate.logStatistics.requestCount</fmt:message>',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.requestCount);
			                            }
			                        },
			                        {
			                            name: 'successCount',
			                            header: '<fmt:message>igate.logStatistics.successCount</fmt:message>',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.successCount);
			                            }
			                        },
			                        {
			                            name: 'exceptionCount',
			                            header: '<fmt:message>igate.logStatistics.exceptionCount</fmt:message>',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.exceptionCount);
			                            }
			                        },
			                        {
			                            name: 'timeoutCount',
			                            header: '<fmt:message>igate.logStatistics.timeoutCount</fmt:message>',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.timeoutCount);
			                            }
			                        },
			                        {
			                            name: 'responseTotal',
			                            header: '<fmt:message>igate.logStatistics.responseTotal</fmt:message>' + ' (ms)',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.responseTotal);
			                            }
			                        },
			                        {
			                            name: 'responseMax',
			                            header: '<fmt:message>igate.logStatistics.responseMax</fmt:message>' + ' (ms)',
			                            align: 'right',
			                            width: '10%',
			                            sortable: true,
			                            formatter: function (info) {
			                                return numberWithComma(info.row.responseMax);
			                            }
			                        }
			                    ]
			                });

			                SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();

			                if (this.newTabSearchGrid()) {
			                    this.$nextTick(function () {
			                        window.vmSearch.search();
			                    });
			                }
			            }
			        });
			    });
			});

			this.addEventListener('destroy', function (evt) {
			    $('body').removeClass('searchTypeDaily');
			    $('.daterangepicker').remove();
			    $('.ui-datepicker').remove();
			    $('.backdrop').remove();
			    $('.modal').remove();
			    $('.modal-backdrop').remove();
			    $('#ct').find('script').remove();
			});
		});			
	</script>
</body>
</html> 