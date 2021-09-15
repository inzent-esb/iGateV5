<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  var firstTemplateMode = true ;
  var propertyCount = 0 ;

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

    createPageObj.setViewName('instance') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.instanceId",
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.instanceNode",
      'name' : "<fmt:message>igate.instance.node</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.instanceType",
        'optionFor' : 'option in instanceTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'instanceTypes'
      },
      'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasInstanceEditor,
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
          'mappingDataInfo' : "object.instanceId",
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.downStatus',
            'optionFor' : 'elm in instanceDownStatus',
            'optionValue' : 'elm.pk.propertyKey',
            'optionText' : 'elm.propertyValue'
          },
          'name' : "<fmt:message>igate.instance.downStatus</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.logLevel',
            'optionFor' : 'elm in instanceLoglevels',
            'optionValue' : 'elm.pk.propertyKey',
            'optionText' : 'elm.propertyValue'
          },
          'name' : "<fmt:message>head.log.level</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.instanceType',
            'optionFor' : 'elm in instanceTypes',
            'optionValue' : 'elm.pk.propertyKey',
            'optionText' : 'elm.propertyValue'
          },
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.type</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.instanceAddress",
          'name' : "<fmt:message>igate.instance.address</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.instanceNode",
          'name' : "<fmt:message>igate.instance.node</fmt:message>"
        }, ]
      }, ]
    },

    {
      'type' : 'custom',
      'id' : 'InstanceProperties',
      'name' : '<fmt:message>head.property</fmt:message>',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<div class="form-table form-table-responsive">' ;
        detailHtml += '    <div class="form-table-wrap">' ;
        detailHtml += '        <div class="form-table-head">' ;
        detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyAdd();"><i class="icon-plus-circle"></i></button><label class="col"><fmt:message>common.property.key</fmt:message></label><label class="col"><fmt:message>common.property.value</fmt:message></label><label class="col"><fmt:message>head.description</fmt:message></label>' ;
        detailHtml += '        </div>' ;
        detailHtml += '        <div class="form-table-body" v-for="(elm,index) in instanceProperties">' ;
        detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require == true"><i class="icon-star"></i></button>' ;
        detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="propertyRemove(index);" v-if="elm.require == false || elm.require == null"><i class="icon-minus-circle"></i></button>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" @change="searchPropertyKey(index);">' ;
        detailHtml += '        			<datalist id="propertyKeys">' ;
        detailHtml += '        				<option v-for="et in propertyKeys">{{et}}</option>' ;
        detailHtml += '        			</datalist>' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col" v-if="elm.cipher == true">' ;
        detailHtml += '        			<input type="password" class="form-control view-disabled" v-model="elm.propertyValue">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.propertyValue">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.propertyDesc" disabled="disabled">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        </div>' ;
        detailHtml += '    </div>' ;
        detailHtml += '</div>'

        return detailHtml ;
      }
    }]) ;

    createPageObj.setPanelButtonList({
      dumpBtn : hasInstanceEditor,
      removeBtn : hasInstanceEditor,
      goModBtn : hasInstanceEditor,
      saveBtn : hasInstanceEditor,
      updateBtn : hasInstanceEditor,
      goAddBtn : hasInstanceEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/instance/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/instance/control.json' />"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          instanceProperties : [],
          downStatus : 'N'
        },
        projectTypes : [],
        instanceTypes : [],
        instanceDownStatus : [],
        instanceLoglevels : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            instanceId : this.object.instanceId
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Yn', true, function(properties)
        {
          this.instanceDownStatus = properties ;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.LogLevel', false, function(properties)
        {
          properties.forEach(function(item, index)
          {
            if (item.propertyValue == "N/A")
              properties.splice(index, 1) ;
          }) ;
          this.instanceLoglevels = properties ;
        }.bind(this)) ;
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
            this.object.downStatus = 'N' ;
            this.object.logLevel = null ;
            this.object.instanceType = null ;
            this.object.instanceAddress = null ;
            this.object.instanceNode = null ;
            this.object.instanceId = null ;
            
            window.vmInstanceProperties.instanceProperties = [] ;
          }
        },
      },
    }) ;

    window.vmInstanceProperties = new Vue({
      el : '#InstanceProperties',
      data : {
        instanceProperties : [],
        propertyKeys : []
      },
      methods : {
        onClickPlus : function()
        {
          var jsonLoad = [{
            uri : "<c:url value='/igate/instance/propertyKeys.json' />",
            attributeName : this.propertyKeys
          }] ;
          getPropertyList(jsonLoad) ;
        },
        propertyAdd : function()
        {
          onCheckPropertyCount() ;
          this.onClickPlus() ;
          this.instanceProperties.push({
            pk : {}
          }) ;
        },
        propertyRemove : function(index)
        {
          if (onCheckPropertyCount())
            --propertyCount ;
          this.instanceProperties = this.instanceProperties.slice(0, index).concat(this.instanceProperties.slice(index + 1)) ;
        }
      },
      mounted : function()
      {
        var self = this
        $.getJSON(this.executePrivilegeIdsUri, function(data)
        {
          self.executePrivilegeIds = data.object ;
        }) ;
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption, {
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

    PropertyImngObj.getProperties('List.Instance.InstanceType', true, function(instanceTypes)
    {

      window.vmMain.instanceTypes = instanceTypes ;

      window.vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            instanceType : " "
          },
          instanceTypes : []
        },
        methods : {
          search : function()
          {
        	vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
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
              this.object.instanceId = null ;
              this.object.instanceNode = null ;
              this.object.instanceType = ' ' ;        		
        	}

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.object.instanceType) ;
          }
        },
        mounted : function()
        {
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#instanceTypes'), this.object.instanceType) ;
        },
        created : function()
        {
          this.instanceTypes = instanceTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          newTabPageUrl: "<c:url value='/igate/instance.html' />"
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
            searchUri : "<c:url value='/igate/instance/search.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "instanceId",
              header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left",
              width: '30%'
            }, {
              name : "instanceType",
              header : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "center",
              width: '10%',
              formatter : function(value)
              {
                switch (value.row.instanceType)
                {
                case 'T' : {
                  return "<fmt:message>igate.instance.type.trx</fmt:message>" ;
                }
                case 'A' : {
                  return "<fmt:message>igate.instance.type.adm</fmt:message>" ;
                }
                case 'L' : {
                  return "<fmt:message>igate.instance.type.log</fmt:message>" ;
                }
                case 'M' : {
                  return "<fmt:message>igate.instance.type.mnt</fmt:message>" ;
                }
                }
              }
            }, {
              name : "instanceAddress",
              header : "<fmt:message>igate.instance.address</fmt:message>",
              align : "left",
              width: '30%',
            }, {
              name : "instanceNode",
              header : "<fmt:message>igate.instance.node</fmt:message>",
              align : "left",
              width: '30%',
            }],
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
          
          this.newTabSearchGrid();
        }
      }) ;
    }) ;
  }) ;

  //Flag에 의해 최초 프로퍼티 개수 Count
  function onCheckPropertyCount()
  {
    if (firstTemplateMode)
    {
      firstTemplateMode = false ;
      propertyCount = window.vmInstanceProperties.instanceProperties.length ;
      return true ;
    }
    return false ;
  } ;

  function getPropertyList(jsonLoad)
  {
    jsonLoad.forEach(function(value, idx)
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
            window.vmMain.object.instanceProperties = result.object ; //필수 값인 항목들 표시 용도

          //onClickPlus 에서 호출된 경우,
          else
          {
            var propertyKey = [] ;
            for (key in result.object)
              propertyKey[key] = result.object[key].pk.propertyKey ;

            window.vmInstanceProperties.propertyKeys = propertyKey ; //프로퍼티 키 필드에 보이는 리스트 용도
          }
        },
        error : function(request, status, error)
        {
          ResultImngObj.errorHandler(request, status, error) ;
        }
      }) ;
    }) ;
  } ;

  //프로퍼티 키 필드의 값 변경 시, onchange 이벤트
  function searchPropertyKey(index)
  {
    onCheckPropertyCount() ;

    var paramPropertyKey = window.vmInstanceProperties.instanceProperties[index] ; // Property Key
    var propertyValue = "" ;
    var propertyDesc = "" ;

    // #으로 시작하는 경우, 설명 : 갱신
    if (paramPropertyKey.pk.propertyKey.startsWith("#"))
      window.vmInstanceProperties.instanceProperties[index].propertyDesc = propertyDesc ;

    // #으로 시작하는 옵션이 아닌경우, 기본값 & 설명 : 갱신 가능
    else
    {
      $.ajax({
        type : "GET",
        url : "<c:url value='/common/property/properties.json' />",
        data : {
          "propertyId" : "Property.Instance",
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
              window.vmInstanceProperties.instanceProperties[index].propertyValue = propertyValue ;

            window.vmInstanceProperties.instanceProperties[index].propertyDesc = propertyDesc ;
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
    var checkPropertyArray = window.vmInstanceProperties.instanceProperties.map(function(element)
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
      warnAlert({message : '<fmt:message key="igate.instance.alert.overlap"><fmt:param value="' + overlapElement + '" /></fmt:message>'}) ;
      return false ;
    }
    return true ;
  }
</script>