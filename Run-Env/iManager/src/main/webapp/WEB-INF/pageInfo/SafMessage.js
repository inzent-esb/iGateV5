const info = {
		type: 'basic',
		cudUrl: '/igate/safMessage/object.json',
		updateStatusFunc: function(row, mod) {
			return {
				url: 'ready' === mod? '/igate/safMessage/updateReady.json' : '/igate/safMessage/updateCancel.json',
				params: {
					safStatus: row.safStatus
				},
				columnName: 'safStatus',
			}
		},
		search: {
			list: [
				{ type: 'singleDaterange', vModel: 'fromCreateDateTime', label: this.$t('head.from'), dateRangeType: 'from' },
				{ type: 'singleDaterange', vModel: 'toCreateDateTime', label: this.$t('head.to'), dateRangeType: 'to' },
				{
					type: 'text',
					vModel: 'transactionId',
					label: this.$t('head.transaction') + ' ' + this.$t('head.id'),
					placeholder: this.$t('head.searchId'),
					regExpType: 'searchId',
				},					
				{
					type: 'modal',
					modalInfo: {
						title: this.$t('igate.service'),
						search: {
							list: [
								{
									type: 'text',
									vModel: 'serviceId',
									label: this.$t('head.id'),
									placeholder: this.$t('head.searchId'),
									regExpType: 'searchId',
								},
								{
									type: 'text',
									vModel: 'serviceName',
									label: this.$t('head.name'),
									placeholder: this.$t('head.searchName'),
									regExpType: 'name',
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
					placeholder: this.$t('head.searchId'),
					regExpType: 'searchId',
				},					
				{
					type: 'select',
					vModel: 'safStatus',
					label: this.$t('head.status'),
					optionInfo: {
						url: '/common/property/properties.json',
						params: {
							propertyId: 'List.SafMessage.Status',
							orderByKey: true,
						},
						optionListName: 'safStatusList',
						optionFor: 'option in safStatusList',
						optionValue: 'option.pk.propertyKey',
						optionText: 'option.propertyValue',
					},
				},				
				{
					type: 'modal',
					vModel: 'interfaceId',
					label: this.$t('igate.interface') + ' ' + this.$t('head.id'),
					placeholder: this.$t('head.searchId'),
					regExpType: 'searchId',
					modalInfo: {
						title: this.$t('igate.interface'),
						search: {
							list: [
								{
									type: 'text',
									vModel: 'interfaceId',
									label: this.$t('head.id'),
									placeholder: this.$t('head.searchId'),
									regExpType: 'searchId',
								},
								{
									type: 'text',
									vModel: 'interfaceName',
									label: this.$t('head.name'),
									placeholder: this.$t('head.searchName'),
									regExpType: 'name',
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
							list: [{ id: 'initialize', isUse: true }],
						},
						grid: {
							url: '/igate/interface/searchPopup.json',
							totalCntUrl: '/igate/interface/rowCount.json',
							paging: {
								isUse: true,
								side: 'server',
							},
							options: {
								columns: [
									{
										header: this.$t('head.id'),
										name: 'interfaceId',
									},
									{
										header: this.$t('head.name'),
										name: 'interfaceName',
									},
									{
										header: this.$t('head.description'),
										name: 'interfaceDesc',
									},
									{
										header:  this.$t('common.type'),
										name: 'interfaceType',
									},
								],
							},
						},
						rowClickedCallback: function(rowInfo) {
							return rowInfo.interfaceId;
						},
					},
				},		
				{
					type: 'text',
					vModel: 'pk.safId',
					label: this.$t('igate.saf') + ' ' + this.$t('head.id'),
					placeholder: this.$t('head.searchId'),
					regExpType: 'searchId',
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
				{ id: 'updateCancel', isUse: true },
				{ id: 'updateReady', isUse: true },
				{ id: 'newTab', isUse: true },
			],
		},
		grid: {
			url: '/igate/safMessage/search.json',
			totalCntUrl: '/igate/safMessage/rowCount.json',
			paging: {
				isUse: true,
				side: 'server',
			},
			options: {
				rowHeaders: ['checkbox'],
				columns: [
					{
						name: 'pk.createDateTime',
						header: this.$t('igate.connectorControl.create') + ' ' + this.$t('head.date'),
						align: 'center',
					},
					{
						name: 'transactionId',
						header: this.$t('head.transaction') + ' ' + this.$t('head.id'),
					},
					{
						name: 'serviceId',
						header: this.$t('igate.service') + ' ' + this.$t('head.id'),
					},					
					{
						name: 'safStatus',
						header: this.$t('igate.saf') + ' ' + this.$t('head.status'),
						align: 'center',
						formatter: function(value) {
							switch (value.row.safStatus) {
								case 'R': {
									return this.$t('igate.safMessage.ready');
								}
								case 'A': {
									return this.$t('igate.safMessage.active');
								}
								case 'E': {
									return this.$t('igate.safMessage.expired');
								}
								case 'D': {
									return this.$t('igate.safMessage.done');
								}
								case 'C': {
									return this.$t('igate.safMessage.cancel');
								}
							}
						},
					},					
					{
						name: 'interfaceId',
						header: this.$t('igate.interface') + ' ' + this.$t('head.id'),
					},
					{
						name: 'pk.safId',
						header: this.$t('igate.saf') + ' ' + this.$t('head.id'),
					},					
				]
			},
		},
		
		detail: {
			pk: ['pk.createDateTime', 'pk.adapterId', 'pk.instanceId', 'pk.safId'],
			button: {
				list: [],
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
									vModel: 'pk.createDateTime',
									label: this.$t('igate.connectorControl.create') + ' ' + this.$t('head.date'),
									isPK: true,
								},
								{
									type: 'text',
									vModel: 'pk.adapterId',
									label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
									isPK: true,
								},
								{
									type: 'text',
									vModel: 'pk.instanceId',
									label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
									isPK: true,
								},
								{
									type: 'text',
									vModel: 'pk.safId',
									label: this.$t('igate.saf') + ' ' + this.$t('head.id'),
									isPK: true,
								},
							],
							[
								{
									type: 'text',
									vModel: 'transactionId',
									label: this.$t('head.transaction') + ' ' + this.$t('head.id'),
								},
								{
									type: 'text',
									vModel: 'messageId',
									label: this.$t('igate.message') + ' ' + this.$t('head.id'),
								},
								{
									type: 'text',
									vModel: 'interfaceId',
									label: this.$t('igate.interface') + ' ' + this.$t('head.id'),
								},
								{
									type: 'text',
									vModel: 'serviceId',
									label: this.$t('igate.service') + ' ' + this.$t('head.id'),
								},
								{
									type: 'text',
									vModel: 'safStatus',
									label: this.$t('igate.saf') + ' ' + this.$t('head.status'),			
									formatter: function(value) {
										switch (value) {
											case 'R': {
												return this.$t('igate.safMessage.ready');
											}
											case 'A': {
												return this.$t('igate.safMessage.active');
											}
											case 'E': {
												return this.$t('igate.safMessage.expired');
											}
											case 'D': {
												return this.$t('igate.safMessage.done');
											}
											case 'C': {
												return this.$t('igate.safMessage.cancel');
											}
										}
									}.bind(this)
								}
							],							
						],
					],
				},
			],
		},
		
};