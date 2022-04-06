<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('mciSession') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([
    {
      'type' : "text",
      'mappingDataInfo' : "object.mciSessionId",
      'name' : "<fmt:message>igate.mciSession</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    },
    {
      'type' : "text",
      'mappingDataInfo' : "object.empId",
      'name' : "<fmt:message>igate.mciSession.empId</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    },
    {
      'type' : "text",
      'mappingDataInfo' : "object.macAddress",
      'name' : "<fmt:message>igate.mciSession.macAddress</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    },
    {
      'type' : "text",
      'mappingDataInfo' : "object.brnCd",
      'name' : "<fmt:message>igate.mciSession.brnCd</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    },
    {
      'type' : "select",
      'mappingDataInfo' :
      {
        'selectModel' : "object.sessionDelYn",
        'optionFor' : 'option in sessionDelYnList',
        'optionValue' : 'option.pk.propertyKey',
        'optionText' : 'option.propertyValue',
        'id' : 'sessionDelYnList',
      },
      'name' : "<fmt:message>head.logon</fmt:message> <fmt:message>head.yn</fmt:message>",
      'placeholder' : "<fmt:message>head.all</fmt:message>"
    },{
      'type' : "singleDaterange",
      'mappingDataInfo' : {
        'id' : 'searchLogonDaterange'
      },
      'name' : "<fmt:message>head.logon</fmt:message> <fmt:message>head.date</fmt:message>",
      'placeholder' : "<fmt:message>head.searchDate</fmt:message>"
    },{
      'type' : "singleDaterange",
      'mappingDataInfo' : {
        'id' : 'searchLogoffDaterange'
      },
      'name' : "<fmt:message>head.logoff</fmt:message> <fmt:message>head.date</fmt:message>",
      'placeholder' : "<fmt:message>head.searchDate</fmt:message>"
    }]) ;

    createPageObj.searchConstructor() ;

    createPageObj.setMainButtonList(
    {
      searchInitBtn : true,
      totalCount : true,
      newTabBtn : 'b' == '<c:out value="${_client_mode}" />',
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([
    {
      'type' : 'basic',
      'id' : 'MainBasic',
      'name' : '<fmt:message>head.basic.info</fmt:message>',
      'detailList' : [
      {
        'className' : 'col-lg-4',
        'detailSubList' : [
        {
          'type' : "text",
          'mappingDataInfo' : 'object.mciSessionId',
          'name' : "<fmt:message>igate.mciSession</fmt:message> <fmt:message>head.id</fmt:message>",
          isPk : true
        },
        {
          'type' : "text",
          'mappingDataInfo' : 'object.channelCode',
          'name' : "<fmt:message>igate.mciSession.channelCode</fmt:message>"
        },
        {
          'type' : "text",
          'mappingDataInfo' : 'object.brnCd',
          'name' : "<fmt:message>igate.mciSession.brnCd</fmt:message>"
        },{
          'type' : "select",
          'mappingDataInfo' :
          {
            'selectModel' : "object.sessionDelYn",
            'optionFor' : 'option in sessionDelYnList',
            'optionValue' : 'option.pk.propertyKey',
            'optionText' : 'option.propertyValue',
            'id' : 'sessionDelYnList',
          },
          'name' : "<fmt:message>head.logon</fmt:message> <fmt:message>head.yn</fmt:message>",
        } ]
      },
      {
        'className' : 'col-lg-4',
        'detailSubList' : [
        {
          'type' : "text",
          'mappingDataInfo' : 'object.mciInstanceId',
          'name' : "<fmt:message>igate.instance</fmt:message> <fmt:message>head.id</fmt:message>",
        },
        {
          'type' : "text",
          'mappingDataInfo' : 'object.channelIp',
          'name' : "<fmt:message>igate.mciSession.channelIp</fmt:message>",
        },{
          'type' : "text",
          'mappingDataInfo' : 'object.empId',
          'name' : "<fmt:message>igate.mciSession.empId</fmt:message>",
        }]
      },
      {
        'className' : 'col-lg-4',
        'detailSubList' : [
        {
          'type' : "text",
          'mappingDataInfo' : 'object.cmgrCd',
          'name' : "<fmt:message>igate.mciSession.cmgrCd</fmt:message>",
        },
        {
          'type' : "text",
          'mappingDataInfo' : 'object.logonYms',
          'name' : "<fmt:message>head.logon</fmt:message> <fmt:message>head.date</fmt:message>",
        },
        {
          'type' : "text",
          'mappingDataInfo' : 'object.logoffYms',
          'name' : "<fmt:message>head.logoff</fmt:message> <fmt:message>head.date</fmt:message>",
        }, ]
      }]
    }, ]) ;

    createPageObj.setPanelButtonList(null) ;
    createPageObj.panelConstructor(true) ;
    createPageObj.mainConstructor();

    SaveImngObj.setConfig(
    {
      objectUri : "<c:url value='/igate/mciSession/object.json'/>"
    }) ;

    ControlImngObj.setConfig(
    {
      controlUri : "<c:url value='/igate/mciSession/control.json'/>"
    }) ;

    new Vue(
    {
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;

    PropertyImngObj.getProperties('List.MciSession.SessionDelYn', true, function(sessionDelYnList)
    {

      window.vmSearch = new Vue(
      {
        el : '#' + createPageObj.getElementId('ImngSearchObject'),
        data :
        {
          pageSize : '10',
          object :
          {
            mciSessionId : null,
            empId : null,
            macAddress : null,
            brnCd : null,
            logonYms : null,
            logoffYms : null,
            sessionDelYn : " ",
          },
          sessionDelYnList : []
        },
        methods :
        {
          search : function()
          {
            var param = {
                pageSize: this.pageSize,
                object: {},
            };
            
            for(var key in this.object)
            {
              if(!this.object[key]) continue;
              param.object[key] = this.object[key];
            }
            
            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject')) ;
            vmList.makeGridObj.search(param, function()
            {
              $.ajax(
              {
                type : "GET",
                url : "<c:url value='/igate/mciSession/rowCount.json' />",
                data : JsonImngObj.serialize(param.object),
                processData : false,
                success : function(result)
                {
                  vmList.totalCount = numberWithComma(result.object) ;
                }
              }) ;
            }.bind(this)) ;
          },
          initSearchArea : function(searchCondition)
          {
            if (searchCondition)
            {
              for ( var key in searchCondition)
              {
                this.$data[key] = searchCondition[key] ;
              }
            }
            else
            {
              this.pageSize = '10' ;
              this.object.mciSessionId = null ;
              this.object.empId = null ;
              this.object.macAddress = null;
              this.object.brnCd = null;
              this.object.logonYms = null;
              this.object.logoffYms = null;
              this.object.sessionDelYn = " ";
            }

            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
            initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#sessionDelYnList'), this.object.sessionDelYn) ;
            initLogonSinglePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchLogonDaterange')) ;
            initLogoffSinglePicker(this, $('#' + createPageObj.getElementId('ImngSearchObject')).find('#searchLogoffDaterange')) ;
          }
        },
        mounted : function()
        {
          this.initSearchArea() ;
        },
        created : function()
        {
          this.sessionDelYnList = sessionDelYnList ;
        }
      }) ;

      var vmList = new Vue(
      {
        el : '#' + createPageObj.getElementId('ImngListObject'),
        data :
        {
          makeGridObj : null,
          newTabPageUrl : "<c:url value='/igate/mciSession.html' />",
          totalCount : '0',
        },
        methods : $.extend(true, {}, listMethodOption,
        {
          initSearchArea : function()
          {
            window.vmSearch.initSearchArea() ;
          }
        }),
        mounted : function()
        {

          this.makeGridObj = getMakeGridObj() ;

          this.makeGridObj.setConfig(
          {
            elementId : createPageObj.getElementId('ImngSearchGrid'),
            onClick : SearchImngObj.clicked,
            searchUri : "<c:url value='/igate/mciSession/search.json'/>",
            viewMode : "${viewMode}",
            popupResponse : "${popupResponse}",
            popupResponsePosition : "${popupResponsePosition}",
            columns : [
            {
              name : "empId",
              header : "<fmt:message>igate.mciSession.empId</fmt:message>",
              align : "left",
              width : "20%"
            },
            {
              name : "logonYms",
              header : "<fmt:message>head.logon</fmt:message> <fmt:message>head.date</fmt:message>",
              align : "left",
              width : "20%"
            },
            {
              name : "logoffYms",
              header : "<fmt:message>head.logoff</fmt:message> <fmt:message>head.date</fmt:message>",
              align : "left",
              width : "20%"
            },
            {
              name : "sessionDelYn",
              header : "<fmt:message>head.logon</fmt:message> <fmt:message>head.yn</fmt:message>",
              align : "center",
              width : "20%",
              formatter : function(value)
              {
                switch (value.row.sessionDelYn)
                {
                case 'Y' : {
                  return "<fmt:message>head.logon</fmt:message>" ;
                }
                case 'N' : {
                  return "<fmt:message>head.logoff</fmt:message>"; 
                }
                }
              }
            },
            {
              name : "brnCd",
              header : "<fmt:message>igate.mciSession.brnCd</fmt:message>",
              align : "left",
              width : "20%"
            }]
          }) ;

          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;

          this.newTabSearchGrid() ;
        }
      }) ;

      window.vmMain = new Vue(
      {
        el : '#MainBasic',
        data :
        {
          viewMode : 'Open',
          object :
          {
          },
          sessionDelYnList : [],
          panelMode : null
        },
        created :function()
        {
          PropertyImngObj.getProperties('List.MciSession.SessionDelYn', true, function(sessionDelYnList)
              {
                this.sessionDelYnList = sessionDelYnList;
              }.bind(this)) ;
        },
        methods :
        {
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
            }
          }
        },
      }) ;

    }) ;

    function initLogonSinglePicker(vueObj, dateRangeSelector)
    {
      var startDate = null;
      
      if(vueObj.object.logonYms)
      {
     	  var year = vueObj.object.logonYms.substring(0, 4);
     	  var month = vueObj.object.logonYms.substring(4, 6);
     	  var day = vueObj.object.logonYms.substring(6, 8);
  		
     	  startDate = year + '-' + month + '-' + day;
      }
      
      dateRangeSelector.customDatePicker(function(time)
      {
        vueObj.object.logonYms= time ;
      }, {
        startDate: startDate,
        format: 'YYYY-MM-DD',
        localeFormat: 'YYYY-MM-DD'
        }) ;
    }
    
    function initLogoffSinglePicker(vueObj, dateRangeSelector)
    {
      var startDate = null;
      
      if(vueObj.object.logoffYms)
      {
     	  var year = vueObj.object.logoffYms.substring(0, 4);
     	  var month = vueObj.object.logoffYms.substring(4, 6);
     	  var day = vueObj.object.logoffYms.substring(6, 8);
  		
     	  startDate = year + '-' + month + '-' + day;
      }
      
      dateRangeSelector.customDatePicker(function(time)
      {
        vueObj.object.logoffYms= time ;
      }, {
        startDate: startDate,
        format: 'YYYY-MM-DD',
        localeFormat: 'YYYY-MM-DD'
        }) ;
    }

  }) ;
</script>