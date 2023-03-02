var ResultImngObj = {
	errorHandler: function (request, status, error) {
		window.$stopSpinner();

		console.log('ajaxError : \n' + error);
		
		window._alert({
			type: 'warn',
			message: error,
		});
	},

	resultErrorHandler: function (result) {
		window.$stopSpinner();

		$('#accordionResult').children('.collapse-item').remove();

		result.error.forEach(function (item, index) {
			var object = $('.collapse-item-origin').clone();
			object.attr('class', 'collapse-item');

			var field = '';

			if (item.field) field = 'Field(' + item.field + ') : ';

			object.children('button').children('i.iconb-compt.mr-2').removeClass().addClass('iconb-danger mr-2');
			object
				.children('button')
				.children('span')
				.text(field + item.message);

			if (item.stackTrace) {
				object.children('button').attr('data-target', '#collapseResult' + index);
				object
					.children('div')
					.attr('id', 'collapseResult' + index)
					.children('.collapse-content')
					.append($('<pre/>').text(item.stackTrace));
			} else {
				object.children('.collapse').remove();
			}

			$('#accordionResult').append(object);
		});

		$('#item-result').trigger('click');
		$('.collapse-item').show();
		$('#accordionResult').show();
	},

	resultResponseHandler: function (result) {
		$('#accordionResult').children('.collapse-item').remove();

		if (!result.response) {
			var object = $('.collapse-item-origin').clone();

			object.attr('class', 'collapse-item');
			object.children('button').children('span').text('Successfully done.');

			$('#accordionResult').append(object);
		} else {
			result.response.forEach(function (item, index) {
				var object = $('.collapse-item-origin').clone();
				object.attr('class', 'collapse-item');

				if (item.success) {
					object
						.children('button')
						.children('span')
						.text(item.instanceId + ' was succeed.');
				} else {
					object.children('button').children('i.iconb-compt.mr-2').removeClass().addClass('iconb-danger mr-2');
					object
						.children('button')
						.children('span')
						.text(item.instanceId + ' was failed.');
				}

				if (item.response) {
					object.children('button').attr('data-target', '#collapseResult' + index);
					object
						.children('div')
						.attr('id', 'collapseResult' + index)
						.children('.collapse-content')
						.append($('<pre/>').text(item.response));
				} else {
					object.children('.collapse').remove();
				}

				$('#accordionResult').append(object);
			});
		}

		$('#item-result').trigger('click');
		$('.collapse-item').show();
		$('#accordionResult').show();
	},

	resultClearHandler: function () {
		$('#accordionResult').children('.collapse-item').remove();
	},
};

var SearchImngObj = {
	searchGrid: null,
	searchUri: null,
	viewMode: null,
	popupResponse: null,
	popupResponsePosition: null,
	searchGridEL: null,

	initSearchImngObj: function () {
		SearchImngObj.searchGrid = null;
		SearchImngObj.searchUri = null;
		SearchImngObj.viewMode = null;
		SearchImngObj.popupResponse = null;
		SearchImngObj.popupResponsePosition = null;
		SearchImngObj.searchGridEL = null;
	},

	clicked: function (loadParam) {
		if (!loadParam) return;

		if ('Popup' == SearchImngObj.viewMode) {
			if (loadParam._checked === null) {
				if (-1 != SearchImngObj.searchGrid.getCheckedRowKeys().indexOf(loadParam.rowKey)) {
					SearchImngObj.searchGrid.uncheck(loadParam.rowKey);
					SearchImngObj.searchGrid.removeRowClassName(loadParam.rowKey, 'row-selected');
				} else {
					SearchImngObj.searchGrid.check(loadParam.rowKey);
					SearchImngObj.searchGrid.addRowClassName(loadParam.rowKey, 'row-selected');
				}
			} else {
				parent[SearchImngObj.popupResponse](SearchImngObj.popupResponsePosition, loadParam);
				parent.DialogImngObj.modalClose();
			}
		} else {
			if (window.vmMain !== undefined) {
				loadParam.viewMode = window.vmMain.viewMode;
				SearchImngObj.load($.param(loadParam));
			}

			if (loadParam._checked === null) {
				if (-1 != SearchImngObj.searchGrid.getCheckedRowKeys().indexOf(loadParam.rowKey)) {
					SearchImngObj.searchGrid.uncheck(loadParam.rowKey);
					SearchImngObj.searchGrid.removeRowClassName(loadParam.rowKey, 'row-selected');
				} else {
					SearchImngObj.searchGrid.check(loadParam.rowKey);
					SearchImngObj.searchGrid.addRowClassName(loadParam.rowKey, 'row-selected');
				}
			}
		}
	},
	load: function (data) {
	    new HttpReq(SaveImngObj.objectUri).read(data, function (result) {
	        var vmMain = window.vmMain;
	        vmMain.viewMode = result.viewMode;
	        vmMain.object = result.object;
	       
	        var initLetter = function(obj) {
	            var rtnObj = {};
	          
	            for (var key in obj) {
	                rtnObj[key] = ('object' === typeof obj[key])? initLetter(obj[key]) : obj[key]? obj[key].toString().length : 0;
	            }
	               
	            return rtnObj;
	        };
	       
	        for (var key in result.object) {
	            var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1);
	            var value = result.object[key];

	            if (value instanceof Array && window.hasOwnProperty(name)) {
	                var vmSub = window[name];
	                vmSub.viewMode = result.viewMode;
	                vmSub[key] = value;
	             
	                value.forEach(function(v) {
	                    v.letter = initLetter(v);
	                });
	            }
	        }

	        if (vmMain.loaded) vmMain.loaded();

	        if (vmMain.goDetailPanel) vmMain.goDetailPanel();
	    });
	},
};

var SaveImngObj = {
	objectUri: null,

	setConfig: function (instanceSettings) {
		SaveImngObj.objectUri = instanceSettings.objectUri;
	},

	submit: function (uri, data, message, callback, modalMode) {
		var successFunc = function (result) {
			if (SearchImngObj.searchGrid) window.vmSearch.search();
			
			window._alert({
				type: 'normal',
				message: message,
				backdropMode: modalMode,
			});			
			
			if('DELETE' !== data._method) panelOpen('done');
			
			if (callback) callback();
		};

		var httpReq = new HttpReq(uri);

		if ('PUT' == data._method)
			httpReq.create(data, function (result) {
				successFunc(result);
			}, true);
		else if ('POST' == data._method)
			httpReq.update(data, function (result) {
				successFunc(result);
			}, true);
		else if ('DELETE' == data._method)
			httpReq.remove(data, function (result) {
				successFunc(result);
			}, true);
	},

	insertSubmit: function (data, message, callback) {
		data._method = 'PUT';
		SaveImngObj.submit(SaveImngObj.objectUri, data, message, callback);
	},

	updateSubmit: function (data, message, callback) {
		data._method = 'POST';
		SaveImngObj.submit(SaveImngObj.objectUri, data, message, callback);
	},

	deleteSubmit: function (data, message, callback) {
		data._method = 'DELETE';
		SaveImngObj.submit(SaveImngObj.objectUri, data, message, callback);
	},

	insert: function (message, callback) {
		var vmMain = window.vmMain;
		var object = vmMain.object;

		for (var key in object) {
			var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1);
			if (window.hasOwnProperty(name)) object[key] = window[name][key];
		}

		if (vmMain.saving) vmMain.saving();

		this.insertSubmit(object, message);
	},

	update: function (message, callback) {
		var vmMain = window.vmMain;
		var object = vmMain.object;
		for (var key in object) {
			var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1);
			if (window.hasOwnProperty(name)) object[key] = window[name][key];
		}

		if (vmMain.saving) vmMain.saving();

		this.updateSubmit(object, message);
	},

	remove: function (confirm, message, callback) {
		window._confirm({
			type: 'normal',
			message: confirm,
			callBackFunc: function () {

				window.$startSpinner();
				
				var vmMain = window.vmMain;
				var object = vmMain.object;

				for (var key in object) {
					var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1);

					if (window.hasOwnProperty(name)) object[key] = window[name][key];
				}

				if (vmMain.saving) vmMain.saving();

				this.deleteSubmit(object, message, callback);
			}.bind(this),
		});
	},
};

var ControlImngObj = {
	controlUri: null,

	setConfig: function(instanceSettings) {
	  ControlImngObj.controlUri = instanceSettings.controlUri;
	},
	control: function(command, data, callback) {
		new HttpReq(ControlImngObj.controlUri + "?" + $.param({ command : command })).update(data, callback, true);
	},
	gridControl: function(command, controlParams) {
		var checkedRows = SearchImngObj.searchGrid.getCheckedRows();
		
		if(checkedRows.length == 0) {
			window._alert({ type: 'normal', message: noSelect});
			return;
		}
		
		window.$startSpinner();
		
		getGridControlResult(0)
		
		function getGridControlResult(idx) {
			var item = checkedRows[idx];
			
			SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', running);
			
			var url = ControlImngObj.controlUri + "?" + $.param({ command : command });
			 
			 new HttpReq(url).update(controlParams(item), function (result) {
				 if('ok' === result.result) {
					 if (result.response[0].success) {
						 SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', command + " was successed") ;
						 SearchImngObj.searchGrid.setValue(item.rowKey, 'status', result.object.status);						  
					 } else {
						 SearchImngObj.searchGrid.setValue(item.rowKey, 'processResult', result.response[0].response) ;
					 }
				 } else {
					 SearchImngObj.searchGrid.setValue(row.rowKey, 'processResult', command + " was failed") ;
				 }
				 
				 if(idx == checkedRows.length - 1) window.$stopSpinner();
				 else getGridControlResult(idx+1);				 
			 });
		};
	},
	dump : function() {
		this.control('dump', JsonImngObj.serialize(window.vmMain.pk)) ;
	},
	load : function() {
		this.control('dump', JsonImngObj.serialize(window.vmMain.pk)) ;
	},
};

var JsonImngObj = {
	planarize: function (object) {
		if (object instanceof Array) {
			var result = [];

			for (var j = 0, l = object.length; j < l; j++) result.push(this.planarize_sub(null, object[j], {}));

			return result;
		} else return this.planarize_sub(null, object, {});
	},

	planarize_sub: function (name, orgObject, newObject) {
		if (orgObject instanceof Array) return newObject;

		var subname, value;
		for (var key in orgObject) {
			value = orgObject[key];

			if (name) subname = name + '.' + key;
			else subname = key;

			if (typeof value == 'object') this.planarize_sub(subname, value, newObject);
			else newObject[subname] = value;
		}

		return newObject;
	},

	serialize: function (object) {
		var array = this.serialize_sub(null, object, []);
		return array.join('&');
	},

	serialize_sub: function (name, orgObject, newObject) {
		for (var key in orgObject) {
			var value = orgObject[key];
			var subname = name ? name + '.' + key : key;

			if (value instanceof Array)
				value.forEach(function (item, idx) {					
					if ('object' !== typeof item) newObject.push(encodeURIComponent(subname + '[' + idx + ']') + '=' + encodeURIComponent(item) );
					else JsonImngObj.serialize_sub(subname + '[' + idx + ']', item, newObject);
					
				});
			else {
				var vType = typeof value;
				if (value == null || vType == 'undefined') continue;
				else if (vType == 'object') this.serialize_sub(subname, value, newObject);
				else newObject.push(encodeURIComponent(subname) + '=' + encodeURIComponent(value));
			}
		}

		return newObject;
	},
};

var PropertyImngObj = {
	contextRoot: null,

	setConfig: function (settings) {
		this.contextRoot = settings.contextRoot;
	},

	getProperty: function (propertyId, propertyKey, callback) {
		$.get(PropertyImngObj.contextRoot + '/common/property/object.json', {
			'pk.propertyId': propertyId,
			'pk.propertyKey': propertyKey,
		}).done(function (result) {
			callback(result.object);
		});
	},

	getProperties: function (propertyName, orderByKey, callback) {
		$.get(PropertyImngObj.contextRoot + '/common/property/properties.json', {
			propertyId: propertyName,
			orderByKey: orderByKey,
		}).done(function (result) {
			callback(result.object);
		});
	},
};