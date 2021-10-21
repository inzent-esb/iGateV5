<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {
	var data = null ;
    var createPageObj = getCreatePageObj() ;

    createPageObj.setViewName('interface') ;
    createPageObj.setIsModal(false) ;

    createPageObj.setSearchList([{
      'type' : "modal",
      'mappingDataInfo' : {
        'url' : '/igate/adapter.html',
        'modalTitle' : '<fmt:message>igate.adapter</fmt:message>',
        'vModel' : "object.adapterId",
        'callBackFuncName' : 'setSearchAdapterId'
      },
      'name' : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
      'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    }, 
    {
        'type' : "text",
        'mappingDataInfo' : "object.interfaceId",
        'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
        'placeholder' : "<fmt:message>head.searchId</fmt:message>"
    },
    {
        'type' : "text",
        'mappingDataInfo' : "object.interfaceName",
        'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>",
        'placeholder' : "<fmt:message>head.searchName</fmt:message>"
    },{
        'type' : "select",
        'mappingDataInfo' : {
          'selectModel' : "object.interfaceType",
          'optionFor' : 'option in interfaceTypes',
          'optionValue' : 'option.pk.propertyKey',
          'optionText' : 'option.propertyValue',
          'id' : 'interfaceTypes'
        },
        'name' : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.type</fmt:message>",
        'placeholder' : "<fmt:message>head.all</fmt:message>"
    },{
      'type' : "text",
      'mappingDataInfo' : "object.interfaceGroup",
      'name' : "<fmt:message>igate.interface</fmt:message>  <fmt:message>head.group</fmt:message>",
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
      importBtn : hasInterfaceEditor,
      makeBtn : hasInterfaceEditor,
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
          detailHtml += '		       <th style="height: 32px;"><fmt:message>igate.interface</fmt:message></th>' ;
          detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.includeList</fmt:message></th>' ;
          detailHtml += '			   <th style="height: 32px;"><fmt:message>igate.migration.referList</fmt:message></th>' ;
          detailHtml += '	       </tr>' ;
          detailHtml += '	   </thead>' ;
          detailHtml += '	   <tr v-for="interface in object.interfaces" style="height: 28px;">' ;
          detailHtml += '	       <td>{{interface.interface.interfaceId}}({{interface.interface.interfaceName}})</td>' ;
          detailHtml += '        <td valign="top">' ;
          detailHtml += '            <table width="100%">' ;
          detailHtml += '                <tr>' ;
          detailHtml += '                    <td width="20%"><fmt:message>igate.interface</fmt:message></td>' ;
          detailHtml += '                    <td>' ;
          detailHtml += '                        <table width="100%">' ;
          detailHtml += '                            <tr>' ;
          detailHtml += '                                <td>{{interface.interface.interfaceId}}({{interface.interface.interfaceName}})</td>' ;
          detailHtml += '                            </tr>' ;
          detailHtml += '                        </table>' ;
          detailHtml += '                    </td>' ;
          detailHtml += '               </tr>' ;
          detailHtml += '				  <tr v-if="interface.interface.requestRecordObject">' ;
          detailHtml += '				      <td width="30%"><fmt:message>igate.record</fmt:message></td>' ;
          detailHtml += '					  <td>' ;
          detailHtml += '					      <table width="100%">' ;
          detailHtml += '						      <tr>' ;
          detailHtml += '							      <td>{{interface.interface.requestRecordObject.recordId}}({{interface.interface.requestRecordObject.recordName}})</td>' ;
          detailHtml += '						      </tr>' ;
          detailHtml += '							  <tr v-for="interfaceResponse in interface.interface.interfaceResponses">' ;
          detailHtml += '							      <td>{{interfaceResponse.recordObject.recordId}}({{interfaceResponse.recordObject.recordName}})</td>' ;
          detailHtml += '						      </tr>' ;
          detailHtml += '					     </table>' ;
          detailHtml += '					  </td>' ;
          detailHtml += '		         </tr>' ;
          detailHtml += '				 <tr v-for="interfaceService in interface.interface.interfaceServices">' ;
          detailHtml += '				     <td width="30%"><fmt:message>igate.mapping</fmt:message></td>' ;
          detailHtml += '					 <td>' ;
          detailHtml += '					     <table width="100%">' ;
          detailHtml += '						     <tr v-if="interfaceService.requestMappingObject">' ;
          detailHtml += '							     <td>{{interfaceService.requestMappingObject.mappingId}}({{interfaceService.requestMappingObject.mappingName}})</td>' ;
          detailHtml += '							 </tr>' ;
          detailHtml += '							 <tr v-if="interfaceService.responseMappingObject">' ;
          detailHtml += '							     <td>{{interfaceService.responseMappingObject.mappingId}}({{interfaceService.responseMappingObject.mappingName}})</td>' ;
          detailHtml += '						     </tr>' ;
          detailHtml += '				         </table>' ;
          detailHtml += '				     </td>' ;
          detailHtml += '			     </tr>' ;
          detailHtml += '           </table>' ;
          detailHtml += '       </td>' ;
          detailHtml += '       <td valign="top">' ;
          detailHtml += '           <table width="100%">' ;
          detailHtml += '               <tr v-if="interface.referServices.length">' ;
          detailHtml += '                   <td width="30%"><fmt:message>igate.service</fmt:message></td>' ;
          detailHtml += '                   <td>' ;
          detailHtml += '                       <table width="100%">' ;
          detailHtml += '                           <tr v-for="referService in interface.referServices">' ;
          detailHtml += '                              <td>{{referService.serviceId}}({{referService.serviceName}})</td>' ;
          detailHtml += '                           </tr>' ;
          detailHtml += '                       </table>' ;
          detailHtml += '                   </td>' ;
          detailHtml += '              </tr>' ;
          detailHtml += '          </table>' ;
          detailHtml += '      </td>' ;
          detailHtml += '    </tr>' ;
          detailHtml += '</table>' ;
          detailHtml += '</div>' ;

          if (hasInterfaceEditor)
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

    ControlImngObj.setConfig({
      controlUri : "<c:url value='/igate/migration/interface/list.json' />"
    }) ;

    PropertyImngObj.getProperties('List.Interface.InterfaceType', true, function(interfaceTypes){
	    window.vmSearch = new Vue({
	      el : '#' + createPageObj.getElementId('ImngSearchObject'),
	      data : {
	        pageSize : '10',
	        object : {
	          adapterId : null,
	          privilegeId : null,
	          interfaceId : null,
	          interfaceName : null,
	          interfaceGroup : null,
	          interfaceType : " ",
	          pk : {}
	        },    
	        interfaceTypes : []
	      },
	      created : function()
	      {
	          this.interfaceTypes = interfaceTypes ;
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
		        this.object.adapterId = null ;
		        this.object.interfaceId = null ;
		        this.object.interfaceName = null ;
		        this.object.interfaceGroup = null ;
		        this.object.privilegeId = null ;
		        this.object.interfaceType = ' ' ;	        	  
	          }	  
	
	          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize) ;
	          initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#interfaceTypes'), this.object.interfaceType) ;
	        },
	        openModal : function(openModalParam)
	        {
	          createPageObj.openModal.call(this, openModalParam) ;
	        },
	        setSearchAdapterId : function(param)
	        {
	          this.object.adapterId = param.adapterId ;
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
	    
	    window.vmList = new Vue({
	        el : '#' + createPageObj.getElementId('ImngListObject'),
	        data : {
	          makeGridObj : null,
	          newTabPageUrl: "<c:url value='/igate/migration/interface.html' />"
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
	              targetIdList[idx] = item.interfaceId ;
	              makeData = makeData + "targetIds=" + item.interfaceId + "&" ;
	            }) ;

	            if (targetIdList.length == 0)
	            {
	              warnAlert({message : "<fmt:message>igate.migration.selectError</fmt:message>"}) ;
	            }
	            else
	            {
	              MigrationImngObj.makeSubmit("<c:url value='/igate/migration/interface/make.json' />", targetIdList, "<fmt:message>igate.migration.make</fmt:message>",  function(result)
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
	            searchUri : "<c:url value='/igate/migration/interface/list.json' />",
	            viewMode : "${viewMode}",
	            popupResponse : "${popupResponse}",
	            popupResponsePosition : "${popupResponsePosition}",
	            rowHeaders : ['checkbox', 'rowNum'],
	            columns : [{
	              name : "interfaceId",
	              header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.id</fmt:message>",
	              align : "left",
	              width: "15%",
	            }, {
	              name : "interfaceName",
	              header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.name</fmt:message>",
	              align : "left",
	              width: "20%",
	            }, {
	              name : "interfaceDesc",
	              header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.description</fmt:message>",
	              align : "left",
	              width: "20%",
	            }, {
	              name : "interfaceType",
	              header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.type</fmt:message>",
	              align : "center",
	              width: "15%",
	              formatter : function(value){
	        	  	switch (value.row.interfaceType) {
	     				case 'Online' : {
	       				return "<fmt:message>head.online</fmt:message>" ;
	     				}
		     			case 'File' : {
		       			return "<fmt:message>head.file</fmt:message>" ;
	     				}
		     		  }
	        	  	}
	            }, {
	              name : "interfaceGroup",
	              header : "<fmt:message>igate.interface</fmt:message> <fmt:message>head.group</fmt:message>",
	              align : "left",
	              width: "15%",
	            }, {
	              name : "privilegeId",
	              header : "<fmt:message>common.privilege</fmt:message> <fmt:message>head.id</fmt:message>",
	              align : "left",
	              width: "15%",
	            }, {
	              name : "adapterId",
	              header : "<fmt:message>igate.adapter</fmt:message> <fmt:message>head.id</fmt:message>",
	              align : "left",
	              width: "15%",
	            }]
	          }) ;

	          SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid() ;
	          
	          this.newTabSearchGrid();
	        }
	      }) ;	    
    });

    window.vmMake = new Vue({
      el : '#Make',
      data : {
        pageSize : '10',
        object : {
          pk : {}
        },
        data : null
      },
      methods : {
        downloadFile : function()
        {
          var myForm = document.popForm ;
          var url = "<c:url value='/igate/migration/interface/down.json?' />" + makeData ;
          var popup = window.open("", "hiddenframe", "toolbar=no, width=0, height=0, directories=no, status=no, scrollorbars=no, resizable=no") ;
          myForm.action = url ;
          myForm.method = "post" ;
          myForm.target = "hiddenframe" ;
          myForm.submit()
        },
        migration : function()
        {
          MigrationImngObj.makeSubmit("<c:url value='/igate/migration/interface/send.json' />", targetIdList, "<fmt:message>igate.migration.migration</fmt:message>", function(result)
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
		  var fileEle = $("<input/>").attr({'type': 'file'});
		  
		  fileEle.on('change', function(evt) 
		  {
		    data = new FormData() ;
		    data.append('body', this.files[0]) ;
		    window.vmImport.fileName = this.files[0].name ;
		  }) ;
		  
		  fileEle.trigger('click');
        },
        uploadFile : function()
        {

          if (null == data)
          {
            warnAlert({message : "<fmt:message>igate.migration.fileSelectError</fmt:message>"}) ;
            return ;
          }
          
          startSpinner();

          $.ajax({
            url : "<c:url value='/igate/migration/interface/import.json' />",
            data : data,
            cache : false,
            contentType : false,
            processData : false,
            method : 'POST',
            type : 'POST', // For jQuery < 1.9
            success : function(data)
            {
              
              stopSpinner();	
            	
              if (data.object !== undefined)
              {
                window.vmImport.object = data.object ;
                window.vmImport.errorMessage = "" ;
                normalAlert({message : "<fmt:message>head.upload</fmt:message> <fmt:message>head.success</fmt:message>"});
              }
              else
              {
                warnAlert({message : "<fmt:message>head.upload</fmt:message> <fmt:message>head.fail</fmt:message>"}) ;
        	  	window.vmImport.errorMessage = data.error[0].className + ((data.error[0].message)? "\n" + data.error[0].message  : "");
              }
            }
          }) ;
        }
      }
    }) ;

    window.vmCount = new Vue({
      el : '#ImngCount',
      data : {
        columnCount : '0'
      }
    }) ;

    new Vue({
      el : '#panel-footer',
      methods : $.extend(true, {}, panelMethodOption)
    }) ;
  }) ;
</script>