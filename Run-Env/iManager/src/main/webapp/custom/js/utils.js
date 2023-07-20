function escapeHtml(text) {
	return $('<span />').text(text).html();
}

function unescapeHtml(text) {
	return $('<span />').html(text).text();
}

function encryptPassword(password) {
	if (!password) return null;

	var key = (function () {
		var characters = 'ABCDEF0123456789';

		var result = '';

		for (var i = 0; i < 32; i++) {
			result += characters.charAt(Math.floor(mathRandom() * characters.length));
		}

		return result;
	})();

	var encrypt = CryptoJS.AES.encrypt(password, CryptoJS.enc.Hex.parse(key), { iv: CryptoJS.enc.Hex.parse(key) });

	return '{jst}' + btoa(key + encrypt.toString());
}

function mathRandom() {
	var cryptoObj = window.crypto || window.msCrypto;

	var arr = new Uint32Array(1);

	cryptoObj.getRandomValues(arr);

	return arr[0] / Math.pow(2, 32); //4294967296
}

function numberWithComma(number) {
	return 0 === number? '0' : number ? number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '';
}

function initSelectPicker(element, selectedValue) {
	if ('undefined' != typeof selectedValue) $(element).selectpicker('val', selectedValue);
	else $(element).selectpicker();

	$(element).on({
		'show.bs.select': function (e) {
			var label = $(e.target).parents('.form-control-label');
			label.length && label.addClass('active');
		},
		'hide.bs.select': function (e) {
			var label = $(e.target).parents('.form-control-label');
			label.length && label.removeClass('active');
		}
	});
}

function getRegExpInfo(type) {
	return constants.regExpList[type];
}

function setLengthCnt(info) {
   var keyList = info.key.split('.').slice(1);
   
   var regExp = info.regExp;
   var object = this.object? this.object : this;
   var objectLetter = this.letter;
   
   keyList.forEach(function(key, index) {
      key = key.toString();
      
      if(index !== keyList.length - 1) {
         object = object[key];
         objectLetter = objectLetter[key];
      } else {      
         object[key] = object[key]? object[key].replace(new RegExp(regExp, 'g'), '') : '';
         objectLetter[key] = object[key]? object[key].length : 0;
      }
   });
}

function getUUID() {
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
		var r = (mathRandom() * 16) | 0,
			v = c == 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

function removeStorage() {
	clearStorage(localStorage, function(key) {
		return 'ckSaveUserId' === key || 'saveUserId' === key;
	});
	
	clearStorage(sessionStorage);
}

function clearStorage(storage, continueFunc) {
	for (var key in storage) {
		if (continueFunc && continueFunc(key)) continue;
		storage.removeItem(key);
	}
}

function getFileSize(fileSize){
	var rtn = 0;
	  
	if(fileSize > 0) {
		rtn = Math.round( fileSize / 1024 );
		if(rtn <= 0) rtn = 1;
	}
	  
	return rtn;
}

function changeDateFormat(date, format) {	
	if (!date) return date;
	
	return moment(new Date(date.split('.')[0].replace('-', '/'))).format(format ? format : 'YYYY-MM-DD HH:mm:ss');
}

function getNumFromStr(str) {
	return Number(str.replace(/[^0-9]/g, ''));
}

function parseFlattenObj(obj, pRoots, pSep) {
	var roots = pRoots? pRoots : []; 
	var sep = pSep? pSep : '.';
	
	return Object.keys(obj).reduce(
		function (memo, prop) {
			return Object.assign(
				{},
				memo,
				Object.prototype.toString.call(obj[prop]) === '[object Object]'
					? parseFlattenObj(obj[prop], roots.concat([prop]))
					:
					(function() {
						var source = {};
						source[roots.concat([prop]).join(sep)] = obj[prop];
						return source;
					})()
			)
		},
		{}
	);
}

function endsWith(str, searchString, position) {
	var subjectString = str.toString();

	if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
		position = subjectString.length;
	}
    
	position -= searchString.length;
    
	var lastIndex = subjectString.indexOf(searchString, position);
    
	return lastIndex !== -1 && lastIndex === position;	
}

function makeGridOptions(gridOptions, formatterData) {
	gridOptions = $.extend(true, {}, gridOptions);

	var options = {
		width: null,
		columns: [],
		header: {
			height: 32,
			align: 'center'
		},
		columnOptions: {
			resizable: true
		},
		contextMenu: function() {
			return [];
		},
		scrollX: false,
		data: []
	};
	
	options = $.extend(true, options, gridOptions);

	options.columns.forEach(function(column) {
		if (column.formatter) {
			var formatterFunc = column.formatter;

			column.formatter = function(info) {
				if (formatterData) info.formatterData = formatterData;

				return formatterFunc(info);
			};
		} else {
			column.escapeHTML = true;
		}

		if (column.width && -1 < String(column.width).indexOf('%')) {
			if (!column.copyOptions) column.copyOptions = {};

			column.copyOptions.widthRatio = column.width.replace('%', '');

			delete column.width;
		}
	});

	var onGridMounted = gridOptions.onGridMounted;
	delete options.onGridMounted;
	delete gridOptions.onGridMounted;

	options.onGridMounted = function(evt) {
		if (!evt.instance) return;

		if (!evt.instance.el) return;

		for (var attributeKey in options) {
			evt.instance.el.removeAttribute(attributeKey);
		}

		evt.instance.on('mouseover', function(mouseEvt) {
			if ('cell' !== mouseEvt.targetType) return;

			var element = mouseEvt.instance.getElement(mouseEvt.rowKey, mouseEvt.columnName);
			var value = unescapeHtml(mouseEvt.instance.getFormattedValue(mouseEvt.rowKey, mouseEvt.columnName));

			element.setAttribute('title', value);
		});

		if (onGridMounted) onGridMounted(evt);
	};
	
	var onGridUpdated = gridOptions.onGridUpdated;
	delete options.onGridUpdated;
	delete gridOptions.onGridUpdated;

	options.onGridUpdated = function(evt) {
		for (var attributeKey in options) {
			evt.instance.el.removeAttribute(attributeKey);
		}

		var resetColumnWidths = [];

		evt.instance.getColumns().forEach(function(columnInfo) {
			if (!columnInfo.copyOptions) return;

			if (columnInfo.copyOptions.widthRatio) {
				resetColumnWidths.push(evt.instance.el.offsetWidth * (columnInfo.copyOptions.widthRatio / 100));
			}
		});

		if (0 < resetColumnWidths.length) evt.instance.resetColumnWidths(resetColumnWidths);

		evt.instance.refreshLayout();

		if (onGridUpdated) onGridUpdated(evt);
	};

	return options;
}

function parseHierarchyObj(obj) {
	var result = {};
	
	for (var key in obj) {
		
		if (obj.hasOwnProperty(key)) {
			var parts = key.split('.');
			var temp = result;

			for (var i = 0; i < parts.length - 1; i++) {
				if (!temp[parts[i]]) {
					temp[parts[i]] = {};
				}
				temp = temp[parts[i]];
			}

			var lastPart = parts[parts.length - 1];

			if (typeof obj[key] === 'object' && obj[key] !== null && !Array.isArray(obj[key])) {
				temp[lastPart] = parseHierarchyObj(obj[key]);
			} else {
				temp[lastPart] = obj[key];
			}
		}
	}

	return result;
}

function downloadFileFunc(downloadObj) {
	
	var errorFunc = function() {
		window._alert({ type: 'warn', message: failMsg });
	};
	
	if(!downloadObj) {
		errorFunc();
		return;
	}
    	
	var downloadUrl = downloadObj.url;
	var downloadParam = downloadObj.param;
	var fileName = downloadObj.fileName;
	
	if(!downloadUrl || !downloadParam || !fileName) {
		errorFunc();
		return;
	}
	
	validateAccessToken({
		successCallBackFunc: function() {

			window.$startSpinner();
            
			var req = new XMLHttpRequest();

            req.open('POST', prefixUrl + downloadUrl, true);

            req.setRequestHeader('Authorization', localStorage.getItem('accessToken'));
            req.setRequestHeader('X-iManager-Method', 'GET');
            
            req.withCredentials = true;
            req.responseType = 'blob';
            
            var param = JSON.parse(JSON.stringify(downloadParam));
            req.send(JSON.stringify(param));

            req.onload = function (event) {
                window.$stopSpinner();
                
                var blob = req.response;
                var file_name = fileName;

                if (blob.size <= 0) {
                	errorFunc();
            		return;
                }

                if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                    window.navigator.msSaveOrOpenBlob(blob, file_name);
                } else {
                    var link = document.createElement('a');
                    link.href = window.URL.createObjectURL(blob);
                    link.download = file_name;
                    link.click();
                    URL.revokeObjectURL(link.href);
                    link.remove();
                }
            };
		},
		errorCallBackFunc: function() {
			errorFunc();
			return;
		}
	});
}

function uploadFileFunc(uploadObj) {
	
	var errorFunc = function() {
		window._alert({ type: 'warn', message: failMsg });
	};
	
	if(!uploadObj) {
		errorFunc();
		return;
	}
    	
	var uploadUrl = uploadObj.url;
	var uploadData = uploadObj.param;
	var callback = uploadObj.callback;
	
	if(!uploadUrl || !uploadData) {
		errorFunc();
		return;
	}
	
	validateAccessToken({
		successCallBackFunc: function() {

			window.$startSpinner();
            
			var req = new XMLHttpRequest();

            req.open('POST', prefixUrl + uploadUrl, true);

            req.setRequestHeader('Authorization', localStorage.getItem('accessToken'));
            req.setRequestHeader('X-iManager-Method', 'POST');
            
            req.withCredentials = true;
           
            console.log(uploadData)
            
            var formData = new FormData();
			formData.enctype = 'multipart/form-data';
			formData.append('uploadFile', uploadData);
			
			req.send(formData);

            req.onload = function (event) {
                window.$stopSpinner();
                
                console.log(callback)
                
                if(callback) callback(req);
            };
		},
		errorCallBackFunc: function() {
			errorFunc();
			return;
		}
	});
}