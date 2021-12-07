<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var popupId = '<c:out value="${popupId}" />' ;
<%-- search init --%>
  var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('jobModal') ;
    createPageObj.setIsModal(true) ;

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
      searchInitBtn : true,
      totalCount: true,
    }) ;

    createPageObj.mainConstructor() ;
<%-- grid init --%>
  PropertyImngObj.getProperties('List.Job.JobType', true, function(jobTypes)
    {

      var vmSearch = new Vue({
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data : {
          pageSize : '10',
          object : {
            jobId : null,
            jobDesc : null,
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
          initSearchArea : function()
          {
            this.pageSize = '10' ;
            this.object.jobId = null ;
            this.object.jobDesc = null ;
            this.object.jobType = ' ' ;

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#jobTypes'), this.object.jobType) ;
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
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
        },
        methods : {
          initSearchArea : function()
          {
            vmSearch.initSearchArea() ;
          },
        },
        mounted : function()
        {

          this.makeGridObj = getMakeGridObj() ;

          this.makeGridObj.setConfig({
            isModal : true,
            elementId : createPageObj.getElementId('ImngSearchGrid'),
            onClick : function(loadParam)
            {

              startSpinner() ;

              $("#" + popupId).data('callBackFunc')(loadParam) ;

              $("#" + popupId).find('#modalClose').trigger('click') ;
            },
            searchUri : "<c:url value='/igate/job/searchPopup.json' />",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [{
              name : "jobId",
              header : "<fmt:message>head.id</fmt:message>",
              align : "left"
            }, {
              name : "jobDesc",
              header : "<fmt:message>head.description</fmt:message>",
              align : "left"
            }, {
              name : "jobType",
              header : "<fmt:message>igate.job.jobType</fmt:message>",
              align : "left",
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
              align : "left"
            }]
          }) ;
        }
      }) ;
    }) ;
  }) ;
</script>