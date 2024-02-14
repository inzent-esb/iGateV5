var constants = {
	 regExpList: {
		id: { maxLength: 70, regExp: '[^A-Za-z0-9_.-]'},
		searchId: { maxLength: 70, regExp: '[^A-Za-z0-9_.#%-]'},
		name: { maxLength: 70, regExp: '' },
		value: { maxLength: 90, regExp: '' },
		desc: { maxLength: 500, regExp: '' },
		num: { maxLength: 30, regExp: '[^0-9]' },
		url: { maxLength: 100, regExp: '' },
		ip: { maxLength: 30, regExp: '[^0-9.]' },
		className: { maxLength: 200, regExp: '[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]' },
		cron: { maxLength: 30, regExp: '[^A-Za-z0-9*,#-? ]'},
		password: { maxLength: 30, regExp: '[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]'},
		pageSize: { maxLength: 4, regExp: '[^0-9]' },
		default: { maxLength: 100, regExp: '' }
	},
	
	motionDetectTime: 1000,
	autoLogoutTime: 1200000,
	
	//escape: 27, space: 32
	modalCloseKeyCode: [27, 32],
	isUseTheme: true,
	
	search: {
		searchListFunc: function(menuId, searchList) {
			/* 웹서비스 제외
			ex) 'basic' === type
			if ('103010' === menuId) {
				searchList[2].label = 'UUID';
			}
			
			ex) 'custom' === type
			if ('103020' === menuId) {
				searchList[2].name = 'UUID';
			}*/
						
			return searchList;
		}
	},
	
	grid : {
		gridOptionFunc: function(menuId, searchUrl, gridOptions) {
			/*
			 ex) 'basic' === type
			 if ('101010' === menuId) {
				gridOptions.paging.side = 'serverPaging';
				gridOptions.url = '/api/entity/record/page';
				
				gridOptions.options.columns[0].sortable = true;
				gridOptions.options.columns[0].sortingType = "desc";
				
				gridOptions.options.columns[2].sortable = true;
				gridOptions.options.columns[2].sortingType = "desc";
			}
			
			ex) 'custom' === type
			if ('101040' === menuId) {
				gridOptions.paging.side = 'serverPaging';
				gridOptions.searchUrl = '/api/entity/serviceRecognize/page';
				
				gridOptions.columns[1].sortable = true;
				gridOptions.columns[1].sortingType = "desc";
				
				gridOptions.sortColumn = "pk.telegramValue";
			}*/
			
			return gridOptions;
		},
		pageOptionFunc: function(menuId, searchUrl) {
			var limit = 100;
			var ascending = true;
			
			// 에러로그, 조작이력, 공지사항
			if ('103010' === menuId || '303020' === menuId || '303010' === menuId) {
				ascending = false;
			} else if (('101010' === menuId || '101030' === menuId || '101050' === menuId || '102040' === menuId) && '/api/entity/metaHistory/search' === searchUrl) {
				ascending = false;
			}
			
			return {
				limit: limit,
				ascending: ascending
			}
		},
		maxListCount: {
			103010 : 1000,
			103020 : 1000,
			103080 : 1000,
			201010 : 1000,
			201020 : 1000,
			105010 : 1000,
			105020 : 1000,
			105030 : 1000,
			105040 : 1000,
			105050 : 1000,
			105060 : 1000,
		}
	},
	
	detail: {
		tabListFunc: function(menuId, tabList) {
			/* 웹서비스, SAP 서비스, SAP 인터페이스, 어댑터 위자드, 어댑터, 커넥터, 배치작업 제외 		
			ex) 'basic' === type
			if ('303030' === menuId) {
				var basicInfo = tabList[0].content;
				
				basicInfo[0][0][0].label = window.$t('head.test');
			}
			
			ex) 'custom' === type
			if ('101040' === menuId) {
				var basicInfo = tabList[0].detailList[0];
				basicInfo.detailSubList[0].name = window.$t('head.test');
			}*/
			
			return tabList;
		},
		selectedInfoTitleKey: {
			101010: ['recordId', 'recordDesc'],
			101070: ['queryId', 'queryDesc'],
			101050: ['interfaceId', 'interfaceDesc'],
			102070: ['operationId', 'operationDesc'],
			202020: ['connectorId', 'connectorName'],
			202030: ['adapterId', 'adapterName'],
			302020: ['threadPoolId', 'threadPoolDesc'],
			302030: ['calendarId', 'calendarDesc'],
			303070: ['menuId', 'menuUrl'],
			303080: ['noticeTitle']
		}
	},
	
	// both, basic, external, none
	guideBtnType: 'both',
		
	//"yyyyMMddHHmmss" or "HHmmss"
	interfaceRestrictionDateFormat: 'HHmmss',
	
	//"yyyyMMddHHmmss" or "HHmmss"
	serviceRestrictionDateFormat: 'HHmmss',
	
	isDetailExpand: false
};