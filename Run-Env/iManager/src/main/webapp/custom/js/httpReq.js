function HttpReq(url) {
	this.url = url;

	HttpReq.prototype.submit = function (mode, param, callback, isViewSpinner, errorMsgCallback) {
		
		validateAccessToken({
			errorCallBackFunc: function() {
				// accessToken 유효 X
				location.reload();
			},
			successCallBackFunc: function() {
				// accessToken 유효 O
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
							validateAccessToken({
								errorCallBackFunc: function() {
									// accessToken 유효 X
									location.reload();
								},
								successCallBackFunc: function(callbackResult) {
									// accessToken 유효 O
									if(callbackResult && callbackResult.isRefresh) {
										// accessToken 갱신 O (재시도)
										this.submit(mode, param, callback, isViewSpinner, errorMsgCallback);
									} else {
										// accessToken 갱신 X (에러 처리)
										ResultImngObj.resultErrorHandler(result);
				                        
				                        if(errorMsgCallback) {
				                        	errorMsgCallback(result);
				                        } else {
				                            window._alert({
				                            	type: 'warn',
				                            	isXSSMode: false,
				                            	message: result.error.map(function(info) { 
				                            		return info.className ?  info.className + '<hr>' + info.message : info.message
				                            	}).join(',')
				                            });                        	
				                        }
									}
								}.bind(this)
							});
						}
					}.bind(this),
					error: function (request, status, error) {
						ResultImngObj.errorHandler(request, status, error);
					},
					complete: function () {
						if (isViewSpinner) window.$stopSpinner();
					}
				});
			}.bind(this)
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

function validateAccessToken(obj) {
	var successCallBackFunc = obj.successCallBackFunc;
    var errorCallBackFunc = obj.errorCallBackFunc;

    // refreshToken 유효 기한이 만료되기 전까지 accessToken가 만료되었을 때 accessToken 갱신 O => 현재 상태 유지
    // refreshToken 유효 기간 만료 시 accessToken 갱신 X => 로그아웃
    var tokenExpiration = localStorage.getItem('tokenExpiration');
    
	if (tokenExpiration && 999 <= tokenExpiration - Date.now()) {
		// accessToken 유효 O
		successCallBackFunc({ isValidateToken: true });
	} else {
		// accessToken 유효 X
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
                
                var refreshToken = localStorage.getItem('refreshToken');
                request.setRequestHeader('X-iManager-Refresh', refreshToken? refreshToken.replace('Bearer ', '') : null);    
            },
            success: function (refreshTokenResult, textStatus, jqXHR) {
                if ('ok' != refreshTokenResult.result) {
                	// accessToken 갱신 X
                	errorCallBackFunc({ isValidateToken: false, isRefresh: false });                        	
                } else {
                	// accessToken 갱신 O
                    localStorage.removeItem('accessToken');
                    localStorage.removeItem('tokenExpiration');
                    
                    var accessToken = jqXHR.getResponseHeader('X-iManager-Access');
                   
                    if (accessToken && refreshTokenResult.object) {
            			localStorage.setItem('accessToken', 'Bearer ' + accessToken);
            			localStorage.setItem('tokenExpiration', refreshTokenResult.object);
            			
            			successCallBackFunc({ isValidateToken: true, isRefresh: true });
            		}
                }
            }
        });
	}
}