const info = {
	type: 'basic',
	cudUrl: '/common/privilege/object.json',
	search: {
		load: true,
		list: [			
			{ type: 'text', 	vModel: 'privilegeId',		label: this.$t('head.id'),	placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
			{
				type: 'select',
				vModel: 'privilegeType',
				label: this.$t('common.type'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.Privilege.Type',
						orderByKey: true
					},
					optionListName: 'privilegeTypeList',
					optionFor: 'option in privilegeTypeList',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
			},
			{ type: 'text', 	vModel: 'privilegeDesc',   	label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
		url: '/common/privilege/search.json',
		totalCntUrl: '/common/privilege/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
			columns: [
				{
					header: this.$t('head.id'),
					name: 'privilegeId',
					width: '35%',
				},				
            	{
					header: this.$t('common.type'),
					name: 'privilegeType',
					 width: '30%',
					 formatter : function(value) {
						 return (value.row.privilegeType == "S")? this.$t('common.privilege.type.system') : this.$t('common.privilege.type.business');
					 }
				},
				{
              		header : this.$t('head.description'),
              		name : 'privilegeDesc',
                    width: '35%',
            	},				
			],
		},
	},

	detail: {
		pk: ['privilegeId'],
		button: {
			list: [
				{ id: 'insert', isUse: true },
				{ id: 'update', isUse: true },
				{ id: 'delete', isUse: true },
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
								vModel: 'privilegeId',
								label: this.$t('head.id'),
								isPK: true,
								regExpType: 'id',
							},				
						],
						[
							{
								type: 'select',
								vModel: 'privilegeType',
								label: this.$t('common.type'),
								isRequired: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Privilege.Type',
										orderByKey: true
									},
									optionListName: 'privilegeTypeList',
									optionFor: 'option in privilegeTypeList',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},			
						],	
					],
					[
						[
							{
								type: 'textarea',
								vModel: 'privilegeDesc',
								label: this.$t('head.description'),
							},							
						]
					]
				],
			},
		],
	},
};