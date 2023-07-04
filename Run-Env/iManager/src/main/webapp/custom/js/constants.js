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
	logInTime: 300000,
	//escape: 27, space: 32
	modalCloseKeyCode: [27, 32],
	isUseTheme: true,
	
	grid : {
		gridOptionFunc: function(gridOptions) {
			//var url = gridOptions.url? gridOptions.url : gridOptions.searchUrl;

			/*
			if ('/api/entity/record/search' === url) {
				gridOptions.paging.side = 'serverPaging';
				gridOptions.url = '/api/entity/record/page';
				
				gridOptions.options.columns[0].sortable = true;
				gridOptions.options.columns[0].sortingType = "desc";
				
				gridOptions.options.columns[2].sortable = true;
				gridOptions.options.columns[2].sortingType = "desc";
			}
			*/
			
			/*
			if ('/api/entity/serviceRecognize/search' === url) {
				gridOptions.paging.side = 'serverPaging';
				gridOptions.searchUrl = '/api/entity/serviceRecognize/page';
				
				gridOptions.columns[1].sortable = true;
				gridOptions.columns[1].sortingType = "desc";
				
				gridOptions.sortColumn = "pk.telegramValue";
			}
			*/
			
			return gridOptions;
		},
		pageOptionFunc: function(searchUrl) {
			var limit = 100;
			var ascending = true;
			
			if ('/api/entity/metaHistory/search' === searchUrl || '/api/entity/exceptionLog/search' === searchUrl || '/api/entity/notice/search' === searchUrl) {
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
		101010: {
			selectedInfoTitleKey: ['recordId', 'recordDesc']
		},
		101070: {
			selectedInfoTitleKey: ['queryId', 'queryDesc']
		},
		102070: {
			selectedInfoTitleKey: ['operationId', 'operationDesc']
		},
		101050: {
			selectedInfoTitleKey: ['interfaceId', 'interfaceDesc']
		},
		202030: {
			selectedInfoTitleKey: ['adapterId', 'adapterName']
		},
		202020: {
			selectedInfoTitleKey: ['connectorId', 'connectorName']
		},
		302020: {
			selectedInfoTitleKey: ['threadPoolId', 'threadPoolDesc']
		},
		302030: {
			selectedInfoTitleKey: ['calendarId', 'calendarDesc']
		},
		303070: {
			selectedInfoTitleKey: ['menuId', 'menuUrl']
		},
		303080: {
			selectedInfoTitleKey: ['noticeTitle']
		}
	},
	
	// both, basic, external, none
	guideBtnType: 'both',
		
	//"yyyyMMddHHmmss" or "HHmmss"
	interfaceRestrictionDateFormat: 'HHmmss',
	
	//"yyyyMMddHHmmss" or "HHmmss"
	serviceRestrictionDateFormat: 'HHmmss',
};