function HttpReq(url) {
	this.url = url;

	HttpReq.prototype.submit = function (mode, param, callback, skipSpinner) {
		var X_IMANAGER_WINDOW = null;
		
		if (param) {
			if ('string' === typeof param) {
				if (-1 < param.indexOf('NEW-WINDOW-ID')) {
					var splitParam = param.split('&');
					
					for (var i = 0; i < splitParam.length; i++) {
						if (-1 < splitParam[i].indexOf('NEW-WINDOW-ID')) {
							X_IMANAGER_WINDOW = splitParam[i].split('=')[1]; 
							break;
						}
					}
					
					param = splitParam.filter(function(info) {
						return -1 === info.indexOf('NEW-WINDOW-ID')
					}).join('&');
				} else {
					X_IMANAGER_WINDOW = sessionStorage.getItem('X-IMANAGER-WINDOW');
				}
			} else {
				if (param['NEW-WINDOW-ID']) {
					X_IMANAGER_WINDOW = param['NEW-WINDOW-ID'];
					delete param['NEW-WINDOW-ID'];
				} else {
					X_IMANAGER_WINDOW = sessionStorage.getItem('X-IMANAGER-WINDOW');
				}
			}
		} else {
			X_IMANAGER_WINDOW = sessionStorage.getItem('X-IMANAGER-WINDOW');	
		}		
		
		$.ajax({
			type: 'read' === mode ? 'GET' : 'POST',
			url: prefixUrl + this.url,
			processData: false,
	        xhrFields: {
	        	withCredentials: true
	        },			
			data: (function () {
				if (!param) return '';
				
				var data = null;

				if ('string' === typeof param) {
					data = param;
				} else {
					var tmpParam = JSON.parse(JSON.stringify(param));

					if ('read' != mode) {
						tmpParam._method = 'create' === mode ? 'PUT' : 'update' === mode ? 'POST' : 'DELETE';
					}

					data = JsonImngObj.serialize(tmpParam);
				}

				return data;
			})(),
			xhrFields: {
				withCredentials: true,
			},
			dataType: 'json',
			beforeSend: function (request) {
				if (!skipSpinner) window.$startSpinner();
				
                request.setRequestHeader('X-IMANAGER-WINDOW', X_IMANAGER_WINDOW);
                
				var csrfToken = JSON.parse(localStorage.getItem('csrfToken'));
				request.setRequestHeader(csrfToken.headerName, csrfToken.token);
			},
			success: function (result) {
				if ('ok' == result.result) {
					if ('read' !== mode) ResultImngObj.resultResponseHandler(result);

					callback(result);
				} else {
					$.ajax({
						type: 'GET',
						url: prefixUrl + '/igate/page/common/validateSession.json',
						processData: false,
				        xhrFields: {
				        	withCredentials: true
				        },
				        success: function (validateSessionResult) {
				        	if (!validateSessionResult.object) {
				        		location.reload();
				        	} else {
								ResultImngObj.resultErrorHandler(result);
								window._alert({type: 'warn', message: failMessage});				        		
				        	}
				        }
					});
				}
			},
			error: function (request, status, error) {
				ResultImngObj.errorHandler(request, status, error);
			},
			complete: function () {
				if (!skipSpinner) window.$stopSpinner();
			},
		});
	};

	HttpReq.prototype.read = function (param, callback, skipSpinner) {
		this.submit('read', param, callback, skipSpinner);
	};

	HttpReq.prototype.create = function (param, callback, skipSpinner) {
		this.submit('create', param, callback, skipSpinner);
	};

	HttpReq.prototype.update = function (param, callback, skipSpinner) {
		this.submit('update', param, callback, skipSpinner);
	};

	HttpReq.prototype.remove = function (param, callback, skipSpinner) {
		this.submit('delete', param, callback, skipSpinner);
	};
}