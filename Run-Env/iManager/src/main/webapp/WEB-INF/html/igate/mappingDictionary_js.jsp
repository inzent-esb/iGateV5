<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('mappingDictionary') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.dictionaryName",
      'name' : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    },{
      'type' : "text",
      'mappingDataInfo' : "object.dictionaryDesc",
      'name' : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      totalCount: true,
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      addBtn : hasRecordEditor,
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
          'mappingDataInfo' : 'object.dictionaryName',
          'name' : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.name</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.dictionaryDesc',
          'name' : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.description</fmt:message>",
          isPk : false
        }]
      }]
    },
    {
      'type' : 'property',
      'id' : 'MappingDictionaryDetails',
      'name' : '<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.detail</fmt:message>',
      'addRowFunc' : 'detailAdd',
      'removeRowFunc' : 'detailRemove(index)',
      'mappingDataInfo' : 'mappingDictionaryDetails',
      'detailList' : [{
        'type' : 'text',
        'mappingDataInfo' : 'elm.pk.targetFieldPath',
        'name' : '<fmt:message>igate.mappingDictionary.targetFieldPath</fmt:message>'
      },{
        'type' : 'text',
        'mappingDataInfo' : 'elm.mappingExpression',
        'name' : '<fmt:message>igate.mappingDictionary.mappingExpression</fmt:message>'
      }]
    }
    ]) ;

    createPageObj.setPanelButtonList({
      removeBtn : hasRecordEditor,
      goModBtn : hasRecordEditor,
      saveBtn : hasRecordEditor,
      updateBtn : hasRecordEditor,
      goAddBtn : hasRecordEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/mappingDictionary/object.json'/>"
    }) ;
    
    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/mappingDictionary/control.json'/>"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          dictionaryDesc : null,
          mappingDictionaryDetails : [],
        },
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            dictionaryName : this.object.dictionaryName,
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
            this.object.dictionaryDesc = null;
            
            window.vmMappingDictionaryDetails.mappingDictionaryDetails = [];
          }
        }
      },
    }) ;
    
    window.vmMappingDictionaryDetails = new Vue({
      el : '#MappingDictionaryDetails',
      data : {
        object : {},
        viewMode : 'Open',
        mappingRuleDetails : [],
        mappingDictionaryDetails : [],
      },
      methods : {
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        detailAdd : function()
        {
          this.openModal({
            'url' : '/igate/mapping.html',
            'modalTitle' : '<fmt:message>igate.mapping</fmt:message>',
            "callBackFuncName" : "setDetailList"
          }) ;
        },
        detailRemove : function(index)
        {
          this.mappingDictionaryDetails = this.mappingDictionaryDetails.slice(0, index).concat(this.mappingDictionaryDetails.slice(index + 1)) ;
        },
        setDetailList : function(param)
        {
          var paramData = $.param(param);
          $.ajax({
            type : "GET",
            url : "/iManager/igate/mapping/object.json",
            processData : false,
            data : paramData,
            dataType : "json",
            success : function(result)
            {
              window.vmMappingDictionaryDetails.mappingRuleDetails = result.object.mappingDetails[0].mappingRuleObject.mappingRuleDetails ;
             console.log(window.vmMappingDictionaryDetails.mappingRuleDetails);
              
  		  	for(var j=0 ; j<window.vmMappingDictionaryDetails.mappingRuleDetails.length; j++)
  		    {
  		  	 var isExistAdapterId = false ;
  		  	 
  	          for (var i = 0 ; i < window.vmMappingDictionaryDetails.mappingDictionaryDetails.length ; i++)
  	          {
  	            if (window.vmMappingDictionaryDetails.mappingDictionaryDetails[i].pk.targetFieldPath == window.vmMappingDictionaryDetails.mappingRuleDetails[j].targetFieldPath)
  	            {
  	              isExistAdapterId = true ;
  	              break ;
  	            }
  	          }
  	          
  	          if (isExistAdapterId)
  	            return ;

  	        window.vmMappingDictionaryDetails.mappingDictionaryDetails.push({
  	            pk : {
  	              targetFieldPath : window.vmMappingDictionaryDetails.mappingRuleDetails[j].targetFieldPath
  	            },
  				mappingExpression : window.vmMappingDictionaryDetails.mappingRuleDetails[j].mappingExpression	            
  	          }) ;
  	          
  		    }
            },
            error : function(request, status, error)
            {
              ResultImngObj.errorHandler(request, status, error) ;
            }
          }
          );
          
        },
      }
    }) ;
    

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
    
    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          dictionaryName : null,
          dictionaryDesc : null,
        }
      },
      methods : {
        search : function()
        {
          vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
          vmList.makeGridObj.search(this, function() {
              $.ajax({
                  type : "GET",
                  url : "<c:url value='/igate/mappingDictionary/rowCount.json' />",
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
	        this.object.dictionaryName = null ;
	        this.object.dictionaryDesc = null ;
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
        newTabPageUrl: "<c:url value='/igate/mappingDictionary.html' />",
        totalCount: '0',
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
          searchUri : "<c:url value='/igate/mappingDictionary/search.json'/>",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "dictionaryName",
            header : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "20%"
          }, {
            name : "dictionaryDesc",
            header : "<fmt:message>igate.mappingDictionary</fmt:message> <fmt:message>head.description</fmt:message>",
            align : "left",
            width: "20%"
          }]
        }) ;

        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
        
        this.newTabSearchGrid();
      }
    }) ;
  }) ;
</script>