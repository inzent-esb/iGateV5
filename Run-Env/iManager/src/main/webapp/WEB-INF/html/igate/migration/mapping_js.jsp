<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {

    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('mapping') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "text",
      'mappingDataInfo' : "object.mappingId",
      'name' : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.mappingName",
      'name' : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>",
      'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    }, {
      'type' : "text",
      'mappingDataInfo' : "object.mappingGroup",
      'name' : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.group</fmt:message>",
      'placeholder' : "<fmt:message>head.searchData</fmt:message>"
    }, {
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/common/privilege.html',
        'modalTitle' : '<fmt:message>common.privilege</fmt:message>',
        'vModel' : "object.privilegeId",
        'callBackFuncName' : 'setSearchPrivilegeId'
      },
      'name' : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }]) ;

    createPageObj.searchConstructor(true) ;

    createPageObj.setMainButtonList({
      newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
      importBtn : hasMappingEditor,
      makeBtn : hasMappingEditor,
      searchInitBtn : true,
    }) ;

    createPageObj.mainConstructor() ;

    createPageObj.setTabList([{
      'type' : 'basic',
      'id' : 'Make',
      'name' : '<fmt:message>head.make</fmt:message>',
      'detailList' : [{
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : 'object.userId',
          'name' : "<fmt:message>igate.migration.userId</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.name',
          'name' : "<fmt:message>igate.migration.name</fmt:message>"
        }, ]
      }, {
        'className' : 'col-lg-6',
        'detailSubList' : [{
          'type' : "text",
          'mappingDataInfo' : 'object.migrationDate',
          'name' : "<fmt:message>igate.migration.migrationDate</fmt:message>"
        }, {
          'type' : "text",
          'mappingDataInfo' : 'object.migrationTime',
          'name' : "<fmt:message>igate.migration.migrationTime</fmt:message>"
        }, ]
      }, ],
      'appendAreaList' : [{
        'getDetailArea' : function()
        {

          var detailHtml = '' ;

          detailHtml += '<div style="width: 100%; padding-left:0.75rem; padding-right: 0.75rem;">' ;
          detailHtml += '<table class="migration-table" width="100%">' ;
          detailHtml += '    <colgroup>' ;
          detailHtml += '        <col width="33%">' ;
          detailHtml += '        <col width="33%">' ;
          detailHtml += '        <col width="34%">' ;
          detailHtml += '    </colgroup>' ;
          detailHtml += '    <thead>' ;
          detailHtml += '	       <tr align="center" style="background-color: #f5f6fb;">' ;
          detailHtml += '		       <th style="height: 32px;"><fmt:message>igate.mapping</fmt:message></th>' ;
          detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.includeList</fmt:message></th>' ;
          detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.referList</fmt:message></th>' ;
          detailHtml += '	       </tr>' ;
          detailHtml += '	   </thead>' ;
          detailHtml += '	   <tr v-for="mapping in object.mappingList" style="height: 28px;">' ;
          detailHtml += '	       <td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>' ;
          detailHtml += '        <td valign="top">' ;
          detailHtml += '            <table width="100%">' ;
          detailHtml += '                <tr>' ;
          detailHtml += '                    <td width="20%"><fmt:message>igate.mapping</fmt:message></td>' ;
          detailHtml += '                    <td>' ;
          detailHtml += '                        <table width="100%">' ;
          detailHtml += '                            <tr>' ;
          detailHtml += '                                <td>{{mapping.mapping.mappingId}}({{mapping.mapping.mappingName}})</td>' ;
          detailHtml += '                            </tr>' ;
          detailHtml += '                        </table>' ;
          detailHtml += '                    </td>' ;
          detailHtml += '               </tr>' ;
          detailHtml += '           </table>' ;
          detailHtml += '       </td>' ;
          detailHtml += '       <td valign="top">' ;
          detailHtml += '           <table width="100%">' ;
          detailHtml += '               <tr v-if="mapping.referRecords.length">' ;
          detailHtml += '                   <td width="30%"><fmt:message>igate.record</fmt:message></td>' ;
          detailHtml += '                   <td>' ;
          detailHtml += '                       <table width="100%">' ;
          detailHtml += '                           <tr v-for="referRecord in mapping.referRecords">' ;
          detailHtml += '                              <td>{{referRecord.recordId}}({{referRecord.recordName}})</td>' ;
          detailHtml += '                           </tr>' ;
          detailHtml += '                       </table>' ;
          detailHtml += '                   </td>' ;
          detailHtml += '              </tr>' ;
          detailHtml += '          </table>' ;
          detailHtml += '      </td>' ;
          detailHtml += '    </tr>' ;
          detailHtml += '</table>' ;
          detailHtml += '</div>' ;

          if (hasMappingEditor)
          {
            detailHtml += '<div class="col-lg-12">' ;
            detailHtml += '    <a href="javascript:void(0);" id="migrationBtn" class="btn detail btn-primary viewGroup" style="float: right;" v-on:click="migration"><fmt:message>head.migration</fmt:message></a>' ;
            detailHtml += '    <a href="javascript:void(0);" id="downloadBtn" class="btn detail viewGroup" style="float: right; right: 10px;" v-on:click="downloadFile"><fmt:message>head.download</fmt:message></a>' ;
            detailHtml += '</div>' ;
          }

          return $(detailHtml) ;
        }
      }]
    }, {
      'type' : 'custom',
      'id' : 'Import',
      'name' : '<fmt:message>head.import</fmt:message>',
      'getDetailArea' : function()
      {
        return $("#fileResult").html() ;
      }
    }]) ;

    createPageObj.setPanelButtonList(null) ;

    createPageObj.panelConstructor(true) ;

    SaveImngObj.setConfig({
      objectUri : "<c:url value='/igate/migration/mapping/object.json' />"
    }) ;

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/migration/mapping/control.json' />"
    }) ;

    window.vmSearch = new Vue({
      el : '#' + createPageObj.getElementId('ImngSearchObject'),
      data : {
        pageSize : '10',
        object : {
          privilegeId : null,
          mappingId : null,
          mappingName : null,
          mappingGroup : null,
          pk : {}
        },
      },
      methods : {
        search : function()
        {
          if ('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display'))
          {
            $('#' + createPageObj.getElementId('ImngListObject')).show() ;
            $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide() ;
          }

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
            this.object.mappingId = null ;
            this.object.mappingName = null ;
            this.object.mappingGroup = null ;
            this.object.privilegeId = null ;        	  
          }

          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
        },
        openModal : function(openModalParam)
        {
          createPageObj.openModal.call(this, openModalParam) ;
        },
        setSearchPrivilegeId : function(param)
        {
          this.object.privilegeId = param.privilegeId ;
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
        newTabPageUrl: "<c:url value='/igate/migration/mapping.html' />"
      },
      methods : $.extend(true, {}, listMethodOption, {
        initSearchArea : function()
        {
          window.vmSearch.initSearchArea() ;
        },
        goImport : function()
        {
	      window.vmImport.fileName = "" ;
	      window.vmImport.errorMessage = "" ;
	      window.vmImport.object = {} ;
	      data = null ;
          panelOpen('detail') ;
          $("a[href='#Import']").trigger('click') ;
        },
        make : function()
        {

          targetIdList = [] ;
          makeData = "" ;

          $.each(SearchImngObj.searchGrid.getCheckedRows(), function(idx, item)
          {
            targetIdList[idx] = item.mappingId ;
            makeData = makeData + "targetIds=" + item.mappingId + "&" ;
          }) ;

          if (targetIdList.length == 0)
          {
            warnAlert("<fmt:message>igate.migration.selectError</fmt:message>") ;
          }
          else
          {
            MigrationImngObj.makeSubmit("<c:url value='/igate/migration/mapping/make.json' />", targetIdList, function(result)
            {
              window.vmMake.object = result.object ;
              panelOpen('detail') ;
            }) ;
          }
        }
      }),
      mounted : function()
      {

        this.makeGridObj = getMakeGridObj() ;

        this.makeGridObj.setConfig({
          elementId : createPageObj.getElementId('ImngSearchGrid'),
          onClick : SearchImngObj.clicked,
          searchUri : "<c:url value='/igate/migration/mapping/list.json' />",
          viewMode : "${viewMode}",
          popupResponse : "${popupResponse}",
          popupResponsePosition : "${popupResponsePosition}",
          rowHeaders : ['checkbox', 'rowNum'],
          columns : [{
            name : "mappingId",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "20%",
          }, {
            name : "mappingName",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.name</fmt:message>",
            align : "left",
            width: "20%",
          }, {
            name : "mappingDesc",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.description</fmt:message>",
            align : "left",
            width: "20%",
          }, {
            name : "mappingType",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.type</fmt:message>",
            align : "center",
            width: "10%",
            formatter : function(value)
            {
              if (value.row.mappingType == "H")
                return "Header" ;
              else if (value.row.mappingType == "I")
                return "Individual" ;
              else if (value.row.mappingType == "E")
                return "Embedded" ;
            }
          }, {
            name : "mappingGroup",
            header : "<fmt:message>igate.mapping</fmt:message> <fmt:message>head.group</fmt:message>",
            align : "left",
            width: "15%",
          }, {
            name : "privilegeId",
            header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
            align : "left",
            width: "15%",
          }]
        }) ;

        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
        
        this.newTabSearchGrid();
      }
    }) ;

    window.vmMake = new Vue({
      el : '#Make',
      data : {
        pageSize : '10',
        object : {
          pk : {}
        }
      },
      methods : {
        downloadFile : function()
        {
          var myForm = document.popForm ;
          var url = "<c:url value='/igate/migration/mapping/down.json?' />" + makeData ;
          var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no, scrollorbars=no, resizable=no") ;
          myForm.action = url ;
          myForm.method = "post" ;
          myForm.target = "hiddenframe" ;
          myForm.submit()
        },
        migration : function()
        {
          MigrationImngObj.makeSubmit("<c:url value='/igate/migration/mapping/send.json' />", targetIdList, function(result)
          {
            window.vmMake.object = result.object ;
          }) ;
        }
      }
    }) ;

    window.vmImport = new Vue({
      el : '#Import',
      data : {
        pageSize : '10',
        object : {
          pk : {}
        },
        fileName : "",
        errorMessage : ""
      },
      methods : {
        selectFile : function()
        {

          window.vmImport.fileName = "" ;
          window.vmImport.errorMessage = "" ;
          window.vmImport.object = {} ;

          // remove current detail form
          data = new FormData() ;

          var formElm = $("#SearchForm") ;
          var fields = formElm.serializeArray() ;

          var param = {} ;

          $.each(fields, function(index, elm)
          {
            var jElm = $(elm) ;

            var key = jElm.attr("name") ;
            var value = jElm.attr("value") ;

            data.append(key, value) ;
            param[key] = value ;
          }) ;

          var paramElm = jQuery(document.createElement('input')) ;
          paramElm.attr("type", "file").attr("name", "body").css("display", "none").appendTo("body") ;

          paramElm.change(function()
          {
            if (!this.files || this.files.length != 1)
            {
              warnAlert("<fmt:message>common.noFileError</fmt:message>") ;
              return ;
            }

            data.append('body', this.files[0]) ;
            window.vmImport.fileName = this.files[0].name ;
          }) ;

          paramElm.trigger("click") ;

          return false ;
        },
        uploadFile : function()
        {

          if (null === data)
          {
            warnAlert("<fmt:message>igate.migration.fileSelectError</fmt:message>") ;
            return ;
          }

          $.ajax({
            url : "<c:url value='/igate/migration/mapping/import.json' />",
            data : data,
            cache : false,
            contentType : false,
            processData : false,
            method : 'POST',
            type : 'POST', // For jQuery < 1.9
            success : function(data)
            {
              if (data.object !== undefined)
              {
                window.vmImport.object = data.object ;
                window.vmImport.errorMessage = "" ;
                normalAlert("<fmt:message>head.upload</fmt:message> <fmt:message>head.success</fmt:message>") ;
              }
              else
              {
        	  	warnAlert("<fmt:message>head.upload</fmt:message> <fmt:message>head.fail</fmt:message>") ;
                window.vmImport.errorMessage = data.error[0].className + "\n" + data.error[0].message ;
              }
            }
          }) ;
        }
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>