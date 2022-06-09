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
		},
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
	localStorage.removeItem('searchObj');
	localStorage.removeItem('selectedMenuPathIdListNewTab');
	localStorage.removeItem('isOpenNewTab');
	localStorage.removeItem('csrfToken');
	localStorage.removeItem('selectedRowMapping');
	localStorage.removeItem('selectedMenuPathIdListNewTab');

	sessionStorage.removeItem('externalMenuUrl');
	sessionStorage.removeItem('externalMenuParam');
	sessionStorage.removeItem('selectedMenuPathIdList');
	sessionStorage.removeItem('X-IMANAGER-WINDOW');
}