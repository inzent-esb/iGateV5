<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('privilege') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.privilegeId",
      'name' : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.privilegeDesc",
      'name' : "<fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.privilegeType",
        'optionFor' : 'option in privilegeTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'privilegeTypes'
      },
      'name' : "<fmt:message>common.privilege.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      totalCount: true,
      addBtn : hasPrivilegeEditor,
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
          'mappingDataInfo' : "object.privilegeId",
          'name' : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.privilegeType',
            'optionFor' : 'option in privilegeTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>common.privilege.type</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.privilegeDesc",
          'name' : "<fmt:message>head.description</fmt:message>",
          height : 80
        }, ]
      }, ]
    }]) ;

    createPageObj.setPanelButtonList({
      removeBtn : hasPrivilegeEditor,
      goModBtn : hasPrivilegeEditor,
      saveBtn : hasPrivilegeEditor,
      updateBtn : hasPrivilegeEditor,
      goAddBtn : hasPrivilegeEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/common/privilege/object.json' />"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {},
        privilegeTypes : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            privilegeId : this.object.privilegeId
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Privilege.Type', true, function(properties)
        {
          this.privilegeTypes = properties ;
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
            this.object.privilegeType = null ;
            this.object.privilegeDesc = null ;
            this.object.privilegeId = null ;
          }
        }
      },
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;

    PropertyImngObj.getProperties('List.Privilege.Type', true, function(privilegeTypes)
    {

      window.vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            privilegeId : "",
            privilegeDesc : "",
            privilegeType : " "
          },
          privilegeTypes : []
        },
        methods : {
          search : function()
          {
        	vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
        	vmList.makeGridObj.search(this, function() {
                $.ajax({
                    type : "GET",
                    url : "<c:url value='/common/privilege/rowCount.json' />",
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
              this.object.privilegeId = null ;
              this.object.privilegeDesc = null ;
              this.object.privilegeType = ' ' ;        		
        	}

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#privilegeTypes'), this.object.privilegeType) ;
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.privilegeTypes = privilegeTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          totalCount: '0',
          newTabPageUrl: "<c:url value='/common/privilege.html' />"
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
            searchUri : "<c:url value='/common/privilege/search.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            rowHeaders : (parent.window.location.href.indexOf("role") != -1) ? ['rowNum', 'checkbox'] : [],
            columns : [{
              name : "privilegeId",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left",
              width: "35%",
            }, {
              name : "privilegeType",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "center",
              width: "30%",
              formatter : function(value)
              {
                if (value.row.privilegeType == "S")
                  return "<fmt:message>common.privilege.type.system</fmt:message>" ;
                else if (value.row.privilegeType == "b")
                  return "<fmt:message>common.privilege.type.business</fmt:message>" ;
              }
            }, {
              name : "privilegeDesc",
              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.description</fmt:message>",
              align : "left",
              width: "35%",
            }]
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
          
          this.newTabSearchGrid();
        }
      }) ;
    }) ;

    window.vmInsertButton = new Vue({
      el : '#PopupInsertButton',
      data : {},
      methods : {
        isRole : function()
        {
          if (parent.window.location.href.indexOf("role") != -1)
          {
            return true ;
          }
          else
          {
            return false ;
          }
        }
      }
    }) ;

    var searchType = "${param.searchType}" ;

    function isEmtpy(value)
    {
      if (!value || value.length == 0)
        return true ;
      return false ;
    }

    var searchTypeOpen = isEmtpy("${param.searchType}") ;

    if (isEmtpy("${param.searchType}"))
    {
      this.searchTypeOpen = true ;
    }
    else
    {
      this.searchTypeOpen = false ;
      window.vmSearch.object.privilegeType = "${param.searchType}" ;
    }
  }) ;
</script>