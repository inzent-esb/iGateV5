const info = {
	type: 'basic',
	cudUrl: '/igate/serviceRecognize/object.json',
	search: {
		load: true,
		list: [
			{
				type: 'modal',
				regExpType: 'searchId',
				modalInfo: {
					title: this.$t('igate.adapter'),
					search: {
						list: [
							{ type: 'text', vModel: 'adapterId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId', },
							{ type: 'text', vModel: 'adapterName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name', },
							{ type: 'text', vModel: 'adapterDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc', },
							{
								type: 'dataList',
								vModel: 'pageSize',
								label: this.$t('head.listCount'),
								val: '10',
								optionInfo: {
									optionFor: 'option in [10, 100, 1000]',
									optionValue: 'option',
									optionText: 'option',
								},
							},
						],
					},
					button: {
						list: [{ id: 'initialize', isUse: true }],
					},
					grid: {
						url: '/igate/adapter/searchPopup.json',
						totalCntUrl: '/igate/adapter/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: 'adapterId',
									header: this.$t('head.id'),
									width: '20%',
								},
								{
									name: 'adapterName',
									header: this.$t('head.name'),
									width: '20%',
								},
								{
									name: 'adapterDesc',
									header: this.$t('head.description'),
									width: '20%',
								},
								{
									name: 'requestStructure',
									header: this.$t('igate.adapter.structure.request'),
									width: '20%',
								},
								{
									name: 'responseStructure',
									header: this.$t('igate.adapter.structure.response'),
									width: '20%',
								},
							],
						},
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.adapterId;
					},
				},
				vModel: 'pk.adapterId',
				label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId') 
			},
			{ type: 'text', vModel: 'pk.telegramValue', label: this.$t('igate.telegramValue'), placeholder: this.$t('head.searchTelegram'), regExpType: 'name', },
			{ 
				type: 'modal',
				regExpType: 'searchId',
				modalInfo: {
					title: this.$t('igate.service'),
					search: {
						list: [
							{ type: 'text', vModel: 'serviceId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId', },
							{ type: 'text', vModel: 'serviceName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name', },
							{
								type: 'dataList',
								vModel: 'pageSize',
								label: this.$t('head.listCount'),
								val: '10',
								optionInfo: {
									optionFor: 'option in [10, 100, 1000]',
									optionValue: 'option',
									optionText: 'option',
								},
							},
						],
					},
					button: {
						list: [{ id: 'initialize', isUse: true }],
					},
					grid: {
						url: '/igate/service/searchPopup.json',
						totalCntUrl: '/igate/service/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: 'serviceId',
									header: this.$t('head.id'),
									width: '25%',
								},
								{
									name: 'serviceName',
									header: this.$t('head.name'),
									width: '25%',
								},
								{
									name: 'serviceDesc',
									header: this.$t('head.description'),
									width: '25%',
								},
								{
									name: 'serviceType',
									header: this.$t('common.type'),
									width: '25%',
								},
							],
						},
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.serviceId;
					},
				},
				vModel: 'serviceId',
				label: this.$t('igate.service') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId') 
			},
			{
				type: 'dataList',
				vModel: 'pageSize',
				label: this.$t('head.listCount'),
				val: '10',
				optionInfo: {
					optionFor: 'option in [10, 100, 1000]',
					optionValue: 'option',
					optionText: 'option',
				},
			},
		],
	},
	button: {
		list: [
			{ id: 'add', isUse: true },
			{ id: 'initialize', isUse: true },
			{ id: 'newTab', isUse: true },
		],
	},
	grid: {
		url: '/igate/serviceRecognize/search.json',
		totalCntUrl: '/igate/serviceRecognize/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
			columns: [
				{
					name: "pk.adapterId",
					header: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
					width: "25%",
				},
				{
					name: "pk.telegramValue",
					header: this.$t('igate.telegramValue'),
					width: "50%",
				},
				{
					name: "serviceId",
					header: this.$t('igate.service') + ' ' + this.$t('head.id'),
					width: "25%",
				},
			]
		}
	},
	
	detail: {
		pk: ['pk.adapterId', 'pk.telegramValue'],
		controlUrl: '/igate/serviceRecognize/control.json',
		controlParams: function(detailData) {
			return {
				'pk.adapterId': detailData['pk.adapterId'], 
				'pk.telegramValue': detailData['pk.telegramValue'], 
			};
		},		
		button: {
			list: [
				{ id: 'insert', isUse: true },
				{ id: 'update', isUse: true },
				{ id: 'delete', isUse: true },
				{ id: 'dump', isUse: true },
			],
		},
		tabList: [
			{
				type: 'bundle',
				url: '/serviceRecognize/BasicInfo',
				label: this.$t('head.basic.info'),
			},
		]
	},
};