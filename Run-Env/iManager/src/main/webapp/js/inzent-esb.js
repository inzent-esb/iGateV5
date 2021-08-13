function getCreatePageObj()
{

  var viewName = null ;

  var searchList = null ;

  var mainButtonList = null ;

  var tabList = null ;
  var panelButtonList = null ;

  var isModal = false ;

  var idDelimiter = '-' ;

  function createPageObj()
  {

    this.setViewName = function(pViewName)
    {

      $('#ImngListObject').attr('id', 'ImngListObject' + idDelimiter + pViewName) ;
      $('#ImngSearchGrid').attr('id', 'ImngSearchGrid' + idDelimiter + pViewName) ;
      $('#ImngSearchObject').attr('id', 'ImngSearchObject' + idDelimiter + pViewName) ;

      viewName = pViewName ;
    },

    this.setSearchList = function(pSearchList)
    {

      if (!isModal)
        SearchImngObj.initSearchImngObj() ;

      searchList = pSearchList ;
    } ;

    this.setMainButtonList = function(pMainButtonList)
    {
      mainButtonList = pMainButtonList ;
    } ;

    this.setTabList = function(pTabList)
    {
      tabList = pTabList ;
    } ;

    this.setPanelButtonList = function(pPanelButtonList)
    {
      panelButtonList = pPanelButtonList ;
    } ;

    this.setIsModal = function(pIsModal)
    {
      isModal = pIsModal ;

      if (!isModal)
      {
        window.mainListAreaId = 'ImngListObject' + idDelimiter + viewName ;
        window.mainSearchAreaId = 'ImngSearchObject' + idDelimiter + viewName ;
        window.mainSearchGridId = 'ImngSearchGrid' + idDelimiter + viewName ;
      }
    }

    this.getElementId = function(id)
    {
      return id + idDelimiter + viewName ;
    }

    this.searchConstructor = function(isHidePageSize, callBackFunc)
    {

      var beforeSelector = $('#' + this.getElementId('ImngSearchObject')).find('#list-select') ;

      searchList.forEach(function(searchInfo, index)
      {
        var type = searchInfo.type ;
        var mappingDataInfo = searchInfo.mappingDataInfo ;
        var name = searchInfo.name ;
        var placeholder = searchInfo.placeholder ;

        if (type === 'text')
        {
        	beforeSelector.before(
            	$('<div/>').addClass('col').append(
            			$('<label/>').addClass('form-control-label reset')
            						 .append(
            								 $('<b/>').addClass('control-label').text(name)
            						 )
            						 .append(
            								 $('<input/>').addClass('form-control').attr({'id': searchInfo.id, 'v-model' : mappingDataInfo, 'placeholder' : placeholder, 'v-on:keyup.enter' : 'search'})
            						 )
  					 			  	 .append(
  					 			  			 $('<i/>').addClass('icon-close').attr({'v-on:click.prevent': mappingDataInfo + ' = null' })
  					 			  	 )                						 
            	)        			
        	);
        }
        else if (type === 'select')
        {
          var selectDiv = $('<select/>').addClass('form-control selectpicker').attr({'v-model' : mappingDataInfo.selectModel, 'id' : mappingDataInfo.id, 'data-size' : '10'}) ;
          
          if (searchInfo.changeEvt)
        	  selectDiv.attr({'v-on:change': searchInfo.changeEvt}) ;
          
          if (!searchInfo.isHideAllOption)
        	  selectDiv.append($('<option/>').attr({'selected' : 'selected', 'value' : ' '}).text(placeholder)) ;
          
          var appendOption = $('<option/>').attr({'v-for' : mappingDataInfo.optionFor, 'v-bind:value' : mappingDataInfo.optionValue, 'v-text' : mappingDataInfo.optionText}) ;
          
          if(mappingDataInfo.optionIf)
        	  appendOption.attr({'v-if': mappingDataInfo.optionIf}) ;
          
          selectDiv.append(appendOption) ;
          
          beforeSelector.before(
        		  $('<div/>').addClass('col').append(
        				  $('<label/>').addClass('form-control-label label-select')
        				               .append($
        				            		   ('<b/>').attr('class', 'control-label').text(name)
        				               )
        				               .append(
        				            		   selectDiv
        				               )
        		  )
          );
        }
        else if (type === 'daterange')
        {

          mappingDataInfo.daterangeInfo.forEach(function(daterangeObj){    		
	    	  beforeSelector.before($('<div/>').attr('class', 'col').append($('<label/>').attr('class', 'form-control-label').append($('<b/>').attr('class', 'control-label').text(daterangeObj.name)).append($('<input/>').attr(
	          {
	            'id' : daterangeObj.id,
	            'class' : 'form-control input-daterange',
	            'placeholder' : placeholder,
	            'autocomplete' : 'off'
	          }))))
          });

        }
        else if (type === 'dateCalc')
        {
        	
        	var unitObj = {'h' : timeHour, 'm' : timeMinute, 's' : timeSecond};
        	
        	var selectDiv = $('<select/>').addClass('form-control timerRange').attr({'v-model' : mappingDataInfo.selectModel, 'id' : mappingDataInfo.id, 'v-on:change' : mappingDataInfo.changeEvt +'("'+ mappingDataInfo.unit +'")'});
        	
        	selectDiv.append($('<option/>').attr({'selected' : 'selected', 'value' : '0'}).text(placeholder)) ;
        	selectDiv.append(
        			 	$('<option/>').attr({'v-for' : mappingDataInfo.optionFor, 'v-bind:value' : mappingDataInfo.optionValue}).text('{{'+mappingDataInfo.optionText+'}}' + unitObj[mappingDataInfo.unit])
        			 );
        	
        	beforeSelector.before(
          		  $('<div/>').addClass('col').append(
          				  $('<label/>').addClass('form-control-label label-select')
          				               .append(
          				            		   $('<b/>').addClass('control-label').text(name)
          				               )
          				               .append(
          				            		   selectDiv
          				               )
          		  )
            );
        }
        else if (type === 'singleDaterange')
        {
          beforeSelector.before($('<div/>').attr('class', 'col').append($('<label/>').attr('class', 'form-control-label').append($('<b/>').attr('class', 'control-label').text(name)).append($('<input/>').attr(
          {
            'v-model' : mappingDataInfo.vModel,
            'id' : mappingDataInfo.id,
            'class' : 'form-control input-filedate',
            'placeholder' : placeholder,
            'readonly' : true
          }))))
        }
        else if (type === 'modal')
        {
            beforeSelector.before(
          		  $('<div/>').addClass('col')
          		  			 .append(
          		  					 $('<label/>').addClass('form-control-label reset')
          		  					 			  .append(
          		  					 					  $('<b/>').addClass('control-label')
          		  					 					  		   .text(name)
          		  					 					           .append(
          		  					 					        		$('<i/>').addClass('icon-srch')
          		  					 					        		         .attr({'v-on:click' : 'openModal(' + JSON.stringify(mappingDataInfo) + ')'})
          		  					 					        				 .css({
          		  					 					        					 'line-height': 'unset', 
          		  					 					        					 'padding-left': '5px'
          		  					 					        				 })  
          		  					 					           )
          		  					 			  )
          		  					 			  .append(
          		  					 					  $('<input/>').addClass('form-control').attr({'v-model' : mappingDataInfo.vModel, 'placeholder' : placeholder, 'v-on:keyup.enter' : 'search'})
          		  					 			  )
          		  					 			  .append(
          		  					 					  $('<i/>').addClass('icon-close').attr({'v-on:click.prevent': mappingDataInfo.vModel + ' = null' })
          		  					 			  )
          		  			 )
            )
        }
        else if (type === 'datalist')
        {
          beforeSelector.before($('<div/>').attr('class', 'col').append($('<label/>').attr('class', 'form-control-label').append($('<b/>').attr('class', 'control-label').text(name)).append($('<input/>').attr(
          {
            'class' : 'form-control',
            'list' : mappingDataInfo.dataListId,
            'v-model' : mappingDataInfo.vModel,
            'placeholder' : placeholder,
            'v-on:keyup.enter' : 'search'
          })).append($('<datalist/>').attr(
          {
            'id' : mappingDataInfo.dataListId
          }).append($("<option/>").attr(
          {
            'v-for' : mappingDataInfo.dataListFor,
            'v-text' : mappingDataInfo.dataListText
          })))))
        }
        
        if(searchInfo.isShowFlagDataName)
        	beforeSelector.parent().find('.col').first().attr({'v-if': searchInfo.isShowFlagDataName});
        
        if(callBackFunc)
        	callBackFunc() ;
      }) ;

      if (isHidePageSize)
      {
        $('#' + this.getElementId('ImngSearchObject')).find('#list-select').remove() ;
      }

      $("#panel").find('.nav-tabs').off('click').on('click', function(evt)
      {
        windowResizeSearchGrid() ;
      }) ;
    }

    this.mainConstructor = function()
    {
      if (mainButtonList)
      {
        $.each($('#' + this.getElementId('ImngListObject')).find('.sub-bar').find('.ml-auto').children(), function(index, element)
        {
          if (!mainButtonList[element.id])
          {
            $(element).remove() ;
          }
          else
          {
            $(element).show() ;
          }
        }) ;
      }
      else
      {
        $('#' + this.getElementId('ImngListObject')).find('.sub-bar').find('.ml-auto').empty() ;
      }
    } ;

    this.panelConstructor = function(isHideResultTab)
    {

      tabList.forEach(function(tabObj, tabIndex)
      {

        // make tab menu
        var tabBar = $("#panel").find('.nav-item-origin').clone() ;

        tabBar.removeClass().addClass('nav-item') ;
        tabBar.children('.nav-link').addClass((0 == tabIndex) ? 'active' : '').attr(
        {
          'href' : '#' + tabObj.id
        }).text(tabObj.name) ;
        
        if(tabObj.clickEvt) {
            tabBar.off('click').on('click', function(evt) {
            	tabObj.clickEvt()
            });        	
        }
        
        tabBar.show() ;

        $("#panel").find('#item-result-parent').before(tabBar) ;

        // make tab detail area
        var tabDiv = $("<div/>").attr(
        {
          'id' : tabObj.id
        }) ;
        tabDiv.addClass('tab-pane ' + ((0 == tabIndex) ? 'active' : '')) ;
        tabDiv.addClass((tabObj.isSubResponsive) ? 'sub-responsive' : '') ;

        $("#panel").find('#process-result').before(tabDiv) ;

        var rowDiv = $("<div/>").addClass('row frm-row') ;
        tabDiv.append(rowDiv) ;

        if ('basic' == tabObj.type)
        {

          tabObj.detailList.forEach(function(detailObj, detailIndex)
          {

            var colDiv = $("<div/>").addClass(detailObj.className) ;
            rowDiv.append(colDiv) ;

            detailObj.detailSubList.forEach(function(detailSubObj, detailSubIndex)
            {

              var startIcon = (detailSubObj.isPk || detailSubObj.isRequired) ? '<b class="icon-star"></b>' : '' ;
              var formControl = (detailSubObj.isPk) ? 'form-control view-disabled dataKey' : 'form-control view-disabled' ;

              var object = $('.form-group-origin').clone() ;

              object.removeClass().addClass('form-group') ;
              object.children('.control-label').append($("<span/>").text(detailSubObj.name)).append(startIcon) ;
          
          	 if(detailSubObj.warning)
          		object.children('.control-label').after(
          			$('<label/>').addClass('control-label warningLabel').append(escapeHtml(detailSubObj.warning))
          		);
          	 
              if(detailSubObj.isShowFlagDataName)
            	  object.attr({'v-if': detailSubObj.isShowFlagDataName})              
              
              if ('text' == detailSubObj.type)
              {
                object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo,
                  'readonly' : detailSubObj.readonly,
                  'disabled' : detailSubObj.disabled
                }).show() ;
              }
              else if ('textEvt' == detailSubObj.type)
              {
                object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo,
                  'v-on:change' : detailSubObj.changeEvt,
                }) ;
                
                if(detailSubObj.clickEvt) {
                	object.children('.input-group').attr({'v-on:click' : detailSubObj.clickEvt })
                	object.children('.input-group').children('input[type=text]').addClass('underlineTxt');
                	object.children('.input-group').css({'cursor' : 'pointer'});
                }
                
                if(detailSubObj.btnClickEvt)
                	object.children('.input-group').append($("<button/>").attr({'v-on:click' : detailSubObj.btnClickEvt }).addClass('btn btn-icon').css({'margin-left' : '3px', 'padding': '5px 10px 0px 10px'})
    						   					   .append($("<i/>").addClass('icon-link')));
                
                object.children('.input-group').children('input[type=text]').show();	
                	
              }
              else if ('password' == detailSubObj.type)
              {
            	object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo,
                  'disabled' : detailSubObj.disabled,
                });

            	if(detailSubObj.cryptType)
            	{
            	  object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(formControl).attr({
            	    'v-bind:type' : detailSubObj.cryptType,
            	  });
            	  
            	  object.children('.input-group').children('span[type=password]').children('.icon-eye').attr(
            	  {
            	    'v-on:click' : '("password" == ' + detailSubObj.cryptType + ')? ' + detailSubObj.cryptType + ' = "text" : ' + detailSubObj.cryptType + ' = "password"'
            	  });
            	}
            	else
            	{
              	  object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(formControl).attr({
              	    'type' : 'password'
              	  }).width('100%');
              	  
              	  object.children('.input-group').children('span[type=password]').children('.icon-eye').hide();
            	}
            	
            	object.children('.input-group').children('span[type=password]').show();
              }
              else if ('search' == detailSubObj.type)
              {
                var searchClass = (detailSubObj.isPk) ? 'input-group-append saveGroup' : 'input-group-append saveGroup updateGroup' ;

                if (detailSubObj.height)
                {
                  object.children('.input-group').children('textarea').removeClass().addClass(formControl).attr(
                  {
                    'name' : 'detail_type_search',
                    'v-model' : detailSubObj.mappingDataInfo.vModel,
                    'readonly' : true
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').attr(
                  {
                    'class' : searchClass
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').find('#lookupBtn').attr(
                  {
                    'v-on:click' : 'openModal(' + JSON.stringify(detailSubObj.mappingDataInfo) + ')'
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').find('#resetBtn').attr(
                  {
                    'v-on:click' : detailSubObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();'
                  }) ;
                  object.children('.input-group').children('input-group-append').css('min-height', detailSubObj.height) ;
                }
                else
                {
                  object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr(
                  {
                    'name' : 'detail_type_search',
                    'v-model' : detailSubObj.mappingDataInfo.vModel,
                    'readonly' : true
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').attr(
                  {
                    'class' : searchClass
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').find('#lookupBtn').attr(
                  {
                    'v-on:click' : 'openModal(' + JSON.stringify(detailSubObj.mappingDataInfo) + ')'
                  }).show() ;
                  object.children('.input-group').children('.input-group-append').find('#resetBtn').attr(
                  {
                    'v-on:click' : detailSubObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();'
                  }) ;
                }
              }
              else if ('singleDaterange' == detailSubObj.type)
              {
                object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl + ' input-date').attr(
                {
                  'id' : detailSubObj.mappingDataInfo.id,
                  'v-model' : detailSubObj.mappingDataInfo.vModel,
                  'data-drops' : ((detailSubObj.mappingDataInfo.dataDrops) ? detailSubObj.mappingDataInfo.dataDrops : 'up'),
                  'autocomplete' : 'off',
                  'disabled' : detailSubObj.disabled
                }).show() ;
              }
              else if ('select' == detailSubObj.type)
              {
                var selectAttr = object.children('.input-group').children('select').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo.selectModel,
                  'v-on:change' : (detailSubObj.mappingDataInfo.changeEvt) ? detailSubObj.mappingDataInfo.changeEvt : null,
                  'disabled' : detailSubObj.disabled
                }) ;
                
                if (detailSubObj.id)
                	selectAttr.attr({'id' : detailSubObj.id});
                
                if (detailSubObj.clickEvt) 
                	object.children('.input-group').append($("<button/>").attr({'v-on:click' : detailSubObj.clickEvt }).addClass('btn btn-icon').css({'margin-left' : '3px', 'padding': '5px 10px 0px 10px'})
                								   .append($("<i/>").addClass('icon-link')));
                

                if (detailSubObj.placeholder)
                {
                  selectAttr.append($('<option/>').attr(
                  {
                    'selected' : 'selected',
                    'value' : ' '
                  }).text(detailSubObj.placeholder)) ;
                }

                selectAttr.append($("<option/>").attr(
                {
                  'v-for' : detailSubObj.mappingDataInfo.optionFor,
                  'v-bind:value' : detailSubObj.mappingDataInfo.optionValue,
                  'v-text' : detailSubObj.mappingDataInfo.optionText,
                  'v-bind:disabled' : detailSubObj.mappingDataInfo.optionDisabled
                })).show() ;
              }
              else if ('textarea' == detailSubObj.type)
              {
                object.children('.input-group').children('textarea').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo
                }).show() ;

                if (detailSubObj.height)
                  object.children('.input-group').children('textarea').css('min-height', detailSubObj.height) ;

              }
              else if ('combination' == detailSubObj.type)
              {

                detailSubObj.combiList.forEach(function(combiObj, combiIndex)
                {
                  if ('select' == combiObj.type)
                  {
                    object.children('.input-group').children('select').removeClass().addClass(formControl).attr(
                    {
                      'v-model' : combiObj.mappingDataInfo.selectModel
                    }).append($("<option/>").attr(
                    {
                      'v-for' : combiObj.mappingDataInfo.optionFor,
                      'v-bind:value' : combiObj.mappingDataInfo.optionValue,
                      'v-text' : combiObj.mappingDataInfo.optionText
                    })).show() ;
                  }
                  else if ('text' == combiObj.type)
                  {
                    object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr(
                    {
                      'v-model' : combiObj.mappingDataInfo
                    }).css('margin-left', '5px').show() ;
                  }
                })
              }
              else if ('datalist' == detailSubObj.type)
              {
                object.children('.input-group').children('span[type=datalist]').children('input[type=text]').removeClass().addClass(formControl).attr(
                {
                  'list' : detailSubObj.mappingDataInfo.dataListId,
                  'v-model' : detailSubObj.mappingDataInfo.vModel,
                }) ;

                object.children('.input-group').children('span[type=datalist]').children('datalist').attr(
                {
                  'id' : detailSubObj.mappingDataInfo.dataListId,
                }).append($("<option/>").attr(
                {
                  'v-for' : detailSubObj.mappingDataInfo.dataListFor,
                  'v-text' : detailSubObj.mappingDataInfo.dataListText
                }))

                object.children('.input-group').children('span[type=datalist]').show() ;
              }
              else if ('validateThreadMax' == detailSubObj.type)
              {
                object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr(
                {
                  'v-model' : detailSubObj.mappingDataInfo,
                  'readonly' : detailSubObj.readonly,
                  'disabled' : detailSubObj.disabled,
                  'v-on:change' : detailSubObj.changeEvt
                }).show() ;
              }
              else if ('grid' == detailSubObj.type)
              {
            	object.append($("<div/>").addClass('table-responsive').append($("<div/>").attr({'id' : detailSubObj.id})));  
              }
              
              if ('search' != detailSubObj.type)
              {
                object.children('.input-group').children('.input-group-append').remove() ;
              }

              colDiv.append(object) ;
            }) ;
          }) ;

          if (tabObj.appendAreaList)
          {

            var rowDiv = $("<div/>").addClass('row frm-row') ;
            tabDiv.append(rowDiv) ;

            tabObj.appendAreaList.forEach(function(appendArea)
            {
              rowDiv.append(appendArea.getDetailArea()) ;
            }) ;
          }

        }
        else if ('property' == tabObj.type) {
         
          if(tabObj.searchList) {
        	  
        	  var searchDiv = $("<div/>").addClass('viewGroup row').css({'width': '100%', 'margin' : '0 0 1.25rem 0'});
        	  
              tabObj.searchList.forEach(function(searchObj) {   
            	  
            	  var colDiv = $("<div/>").addClass(searchObj.className + ' searchArea-col');
            	  
            	  searchObj.searchSubList.forEach(function(searchSubObj) { 
            		  
            		  var appendTag = $("<div/>").addClass('form-group');            		  
            		  appendTag.append( $('<label/>').append( $('<b/>').attr('class', 'control-label').text(searchSubObj.name) ));
           	
	            	  if('select' == searchSubObj.type) {
	            		 
	            		  selectDiv = $('<select/>').removeClass().addClass('form-control').css({'background-color': 'rgb(245, 246, 251)'}).attr({
	            			  'id' : searchSubObj.mappingDataInfo.id,
	                		  'v-model' : searchSubObj.mappingDataInfo.selectModel,
	                		  'v-on:change' : (searchSubObj.mappingDataInfo.changeEvt) ? searchSubObj.mappingDataInfo.changeEvt : null
	            		  });
	            			  
	                    
	            		  if (searchSubObj.placeholder) {
	            			  selectDiv.append($('<option/>').attr({
	            				  'selected' : 'selected',
	            				  'value' : ' '
	            			  }).text(searchSubObj.placeholder)) ;
	            		  }
	
	            		  selectDiv.append($("<option/>").attr({
	            			  'v-for' : searchSubObj.mappingDataInfo.optionFor,
	            			  'v-bind:value' : searchSubObj.mappingDataInfo.optionValue,
	            			  'v-text' : searchSubObj.mappingDataInfo.optionText,
	            		  })) ;
	            		  
	            		  appendTag.append(selectDiv);
	            	  }
	            	  
	            	  colDiv.append(appendTag);
            	  });
            	  
            	  searchDiv.append(colDiv);
              });
              
              rowDiv.append(searchDiv);
          }
          
          rowDiv.append($("<div/>").addClass('form-table form-table-responsive').append($("<div/>").addClass('form-table-wrap')).append($("<div/>").addClass('form-table-head').append($("<button/>").addClass('btn-icon saveGroup updateGroup').attr(
          {
            'type' : 'button',
            'v-on:click' : tabObj.addRowFunc
          }).append($("<i/>").addClass('icon-plus-circle')))

          ).append($("<div/>").addClass('form-table-body').attr(
          {
            'v-for' : '(elm, index) in ' + tabObj.mappingDataInfo
          }))) ;

          if (tabObj.isShowRemoveIconWhere)
          {
            rowDiv.find('.form-table-body').append($("<button/>").addClass('btn-icon saveGroup updateGroup').attr(
            {
              'type' : 'button',
              'v-on:click' : tabObj.removeRowFunc,
              'v-if' : tabObj.isShowRemoveIconWhere
            }).append($("<i/>").addClass('icon-minus-circle'))).append($("<button/>").addClass('btn-icon saveGroup updateGroup').attr(
            {
              'type' : 'button',
              'v-if' : '!' + tabObj.isShowRemoveIconWhere
            }).append($("<i/>").addClass('icon-star')))
          }
          else
          {
            rowDiv.find('.form-table-body').append($("<button/>").addClass('btn-icon saveGroup updateGroup').attr(
            {
              'type' : 'button',
              'v-on:click' : tabObj.removeRowFunc
            }).append($("<i/>").addClass('icon-minus-circle'))) ;
          }

          tabObj.detailList.forEach(function(detailObj, detailIndex)
          {

            var disabled = (detailObj.disabled) ? detailObj.disabled : false ;

            var appendTag = null ;

            if ('text' == detailObj.type)
            {
              appendTag = $("<input/>").addClass('form-control view-disabled').attr(
              {
                'type' : detailObj.type,
                'v-model' : detailObj.mappingDataInfo,
                'disabled' : disabled
              }) ;
            }
            else if ('search' == detailObj.type)
            {
              appendTag = $("<div/>").addClass('input-group-append ').width('100%').append($("<input/>").addClass('form-control').attr(
              {
                'type' : detailObj.type,
                'v-model' : detailObj.mappingDataInfo.vModel,
                'readonly' : true,
                'disabled' : true
              })).append($("<button/>").addClass('btn saveGroup updateGroup').attr(
              {
                'v-on:click' : 'openModal(' + JSON.stringify(detailObj.mappingDataInfo) + ', index)'
              }).css(
              {
                'margin-left' : '3px'
              }).append($("<i/>").addClass('icon-srch')).append(searchBtn)).append($("<button/>").addClass('btn saveGroup updateGroup').attr(
              {
                'v-on:click' : detailObj.mappingDataInfo.vModel + ' = null;'
              }).css(
              {
                'margin-left' : '3px',
                'min-width' : '0px',
                'padding-left' : '0.5rem'
              }).append($("<i/>").addClass('icon-reset').css(
              {
                'margin-right' : '0px'
              })))
            }
            else if ('select' == detailObj.type)
            {
              appendTag = $("<select/>").attr(
              {
                'v-model' : detailObj.mappingDataInfo.selectModel
              }).addClass('form-control view-disabled').append($("<option/>").attr(
              {
                'v-for' : detailObj.mappingDataInfo.optionFor,
                'v-bind:value' : detailObj.mappingDataInfo.optionValue,
                'v-text' : detailObj.mappingDataInfo.optionText
              })) ;
            }
            else if ('singleDaterange' == detailObj.type)
            {
              appendTag = $("<input/>").addClass('form-control view-disabled input-date').attr(
              {
                'v-bind:id' : "'" + detailObj.mappingDataInfo.id + "' + index",
                'v-model' : detailObj.mappingDataInfo.vModel,
                'data-drops' : ((detailObj.mappingDataInfo.dataDrops) ? detailObj.mappingDataInfo.dataDrops : 'up'),
                'autocomplete' : 'off'
              }).show() ;
            }

            $("#" + tabObj.id).find('.form-table-head').append($("<label/>").addClass('col').text(detailObj.name)) ;
            $("#" + tabObj.id).find('.form-table-body').append($("<div/>").addClass('col').append(appendTag)) ;
          }) ;

        }
        else if ('tree' == tabObj.type)
        {
          rowDiv.append($("<div/>").addClass('table-responsive').append($("<div/>").attr(
          {
            'id' : tabObj.id + '_tree'
          }))) ;
        }
        else if ('custom' == tabObj.type)
        {
          var appendDiv = (tabObj.noRowClass) ? tabDiv : rowDiv ;

          if (tabObj.noRowClass)
            tabDiv.empty() ;

          appendDiv.append(tabObj.getDetailArea()) ;
        }
      }) ;

      $('.nav-item-origin').remove() ;
      $('.form-group-origin').remove() ;

      if (panelButtonList)
      {
        $.each($("#panel").find("#panel-footer").find('.ml-auto').children(), function(index, element)
        {
          if (!panelButtonList[element.id])
          {
            $(element).remove() ;
          }
          else
          {
            $(element).show() ;
          }
        }) ;
      }
      else
      {
        $("#panel").find("#panel-footer").find('.ml-auto').empty() ;
      }

      if (isHideResultTab)
      {
        $("#panel").find('#item-result-parent').remove() ;
        $("#panel").find('#process-result').remove() ;
      }
    }

    this.openModal = function(openModalParam)
    {
      openModalParam.url = openModalParam.url.replace('.html', '/popup.html');
      var url = contextPath + openModalParam.url + '?_client_mode=b&viewMode=Popup' + ((openModalParam.appendUrlObj) ? '&' + $.param(openModalParam.appendUrlObj) : '') ;
      var modalTitle = openModalParam.modalTitle ;
      var callBackFuncName = openModalParam.callBackFuncName ;
      var isMultiCheck = openModalParam.isMultiCheck ;

      var modalHtml = '' ;

      modalHtml += '<div id="' + viewName + 'ModalSearch"  class="modal fade" tabindex="-1" role="dialog">' ;
      modalHtml += '    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">' ;
      modalHtml += '        <div class="modal-content">' ;
      modalHtml += '            <div class="modal-header">' ;
      modalHtml += '                <h2 class="modal-title">' + modalTitle + '</h2>' ;
      modalHtml += '                <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>' ;
      modalHtml += '            </div>' ;
      modalHtml += '            <div class="modal-body"></div>' ;
      modalHtml += '            <div class="modal-footer">' ;
      modalHtml += '                <button type="button" class="btn btn-primary" id="modalConfirm" style="display:none;">OK</button>' ;
      modalHtml += '                <button type="button" class="btn" data-dismiss="modal" id="modalClose">Close</button>' ;
      modalHtml += '            </div>' ;
      modalHtml += '        </div>' ;
      modalHtml += '    </div>' ;
      modalHtml += '</div>' ;

      $('#' + viewName + 'ModalSearch').remove() ;

      $("body").append($(modalHtml)) ;

      if (isMultiCheck)
      {
        $('#' + viewName + 'ModalSearch').data('isMultiCheck', true) ;
        $('#' + viewName + 'ModalSearch').find("#modalConfirm").show() ;
      }
      
      startSpinner((openModalParam.modalParam)? openModalParam.modalParam.spinnerMode : null) ;
      
      $('#' + viewName + 'ModalSearch').on('show.bs.modal', function(e)
      {
        function step() 
        {
          if(0 == $('#' + viewName + 'ModalSearch').length)
          {
            cancelAnimationFrame(rafId);
            return;
          }

          var nextItem = $('#' + viewName + 'ModalSearch').next();
          
          if((0 < nextItem.length) && nextItem.hasClass('modal-backdrop')) 
          {
        	if(!(openModalParam.modalParam && 'full' == openModalParam.modalParam.spinnerMode))
        	{
        	  var ctWidth = $("#ct").outerWidth(true);        		
        	  nextItem.width(ctWidth).css({'left': 'auto', 'right': '0px'});
              $('#' + viewName + 'ModalSearch').width(ctWidth).css({'left': 'auto', 'right': '0px'});
        	}
        	  
        	$('.spinnerBg').hide();
            cancelAnimationFrame(rafId);
            return;
          }
            
          rafId = requestAnimationFrame(step);
        }
          
        var rafId = requestAnimationFrame(step);
      });      
      
      $('#' + viewName + 'ModalSearch').on('shown.bs.modal', function(e)
      {
        stopSpinner(function() {
          $('.spinnerBg').show() ;   
        }) ;
      }) ;

      $('#' + viewName + 'ModalSearch').on('hidden.bs.modal', function(e)
      {
        stopSpinner() ;
        $('#' + viewName + 'ModalSearch').remove() ;
      }) ;

      $('#' + viewName + 'ModalSearch').data('callBackFunc', this[callBackFuncName]) ;

      if (openModalParam.modalParam)
      {
        $('#' + viewName + 'ModalSearch').data('modalParam', openModalParam.modalParam) ;
      }

      $('#' + viewName + 'ModalSearch').find($(".modal-body")).load(url + '&popupId=' + viewName + 'ModalSearch') ;
      $('#' + viewName + 'ModalSearch').modal('show') ;
    }
  }

  return new createPageObj() ;
}

function panelOpen(o, object, callBackFunc) {

	$("#panel").find('#panel-header').find('.ml-auto').show();	
	
	if(window.vmMain) {
		window.vmMain.$nextTick(function() {
			setPanel();
		});
	} else {
		setPanel();
	}
  
	function setPanel() {
		if ('sidebar' != o) {
			
			if (o != 'done')
				$('#accordionResult').children('.collapse-item').remove() ;

		    if (window.vmMain)
		        window.vmMain.panelMode = o ;
		    
		    if (o == 'add') {
		    	$("#panel").find('.sub-bar-tit').text('Insert') ;
		    	$("#panel").find('.updateGroup').hide() ;
		    	$("#panel").find('.viewGroup').hide() ;
		    	$("#panel").find('.saveGroup').show() ;

		    	$("#panel").find('.view-disabled').not("input[type='checkbox']").attr('readonly', false) ;
		    	$("#panel").find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false) ;
		    	$("#panel").find('.form-control').filter('[name=detail_type_search]').attr('readonly', true) ;

		    	$("#panel").find('.dataKey').not('[name=detail_type_search]').attr('readonly', false) ;
		      
		    	if($("#panel").find('.warningLabel'))
		    		$("#panel").find('.warningLabel').show();
		      
			    if (window.vmMain) {
			    	window.vmMain.initDetailArea(object) ;
			    	window.vmMain.$forceUpdate();
			    }
		    }
		    else if (o == 'mod') {
		    	$("#panel").find('.sub-bar-tit').text('Update') ;
		    	$("#panel").find('.viewGroup').hide() ;
		    	$("#panel").find('.saveGroup').hide() ;
		    	$("#panel").find('.updateGroup').show() ;

		    	$("#panel").find('.view-disabled').not("input[type='checkbox']").attr('readonly', false) ;
		    	$("#panel").find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false) ;
		    	$("#panel").find('.form-control').filter('[name=detail_type_search]').attr('readonly', true) ;

		    	$("#panel").find('.dataKey').attr('readonly', true) ;
		      
		    	if($("#panel").find('.warningLabel'))
		    		$("#panel").find('.warningLabel').show();

		    }
		    else if (o == 'detail' || o == 'done') {
		    	$("#panel").find('.sub-bar-tit').text('Detail') ;
		    	$("#panel").find('.updateGroup').hide() ;
		    	$("#panel").find('.saveGroup').hide() ;
		    	$("#panel").find('.viewGroup').show() ;

		    	$("#panel").find('.view-disabled').not("input[type='checkbox']").attr('readonly', true) ;
		    	$("#panel").find('.view-disabled').filter("input[type='checkbox']").attr('disabled', true) ;

		    	$("#panel").find('.dataKey').attr('readonly', true) ;
		      
		    	if($("#panel").find('.warningLabel'))
		    		$("#panel").find('.warningLabel').hide();
		    }
		}
		
		var $wrap = $('#wrap') ;
		var a = -$wrap.scrollTop() ;
		var target = $('#' + (('sidebar' != o) ? 'panel' : 'sidebar')) ;
		var $body = $('body') ;

		$wrap.css('top', a) ;

		target.data('backdrop') !== false && target.after('<div class="backdrop"></div>') ;

		if ($body.hasClass('fixed')) {
			$body.removeAttr('class') ;
		    $('.panel').hide() ;
		}

		$body.addClass('fixed') ;

		setTimeout(function() {
			target.show(0, function() {

				$body.addClass('panel-open-' + o) ;

				windowResizeSearchGrid() ;

				if (callBackFunc) {
					callBackFunc() ;
				}
			});
		}, 200) ;		

		/*
		  if ((o == 'detail' || o == 'add') && !object)
		    $("#panel").find('.flex-shrink-0').children().first().children('a').trigger('click') ;
		*/
	}
}

function panelClose(o)
{

  if (window.vmMain)
    window.vmMain.panelMode = null

  var ct = $('#wrap') ;
  var originScroll = -ct.position().top ;
  $('body').removeClass('panel-open-' + o).find('.backdrop').remove() ;
  $("#" + window.mainListAreaId).find(".table-responsive").height('auto') ;

  setTimeout(function()
  {
    $('#' + o).hide() ;
    $('body').removeClass('fixed') ;
    if (originScroll != -0)
    {
      ct.scrollTop(originScroll) ;
    }
    ct.removeAttr('style') ;
    windowResizeSearchGrid() ;
  }, 200) ;
}

