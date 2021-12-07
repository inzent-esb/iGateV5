<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('fieldMeta') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.fieldName",
      'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.name</fmt:message>",
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
          'mappingDataInfo' : 'object.pk.metaDomain',
          'name' : "<fmt:message>igate.fieldMeta.metaDomain</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.pk.fieldId',
          'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        },{
            'type' : "text",
            'mappingDataInfo' : 'object.fieldLength',
            'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.length</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : 'object.fieldName',
          'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.name</fmt:message>",
          isRequired: true
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.fieldType',
            'optionFor' : 'option in fieldTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.type</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : 'object.fieldDesc',
          'name' : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.description</fmt:message>",
          'height' : 100
        }, ]
      }, ]
    }, ]) ;

    createPageObj.setPanelButtonList({
      removeBtn : hasRecordEditor,
      goModBtn : hasRecordEditor,
      saveBtn : hasRecordEditor,
      updateBtn : hasRecordEditor,
      goAddBtn : hasRecordEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/fieldMeta/object.json'/>"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/fieldMeta/control.json'/>"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {}
      },
      methods : {
        search : function()
        {
          vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
          vmList.makeGridObj.search(this, function() {
              $.ajax({
                  type : "GET",
                  url : "<c:url value='/igate/fieldMeta/rowCount.json' />",
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
	        this.object.fieldName = null ;			  
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
        newTabPageUrl: "<c:url value='/igate/fieldMeta.html' />",
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
          searchUri : "<c:url value='/igate/fieldMeta/search.json'/>",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          columns : [{
            name : "pk.metaDomain",
            header : "<fmt:message>igate.fieldMeta.metaDomain</fmt:message>",
            align : "left",
            width: "20%"
          }, {
            name : "pk.fieldId",
            header : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "20%"
          }, {
            name : "fieldName",
            header : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "20%"
          }, {
            name : "fieldType",
            header : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.type</fmt:message>",
            align : "center",
            width: "10%",
            formatter : function(value)
            {
              switch (value.row.fieldType)
              {
              case 'B' : {
                return "<fmt:message>igate.fieldMeta.fieldType.byte</fmt:message>" ;
              }
              case 'S' : {
                return "<fmt:message>igate.fieldMeta.fieldType.short</fmt:message>" ;
              }
              case 'I' : {
                return "<fmt:message>igate.fieldMeta.fieldType.int</fmt:message>" ;
              }
              case 'L' : {
                return "<fmt:message>igate.fieldMeta.fieldType.long</fmt:message>" ;
              }
              case 'F' : {
                return "<fmt:message>igate.fieldMeta.fieldType.float</fmt:message>" ;
              }
              case 'D' : {
                return "<fmt:message>igate.fieldMeta.fieldType.double</fmt:message>" ;
              }
              case 'N' : {
                return "<fmt:message>igate.fieldMeta.fieldType.numeric</fmt:message>" ;
              }
              case 'p' : {
                return "<fmt:message>igate.fieldMeta.fieldType.timeStamp</fmt:message>" ;
              }
              case 'b' : {
                return "<fmt:message>igate.fieldMeta.fieldType.boolean</fmt:message>" ;
              }
              case 'v' : {
                return "<fmt:message>igate.fieldMeta.fieldType.individual</fmt:message>" ;
              }
              case 'A' : {
                return "<fmt:message>igate.fieldMeta.fieldType.raw</fmt:message>" ;
              }
              case 'P' : {
                return "<fmt:message>igate.fieldMeta.fieldType.packedDecimal</fmt:message>" ;
              }
              case 'R' : {
                return "<fmt:message>igate.fieldMeta.fieldType.record</fmt:message>" ;
              }
              case 'T' : {
                return "<fmt:message>igate.fieldMeta.fieldType.string</fmt:message>" ;
              }
              }
            }
          }, {
            name : "fieldDesc",
            header : "<fmt:message>igate.fieldMeta</fmt:message> <fmt:message>head.description</fmt:message>",
            align : "left",
            width: "30%"
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
          pk : {}
        },
        fieldTypes : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            'pk.fieldId' : this.object.pk.fieldId,
            'pk.metaDomain' : this.object.pk.metaDomain
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.FieldMeta.FieldType', true, function(properties)
        {
          this.fieldTypes = properties ;
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
            this.object.fieldName = null ;
            this.object.fieldType = null ;
            this.object.fieldDesc = null ;
            this.object.fieldLength = null;
            this.object.pk.metaDomain = null ;
            this.object.pk.fieldId = null ;
          }
        }
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>