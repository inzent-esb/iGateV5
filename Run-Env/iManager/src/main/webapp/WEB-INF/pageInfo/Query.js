const info = {
		type: 'basic',
		cudUrl: '/igate/query/object.json',
		search: {
			load: true,
			list: [
				{ type: 'text', vModel: 'queryId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId', },
				{ type: 'text', vModel: 'queryName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name', },
				{
					type: 'select',
					vModel: 'queryType',
					label: this.$t('common.type'),
					optionInfo: {
						url: '/common/property/properties.json',
						params: {
							propertyId: 'List.Query.QueryType',
							orderByKey: true,
						},
						optionListName: 'queryTypeList',
						optionFor: 'option in queryTypeList',
						optionValue: 'option.pk.propertyKey',
						optionText: 'option.propertyValue',
					},
				},				
				{
					type: 'text',
					vModel: 'queryGroup',
					label: this.$t('head.group'),
					placeholder: this.$t('head.searchId'),
				},
				{
					type: 'dataList',
					vModel: 'privilegeId',
					label: this.$t('common.privilege'),
					placeholder: this.$t('head.searchData'),
					regExpType: 'searchId',
					optionInfo: {
						url: '/common/privilege/list.json',
						params: {
							privilegeType: 'b',
						},
						optionListName: 'privilegeTypeList',
						optionFor: 'option in privilegeTypeList',
						optionValue: 'option.privilegeId',
						optionText: 'option.privilegeId',
					},
				},				
				{
					type: 'text',
					vModel: 'queryDesc',
					label: this.$t('head.description'),
					placeholder: this.$t('head.searchComment'),
					regExpType: 'desc',
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
			url: '/igate/query/search.json',
			totalCntUrl: '/igate/query/rowCount.json',
			paging: {
				isUse: true,
				side: 'server',
			},
			options: {
				columns: [
					{
						name: "queryId",
						header: this.$t('head.id'),
						width: "20%",
					},
					{
						name: "queryName",
						header: this.$t('head.name'),
						width: "20%",
					},
					{
						name: 'queryType',
						header: this.$t('common.type'),
						width: '15%',
						align: 'center',
						formatter: function(param) {
							return 'F' === param.value? 'Single Select' : 'S' === param.value? 'Multi Select' : 'U' === param.value? 'Single Update/Delete' : 'B' === param.value? 'Multi Update/Delete' : '';
						}
					},				
					{
						header: this.$t('head.group'),
						name: 'queryGroup',
						width: '10%',
					},
					{
						name: "privilegeId",
						header: this.$t('common.privilege'),
						width: "10%",
					},					
					{
						header: this.$t('head.description'),
						name: 'queryDesc',
						width: '25%',
					},					
				]
			}
		},
		
		detail: {
			pk: ['queryId'],
			controlUrl: '/igate/query/control.json',
			controlParams: function(detailData) {
				return {
					queryId: detailData.queryId
				};
			},			
			button: {
				list: [
					{ id: 'dump', isUse: true },
				],
			},
			tabList: [
				{
					type: 'bundle',
					label: this.$t('head.basic.info'),
					url: '/query/BasicInfo',
				},
				{
					type: 'basic',
					label: this.$t('head.resource.inuse.info'),
					content: [
						[
							[
								{
									type: 'text',
									vModel: 'lockUserId',
									label: this.$t('head.lock.userId'),
									readonly: true,
									val: '0',
								},
								{
									type: 'text',
									vModel: 'updateVersion',
									label: this.$t('head.updateVersion'),
									readonly: true,
									val: '0',
								},
							],
							[
								{
									type: 'text',
									vModel: 'updateUserId',
									label: this.$t('head.update.userId'),
									readonly: true,
								},
								{
									type: 'text',
									vModel: 'updateTimestamp',
									label: this.$t('head.update.timestamp'),
									readonly: true,
								},
							],
						],
					],
				},
			]
		},
};