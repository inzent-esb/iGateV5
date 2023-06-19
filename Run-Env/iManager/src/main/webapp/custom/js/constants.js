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
		// only server type
		pageOptions: {
			notice: {
				limit: 100,
				ascending: false
			},
			default: {
				limit: 100,
				ascending: false			
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