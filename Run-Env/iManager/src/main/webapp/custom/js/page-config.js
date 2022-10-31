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

			searchList.forEach(function (searchInfo, index) {
				var type = searchInfo.type;
				var mappingDataInfo = searchInfo.mappingDataInfo;
				var name = searchInfo.name;
				var placeholder = searchInfo.placeholder;
				var regExpType = searchInfo.regExpType? searchInfo.regExpType : 'default';				
				var maxLength = getRegExpInfo(regExpType).maxLength;

				if (type === 'text') {					
					var regExpDataInfo = mappingDataInfo.replace('object', 'letter');
					var regExpInputInfo = {
						key : mappingDataInfo,
						regExp: getRegExpInfo(regExpType).regExp,
					};
					
					var letterLength = $('<span/>').addClass('letterLength')
										.append($('<span/>').text('('))
										.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
										.append($('<span/>').text('/' + maxLength + ')'));						
					
					
					beforeSelector.before(
						$('<div/>')
							.addClass('col')
							.append(
								$('<label/>')
									.addClass('form-control-label reset')
									.append($('<b/>').addClass('control-label').text(name).append(letterLength))
									.append( $('<input/>').addClass('form-control')
											.attr({
												id: searchInfo.id, 
												'v-model': mappingDataInfo, 
												placeholder: placeholder, 
												maxlength: maxLength,
												'v-on:keyup.enter': 'search',
												'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
											})
									)
									.append(
										$('<i/>')
											.addClass('icon-close')
											.attr({ 'v-on:click.prevent': mappingDataInfo + ' = null; '+ (regExpDataInfo? (regExpDataInfo  +' = 0;') : '') })
									)
							)
					);
				} else if (type === 'select') {
					var selectDiv = $('<select/>').addClass('form-control selectpicker').attr({ 'v-model': mappingDataInfo.selectModel, id: mappingDataInfo.id, 'data-size': '10' });

					if (searchInfo.changeEvt) selectDiv.attr({ 'v-on:change': searchInfo.changeEvt });

					if (!searchInfo.isHideAllOption) selectDiv.append($('<option/>').attr({ selected: 'selected', value: ' ' }).text(placeholder));

					var appendOption = $('<option/>').attr({ 'v-for': mappingDataInfo.optionFor, 'v-bind:value': mappingDataInfo.optionValue, 'v-text': mappingDataInfo.optionText });

					if (mappingDataInfo.optionIf) appendOption.attr({ 'v-if': mappingDataInfo.optionIf });

					selectDiv.append(appendOption);

					beforeSelector.before(
						$('<div/>')
							.addClass('col')
							.append($('<label/>').addClass('form-control-label label-select').append($('<b/>').attr('class', 'control-label').text(name)).append(selectDiv))
					);
				} else if (type === 'daterange') {
					mappingDataInfo.daterangeInfo.forEach(function (daterangeObj, idx) {
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
												placeholder: placeholder,
												autocomplete: 'off',
											})
										)
								)
						);
					});
				} else if (type === 'dateCalc') {
					var unitObj = { h: timeHour, m: timeMinute, s: timeSecond };

					var selectDiv = $('<select/>')
						.addClass('form-control timerRange')
						.attr({ 'v-model': mappingDataInfo.selectModel, id: mappingDataInfo.id, 'v-on:change': mappingDataInfo.changeEvt + '("' + mappingDataInfo.unit + '")' });

					selectDiv.append($('<option/>').attr({ selected: 'selected', value: '0' }).text(placeholder));
					selectDiv.append(
						$('<option/>')
							.attr({ 'v-for': mappingDataInfo.optionFor, 'v-bind:value': mappingDataInfo.optionValue })
							.text('{{' + mappingDataInfo.optionText + '}}' + unitObj[mappingDataInfo.unit])
					);

					beforeSelector.before(
						$('<div/>')
							.addClass('col')
							.append($('<label/>').addClass('form-control-label label-select').append($('<b/>').addClass('control-label').text(name)).append(selectDiv))
					);
				} else if (type === 'singleDaterange') {
					beforeSelector.before(
						$('<div/>')
							.attr('class', 'col')
							.append(
								$('<label/>')
									.attr('class', 'form-control-label')
									.append($('<b/>').attr('class', 'control-label').text(name))
									.append(
										$('<input/>').attr({
											'v-model': mappingDataInfo.vModel,
											id: mappingDataInfo.id,
											class: 'form-control input-filedate',
											placeholder: placeholder,
											readonly: true,
										})
									)
							)
					);
				} else if (type === 'modal') {								
					var regExpDataInfo = mappingDataInfo.vModel.replace('object', 'letter');
					var regExpInputInfo = {
						key : mappingDataInfo.vModel,
						regExp: getRegExpInfo(regExpType).regExp,
					};
				
					var letterLength = $('<span/>').addClass('letterLength')
										.append($('<span/>').text('('))
										.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
										.append($('<span/>').text('/' + maxLength + ')'));
					
					
					beforeSelector.before(
						$('<div/>')
							.addClass('col')
							.append(
								$('<label/>')
									.addClass('form-control-label reset')
									.append(
										$('<b/>')
											.addClass('control-label')
											.text(name)
											.append(
												$('<i/>')
													.addClass('icon-srch')
													.attr({ 'v-on:click': 'openModal(' + JSON.stringify(mappingDataInfo) + ',' + JSON.stringify(regExpInputInfo) + ')' })
													.css({
														'line-height': 'unset',
														'padding-left': '5px',
													})
											)
											.append(letterLength)
									)
									.append( $('<input/>').addClass('form-control')
											.attr({
												'v-model': mappingDataInfo.vModel, 
												placeholder: placeholder, 
												maxlength: maxLength,
												'v-on:keyup.enter': searchInfo.enterEvt ? searchInfo.enterEvt : 'search',
												'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
											})
									)
									.append(
										$('<i/>')
											.addClass('icon-close')
											.attr({ 'v-on:click.prevent': mappingDataInfo.vModel + ' = null;'+ (regExpDataInfo? (regExpDataInfo  +' = 0;') : '') })
									)
							)
					);
				} else if (type === 'datalist') {
					var regExpDataInfo = mappingDataInfo.vModel.replace('object', 'letter');
					var regExpInputInfo = {
						key : mappingDataInfo.vModel,
						regExp: getRegExpInfo(regExpType).regExp,
					};
					
					var letterLength = $('<span/>').addClass('letterLength')
										.append($('<span/>').text('('))
										.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
										.append($('<span/>').text('/' + maxLength + ')'));						
					
					beforeSelector.before(
						$('<div/>')
							.attr('class', 'col')
							.append(
								$('<label/>')
									.attr('class', 'form-control-label')
									.append($('<b/>').attr('class', 'control-label').text(name).append(letterLength))
									.append(
										$('<input/>').attr({
											class: 'form-control',
											list: mappingDataInfo.dataListId,
											'v-model': mappingDataInfo.vModel,
											placeholder: placeholder,
											maxlength: maxLength,
											'v-on:keyup.enter': 'search',
											'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
										})
									)
									.append(
										$('<datalist/>')
											.attr({
												id: mappingDataInfo.dataListId,
											})
											.append(
												$('<option/>').attr({
													'v-for': mappingDataInfo.dataListFor,
													'v-text': mappingDataInfo.dataListText,
												})
											)
									)
							)
					);
				}

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
						if ($(element).hasClass('ml-auto')) {
							$(element)
								.children()
								.each(function (subIndex, subElement) {
									if (!$(subElement).attr('id')) return;
									mainButtonIdList.push($(subElement).attr('id'));
								});
						} else if ($(element).attr('id')) {
							mainButtonIdList.push($(element).attr('id'));
						}
					});

				mainButtonIdList.forEach(function (id) {
					if (!mainButtonList[id]) listObj.find('#' + id).remove();
					else if (!$('#' + id).attr('showLater')) listObj.find('#' + id).show();
				});
			} else {
				$('#' + this.getElementId('ImngListObject'))
					.find('.sub-bar')
					.find('.ml-auto')
					.empty();
			}
		};

		this.panelConstructor = function (isHideResultTab) {
			tabList.forEach(function (tabObj, tabIndex) {
				// make tab menu
				var tabBar = $('#panel').find('.nav-item-origin').clone();

				tabBar.removeClass().addClass('nav-item');
				tabBar
					.children('.nav-link')
					.addClass(0 == tabIndex ? 'active' : '')
					.attr({
						href: '#' + tabObj.id,
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
					id: tabObj.id,
				});
				tabDiv.addClass('tab-pane ' + (0 == tabIndex ? 'active' : ''));
				tabDiv.addClass(tabObj.isSubResponsive ? 'sub-responsive' : '');

				$('#panel').find('#process-result').before(tabDiv);

				var rowDiv = $('<div/>').addClass('row frm-row');
				tabDiv.append(rowDiv);

				if ('basic' == tabObj.type) {
					tabObj.detailList.forEach(function (detailObj, detailIndex) {
						var colDiv = $('<div/>').addClass(detailObj.className);
						rowDiv.append(colDiv);

						detailObj.detailSubList.forEach(function (detailSubObj, detailSubIndex) {
							var startIcon = detailSubObj.isPk || detailSubObj.isRequired ? '<b class="icon-star"></b>' : '';
							var formControl = detailSubObj.isPk ? 'form-control view-disabled dataKey' : 'form-control view-disabled';

							var object = $('.form-group-origin').clone();
							
							object.removeClass().addClass('form-group');
							object.children('.control-label').append($('<span/>').text(detailSubObj.name)).append(startIcon);

							if (detailSubObj.warning) object.children('.control-label').after($('<label/>').addClass('control-label warningLabel').append(escapeHtml(detailSubObj.warning)));

							if (detailSubObj.isShowFlagDataName) object.attr({ 'v-if': detailSubObj.isShowFlagDataName });
							
							var regExpType = detailSubObj.regExpType ? detailSubObj.regExpType : 'default' ;
							var maxLength = getRegExpInfo(regExpType).maxLength;

							if ('text' == detailSubObj.type) {								
								var regExpDataInfo = detailSubObj.mappingDataInfo.replace('object', 'letter');
								var regExpInputInfo = {
									key : detailSubObj.mappingDataInfo,
									regExp: getRegExpInfo(regExpType).regExp,
								};
								
								object.children('.control-label').children(':first-child')
									  .append($('<span/>').addClass('letterLength')
												.append($('<span/>').text('('))
												.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
												.append($('<span/>').text('/' + maxLength + ')'))
									  ).show();
								
								
								object
									.children('.input-group')
									.children('input[type=text]')
									.removeClass()
									.addClass(formControl)
									.attr({
										'v-model': detailSubObj.mappingDataInfo,
										readonly: detailSubObj.readonly,
										disabled: detailSubObj.disabled,
										maxlength: maxLength,
										'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
									})
									.show();
							} else if ('textEvt' == detailSubObj.type) {
								var regExpDataInfo = detailSubObj.mappingDataInfo.replace('object', 'letter');
								var regExpInputInfo = {
									key : detailSubObj.mappingDataInfo,
									regExp: getRegExpInfo(regExpType).regExp,
								};
								
								object.children('.control-label').children(':first-child')
									  .append($('<span/>').addClass('letterLength')
												.append($('<span/>').text('('))
												.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
												.append($('<span/>').text('/' + maxLength + ')'))
									  ).show();
								
								object.children('.input-group').children('input[type=text]').removeClass().addClass(formControl).attr({
									'v-model': detailSubObj.mappingDataInfo,
									'v-on:change': detailSubObj.changeEvt,
									maxlength: maxLength,
									'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
								});

								if (detailSubObj.clickEvt) {
									object.children('.input-group').attr({ 'v-on:click': detailSubObj.clickEvt });
									object.children('.input-group').children('input[type=text]').addClass('underlineTxt');
									object.children('.input-group').css({ cursor: 'pointer' });
								}

								if (detailSubObj.btnClickEvt) object.children('.input-group').append($('<button/>').attr({ 'v-on:click': detailSubObj.btnClickEvt }).addClass('btn btn-icon').css({ 'margin-left': '3px', padding: '5px 10px 0px 10px' }).append($('<i/>').addClass('icon-link')));

								object.children('.input-group').children('input[type=text]').show();
							} else if ('password' == detailSubObj.type) {
								var regExpDataInfo = detailSubObj.mappingDataInfo.replace('object', 'letter');
								var regExpInputInfo = {
									key : detailSubObj.mappingDataInfo,
									regExp: getRegExpInfo(regExpType).regExp,
								};
									
								object.children('.control-label').children(':first-child')
									  .append($('<span/>').addClass('letterLength')
												.append($('<span/>').text('('))
												.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
												.append($('<span/>').text('/' + maxLength + ')'))
									  ).show();
								
								
								object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(formControl).attr({
									'v-model': detailSubObj.mappingDataInfo,
									disabled: detailSubObj.disabled,
									maxlength: maxLength,
									'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
								});

								if (detailSubObj.cryptType) {
									object.children('.input-group').children('span[type=password]').children('input').removeClass().addClass(formControl).attr({
										'v-bind:type': detailSubObj.cryptType,
									});

									object
										.children('.input-group')
										.children('span[type=password]')
										.children('.icon-eye')
										.attr({
											'v-on:click': '("password" == ' + detailSubObj.cryptType + ')? ' + detailSubObj.cryptType + ' = "text" : ' + detailSubObj.cryptType + ' = "password"',
										});
								} else {
									object
										.children('.input-group')
										.children('span[type=password]')
										.children('input')
										.removeClass()
										.addClass(formControl)
										.attr({
											type: 'password',
										})
										.width('100%');

									object.children('.input-group').children('span[type=password]').children('.icon-eye').hide();
								}

								object.children('.input-group').children('span[type=password]').show();
							} else if ('search' == detailSubObj.type) {
								var searchClass = detailSubObj.isPk ? 'input-group-append saveGroup' : 'input-group-append saveGroup updateGroup';

								if (detailSubObj.height) {
									object
										.children('.input-group')
										.children('textarea')
										.removeClass()
										.addClass(formControl)
										.attr({
											name: 'detail_type_search',
											'v-model': detailSubObj.mappingDataInfo.vModel,
											readonly: true,
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.attr({
											class: searchClass,
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.find('#lookupBtn')
										.attr({
											'v-on:click': 'openModal(' + JSON.stringify(detailSubObj.mappingDataInfo) + ')',
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.find('#resetBtn')
										.attr({
											'v-on:click': detailSubObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();',
										});
									object.children('.input-group').children('input-group-append').css('min-height', detailSubObj.height);
								} else {
									object
										.children('.input-group')
										.children('input[type=text]')
										.removeClass()
										.addClass(formControl)
										.attr({
											name: 'detail_type_search',
											'v-model': detailSubObj.mappingDataInfo.vModel,
											readonly: true,
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.attr({
											class: searchClass,
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.find('#lookupBtn')
										.attr({
											'v-on:click': 'openModal(' + JSON.stringify(detailSubObj.mappingDataInfo) + ')',
										})
										.show();
									object
										.children('.input-group')
										.children('.input-group-append')
										.find('#resetBtn')
										.attr({
											'v-on:click': detailSubObj.mappingDataInfo.vModel + '= null;' + 'window.vmMain.$forceUpdate();',
										});
								}
							} else if ('singleDaterange' == detailSubObj.type) {
								object
									.children('.input-group')
									.children('input[type=text]')
									.removeClass()
									.addClass(formControl + ' input-date')
									.attr({
										id: detailSubObj.mappingDataInfo.id,
										'v-model': detailSubObj.mappingDataInfo.vModel,
										'data-drops': detailSubObj.mappingDataInfo.dataDrops ? detailSubObj.mappingDataInfo.dataDrops : 'up',
										autocomplete: 'off',
										disabled: detailSubObj.disabled,
									})
									.show();
							} else if ('select' == detailSubObj.type) {
								var selectAttr = object
									.children('.input-group')
									.children('select')
									.removeClass()
									.addClass(formControl)
									.attr({
										'v-model': detailSubObj.mappingDataInfo.selectModel,
										'v-on:change': detailSubObj.mappingDataInfo.changeEvt ? detailSubObj.mappingDataInfo.changeEvt : null,
										disabled: detailSubObj.disabled,
									});

								if (detailSubObj.id) selectAttr.attr({ id: detailSubObj.id });

								if (detailSubObj.clickEvt) object.children('.input-group').append($('<button/>').attr({ 'v-on:click': detailSubObj.clickEvt }).addClass('btn btn-icon').css({ 'margin-left': '3px', padding: '5px 10px 0px 10px' }).append($('<i/>').addClass('icon-link')));

								if (detailSubObj.placeholder) {
									selectAttr.append(
										$('<option/>')
											.attr({
												selected: 'selected',
												value: ' ',
											})
											.text(detailSubObj.placeholder)
									);
								}

								selectAttr
									.append(
										$('<option/>').attr({
											'v-for': detailSubObj.mappingDataInfo.optionFor,
											'v-bind:value': detailSubObj.mappingDataInfo.optionValue,
											'v-text': detailSubObj.mappingDataInfo.optionText,
											'v-bind:disabled': detailSubObj.mappingDataInfo.optionDisabled,
										})
									)
									.show();
							} else if ('textarea' == detailSubObj.type) {
								var regExpDataInfo = mappingDataInfo.replace('object', 'letter');
								var regExpInputInfo = {
									key : detailSubObj.mappingDataInfo,
									regExp: getRegExpInfo(regExpType).regExp,
								};
								
								object.children('.control-label').children(':first-child')
								  .append($('<span/>').addClass('letterLength')
											.append($('<span/>').text('('))
											.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
											.append($('<span/>').text('/' + maxLength + ')'))
								  ).show();
								
								object
									.children('.input-group')
									.children('textarea')
									.removeClass()
									.addClass(formControl)
									.attr({
										'v-model': detailSubObj.mappingDataInfo,
										maxlength: maxLength,
										'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
									})
									.show();

								if (detailSubObj.height) object.children('.input-group').children('textarea').css('min-height', detailSubObj.height);
							} else if ('combination' == detailSubObj.type) {								
								detailSubObj.combiList.forEach(function (combiObj, combiIndex) {
									var combiRegExpType = combiObj.regExpType ? combiObj.regExpType : 'default';	
									var combiMaxLength = getRegExpInfo(combiRegExpType).maxLength;
									
									if ('select' == combiObj.type) {
										object
											.children('.input-group')
											.children('select')
											.removeClass()
											.addClass(formControl)
											.attr({
												'v-model': combiObj.mappingDataInfo.selectModel,
											})
											.append(
												$('<option/>').attr({
													'v-for': combiObj.mappingDataInfo.optionFor,
													'v-bind:value': combiObj.mappingDataInfo.optionValue,
													'v-text': combiObj.mappingDataInfo.optionText,
												})
											)
											.show();
									} else if ('text' == combiObj.type) {
										var regExpDataInfo = combiObj.mappingDataInfo.replace('object', 'letter');
										var regExpInputInfo = {
											key : combiObj.mappingDataInfo,
											regExp:  getRegExpInfo(combiRegExpType).regExp,
										}
										
										object.children('.input-group').append(
												$('<div/>').addClass('detail-content-regExp').css({ 'margin-left': '5px', 'width': 'auto' })
													.append(
														object.children('.input-group').children('input[type=text]')
														.removeClass().addClass('regExp-text')
														.attr({
															'v-model': combiObj.mappingDataInfo,
															maxlength: combiMaxLength,
															'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
														}).show()
													)
											  		.append(
											  			$('<span/>').addClass('letterLength')
														.append($('<span/>').text('('))
														.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
														.append($('<span/>').text('/' + combiMaxLength + ')')
													)
											  )
										);
								 } else if ('radio' == detailSubObj.type) {
									object
									.children('.input-group')
									.children('div[type=radio]')
									.removeClass()
									.addClass('custom-control custom-radio single')
									.append(
										$('<label/>').css({'padding-right': '30px'}).attr({
											'v-for': detailSubObj.mappingDataInfo.optionFor,
										}).append(
											$('<input/>').addClass('custom-control-input').attr({
												type: 'radio',
												'v-model': detailSubObj.mappingDataInfo.vModel,
												'v-bind:value': detailSubObj.mappingDataInfo.optionValue,
												'v-bind:disabled': detailSubObj.mappingDataInfo.optionDisabled,
											})
										)
										.append(
											$('<span/>').addClass('custom-control-label').attr({
												'v-text': detailSubObj.mappingDataInfo.optionText
											}).css({'padding-left': '5px'})
										)
									).show();
								 } else if ('checkbox' == detailSubObj.type) {
									object
									.children('.input-group')
									.children('div[type=checkbox]')
									.removeClass()
									.addClass('custom-control custom-checkbox single')
									.append(
										$('<label/>').css({'padding-right': '30px'}).attr({
											'v-for': detailSubObj.mappingDataInfo.optionFor,
										}).append(
											$('<input/>').addClass('custom-control-input').attr({
												type: 'checkbox',
												'v-model': detailSubObj.mappingDataInfo.vModel,
												'v-bind:value': detailSubObj.mappingDataInfo.optionValue,
												'v-bind:disabled': detailSubObj.mappingDataInfo.optionDisabled,
												'v-on:change': searchSubObj.mappingDataInfo.changeEvt ? searchSubObj.mappingDataInfo.changeEvt : null,
											})
										)
										.append(
											$('<span/>').addClass('custom-control-label').attr({
												'v-text': detailSubObj.mappingDataInfo.optionText
											}).css({'padding-left': '5px'})
										)
									).show();
								 }
								});
							} else if ('datalist' == detailSubObj.type) {
								var regExpDataInfo = detailSubObj.mappingDataInfo.vModel.replace('object', 'letter');
								var regExpInputInfo = {
									key : detailSubObj.mappingDataInfo.vModel,
									regExp: getRegExpInfo(regExpType).regExp,
								}
								
								object.children('.control-label').children(':first-child')
									  .append($('<span/>').addClass('letterLength')
												.append($('<span/>').text('('))
												.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
												.append($('<span/>').text('/' + maxLength + ')'))
									  ).show();
								
								
								object.children('.input-group').children('span[type=datalist]').children('input[type=text]').removeClass().addClass(formControl).attr({
									list: detailSubObj.mappingDataInfo.dataListId,
									'v-model': detailSubObj.mappingDataInfo.vModel,
									maxlength: maxLength,
									'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ')' : null
								});

								object
									.children('.input-group')
									.children('span[type=datalist]')
									.children('datalist')
									.attr({
										id: detailSubObj.mappingDataInfo.dataListId,
									})
									.append(
										$('<option/>').attr({
											'v-for': detailSubObj.mappingDataInfo.dataListFor,
											'v-text': detailSubObj.mappingDataInfo.dataListText,
										})
									);

								object.children('.input-group').children('span[type=datalist]').show();
							} else if ('radio' == detailSubObj.type) {
								object
								.children('.input-group')
								.children('div[type=radio]')
								.removeClass()
								.addClass('custom-control custom-radio single')
								.append(
									$('<label/>').css({'padding-right': '30px'}).attr({
										'v-for': detailSubObj.mappingDataInfo.optionFor,
									}).append(
										$('<input/>').addClass('custom-control-input').attr({
											type: 'radio',
											'v-model': detailSubObj.mappingDataInfo.vModel,
											'v-bind:value': detailSubObj.mappingDataInfo.optionValue,
											'v-bind:disabled': detailSubObj.mappingDataInfo.optionDisabled,
										})
									)
									.append(
										$('<span/>').addClass('custom-control-label').attr({
											'v-text': detailSubObj.mappingDataInfo.optionText
										}).css({'padding-left': '5px'})
									)
								).show();
						 } else if ('checkbox' == detailSubObj.type) {
								object
								.children('.input-group')
								.children('div[type=checkbox]')
								.removeClass()
								.addClass('custom-control custom-checkbox single')
								.append(
									$('<label/>').css({'padding-right': '30px'}).attr({
										'v-for': detailSubObj.mappingDataInfo.optionFor,
									}).append(
										$('<input/>').addClass('custom-control-input').attr({
											type: 'checkbox',
											'v-model': detailSubObj.mappingDataInfo.vModel,
											'v-bind:value': detailSubObj.mappingDataInfo.optionValue,
											'v-bind:disabled': detailSubObj.mappingDataInfo.optionDisabled,
											'v-on:change': searchSubObj.mappingDataInfo.changeEvt ? searchSubObj.mappingDataInfo.changeEvt : null,
										})
									)
									.append(
										$('<span/>').addClass('custom-control-label').attr({
											'v-text': detailSubObj.mappingDataInfo.optionText
										}).css({'padding-left': '5px'})
									)
								).show();
						 } else if ('grid' == detailSubObj.type) {
								object.append(
									$('<div/>')
										.addClass('table-responsive')
										.append($('<div/>').attr({ id: detailSubObj.id }))
								);
							}

							if ('search' != detailSubObj.type && 'cron' != detailSubObj.type) {
								object.children('.input-group').children('.input-group-append').remove();
							}

							colDiv.append(object);
						});
					});

					if (tabObj.appendAreaList) {
						var rowDiv = $('<div/>').addClass('row frm-row');
						tabDiv.append(rowDiv);

						tabObj.appendAreaList.forEach(function (appendArea) {
							rowDiv.append(appendArea.getDetailArea());
						});
					}
				} else if ('property' == tabObj.type) {
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
											'v-on:change': searchSubObj.mappingDataInfo.changeEvt ? searchSubObj.mappingDataInfo.changeEvt : null,
										});

									if (searchSubObj.placeholder) {
										selectDiv.append(
											$('<option/>')
												.attr({
													selected: 'selected',
													value: ' ',
												})
												.text(searchSubObj.placeholder)
										);
									}

									selectDiv.append(
										$('<option/>').attr({
											'v-for': searchSubObj.mappingDataInfo.optionFor,
											'v-bind:value': searchSubObj.mappingDataInfo.optionValue,
											'v-text': searchSubObj.mappingDataInfo.optionText,
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

					rowDiv.append(
						$('<div/>')
							.addClass('form-table form-table-responsive propertyTab')
							.append($('<div/>').addClass('form-table-wrap'))
							.append(
								$('<div/>')
									.addClass('form-table-head')
									.append(
										$('<button/>')
											.addClass('btn-icon saveGroup updateGroup')
											.attr({
												type: 'button',
												'v-on:click': tabObj.addRowFunc,
											})
											.append($('<i/>').addClass('icon-plus-circle'))
									)
							)
							.append(
								$('<div/>')
									.addClass('form-table-body')
									.attr({
										'v-for': '(elm, index) in ' + tabObj.mappingDataInfo,
									})
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
										'v-if': tabObj.isShowRemoveIconWhere,
									})
									.append($('<i/>').addClass('icon-minus-circle'))
							)
							.append(
								$('<button/>')
									.addClass('btn-icon saveGroup updateGroup')
									.attr({
										type: 'button',
										'v-if': '!' + tabObj.isShowRemoveIconWhere,
									})
									.append($('<i/>').addClass('icon-star'))
							);
					} else {
						rowDiv.find('.form-table-body').append(
							$('<button/>')
								.addClass('btn-icon saveGroup updateGroup')
								.attr({
									type: 'button',
									'v-on:click': tabObj.removeRowFunc,
								})
								.append($('<i/>').addClass('icon-minus-circle'))
						);
					}

					tabObj.detailList.forEach(function (detailObj, detailIndex) {
						var disabled = detailObj.disabled ? detailObj.disabled : false;
						var regExpType = detailObj.regExpType? detailObj.regExpType : 'default';
						var maxLength = getRegExpInfo(regExpType).maxLength;
						
						var appendTag = null;

						if ('text' == detailObj.type) {
							var dataInfoArr = detailObj.mappingDataInfo.split('.');								
							dataInfoArr.splice(1, 0, 'letter'); 
							
							var regExpDataInfo = dataInfoArr.join('.');
							var regExpInputInfo = {
								key : detailObj.mappingDataInfo,
								regExp:  getRegExpInfo(regExpType).regExp,
							}
						
							appendTag = $('<div/>').addClass('detail-content-regExp')
										.append(
											$('<input/>').addClass('regExp-text view-disabled ')
											.attr({
												'v-model': detailObj.mappingDataInfo,
												maxlength: maxLength,
												'v-on:input': regExpType? 'inputEvt(' + JSON.stringify(regExpInputInfo)  + ', elm)' : null
											})
										)
								  		.append(
								  			$('<span/>').addClass('letterLength')
											.append($('<span/>').text('('))
											.append($('<span/>').attr({ 'v-text': regExpDataInfo }))
											.append($('<span/>').text('/' + maxLength + ')')
										)
								  	);
						} else if ('search' == detailObj.type) {
							appendTag = $('<div/>')
								.addClass('input-group-append ')
								.width('100%')
								.append(
									$('<input/>').addClass('form-control').attr({
										type: detailObj.type,
										'v-model': detailObj.mappingDataInfo.vModel,
										readonly: true,
										disabled: true,
									})
								)
								.append(
									$('<button/>')
										.addClass('btn saveGroup updateGroup')
										.attr({
											'v-on:click': 'openModal(' + JSON.stringify(detailObj.mappingDataInfo) + ', index)',
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
											'v-on:click': detailObj.mappingDataInfo.vModel + ' = null;',
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
						} else if ('select' == detailObj.type) {
							appendTag = $('<select/>')
								.attr({
									'v-model': detailObj.mappingDataInfo.selectModel,
								})
								.addClass('form-control view-disabled')
								.append(
									$('<option/>').attr({
										'v-for': detailObj.mappingDataInfo.optionFor,
										'v-bind:value': detailObj.mappingDataInfo.optionValue,
										'v-text': detailObj.mappingDataInfo.optionText,
									})
								);
						} else if ('singleDaterange' == detailObj.type) {
							appendTag = $('<input/>')
								.addClass('form-control view-disabled input-date')
								.attr({
									'v-bind:id': "'" + detailObj.mappingDataInfo.id + "' + index",
									'v-model': detailObj.mappingDataInfo.vModel,
									'data-drops': detailObj.mappingDataInfo.dataDrops ? detailObj.mappingDataInfo.dataDrops : 'up',
									autocomplete: 'off',
								})
								.show();
						}

						$('#' + tabObj.id)
							.find('.form-table-head')
							.append($('<label/>').addClass('col').text(detailObj.name));
						$('#' + tabObj.id)
							.find('.form-table-body')
							.append($('<div/>').addClass('col').append(appendTag));
					});
				} else if ('tree' == tabObj.type) {
					rowDiv.append(
						$('<div/>')
							.addClass('table-responsive')
							.append(
								$('<div/>').attr({
									id: tabObj.id + '_tree',
								})
							)
					);
				} else if ('custom' == tabObj.type) {
					var appendDiv = tabObj.noRowClass ? tabDiv : rowDiv;

					if (tabObj.noRowClass) tabDiv.empty();

					appendDiv.append(tabObj.getDetailArea());
				}
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
			var url = prefixUrl + '/igate/page/common/custom' + openModalParam.url + '?popupId=' + viewName + 'ModalSearch';
			
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

				$('#panel').find('.detail-content-common').removeClass().addClass('detail-content-regExp');
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

				$('#panel').find('.detail-content-common').removeClass().addClass('detail-content-regExp');
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

		setTimeout(function () {
			target.show(0, function () {
				$body.addClass('panel-open-' + o);

				windowResizeSearchGrid();

				if (callBackFunc) {
					callBackFunc();
				}
			});
		}, 200);
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
	$('body')
		.removeClass('panel-open-' + o)
		.find('.backdrop')
		.remove();
	$('#' + window.mainListAreaId)
		.find('.table-responsive')
		.height('auto');

	setTimeout(function () {
		$('#' + o).hide();
		$('body').removeClass('fixed');
		if (originScroll != -0) {
			ct.scrollTop(originScroll);
		}
		ct.removeAttr('style');
		windowResizeSearchGrid();
	}, 300);
}

function getMakeGridObj() {
	var elementId = null;
	var searchUri = null;
	var searchGrid = null;
	var isModal = null;
	var windowName = null;

	function makeGridObj() {
		this.getSearchGrid = function () {
			return searchGrid;
		};

		this.setConfig = function (instanceSettings) {
			elementId = instanceSettings.elementId;
			searchUri = instanceSettings.searchUri;
			isModal = instanceSettings.isModal;

			tui.Grid.applyTheme('clean', {
				row: {
					hover: {
						background: '#f5f6fb',
					},
				},
			});

			tui.Grid.setLanguage('en', {
				display: {
					noData: 'No Data.',
				},
			});

			var settings = {
				el: document.getElementById(elementId),
				columnOptions: {
					resizable: true,
				},
				usageStatistics: false,
				rowHeaders: instanceSettings.rowHeaders,
				header: {
					height: 32,
					align: 'center',
				},
				onGridMounted: function () {
					if (instanceSettings.onGridMounted) {
						instanceSettings.onGridMounted();
					}

					$('#' + elementId)
						.find('.tui-grid-column-resize-handle')
						.removeAttr('title');
				},
				onGridUpdated: function () {
					if (instanceSettings.onGridUpdated) {
						instanceSettings.onGridUpdated();
					}

					var resetColumnWidths = [];

					searchGrid.getColumns().forEach(function (columnInfo) {
						if (!columnInfo.copyOptions) return;

						if (columnInfo.copyOptions.widthRatio) {
							resetColumnWidths.push($('#' + elementId).width() * (columnInfo.copyOptions.widthRatio / 100));
						}
					});

					if (0 < resetColumnWidths.length) searchGrid.resetColumnWidths(resetColumnWidths);
				},
				scrollX: false,
				scrollY: true,
			};

			$.extend(settings, instanceSettings);

			settings.columns.forEach(function (column) {
				if (!column.formatter) {
					column.escapeHTML = true;
				}

				if (column.width && -1 < String(column.width).indexOf('%')) {
					if (!column.copyOptions) column.copyOptions = {};

					column.copyOptions.widthRatio = column.width.replace('%', '');

					delete column.width;
				}
			});

			searchGrid = new tui.Grid(settings);

			searchGrid.on('mouseover', function (ev) {
				if ('cell' != ev.targetType) return;

				var overCellElement = $(searchGrid.getElement(ev.rowKey, ev.columnName));
				overCellElement.attr('title', overCellElement.text());
			});

			if ('undefined' != typeof settings.onClick) {
				if (instanceSettings.rowHeaders && -1 < instanceSettings.rowHeaders.indexOf('checkbox')) {
					searchGrid.on('click', function (ev) {
						if ('rowHeader' == ev.targetType) {
							setTimeout(function () {
								if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey)) {
									searchGrid.addRowClassName(ev.rowKey, 'row-selected');
								} else {
									searchGrid.removeRowClassName(ev.rowKey, 'row-selected');
								}
							}, 0);
						} else {
							settings.onClick(searchGrid.getRow(ev.rowKey), ev);
						}
					});

					searchGrid.on('checkAll', function (ev) {
						if (!searchGrid.store.data.rawData) return;

						if (0 == searchGrid.store.data.rawData.length) return;

						searchGrid.store.data.rawData.forEach(function (data) {
							searchGrid.addRowClassName(data.rowKey, 'row-selected');
						});
					});

					searchGrid.on('uncheckAll', function (ev) {
						if (!searchGrid.store.data.rawData) return;

						if (0 == searchGrid.store.data.rawData.length) return;

						searchGrid.store.data.rawData.forEach(function (data) {
							searchGrid.removeRowClassName(data.rowKey, 'row-selected');
						});
					});
				} else {
					searchGrid.on('click', function (ev) {
						if (ev.rowKey != null) {
							searchGrid.store.data.rawData.forEach(function (data) {
								searchGrid.removeRowClassName(data.rowKey, 'row-selected');
							});

							searchGrid.addRowClassName(ev.rowKey, 'row-selected');

							settings.onClick(searchGrid.getRow(ev.rowKey), ev);
						}
					});
				}
			} else {
				if (instanceSettings.rowHeaders && -1 < instanceSettings.rowHeaders.indexOf('checkbox')) {
					searchGrid.on('click', function (ev) {
						if ('rowHeader' == ev.targetType) {
							setTimeout(function () {
								if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey)) {
									searchGrid.addRowClassName(ev.rowKey, 'row-selected');
								} else {
									searchGrid.removeRowClassName(ev.rowKey, 'row-selected');
								}
							}, 0);
						} else {
							if (-1 != searchGrid.getCheckedRowKeys().indexOf(ev.rowKey)) {
								searchGrid.uncheck(ev.rowKey);
								searchGrid.removeRowClassName(ev.rowKey, 'row-selected');
							} else {
								searchGrid.check(ev.rowKey);
								searchGrid.addRowClassName(ev.rowKey, 'row-selected');
							}
						}
					});

					searchGrid.on('checkAll', function (ev) {
						if (!searchGrid.store.data.rawData) return;

						if (0 == searchGrid.store.data.rawData.length) return;

						searchGrid.store.data.rawData.forEach(function (data) {
							searchGrid.addRowClassName(data.rowKey, 'row-selected');
						});
					});

					searchGrid.on('uncheckAll', function (ev) {
						if (!searchGrid.store.data.rawData) return;

						if (0 == searchGrid.store.data.rawData.length) return;

						searchGrid.store.data.rawData.forEach(function (data) {
							searchGrid.removeRowClassName(data.rowKey, 'row-selected');
						});
					});
				} else {
					searchGrid.on('click', function (ev) {
						if (ev.rowKey != null) {
							searchGrid.store.data.rawData.forEach(function (data) {
								searchGrid.removeRowClassName(data.rowKey, 'row-selected');
							});

							searchGrid.addRowClassName(ev.rowKey, 'row-selected');
						}
					});
				}
			}

			if ('undefined' != typeof settings.onDblClick) {
				searchGrid.on('dblclick', function (ev) {
					settings.onDblClick(searchGrid.getRow(ev.rowKey), ev);
				});
			}

			if (isModal) {
				windowName = (function () {
					var S4 = function () {
						return Math.floor(mathRandom() * 0x10000).toString(16);
					};

					return 'GUID-' + (S4() + S4() + '-' + S4() + '-' + S4() + '-' + S4() + '-' + S4() + S4() + S4());
				})();
			}
		};

		this.noDataHidePage = function (listAreaId) {
			if ('none' == $('#' + listAreaId).children('.empty').css('display'))
				return;

			$('#' + listAreaId).children('.empty').hide();
			$('#' + listAreaId).children('.table-responsive').show();
			$('#' + listAreaId).find("[showLater='true']").show();
		};

		this.search = function (vueSearchObj, callback) {
			submit(
				JsonImngObj.serialize(
					$.extend(
						{
							_pageSize: vueSearchObj.pageSize,
						},
						vueSearchObj.object
					)
				),
				function (result) {
					if (isModal)
						setTimeout(function () {
							searchGrid.refreshLayout();
							resizeSearchGridPagination(elementId);
						}, 0);
					else resizeSearchGrid();

					if (callback) {
						callback(result);
					}
				}
			);
		};

		function submit(param, callback) {
			if (isModal) {
				param += '&NEW-WINDOW-ID=' + windowName;
			}
			
			new HttpReq(searchUri).read(param, function (result) {
				setGridPaging(result);

				if (callback) callback(result);
			});
		}

		function page(param, callback) {
			submit(param, callback);
		}

		function setGridPaging(result) {
			if ('ok' != result.result) return;

			if ('undefined' != typeof result.object.page) {
				searchGrid.resetData(JsonImngObj.planarize(result.object.page));
			} else if ('undefined' != typeof result.object) {
				searchGrid.resetData(JsonImngObj.planarize(result.object));
			} else {
				searchGrid.resetData([]);
			}

			$('#' + elementId).find('.ImngSearchGridPagination').remove();
			$('#' + elementId).append($('<ul/>').addClass('ImngSearchGridPagination pagination'));

			if ('undefined' != typeof result.object.prev) {
				var prevLi = $('<li/>').addClass('page-item');

				prevLi.append(
					$('<a/>')
						.addClass('page-link page-link-prev')
						.attr({
							href: 'javascript:void(0);',
							name: 'prev',
						})
						.data('page_param', '_pageNo=' + result.object.prev.pageNo + '&' + result.object.prev.keyURI)
						.append($('<i/>').addClass('icon-left'))
				);

				$('#' + elementId)
					.find('.ImngSearchGridPagination')
					.append(prevLi);
			}

			if ('undefined' != typeof result.object.pages) {
				for (var i = 0; i < result.object.pages.length; i++) {
					var pageItemLi = $('<li/>').addClass('page-item');

					if (result.object.pages[i].current) {
						pageItemLi.append(
							$('<a/>')
								.addClass('page-link active')
								.attr({
									href: 'javascript:void(0);',
								})
								.text(result.object.pages[i].pageNo)
						);
					} else {
						pageItemLi.append(
							$('<a/>')
								.addClass('page-link')
								.attr({
									href: 'javascript:void(0);',
									name: 'pageNum',
								})
								.data('page_param', '_pageNo=' + result.object.pages[i].pageNo + '&' + result.object.pages[i].keyURI)
								.text(result.object.pages[i].pageNo)
						);
					}

					$('#' + elementId)
						.find('.ImngSearchGridPagination')
						.append(pageItemLi);
				}
			}

			if ('undefined' != typeof result.object.next) {
				var nextLi = $('<li/>').addClass('page-item');

				nextLi.append(
					$('<a/>')
						.addClass('page-link page-link-next')
						.attr({
							href: 'javascript:void(0);',
							name: 'next',
						})
						.data('page_param', '_pageNo=' + result.object.next.pageNo + '&' + result.object.next.keyURI)
						.append($('<i/>').addClass('icon-right'))
				);

				$('#' + elementId)
					.find('.ImngSearchGridPagination')
					.append(nextLi);
			}

			resizeSearchGridPagination(elementId);

			$('#' + elementId)
				.find('.ImngSearchGridPagination')
				.find('[name=pageNum], [name=prev], [name=next]')
				.on('click', function () {
					page($(this).data('page_param'), function () {
						if (isModal) {
							setTimeout(function () {
								searchGrid.refreshLayout();
								resizeSearchGridPagination(elementId);
							}, 0);
						} else {
							resizeSearchGrid();
						}
					});
				});

			$('#' + elementId)
				.find('.tui-pagination')
				.off('click')
				.on('click', resizeSearchGrid);
		}
	}

	return new makeGridObj();
}