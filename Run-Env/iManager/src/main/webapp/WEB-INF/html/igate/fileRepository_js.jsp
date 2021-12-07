<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('fileRepository') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.pk.fileMode",
        'optionFor' : 'option in fileMode',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'fileMode'
      },
      'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.mode</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
        'type' : "singleDaterange",
        'mappingDataInfo' : {
          'id' : 'searchSingleDaterange'
        },
        'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>",
        'placeholder' : "<fmt:message>head.searchDate</fmt:message>"
      },{
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
      'type' : "text",
      'mappingDataInfo' : "object.pk.fileName",
      'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    },  {
      'type' : "text",
      'mappingDataInfo' : "object.interfaceServiceId",
      'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.fileStatus",
        'optionFor' : 'option in fileStatus',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'fileStatus'
      },
      'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.status</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
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
      updateCancelBtn : hasFileLogEditor,
      updateReadyBtn : hasFileLogEditor,
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
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.pk.fileMode",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.mode</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.adapterId",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.fileName",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.fileDate",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.pk.fileSequence",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.sequence</fmt:message>",
          isPk : true
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.transactionId",
          'name' : "<fmt:message>head.transaction</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.interfaceServiceId",
          'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.instanceId",
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.createDateTime",
          'name' : "<fmt:message>igate.connectorControl.create</fmt:message> <fmt:message>head.date</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.fileRemoteName",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.fileStatus",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.status</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.filePath",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.path</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.fileLength",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.length</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.fileOffset",
          'name' : "<fmt:message>head.file</fmt:message> <fmt:message>head.offset</fmt:message>"
        }, ]
      }, ]
    }]) ;

    createPageObj.setPanelButtonList(null) ;

    createPageObj.panelConstructor(true) ;

    PropertyImngObj.getProperties('List.FileRepository.Status', true, function(pfileStatus)
    {

      PropertyImngObj.getProperties('List.FileRepository.Mode', true, function(pFileMode)
      {

        window.vmSearch = new Vue({
          el : '#' + createPageObj.getElementId('ImngSearchObject'),
          data : {
            pageSize : '10',
            object : {
              interfaceServiceId : null,
              fromCreateDateTime : '',
              toCreateDateTime : '',
              pk : {
                adapterId : null,
                fileDate : null
              }
            },
            fileStatus : [],
            fileMode : []
          },
          methods : {
            search : function()
            {
              vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
              vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/igate/fileRepository/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                        vmList.totalCount = result.object;
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
                this.object.pk.fileMode = ' ' ;
                this.object.pk.adapterId = null ;
                this.object.pk.fileName = null ;
                this.object.pk.fileDate = null ;
                this.object.interfaceServiceId = null ;
                this.object.fileStatus = ' ' ;
                this.object.fromCreateDateTime = null ;
                this.object.toCreateDateTime = null ;            	  
              }	  

              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#fileMode'), this.object.pk.fileMode) ;
              initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#fileStatus'), this.object.fileStatus) ;

              initDateSinglePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchSingleDaterange')) ;
              initDateRangePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateFrom'), $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchDateTo')) ;

              this.$forceUpdate() ;
            },
            openModal : function(openModalParam)
            {
              createPageObj.openModal.call(this, openModalParam) ;
            },
            setSearchAdapterId : function(param)
            {
              this.object.pk.adapterId = param.adapterId ;
            },
            setSearchServiceId : function(param)
            {
              this.object.interfaceServiceId = param.serviceId ;
            }
          },
          created : function()
          {
            this.fileMode = pFileMode ;
            this.fileStatus = pfileStatus ;
          },
          mounted : function()
          {
            this.initSearchArea() ;
          },
        }) ;

        var vmList = new Vue({
          el : '#' + createPageObj.getElementId('ImngListObject'),
          data : {
            makeGridObj : null,
            newTabPageUrl: "<c:url value='/igate/fileRepository.html' />",
            totalCount: '0',
          },
          methods : $.extend(true, {}, listMethodOption, {
            initSearchArea : function()
            {
              window.vmSearch.initSearchArea() ;
            },
            updateReady : function()
            {
              $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item)
              {
                StatusImngObj.updateReady("<c:url value='/igate/fileRepository/updateReady.json'/>", $.param({
                  "pk.fileMode" : item['pk.fileMode'],
                  "pk.adapterId" : item['pk.adapterId'],
                  "pk.fileDate" : item['pk.fileDate'],
                  "pk.fileName" : item['pk.fileName'],
                  "pk.fileSequence" : item['pk.fileSequence'],
                  fileStatus : item.fileStatus
                }), item.rowKey, "fileStatus") ;
              }) ;
            },
            updateCancel : function()
            {
              $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item)
              {
                StatusImngObj.updateCancel("<c:url value='/igate/fileRepository/updateCancel.json'/>", $.param({
                  "pk.fileMode" : item['pk.fileMode'],
                  "pk.adapterId" : item['pk.adapterId'],
                  "pk.fileDate" : item['pk.fileDate'],
                  "pk.fileName" : item['pk.fileName'],
                  "pk.fileSequence" : item['pk.fileSequence'],
                  fileStatus : item.fileStatus
                }), item.rowKey, "fileStatus") ;
              }) ;
            }
          }),
          mounted : function()
          {

            this.makeGridObj = getMakeGridObj() ;

            this.makeGridObj.setConfig({
              elementId : createPageObj.getElementId('ImngSearchGrid'),
              onClick : SearchImngObj.clicked,
              searchUri : "<c:url value='/igate/fileRepository/search.json'/>",
              viewMode : "${viewMode}",
              popupResponse : "${popupResponse}",
              popupResponsePosition : "${popupResponsePosition}",
              rowHeaders : ['checkbox'],
              columns : [{
                name : "pk.fileMode",
                header : "<fmt:message>head.file</fmt:message> <fmt:message>head.mode</fmt:message>",
                align : "center",
                width: "6%",
                formatter : function(value)
                {
                  var rtnValue = '' ;
                  
                  for(var i = 0; i < window.vmSearch.fileMode.length; i++) 
                  {
                    if(value.row['pk.fileMode'] == window.vmSearch.fileMode[i].pk.propertyKey)
                    {
                      rtnValue = window.vmSearch.fileMode[i].propertyValue ;	
                      break ;
                    }
                  }
                  
                  return rtnValue ;
                }
              },{
                  name : "pk.fileDate",
                  header : "<fmt:message>head.file</fmt:message> <fmt:message>head.date</fmt:message>",
                  align : "center",
                  width: "10%"
                }, {
                name : "pk.adapterId",
                header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "10%"
              },  {
                name : "pk.fileName",
                header : "<fmt:message>head.file</fmt:message> <fmt:message>head.name</fmt:message>",
                align : "left",
                width: "14%"
              }, {
                name : "instanceId",
                header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "12%"
              }, {
                name : "interfaceServiceId",
                header : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.service</fmt:message> <fmt:message>head.id</fmt:message>",
                align : "left",
                width: "12%"
              }, {
                name : "fileLength",
                header : "<fmt:message>head.file</fmt:message> <fmt:message>head.length</fmt:message>",
                align : "right",
                width: "6%",
                formatter: function(info) {
              	  return numberWithComma(info.row.fileLength);
                }
              }, {
                name : "createDateTime",
                header : "<fmt:message>igate.connectorControl.create</fmt:message> <fmt:message>head.date</fmt:message>",
                align : "center",
                width: "12%"
              }, {
                name : "fileStatus",
                header : "<fmt:message>head.file</fmt:message> <fmt:message>head.status</fmt:message>",
                align : "center",
                width: "8%",
                formatter : function(value)
                {
                  switch (value.row.fileStatus)
                  {
                  case 'R' : {
                    return "<fmt:message>igate.fileRepository.ready</fmt:message>" ;
                  }
                  case 'W' : {
                    return "<fmt:message>igate.fileRepository.wait</fmt:message>" ;
                  }
                  case 'M' : {
                    return "<fmt:message>igate.fileRepository.making</fmt:message>" ;
                  }
                  case 'A' : {
                    return "<fmt:message>igate.fileRepository.active</fmt:message>" ;
                  }
                  case 'E' : {
                    return "<fmt:message>igate.fileRepository.error</fmt:message>" ;
                  }
                  case 'D' : {
                    return "<fmt:message>igate.fileRepository.done</fmt:message>" ;
                  }
                  case 'P' : {
                    return "<fmt:message>igate.fileRepository.process</fmt:message>" ;
                  }
                  case 'X' : {
                    return "<fmt:message>igate.fileRepository.expire</fmt:message>" ;
                  }
                  case 'C' : {
                    return "<fmt:message>igate.fileRepository.cancel</fmt:message>" ;
                  }
                  case 'H' : {
                    return "<fmt:message>igate.fileRepository.finish</fmt:message>" ;
                  }
                  case 'F' : {
                    return "<fmt:message>igate.fileRepository.fail</fmt:message>" ;
                  }
                  }
                }
              }],
            }) ;

            SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
            
            this.newTabSearchGrid();
          }
        }) ;
      }) ;
    }) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/fileRepository/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/fileRepository/control.json'/>"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          pk : {}
        },
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.fileMode' : this.object.pk.fileMode,
            'pk.adapterId' : this.object.pk.adapterId,
            'pk.fileDate' : this.object.pk.fileDate,
            'pk.fileName' : this.object.pk.fileName,
            'pk.fileSequence' : this.object.pk.fileSequence,
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
            this.object.interfaceServiceId = null ;
            this.object.instanceId = null ;
            this.object.createDateTime = null ;
            this.object.fileRemoteName = null ;
            this.object.fileStatus = null ;
            this.object.filePath = null ;
            this.object.fileLength = null ;
            this.object.fileOffset = null ;
          }

          this.object.pk.fileMode = null ;
          this.object.pk.adapterId = null ;
          this.object.pk.fileName = null ;
          this.object.pk.fileDate = null ;
          this.object.pk.fileSequence = null ;
        }
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;

  function initDateSinglePicker(vueObj, dateRangeSelector)
  {
    var startDate = null;

    if(vueObj.object.pk.fileDate)
    {
   	  var year = vueObj.object.pk.fileDate.substring(0, 4);
   	  var month = vueObj.object.pk.fileDate.substring(4, 6);
   	  var day = vueObj.object.pk.fileDate.substring(6, 8);
		
   	  startDate = month + '/' + day + '/' + year;
    }
    
    dateRangeSelector.customDatePicker(function(time)
    {
      vueObj.object.pk.fileDate = time ;
    }, {startDate: startDate}) ;
  }

  function initDateRangePicker(vueObj, dateFromSelector, dateToSelector)
  {

    dateFromSelector.customDateRangePicker('from', function(fromTime)
    {
      vueObj.object.fromCreateDateTime = fromTime ;

      dateToSelector.customDateRangePicker('to', function(toTime)
      {
        vueObj.object.toCreateDateTime = toTime ;
      }, {
        minDate : fromTime,
        startDate : vueObj.object.toCreateDateTime
      }) ;

    }, {startDate : vueObj.object.fromCreateDateTime}) ;
  }
</script>