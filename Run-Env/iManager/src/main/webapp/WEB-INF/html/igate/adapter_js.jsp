<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  var firstTemplateMode = true ; // 최초 옵션 Count를 위한 Flag
  var propertyCount = 0 ; // 최초 옵션 Count

  String.prototype.startsWith = function(str)
  {
    if (this.length < str.length)
    {
      return false ;
    }
    return this.indexOf(str) == 0 ;
  }

  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('adapter') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.adapterId",
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.adapterName",
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.adapterDesc",
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasAdapterEditor,
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
          'mappingDataInfo' : "object.adapterId",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.adapterName",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.name</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.charset",
          'name' : "<fmt:message>igate.adapter.charset</fmt:message>"
        }, {
            'type' : "select",
            'warning' : "<fmt:message>igate.adapter.alert.type.empty</fmt:message>",
            'mappingDataInfo' : {
              'selectModel' : 'object.adapterType',
              'optionFor' : 'option in adapterTypes',
              'optionValue' : 'option.pk.propertyKey',
              'optionText' : 'option.propertyValue',
              'changeEvt' : 'onChangeTypeValue'
            },
            'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.type</fmt:message>"
        } ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.endian',
            'optionFor' : 'option in adapterEndians',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.adapter.endian</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.queueMode',
            'optionFor' : 'option in adapterQueueModes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.adapter.queue.mode</fmt:message>",
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.queueLogLevel',
            'optionFor' : 'option in queueLogLevels',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.queue</fmt:message> <fmt:message>head.log.level</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/record.html',
            'modalTitle' : '<fmt:message>igate.record</fmt:message>',
            'vModel' : "object.requestStructure",
            "callBackFuncName" : "setSearchRequestStructure"
          },
          'name' : "<fmt:message>igate.adapter.structure.request</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/record.html',
            'modalTitle' : '<fmt:message>igate.record</fmt:message>',
            'vModel' : "object.responseStructure",
            "callBackFuncName" : "setSearchResponseStructure"
          },
          'name' : "<fmt:message>igate.adapter.structure.response</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/activity.html',
            'modalTitle' : '<fmt:message>igate.activity</fmt:message>',
            'vModel' : "object.telegramHandler",
            "callBackFuncName" : "setSearchTelegramHandler"
          },
          'name' : "<fmt:message>igate.adapter.telegramHandler</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.adapterDesc",
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>"
        }, ]
      }, ]
    }, {
      'type' : 'property',
      'id' : 'AdapterOperations',
      'name' : '<fmt:message>igate.adapter</fmt:message> <fmt:message>igate.operation</fmt:message>',
      'addRowFunc' : 'operationAdd',
      'removeRowFunc' : 'operationRemove(index)',
      'mappingDataInfo' : 'adapterOperations',
      'detailList' : [{
        'type' : 'select',
        'mappingDataInfo' : {
          'selectModel' : 'elm.pk.adapterEvent',
          'optionFor' : 'option in adapterEvents',
          'optionValue' : 'option.pk.propertyKey',
          'optionText' : 'option.propertyValue'
        },
        'name' : '<fmt:message>igate.adapter.event</fmt:message>'
      }, {
        'type' : 'search',
        'mappingDataInfo' : {
          'url' : '/igate/operation.html',
          'modalTitle' : '<fmt:message>igate.operation</fmt:message>',
          'vModel' : "elm.operationId",
          "callBackFuncName" : "setOperationId"
        },
        'name' : '<fmt:message>igate.operation</fmt:message> <fmt:message>head.id</fmt:message>'
      }, {
        'type' : 'text',
        'mappingDataInfo' : 'elm.cronExpression',
        'name' : '<fmt:message>igate.adapter.cronExpression</fmt:message>'
      }, {
        'type' : 'search',
        'mappingDataInfo' : {
          'url' : '/igate/calendar.html',
          'modalTitle' : '<fmt:message>igate.calendar</fmt:message>',
          'vModel' : "elm.calendarId",
          "callBackFuncName" : "setCalendarId"
        },
        'name' : '<fmt:message>igate.calendar</fmt:message><fmt:message>head.id</fmt:message>'
      }, {
        'type' : 'select',
        'mappingDataInfo' : {
          'selectModel' : 'elm.disabledYn',
          'optionFor' : 'option in adapterDisabledYns',
          'optionValue' : 'option.pk.propertyKey',
          'optionText' : 'option.propertyValue'
        },
        'name' : '<fmt:message>igate.adapter.disabledYn</fmt:message>'
      }, ]
    }, {
      'type' : 'custom',
      'id' : 'AdapterProperties',
      'name' : '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.property</fmt:message>',   
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<div class="form-table form-table-responsive">' ;
        detailHtml += '    <div class="form-table-wrap">' ;
        detailHtml += '        <div class="form-table-head">' ;
        detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyAdd();"><i class="icon-plus-circle"></i></button>' ;
        detailHtml += '			   <label class="col"><fmt:message>common.property.key</fmt:message></label>' ;
        detailHtml += '			   <label class="col"><fmt:message>common.property.value</fmt:message></label>' ;
        detailHtml += '			   <label class="col"><fmt:message>head.description</fmt:message></label>' ;
        detailHtml += '        </div>' ;
        detailHtml += '        <div class="form-table-body" v-for="(elm, index) in adapterProperties">' ;
        detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require == true"><i class="icon-star"></i></button>' ;
        detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyRemove(index);" v-if="elm.require == false || elm.require == null"><i class="icon-minus-circle"></i></button>' ;
        detailHtml += '        		<div class="col" v-if="elm.require == true">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled propertyKey" list="propertyKeys" v-model="elm.pk.propertyKey" readonly="readonly" disabled="disabled">' ;
        detailHtml += '        			<datalist id="propertyKeys">' ;
        detailHtml += '        				<option v-for="et in propertyKeys">{{et}}</option>' ;
        detailHtml += '        			</datalist>' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col" v-if="elm.require != true">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" @change="searchPropertyKey(index);">' ;
        detailHtml += '        			<datalist id="propertyKeys">' ;
        detailHtml += '        				<option v-for="et in propertyKeys">{{et}}</option>' ;
        detailHtml += '        			</datalist>' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col" v-if="elm.cipher == true">' ;
        detailHtml += '        			<input type="password" class="form-control view-disabled" v-model="elm.propertyValue">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col"  v-if="elm.cipher == false || elm.cipher == null">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.propertyValue">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled propertyKey" v-model="elm.propertyDesc" readonly="readonly" disabled="disabled">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        </div>' ;
        detailHtml += '    </div>' ;
        detailHtml += '</div>' ;

        return detailHtml ;
      }
    }, {
      'type' : 'custom',
      'id' : 'Connectors',
      'name' : '<fmt:message>igate.connector</fmt:message>',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '    <div class="col-lg-6">' ;
        detailHtml += '        <div class="form-group">' ;
        detailHtml += '            <label class="control-label">' ;
        detailHtml += '                <span><fmt:message>igate.connector</fmt:message> ID</span>' ;
        detailHtml += '            </label>' ;
        detailHtml += '        </div>' ;
        detailHtml += '        <div class="form-group" v-for="index in connectors">' ;
        detailHtml += '            <div class="input-group">' ;
        detailHtml += '                <input type="text" class="form-control view-disabled readonly disabled" v-model="index" disabled readonly>' ;
        detailHtml += '            </div>' ;
        detailHtml += '        </div>' ;
        detailHtml += '    </div>' ;

        return $(detailHtml) ;
      }
    }, {
      'type' : 'custom',
      'id' : 'AdapterQueueDeploies',
      'name' : '<fmt:message>igate.adapter.queue.deploies</fmt:message>',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<ul class="list-group" style="width: 100%;">' ;
        detailHtml += '    <li class="list-group-item" v-for="(elm, index) in instanceList" v-if="elm.instanceType==\'T\'">' ;
        detailHtml += '        <label class="custom-control custom-checkbox">' ;
        detailHtml += '            <input type="checkbox" class="custom-control-input view-disabled" v-model="adapterSubDeploies[index]" @change="push(elm.instanceId, $event)">' ;
        detailHtml += '            <span class="custom-control-label">{{elm.instanceId}}</span>' ;
        detailHtml += '        </label>' ;
        detailHtml += '    </li>' ;
        detailHtml += '</ul>' ;

        return detailHtml ;
      }
    }]) ;

    createPageObj.setPanelButtonList({
      startBtn : hasAdapterEditor,
      stopBtn : hasAdapterEditor,
      dumpBtn : hasAdapterEditor,
      removeBtn : hasAdapterEditor,
      goModBtn : hasAdapterEditor,
      saveBtn : hasAdapterEditor,
      updateBtn : hasAdapterEditor,
      goAddBtn : hasAdapterEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/adapter/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/adapter/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
			adapterId : null,
			adapterName : null,
			adapterDesc : null
        }
      },
      methods : {
        search : function()
        {
          if ('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display'))
          {
            $('#' + createPageObj.getElementId('ImngListObject')).show() ;
            $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide() ;
          }

          vmList.makeGridObj.search(this) ;
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
	        this.object.adapterId = null ;
	        this.object.adapterName = null ;
	        this.object.adapterDesc = null ;		  
		  }	  

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        }
      },
      mounted : function()
      {
        initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
      }
    }) ;

    var vmList = new Vue({
      el : '#' + createPageObj.getElementId('ImngListObject'),
      data : {
        makeGridObj : null,
        newTabPageUrl: "<c:url value='/igate/adapter.html' />"
      },
      methods : $.extend(true, {}, listMethodOption, {
        initSearchArea : function()
        {
          window.vmSearch.initSearchArea() ;
        }
      }),
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/adapter/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "adapterId",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "25%"
          }, {
            name : "adapterName",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "25%"
          }, {
            name : "adapterDesc",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.description</fmt:message>",
            align : "left",
            width: "25%"
          }, {
            name : "requestStructure",
            header : "<fmt:message>igate.adapter.structure.request</fmt:message>",
            align : "left",
            width: "25%"
          }, {
            name : "responseStructure",
            header : "<fmt:message>igate.adapter.structure.response</fmt:message>",
            align : "left",
            width: "25%"
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
          requestStructure : null,
          responseStructure : null,
          telegramHandler : null,
          queueLogLevel : 'N/A',
          queueMode : '',
          pk : {},
          adapterOperations : [],
          adapterProperties : [],
          adapterQueueDeploies : [],
          adapterType: null,
        },
        adapterQueueModes : [],
        queueLogLevels : [],
        adapterEndians : [],
        adapterTypes: [],
        uri : '',
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            adapterId : this.object.adapterId
          } ;
        }
      },
      created : function()
      {
    	PropertyImngObj.getProperties('List.Adapter.Type', true, function(properties)
    	{
    		this.adapterTypes = properties ;
    	}.bind(this)) ;     	  
    	  
        PropertyImngObj.getProperties('List.Adapter.Queuemode', false, function(properties)
        {
          this.adapterQueueModes = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.LogLevel', false, function(properties)
        {
          this.queueLogLevels = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.Adapter.Endian', true, function(properties)
        {
          this.adapterEndians = properties ;
        }.bind(this)) ;
      },
      methods : {
    	onChangeTypeValue : function()
        {
    	    getPropertyList([{
    	    	uri : "<c:url value='/igate/adapter/propertyKeys.json?adapterType=" + this.object.adapterType + "&requireFlag=true' />"
    	    }]) ;
        },    	  
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
            this.object.adapterName = null ;
            this.object.charset = null ;
            this.object.endian = null ;
            this.object.queueMode = null ;
            this.object.queueLogLevel = null ;
            this.object.requestStructure = null ;
            this.object.responseStructure = null ;
            this.object.telegramHandler = null ;
            this.object.adapterDesc = null ;
			this.object.adapterType = null ;
	        this.object.adapterId = null ;
            
            window.vmAdapterOperations.adapterOperations = [] ;
            window.vmAdapterProperties.adapterProperties = [] ;
            window.vmConnectors.connectors = [] ;
            window.vmAdapterQueueDeploies.adapterSubDeploies = [] ;
          }
        },
        loaded : function()
        {
          var deploies = window.vmAdapterQueueDeploies ;

          deploies.adapterSubDeploies = [] ;
          deploies.instanceList.forEach(function(element)
          {

            if (element.instanceType == 'T')
            {
              var value = -1 ;
              for (var i = 0 ; i < deploies.adapterQueueDeploies.length ; i++)
              {

                if (deploies.adapterQueueDeploies[i].pk.instanceId === element.instanceId)
                {
                  value = i ;
                  break ;
                }
              }

              if (value != -1)
                deploies.adapterSubDeploies.push(true) ;
              else
                deploies.adapterSubDeploies.push(false) ;
            }
          }) ;
        },
        openModal : function(openModalParam)
        {

          if ('/igate/record.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              recordType : 'H'
            } ;
          }
          else if ('/igate/activity.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              activityType : 'H'
            } ;
          }

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchRequestStructure : function(param)
        {
          this.object.requestStructure = param.recordId ;
          this.$forceUpdate();
        },
        setSearchResponseStructure : function(param)
        {
          this.object.responseStructure = param.recordId ;
          this.$forceUpdate();
        },
        setSearchTelegramHandler : function(param)
        {
          this.object.telegramHandler = param.activityId ;
          this.$forceUpdate();
        },
      }
    }) ;

    window.vmAdapterOperations = new Vue({
      el : '#AdapterOperations',
      data : {
        viewMode : 'Open',
        adapterOperations : [],
        adapterEvents : [],
        adapterDisabledYns : [],
        cacheOperationPopup : {
          operationId : null
        },
        cacheCalendarPopup : {
          calendarId : null
        },
        selectedIndex : null,
      },
      methods : {
        operationAdd : function()
        {
          this.adapterOperations.push({
            operationId : null,
            calendarId : null,
            cronExpression : null,
            disabledYn : 'N',
            pk : {}
          }) ;
        },
        operationRemove : function(index)
        {
          this.adapterOperations = this.adapterOperations.slice(0, index).concat(this.adapterOperations.slice(index + 1)) ;
        },
        openModal : function(openModalParam, selectedIndex)
        {

          if ('/igate/operation.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              operationType : 'A'
            } ;
          }

          this.selectedIndex = selectedIndex ;

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setOperationId : function(param)
        {
          this.adapterOperations[this.selectedIndex].operationId = param.operationId ;
          this.$forceUpdate() ;
        },
        setCalendarId : function(param)
        {
          this.adapterOperations[this.selectedIndex].calendarId = param.calendarId ;
          this.$forceUpdate() ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Adapter.Event', true, function(adapterEvents)
        {
          this.adapterEvents = adapterEvents ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.Yn', false, function(adapterDisabledYns)
        {
          this.adapterDisabledYns = adapterDisabledYns ;
        }.bind(this)) ;
      },
    }) ;
    window.vmAdapterProperties = new Vue({
      el : '#AdapterProperties',
      data : {
        viewMode : 'Open',
        object : {
          pk : {}
        },
        adapterProperties : [],
        propertyKeys : [],
        uri : ''
      },
      methods : {
        // ['+' 버튼 클릭 시, 이벤트] edit 영역 - 커넥터 Property 탭
        onClickPlus : function()
        {
          var jsonLoad = [{
        	uri : "<c:url value='/igate/adapter/propertyKeys.json?adapterType=" + window.vmMain.object.adapterType + "' />",
            attributeName : this.propertyKeys
          }] ;
          getPropertyList(jsonLoad) ;
        },
        propertyAdd : function()
        {
          onCheckPropertyCount() ;
          this.onClickPlus() ;
          this.adapterProperties.push({
            propertyDesc : '',
            pk : {}
          }) ;
        },
        propertyRemove : function(index)
        {
          if (onCheckPropertyCount())
            --propertyCount ;
          this.adapterProperties = this.adapterProperties.slice(0, index).concat(this.adapterProperties.slice(index + 1)) ;
        }
      }
    }) ;

    window.vmConnectors = new Vue({
      el : '#Connectors',
      data : {
        viewMode : 'Open',
        object : {},
        connectors : []
      }
    }) ;

    window.vmAdapterQueueDeploies = new Vue({
      el : '#AdapterQueueDeploies',
      data : {
        instanceList : [],
        uri : "<c:url value='/igate/instance/list.json' />",
        adapterQueueDeploies : [],
        adapterSubDeploies : []
      },
      mounted : function()
      {
        $.getJSON(this.uri, function(data)
        {
          this.instanceList = data.object ;
        }.bind(this)) ;
      },
      computed : {
        pk : function()
        {
          return {
            "pk.adapterId" : this.adapterQueueDeploies.pk.adapterId,
            "pk.instanceId" : this.adapterQueueDeploies.pk.instanceId
          } ;
        }
      },
      methods : {
        push : function(value, e)
        {
          if (e.target.checked)
          { //check true
            this.adapterQueueDeploies.push({
              "pk" : {
                "adapterId" : window.vmMain.object.adapterId,
                "instanceId" : value
              }
            }) ;
          }
          else
          { //check false
            for (var i = 0 ; i < this.adapterQueueDeploies.length ; i++)
            {
              if (this.adapterQueueDeploies[i].pk.instanceId === value)
              {
                this.adapterQueueDeploies.splice(i, 1) ;
                break ;
              }
            }
          }
        }
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption, {
        start : function()
        {
          ControlImngObj.control("start", null, $.param({
            adapterId : window.vmMain.object.adapterId
          })) ;
        },
        stop : function()
        {
          ControlImngObj.control("stop", null, $.param({
            adapterId : window.vmMain.object.adapterId
          })) ;
        },
        saveInfo : function()
        {
          if (checkOverlap())
            panelMethodOption.saveInfo() ;
        },
        updateInfo : function()
        {
          if (checkOverlap())
            panelMethodOption.updateInfo() ;
        }
      })
    }) ;
  }) ;

  //Flag에 의해 최초 프로퍼티 개수 Count
  function onCheckPropertyCount()
  {
    if (firstTemplateMode)
    {
      firstTemplateMode = false ;
      propertyCount = window.vmAdapterProperties.adapterProperties.length ;
      return true ;
    }
    return false ;
  } ;

  //어댑터 Property 리스트 조회
  function getPropertyList(jsonLoad)
  {
    $.each(jsonLoad, function(idx, value)
    {
      $.ajax({
        type : "GET",
        url : value.uri,
        data : {},
        dataType : "json",
        success : function(result)
        {
          //onChangeTypeValue 에서 호출된 경우,
          if (typeof value.attributeName == "undefined")
            window.vmAdapterProperties.adapterProperties = result.object ; //필수 값인 항목들 표시 용도

          //onClickPlus 에서 호출된 경우,
          else
          {
            var propertyKey = [] ;
            for (key in result.object)
              propertyKey[key] = result.object[key].pk.propertyKey ;
            window.vmAdapterProperties.propertyKeys = propertyKey ;
          }
        },
        error : function(request, status, error)
        {
          ResultImngObj.errorHandler(request, status, error) ;
        }
      }) ;
    }) ;
  } ;

  // 프로퍼티 키 필드의 값 변경 시, onchange 이벤트
  function searchPropertyKey(index)
  {
    onCheckPropertyCount() ;
    var paramPropertyId = window.vmMain.object.adapterType ; // Adapter Type
    var paramPropertyKey = window.vmAdapterProperties.adapterProperties[index] ; // Property Key
    var propertyValue = "" ;
    var propertyDesc = "" ;

    // #으로 시작하는 경우, 설명 : 갱신
    if (paramPropertyKey.pk.propertyKey.startsWith("#"))
    {
      window.vmAdapterProperties.adapterProperties[index].propertyDesc = propertyDesc ;
    }
    // #으로 시작하는 옵션이 아닌경우, 기본값 & 설명 : 갱신 가능
    else
    {
      $.ajax({
        type : "GET",
        url : "<c:url value='/common/property/properties.json' />",
        data : {
          "propertyId" : "Property.Adapter." + paramPropertyId,
          "propertyKey" : paramPropertyKey.pk.propertyKey,
          "orderByKey" : true
        },
        dataType : "json",
        success : function(result)
        {
          if (result.result == "ok")
          {
            // propertyKey가 "" 공백으로 다 건 조회되는 경우 회피.
            if (result.object.length == 1)
            {
              propertyValue = result.object[0].propertyValue ;
              propertyDesc = result.object[0].propertyDesc ;
            }
            //(+) 신규 추가 된 옵션인 경우, 기본값 갱신
            if (propertyCount < (index + 1))
              window.vmAdapterProperties.adapterProperties[index].propertyValue = propertyValue ;

            window.vmAdapterProperties.adapterProperties[index].propertyDesc = propertyDesc ;
          }
        },
        error : function(request, status, error)
        {
          ResultImngObj.errorHandler(request, status, error) ;
        }
      }) ;
    }
  } ;

  function checkOverlap()
  {
    var checkPropertyArray = window.vmAdapterProperties.adapterProperties.map(function(element)
    {
      return element.pk.propertyKey
    }) ;
    var overlapElement ;

    checkPropertyArray.forEach(function(element, index)
    {
      if (checkPropertyArray.indexOf(element) != index)
        overlapElement = element ;
    }) ;

    if (overlapElement)
    {
      warnAlert('<fmt:message key="igate.adapter.alert.overlap"><fmt:param value="' + overlapElement + '" /></fmt:message>') ;
      return false ;
    }
    return true ;
  }
</script>