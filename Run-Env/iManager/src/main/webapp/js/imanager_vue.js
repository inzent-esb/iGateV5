var ResultImngObj =
{
  errorHandler : function(request, status, error)
  {
    stopSpinner() ;

    console.log("ajaxError : \n" + error) ;

    warnAlert({message : error}) ;
  },

  resultErrorHandler : function(result)
  {
    stopSpinner() ;

    $('#accordionResult').children('.collapse-item').remove() ;

    result.error.forEach(function(item, index)
    {
      var object = $('.collapse-item-origin').clone() ;
      object.attr('class', 'collapse-item') ;

      var field = '' ;

      if (item.field)
        field = "Field(" + item.field + ") : " ;

      object.children('button').children('i.iconb-compt.mr-2').removeClass().addClass('iconb-danger mr-2');
      object.children('button').children('span').text(field + item.message) ;

      if (item.stackTrace)
      {
        object.children('button').attr('data-target', '#collapseResult' + index) ;
        object.children('div').attr('id', 'collapseResult' + index).children('.collapse-content').append($('<pre/>').text(item.stackTrace)) ;
      }
      else
      {
        object.children('.collapse').remove() ;
      }

      $('#accordionResult').append(object) ;
    }) ;

    $('#item-result').trigger('click') ;
    $('.collapse-item').show() ;
    $('#accordionResult').show() ;
  },

  resultResponseHandler : function(result)
  {
    $('#accordionResult').children('.collapse-item').remove() ;

    if (!result.response)
    {
      var object = $('.collapse-item-origin').clone() ;

      object.attr('class', 'collapse-item') ;
      object.children('button').children('span').text("Successfully done.") ;

      $('#accordionResult').append(object) ;
    }
    else
    {
      result.response.forEach(function(item, index)
      {
        var object = $('.collapse-item-origin').clone() ;
        object.attr('class', 'collapse-item') ;

        if (item.success)
        {
          object.children('button').children('span').text(item.instanceId + " was succeed.") ;
        }
        else
        {
          object.children('button').children('i.iconb-compt.mr-2').removeClass().addClass('iconb-danger mr-2');
          object.children('button').children('span').text(item.instanceId + " was failed.") ;
        }

        if (item.response)
        {
          object.children('button').attr('data-target', '#collapseResult' + index) ;
          object.children('div').attr('id', 'collapseResult' + index).children('.collapse-content').append($('<pre/>').text(item.response)) ;
        }
        else
        {
          object.children('.collapse').remove() ;
        }

        $('#accordionResult').append(object) ;
      }) ;
    }

    $('#item-result').trigger('click') ;
    $('.collapse-item').show() ;
    $('#accordionResult').show() ;
  },

  resultClearHandler : function()
  {
    $('#accordionResult').children('.collapse-item').remove() ;
  }

} ;

var StatusImngObj =
{
  updateReady : function(url, data, gridIndex, columnString, callback)
  {
    $.ajaxSettings.traditional = true ;

    $.ajax(
    {
      type : "POST",
      url : url,
      processData : true,
      data : data,
      dataType : "json",
      success : function(result)
      {
        if (result.response == "OK")
          SearchImngObj.searchGrid.setValue(gridIndex, columnString, 'R') ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
    if (callback)
      callback() ;
  },
  updateCancel : function(url, data, gridIndex, columnString, callback)
  {
    $.ajaxSettings.traditional = true ;

    $.ajax(
    {
      type : "POST",
      url : url,
      processData : true,
      data : data,
      dataType : "json",
      success : function(result)
      {
        if (result.response == "OK")
          SearchImngObj.searchGrid.setValue(gridIndex, columnString, 'C') ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
    if (callback)
      callback() ;
  }
} ;
var ReorderImngObj =
{
  reorder : function(url, callback)
  {
    $.ajax(
    {
      type : "GET",
      url : url,
      processData : true,
      data : null,
      dataType : "json",
      success : function(result)
      {
        if (result.response == "OK")
        {
          window.vmSearch.search() ;
        }
        if (callback)
          callback(result) ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
    if (callback)
      callback() ;
  }
} ;

var SearchImngObj =
{

  searchGrid : null,
  searchUri : null,
  viewMode : null,
  popupResponse : null,
  popupResponsePosition : null,
  searchGridEL : null,

  initSearchImngObj : function()
  {
    SearchImngObj.searchGrid = null ;
    SearchImngObj.searchUri = null ;
    SearchImngObj.viewMode = null ;
    SearchImngObj.popupResponse = null ;
    SearchImngObj.popupResponsePosition = null ;
    SearchImngObj.searchGridEL = null ;
  },

  clicked : function(loadParam)
  {

    if (!loadParam)
      return ;

    if ('Popup' == SearchImngObj.viewMode)
    {
      if (loadParam._checked === null)
      {
        if (-1 != SearchImngObj.searchGrid.getCheckedRowKeys().indexOf(loadParam.rowKey))
        {
          SearchImngObj.searchGrid.uncheck(loadParam.rowKey) ;
          SearchImngObj.searchGrid.removeRowClassName(loadParam.rowKey, "row-selected") ;
        }
        else
        {
          SearchImngObj.searchGrid.check(loadParam.rowKey) ;
          SearchImngObj.searchGrid.addRowClassName(loadParam.rowKey, "row-selected") ;
        }
      }
      else
      {
        parent[SearchImngObj.popupResponse](SearchImngObj.popupResponsePosition, loadParam) ;
        parent.DialogImngObj.modalClose() ;
      }
    }
    else
    {
      if (window.vmMain !== undefined)
      {
        loadParam.viewMode = window.vmMain.viewMode ;
        SearchImngObj.load($.param(loadParam)) ;
      }

      if (loadParam._checked === null)
      {
        if (-1 != SearchImngObj.searchGrid.getCheckedRowKeys().indexOf(loadParam.rowKey))
        {
          SearchImngObj.searchGrid.uncheck(loadParam.rowKey) ;
          SearchImngObj.searchGrid.removeRowClassName(loadParam.rowKey, "row-selected") ;
        }
        else
        {
          SearchImngObj.searchGrid.check(loadParam.rowKey) ;
          SearchImngObj.searchGrid.addRowClassName(loadParam.rowKey, "row-selected") ;
        }
      }
    }
  },

  load : function(data)
  {

    startSpinner() ;

    $.ajax(
    {
      type : "GET",
      url : SaveImngObj.objectUri,
      processData : false,
      data : data,
      dataType : "json",
      success : function(result)
      {

        if ("ok" == result.result)
        {

          var vmMain = window.vmMain ;
          vmMain.viewMode = result.viewMode ;
          vmMain.object = result.object ;

          for ( var key in result.object)
          {

            var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
            var value = result.object[key] ;

            if (value instanceof Array && window.hasOwnProperty(name))
            {
              var vmSub = window[name] ;
              vmSub.viewMode = result.viewMode ;
              vmSub[key] = value ;
            }
          }

          // 파일 송수신내역
          if (vmMain.object.pk !== undefined && vmMain.object.pk.fileMode !== undefined)
          {
            if (vmMain.object.pk.fileMode === "R")
            {
              vmMain.object.pk.fileMode = "Recv" ;
            }
            else
            {
              vmMain.object.pk.fileMode = "Send" ;
            }

            if (vmMain.object.fileStatus === "R")
            {
              vmMain.object.fileStatus = "Ready" ;
            }
            else if (vmMain.object.fileStatus === "W")
            {
              vmMain.object.fileStatus = "Wait" ;
            }
            else if (vmMain.object.fileStatus === "M")
            {
              vmMain.object.fileStatus = "Making" ;
            }
            else if (vmMain.object.fileStatus === "A")
            {
              vmMain.object.fileStatus = "Active" ;
            }
            else if (vmMain.object.fileStatus === "E")
            {
              vmMain.object.fileStatus = "Error" ;
            }
            else if (vmMain.object.fileStatus === "D")
            {
              vmMain.object.fileStatus = "Done" ;
            }
            else if (vmMain.object.fileStatus === "P")
            {
              vmMain.object.fileStatus = "Process" ;
            }
            else if (vmMain.object.fileStatus === "X")
            {
              vmMain.object.fileStatus = "Expire" ;
            }
            else if (vmMain.object.fileStatus === "C")
            {
              vmMain.object.fileStatus = "Cancel" ;
            }
            else if (vmMain.object.fileStatus === "H")
            {
              vmMain.object.fileStatus = "Finish" ;
            }
            else if (vmMain.object.fileStatus === "F")
            {
              vmMain.object.fileStatus = "Fail" ;
            }
          }

          // Time Picker
          if (vmMain.object.pk !== undefined && vmMain.object.pk.startTime !== undefined)
          {
            if (vmMain.object.pk.startTime.length == 6)
            {
              vmMain.object.pk.startTime = vmMain.object.pk.startTime.replace(/(.{2})/g, "$1:") ;
              vmMain.object.pk.startTime = vmMain.object.pk.startTime.slice(0, -1) ;
              vmMain.object.endTime = vmMain.object.endTime.replace(/(.{2})/g, "$1:") ;
              vmMain.object.endTime = vmMain.object.endTime.slice(0, -1) ;
            }
            else
            {
              var startDate = vmMain.object.pk.startTime.substring(0, 8) ;
              var startTime = vmMain.object.pk.startTime.substring(8) ;

              startDate = startDate.replace(/(.{4})/g, "$1-") ;
              startDate = startDate.replace(/(.{7})/g, "$1-") ;
              startDate = startDate.slice(0, -1) ;
              startTime = startTime.replace(/(.{2})/g, "$1:") ;
              startTime = startTime.slice(0, -1) ;

              var endDate = vmMain.object.endTime.substring(0, 8) ;
              var endTime = vmMain.object.endTime.substring(8) ;

              endDate = endDate.replace(/(.{4})/g, "$1-") ;
              endDate = endDate.replace(/(.{7})/g, "$1-") ;
              endDate = endDate.slice(0, -1) ;
              endTime = endTime.replace(/(.{2})/g, "$1:") ;
              endTime = endTime.slice(0, -1) ;

              vmMain.object.pk.startTime = startDate.concat(" " + startTime) ;
              vmMain.object.endTime = endDate.concat(" " + endTime) ;
            }
          }

          if (vmMain.loaded)
            vmMain.loaded() ;

          if (vmMain.goDetailPanel)
            vmMain.goDetailPanel() ;

          stopSpinner() ;

        }
        else
        {
          ResultImngObj.resultErrorHandler(result) ;
        }
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
  }
} ;

var SaveImngObj =
{
  objectUri : null,

  setConfig : function(instanceSettings)
  {
    SaveImngObj.objectUri = instanceSettings.objectUri ;
  },

  submit : function(uri, data, message, callback, modalMode)
  {
    startSpinner() ;

    $.ajax(
    {
      type : "POST",
      url : uri,
      processData : false,
      data : data,
      dataType : "json",
      success : function(result)
      {
        if ("ok" == result.result)
        {

          ResultImngObj.resultResponseHandler(result) ;

          if (SearchImngObj.searchGrid)
            window.vmSearch.search() ;

		  normalAlert({message : message, isSpinnerMode : modalMode });

          stopSpinner() ;

          panelOpen('done') ;
        }
        else
          ResultImngObj.resultErrorHandler(result) ;

        if (callback)
          callback(result) ;

      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
  },

  insertSubmit : function(data, message)
  {
    data._method = "PUT" ;
    SaveImngObj.submit(SaveImngObj.objectUri, JsonImngObj.serialize(data), message) ;
  },

  updateSubmit : function(data, message)
  {
    data._method = "POST" ;
    SaveImngObj.submit(SaveImngObj.objectUri, JsonImngObj.serialize(data), message) ;
  },

  deleteSubmit : function(data, message)
  {
    data._method = "DELETE" ;
    SaveImngObj.submit(SaveImngObj.objectUri, JsonImngObj.serialize(data), message, function(result)
    {
      if ("ok" == result.result)
        panelClose('panel') ;
    }) ;
  },

  insert : function(message)
  {
    var vmMain = window.vmMain ;
    var object = vmMain.object ;

    for ( var key in object)
    {
      var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
      if (window.hasOwnProperty(name))
        object[key] = window[name][key] ;
    }

    if (vmMain.saving)
      vmMain.saving() ;

    this.insertSubmit(object, message) ;
  },

  update : function(message)
  {
    var vmMain = window.vmMain ;
    var object = vmMain.object ;
    for ( var key in object)
    {
      var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
      if (window.hasOwnProperty(name))
        object[key] = window[name][key] ;
    }

    if (vmMain.saving)
      vmMain.saving() ;

    this.updateSubmit(object, message) ;
  },

  remove : function(confirm, message)
  {

	  normalConfirm({message : confirm, callBackFunc : function()
    {

      var vmMain = window.vmMain ;
      var object = vmMain.object ;

      for ( var key in object)
      {
        var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
        if (window.hasOwnProperty(name))
          object[key] = window[name][key] ;
      }

      if (vmMain.saving)
        vmMain.saving() ;

      this.deleteSubmit(object, message) ;
    }.bind(this)}) ;
  }

} ;

var ControlImngObj =
{
  controlUri : null,

  setConfig : function(instanceSettings)
  {
    ControlImngObj.controlUri = instanceSettings.controlUri ;
  },

  control : function(command, instance, data)
  {
    var param =
    {
      command : command
    } ;

    if (instance)
      param['instance'] = instance ;

    startSpinner() ;

    $.ajax(
    {
      type : "POST",
      url : ControlImngObj.controlUri + "?" + $.param(param),
      processData : false,
      data : data,
      dataType : "json",
      success : function(result)
      {
        if ("ok" == result.result)
        {
          ResultImngObj.resultResponseHandler(result) ;

          stopSpinner() ;
        }
        else
          ResultImngObj.resultErrorHandler(result) ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
  },

  rowControl : function(command, instance, data, gridIndex)
  {
    startSpinner() ;

    $.ajax(
    {
      type : "POST",
      url : ControlImngObj.controlUri + "?" + $.param(
      {
        command : command,
        instance : instance
      }),
      processData : false,
      data : data,
      dataType : "json",
      success : function(result)
      {
        if ("ok" == result.result)
        {
          if (result.response)// 응답이 온 경우, (성공 && 실패)
          {
            var snapshotStatus = result.object.status ;

            if (result.response[0].success)
            {
              SearchImngObj.searchGrid.setValue(gridIndex, "processResult", command + " was successed") ;
              SearchImngObj.searchGrid.setValue(gridIndex, "status", snapshotStatus) ;
            }
            else
              SearchImngObj.searchGrid.setValue(gridIndex, "processResult", result.response[0].response) ;
          }
        }
        else
          // 응답이 오지 않은 경우
          SearchImngObj.searchGrid.setValue(gridIndex, "processResult", command + " was failed") ;

        stopSpinner() ;
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
      }
    }) ;
  },

  dump : function()
  {
    this.control("dump", null, JsonImngObj.serialize(window.vmMain.pk)) ;
  },

  load : function()
  {
    this.control("load", null, JsonImngObj.serialize(window.vmMain.pk)) ;
  }
} ;

var MigrationImngObj =
{
  makeSubmit : function(url, data, message, callback, modalMode)
  {
    var param =
    {
      targetIds : data
    } ;

    $.ajaxSettings.traditional = true ;
    
    startSpinner() ;

    $.ajax(
    {
      type : "POST",
      url : url,
      processData : true,
      data : param,
      dataType : "json",
      success : function(result)
      {
        if ("ok" == result.result)
        {
          ResultImngObj.resultResponseHandler(result) ;
          normalAlert({message : message, isSpinnerMode : modalMode});
          callback(result) ;
          $("#Make-tab").tab("show") ;
        }
        else {
        	ResultImngObj.resultErrorHandler(result);
        	warnAlert({message : (escapeHtml(result.error[0].className) + ((result.error[0].message)? "<hr/>" + escapeHtml(result.error[0].message)  : "")), isSpinnerMode : modalMode, isXSSMode : false});
        }
        
        stopSpinner();
          
      },
      error : function(request, status, error)
      {
        ResultImngObj.errorHandler(request, status, error) ;
        stopSpinner();
      }
    }) ;
  }
} ;

var JsonImngObj =
{
  planarize : function(object)
  {
    if (object instanceof Array)
    {
      var result = [] ;

      for (var j = 0, l = object.length ; j < l ; j++)
        result.push(this.planarize_sub(null, object[j],
        {})) ;

      return result ;
    }
    else
      return this.planarize_sub(null, object,
      {}) ;
  },

  planarize_sub : function(name, orgObject, newObject)
  {
    if (orgObject instanceof Array)
      return newObject ;

    var subname, value ;
    for ( var key in orgObject)
    {
      value = orgObject[key] ;

      if (name)
        subname = name + "." + key ;
      else
        subname = key ;

      if (typeof value == "object")
        this.planarize_sub(subname, value, newObject) ;
      else
        newObject[subname] = value ;
    }

    return newObject ;
  },

  serialize : function(object)
  {
    var array = this.serialize_sub(null, object, []) ;
    return array.join("&") ;
  },

  serialize_sub : function(name, orgObject, newObject)
  {
    for ( var key in orgObject)
    {
      var value = orgObject[key] ;
      var subname = name ? name + "." + key : key ;

      if (value instanceof Array)
        value.forEach(function(item, idx)
        {
          JsonImngObj.serialize_sub(subname + "[" + idx + "]", item, newObject) ;
        }) ;
      else
      {
        var vType = typeof value
        if (value == null || vType == 'undefined')
          continue ;
        else if (vType == "object")
          this.serialize_sub(subname, value, newObject) ;
        else
          newObject.push(encodeURIComponent(subname) + "=" + encodeURIComponent(value)) ;
      }
    }

    return newObject ;
  }
} ;

var PropertyImngObj =
{
  contextRoot : null,

  setConfig : function(settings)
  {
    this.contextRoot = settings.contextRoot ;
  },

  getProperty : function(propertyId, propertyKey, callback)
  {
    $.get(PropertyImngObj.contextRoot + "/common/property/object.json",
    {
      "pk.propertyId" : propertyId,
      "pk.propertyKey" : propertyKey
    }).done(function(result)
    {
      callback(result.object) ;
    }) ;
  },

  getProperties : function(propertyName, orderByKey, callback)
  {
    $.get(PropertyImngObj.contextRoot + "/common/property/properties.json",
    {
      "propertyId" : propertyName,
      "orderByKey" : orderByKey
    }).done(function(result)
    {
      callback(result.object) ;
    }) ;
  }
} ;

function getMakeGridObj()
{

  var elementId = null ;
  var searchUri = null ;
  var searchGrid = null ;
  var isModal = null ;
  var windowName = null ;

  function makeGridObj()
  {

    this.getSearchGrid = function()
    {
      return searchGrid ;
    } ;

    this.setConfig = function(instanceSettings)
    {

      elementId = instanceSettings.elementId ;
      searchUri = instanceSettings.searchUri ;
      isModal = instanceSettings.isModal ;

      tui.Grid.applyTheme('clean', {
    	  row: {
    		  hover: {
    			  background: '#f5f6fb'
    		  }
    	  }
      }) ;

      tui.Grid.setLanguage('en',
      {
        display :
        {
          noData : 'No Data.',
        },
      }) ;

      var settings =
      {
        el : document.getElementById(elementId),
        columnOptions :
        {
          resizable : true
        },
        usageStatistics : false,
        rowHeaders : instanceSettings.rowHeaders,
        header :
        {
          height : 32,
          align : 'center'
        },
        onGridMounted: function() {
        	if(instanceSettings.onGridMounted) {
        		instanceSettings.onGridMounted();
        	}
        	
        	$('#' + elementId).find('.tui-grid-column-resize-handle').removeAttr('title');
        },
        onGridUpdated: function() {
        	if(instanceSettings.onGridUpdated) {
        		instanceSettings.onGridUpdated();
        	}
        	
        	var resetColumnWidths = [];

        	searchGrid.getColumns().forEach(function(columnInfo) {
        		if(!columnInfo.copyOptions) return;

        		if(columnInfo.copyOptions.widthRatio) {
        			resetColumnWidths.push($("#" + elementId).width() * (columnInfo.copyOptions.widthRatio / 100));
        		}
        	});
        	
        	if(0 < resetColumnWidths.length)
        		searchGrid.resetColumnWidths(resetColumnWidths);
        },
        scrollX : false,
        scrollY : true
      } ;

      $.extend(settings, instanceSettings) ;

      settings.columns.forEach(function(column){
    	  if(!column.formatter) {
    		  column.escapeHTML = true;  
    	  }

    	  if(column.width && -1 < String(column.width).indexOf('%')) {
    		  if(!column.copyOptions)
    			  column.copyOptions = {};
    		  
    		  column.copyOptions.widthRatio = column.width.replace('%', '');
    		  
    		  delete column.width;
    	  }
      });
      
      searchGrid = new tui.Grid(settings) ;

      searchGrid.on('mouseover', function(ev) {
    	  
    	  if('cell' != ev.targetType) return;
    	  
    	  var overCellElement = $(searchGrid.getElement(ev.rowKey, ev.columnName));    	  
    	  overCellElement.attr('title', overCellElement.text());
      });

      if ('undefined' != typeof (settings.onClick))
      {

        if (instanceSettings.rowHeaders && -1 < instanceSettings.rowHeaders.indexOf('checkbox'))
        {

          searchGrid.on('click', function(ev)
          {
            if ("rowHeader" == ev.targetType)
            {
              setTimeout(function()
              {
                if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey))
                {
                  searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
                }
                else
                {
                  searchGrid.removeRowClassName(ev.rowKey, "row-selected") ;
                }
              }, 0) ;
            }
            else
            {
              settings.onClick(searchGrid.getRow(ev.rowKey), ev) ;
            }
          }) ;

          searchGrid.on('checkAll', function(ev)
          {

            if (!searchGrid.store.data.rawData)
              return ;

            if (0 == searchGrid.store.data.rawData.length)
              return ;

            searchGrid.store.data.rawData.forEach(function(data)
            {
              searchGrid.addRowClassName(data.rowKey, "row-selected") ;
            }) ;
          }) ;

          searchGrid.on('uncheckAll', function(ev)
          {

            if (!searchGrid.store.data.rawData)
              return ;

            if (0 == searchGrid.store.data.rawData.length)
              return ;

            searchGrid.store.data.rawData.forEach(function(data)
            {
              searchGrid.removeRowClassName(data.rowKey, "row-selected") ;
            }) ;
          }) ;

        }
        else
        {
          searchGrid.on('click', function(ev)
          {
            if (ev.rowKey != null)
            {
              searchGrid.store.data.rawData.forEach(function(data)
              {
                searchGrid.removeRowClassName(data.rowKey, "row-selected") ;
              }) ;        

              searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
              
              settings.onClick(searchGrid.getRow(ev.rowKey), ev) ;
            }
          }) ;
        }

      }
      else
      {
        if (instanceSettings.rowHeaders && -1 < instanceSettings.rowHeaders.indexOf('checkbox'))
        {
          searchGrid.on('click', function(ev)
          {
            if ("rowHeader" == ev.targetType)
            {
              setTimeout(function()
              {
                if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey))
                {
                  searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
                }
                else
                {
                  searchGrid.removeRowClassName(ev.rowKey, "row-selected") ;
                }
              }, 0) ;
            }
            else
            {
              if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey))
              {
                searchGrid.uncheck(ev.rowKey) ;
                searchGrid.removeRowClassName(ev.rowKey, "row-selected") ;
              }
              else
              {
                searchGrid.check(ev.rowKey) ;
                searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
              }
            }
          }) ;

          searchGrid.on('checkAll', function(ev)
          {

            if (!searchGrid.store.data.rawData)
              return ;

            if (0 == searchGrid.store.data.rawData.length)
              return ;

            searchGrid.store.data.rawData.forEach(function(data)
            {
              searchGrid.addRowClassName(data.rowKey, "row-selected") ;
            }) ;
          }) ;

          searchGrid.on('uncheckAll', function(ev)
          {

            if (!searchGrid.store.data.rawData)
              return ;

            if (0 == searchGrid.store.data.rawData.length)
              return ;

            searchGrid.store.data.rawData.forEach(function(data)
            {
              searchGrid.removeRowClassName(data.rowKey, "row-selected") ;
            }) ;
          }) ;
        }
        else 
        {
          searchGrid.on('click', function(ev)
          {
            if (ev.rowKey != null)
            {
              searchGrid.store.data.rawData.forEach(function(data)
              {
                searchGrid.removeRowClassName(data.rowKey, "row-selected") ;
              }) ;        

              searchGrid.addRowClassName(ev.rowKey, "row-selected") ;
            }
          }) ;        	
        }
      }

      if ('undefined' != typeof (settings.onDblClick))
      {
        searchGrid.on('dblclick', function(ev)
        {
          settings.onDblClick(searchGrid.getRow(ev.rowKey), ev) ;
        }) ;
      }

      if (isModal)
      {
        windowName = function()
        {

          var S4 = function()
          {
            return (Math.floor(mathRandom() * 0x10000).toString(16)) ;
          }

          return "GUID-" + (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4()) ;
        }() ;
      }
    }
    
    this.noDataHidePage = function(listAreaId){
    	if('none' == $('#' + listAreaId).children('.empty').css('display')) return;
    	
		$('#' + listAreaId).children('.empty').hide();					
		$('#' + listAreaId).children('.table-responsive').show();		
		$('#' + listAreaId).find("[showLater='true']").show();
    };
    
    this.search = function(vueSearchObj, callback)
    {
      submit(JsonImngObj.serialize($.extend(
      {
        _pageSize : vueSearchObj.pageSize
      }, vueSearchObj.object)), function(result)
      {

        if (isModal)
          setTimeout(function()
          {
            searchGrid.refreshLayout() ;
            resizeSearchGridPagination(elementId) ;
          }, 0)
        else
          resizeSearchGrid() ;

        if (callback)
        {
          callback(result) ;
        }
      }) ;
    } ;

    function submit(param, callback)
    {

      startSpinner() ;

      var ajaxOption =
      {
        type : "GET",
        url : searchUri,
        processData : false,
        data : param,
        dataType : "json",
        success : function(result)
        {

          setGridPaging(result) ;

          if (callback)
          {
            callback(result) ;
          }
          stopSpinner() ;
        },
        error : function(request, status, error)
        {
          stopSpinner() ;
        }
      } ;

      if (isModal)
      {
        ajaxOption.beforeSend = function(xhr)
        {

          var token = $("meta[name='_csrf']").attr("content") ;
          var header = $("meta[name='_csrf_header']").attr("content") ;

          if (header)
            xhr.setRequestHeader(header, token) ;

          xhr.setRequestHeader("X-IMANAGER-WINDOW", windowName) ;
        } ;
      }

      $.ajax(ajaxOption) ;
    }

    function page(param, callback)
    {

      startSpinner() ;

      submit(param, callback) ;
    }

    function setGridPaging(result)
    {
      if ("ok" != result.result)
        return ;

      if ('undefined' != typeof (result.object.page))
      {
        searchGrid.resetData(JsonImngObj.planarize(result.object.page)) ;
      }
      else if ('undefined' != typeof (result.object))
      { 
    	searchGrid.resetData(JsonImngObj.planarize(result.object)) ; 
      }      
      else
      {
        searchGrid.resetData([]) ;
      }

      $("#" + elementId).find('.ImngSearchGridPagination').remove() ;
      $("#" + elementId).append($("<ul/>").addClass('ImngSearchGridPagination pagination')) ;

      if ('undefined' != typeof (result.object.prev))
      {

        var prevLi = $("<li/>").addClass('page-item') ;

        prevLi.append($("<a/>").addClass('page-link page-link-prev').attr(
        {
          'href' : 'javascript:void(0);',
          'name' : 'prev'
        }).data('page_param', '_pageNo=' + result.object.prev.pageNo + '&' + result.object.prev.keyURI).append($("<i/>").addClass('icon-left'))) ;

        $("#" + elementId).find('.ImngSearchGridPagination').append(prevLi) ;
      }

      if ('undefined' != typeof (result.object.pages))
      {
        for (var i = 0 ; i < result.object.pages.length ; i++)
        {

          var pageItemLi = $("<li/>").addClass('page-item') ;

          if (result.object.pages[i].current)
          {
            pageItemLi.append($("<a/>").addClass('page-link active').attr(
            {
              'href' : 'javascript:void(0);'
            }).text(result.object.pages[i].pageNo)) ;
          }
          else
          {
            pageItemLi.append($("<a/>").addClass('page-link').attr(
            {
              'href' : 'javascript:void(0);',
              'name' : 'pageNum'
            }).data('page_param', '_pageNo=' + result.object.pages[i].pageNo + '&' + result.object.pages[i].keyURI).text(result.object.pages[i].pageNo)) ;
          }

          $("#" + elementId).find('.ImngSearchGridPagination').append(pageItemLi) ;
        }
      }

      if ('undefined' != typeof (result.object.next))
      {

        var nextLi = $("<li/>").addClass('page-item') ;

        nextLi.append($("<a/>").addClass('page-link page-link-next').attr(
        {
          'href' : 'javascript:void(0);',
          'name' : 'next'
        }).data('page_param', '_pageNo=' + result.object.next.pageNo + '&' + result.object.next.keyURI).append($("<i/>").addClass('icon-right'))) ;

        $("#" + elementId).find('.ImngSearchGridPagination').append(nextLi) ;
      }

      resizeSearchGridPagination(elementId) ;
      
      $("#" + elementId).find('.ImngSearchGridPagination').find('[name=pageNum], [name=prev], [name=next]').on('click', function()
      {
        page($(this).data('page_param'), function() {
          if(isModal)
          {
            setTimeout(function()
            {
              searchGrid.refreshLayout() ;
              resizeSearchGridPagination(elementId) ;
            }, 0)        	  
          }
          else
          {
            resizeSearchGrid() ;
          }
        }) ;
      }) ;
      
      $('#' + elementId).find('.tui-pagination').off('click').on('click', resizeSearchGrid);
    }
  }

  return new makeGridObj() ;
}