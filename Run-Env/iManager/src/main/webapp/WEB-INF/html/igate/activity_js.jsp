<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  function getParam(sname)
  {
    var params = location.search.substr(location.search.indexOf("?") + 1) ;
    var sval = "" ;
    params = params.split("&") ;
    for (var i = 0 ; i < params.length ; i++)
    {
      temp = params[i].split("=") ;
      if ([temp[0]] == sname)
      {
        sval = temp[1] ;
      }
    }
    return sval ;
  }

  $(document).ready(function()
  {

    var paramActivityId = getParam("activityId") ;
    var isTools = $('#_client_mode').val() === 'c' ? true : false ;
    var isBtn = hasActivityEditor ;
    if (isTools)
      isBtn = false ;

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('activity') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.activityId",
      'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.activityType",
        'optionFor' : 'option in activityTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'activityTypes'
      },
      'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.type</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.activityDesc",
      'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      searchInitBtn : true,
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      addBtn : hasActivityEditor,
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
          'mappingDataInfo' : "object.activityId",
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.activityName",
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.name</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.activityType',
            'optionFor' : 'option in activityTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue',
            'optionDisabled': 'option.pk.propertyKey == "F" && panelMode != "detail"',
          },
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.type</fmt:message>",
          isRequired: true
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : "object.activityGroup",
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.group</fmt:message>",
          isRequired: true
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/common/privilege.html',
            'modalTitle' : '<fmt:message>common.privilege</fmt:message>',
            'vModel' : "object.executePrivilegeId",
            'callBackFuncName' : 'setSearchPrivilegeId'
          },
          'name' : "<fmt:message>common.privilege</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.activityClassName",
          'name' : "<fmt:message>igate.activity.className</fmt:message>",
          isRequired: true
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/javaProject.html',
            'modalTitle' : '<fmt:message>igate.javaProject</fmt:message>',
            'vModel' : "object.activityProject",
            'callBackFuncName' : 'setSearchProjectId'
          },
          'name' : "<fmt:message>igate.activity.project</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.activityLogLevel',
            'optionFor' : 'option in logLevels',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.log.level</fmt:message>",
          isRequired: true
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.activityDesc",
          'name' : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.description</fmt:message>",
          'height' : 100
        }, ]
      }, ]
    }, {
      'type' : 'custom',
      'id' : 'ActivityParameters',
      'name' : 'Parameter',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<div class="form-table form-table-responsive">' ;
        detailHtml += '    <div class="form-table-wrap">' ;
        detailHtml += '        <div class="form-table-head">' ;
        detailHtml += '            <button type="button" class="btn-icon saveGroup updateGroup" v-on:click="addActivityParameter();"><i class="icon-plus-circle"></i></button>' ;
        detailHtml += '			   <label class="col"><fmt:message>head.type</fmt:message></label>' ;
        detailHtml += '			   <label class="col"><fmt:message>head.description</fmt:message></label>' ;
        detailHtml += '        </div>' ;
        detailHtml += '        <div class="form-table-body" v-for="(elm, index) in activityParameters">' ;
        detailHtml += '        		<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="removeActivityParameter(index);"><i class="icon-minus-circle"></i></button>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" list="parameterTypes" v-model="elm.parameterType">' ;
        detailHtml += '        			<datalist id="parameterTypes">' ;
        detailHtml += '        				<option v-for="parameterType in parameterTypes">{{parameterType}}</option>' ;
        detailHtml += '        			</datalist>' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        		<div class="col">' ;
        detailHtml += '        			<input type="text" class="form-control view-disabled" v-model="elm.parameterDesc">' ;
        detailHtml += '        		</div>' ;
        detailHtml += '        </div>' ;
        detailHtml += '    </div>' ;
        detailHtml += '</div>' ;

        return detailHtml ;
      }
    }]) ;

    createPageObj.setPanelButtonList({
      loadBtn : hasActivityEditor,
      dumpBtn : hasActivityEditor,
      removeBtn : isBtn,
      goModBtn : hasActivityEditor,
      saveBtn : hasActivityEditor,
      updateBtn : hasActivityEditor,
      goAddBtn : hasActivityEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/activity/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/activity/control.json' />"
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          executePrivilegeId : null,
          activityProject : null,
          activityParameters : []
        },
        activityTypes : [],
        logLevels : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            activityId : this.object.activityId
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Activity.ActivityType', true, function(properties)
        {
          this.activityTypes = properties;
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.LogLevel', false, function(properties)
        {
          this.logLevels = properties ;
        }.bind(this)) ;
      },
      methods : {
        goDetailPanel : function()
        {
          panelOpen('detail', null, function()
          {
            this.setPanelBtn() ;
          }.bind(this)) ;
        },
        setPanelBtn : function()
        {
          if (this.object.loadable)
            $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').show() ;
          else
            $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').hide() ;
          
          if (vmMain.object.activityType == 'A')
          {
            $("#panel").find('.panel-content').find('#item-result-parent').show() ;
            $("#panel").find('.panel-footer').find('.ml-auto').show() ;
          }
          else if (vmMain.object.activityType == 'F')
          {
            $("#panel").find('.panel-content').find('#item-result-parent').hide() ;
            $("#panel").find('.panel-footer').find('.ml-auto').hide() ;
          }
          else
          {
            $("#panel").find('.panel-content').find('#item-result-parent').show() ;
            $("#panel").find('.panel-footer').find('.ml-auto').show() ;
          }
        },
        initDetailArea : function(object)
        {
          
          $("#panel").find('.panel-footer').find('.ml-auto').show() ;
        	
          if (object)
          {
            this.object = object ;
            if (isTools)
              $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').hide() ;
          }
          else
          {
            this.object.activityId = null ;
            this.object.activityName = null ;
            this.object.activityType = null ;
            this.object.activityGroup = null ;
            this.object.executePrivilegeId = null ;
            this.object.activityClassName = null ;
            this.object.activityProject = null ;
            this.object.activityLogLevel = null ;
            this.object.activityDesc = null ;

            window.vmActivityParameters.activityParameters = [] ;
          }
        },
        openModal : function(openModalParam)
        {

          if ('/common/privilege.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              privilegeType : 'b'
            } ;
          }

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchPrivilegeId : function(param)
        {
          this.object.executePrivilegeId = param.privilegeId ;
          this.$forceUpdate() ;
        },
        setSearchProjectId : function(param)
        {
          this.object.activityProject = param.projectId ;
          this.$forceUpdate() ;
        }
      }
    }) ;

    window.vmActivityParameters = new Vue({
      el : '#ActivityParameters',
      data : {
        viewMode : 'Open',
        activityParameters : [],
        parameterTypes : [],
        uri : "<c:url value='/igate/activity/parameterTypes.json' />"
      },
      methods : {
        addActivityParameter : function()
        {
          this.activityParameters.push({
            pk : {}
          }) ;
        },
        removeActivityParameter : function(index)
        {
          this.activityParameters = this.activityParameters.slice(0, index).concat(this.activityParameters.slice(index + 1)) ;
        },
        validationCheck: function() {
	   		
			var isValidation = true;
			
			for(var i = 0; i < this.activityParameters.length; i++) {
				
				var info = this.activityParameters[i];
				
				if(!info || !info.pk || !info.parameterType) {
					warnAlert({message : '<fmt:message>igate.activity.valNullCheck</fmt:message>'}) ;
					isValidation = false;
					break;
				}
			}
	   		
	   		return isValidation;
	   	}
      },
      mounted : function()
      {
        $.getJSON(this.uri, function(data)
        {
          this.parameterTypes = data.object ;
        }.bind(this)) ;
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption, {
        loadInfo : function()
        {
          ControlImngObj.load() ;
        },
        updateInfo : function() {
       	  if(!window.vmActivityParameters.validationCheck()) return;	
        	
          panelMethodOption.updateInfo() ;
          vmMain.setPanelBtn() ;
        },
        saveInfo: function() {		   		
          if(!window.vmActivityParameters.validationCheck()) return;

  		  panelMethodOption.saveInfo() ;
	   	},
        goAddInfo : function()
        {
          $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').hide() ;
          panelOpen('add', window.vmMain.object) ;
        },
        goModifyPanel : function()
        {
          $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').hide() ;
          panelOpen('mod') ;
        },
      })
    }) ;

    PropertyImngObj.getProperties('List.Activity.ActivityType', true, function(activityTypes)
    {

      window.vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            activityId : null,
            activityType : " ",
            activityDesc : null,
          },
          activityTypes : [],
          isfirst : true
        },
        methods : {
          search : function()
          {
            if ('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display'))
            {
              $('#' + createPageObj.getElementId('ImngListObject')).show() ;
              $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide() ;
            }

            vmList.makeGridObj.search(this, function(result)
            {
              if (paramActivityId && window.vmSearch.isfirst && result.object)
              {
                for (var i = 0 ; i < result.object.page.length ; i++)
                {
                  var activityObject = result.object.page[i] ;
                  if (paramActivityId === activityObject.activityId)
                  {
                    vmList.goDetail(activityObject) ;
                    break ;
                  }
                }
                window.vmSearch.isfirst = false ;
              }
            }) ;
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
              this.object.activityId = null ;
              this.object.activityType = " " ;
              this.object.activityDesc = null ;        		
        	}

        	initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#activityTypes'), this.object.activityType) ;
          }

        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.activityTypes = activityTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          newTabPageUrl: "<c:url value='/igate/activity.html' />"
        },
        methods : $.extend(true, {}, listMethodOption, {
          initSearchArea : function()
          {
            window.vmSearch.initSearchArea() ;
          },
          goDetail : function(data)
          {
            SearchImngObj.load($.param(data)) ;
            if ('panel panel-bottom expand' !== $("#panel").attr('class'))
              $("#panel").find("[data-target='#panel']").trigger('click') ;
            $('#panel-header').hide() ;
          },
          goSavePanel : function()
          {
            $("#panel").find('.panel-footer').find('.ml-auto').find('#loadBtn').hide() ;
            panelOpen('add') ;
          }
        }),
        mounted : function()
        {

          this.makeGridObj = getMakeGridObj() ;

          this.makeGridObj.setConfig({
            elementId : createPageObj.getElementId('ImngSearchGrid'),
            onClick : SearchImngObj.clicked,
            searchUri : "<c:url value='/igate/activity/search.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "activityId",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.id</fmt:message>",
              align : "left",
              width: "25%"
            }, {
              name : "activityName",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.name</fmt:message>",
              align : "left",
              width: "25%"
            }, {
              name : "activityType",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.type</fmt:message>",
              align : "center",
              width: "15%",
              formatter : function(value)
              {
                if (value.row.activityType == "F")
                  return "<fmt:message>igate.activity.type.control</fmt:message>" ;
                else if (value.row.activityType == "A")
                  return "<fmt:message>igate.activity.type.activity</fmt:message>" ;
                else if (value.row.activityType == "S")
                  return "<fmt:message>igate.activity.type.service</fmt:message>" ;
                else if (value.row.activityType == "C")
                  return "<fmt:message>igate.activity.type.codec</fmt:message>" ;
                else if (value.row.activityType == "T")
                  return "<fmt:message>igate.activity.type.transform</fmt:message>" ;
                else if (value.row.activityType == "I")
                  return "<fmt:message>igate.activity.type.internal</fmt:message>" ;
                else if (value.row.activityType == "H")
                    return "<fmt:message>igate.activity.type.telegram.handler</fmt:message>" ;                  
              }
            }, {
              name : "activityDesc",
              header : "<fmt:message>igate.activity</fmt:message> <fmt:message>head.description</fmt:message>",
              align : "left",
              width: "35%"
            }]
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
          
          this.newTabSearchGrid();
        }
      }) ;

      if (isTools)
      {
        if (paramActivityId)
        {
          window.vmSearch.object.activityId = paramActivityId ;
          window.vmSearch.search() ;
        }
        else
        {
          vmList.goSavePanel() ;
          $("#panel").find("[data-target='#panel']").trigger('click') ;
          $('#panel-header').hide() ;
        }
      }

    }) ;
  }) ;
</script>