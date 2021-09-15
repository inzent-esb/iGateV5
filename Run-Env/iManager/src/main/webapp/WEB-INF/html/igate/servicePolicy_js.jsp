<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('servicePolicy') ;
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
        'type' : "modal",
        'mappingDataInfo' : {
    	  'url' : '/igate/activity.html',
          'modalTitle' : '<fmt:message>igate.activity</fmt:message>',
          'vModel' : "object.activityId",
          'callBackFuncName' : 'setSearchActivityId'
        },
        'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
        'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasServicePolicyEditor,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/adapter.html',
            'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
            'vModel' : "object.pk.adapterId",
            'callBackFuncName' : 'setSearchAdapterId'
          },
          'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.pk.serviceType',
            'optionFor' : 'option in serviceTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.type</fmt:message>",
          isPk : true
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/activity.html',
            'modalTitle' : '<fmt:message>igate.activity</fmt:message>',
            'vModel' : "object.activityId",
            'callBackFuncName' : 'setSearchActivityId'
          },
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, ]
    }]) ;

    createPageObj.setPanelButtonList({
      dumpBtn : hasServicePolicyEditor,
      removeBtn : hasServicePolicyEditor,
      goModBtn : hasServicePolicyEditor,
      saveBtn : hasServicePolicyEditor,
      updateBtn : hasServicePolicyEditor,
      goAddBtn : hasServicePolicyEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/servicePolicy/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/servicePolicy/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          pk : {
            adapterId : null
          },
          activityId : null
        },
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
            this.object.pk.adapterId = null ;     
            this.object.activityId = null ;
          }	  

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam)
        {
        	if ('/igate/activity.html' == openModalParam.url)
            {
              openModalParam.modalParam = {
                activityType : 'S'
              } ;
            }
        	
              
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.pk.adapterId = param.adapterId ;
        },
        setSearchActivityId : function(param)
        {
          this.object.activityId = param.activityId ;
        }
      },
      mounted : function()
      {
        this.initSearchArea() ;
      }
    }) ;

    var vmList = new Vue({
      el : '#' + createPageObj.getElementId('ImngListObject'),
      data : {
        makeGridObj : null,
        newTabPageUrl: "<c:url value='/igate/servicePolicy.html' />"
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
          searchUri : "<c:url value='/igate/servicePolicy/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "pk.adapterId",
            header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "40%",
          }, {
            name : "pk.serviceType",
            header : "<fmt:message>head.type</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "center",
            width: "20%",
            formatter : function(value)
            {
              if (value.row['pk.serviceType'] == "DB")
                return "<fmt:message>head.db</fmt:message>" ;
              else if (value.row['pk.serviceType'] == "File")
                return "<fmt:message>head.file</fmt:message>" ;
              else if (value.row['pk.serviceType'] == "Online")
                return "<fmt:message>head.online</fmt:message>" ;
            }
          }, {
            name : "activityId",
            header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "40%",
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
          activityId : null,
          pk : {
            adapterId : null,
            serviceType : null
          }
        },
        serviceTypes : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.adapterId' : this.object.pk.adapterId,
            'pk.serviceType' : this.object.pk.serviceType
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Service.ServiceType', true, function(properties)
        {
          this.serviceTypes = properties ;
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
            this.object.activityId = null ;
            this.object.pk.adapterId = null ;
            this.object.pk.serviceType = null ;
          }
        },
        openModal : function(openModalParam)
        {

          if ('/igate/activity.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              activityType : 'S'
            } ;
          }

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchAdapterId : function(param)
        {
          this.object.pk.adapterId = param.adapterId ;
        },
        setSearchActivityId : function(param)
        {
          this.object.activityId = param.activityId ;
        }
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>