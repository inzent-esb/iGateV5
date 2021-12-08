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
      totalCount: true,
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
          'type' : "cron",
          'mappingDataInfo' : {
        	  'modalTitle' : '<fmt:message>igate.job.cronExpression</fmt:message>',
        	  'vModel' : "object.cronExpression",
        	  'bodyHtml' : '#cronExpression',
          },
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
        detailHtml += '    <li class="list-group-item" v-for="(elm, index) in instanceList">' ;
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
           	vmList.makeGridObj.search(this, function() {
                $.ajax({
                    type : "GET",
                    url : "<c:url value='/igate/job/rowCount.json' />",
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
          totalCount: '0',
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
          cronExpression : null,
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
        
        openCustomModal : function(modalInfo)
        {
        	// Cron Expression Create Modal
        	
        	var cron_error = "<fmt:message>igate.job.error</fmt:message>" ;
        	var cron_validationBasic = "<fmt:message>igate.job.validationBasic</fmt:message>" ;
        	var cron_validationQuestion = "<fmt:message>igate.job.validationQuestion</fmt:message>" ;
        	var cron_validationHash = "<fmt:message>igate.job.validationHash</fmt:message>" ;
        	var cron_validationKo = "<fmt:message>igate.job.validationKo</fmt:message>" ;
        	var cron_validationEn = "<fmt:message>igate.job.validationEn</fmt:message>" ;
        	
        	var astro = '*' ;
    	   	var slash = '/' ;
    	   	var hyphen = '-' ;
    	   	var question = '?' ;
    	   	var comma = ',' ;
    	   	var hash = '#' ;
    	   	
    	   	var cron = null;
        	var regexr = /^\s*($|#|\w+\s*=|(\?|\*|(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?(?:,(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?)*)\s+(\?|\*|(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?(?:,(?:[0-5]?\d)(?:(?:-|\/|\,)(?:[0-5]?\d))?)*)\s+(\?|\*|(?:[01]?\d|2[0-3])(?:(?:-|\/|\,)(?:[01]?\d|2[0-3]))?(?:,(?:[01]?\d|2[0-3])(?:(?:-|\/|\,)(?:[01]?\d|2[0-3]))?)*)\s+(\?|\*|(?:0?[1-9]|[12]\d|3[01])(?:(?:-|\/|\,)(?:0?[1-9]|[12]\d|3[01]))?(?:,(?:0?[1-9]|[12]\d|3[01])(?:(?:-|\/|\,)(?:0?[1-9]|[12]\d|3[01]))?)*)\s+(\?|\*|(?:[1-9]|1[012])(?:(?:-|\/|\,)(?:[1-9]|1[012]))?(?:L|W)?(?:,(?:[1-9]|1[012])(?:(?:-|\/|\,)(?:[1-9]|1[012]))?(?:L|W)?)*|\?|\*|(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(?:(?:-)(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))?(?:,(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(?:(?:-)(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))?)*)\s+(\?|\*|(?:[0-6])(?:(?:-|\/|\,|#)(?:[0-6]))?(?:,(?:[0-6])(?:(?:-|\/|\,|#)(?:[0-6]))?)*|\?|\*|(?:MON|TUE|WED|THU|FRI|SAT|SUN)(?:(?:-)(?:MON|TUE|WED|THU|FRI|SAT|SUN))?(?:,(?:MON|TUE|WED|THU|FRI|SAT|SUN)(?:(?:-)(?:MON|TUE|WED|THU|FRI|SAT|SUN))?)*)(|\s)+(\?|\*|(?:|\d{4})(?:(?:-|\/|\,)(?:|\d{4}))?(?:,(?:|\d{4})(?:(?:-|\/|\,)(?:|\d{4}))?)*))$$/i;
        	
        	if (this.object.cronExpression) {
        		cron = this.object.cronExpression.split(' ');
        		
				var isEmpty = false;
        		
        		for (var i = 0; i < cron.length; i++) {
        			if (0 === cron[i].length){
        				isEmpty = true;
        				break;
        			}
        		}
        		
        		if (!regexr.test(this.object.cronExpression) || cron[3] == cron[5] || isEmpty) {
        			warnAlert({ message : cron_error });
        			return;
        		}
        		
        	} else {
        		cron = "* * * * * ? *".split(' ');
        	}
        	
        	startSpinner(modalInfo.spinnerMode);
        	
        	var cronResults;
        	var cloneElement = $('#cronExpression').clone();
        	
        	cloneElement.find('#cronVue').attr('id', 'cronVueJob');
        	cloneElement.find('#gridDiv').attr('id', 'gridDivJob');
        	
        	cloneElement.find('.tab-pane').each(function(index, element) {
        		$(element).attr({'id': $(element).attr('id') + 'JobDiv'});
        	});
        	
        	modalInfo.bodyHtml = cloneElement.html();
        	
        	modalInfo.shownCallBackFunc = function() {
        		// Cron Expression Shown Modal
        		
        		stopSpinner(modalInfo.spinnerMode);
        		cronResults = new Vue ({
                    el : '#cronVueJob',
                    created: function() {
                    	// 사용자 외부 입력값에 따른 모달 라디오 버튼 설정
                    	if (cron[0].indexOf(comma) != -1) {
                    		this.secondCheckValue = 4;
                    		
                       		this.secondResult5 = cron[0];
                    	} else if (cron[0].indexOf(astro) != -1) {
                    		this.secondCheckValue = 1;
                    		
                    	} else if (cron[0].indexOf(slash) != -1) {
                    		this.secondCheckValue = 2;
                    		
                    		secondSelect = cron[0].split(slash);
                    		this.secondResult1 = secondSelect[0];
                    		this.secondResult2 = secondSelect[1];
                    	} else if (cron[0].indexOf(hyphen) != -1) {
                   			this.secondCheckValue = 3;
                   			
                   			secondSelect = cron[0].split(hyphen);
                    		this.secondResult3 = secondSelect[0];
                    		this.secondResult4 = secondSelect[1];
                   		} else {
                    		this.secondCheckValue = 4;
                    		
                    		this.secondResult5 = cron[0];
                    	}
                    	
                    	if (cron[1].indexOf(comma) != -1) {
                    		this.minuteCheckValue = 4;
                    		
                    		this.minuteResult5 = cron[1];
                   		} else if (cron[1].indexOf(astro) != -1) {
                   			this.minuteCheckValue = 1;
                   			
                   		} else if (cron[1].indexOf(slash) != -1) {
                    		this.minuteCheckValue = 2;
                    		
                    		minuteSelect = cron[1].split(slash);
                    		this.minuteResult1 = minuteSelect[0];
                    		this.minuteResult2 = minuteSelect[1];
                   		} else if (cron[1].indexOf(hyphen) != -1) {
                    		this.minuteCheckValue = 3;
                    		
                    		minuteSelect = cron[1].split(hyphen);
                    		this.minuteResult3 = minuteSelect[0];
                    		this.minuteResult4 = minuteSelect[1];
                   		} else {
                    		this.minuteCheckValue = 4;
                    		
                    		this.minuteResult5 = cron[1];
                   		}
                    	
                    	if (cron[2].indexOf(comma) != -1) {
                    		this.hourCheckValue = 4;
                    		
                    		this.hourResult5 = cron[2];
                   		} else if (cron[2].indexOf(astro) != -1){
                   			this.hourCheckValue = 1;
                   			
                   		} else if (cron[2].indexOf(slash) != -1) {
                    		this.hourCheckValue = 2;
                    		
                    		hourSelect = cron[2].split(slash);
                    		this.hourResult1 = hourSelect[0];
                    		this.hourResult2 = hourSelect[1];
                   		} else if (cron[2].indexOf(hyphen) != -1) {
                    		this.hourCheckValue = 3;
                    		
                    		hourSelect = cron[2].split(hyphen);
                    		this.hourResult3 = hourSelect[0];
                    		this.hourResult4 = hourSelect[1];
                   		} else {
                    		this.hourCheckValue = 4;
                    		
                    		this.hourResult5 = cron[2];
                   		}
                    	
                    	if (cron[3].indexOf(comma) != -1) {
                    		this.dayCheckValue = 3;
                    		
                    		this.dayResult1 = cron[3]
                   		} else if (cron[3].indexOf(astro) != -1) {
                   			this.dayCheckValue = 1;
                   			
                   		} else if (cron[3].indexOf(question) != -1) {
                   			this.dayCheckValue = 2;
                   			
                   		} else {
                    		this.dayCheckValue = 3;
                    		
                    		this.dayResult1 = cron[3];
                   		}
                    	
                    	if (cron[4].indexOf(comma) != -1) {
                    		this.monthCheckValue = 4;
                    		
                    		this.monthResult5 = cron[4];
                   		} else if (cron[4].indexOf(astro) != -1) {
                   			this.monthCheckValue = 1;
                   			
                   		} else if (cron[4].indexOf(slash) != -1) {
                    		this.monthCheckValue = 2;
                    		
                    		monthSelect = cron[4].split(slash);
                    		this.monthResult1 = monthSelect[0];
                    		this.monthResult2 = monthSelect[1];
                   		} else if (cron[4].indexOf(hyphen) != -1) {
                    		this.monthCheckValue = 3;
                    		
                    		monthSelect = cron[4].split(hyphen);
                    		this.monthResult3 = monthSelect[0];
                    		this.monthResult4 = monthSelect[1];
                   		} else {
                    		this.monthCheckValue = 4;
                    		
                    		this.monthResult5 = cron[4];
                   		}
                    	
                    	if (cron[5].indexOf(question) != -1){
                    		this.weekCheckValue = 1
                    		
                    	} else if (cron[5].indexOf(astro) != -1 || cron[5].indexOf(slash) != -1 || cron[5].indexOf(hyphen) != -1 || cron[5].indexOf(comma) != -1 || cron[5].indexOf(hash) != -1 ) {
                    		this.weekCheckValue = 3;
                    		
                    		this.weekResult2 = cron[5];
                   		} else {
                    		this.weekCheckValue = 2;
                    		
                    		if (cron[5] === "0" || cron[5] === "SUN" || cron[5] === "sun" || cron[5] === "Sun") this.weekResult1 = "Sun"
                    		else if (cron[5] === "1" || cron[5] === "MON" || cron[5] === "mon" || cron[5] === "Mon") this.weekResult1 = "Mon"
                   			else if (cron[5] === "2" || cron[5] === "TUE" || cron[5] === "tue" || cron[5] === "Tue") this.weekResult1 = "Tue"
               				else if (cron[5] === "3" || cron[5] === "WED" || cron[5] === "wed" || cron[5] === "Wed") this.weekResult1 = "Wed"
          					else if (cron[5] === "4" || cron[5] === "THU" || cron[5] === "thu" || cron[5] === "Thu") this.weekResult1 = "Thu"
      						else if (cron[5] === "5" || cron[5] === "FRI" || cron[5] === "fri" || cron[5] === "Fri") this.weekResult1 = "Fri"
   							else if (cron[5] === "6" || cron[5] === "SAT" || cron[5] === "sat" || cron[5] === "Sat") this.weekResult1 = "Sat"
                   		}
                    	
                    	if (cron[6] == null){
                    		this.yearCheckValue = 1;
                    		
                    	} else if (cron[6].indexOf(comma) != -1) {
                    		this.yearCheckValue = 4;
                    		
                    		this.yearResult5 = cron[6];
                   		} else if (cron[6].indexOf(astro) != -1){
                   			this.yearCheckValue = 1;
                   			
                   		} else if (cron[6].indexOf(slash) != -1) {
                    		yearSelect = cron[6].split(slash);
                    		
                    		if (yearSelect[0] <= 2099 && yearSelect[1] <= 10){
                    			this.yearCheckValue = 2;
                        		this.yearResult1 = yearSelect[0];
                        		this.yearResult2 = yearSelect[1];	
                    		} else {
                    			this.yearCheckValue = 4;
                    			this.yearResult5 = cron[6];
                    		}
                    		
                   		} else if (cron[6].indexOf(hyphen) != -1) {
                    		yearSelect = cron[6].split(hyphen);
                    		
							if (yearSelect[0] <= 2099 && yearSelect[1] <= 2099){
								this.yearCheckValue = 3;
	                    		this.yearResult3 = yearSelect[0];
	                    		this.yearResult4 = yearSelect[1];	
							} else{
								this.yearCheckValue = 4;
								this.yearResult5 = cron[6];
							}
							
                   		} else {
                    		this.yearCheckValue = 4;
                    		this.yearResult5 = cron[6];
                   		}
                    },
                    data : {
                       items : [
                    	   {
                    		   id : "secondTabJob",
                    		   name : "<fmt:message>igate.job.second</fmt:message>"
                    	   },
                    	   {
                    		   id : "minuteTabJob",
                    		   name : "<fmt:message>igate.job.minute</fmt:message>"
                    	   },
                    	   {
                    		   id : "hourTabJob",
                    		   name : "<fmt:message>igate.job.hour</fmt:message>"
                    	   },
                    	   {
                    		   id : "dayTabJob",
                    		   name : "<fmt:message>igate.job.dayOfMonth</fmt:message>"
                    	   },
                    	   {
                    		   id : "monthTabJob",
                    		   name : "<fmt:message>igate.job.month</fmt:message>"
                    	   },
                    	   {
                    		   id : "weekTabJob",
                    		   name : "<fmt:message>igate.job.dayOfWeek</fmt:message>"
                    	   },
                    	   {
                    		   id : "yearTabJob",
                    		   name : "<fmt:message>igate.job.year</fmt:message>"
                    	   }
                       ],
                       columns : [
               	   		   {
            	   			   header : "<fmt:message>igate.job.second</fmt:message>",
            	   			   name : "second",
            	   			   align : "center"
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.minute</fmt:message>",
            	   			   name : "minute",
            	   			   align : "center"
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.hour</fmt:message>",
	         	   			   name : "hour",
	         	   			   align : "center"
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.dayOfMonth</fmt:message>",
	         	   			   name : "dayOfMonth",
	         	   			   align : "center"
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.month</fmt:message>",
	         	   			   name : "month",
	         	   			   align : "center"
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.dayOfWeek</fmt:message>",
	         	   			   name : "dayOfWeek",
	         	   			   align : "center"               	   			   
            	   		   },
            	   		   {
            	   			   header : "<fmt:message>igate.job.year</fmt:message>",
	         	   			   name : "year",
	         	   			   align : "center"               	   			   
            	   		   }
               	   	   ],
               	   	   secondCheckValue : '',
                       minuteCheckValue : '',
                       hourCheckValue : '',
                       dayCheckValue : '',
                       monthCheckValue : '',
                       weekCheckValue : '',
                       yearCheckValue : '',
                       secondResult1 : '',
                       secondResult2 : '',
                       secondResult3 : '',
                       secondResult4 : '',
                       secondResult5 : '',
                       minuteResult1 : '',
                       minuteResult2 : '',
                       minuteResult3 : '',
                       minuteResult4 : '',
                       minuteResult5 : '',
                       hourResult1 : '',
                       hourResult2 : '',
                       hourResult3 : '',
                       hourResult4 : '',
                       hourResult5 : '',
                       dayResult1 : '',
                       monthResult1 : '',
                       monthResult2 : '',
                       monthResult3 : '',
                       monthResult4 : '',
                       monthResult5 : '',
                       weekResult1 : '',
                       weekResult2 : '',
                       yearResult1 : '', 
                       yearResult2 : '', 
                       yearResult3 : '', 
                       yearResult4 : '',
                       yearResult5 : '',
                       gridView : [],
                       hideIE : true,
                       resultData : null,
                       secondSelect : null,
                       minuteSelect : null,
                       hourSelect : null,
                       monthSelect : null,
                       yearSelect : null
        			},
        			mounted: function() {
						this.gridView = new tui.Grid({
							// Modal Tui Grid Create
							el : document.getElementById('gridDivJob'),
							data : this.dataset,
							scrollX : false,
							scrollY : false,
							columns : this.columns
						}) ;
						
						// Browser Check
                		var agt = navigator.userAgent.toLowerCase();
                		this.hideIE = !((navigator.appName == 'Netscape' && agt.indexOf('trident') != -1) || (agt.indexOf("msie") != -1)) ;
					},
                    methods : {
                    	tabClick : function() {
                    		// Tab 클릭 시, Cron Expression 정규식 테스트
                    		
                    		$('#cronVueJob').find('a[data-toggle="tab"]').off('show.bs.tab').on('show.bs.tab', function(e) {
                    			
                    			var reg1 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-z|A-Z|.~!?@;:\#$\\\%<>^&\()\=+_\’`]/ ;
                        	   	var reg2 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-z|A-Z|.~!@;:\#$\\\%<>^&\()\=+_\’`]/ ;
                        	   	var reg3 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|.~!?@;:\#$\\\%<>^&\()\=+_\’`]/ ;
                        	   	var reg4 = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|.~!@;:\$\\\%<>^&\()\=+_\’`]/ ;

                        	   	var isEmpty = false ;
                    			var gridColums = cronResults.gridView.getColumns();
                    			var rowInfo = cronResults.gridView.getRowAt(0);
                    			var cronTabCheck = rowInfo.second + " " + rowInfo.minute + " " + rowInfo.hour + " " + rowInfo.dayOfMonth + " " + rowInfo.month + " " + rowInfo.dayOfWeek + ( '' === rowInfo.year ? '' : " " + rowInfo.year ) ;
                    			
                    			for (var i = 0; i < gridColums.length; i++){
                    				
                    				if ('' == cronResults.gridView.getColumnValues(gridColums[i].name)){
                    					isEmpty = true ;
                    					
                    					if (rowInfo.year == '') isEmpty = false ;
                    					
                    					break ;	
                    				}
                    			}
                    			
                    			if (reg1.test(rowInfo.second) || reg1.test(rowInfo.minute) || reg1.test(rowInfo.hour) || reg1.test(rowInfo.year)){
                    				warnAlert({ message : cron_validationBasic + "<br/>" + cron_validationEn + "<br/>" + cron_validationKo, isXSSMode: false });
                    				e.preventDefault();
                    			} else if (reg2.test(rowInfo.dayOfMonth)) {
                    				warnAlert({ message : cron_validationQuestion + "<br/>" + cron_validationEn + "<br/>" + cron_validationKo, isXSSMode: false });
                    				e.preventDefault();                  		
                    			} else if (reg3.test(rowInfo.month)){
                    				warnAlert({ message : cron_validationBasic + "<br/>" + cron_validationKo, isXSSMode: false });
                    				e.preventDefault();                    			
                    			} else if (reg4.test(rowInfo.dayOfWeek)){
                    				warnAlert({ message : cron_validationHash + "<br/>" + cron_validationKo, isXSSMode: false });
                    				e.preventDefault();      
                    			} else if (!regexr.test(cronTabCheck) || isEmpty){
                    				warnAlert({ message : cron_error});
            		    			e.preventDefault();
                    			}
                    			
                    		});
                   		},
                   		gridData : function(param) {
                   			// Tui Grid 표 데이터 변경
                   			
                    		var newDataObj = {
                    			second : astro,
                    			minute : astro,
                    			hour : astro,
                    			dayOfMonth : astro,
                    			month : astro,
                    			dayOfWeek : question,
                    			year : astro
                    		};

                    		var rowInfo = this.gridView.getRowAt(0);
                    		
                    		if (null != rowInfo) {
                        		for (var key in newDataObj){
                        			newDataObj[key] = rowInfo[key];
                        		}                    			
                    		}
                    		
							for (var key in param) {
								newDataObj[key] = param[key];
							}
                      		
                    		this.gridView.resetData([newDataObj]) ;
                    	}
                    },
					watch: {
						// 라디오 버튼에 따른 값 변경
						secondCheckValue: function() {
                    		if (this.secondCheckValue == 1) this.resultData = astro;
                    		else if (this.secondCheckValue == 2) this.resultData = this.secondResult1 + slash + this.secondResult2;
                    		else if (this.secondCheckValue == 3) this.resultData = this.secondResult3 + hyphen + this.secondResult4;
                    		else if (this.secondCheckValue == 4) this.resultData = this.secondResult5;
                    		
                    		this.gridData({second: this.resultData});
						},
						secondResult1 : function() {
							this.gridData({second: this.secondResult1 + slash + this.secondResult2});
						},
						secondResult2 : function() {
							this.gridData({second: this.secondResult1 + slash + this.secondResult2});
						},
						secondResult3 : function() {
							this.gridData({second: this.secondResult3 + hyphen + this.secondResult4});
						},
						secondResult4 : function() {
							this.gridData({second: this.secondResult3 + hyphen + this.secondResult4});
						},
						secondResult5 : function() {
                    		this.gridData({second: this.secondResult5});
		                },
						minuteCheckValue : function() {
							if (this.minuteCheckValue == 1) this.resultData = astro;
							else if (this.minuteCheckValue == 2) this.resultData = this.minuteResult1 + slash + this.minuteResult2;
							else if (this.minuteCheckValue == 3) this.resultData = this.minuteResult3 + hyphen + this.minuteResult4;
							else if (this.minuteCheckValue == 4) this.resultData = this.minuteResult5;
							
							this.gridData({minute: this.resultData});
                    	},
                    	minuteResult1 : function() {
                    		this.gridData({minute: this.minuteResult1 + slash + this.minuteResult2});
                    	},
                    	minuteResult2 : function() {
                    		this.gridData({minute: this.minuteResult1 + slash + this.minuteResult2});
                    	},
                    	minuteResult3 : function() {
                    		this.gridData({minute: this.minuteResult3 + hyphen + this.minuteResult4});
                    	},
                    	minuteResult4 : function() {
                    		this.gridData({minute: this.minuteResult3 + hyphen + this.minuteResult4});
                    	},
                    	minuteResult5 : function() {
                    		this.gridData({minute: this.minuteResult5});
                    	},
						hourCheckValue : function() {
                    		if (this.hourCheckValue == 1) this.resultData = astro;
                    		else if (this.hourCheckValue == 2) this.resultData = this.hourResult1 + slash + this.hourResult2;
                    		else if (this.hourCheckValue == 3) this.resultData = this.hourResult3 + hyphen + this.hourResult4;
                    		else if (this.hourCheckValue == 4) this.resultData = this.hourResult5;
                    		
                    		this.gridData({hour: this.resultData});
                    	},
                    	hourResult1 : function() {
                    		this.gridData({hour: this.hourResult1 + slash + this.hourResult2});
                    	},
                    	hourResult2 : function() {
                    		this.gridData({hour: this.hourResult1 + slash + this.hourResult2});
                    	},
                    	hourResult3 : function() {
                    		this.gridData({hour: this.hourResult3 + hyphen + this.hourResult4});
                    	},
                    	hourResult4 : function() {
                    		this.gridData({hour: this.hourResult3 + hyphen + this.hourResult4});
                    	},
                    	hourResult5 : function() {
                    		this.gridData({hour: this.hourResult5});
                    	},
						dayCheckValue : function() {
							if (this.dayCheckValue == 1) {
								this.resultData = astro;
							
								if (this.weekCheckValue != 1){
									this.weekCheckValue = 1;
									this.gridData({dayOfWeek: question});
								}
							}
							else if (this.dayCheckValue == 2) {
								this.resultData = question;
								
								if (this.weekCheckValue == 1){
									this.weekCheckValue = 3;
									this.weekResult2 = astro;
									this.gridData({dayOfWeek: astro});
								}
							}
							else if (this.dayCheckValue == 3){
								this.resultData = this.dayResult1;
								
								if (this.weekCheckValue != 1){
									this.weekCheckValue = 1;
									this.gridData({dayOfWeek: question});
								}
							}
							
							this.gridData({dayOfMonth: this.resultData});
                    	},
                    	dayResult1 : function() {
                    		this.gridData({dayOfMonth: this.dayResult1});
                    	},
						monthCheckValue : function() {
							if (this.monthCheckValue == 1) this.resultData = astro;
							else if (this.monthCheckValue == 2) this.resultData = this.monthResult1 + slash + this.monthResult2;
							else if (this.monthCheckValue == 3) this.resultData = this.monthResult3 + hyphen + this.monthResult4;
							else if (this.monthCheckValue == 4) this.resultData = this.monthResult5;
							
							this.gridData({month: this.resultData});
                    	},
                    	monthResult1 : function () {
                			this.gridData({month: this.monthResult1 + slash + this.monthResult2});
                    	},
                    	monthResult2 : function () {
                			this.gridData({month: this.monthResult1 + slash + this.monthResult2});
                    	},
                    	monthResult3 : function () {
                    		this.gridData({month: this.monthResult3 + hyphen + this.monthResult4});
                    	},
                    	monthResult4 : function () {
                    		this.gridData({month: this.monthResult3 + hyphen + this.monthResult4});
                    	},
                    	monthResult5 : function () {
                    		this.gridData({month: this.monthResult5});
                    	},
						weekCheckValue : function() {
                    		if (this.weekCheckValue == 1){
                    			this.resultData = question;
                    		
                    			if (this.dayCheckValue == 2){
                    				this.dayCheckValue = 1;
                    				this.gridData({dayOfMonth: astro});
                    			}
                    		}
                    		else if (this.weekCheckValue == 2){
                    			this.resultData = this.weekResult1;
                    			
                    			if (this.dayCheckValue != 2){
                    				this.dayCheckValue = 2;
                    				this.gridData({dayOfMonth: question});
                    			}
                    		}
                    		else if (this.weekCheckValue == 3){
                    			this.resultData = this.weekResult2;
                    			
                    			if (this.dayCheckValue != 2){
                    				this.dayCheckValue = 2;
                    				this.gridData({dayOfMonth: question});
                    			}
                    		}
                    		
                    		this.gridData({dayOfWeek: this.resultData});
                    	},
                    	weekResult1 : function() {
                    		this.gridData({dayOfWeek: this.weekResult1});
                    	},
                    	weekResult2 : function() {
                    		this.gridData({dayOfWeek: this.weekResult2});
                    	},
						yearCheckValue : function() {
							if (this.yearCheckValue == 1) this.resultData = astro;
							else if (this.yearCheckValue == 2) this.resultData = this.yearResult1 + slash + this.yearResult2;
							else if (this.yearCheckValue == 3) this.resultData = this.yearResult3 + hyphen + this.yearResult4;
							else if (this.yearCheckValue == 4) this.resultData = this.yearResult5;
							
							this.gridData({year: this.resultData});
                    	},
                    	yearResult1 : function() {
                			this.gridData({year: this.yearResult1 + slash + this.yearResult2});
                    	},
                    	yearResult2 : function() {
                			this.gridData({year: this.yearResult1 + slash + this.yearResult2});
                    	},
                    	yearResult3 : function() {
                    		this.gridData({year: this.yearResult3 + hyphen + this.yearResult4});
                    	},
                    	yearResult4 : function() {
                    		this.gridData({year: this.yearResult3 + hyphen + this.yearResult4});
                    	},
                    	yearResult5 : function() {
                    		this.gridData({year: this.yearResult5});
                    	}
					}
                })
        	} ;
        
        	modalInfo.okCallBackFunc = function() {
        		// Cron Expression Modal Ok Click Function
        		
        		var isEmpty = false;
        		var gridColums = cronResults.gridView.getColumns();
        		var rowInfo = cronResults.gridView.getRowAt(0) ;
        		var objectResult = rowInfo.second + " " + rowInfo.minute + " " + rowInfo.hour + " " + rowInfo.dayOfMonth + " " + rowInfo.month + " " + rowInfo.dayOfWeek + ( '' === rowInfo.year ? '' : " " + rowInfo.year ) ;
       			
        		for (var i = 0; i < gridColums.length; i++){
        			if ('' == cronResults.gridView.getColumnValues(gridColums[i].name)){
    					isEmpty = true ;
    					
    					if (rowInfo.year == '') isEmpty = false ;
    					
    					break ;	
    				}
        		}
        		
       			if (!regexr.test(objectResult) || isEmpty){
       				warnAlert({ message : cron_error });
       				return;
       			}
       			
   				window.vmMain.object.cronExpression = objectResult;
   				
   				window.vmMain.$forceUpdate() ;
   				
   				$('#jobModalSearch').modal('hide');
       			
        	};
        	
            createPageObj.openCustomModal.call(this, modalInfo) ;
        } 
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
          this.instanceList = data.object.filter(function(obj) {
        	  return 'T' == obj.instanceType;
          }) ;
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