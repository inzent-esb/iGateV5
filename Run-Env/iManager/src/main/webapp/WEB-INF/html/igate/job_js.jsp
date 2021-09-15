<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('job') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.jobId",
      'name' : "<fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.jobDesc",
      'name' : "<fmt:message>head.description</fmt:message>",
      'placeholder' : "<fmt:message>head.searchComment</fmt:message>"
    }, {
      'type' : "select",
      'mappingDataInfo' : {
        'selectModel' : "object.jobType",
        'optionFor' : 'option in jobTypes',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'jobTypes'
      },
      'name' : "<fmt:message>igate.job.jobType</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      searchInitBtn : true,
      addBtn : hasJobEditor,
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
          'mappingDataInfo' : "object.jobId",
          'name' : "<fmt:message>head.id</fmt:message>",
          isPk : true
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.jobName",
          'name' : "<fmt:message>igate.reservedSchedule.job</fmt:message> <fmt:message>head.name</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.jobType',
            'optionFor' : 'option in jobTypes',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.reservedSchedule.job</fmt:message> <fmt:message>head.type</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/calendar.html',
            'modalTitle' : '<fmt:message>igate.calendar</fmt:message>',
            'vModel' : "object.calendarId",
            'callBackFuncName' : 'setSearchCalendarId'
          },
          'name' : "<fmt:message>igate.job.calendarId</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : "object.cronExpression",
          'name' : "<fmt:message>igate.job.cronExpression</fmt:message>"
        }, {
          'type' : "search",
          'mappingDataInfo' : {
            'url' : '/igate/operation.html',
            'modalTitle' : '<fmt:message>igate.operation</fmt:message>',
            'vModel' : "object.operationId",
            'callBackFuncName' : 'setSearchOperationId'
          },
          'name' : "<fmt:message>igate.operation</fmt:message> <fmt:message>head.id</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-4',
        'detailSubList' : [{
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.jobLogLevel',
            'optionFor' : 'option in jobLogLevels',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>head.log.level</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.concurrentExecuteYn',
            'optionFor' : 'option in concurrentExecuteYns',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.job.concurrentExecuteYn</fmt:message>"
        }, {
          'type' : "select",
          'mappingDataInfo' : {
            'selectModel' : 'object.logResultYn',
            'optionFor' : 'option in logResultYns',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue'
          },
          'name' : "<fmt:message>igate.job.logResultYn</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-12',
        'detailSubList' : [{
          'type' : "textarea",
          'mappingDataInfo' : "object.jobDesc",
          'name' : "<fmt:message>head.description</fmt:message>",
          height : 60
        }, ]
      }, ]
    }, {
      'type' : 'property',
      'id' : 'JobParameter',
      'name' : '<fmt:message>igate.job.jobParameter</fmt:message>',
      'addRowFunc' : 'parameterAdd',
      'removeRowFunc' : 'parameterRemove(index)',
      'mappingDataInfo' : 'jobParameter',
      'detailList' : [{
        'type' : 'text',
        'mappingDataInfo' : 'elm.parameterValue',
        'name' : '<fmt:message>common.property.value</fmt:message>'
      },{
        'type' : 'text',
        'mappingDataInfo' : 'elm.parameterDesc',
        'name' : '<fmt:message>head.description</fmt:message>'
      }]
    }, {
      'type' : 'custom',
      'id' : 'JobDeploies',
      'name' : '<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>',
      'getDetailArea' : function()
      {

        var detailHtml = '' ;

        detailHtml += '<ul class="list-group" style="width: 100%;">' ;
        detailHtml += '    <li class="list-group-item" v-for="(elm, index) in instanceList" v-if="elm.instanceType==\'T\'">' ;
        detailHtml += '        <label class="custom-control custom-checkbox">' ;
        detailHtml += '            <input type="checkbox" class="custom-control-input view-disabled" v-model="jobSubDeploies[index]" @change="push(elm.instanceId, $event)">' ;
        detailHtml += '            <span class="custom-control-label">{{elm.instanceId}}</span>' ;
        detailHtml += '        </label>' ;
        detailHtml += '    </li>' ;
        detailHtml += '</ul>' ;

        return detailHtml ;
      }
    }]) ;

    createPageObj.setPanelButtonList({
      startBtn : hasJobEditor,
      interruptBtn : hasJobEditor,
      removeBtn : hasJobEditor,
      goModBtn : hasJobEditor,
      saveBtn : hasJobEditor,
      updateBtn : hasJobEditor,
      goAddBtn : hasJobEditor,
    }) ;

    createPageObj.panelConstructor() ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/job/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/job/control.json' />"
    }) ;

    PropertyImngObj.getProperties('List.Job.JobType', true, function(jobTypes)
    {

      window.vmMain.jobTypes = jobTypes ;

      window.vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            jobType : " "
          },
          jobTypes : []
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
              this.object.jobId = null ;
              this.object.jobDesc = null ;
              this.object.jobType = ' ' ;        		
        	}	

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#jobTypes'), this.object.jobType) ;
          }
        },
        mounted : function()
        {
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#jobTypes'), this.object.jobType) ;
        },
        created : function()
        {
          this.jobTypes = jobTypes ;
        }
      }) ;

      var vmList = new Vue({
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data : {
          makeGridObj : null,
          newTabPageUrl: "<c:url value='/igate/job.html' />"
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
            searchUri : "<c:url value='/igate/job/search.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "jobId",
              header : "<fmt:message>head.id</fmt:message>",
              align : "left",
              width: "25%",
            }, {
              name : "jobDesc",
              header : "<fmt:message>head.description</fmt:message>",
              align : "left",
              width: "30%",
            }, {
              name : "jobType",
              header : "<fmt:message>igate.job.jobType</fmt:message>",
              align : "center",
              width: "20%",
              formatter : function(value)
              {
                if (value.row.jobType == "R")
                  return "<fmt:message>igate.job.type.reserve</fmt:message>" ;
                else if (value.row.jobType == "S")
                  return "<fmt:message>igate.job.type.schdule</fmt:message>" ;
                else if (value.row.jobType == "M")
                  return "<fmt:message>igate.job.type.manual</fmt:message>" ;
              }
            }, {
              name : "cronExpression",
              header : "<fmt:message>igate.job.cronExpression</fmt:message>",
              align : "left",
              width: "25%",
            }]
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
          
          this.newTabSearchGrid();
        }
      }) ;
    }) ;

    window.vmMain = new Vue({
      el : '#MainBasic',
      data : {
        viewMode : 'Open',
        object : {
          operationId : null,
          calendarId : null,
          jobParameter : [],
          jobDeploies : []
        },
        jobTypes : [],
        concurrentExecuteYns : [],
        logResultYns : [],
        jobLogLevels : [],
        panelMode : null
      },
      computed : {
        pk : function()
        {
          return {
            jobId : this.object.jobId
          } ;
        }
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Yn', true, function(properties)
        {
          this.concurrentExecuteYns = properties ;
          this.logResultYns = properties
        }.bind(this)) ;

        PropertyImngObj.getProperties('List.LogLevel', false, function(properties)
        {
          this.jobLogLevels = properties ;
        }.bind(this)) ;
      },
      methods : {
        loaded : function()
        {

          var deploies = window.vmJobDeploies ;

          deploies.jobSubDeploies = [] ;
          deploies.instanceList.forEach(function(element)
          {

            if (element.instanceType == 'T')
            {
              var value = -1 ;
              for (var i = 0 ; i < deploies.jobDeploies.length ; i++)
              {

                if (deploies.jobDeploies[i].pk.instanceId === element.instanceId)
                {
                  value = i ;
                  break ;
                }
              }

              if (value != -1)
                deploies.jobSubDeploies.push(true) ;
              else
                deploies.jobSubDeploies.push(false) ;
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
            this.object.jobName = null ;
            this.object.jobType = null ;
            this.object.calendarId = null ;
            this.object.cronExpression = null ;
            this.object.operationId = null ;
            this.object.jobLogLevel = null ;
            this.object.concurrentExecuteYn = null ;
            this.object.logResultYn = null ;
            this.object.jobDesc = null ;
            this.object.jobId = null ;

            window.vmJobParameter.jobParameter = [] ;
            window.vmJobDeploies.jobSubDeploies = [] ;
          }
        },
        openModal : function(openModalParam)
        {

          if ('/igate/operation.html' == openModalParam.url)
          {
            openModalParam.modalParam = {
              operationType : 'J'
            } ;
          }

          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchOperationId : function(param)
        {
          this.object.operationId = param.operationId ;
        },
        setSearchCalendarId : function(param)
        {
          this.object.calendarId = param.calendarId ;
          this.$forceUpdate() ;
        },
      }
    }) ;

    window.vmJobParameter = new Vue({
      el : '#JobParameter',
      data : {
        jobParameter : []
      },
      methods : {
        parameterAdd : function()
        {
          this.jobParameter.push({}) ;
        },
        parameterRemove : function(index)
        {
          this.jobParameter = this.jobParameter.slice(0, index).concat(this.jobParameter.slice(index + 1)) ;
        }
      }
    }) ;

    window.vmJobDeploies = new Vue({
      el : '#JobDeploies',
      data : {
        instanceList : [],
        uri : "<c:url value='/igate/instance/list.json' />",
        jobDeploies : [],
        jobSubDeploies : []
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
            "pk.jobId" : this.jobDeploies.pk.jobId,
            "pk.instanceId" : this.jobDeploies.pk.instanceId
          } ;
        }
      },
      methods : {
        push : function(value, e)
        {
          if (e.target.checked)
          { //check true

            this.jobDeploies.push({
              "pk" : {
                "jobId" : window.vmMain.object.jobId,
                "instanceId" : value
              }
            }) ;
          }
          else
          { //check false
            for (var i = 0 ; i < this.jobDeploies.length ; i++)
            {
              if (this.jobDeploies[i].pk.instanceId === value)
              {
                this.jobDeploies.splice(i, 1) ;
                break ;
              }
            }
          }
        }
      }
    }) ;

    window.button = new Vue({
      el : '#Buttons',
      methods : {
        buttonVisible : function()
        {
          if (window.vmMain.object.jobType != "R")
            return true ;
          else
            return false ;
        }
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption, {
        start : function()
        {
          ControlImngObj.control("execute", null, $.param({
            jobId : window.vmMain.object.jobId
          })) ;
        },
        interrupt : function()
        {
          ControlImngObj.control("interrupt", null, $.param({
            jobId : window.vmMain.object.jobId
          })) ;
        }
      })
    }) ;
  }) ;
</script>