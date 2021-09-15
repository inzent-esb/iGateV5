<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('onlineHeaderMappingPolicy') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.pk.interfaceAdapterId",
        'callBackFuncName' : 'setSearchInterfaceAdapterId'
      },
      'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.pk.serviceAdapterId",
        'callBackFuncName' : 'setSearchServiceAdapterId'
      },
      'name' : "<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, ]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasOnlineHeaderMappingPolicyEditor,
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
            'vModel' : "object.pk.interfaceAdapterId",
            'callBackFuncName' : 'setSearchInterfaceAdapterId'
          },
          'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/mapping.html',
            'modalTitle' : '<fmt:message>igate.mapping</fmt:message>',
            'vModel' : "object.requestMappingId",
            'callBackFuncName' : 'setSearchRequestMappingId'
          },
          'name' : "<fmt:message>igate.onlineHeaderMappingPolicy.requestMappingId</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/mapping.html',
            'modalTitle' : '<fmt:message>igate.mapping</fmt:message>',
            'vModel' : "object.responseMappingId",
            'callBackFuncName' : 'setSearchResponseMappingId'
          },
          'name' : "<fmt:message>igate.onlineHeaderMappingPolicy.responseMappingId</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/adapter.html',
            'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
            'vModel' : "object.pk.serviceAdapterId",
            'callBackFuncName' : 'setSearchServiceAdapterId'
          },
          'name' : "<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/mapping.html',
            'modalTitle' : '<fmt:message>igate.mapping</fmt:message>',
            'vModel' : "object.replyMappingId",
            'callBackFuncName' : 'setSearchReplyMappingId'
          },
          'name' : "<fmt:message>igate.onlineHeaderMappingPolicy.replyMappingId</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/mapping.html',
            'modalTitle' : '<fmt:message>igate.mapping</fmt:message>',
            'vModel' : "object.createMappingId",
            'callBackFuncName' : 'setSearchCreateMappingId'
          },
          'name' : "<fmt:message>igate.onlineHeaderMappingPolicy.createMappingId</fmt:message>"
        }, ]
      }, ]
    }]) ;

    createPageObj.setPanelButtonList({
      dumpBtn : hasOnlineHeaderMappingPolicyEditor,
      removeBtn : hasOnlineHeaderMappingPolicyEditor,
      goModBtn : hasOnlineHeaderMappingPolicyEditor,
      saveBtn : hasOnlineHeaderMappingPolicyEditor,
      updateBtn : hasOnlineHeaderMappingPolicyEditor,
      goAddBtn : hasOnlineHeaderMappingPolicyEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/onlineHeaderMappingPolicy/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/onlineHeaderMappingPolicy/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          pk : {
            serviceAdapterId : null,
            interfaceAdapterId : null
          }
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
            this.object.pk.interfaceAdapterId = null ;
            this.object.pk.serviceAdapterId = null ;        	  
          }  

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchServiceAdapterId : function(param)
        {
          this.object.pk.serviceAdapterId = param.adapterId ;
        },
        setSearchInterfaceAdapterId : function(param)
        {
          this.object.pk.interfaceAdapterId = param.adapterId ;
        },
      },
      mounted : function()
      {
        this.initSearchArea();
      }
    }) ;

    var vmList = new Vue({
      el : '#' + createPageObj.getElementId('ImngListObject'),
      data : {
        makeGridObj : null,
        newTabPageUrl: "<c:url value='/igate/onlineHeaderMappingPolicy.html' />"
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
          searchUri : "<c:url value='/igate/onlineHeaderMappingPolicy/search.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "pk.interfaceAdapterId",
            header : "<fmt:message>igate.interface</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "25%",
          }, {
            name : "pk.serviceAdapterId",
            header : "<fmt:message>igate.service</fmt:message> <fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "25%",
          }, {
            name : "requestMappingId",
            header : "<fmt:message>igate.onlineHeaderMappingPolicy.requestMappingId</fmt:message>",
            align : "left",
            width: "25%",
          }, {
            name : "responseMappingId",
            header : "<fmt:message>igate.onlineHeaderMappingPolicy.responseMappingId</fmt:message>",
            align : "left",
            width: "25%",
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
          createMappingId : null,
          replyMappingId : null,
          responseMappingId : null,
          requestMappingId : null,
          pk : {
            serviceAdapterId : null,
            interfaceAdapterId : null
          }
        },
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.interfaceAdapterId' : this.object.pk.interfaceAdapterId,
            'pk.serviceAdapterId' : this.object.pk.serviceAdapterId
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
            this.object.requestMappingId = null ;
            this.object.responseMappingId = null ;
            this.object.replyMappingId = null ;
            this.object.createMappingId = null ;
            this.object.pk.interfaceAdapterId = null ;
            this.object.pk.serviceAdapterId = null ;
          }
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchInterfaceAdapterId : function(param)
        {
          this.object.pk.interfaceAdapterId = param.adapterId ;
          this.$forceUpdate() ;
        },
        setSearchServiceAdapterId : function(param)
        {
          this.object.pk.serviceAdapterId = param.adapterId ;
          this.$forceUpdate() ;
        },
        setSearchRequestMappingId : function(param)
        {
          this.object.requestMappingId = param.mappingId ;
          this.$forceUpdate() ;
        },
        setSearchResponseMappingId : function(param)
        {
          this.object.responseMappingId = param.mappingId ;
          this.$forceUpdate() ;
        },
        setSearchReplyMappingId : function(param)
        {
          this.object.replyMappingId = param.mappingId ;
          this.$forceUpdate() ;
        },
        setSearchCreateMappingId : function(param)
        {
          this.object.createMappingId = param.mappingId ;
          this.$forceUpdate() ;
        },
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>