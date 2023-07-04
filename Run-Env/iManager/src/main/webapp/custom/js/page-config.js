function getCreatePageObj() {
	var viewName = null;

	var searchList = null;

	var mainButtonList = null;

	var tabList = null;
	var panelButtonList = null;

	var isModal = false;

	var idDelimiter = '-';

	function createPageObj() {
		this.setViewName = function (pViewName) {
			$('#ImngListObject').attr('id', 'ImngListObject' + idDelimiter + pViewName);
			$('#ImngSearchGrid').attr('id', 'ImngSearchGrid' + idDelimiter + pViewName);
			$('#ImngSearchObject').attr('id', 'ImngSearchObject' + idDelimiter + pViewName);

			viewName = pViewName;
		};

		this.setSearchList = function (pSearchList) {
			if (!isModal) SearchImngObj.initSearchImngObj();

			searchList = pSearchList;
		};

		this.setMainButtonList = function (pMainButtonList) {
			mainButtonList = pMainButtonList;
		};

		this.setTabList = function (pTabList) {
			tabList = pTabList;
		};

		this.setPanelButtonList = function (pPanelButtonList) {
			panelButtonList = pPanelButtonList;
		};

		this.setIsModal = function (pIsModal) {
			isModal = pIsModal;

			if (!isModal) {
				window.mainListAreaId = 'ImngListObject' + idDelimiter + viewName;
				window.mainSearchAreaId = 'ImngSearchObject' + idDelimiter + viewName;
				window.mainSearchGridId = 'ImngSearchGrid' + idDelimiter + viewName;
			}
		};

		this.getElementId = function (id) {
			return id + idDelimiter + viewName;
		};		

		this.searchConstructor = function (isHidePageSize, callBackFunc) {
			var searchRootSelector = $('#' + this.getElementId('ImngSearchObject'));
			searchRootSelector.show();
			
			var startSearchExpandCnt = 5;
			var isNeedExtension =
				startSearchExpandCnt < searchList.length + (isHidePageSize ? 0 : 1) + searchList.filter(function (searchInfo) { return 'daterange' == searchInfo.type && 1 < searchInfo.mappingDataInfo.daterangeInfo.length; }).length;

			if (0 == searchRootSelector.find('.toggleSearchExpandArea').length) isNeedExtension = false;

			if (isNeedExtension) searchRootSelector.find('.toggleSearchExpandBtn').show();
			else searchRootSelector.find('.toggleSearchExpandBtn').hide();

			var beforeSelector = searchRootSelector.find('#list-select');
			
			function textSearchType(searchObj) {
				var regExpDataInfo = searchObj.mappingDataInfo.replace('object', 'letter');
				var regExpInputInfo = {
					key : searchObj.mappingDataInfo,
					regExp: getRegExpInfo(searchObj.regExpType).regExp
				};
				
				var letterLength = $('<span/>').addClass('letterLength')
									.append($('<span/>').text('('))
									.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
									.append($('<span/>').text('/' + searchObj.maxLength + ')'));						
				
				beforeSelector.before(
					$('<div/>')
						.addClass('col')
						.append(
							$('<label/>')
								.addClass('form-control-label reset')
								.append($('<b/>').addClass('control-label').text(searchObj.name).append(letterLength))
								.append( $('<input/>').addClass('form-control')
										.attr({
											id: searchObj.id, 
											'v-model': searchObj.mappingDataInfo, 
											placeholder: searchObj.placeholder, 
											maxlength: searchObj.maxLength,
											'v-on:keyup.enter': 'search',
											'v-on:input': searchObj.regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
										})
								)
								.append(
									$('<i/>')
										.addClass('icon-close')
										.attr({ 'v-on:click.prevent': searchObj.mappingDataInfo + ' = null; '+ (regExpDataInfo? (regExpDataInfo  +' = 0;') : '') })
								)
						)
				);
			}
			
			function selectSearchType(searchObj) {
				var mappingDataInfo = searchObj.mappingDataInfo;
				
				var selectDiv = $('<select/>').addClass('form-control selectpicker').attr({ 'v-model': mappingDataInfo.selectModel, id: mappingDataInfo.id, 'data-size': '10' });

				if (searchObj.changeEvt) selectDiv.attr({ 'v-on:change': searchObj.changeEvt });

				if (!searchObj.isHideAllOption) selectDiv.append($('<option/>').attr({ selected: 'selected', value: ' ' }).text(searchObj.placeholder));

				var appendOption = $('<option/>').attr({ 'v-for': mappingDataInfo.optionFor, 'v-bind:value': mappingDataInfo.optionValue, 'v-text': mappingDataInfo.optionText });

				if (mappingDataInfo.optionIf) appendOption.attr({ 'v-if': mappingDataInfo.optionIf });

				selectDiv.append(appendOption);

				beforeSelector.before(
					$('<div/>')
						.addClass('col')
						.append($('<label/>').addClass('form-control-label label-select').append($('<b/>').attr('class', 'control-label').text(searchObj.name)).append(selectDiv))
				);
			}
			
			function daterangeSearchType(searchObj) {
				searchObj.mappingDataInfo.daterangeInfo.forEach(function (daterangeObj, idx) {
					beforeSelector.before(
						$('<div/>')
							.attr('class', 'col')
							.data('idx', idx)
							.append(
								$('<label/>')
									.attr('class', 'form-control-label')
									.append($('<b/>').attr('class', 'control-label').text(daterangeObj.name))
									.append(
										$('<input/>').attr({
											id: daterangeObj.id,
											class: 'form-control input-daterange',
											placeholder: searchObj.placeholder,
											autocomplete: 'off'
										})
									)
							)
					);
				});
			}
			
			function dateCalcSearchType(searchObj) {
				var mappingDataInfo = searchObj.mappingDataInfo;
				var unitObj = { h: timeHour, m: timeMinute, s: timeSecond };

				var dateCalcSelectDiv = $('<select/>')
					.addClass('form-control timerRange')
					.attr({ 'v-model': mappingDataInfo.selectModel, id: mappingDataInfo.id, 'v-on:change': mappingDataInfo.changeEvt + '("' + mappingDataInfo.unit + '")' });

				dateCalcSelectDiv.append($('<option/>').attr({ selected: 'selected', value: '0' }).text(searchObj.placeholder));
				dateCalcSelectDiv.append(
					$('<option/>')
						.attr({ 'v-for': mappingDataInfo.optionFor, 'v-bind:value': mappingDataInfo.optionValue })
						.text('{{' + mappingDataInfo.optionText + '}}' + unitObj[mappingDataInfo.unit])
				);

				beforeSelector.before(
					$('<div/>')
						.addClass('col')
						.append($('<label/>').addClass('form-control-label label-select').append($('<b/>').addClass('control-label').text(searchObj.name)).append(dateCalcSelectDiv))
				);
			}
			
			function singleDaterangeSearchType(searchObj) {
				beforeSelector.before(
					$('<div/>')
						.attr('class', 'col')
						.append(
							$('<label/>')
								.attr('class', 'form-control-label')
								.append($('<b/>').attr('class', 'control-label').text(searchObj.name))
								.append(
									$('<input/>').attr({
										'v-model': searchObj.mappingDataInfo.vModel,
										id: searchObj.mappingDataInfo.id,
										class: 'form-control input-filedate',
										placeholder: searchObj.placeholder,
										readonly: true
									})
								)
						)
				);
			}
			
			function modalSearchType(searchObj) {
				var mappingDataInfo = searchObj.mappingDataInfo
				var modalRegExpInfo = mappingDataInfo.vModel.replace('object', 'letter');
				var modalRegExpInputInfo = {
					key : mappingDataInfo.vModel,
					regExp: getRegExpInfo(searchObj.regExpType).regExp
				};
			
				var modalLetterLength = $('<span/>').addClass('letterLength')
									.append($('<span/>').text('('))
									.append($('<span/>').attr({ 'v-text': modalRegExpInfo }))
									.append($('<span/>').text('/' + searchObj.maxLength + ')'));
				
				
				beforeSelector.before(
					$('<div/>')
						.addClass('col')
						.append(
							$('<label/>')
								.addClass('form-control-label reset')
								.append(
									$('<b/>')
										.addClass('control-label')
										.text(searchObj.name)
										.append(
											$('<i/>')
												.addClass('icon-srch')
												.attr({ 'v-on:click': 'openModal(' + JSON.stringify(mappingDataInfo) + ',' + JSON.stringify(modalRegExpInputInfo) + ')' })
												.css({
													'line-height': 'unset',
													'padding-left': '5px'
												})
										)
										.append(modalLetterLength)
								)
								.append( $('<input/>').addClass('form-control')
										.attr({
											'v-model': mappingDataInfo.vModel, 
											placeholder: searchObj.placeholder, 
											maxlength: searchObj.maxLength,
											'v-on:keyup.enter': searchObj.enterEvt ? searchObj.enterEvt : 'search',
											'v-on:input': searchObj.regExpType? 'inputEvt(' + JSON.stringify(modalRegExpInputInfo)  + ')' : null
										})
								)
								.append(
									$('<i/>')
										.addClass('icon-close')
										.attr({ 'v-on:click.prevent': mappingDataInfo.vModel + ' = null;'+ (modalRegExpInfo? (modalRegExpInfo  +' = 0;') : '') })
								)
						)
				);
			}
			
			function datalistSearchType(searchObj) {
				var mappingDataInfo = searchObj.mappingDataInfo;
				var datalistRegExpInfo = mappingDataInfo.vModel.replace('object', 'letter');
				var datalistRegExpInputInfo = {
					key : mappingDataInfo.vModel,
					regExp: getRegExpInfo(searchObj.regExpType).regExp
				};
				
				var datalistLetterLength = $('<span/>').addClass('letterLength')
									.append($('<span/>').text('('))
									.append($('<span/>').attr({ 'v-text': datalistRegExpInfo }))
									.append($('<span/>').text('/' + searchObj.maxLength + ')'));						
				
				beforeSelector.before(
					$('<div/>')
						.attr('class', 'col')
						.append(
							$('<label/>')
								.attr('class', 'form-control-label')
								.append($('<b/>').attr('class', 'control-label').text(searchObj.name).append(datalistLetterLength))
								.append(
									$('<input/>').attr({
										class: 'form-control',
										list: mappingDataInfo.dataListId,
										'v-model': mappingDataInfo.vModel,
										placeholder: searchObj.placeholder,
										maxlength: searchObj.maxLength,
										'v-on:keyup.enter': 'search',
										'v-on:input': searchObj.regExpType? 'inputEvt(' + JSON.stringify(datalistRegExpInputInfo)  + ')' : null
									})
								)
								.append(
									$('<datalist/>')
										.attr({
											id: mappingDataInfo.dataListId
										})
										.append(
											$('<option/>').attr({
												'v-for': mappingDataInfo.dataListFor,
												'v-text': mappingDataInfo.dataListText
											})
										)
								)
						)
				);
			}

			searchList.forEach(function (searchInfo, index) {
				var type = searchInfo.type;
				
				var searchObj = {
						id: searchInfo.id,
						mappingDataInfo : searchInfo.mappingDataInfo,
						name : searchInfo.name,
						placeholder : searchInfo.placeholder,
						regExpType : searchInfo.regExpType? searchInfo.regExpType : 'default',
						maxLength : getRegExpInfo(searchInfo.regExpType? searchInfo.regExpType : 'default').maxLength,
						changeEvt: searchInfo.changeEvt,    
						isHideAllOption: searchInfo.isHideAllOption,
						enterEvt: searchInfo.enterEvt,
				}
				
				if (type === 'text') textSearchType(searchObj);					
				else if (type === 'select') selectSearchType(searchObj);				
				else if (type === 'daterange') daterangeSearchType(searchObj);				
				else if (type === 'dateCalc') dateCalcSearchType(searchObj);				
				else if (type === 'singleDaterange') singleDaterangeSearchType(searchObj);
				else if (type === 'modal') modalSearchType(searchObj);				
				else if (type === 'datalist') datalistSearchType(searchObj);
				
				if (isNeedExtension) {
					while (true) {
						if (startSearchExpandCnt >= searchRootSelector.find('#list-select').prevAll('.col').length) {
							break;
						}

						searchRootSelector
							.find('.toggleSearchExpandArea')
							.children('.filter')
							.find('.col-auto')
							.before('daterange' === type && 0 === beforeSelector.prev().prev().data('idx') ? beforeSelector.prev().prev() : beforeSelector.prev());
					}
				}

				if (searchInfo.isShowFlagDataName) beforeSelector.prev().attr({ 'v-if': searchInfo.isShowFlagDataName });

				if (callBackFunc) callBackFunc();
			});

			if (isHidePageSize) {
				searchRootSelector.find('#list-select').remove();
			} else {
				if (isNeedExtension) {
					searchRootSelector.find('.toggleSearchExpandArea').children('.filter').find('.col-auto').before(searchRootSelector.find('#list-select'));
				}
			}

			$('#panel')
				.find('.nav-tabs')
				.off('click')
				.on('click', function (evt) {
					windowResizeSearchGrid();
				});
		};

		this.mainConstructor = function () {
			$('#' + this.getElementId('ImngListObject')).show();
			
			if (mainButtonList) {
				var mainButtonIdList = [];

				var listObj = $('#' + this.getElementId('ImngListObject'));

				listObj
					.find('.sub-bar')
					.children()
					.each(function (index, element) {
						$(element)
						.children()
						.each(function (subIndex, subElement) {
							if (!$(subElement).attr('id')) return;
							mainButtonIdList.push($(subElement).attr('id'));
						});
					});

				mainButtonIdList.forEach(function (id) {
					if (!mainButtonList[id]) listObj.find('#' + id).remove();
					else listObj.find('#' + id).show();
				});
			} else {
				$('#' + this.getElementId('ImngListObject'))
					.find('.sub-bar')
					.find('.ml-auto')
					.empty();
			}
		};

		this.panelConstructor = function (isHideResultTab) {			
			// make tab func
			function basicTabType(tabObj, rowDiv, tabDiv) {
				tabObj.detailList.forEach(function (detailObj, detailIndex) {
					var colDiv = $('<div/>').addClass(detailObj.className);
					rowDiv.append(colDiv);
					
					function textBasicType(detailContentObj) {
						var regExpDataInfo = detailContentObj.mappingDataInfo.replace('object', 'letter');
						var regExpInputInfo = {
							key : detailContentObj.mappingDataInfo,
							regExp: getRegExpInfo(detailContentObj.regExpType).regExp
						};
						
						detailContentObj.object.children('.control-label').children(':first-child')
							  .append($('<span/>').addClass('letterLength')
										.append($('<span/>').text('('))
										.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
										.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
							  ).show();
						
						
						detailContentObj.object
							.children('.input-group')
							.children('input[type=text]')
							.removeClass()
							.addClass(detailContentObj.formControl)
							.attr({
								'v-model': detailContentObj.mappingDataInfo,
								readonly: detailContentObj.readonly,
								disabled: detailContentObj.disabled,
								maxlength: detailContentObj.maxLength,
								'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
							})
							.show();
					}
					
					
					
					detailObj.detailSubList.forEach(function (detailSubObj, detailSubIndex) {
						var type = detailSubObj.type;						
						var startIcon = detailSubObj.isPk || detailSubObj.isRequired ? '<b class="icon-star"></b>' : '';						
						var object = $('.form-group-origin').clone();						
						object.removeClass().addClass('form-group');
						object.children('.control-label').append($('<span/>').text(detailSubObj.name)).append(startIcon);

						if (detailSubObj.warning) object.children('.control-label').after($('<label/>').addClass('control-label warningLabel').append(escapeHtml(detailSubObj.warning)));
						if (detailSubObj.isShowFlagDataName) object.attr({ 'v-if': detailSubObj.isShowFlagDataName });
						
						var detailContentObj = {
								id: detailSubObj.id,
								isPk: detailSubObj.isPk,
								height: detailSubObj.height,
								readonly: detailSubObj.readonly,
								disabled: detailSubObj.disabled,
								mappingDataInfo: detailSubObj.mappingDataInfo,
								regExpType: detailSubObj.regExpType ? detailSubObj.regExpType : 'default',
								maxLength: getRegExpInfo(detailSubObj.regExpType ? detailSubObj.regExpType : 'default').maxLength,
								formControl: detailSubObj.isPk ? 'form-control view-disabled dataKey' : 'form-control view-disabled',
								object: object,		
								placeholder: detailSubObj.placeholder,
								combiList: detailSubObj.combiList,
								changeEvt: detailSubObj.changeEvt,
								clickEvt: detailSubObj.clickEvt,
								btnClickEvt: detailSubObj.btnClickEvt,
								cryptType: detailSubObj.cryptType,
						};

						if ('text' == type) textBasicType(detailContentObj);
						else if ('textEvt' == type) textEvtBasicType(detailContentObj); 
						else if ('password' == type) passwordBasicType(detailContentObj);
						else if ('search' == type) searchBasicType(detailContentObj);
						else if ('singleDaterange' == type) singleDateBasicType(detailContentObj); 
						else if ('select' == type) selectBasicType(detailContentObj);
						else if ('textarea' == type) textareaBasicType(detailContentObj);
						else if ('combination' == type) combiBasicType(detailContentObj);
						else if ('datalist' == type) datalistBasicType(detailContentObj);
						else if ('radio' == type) radioBasicType(detailContentObj);
						else if ('checkbox' == type) checkboxBasicType(detailContentObj);
						else if ('grid' == type) gridBasicType(detailContentObj);

						if ('search' != type && 'cron' != type) {
							object.children('.input-group').children('.input-group-append').remove();
						}

						colDiv.append(object);
					});
				});

				if (tabObj.appendAreaList) {
					var tabRowDiv = $('<div/>').addClass('row frm-row');
					tabDiv.append(tabRowDiv);

					tabObj.appendAreaList.forEach(function (appendArea) {
						tabRowDiv.append(appendArea.getDetailArea());
					});
				}
			}
			
			function textEvtBasicType(detailContentObj) {	
				var textEvtRegExpInfo = detailContentObj.mappingDataInfo.replace('object', 'letter');
				var textEvtRegExpInputInfo = {
					key : detailContentObj.mappingDataInfo,
					regExp: getRegExpInfo(detailContentObj.regExpType).regExp
				};
				
				detailContentObj.object.children('.control-label').children(':first-child')
					  .append($('<span/>').addClass('letterLength')
								.append($('<span/>').text('('))
								.append($('<span/>').attr({ 'v-text': textEvtRegExpInfo }))
								.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
					  ).show();
				
				detailContentObj.object.children('.input-group').children('input[type=text]').removeClass().addClass(detailContentObj.formControl).attr({
					'v-model': detailContentObj.mappingDataInfo,
					'v-on:change': detailContentObj.changeEvt,
					maxlength: detailContentObj.maxLength,
					'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(textEvtRegExpInputInfo)  + ')' : null
				});

				if (detailContentObj.clickEvt) {
					detailContentObj.object.children('.input-group').attr({ 'v-on:click': detailContentObj.clickEvt });
					detailContentObj.object.children('.input-group').children('input[type=text]').addClass('underlineTxt');
					detailContentObj.object.children('.input-group').css({ cursor: 'pointer' });
				}

				if (detailContentObj.btnClickEvt) detailContentObj.object.children('.input-group').append($('<button/>').attr({ 'v-on:click': detailContentObj.btnClickEvt }).addClass('btn btn-icon').css({ 'margin-left': '3px', padding: '5px 10px 0px 10px' }).append($('<i/>').addClass('icon-link')));

				detailContentObj.object.children('.input-group').children('input[type=text]').show();
			}
			
			function passwordBasicType(detailContentObj){
				var passwordRegExpInfo = detailContentObj.mappingDataInfo.replace('object', 'letter');
				var passwordRegExpInputInfo = {
					key : detailContentObj.mappingDataInfo,
					regExp: getRegExpInfo(detailContentObj.regExpType).regExp
				};
					
				detailContentObj.object.children('.control-label').children(':first-child')
					  .append($('<span/>').addClass('letterLength')
								.append($('<span/>').text('('))
								.append($('<span/>').attr({ 'v-text': passwordRegExpInfo }))
								.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
					  ).show();
				
				
				detailContentObj.object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(detailContentObj.formControl).attr({
					'v-model': detailContentObj.mappingDataInfo,
					disabled: detailContentObj.disabled,
					maxlength: detailContentObj.maxLength,
					'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(passwordRegExpInputInfo)  + ')' : null
				});

				if (detailContentObj.cryptType) {
					detailContentObj.object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(detailContentObj.formControl).attr({
						'v-bind:type': detailContentObj.cryptType
					});

					detailContentObj.object
						.children('.input-group')
						.children('span[type=password]')
						.children('.icon-eye')
						.attr({
							'v-on:click': '("password" == ' + detailContentObj.cryptType + ')? ' + detailContentObj.cryptType + ' = "text" : ' + detailContentObj.cryptType + ' = "password"'
						});
				} else {
					detailContentObj.object
						.children('.input-group')
						.children('span[type=password]')
						.children('input')
						.removeClass()
						.addClass(detailContentObj.formControl)
						.attr({
							type: 'password'
						})
						.width('100%');

					detailContentObj.object.children('.input-group').children('span[type=password]').children('.icon-eye').hide();
				}

				detailContentObj.object.children('.input-group').children('span[type=password]').show();
			}
			
			function searchBasicType(detailContentObj) {
				var searchClass = detailContentObj.isPk ? 'input-group-append saveGroup' : 'input-group-append saveGroup updateGroup';

				if (detailContentObj.height) {
					detailContentObj.object
						.children('.input-group')
						.children('textarea')
						.removeClass()
						.addClass(detailContentObj.formControl)
						.attr({
							name: 'detail_type_search',
							'v-model': detailContentObj.mappingDataInfo.vModel,
							readonly: true
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.attr({
							class: searchClass
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.find('#lookupBtn')
						.attr({
							'v-on:click': 'openModal(' + JSON.stringify(detailContentObj.mappingDataInfo) + ')'
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.find('#resetBtn')
						.attr({
							'v-on:click': detailContentObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();'
						});
					detailContentObj.object.children('.input-group').children('input-group-append').css('min-height', detailContentObj.height);
				} else {
					detailContentObj.object
						.children('.input-group')
						.children('input[type=text]')
						.removeClass()
						.addClass(detailContentObj.formControl)
						.attr({
							name: 'detail_type_search',
							'v-model': detailContentObj.mappingDataInfo.vModel,
							readonly: true
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.attr({
							class: searchClass
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.find('#lookupBtn')
						.attr({
							'v-on:click': 'openModal(' + JSON.stringify(detailContentObj.mappingDataInfo) + ')'
						})
						.show();
					detailContentObj.object
						.children('.input-group')
						.children('.input-group-append')
						.find('#resetBtn')
						.attr({
							'v-on:click': detailContentObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();'
						});
				}
			}
			
			function singleDateBasicType(detailContentObj) {
				detailContentObj.object
					.children('.input-group')
					.children('input[type=text]')
					.removeClass()
					.addClass(detailContentObj.formControl + ' input-date')
					.attr({
						id: detailContentObj.mappingDataInfo.id,
						'v-model': detailContentObj.mappingDataInfo.vModel,
						'data-drops': detailContentObj.mappingDataInfo.dataDrops ? detailContentObj.mappingDataInfo.dataDrops : 'up',
						autocomplete: 'off',
						disabled: detailContentObj.disabled
					})
					.show();
			}
			
			function selectBasicType(detailContentObj) {
				var selectAttr = detailContentObj.object
									.children('.input-group')
									.children('select')
									.removeClass()
									.addClass(detailContentObj.formControl)
									.attr({
										'v-model': detailContentObj.mappingDataInfo.selectModel,
										'v-on:change': detailContentObj.mappingDataInfo.changeEvt ? detailContentObj.mappingDataInfo.changeEvt : null,
										disabled: detailContentObj.disabled
									});

				if (detailContentObj.id) selectAttr.attr({ id: detailContentObj.id });

				if (detailContentObj.clickEvt) detailContentObj.object.children('.input-group').append($('<button/>').attr({ 'v-on:click': detailContentObj.clickEvt }).addClass('btn btn-icon').css({ 'margin-left': '3px', padding: '5px 10px 0px 10px' }).append($('<i/>').addClass('icon-link')));

				if (detailContentObj.placeholder) {
					selectAttr.append(
						$('<option/>')
							.attr({
								selected: 'selected',
								value: ' '
							})
							.text(detailContentObj.placeholder)
					);
				}

				selectAttr
					.append(
						$('<option/>').attr({
							'v-for': detailContentObj.mappingDataInfo.optionFor,
							'v-bind:value': detailContentObj.mappingDataInfo.optionValue,
							'v-text': detailContentObj.mappingDataInfo.optionText,
							'v-bind:disabled': detailContentObj.mappingDataInfo.optionDisabled
						})
					)
					.show();
			}
			
			function textareaBasicType(detailContentObj) {
				var textareaRegExpInfo = detailContentObj.mappingDataInfo.replace('object', 'letter');
				var textareaRegExpInputInfo = {
					key : detailContentObj.mappingDataInfo,
					regExp: getRegExpInfo(detailContentObj.regExpType).regExp
				};
				
				detailContentObj.object.children('.control-label').children(':first-child')
				  .append($('<span/>').addClass('letterLength')
							.append($('<span/>').text('('))
							.append($('<span/>').attr({ 'v-text': textareaRegExpInfo }))
							.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
				  ).show();
				
				detailContentObj.object
					.children('.input-group')
					.children('textarea')
					.removeClass()
					.addClass(detailContentObj.formControl)
					.attr({
						'v-model': detailContentObj.mappingDataInfo,
						maxlength: detailContentObj.maxLength,
						'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(textareaRegExpInputInfo)  + ')' : null
					})
					.show();

				if (detailContentObj.height) detailContentObj.object.children('.input-group').children('textarea').css('min-height', detailContentObj.height);
			}
			
			function combiBasicType(detailContentObj) {						
				detailContentObj.combiList.forEach(function (combiObj, combiIndex) {
					var type = combiObj.type;
					
					var combiRegExpType = combiObj.regExpType ? combiObj.regExpType : 'default';	
					var combiMaxLength = getRegExpInfo(combiRegExpType).maxLength;
												
					if ('select' == type) {
						detailContentObj
							.object
							.children('.input-group')
							.children('select')
							.removeClass()
							.addClass(detailContentObj.formControl)
							.attr({
								'v-model': combiObj.mappingDataInfo.selectModel
							})
							.append(
								$('<option/>').attr({
									'v-for': combiObj.mappingDataInfo.optionFor,
									'v-bind:value': combiObj.mappingDataInfo.optionValue,
									'v-text': combiObj.mappingDataInfo.optionText
								})
							)
							.show();
					} else if ('text' == type) {
						var regExpDataInfo = combiObj.mappingDataInfo.replace('object', 'letter');
						var regExpInputInfo = {
							key : combiObj.mappingDataInfo,
							regExp:  getRegExpInfo(combiRegExpType).regExp
						}
						
						detailContentObj.object.children('.input-group').append(
								$('<div/>').addClass('detail-content-regExp').css({ 'margin-left': '5px', 'width': 'auto' })
									.append(
											detailContentObj
												.object
												.children('.input-group')
												.children('input[type=text]')
												.removeClass()
												.addClass('regExp-text')
												.attr({
													'v-model': combiObj.mappingDataInfo,
													maxlength: combiMaxLength,
													'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
												}).show()
									)
							  		.append(
							  			$('<span/>').addClass('letterLength')
										.append($('<span/>').text('('))
										.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
										.append($('<span/>').text('/' + combiMaxLength + ')'))
							  		)
						);
					 } else if ('radio' == type) {
						 detailContentObj
						 	.object
							.children('.input-group')
							.children('div[type=radio]')
							.removeClass()
							.addClass('custom-control custom-radio single')
							.append(
								$('<label/>').css({'padding-right': '30px'}).attr({
									'v-for': combiObj.mappingDataInfo.optionFor
								}).append(
									$('<input/>').addClass('custom-control-input').attr({
										type: 'radio',
										'v-model': combiObj.mappingDataInfo.vModel,
										'v-bind:value': combiObj.mappingDataInfo.optionValue,
										'v-bind:disabled': combiObj.mappingDataInfo.optionDisabled
									})
								)
								.append(
									$('<span/>').addClass('custom-control-label').attr({
										'v-text': combiObj.mappingDataInfo.optionText
									}).css({'padding-left': '5px'})
								)
							).show();
					 } else if ('checkbox' == type) {
						 detailContentObj
							 .object
							 .children('.input-group')
							 .children('div[type=checkbox]')
							 .removeClass()
							 .addClass('custom-control custom-checkbox single')
							 .css({'padding-left': '0'})
							 .append(
									 $('<label/>').css({'padding-right': '10px'})
									 	.attr({
									 		'v-for': combiObj.mappingDataInfo.optionFor
									 	})
									 	.append(
								 			$('<input/>')
								 				.addClass('custom-control-input')
								 					.attr({
								 						type: 'checkbox',
								 						'v-model': combiObj.mappingDataInfo.vModel,
								 						'v-bind:value': combiObj.mappingDataInfo.optionValue,
								 						'v-bind:disabled': combiObj.mappingDataInfo.optionDisabled,
								 						'v-on:change': combiObj.mappingDataInfo.changeEvt ? combiObj.mappingDataInfo.changeEvt : null
							 						})
						 						.css({'position': 'relative', 'width': '0.75rem', 'height': '1.05rem'})
										)
										.append(
											$('<span/>').addClass('custom-control-label').attr({
												'v-text': combiObj.mappingDataInfo.optionText
											}).css({'padding-left': '5px'})
										)
							).show();
					 }
				});			
			}
			
			function datalistBasicType(detailContentObj) {
				var detailSubDatalistRegInfo = detailContentObj.mappingDataInfo.vModel.replace('object', 'letter');
				var detailSubDatalistRegInputInfo = {
					key : detailContentObj.mappingDataInfo.vModel,
					regExp: getRegExpInfo(detailContentObj.regExpType).regExp
				}
				
				detailContentObj.object.children('.control-label').children(':first-child')
					  .append($('<span/>').addClass('letterLength')
								.append($('<span/>').text('('))
								.append($('<span/>').attr({ 'v-text': detailSubDatalistRegInfo }))
								.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
					  ).show();
				
				
				detailContentObj.object.children('.input-group').children('span[type=datalist]').children('input[type=text]').removeClass().addClass(detailContentObj.formControl).attr({
					list: detailContentObj.mappingDataInfo.dataListId,
					'v-model': detailContentObj.mappingDataInfo.vModel,
					maxlength: detailContentObj.maxLength,
					'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(detailSubDatalistRegInputInfo)  + ')' : null
				});

				detailContentObj
					.object
					.children('.input-group')
					.children('span[type=datalist]')
					.children('datalist')
					.attr({
						id: detailContentObj.mappingDataInfo.dataListId
					})
					.append(
						$('<option/>').attr({
							'v-for': detailContentObj.mappingDataInfo.dataListFor,
							'v-text': detailContentObj.mappingDataInfo.dataListText
						})
					);

				detailContentObj.object.children('.input-group').children('span[type=datalist]').show();
			}
			
			function radioBasicType(detailContentObj) {
				detailContentObj
					.object
					.children('.input-group')
					.children('div[type=radio]')
					.removeClass()
					.addClass('custom-control custom-radio single')
					.append(
						$('<label/>').css({'padding-right': '30px'}).attr({
							'v-for': detailContentObj.mappingDataInfo.optionFor
						}).append(
							$('<input/>').addClass('custom-control-input').attr({
								type: 'radio',
								'v-model': detailContentObj.mappingDataInfo.vModel,
								'v-bind:value': detailContentObj.mappingDataInfo.optionValue,
								'v-bind:disabled': detailContentObj.mappingDataInfo.optionDisabled
							})
						)
						.append(
							$('<span/>').addClass('custom-control-label').attr({
								'v-text': detailContentObj.mappingDataInfo.optionText
							}).css({'padding-left': '5px'})
						)
					).show();
			}
			
			function checkboxBasicType(detailContentObj) {
				detailContentObj
					.object
					.children('.input-group')
					.children('div[type=checkbox]')
					.removeClass()
					.addClass('custom-control custom-checkbox single')
					.append(
						$('<label/>').css({'padding-right': '30px'}).attr({
							'v-for': detailContentObj.mappingDataInfo.optionFor
						}).append(
							$('<input/>').addClass('custom-control-input').attr({
								type: 'checkbox',
								'v-model': detailContentObj.mappingDataInfo.vModel,
								'v-bind:value': detailContentObj.mappingDataInfo.optionValue,
								'v-bind:disabled': detailContentObj.mappingDataInfo.optionDisabled,
								'v-on:change': detailContentObj.mappingDataInfo.changeEvt ? detailContentObj.mappingDataInfo.changeEvt : null
							})
						)
						.append(
							$('<span/>').addClass('custom-control-label').attr({
								'v-text': detailContentObj.mappingDataInfo.optionText
							}).css({'padding-left': '5px'})
						)
					).show();				 
			}
			
			function gridBasicType(detailContentObj) {
				detailContentObj.object.append(
					$('<div/>')
						.addClass('table-responsive')
						.append($('<div/>').attr({ id: detailContentObj.id }))
				);
			}
			
			function propertyTabType(tabObj, rowDiv) {				
				if (tabObj.searchList) {
					var searchDiv = $('<div/>').addClass('viewGroup row').css({ width: '100%', margin: '0 0 1.25rem 0' });
										
					tabObj.searchList.forEach(function (searchObj) {
						var colDiv = $('<div/>').addClass(searchObj.className + ' searchArea-col');

						searchObj.searchSubList.forEach(function (searchSubObj) {
							var appendTag = $('<div/>').addClass('form-group');
							appendTag.append($('<label/>').append($('<b/>').attr('class', 'control-label').text(searchSubObj.name)));

							if ('select' == searchSubObj.type) {
								selectDiv = $('<select/>')
									.removeClass()
									.addClass('form-control')
									.css({ 'background-color': 'rgb(245, 246, 251)' })
									.attr({
										id: searchSubObj.mappingDataInfo.id,
										'v-model': searchSubObj.mappingDataInfo.selectModel,
										'v-on:change': searchSubObj.mappingDataInfo.changeEvt ? searchSubObj.mappingDataInfo.changeEvt : null
									});

								if (searchSubObj.placeholder) {
									selectDiv.append(
										$('<option/>')
											.attr({
												selected: 'selected',
												value: ' '
											})
											.text(searchSubObj.placeholder)
									);
								}

								selectDiv.append(
									$('<option/>').attr({
										'v-for': searchSubObj.mappingDataInfo.optionFor,
										'v-bind:value': searchSubObj.mappingDataInfo.optionValue,
										'v-text': searchSubObj.mappingDataInfo.optionText
									})
								);

								appendTag.append(selectDiv);
							}

							colDiv.append(appendTag);
						});

						searchDiv.append(colDiv);
					});

					rowDiv.append(searchDiv);
				}

				rowDiv.addClass('propertyTab');
				
				rowDiv.append(
					$('<div/>')
						.addClass('form-table form-table-responsive')
						.append(
							$('<div/>')
								.addClass('form-table-head')
								.append(
									$('<button/>')
										.addClass('btn-icon saveGroup updateGroup')
										.attr({
											type: 'button',
											'v-on:click': tabObj.addRowFunc
										})
										.append($('<i/>').addClass('icon-plus-circle'))
								)
						)
						.append(
							$('<div/>').addClass('form-table-wrap')
									   .append(
											   $('<div/>').addClass('form-table-body').attr({ 'v-for': '(elm, index) in ' + tabObj.mappingDataInfo })
									   )
						)
				);

				if (tabObj.isShowRemoveIconWhere) {
					rowDiv
						.find('.form-table-body')
						.append(
							$('<button/>')
								.addClass('btn-icon saveGroup updateGroup')
								.attr({
									type: 'button',
									'v-on:click': tabObj.removeRowFunc,
									'v-if': tabObj.isShowRemoveIconWhere
								})
								.append($('<i/>').addClass('icon-minus-circle'))
						)
						.append(
							$('<button/>')
								.addClass('btn-icon saveGroup updateGroup')
								.attr({
									type: 'button',
									'v-if': '!' + tabObj.isShowRemoveIconWhere
								})
								.append($('<i/>').addClass('icon-star'))
						);
				} else {
					rowDiv.find('.form-table-body').append(
						$('<button/>')
							.addClass('btn-icon saveGroup updateGroup')
							.attr({
								type: 'button',
								'v-on:click': tabObj.removeRowFunc
							})
							.append($('<i/>').addClass('icon-minus-circle'))
					);
				}
				
				tabObj.detailList.forEach(function (detailObj, detailIndex) {
					var type = detailObj.type;					
					var appendTag = null;
					
					var detailContentObj = {
							type: detailObj.type,
							regExpType: detailObj.regExpType? detailObj.regExpType : 'default',
							maxLength: getRegExpInfo(detailObj.regExpType? detailObj.regExpType : 'default').maxLength,
							appendTag: appendTag,
							mappingDataInfo: detailObj.mappingDataInfo,
							readonly: detailObj.readonly,
							clickEvt: detailObj.clickEvt,
							changeEvt: detailObj.changeEvt,
					}
					
					if ('text' == type) appendTag = textPropertyType(detailContentObj);
					else if ('search' == type) appendTag = searchPropertyType(detailContentObj); 
					else if ('customModal' == type) appendTag = customModalPropertyType(detailContentObj); 
					else if ('select' == type)  appendTag = selectPropertyType(detailContentObj);
					else if ('datalist' == type) appendTag = datalistPropertyType(detailContentObj);
					else if ('singleDaterange' == type) appendTag = singleDatePropertyType(detailContentObj);

					$('#' + tabObj.id)
						.find('.form-table-head')
						.append($('<label/>').addClass('col').text(detailObj.name));
					$('#' + tabObj.id)
						.find('.form-table-body')
						.append($('<div/>').addClass('col').append(appendTag));
				});
			}

			function textPropertyType(detailContentObj) {
				var dataInfoArr = detailContentObj.mappingDataInfo.split('.');								
				dataInfoArr.splice(1, 0, 'letter'); 
					
				var regExpDataInfo = dataInfoArr.join('.');
				var regExpInputInfo = {
					key : detailContentObj.mappingDataInfo,
					regExp:  getRegExpInfo(detailContentObj.regExpType).regExp,
				}
					
				detailContentObj.appendTag = $('<div/>')
								.addClass(detailContentObj.readonly? 'detail-content-common' : 'detail-content-regExp')
								.append(
									$('<input/>').addClass(detailContentObj.readonly? 'form-control readonly' : 'regExp-text view-disabled')
									.attr({
										'v-model': detailContentObj.mappingDataInfo,
										maxlength: detailContentObj.maxLength,
										readonly: detailContentObj.readonly,
										'v-on:input': !detailContentObj.readonly && detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ', elm)' : null
									})
								)	
			
				if(!detailContentObj.readonly) {
					detailContentObj.appendTag.append(
				  			$('<span/>').addClass('letterLength')
							.append($('<span/>').text('('))
							.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
							.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
					  	);
				}
								
				return detailContentObj.appendTag;
			}
			
			function searchPropertyType(detailContentObj) {
				detailContentObj.appendTag = $('<div/>')
					.addClass('input-group-append')
					.width('100%')
					.append(
						$('<input/>').addClass('form-control').attr({
							type: detailContentObj.type,
							'v-model': detailContentObj.mappingDataInfo.vModel,
							readonly: true,
							disabled: true,
						})
					)
					.append(
						$('<button/>')
							.addClass('btn saveGroup updateGroup')
							.attr({
								'v-on:click': 'openModal(' + JSON.stringify(detailContentObj.mappingDataInfo) + ', index)',
							})
							.css({
								'margin-left': '3px',
							})
							.append($('<i/>').addClass('icon-srch'))
							.append(searchBtn)
					)
					.append(
						$('<button/>')
							.addClass('btn saveGroup updateGroup')
							.attr({
								'v-on:click': detailContentObj.mappingDataInfo.vModel + ' = null;',
							})
							.css({
								'margin-left': '3px',
								'min-width': '0px',
								'padding-left': '0.5rem',
							})
							.append(
								$('<i/>').addClass('icon-reset').css({
									'margin-right': '0px',
								})
							)
					);
				
				if(detailContentObj.clickEvt) {
					detailContentObj.appendTag.attr({'v-on:click': detailContentObj.clickEvt});
					detailContentObj.appendTag.children('input[type=search]').addClass('underlineTxt');
					detailContentObj.appendTag.css({cursor: 'pointer'});
				}
				
				return detailContentObj.appendTag;
			
			}
			
			function customModalPropertyType(detailContentObj) {
				detailContentObj.appendTag = $('<div/>')
					.addClass('input-group-append ')
					.width('100%')
					.append(
						$('<input/>').addClass('form-control').attr({
							type: detailContentObj.type,
							'v-model': detailContentObj.mappingDataInfo.vModel,
							readonly: true,
							disabled: true,
						})
					)
					.append(
						$('<button/>')
							.addClass('btn saveGroup updateGroup')
							.attr({
								'v-on:click': 'openCustomModal(' + JSON.stringify(detailContentObj.mappingDataInfo) + ', index)',
							})
							.css({
								'margin-left': '3px',
							})
							.append($('<i/>').addClass('icon-srch'))
							.append(searchBtn)
					)
					.append(
						$('<button/>')
							.addClass('btn saveGroup updateGroup')
							.attr({
								'v-on:click': detailContentObj.mappingDataInfo.vModel + ' = null;',
							})
							.css({
								'margin-left': '3px',
								'min-width': '0px',
								'padding-left': '0.5rem',
							})
							.append(
								$('<i/>').addClass('icon-reset').css({
									'margin-right': '0px',
								})
							)
					);
				
				return detailContentObj.appendTag;
			}
			
			function selectPropertyType(detailContentObj) {
				detailContentObj.appendTag = $('<select/>')
					.attr({
						'v-model': detailContentObj.mappingDataInfo.selectModel,
						'v-on:change': detailContentObj.changeEvt,
					})
					.addClass('form-control view-disabled')
					.append(
						$('<option/>').attr({
							'v-for': detailContentObj.mappingDataInfo.optionFor,
							'v-bind:value': detailContentObj.mappingDataInfo.optionValue,
							'v-text': detailContentObj.mappingDataInfo.optionText,										
						})
					);	
				
				return detailContentObj.appendTag;
			}
			
			function datalistPropertyType(detailContentObj) {
				var detailDataInfoArr = detailContentObj.mappingDataInfo.vModel.split('.');								
				detailDataInfoArr.splice(1, 0, 'letter'); 
				
				var detailDatalistRegInfo = detailDataInfoArr.join('.');
				var detailDatalistRegInputInfo = {
					key : detailContentObj.mappingDataInfo.vModel,
					regExp:  getRegExpInfo(detailContentObj.regExpType).regExp,
				}
			
				detailContentObj.appendTag = $('<div/>').addClass('detail-content-regExp')
							.append(
								$('<input/>').addClass('regExp-text view-disabled ')
								.attr({
									'v-model': detailContentObj.mappingDataInfo.vModel,
									maxlength: detailContentObj.maxLength,
									'v-on:input': detailContentObj.regExpType? 'inputEvt(' + JSON.stringify(detailDatalistRegInputInfo)  + ', elm)' : null,
									'v-on:change': detailContentObj.changeEvt,
									'list' : detailContentObj.mappingDataInfo.dataListId,
								})
							)
					  		.append(
					  			$('<span/>').addClass('letterLength')
								.append($('<span/>').text('('))
								.append($('<span/>').attr({ 'v-text': detailDatalistRegInfo }))
								.append($('<span/>').text('/' + detailContentObj.maxLength + ')'))
							)
							.append(
								$('<datalist/>')
								.attr({
									id: detailContentObj.mappingDataInfo.dataListId,
								})
								.append(
									$('<option/>').attr({
										'v-for': detailContentObj.mappingDataInfo.dataListFor,
										'v-text': detailContentObj.mappingDataInfo.dataListText,
									})
								)
							);
				return detailContentObj.appendTag;			
			}		
			
			function singleDatePropertyType(detailContentObj) {
				detailContentObj.appendTag = $('<input/>')
					.addClass('form-control view-disabled input-date')
					.attr({
						'v-bind:id': "'" + detailContentObj.mappingDataInfo.id + "' + index",
						'v-model': detailContentObj.mappingDataInfo.vModel,
						'data-drops': detailContentObj.mappingDataInfo.dataDrops ? detailContentObj.mappingDataInfo.dataDrops : 'up',
						autocomplete: 'off',
					})
					.show();
				
				return detailContentObj.appendTag;			
			}
			
			function treeTabType(tabObj, rowDiv) {
				rowDiv.append(
					$('<div/>')
						.addClass('table-responsive')
						.append(
							$('<div/>').attr({
								id: tabObj.id + '_tree',
							})
						)
				);
			}
			
			function customTabType(tabObj, rowDiv, tabDiv) {
				var appendDiv = tabObj.noRowClass ? tabDiv : rowDiv;

				if (tabObj.noRowClass) tabDiv.empty();

				appendDiv.append(tabObj.getDetailArea());			
			}
			
			
			tabList.forEach(function (tabObj, tabIndex) {
				// make tab menu
				var type = tabObj.type;
				var tabBar = $('#panel').find('.nav-item-origin').clone();

				tabBar.removeClass().addClass('nav-item');
				tabBar
					.children('.nav-link')
					.addClass(0 == tabIndex ? 'active' : '')
					.attr({
						href: '#' + tabObj.id
					})
					.text(tabObj.name);

				if (tabObj.clickEvt) {
					tabBar.off('click').on('click', function (evt) {
						tabObj.clickEvt();
					});
				}

				tabBar.show();

				$('#panel').find('#item-result-parent').before(tabBar);

				// make tab detail area
				var tabDiv = $('<div/>').attr({
					id: tabObj.id
				});
				tabDiv.addClass('tab-pane ' + (0 == tabIndex ? 'active' : ''));
				tabDiv.addClass(tabObj.isSubResponsive ? 'sub-responsive' : '');

				$('#panel').find('#process-result').before(tabDiv);

				var rowDiv = $('<div/>').addClass('row frm-row');
				tabDiv.append(rowDiv);

				if ('basic' == type) basicTabType(tabObj, rowDiv, tabDiv);
				else if ('property' == type) propertyTabType(tabObj, rowDiv);
				else if ('tree' == type) treeTabType(tabObj, rowDiv);
				else if ('custom' == type) customTabType(tabObj, rowDiv, tabDiv);
			});

			$('.nav-item-origin').remove();
			$('.form-group-origin').remove();

			if (panelButtonList) {
				$.each($('#panel').find('#panel-footer').find('.ml-auto').children(), function (index, element) {
					if (!panelButtonList[element.id]) {
						$(element).remove();
					} else {
						$(element).show();
					}
				});
			} else {
				$('#panel').find('#panel-footer').find('.ml-auto').empty();
			}

			if (isHideResultTab) {
				$('#panel').find('#item-result-parent').remove();
				$('#panel').find('#process-result').remove();
			}
		};

		this.openModal = function (openModalParam, regExpInfo) {
			var url = prefixUrl + '/api/page/customPage' + openModalParam.url + '?popupId=' + viewName + 'ModalSearch';
			
			var modalTitle = openModalParam.modalTitle;
			var callBackFuncName = openModalParam.callBackFuncName;

			var modalSize = '-lg';

			if (openModalParam.modalParam && openModalParam.modalParam.modalSize) {
				var size = openModalParam.modalParam.modalSize;
				modalSize = 'small' === size ? '-sm' : 'extraLarge' === size ? '-xl' : '';
			}

			var modalHtml = '';

			modalHtml += '<div id="' + viewName + 'ModalSearch"  class="modal fade" tabindex="-1" role="dialog" style="background: none !important;">';
			modalHtml += '    <div class="modal-dialog modal-dialog-centered modal' + modalSize + ' modal-dialog-scrollable">';
			modalHtml += '        <div class="modal-content">';
			modalHtml += '            <div class="modal-header">';
			modalHtml += '                <h2 class="modal-title">' + modalTitle + '</h2>';
			modalHtml += '                <button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>';
			modalHtml += '            </div>';
			modalHtml += '            <div class="modal-body"></div>';
			modalHtml += '            <div class="modal-footer">';
			modalHtml += '                <button type="button" class="btn" data-dismiss="modal" id="modalClose">Close</button>';
			modalHtml += '            </div>';
			modalHtml += '        </div>';
			modalHtml += '    </div>';
			modalHtml += '</div>';

			$('#' + viewName + 'ModalSearch').remove();

			$('body').append($(modalHtml));

			window.$startSpinner(openModalParam.modalParam ? openModalParam.modalParam.spinnerMode : null);
			
			$('#' + viewName + 'ModalSearch').on('show.bs.modal', function (e) {
				function step() {
					if (0 == $('#' + viewName + 'ModalSearch').length) {
						cancelAnimationFrame(rafId);
						return;
					}

					var nextItem = $('#' + viewName + 'ModalSearch').next();

					if (0 < nextItem.length && nextItem.hasClass('modal-backdrop')) {
						if (!(openModalParam.modalParam && 'full' == openModalParam.modalParam.spinnerMode)) {
							var ctWidth = $('#ct').outerWidth(true);
							nextItem.width(ctWidth).css({ left: 'auto', right: '0px' });
							$('#' + viewName + 'ModalSearch')
								.width(ctWidth)
								.css({ left: 'auto', right: '0px' });
						}

						$('.spinnerBg').hide();
						cancelAnimationFrame(rafId);
						return;
					}

					rafId = requestAnimationFrame(step);
				}

				var rafId = requestAnimationFrame(step);
			});

			$('#' + viewName + 'ModalSearch').on('shown.bs.modal', function (e) {
				window.$stopSpinner(function() {
					$('.spinnerBg').show();
				});
			});

			$('#' + viewName + 'ModalSearch').on('hidden.bs.modal', function (e) {
				window.$stopSpinner();
				$('#' + viewName + 'ModalSearch').remove();
			});

			$('#' + viewName + 'ModalSearch').data('callBackFunc', function(loadParam) {
				this[callBackFuncName](loadParam);
				
				if (regExpInfo) {
					setLengthCnt.call(this, regExpInfo);	
				}
			}.bind(this));

			if (openModalParam.modalParam) {
				$('#' + viewName + 'ModalSearch').data('modalParam', openModalParam.modalParam);
			}

			$('#' + viewName + 'ModalSearch').find($('.modal-body')).load(url, function() {
				document.querySelector('#' + viewName + 'ModalSearch').querySelector('[data-ready]').dispatchEvent(new CustomEvent('ready'));	
			});
			
			$('#' + viewName + 'ModalSearch').modal('show');
		};
		
		this.openCustomModal = function(modalInfo, index) {
	    	var modalTitle = modalInfo.modalTitle;
	    	var spinnerMode = modalInfo.spinnerMode;
	    	var bodyHtml = modalInfo.bodyHtml;
	    	var shownCallBackFunc = modalInfo.shownCallBackFunc;
	    	var okCallBackFunc = modalInfo.okCallBackFunc;
	    	
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
	        modalHtml += '                <button type="button" class="btn btn-primary" id="modalOk" >OK</button>' ;
	        modalHtml += '                <button type="button" class="btn" data-dismiss="modal" id="modalClose">Close</button>' ;
	        modalHtml += '            </div>' ;
	        modalHtml += '        </div>' ;
	        modalHtml += '    </div>' ;
	        modalHtml += '</div>' ;

	        $('#' + viewName + 'ModalSearch').remove() ;
	        
	        $("body").append($(modalHtml)) ;
	        	        
	        $('#' + viewName + 'ModalSearch').find('.modal-body').append($(bodyHtml));
	        
	        initModalArea(viewName + 'ModalSearch', spinnerMode, shownCallBackFunc);
	        
	        $('#' + viewName + 'ModalSearch').modal('show');
	        
			$('#' + viewName + 'ModalSearch').find('#modalOk').off().on('click', function() {
				okCallBackFunc() ;
			});	
	    };
	}

	return new createPageObj();
}

function panelOpen(o, object, callBackFunc) {
	$('#panel').find('#panel-header').find('.ml-auto').show();

	if (window.vmMain) {
		window.vmMain.$nextTick(function () {
			setPanel();
		});
	} else {
		setPanel();
	}

	function setPanel() {
		if ('sidebar' != o) {
			document.querySelector('#panel').dispatchEvent(new CustomEvent('detailReady'));	
			
			if (o != 'done') $('#accordionResult').children('.collapse-item').remove();

			if (window.vmMain) window.vmMain.panelMode = o;

			if (o == 'add') {
				$('#panel').find('.sub-bar-tit').text('Insert');
				$('#panel').find('.updateGroup').hide();
				$('#panel').find('.viewGroup').hide();
				$('#panel').find('.saveGroup').show();

				$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', false);
				$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false);
				$('#panel').find('.form-control').filter('[name=detail_type_search]').attr('readonly', true);
				$('#panel').find('.form-control').filter('[name=detail_type_cron]').attr('readonly', false);

				$('#panel').find('.dataKey').not('[name=detail_type_search]').attr('readonly', false);
				
				$('#panel').find('.detail-content-common').find('input:not([readonly])').parent().removeClass().addClass('detail-content-regExp');				
				$('#panel').find('.detail-content-regExp').children('input').removeClass('form-control').addClass('regExp-text');
				$('#panel').find('.detail-content-regExp').children('input[type="password"]').removeClass('form-control').addClass('regExp-password');
			
				if ($('#panel').find('.warningLabel, .letterLength')) $('#panel').find('.warningLabel, .letterLength').show();

				if (window.vmMain) {
					window.vmMain.initDetailArea(object);
					window.vmMain.$forceUpdate();
				}
			} else if (o == 'modify') {
				$('#panel').find('.sub-bar-tit').text('Update');
				$('#panel').find('.viewGroup').hide();
				$('#panel').find('.saveGroup').hide();
				$('#panel').find('.updateGroup').show();

				$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', false);
				$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false);
				$('#panel').find('.form-control').filter('[name=detail_type_search]').attr('readonly', true);

				$('#panel').find('.dataKey').attr('readonly', true);

				$('#panel').find('.detail-content-common').find('input:not([readonly])').parent().removeClass().addClass('detail-content-regExp');	
				$('#panel').find('.detail-content-regExp').children('input').removeClass('form-control').addClass('regExp-text');
				$('#panel').find('.detail-content-regExp').children('input[type="password"]').removeClass('form-control').addClass('regExp-password');
			
				if ($('#panel').find('.warningLabel, .letterLength')) $('#panel').find('.warningLabel, .letterLength').show();
			} else if (o == 'detail' || o == 'done') {
				$('#panel').find('.sub-bar-tit').text('Detail');
				$('#panel').find('.updateGroup').hide();
				$('#panel').find('.saveGroup').hide();
				$('#panel').find('.viewGroup').show();

				$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', true);
				$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', true);

				$('#panel').find('.dataKey').attr('readonly', true);
				
				$('#panel').find('.detail-content-regExp').removeClass().addClass('detail-content-common');	
				$('#panel').find('.detail-content-common').find('input').removeClass('regExp-text').addClass('form-control');
				$('#panel').find('detail-content-common').find('input[type="password"]').removeClass('regExp-password').addClass('form-control');

				if ($('#panel').find('.warningLabel, .letterLength')) $('#panel').find('.warningLabel, .letterLength').hide();
			}
			
			if ('detail' === o || 'done' === o || 'modify' === o) {
				var dataObj = parseFlattenObj(window.vmMain.object);
				
				var selectedInfoTitleSpan = $('<span/>').addClass('sub-bar-selected-tit ellipsis').css({ width : 'calc(100% - ' + ('modify' === o ? 80 : 65) + 'px)' });
				
				var selectedInfoTitle = '';

				var selectedMenuPathIdList = JSON.parse(sessionStorage.getItem('selectedMenuPathIdList'));
				var menuId = selectedMenuPathIdList[selectedMenuPathIdList.length - 1];
				var menuDetailConstants = constants.detail[menuId];		
				
				var selectedInfoTitleKey = null;
				
				if (menuDetailConstants && menuDetailConstants.selectedInfoTitleKey) {
					selectedInfoTitleKey = menuDetailConstants.selectedInfoTitleKey; 
				} else if (window.vmMain.pk && 0 < Object.keys(window.vmMain.pk).length){
					selectedInfoTitleKey = Object.keys(window.vmMain.pk);
				}
				
				if (selectedInfoTitleKey) {
					selectedInfoTitleKey.forEach(function(key) {
						if ('undefined' === typeof dataObj[key]) return;

						if (0 === String(dataObj[key]).trim().length) return;

						selectedInfoTitle += String(dataObj[key]);

						if (1 < selectedInfoTitleKey.length) selectedInfoTitle += ', ';
					});
				}

				if (0 < selectedInfoTitle.length) {
					selectedInfoTitle = selectedInfoTitle.trim();
					
					if (endsWith(selectedInfoTitle, ',')) {
						selectedInfoTitle = selectedInfoTitle.substring(0, selectedInfoTitle.length - 1);
					}
					
					selectedInfoTitle = ' - ' + selectedInfoTitle;
				}
				
				selectedInfoTitleSpan.text(selectedInfoTitle);
				
				$('#panel').find('.sub-bar-tit').css({ width : 'calc(100% - ' + ('modify' === o ? 170 : 125) + 'px)' }).append(' ').append(selectedInfoTitleSpan.attr({title: selectedInfoTitle ? selectedInfoTitle.substr(3) : '' }));
			}
		}

		var $wrap = $('#wrap');
		var a = -$wrap.scrollTop();
		var target = $('#' + ('sidebar' != o ? 'panel' : 'sidebar'));
		var $body = $('body');

		$wrap.css('top', a);

		target.data('backdrop') !== false && target.after('<div class="backdrop"></div>');

		if ($body.hasClass('fixed')) {
			$body.removeClass('panel-open-detail panel-open-add panel-open-mod panel-open-done fixed');
			$('.panel').hide();
		}

		if (o != 'done' && $('#item-result').hasClass('active')) $('#panel').find('.flex-shrink-0').children().first().children('a').trigger('click');

		$body.addClass('fixed');

		target.show(0, function () {
			$body.addClass('panel-open-' + o);
			
			windowResizeSearchGrid();

			if (callBackFunc) {
				callBackFunc();
			}
		});
	}
}

function setPanelData(param) {
	var mode = param.mode;
	var initDataFunc = param.initDataFunc;

	if (mode == 'add') {
		$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', false);
		$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false);
		$('#panel').find('.form-control').filter('[name=detail_type_search]').attr('readonly', true);
		$('#panel').find('.form-control').filter('[name=detail_type_cron]').attr('readonly', false);
		$('#panel').find('.dataKey').not('[name=detail_type_search]').attr('readonly', false);
	} else if (mode == 'modify') {
		$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', false);
		$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', false);
		$('#panel').find('.form-control').filter('[name=detail_type_search]').attr('readonly', true);
		$('#panel').find('.dataKey').attr('readonly', true);
	} else if (mode == 'detail' || mode == 'done') {
		$('#panel').find('.view-disabled').not("input[type='checkbox']").attr('readonly', true);
		$('#panel').find('.view-disabled').filter("input[type='checkbox']").attr('disabled', true);

		$('#panel').find('.dataKey').attr('readonly', true);
	}
	
	if(initDataFunc) initDataFunc();
}

function panelClose(o) {
	if (window.vmMain) window.vmMain.panelMode = null;

	var ct = $('.wrap');
	
	var originScroll = -ct.position().top;
	
	$('body').removeClass('panel-open-' + o).find('.backdrop').remove();
	
	$('#' + window.mainListAreaId).find('.table-responsive').height('auto');

	$('#' + o).hide();
	
	$('body').removeClass('fixed');
	
	if (originScroll != -0) {
		ct.scrollTop(originScroll);
	}
	
	ct.removeAttr('style');
	
	windowResizeSearchGrid();
}

function getMakeGridObj() {
	var grid = null;
	var gridOptions = null;
	var searchUrl = null;
	var totalCntUrl = null;
	var isModalGrid = false;
	var isGridView = false;

	var paging = null;
	var totalCnt = 0;
	var dataList = [];
	var pageNo = 1;
	
	var searchObj = null;
	var searchCallback = null;

	var sortColumnName = null;
	var isServerPaging = false;
	var serverPagingDataArr = [];
	
	var listObjectAreaId = null;
	
	function makeGridObj() {
		this.setConfig = function (options, paramIsModalGrid, formatterData) {
			options = constants.grid.gridOptionFunc(options);
			
			searchUrl = options.searchUrl;
			totalCntUrl = options.totalCntUrl;
			paging = options.paging;
			isModalGrid = paramIsModalGrid;
			
			gridOptions = makeGridOptions(options, formatterData);

			if(paging) {
				isServerPaging = 'serverPaging' === paging.side;
				
				if (paging.isUse) {
					gridOptions.pageOptions = {
						useClient: true
					};
				}
			};
			
            grid = new tui.Grid(gridOptions);
            
            if (paging && paging.isUse) {
				grid.on('beforePageMove', function(info) {
					pageNo = Number(info.page);
					
					if (isServerPaging) {						
						getDataList(function() {
							searchCallback({
								currentCnt: numberWithComma(dataList.length),
								totalCnt: numberWithComma(dataList.length),
							});
						});
					} else {
						if ('server' === paging.side) {
							if (pageNo > Math.ceil(grid.getData().length / searchObj.pageSize)) {
								getDataList(function() {
									paging.setCurrentCnt(grid.getData().length);
								});
							}
						}
					}
				});

				grid.on('afterPageMove', function() {
					if (isModalGrid) {
						grid.refreshLayout();	
					} else {
						window.resizeFunc();	
					}
				});            	
            }
            
            grid.on('click', function(info) {
            	if ('columnHeader' !== info.targetType) return;
            	
            	var columns = info.instance.getSortState().columns;
            	
				if (!columns) return;

				if (0 === columns.length) return;
				
            	sortColumnName = columns[0].columnName;
				
				if (paging.isUse && isServerPaging) {
					// reset data & sort
					getDataList(function() {
						searchCallback({
							currentCnt: numberWithComma(dataList.length),
							totalCnt: numberWithComma(dataList.length)
						});
					});
				} else {
					// sort
					var sortColumnList = getSortColumnList();
					var sortColumnNameList = Array.from(sortColumnList.sortColumnNameList);
					var sortColumnTypeList = Array.from(sortColumnList.sortColumnTypeList);

					if (0 === sortColumnNameList.length) return;
					
					for (var idx = 1; idx < sortColumnNameList.length; idx++) {
						// 연관 칼럼 정렬
						grid.sort(sortColumnNameList[idx], sortColumnTypeList[idx], true);
					}
				}
			});  
		};

		this.noDataHidePage = function (listAreaId) {
			if ('none' === $('#' + listAreaId).children('.empty').css('display'))
				return;
			
			listObjectAreaId = listAreaId;

			$('#' + listObjectAreaId).children('.empty').hide();
			$('#' + listObjectAreaId).children('.table-responsive').show();
		};

		this.search = function (obj, callback) {
			pageNo = 1;
			sortColumnName = null;
			sortDirection = null;

			dataList = [];
			
			searchObj = JSON.parse(JSON.stringify(obj));
			searchCallback = callback;
			
			if(totalCntUrl) {
				getTotalCnt(getDataList.bind(null, function() {					
					if(!searchCallback) return;
					
					$('#' + listObjectAreaId + ' [afterload]').css('display', 'flex');
					
					searchCallback({ 
						currentCnt: numberWithComma(dataList.length), 
						totalCnt: numberWithComma(totalCnt)
					});
				}));				
			} else {
				getDataList(function(res) {
					$('#' + listObjectAreaId + ' [afterload] #currentCnt').css('display', 'none');
					$('#' + listObjectAreaId + ' [afterload]').css('display', 'flex');
					
					if(!searchCallback) return;
					
					searchCallback($.extend(true, {
						currentCnt: numberWithComma(dataList.length),
						totalCnt: numberWithComma(dataList.length)
					}, res))
				});
			}
		};
		
		this.getSearchGrid = function () {
			return grid;
		}
		
		function getTotalCnt(callback) {
			(new HttpReq(totalCntUrl)).read(searchObj, function(res) {
				
                var selectedMenuPathIdList = JSON.parse(sessionStorage.getItem('selectedMenuPathIdList'));
				var menuId = selectedMenuPathIdList[selectedMenuPathIdList.length - 1];
				var maxListCount = constants.grid.maxListCount[menuId];
				
				if(maxListCount && Number(res.object) > maxListCount) {
					window._alert({
                    	type: 'warn',
                    	message: searchCriteriaLabel(maxListCount)
                    });
					
					if(!isGridView) {
						$('#' + listObjectAreaId).children('.empty').show();
						$('#' + listObjectAreaId).children('.table-responsive').hide();						
					}
				} else {
					totalCnt = Number(res.object);
					
					if(!isGridView) isGridView = true;
					
					callback();	
				}
			}, false);
		}		
		
		function getDataList(callback) {
			var sortColumnList = getSortColumnList();		
			var sortColumnNameList = Array.from(sortColumnList.sortColumnNameList);
			var sortColumnTypeList = Array.from(sortColumnList.sortColumnTypeList);
			
			var param = { object: searchObj, limit: null, next: null, reverseOrder: false };		
			
			if (paging && paging.isUse) {
				if ('client' === paging.side) {
					param.limit = totalCnt;
				} else if ('server' === paging.side) {
					var rtnPageOption = constants.grid.pageOptionFunc(searchUrl);
					
					var limit = rtnPageOption.limit;
					var ascending = rtnPageOption.ascending;
					
					param.limit = limit;
					param.reverseOrder = !ascending;

					if (0 < dataList.length) {
						param.next = dataList[dataList.length - 1];
					}
				} else if ('serverPaging' === paging.side) {
					delete param.next;
					delete param.reverseOrder;

					param.limit = searchObj.pageSize;
					param.pageNo = pageNo;
					param.sortColumnInfo = { nameList : sortColumnNameList, reverseList : sortColumnTypeList.map(function(columnType) { return !columnType }) }

					if (null === serverPagingDataArr || totalCnt !== serverPagingDataArr.length) {
						serverPagingDataArr = Array.from({ length: totalCnt }, function() { return {} });
					}
				}				
			} else {
				if (paging && 'serverPaging' === paging.side) {
					delete param.next;
					delete param.reverseOrder;

					param.pageNo = pageNo;
					param.sortColumnInfo = { nameList : [], typeList : [] }
				}
			}
			
			(new HttpReq(searchUrl)).read(param, function(res) {
				var sortColumnList = getSortColumnList();		
				var sortColumnNameList = Array.from(sortColumnList.sortColumnNameList);
				var sortColumnTypeList = Array.from(sortColumnList.sortColumnTypeList);
					
				var pageState = null; 
					
				var isUse = paging && paging.isUse;
				
				if (isUse) {
					pageState = {
						page: pageNo,
						perPage: Number(searchObj.pageSize)
					};
				}
					
				if (isUse && isServerPaging) {
					//serverPaging
					pageState.totalCount = totalCnt;
						
					var startRowIdx = (pageNo - 1) * Number(searchObj.pageSize);
						
					res.object.forEach(function(info, idx) {
						serverPagingDataArr[startRowIdx + idx] = parseFlattenObj(info);
					});
						
					dataList = serverPagingDataArr.slice();
						
					if(0 < sortColumnNameList.length) {
						sortColumnNameList.forEach(function(sortColumnName, idx) {
							grid.resetData(serverPagingDataArr, {
								pageState: pageState,
								sortState: { columnName: sortColumnName, ascending: sortColumnTypeList[idx], multiple: true }
							});
						});
					} else {
						grid.resetData(serverPagingDataArr, { pageState: pageState });
					}
				} else {
					// isUse가 false일 때
					// client, server
					dataList = dataList.concat(res.object.map(function(info) { 
						return parseFlattenObj(info);
					}));
						
					if (isUse) pageState.totalCount = 'server' === paging.side? totalCnt : dataList.length;
						
					var resetDataList = $.extend(true, {}, dataList);
						
					grid.resetData(dataList, { pageState: pageState });
						
					sortColumnNameList.forEach(function(sortColumnName, idx) {
						grid.sort(sortColumnName, sortColumnTypeList[idx], true);
					});
				}
					
				if (isModalGrid) {
					grid.refreshLayout();	
				} else {
					window.resizeFunc();	
				}
				
				if(callback) callback(res);
			}, true);
		}
		
		function getSortColumnList() {
			var column = grid.getSortState().columns[0];
			
			var sortColumnNameList = [];
			var sortColumnTypeList = [];

			var isDefaultSort = 'sortKey' === column.columnName;

			if (isDefaultSort && ('undefined' === typeof gridOptions.sortColumn || null !== sortColumnName)) {
				return {
					sortColumnNameList: sortColumnNameList,
					sortColumnTypeList: sortColumnTypeList
				};
			}

			if (0 < gridOptions.columns.filter(function(column) { return column.sortable }).length) {
				var columnInfo = gridOptions.columns.filter(function(columnInfo) {
					if (isDefaultSort) {
						return gridOptions.sortColumn === columnInfo.name;
					} else {
						return columnInfo.name === column.columnName;
					}					
				})[0];
				
				var name = columnInfo.name;
				var sortingType = columnInfo.sortingType;
				var sortWithColumn = columnInfo.sortWithColumn;
				var sortWithColumnType = columnInfo.sortWithColumnType;

				sortColumnNameList.push(name);
				sortColumnTypeList.push(isDefaultSort ? (sortingType ? 'asc' === sortingType : true) : column.ascending);

				var isReverse = isDefaultSort
					? false
					: ('undefined' === typeof sortingType ? true : 'asc' === sortingType ? true : false) !== sortColumnTypeList[0];

				if (sortWithColumn) {
					sortWithColumn.forEach(function(sortWithColumnName, idx) {
						sortColumnNameList.push(sortWithColumnName);

						var ascending = sortWithColumnType && sortWithColumnType[idx] ? 'asc' === sortWithColumnType[idx] : true;

						if (isReverse) ascending = !ascending;

						sortColumnTypeList.push(ascending);
					});
				}
			}

			return {
				sortColumnNameList: sortColumnNameList,
				sortColumnTypeList: sortColumnTypeList
			};		
		}
	}

	return new makeGridObj();
}