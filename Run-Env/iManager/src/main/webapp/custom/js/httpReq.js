function HttpReq(url) {
	this.url = url;

	HttpReq.prototype.submit = function (mode, param, callback, isViewSpinner, errorMsgCallback) {		
		$.ajax({
			type: 'POST',
			url: prefixUrl + this.url,
			processData: false,
	        xhrFields: {
	        	withCredentials: true
	        },			
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(parseHierarchyObj(param)),
			beforeSend: function (request) {
				if (isViewSpinner) window.$startSpinner();

                request.setRequestHeader('Authorization', localStorage.getItem('accessToken'));
                request.setRequestHeader('X-iManager-Method', (function() {
					var method = {
						'create': 'POST',
						'read': 'GET',
						'update': 'PUT',
						'delete': 'DELETE'
					};

					return method[mode];
				})());
			},
			success: function (result) {
				if ('ok' == result.result) {
					if ('read' !== mode) ResultImngObj.resultResponseHandler(result);

					if(callback) callback(result);
				} else {
					var errorCallBackFunc = function(callbackResult) {	
                        ResultImngObj.resultErrorHandler(result);
                        
                        if(errorMsgCallback) {
                        	errorMsgCallback(result);
                        } else {
                            window._alert({
                            	type: 'warn',
                            	message: result.error.map(function(info) { return  info.message || info.className; }).join(',')
                            });                        	
                        }
                        
                        if(callbackResult && !callbackResult.isValidateToken) {                        	
                        	location.reload();
                        }
                        
                    };
                    
					validateAccessToken({
						successCallBackFunc: function(callbackResult) {
							
							if(callbackResult && !callbackResult.isValidateToken) {
								// accessToken 갱신 후 재시도
								var httpReq = new HttpReq(url);

		                        if ('read' === mode) {
		                            httpReq.read(param, callback, isViewSpinner, errorMsgCallback);
		                        } else if ('create' === mode) {
		                            httpReq.create(param, callback, isViewSpinner, errorMsgCallback);
		                        } else if ('update' === mode) {
		                            httpReq.update(param, callback, isViewSpinner, errorMsgCallback);
		                        } else if ('delete' === mode) {
		                            httpReq.remove(param, callback, isViewSpinner, errorMsgCallback);
		                        }
							} else {
								// 에러 처리	
								errorCallBackFunc()
							}				
							
						}.bind(this),
						errorCallBackFunc: errorCallBackFunc,
					});
				}
			},
			error: function (request, status, error) {
				ResultImngObj.errorHandler(request, status, error);
			},
			complete: function () {
				if (isViewSpinner) window.$stopSpinner();
			}
		});
	};

	HttpReq.prototype.read = function (param, callback, isViewSpinner, errorMsgCallback) {
		this.submit('read', param, callback, isViewSpinner, errorMsgCallback);
	};

	HttpReq.prototype.create = function (param, callback, isViewSpinner, errorMsgCallback) {
		this.submit('create', param, callback, isViewSpinner, errorMsgCallback);
	};

	HttpReq.prototype.update = function (param, callback, isViewSpinner, errorMsgCallback) {
		this.submit('update', param, callback, isViewSpinner, errorMsgCallback);
	};

	HttpReq.prototype.remove = function (param, callback, isViewSpinner, errorMsgCallback) {
		this.submit('delete', param, callback, isViewSpinner, errorMsgCallback);
	};
}

// accessToken 유효한지 확인
function validateAccessToken(obj) {
    var successCallBackFunc = obj.successCallBackFunc;
    var errorCallBackFunc = obj.errorCallBackFunc;

    // refreshToken 유효 기한이 만료되기 전까지 accessToken가 만료되었을때 accessToken 갱신 O => 현재 상태 유지
    // refreshToken 유효 기간 만료 시 accessToken 갱신 X => 로그아웃
    $.ajax({
        type: 'POST',
        url: prefixUrl + '/api/auth/validateToken',
        data: null,
        xhrFields: {
            withCredentials: true,
        },
        dataType: 'json',
        beforeSend: function (request) {
        	request.setRequestHeader('X-iManager-Method', 'GET');
            request.setRequestHeader('Authorization', localStorage.getItem('accessToken'));
        },
        success: function (validateTokenResult) {
        	
            if (!validateTokenResult.object || 'ok' != validateTokenResult.result) {
            	// accessToken 유효 X
                var commonResult = { isValidateToken: false };
               
                $.ajax({
                    type: 'POST',
                    url: prefixUrl + '/api/auth/token',
                    data: JSON.stringify({ clientTimeMillis: Date.now() }),
                    xhrFields: {
                        withCredentials: true,
                    },
                    dataType: 'json',
                    beforeSend: function (request) {
                    	request.setRequestHeader('X-iManager-Method', 'PUT');
                        request.setRequestHeader('Authorization', localStorage.getItem('accessToken'));    
                        request.setRequestHeader('X-iManager-Refresh', localStorage.getItem('refreshToken').replace('Bearer ', ''));    
                    },
                    success: function (refreshTokenResult, textStatus, jqXHR) {
                        if ('ok' != refreshTokenResult.result) {
                        	// accessToken 갱신 X
                        	errorCallBackFunc(commonResult);                        	
                        } else {
                        	// accessToken 갱신 O
                            localStorage.removeItem('accessToken');
                            
                            var accessToken = jqXHR.getResponseHeader('X-iManager-Access');
                            
                            if (accessToken) {
                    			localStorage.setItem('accessToken', 'Bearer ' + accessToken);
                    			
                    			successCallBackFunc(commonResult);
                    		}
                        }
                    },
                });
            } else {
            	// accessToken 유효 O
            	successCallBackFunc();
            }
        },
    });
}