<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('safMessage') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.pk.adapterId",
        'callBackFuncName' : 'setSearchAdapterId'
      },
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.pk.instanceId",
        'optionFor' : 'option in instanceList',
        'optionValue' : 'option.instanceId',
        'optionText' : 'option.instanceId',
        'optionIf': 'option.instanceType == "T"',
        'id' : 'instanceList',
      },
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.pk.safId",
      'name' : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.safStatus",
        'optionFor' : 'option in safStatusList',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'safStatusList',
      },
      'name' : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.status</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.transactionId",
      'name' : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/service.html',
        'modalTitle' : '<fmt:message>igate.service</fmt:message>',
        'vModel' : "object.serviceId",
        'callBackFuncName' : 'setSearchServiceId'
      },
      'name' : "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
	  'type' : "daterange",
	  'mappingDataInfo': {
	  	'daterangeInfo': [
	    	{'id' :  'searchDateFrom', 'name' : "<fmt:message>head.from</fmt:message>"},
	        {'id' :  'searchDateTo', 'name' : "<fmt:message>head.to</fmt:message>"},
	    ]
	  }
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      updateReadyBtn : hasSafMessageEditor,
      updateCancelBtn : hasSafMessageEditor,
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      totalCount: true,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.pk.createDateTime",
          'name' : "<fmt:message>igate.connectorControl.create</fmt:message> <fmt:message>head.date</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.adapterId",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.instanceId",
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.safId",
          'name' : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, ]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.transactionId",
          'name' : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.messageId",
          'name' : "<fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.interfaceId",
          'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.serviceId",
          'name' : "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, ]
    }, ]) ;

    createPageObj.setPanelButtonList(null) ;

    createPageObj.panelConstructor(true) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/safMessage/object.json'/>"
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;

    $.getJSON("<c:url value='/igate/instance/list.json'/>", function(data)
    {

      PropertyImngObj.getProperties('List.SafMessage.Status', true, function(properties)
      {

        window.vmSearch = new Vue({
          el : '#' + createPageObj.getElementId('ImngSearchObject'),
          data : {
            pageSize : '10',
            object : {
              interfaceId : null,
              serviceId : null,
              safStatus : " ",
              transactionId : null,
              fromCreateTime : null,
              toCreateTime : null,
              pk : {
                adapterId : null,
                fileDate : null,
                instanceId : " ",
                safId : null,
              }
            },
            safStatusList : [],
            instanceList : [],
            isSafInstances : false,
            uri : "<c:url value='/igate/instance/list.json'/>"
          },
          methods : {
            search : function()
            {
              vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
              vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/igate/safMessage/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                    	vmList.totalCount = numberWithComma(result.object);
	                    }
	                });
	            }.bind(this));
            },
            initSearchArea : function(searchCondition)
            {
              if(searchCondition)
              {
                for(var key in searchCondition)
                {
                  this.$data[key] = searchCondition[key];
                }
              }
              else
              {
                this.pageSize = '10' ;
                this.object.pk.adapterId = null ;
                this.object.pk.safId = null ;
                this.object.transactionId = null ;
                this.object.serviceId = null ;
                this.object.pk.instanceId = ' ' ;
                this.object.safStatus = ' ' ;
                this.object.fromCreateDateTime = null ;
                this.object.toCreateDateTime = null ;
              }

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceList'), this.object.pk.instanceId)
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#safStatusList'), this.object.safStatus) ;
              initDatePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo')) ;

              this.$forceUpdate() ;
            },
            openModal : function(openModalParam)
            {
              createPageObj.openModal.call(this, openModalParam) ;
            },
            setSearchAdapterId : function(modal)
            {
              this.object.pk.adapterId = modal.adapterId ;
            },
            setSearchServiceId : function(modal)
            {
              this.object.serviceId = modal.serviceId ;
            }
          },
          mounted : function() 
          {
            this.initSearchArea() ;
          },
          created : function()
          {
            this.instanceList = data.object ;
            this.safStatusList = properties ;
          }
        }) ;

        var vmList = new Vue({
          el : '#' + createPageObj.getElementId('ImngListObject'),
          data : {
            makeGridObj : null,
            newTabPageUrl: "<c:url value='/igate/safMessage.html' />",
            totalCount: '0',
          },
          methods : $.extend(true, {}, listMethodOption, {
            initSearchArea : function()
            {
              window.vmSearch.initSearchArea() ;
            },
            goSavePanel : function()
            {
              window.vmMain.goSavePanel() ;
            },
            updateReady : function()
            {
              $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item)
              {
                StatusImngObj.updateReady("<c:url value='/igate/safMessage/updateReady.json'/>", $.param({
                  "pk.createDateTime" : item['pk.createDateTime'],
                  "pk.adapterId" : item['pk.adapterId'],
                  "pk.instanceId" : item['pk.instanceId'],
                  "pk.safId" : item['pk.safId'],
                  safStatus : item.safStatus
                }), item.rowKey, "safStatus") ;
              }) ;
            },
            updateCancel : function()
            {
              $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item)
              {
                StatusImngObj.updateCancel("<c:url value='/igate/safMessage/updateCancel.json'/>", $.param({
                  "pk.createDateTime" : item['pk.createDateTime'],
                  "pk.adapterId" : item['pk.adapterId'],
                  "pk.instanceId" : item['pk.instanceId'],
                  "pk.safId" : item['pk.safId'],
                  safStatus : item.safStatus
                }), item.rowKey, "safStatus") ;
              }) ;
            }
          }),
          mounted : function()
          {
            this.makeGridObj = getMakeGridObj() ;

            this.makeGridObj.setConfig({
              elementId : createPageObj.getElementId('ImngSearchGrid'),
              onClick : SearchImngObj.clicked,
              searchUri : "<c:url value='/igate/safMessage/search.json' />",
              viewMode : "${viewMode}",
              popupResponse : "${popupResponse}",
              popupResponsePosition : "${popupResponsePosition}",
              rowHeaders : ['checkbox'],
              columns : [{
                name : "pk.adapterId",
                header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "10%"
              }, {
                name : "pk.instanceId",
                header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "8%"
              }, {
                name : "pk.safId",
                header : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "17%"
              }, {
                name : "transactionId",
                header : "<fmt:message>head.transaction</fmt:message>  <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "17%"
              }, {
                name : "messageId",
                header : "<fmt:message>igate.message</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "10%"
              }, {
                name : "serviceId",
                header : "<fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "10%"
              }, {
                name : "safStatus",
                header : "<fmt:message>igate.saf</fmt:message> <fmt:message>head.status</fmt:message>",
                align : "center",
                width: "8%",
                formatter : function(value)
                {
                  switch (value.row.safStatus) {
	                  case 'R' : {
	                    return "<fmt:message>igate.safMessage.ready</fmt:message>" ;
	                  }
	                  case 'A' : {
	                    return "<fmt:message>igate.safMessage.active</fmt:message>" ;
	                  }
	                  case 'E' : {
	                    return "<fmt:message>igate.safMessage.expired</fmt:message>" ;
	                  }
	                  case 'D' : {
	                    return "<fmt:message>igate.safMessage.done</fmt:message>" ;
	                  }
	                  case 'C' : {
	                    return "<fmt:message>igate.safMessage.cancel</fmt:message>" ;
	                  }
                  }
                }
              }, 
              {
                name : "pk.createDateTime",
                header : "<fmt:message>igate.connectorControl.create</fmt:message> <fmt:message>head.date</fmt:message>",
                align : "center",
                width: "15%"
              }]
            }) ;

            SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
            
            this.newTabSearchGrid();
          }
        }) ;
        
        window.vmMain = new Vue({
          el : '#MainBasic',
          data : {
            viewMode : 'Open',
            object : {
              pk : {},
              selectedSafSearch: null
            },
            panelMode : null
          },
          computed : {
            pk : function()
            {
              return {
                'pk.createDateTime' : this.object.pk.createDateTime,
                'pk.adapterId' : this.object.pk.adapterId,
                'pk.instanceId' : this.object.pk.instanceId,
                'pk.safId' : this.object.pk.safId
              } ;
            }
          },
          methods : {
            goDetailPanel : function()
            {
              panelOpen('detail') ;
            },
            initDetailArea : function(object)
            {
              if (object)
              {
                this.object = object ;
              }
              else
              {
                this.object.transactionId = null ;
                this.object.messageId = null ;
                this.object.interfaceId = null ;
                this.object.serviceId = null ;
              }
              this.object.pk.createDateTime = null ;
              this.object.pk.adapterId = null ;
              this.object.pk.instanceId = null ;
              this.object.pk.safId = null ;
            }
          },
          created : function() {
            if(localStorage.getItem('selectedSafSearch')){
          	  this.selectedTraceSearch = JSON.parse(localStorage.getItem('selectedSafSearch'));
          	  localStorage.removeItem('selectedSafSearch');
          	  window.vmSearch.object.fromCreateDateTime = this.selectedTraceSearch.fromLogDateTime;
          	  window.vmSearch.object.toCreateDateTime = this.selectedTraceSearch.toLogDateTime;
          	  window.vmSearch.object.pk.safId = this.selectedTraceSearch.safId;
          	  window.vmSearch.search() ;
          	  initDatePicker(window.vmSearch, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo')) ;
            }
          }
        }) ;
        
      }) ;
    }) ;
  }) ;

  function initDatePicker(vueObj, dateFromSelector, dateToSelector)
  {
    dateFromSelector.customDateRangePicker('from', function(fromTime)
    {
      vueObj.object.fromCreateDateTime = fromTime ;

      dateToSelector.customDateRangePicker('to', function(toTime)
      {
        vueObj.object.toCreateDateTime = toTime ;
      }, {
    	startDate: vueObj.object.toCreateDateTime,
        minDate : fromTime
      }) ;
    }, {startDate: vueObj.object.fromCreateDateTime}) ;
  }
</script>