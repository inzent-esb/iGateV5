const info = {
	type: 'basic',
	cudUrl: '/common/metaHistory/object.json',
	search: {
		load: true,
		list: [			
			{ type: 'singleDaterange', 	vModel: 'modifyDateTimeFrom',		label: this.$t('head.from'), 	dateRangeType : 'from'},
			{ type: 'singleDaterange', 	vModel: 'modifyDateTimeTo',			label: this.$t('head.to'), 	dateRangeType : 'to'},
			{ type: 'text', 			vModel: 'entityName',				label: this.$t('common.metaHistory.entityName'),		placeholder: this.$t('head.searchName'), regExpType: 'name' },
			{ type: 'text', 			vModel: 'entityId',					label: this.$t('common.metaHistory.entityId'),			placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
			{
				type: 'select',
				vModel: 'modifyType',
				label: this.$t('common.metaHistory.modifyType'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.MetaHistory.Type',
						orderByKey: true,
					},
					optionListName: 'metaHistoryTypes',
					optionFor: 'option in metaHistoryTypes',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
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
			{ id: 'initialize', isUse: true },
			{ id: 'newTab', isUse: true },
		],
	},
	grid: {
		url: '/common/metaHistory/search.json',
		totalCntUrl: '/common/metaHistory/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
			columns: [
            	{
              		header : this.$t('head.update.timestamp'),
              		name : 'pk.modifyDateTime',
                    width: '25%',
              		align : 'center',
            	},				
				{
              		header : this.$t('common.metaHistory.entityName'),
              		name : 'entityName',
                    width: '25%',
            	},
				{
					header: this.$t('common.metaHistory.entityId'),
					name: 'entityId',
					width: '25%',
				},	
				{
					header: this.$t('common.metaHistory.modifyType'),
					name: 'modifyType',
					width: '25%',
					align: 'center',
					formatter: function(value) {
						var modifyType = value.row.modifyType;
						return 'D' == modifyType? this.$t('head.delete') : 'I' == modifyType? this.$t('head.insert') : 'R' == modifyType? this.$t('common.metaHistory.restore') : 'U' == modifyType? this.$t('head.update') : '';
					}
				},  
			],
		},
	},

	detail: {
		pk: ['pk.modifyDateTime', 'pk.modifyId'],
		button: {
			list: [
				{ 
					id: 'restore', 
					isUse: function(object) { 
						return (object.entityName !== 'com.inzent.imanager.repository.meta.User' && object.beforeDataString)? true : false; 
					} 
				},
			],
		},
		tabList: [
			{
				type: 'basic',
				label: this.$t('head.basic.info'),
				content: [
					[
						[
							{
								type: 'text',
								vModel: 'pk.modifyDateTime',
								label: this.$t('head.update.timestamp'),
								isPK: true,
							},
							{
								type: 'text',
								vModel: 'pk.modifyId',
								label: this.$t('head.modify') + ' ' + this.$t('head.id'),
								isPK: true,
							},
							{
								type: 'select',
								vModel: 'modifyType',
								label: this.$t('common.metaHistory.modifyType'),
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.MetaHistory.Type',
										orderByKey: true,
									},
									optionListName: 'metaHistoryTypes',
									optionFor: 'option in metaHistoryTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},					
						],
						[
							{
								type: 'text',
								vModel: 'entityName',
								label: this.$t('common.metaHistory.entityName'),
							},
							{
								type: 'text',
								vModel: 'entityId',
								label: this.$t('common.metaHistory.entityId'),
							},		
							{
								type: 'text',
								vModel: 'updateUserId',
								label: this.$t('common.user.id'),
							},
							{
								type: 'text',
								vModel: 'updateRemoteAddress',
								label: this.$t('common.metaHistory.updateRemoteAddress'),
							},
						],
					],
				],
			},
			{
				type: 'bundle',
				label: 'Modified Contents',
				url: '/metaHistory/Modifed',
			},
		],
	},
};