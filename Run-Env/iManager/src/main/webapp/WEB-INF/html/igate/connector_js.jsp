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

    createPageObj.setViewName('connector') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.connectorId",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.connectorName",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.connectorType",
        'optionFor' : 'option in connectorTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'connectorTypes'
      },
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.connectorDesc",
      'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasConnectorEditor,
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
          'mappingDataInfo' : "object.connectorId",
          'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.connectorName",
          'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>"
        }, {
          'type' : "select",
          'warning' : "<fmt:message>igate.connector.alert.type.empty</fmt:message>",
          'mappingDataInfo' : {
            'selectModel' : 'object.connectorType',
            'optionFor' : 'option in connectorTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue',
            'changeEvt' : 'onChangeTypeValue()'
          },
          'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.type</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.requestDirection',
            'optionFor' : 'option in connectorRequestdirections',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.connector.requestDirection</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/adapter.html',
            'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
            'vModel' : "object.adapterId",
            'callBackFuncName' : 'setSearchAdapterId'
          },
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/threadPool.html',
            'modalTitle' : '<fmt:message>igate.threadPool</fmt:message>',
            'vModel' : "object.threadPoolId",
            'callBackFuncName' : 'setSearchThreadPoolId'
          },
          'name' : "<fmt:message>igate.threadPool</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.connectorLogLevel',
            'optionFor' : 'option in connectorLoglevels',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.log.level</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.connectorStartYn',
            'optionFor' : 'option in connectorStartYns',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.connector.startYn</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.connectorDesc",
          'name' : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>",
          height : 60
        }, ]
      }, ]
    }, {
      'type' : 'custom',
      'id' : 'ConnectorProperties',
      'name' : '<fmt:message>igate.connector</fmt:message> <fmt:message>head.property</fmt:message>',
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
        detailHtml += '        <div class="form-table-body" v-for="(elm, index) in connectorProperties">' ;
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
        detailHtml += '        		<div class="col" v-if="elm.cipher == false || elm.cipher == null">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.propertyValue">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled propertyKey" v-model="elm.propertyDesc"  readonly="readonly" disabled="disabled">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        </div>' ;
        detailHtml += '    </div>' ;
        detailHtml += '</div>' ;

        return detailHtml ;
      }
    }, {
      'type' : 'property',
      'id' : 'ConnectorAdapters',
      'name' : '<fmt:message>igate.adapter</fmt:message>',
      'addRowFunc' : 'addConnectorAdapter',
      'removeRowFunc' : 'removeConnectorAdapter(index)',
      'mappingDataInfo' : 'connectorAdapters',
      'detailList' : [{
        'type' : 'text',
        'mappingDataInfo' : 'elm.pk.adapterId',
        'name' : '<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>',
        'disabled' : true
      }, ]
    }, {
      'type' : 'custom',
      'id' : 'ConnectorDeploies',
      'name' : '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<ul class="list-group" style="width: 100%;">' ;
        detailHtml += '    <li class="list-group-item" v-for="(elm, index) in instanceList" v-if="elm.instanceType==\'T\'">' ;
        detailHtml += '        <label class="custom-control custom-checkbox">' ;
        detailHtml += '            <input type="checkbox" class="custom-control-input view-disabled" v-model="connectorSubDeploies[index]" @change="push(elm.instanceId, $event)">' ;
        detailHtml += '            <span class="custom-control-label">{{elm.instanceId}}</span>' ;
        detailHtml += '        </label>' ;
        detailHtml += '    </li>' ;
        detailHtml += '</ul>' ;

        return detailHtml ;
      }
    }]) ;

    createPageObj.setPanelButtonList({
      unblockBtn : hasConnectorEditor,
      blockBtn : hasConnectorEditor,
      interruptBtn : hasConnectorEditor,
      stopForceBtn : hasConnectorEditor,
      stopBtn : hasConnectorEditor,
      startBtn : hasConnectorEditor,
      guideBtn : hasConnectorEditor,
      dumpBtn : hasConnectorEditor,
      removeBtn : hasConnectorEditor,
      goModBtn : hasConnectorEditor,
      saveBtn : hasConnectorEditor,
      updateBtn : hasConnectorEditor,
      goAddBtn : hasConnectorEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/connector/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/connector/control.json' />"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          adapterId : null,
          threadPoolId : null,
          requestDirection : 'B',
          connectorLogLevel : 'N/A',
          connectorStartYn : 'Y',
          connectorProperties : [],
          connectorAdapters : [],
          connectorDeploies : []
        },
        connectorTypes : [],
        connectorLoglevels : [],
        connectorRequestdirections : [],
        connectorStartYns : [],
        uri : '',
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            connectorId : this.object.connectorId
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Connector.Type', true, function(properties)
        {
          this.connectorTypes = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.LogLevel', false, function(properties)
        {
          this.connectorLoglevels = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.Connector.RequestDirection', true, function(properties)
        {
          this.connectorRequestdirections = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.Yn', true, function(properties)
        {
          this.connectorStartYns = properties ;
        }.bind(this)) ;
      },
      methods : {
        onChangeTypeValue : function()
        {
          getPropertyList([{
            uri : "<c:url value='/igate/connector/propertyKeys.json?connectorType=" + this.object.connectorType + "&requireFlag=true' />"
          }]) ;
        },
        loaded : function()
        {

          var deploies = window.vmConnectorDeploies ;

          deploies.connectorSubDeploies = [] ;
          deploies.instanceList.forEach(function(element)
          {

            if (element.instanceType == 'T')
            {

              var value = -1 ;

              for (var i = 0 ; i < deploies.connectorDeploies.length ; i++)
              {

                if (deploies.connectorDeploies[i].pk.instanceId === element.instanceId)
                {
                  value = i ;
                  break ;
                }
              }

              if (value != -1)
                deploies.connectorSubDeploies.push(true) ;
              else
                deploies.connectorSubDeploies.push(false) ;
            }
          }) ;
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
            this.object.connectorName = null ;
            this.object.connectorType = null ;
            this.object.requestDirection = null ;
            this.object.adapterId = null ;
            this.object.threadPoolId = null ;
            this.object.connectorLogLevel = null ;
            this.object.connectorStartYn = null ;
            this.object.connectorDesc = null ;
            this.object.connectorId = null ;

            window.vmConnectorProperties.connectorProperties = [] ;
            window.vmConnectorAdapters.connectorAdapters = [] ;
            window.vmConnectorDeploies.connectorSubDeploies = [] ;
          }
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.adapterId = param.adapterId ;
        },
        setSearchThreadPoolId : function(param)
        {
          this.object.threadPoolId = param.threadPoolId ;
        }
      }
    }) ;

    window.vmConnectorProperties = new Vue({
      el : '#ConnectorProperties',
      data : {
        viewMode : 'Open',
        object : {},
        connectorProperties : [],
        propertyKeys : [],
        uri : ''
      },
      methods : {
        // ['+' 버튼 클릭 시, 이벤트] edit 영역 - 커넥터 Property 탭
        onClickPlus : function()
        {
          var jsonLoad = [{
            uri : "<c:url value='/igate/connector/propertyKeys.json' />" + "?connectorType=" + window.vmMain.object.connectorType,
            attributeName : this.propertyKeys
          }] ;
          getPropertyList(jsonLoad) ;
        },
        propertyAdd : function()
        {
          onCheckPropertyCount() ;
          this.onClickPlus() ;
          this.connectorProperties.push({
            propertyDesc : '',
            pk : {}
          }) ;
        },
        propertyRemove : function(index)
        {
          if (onCheckPropertyCount())
            --propertyCount ;
          this.connectorProperties = this.connectorProperties.slice(0, index).concat(this.connectorProperties.slice(index + 1)) ;
        }
      }
    }) ;

    window.vmConnectorAdapters = new Vue({
      el : '#ConnectorAdapters',
      data : {
        viewMode : 'Open',
        object : {},
        connectorAdapters : [],
      },
      methods : {
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        addConnectorAdapter : function()
        {
          this.openModal({
            'url' : '/igate/adapter.html',
            'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
            "callBackFuncName" : "setSearchConnectorAdapterId"
          }) ;
        },
        removeConnectorAdapter : function(index)
        {
          this.connectorAdapters = this.connectorAdapters.slice(0, index).concat(this.connectorAdapters.slice(index + 1)) ;
        },
        setSearchConnectorAdapterId : function(param)
        {

          var isExistAdapterId = false ;

          for (var i = 0 ; i < this.connectorAdapters.length ; i++)
          {
            if (this.connectorAdapters[i].pk.adapterId == param.adapterId)
            {
              isExistAdapterId = true ;
              break ;
            }
          }

          if (isExistAdapterId)
            return ;

          this.connectorAdapters.push({
            pk : {
              adapterId : param.adapterId
            }
          }) ;

        },
      }
    }) ;

    window.vmConnectorDeploies = new Vue({
      el : '#ConnectorDeploies',
      data : {
        uri : "<c:url value='/igate/instance/list.json' />",
        connectorDeploies : [],
        connectorSubDeploies : [],
        instanceList : [],
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
            "pk.connectorId" : this.connectorDeploies.pk.connectorId,
            "pk.instanceId" : this.connectorDeploies.pk.instanceId
          } ;
        }
      },
      methods : {
        push : function(value, e)
        {
          if (e.target.checked)
          { //check true
            this.connectorDeploies.push({
              "pk" : {
                "connectorId" : window.vmMain.object.connectorId,
                "instanceId" : value
              }
            }) ;
          }
          else
          { //check false
            for (var i = 0 ; i < this.connectorDeploies.length ; i++)
            {
              if (this.connectorDeploies[i].pk.instanceId === value)
              {
                this.connectorDeploies.splice(i, 1) ;
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
        guide : function()
        {
          window.open("<c:url value='/manual/Connector Guide.htm' />", "_blank", "height=886, width=785,resizable=yes, toolbar=no, menubar=no, location=no, scrollbars=yes, status=no") ;
        },
        start : function()
        {
          ControlImngObj.control("start", null, $.param({
            connectorId : window.vmMain.object.connectorId
          })) ;
        },
        stop : function()
        {
          ControlImngObj.control("stop", null, $.param({
            connectorId : window.vmMain.object.connectorId
          })) ;
        },
        stopForce : function()
        {
          normalConfirm({message :"<fmt:message>igate.connectorControl.alert</fmt:message>", callBackFunc : function()
          {
            ControlImngObj.control("stopForce", null, $.param({
              connectorId : window.vmMain.object.connectorId
            })) ;
          }}) ;
        },
        interrupt : function()
        {
          ControlImngObj.control("interrupt", null, $.param({
            connectorId : window.vmMain.object.connectorId
          })) ;
        },
        block : function()
        {
          ControlImngObj.control("block", null, $.param({
            connectorId : window.vmMain.object.connectorId
          })) ;
        },
        unblock : function()
        {
          ControlImngObj.control("unblock", null, $.param({
            connectorId : window.vmMain.object.connectorId
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

    PropertyImngObj.getProperties('List.Connector.Type', true, function(connectorTypes)
    {

      window.vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            connectorType : " ",
            connectorId : null,
            connectorName : null,
            connectorDesc : null
          },
          connectorTypes : [],
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
              this.object.connectorId = null ;
              this.object.connectorName = null ;
              this.object.connectorDesc = null ;
              this.object.connectorType = ' ' ;        		
        	}

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorTypes'), this.object.connectorType) ;
          },
        },
        mounted : function()
        {
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#connectorTypes'), this.object.connectorType) ;
        },
        created : function()
        {
          this.connectorTypes = connectorTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          newTabPageUrl: "<c:url value='/igate/connector.html' />"
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
            searchUri : "<c:url value='/igate/connector/search.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "connectorId",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left",
              width: "20%",
            }, {
              name : "connectorName",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.name</fmt:message>",
              align : "left",
              width: "20%",
            }, {
            	name : 'connectorType',
            	header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.type</fmt:message>",
            	align : "center",
            	width : "10%",
            	formatter : function(obj) 
            	{
            	  var rtnValue = '';
            	  
            	  for(var i = 0; i < window.vmSearch.connectorTypes.length; i++)
            	  {
            	    if(window.vmSearch.connectorTypes[i].pk.propertyKey == obj.value)
            	    {
            	      rtnValue = window.vmSearch.connectorTypes[i].propertyValue ;
            	      break ;
            	    }
            	  }
            	  
            	  return rtnValue ;
            	}
            }, {
              name : "connectorDesc",
              header : "<fmt:message>igate.connector</fmt:message> <fmt:message>head.description</fmt:message>",
              align : "left",
              width: "20%",
            }]
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
          
          this.newTabSearchGrid();
        }
      }) ;
    }) ;
  }) ;

  //커넥터 Property 리스트 조회
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
            window.vmConnectorProperties.connectorProperties = result.object ; //필수 값인 항목들 표시 용도

          //onClickPlus 에서 호출된 경우,
          else
          {
            var propertyKey = [] ;
            for (key in result.object)
              propertyKey[key] = result.object[key].pk.propertyKey ;
            window.vmConnectorProperties.propertyKeys = propertyKey ;
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
    var paramPropertyId = window.vmMain.object.connectorType ; // Connector Type
    var paramPropertyKey = window.vmConnectorProperties.connectorProperties[index] ; // Property Key
    var propertyValue = "" ;
    var propertyDesc = "" ;

    // #으로 시작하는 경우, 설명 : 갱신
    if (paramPropertyKey.pk.propertyKey.startsWith("#"))
    {
      window.vmConnectorProperties.connectorProperties[index].propertyDesc = propertyDesc ;
    }
    // #으로 시작하는 옵션이 아닌경우, 기본값 & 설명 : 갱신 가능
    else
    {
      $.ajax({
        type : "GET",
        url : "<c:url value='/common/property/properties.json' />",
        data : {
          "propertyId" : "Property.Connector." + paramPropertyId,
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
              window.vmConnectorProperties.connectorProperties[index].propertyValue = propertyValue ;

            window.vmConnectorProperties.connectorProperties[index].propertyDesc = propertyDesc ;
          }
        },
        error : function(request, status, error)
        {
          ResultImngObj.errorHandler(request, status, error) ;
        }
      }) ;
    }
  } ;

  // Flag에 의해 최초 프로퍼티 개수 Count
  function onCheckPropertyCount()
  {
    if (firstTemplateMode)
    {
      firstTemplateMode = false ;
      propertyCount = window.vmConnectorProperties.connectorProperties.length ;
      return true ;
    }
    return false ;
  } ;

  function checkOverlap()
  {
    var checkPropertyArray = window.vmConnectorProperties.connectorProperties.map(function(element)
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
	  warnAlert({alertMessage : '<fmt:message key="igate.connector.alert.overlap"><fmt:param value="' + overlapElement + '" /></fmt:message>'}) ;
      return false ;
    }
    return true ;
  }
</script>