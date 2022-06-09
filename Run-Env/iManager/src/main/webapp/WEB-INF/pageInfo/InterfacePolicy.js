const info = {
	type: 'basic',	
	cudUrl: '/igate/interfacePolicy/object.json',
	search: {
		load: true,
		list: [
			{
				type: 'modal',
				vModel: 'pk.adapterId',
				label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
				modalInfo: {
					title: this.$t('igate.adapter'),
					search: {
						list: [
							{ type: 'text', vModel: 'adapterId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
							{ type: 'text', vModel: 'adapterName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name' },
							{ type: 'text', vModel: 'adapterDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
						]
					},
					button: {
						list: [
							{ id: 'initialize', isUse: true },	
						]
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
			        				name: "adapterId",
			        				header: this.$t('head.id'),
			        				align: "left"
			        			}, 
			        			{
			        				name: "adapterName",
			        				header: this.$t('head.name'),
			        				align: "left"
			        			}, 
			        			{
			        				name: "adapterDesc",
			        				header: this.$t('head.description'),
			        				align: "left"
			        			}, 
			        			{
			        				name: "requestStructure",
			        				header: this.$t('igate.adapter.structure.request'),
			        				align: "left"
			        			}, 
			        			{
			        				name: "responseStructure",
			        				header: this.$t('igate.adapter.structure.response'),
			        				align: "left"
			        			}
							],
						},						
					},
					rowClickedCallback: function(info) {
						return info.adapterId;
					}
				}
			},
			{
				type: 'select',
				vModel: 'pk.interfaceType',
				label: this.$t('common.type'),
				isPK: true,
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.Interface.InterfaceType',
						orderByKey: true
					},
					optionListName: 'interfaceTypes',
					optionFor: 'option in interfaceTypes',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
			},
			{
				type: 'modal',
				vModel: 'operationId',
				label: this.$t('igate.operation.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
				modalInfo: {
					title: this.$t('igate.operation'),
					search: {
						list: [
							{ type: 'text', vModel: 'operationId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
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
						]
					},
					button: {
						list: [
							{ id: 'initialize', isUse: true },	
						]
					},
					grid: {
						url: '/igate/operation/searchPopup.json',
						totalCntUrl: '/igate/operation/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: "operationId",
						            header: this.$t('head.id'),
						            align: "left"
								}			        		
							],
						},						
					},
					rowClickedCallback: function(info) {
						return info.operationId;
					}
				}
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
		]
	},
	button: {
		list: [
			{ id: 'add', isUse: true },
			{ id: 'initialize', isUse: true },
			{ id: 'newTab', isUse: true },
		],
	},
	grid: {
		url: '/igate/interfacePolicy/search.json',
		totalCntUrl: '/igate/interfacePolicy/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
			columns: [
				{
					name: "pk.adapterId",
		            header: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
		            align: "left",
				}, 
				{
					name: "pk.interfaceType",
		            header: this.$t('common.type'),
		            align: "center",
		            formatter: function(value) {
		            	var interfaceType = value.row['pk.interfaceType'];
		            	var messageKey = 'DB' === interfaceType? 'head.db' : 'File' === interfaceType? 'head.file' : 'head.online';

		            	return this.$t(messageKey);		            	
		            }
				}, 
				{
					name: "operationId",
		            header: this.$t('igate.operation.id'),
		            align: "left",
				}, 
			]
		},
	},
	detail: {
		pk: ['pk.adapterId', 'pk.interfaceType'],
		controlUrl: '/igate/interfacePolicy/control.json',
		controlParams: function(detailData) {
			return {
				'pk.adapterId': detailData['pk.adapterId'], 
				'pk.interfaceType': detailData['pk.interfaceType']
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
				type: 'basic',
				label: this.$t('head.basic.info'),
				content: [
					[
						[
							{
								type: 'modal',
								vModel: 'pk.adapterId',
								label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
								isPK: true,
								modalInfo: {
									title: this.$t('igate.adapter'),
									search: {
										list: [
											{ type: 'text', vModel: 'adapterId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'id' },
											{ type: 'text', vModel: 'adapterName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name' },
											{ type: 'text', vModel: 'adapterDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
										]
									},
									button: {
										list: [
											{ id: 'initialize', isUse: true },	
										]
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
							        				name: "adapterId",
							        				header: this.$t('head.id'),
							        				align: "left"
							        			}, 
							        			{
							        				name: "adapterName",
							        				header: this.$t('head.name'),
							        				align: "left"
							        			}, 
							        			{
							        				name: "adapterDesc",
							        				header: this.$t('head.description'),
							        				align: "left"
							        			}, 
							        			{
							        				name: "requestStructure",
							        				header: this.$t('igate.adapter.structure.request'),
							        				align: "left"
							        			}, 
							        			{
							        				name: "responseStructure",
							        				header: this.$t('igate.adapter.structure.response'),
							        				align: "left"
							        			}
											],
										},						
									},
									rowClickedCallback: function(info) {
										return info.adapterId;
									}
								}
							},
							{
								type: 'select',
								vModel: 'pk.interfaceType',
								label: this.$t('common.type'),
								isPK: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Interface.InterfaceType',
										orderByKey: true
									},
									optionListName: 'interfaceTypes',
									optionFor: 'option in interfaceTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},
						],
						[
							{
								type: 'modal',
								vModel: 'operationId',
								label: this.$t('igate.operation.id'),
								isRequired: true,
								modalInfo: {
									title: this.$t('igate.operation'),
									search: {
										list: [
											{ type: 'text', vModel: 'operationId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'id' },
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
										]
									},
									button: {
										list: [
											{ id: 'initialize', isUse: true },	
										]
									},
									grid: {
										url: '/igate/operation/searchPopup.json?operationType=I',
										totalCntUrl: '/igate/operation/rowCount.json?operationType=I',
										paging: {
											isUse: true,
											side: 'server',
										},
										options: {
											columns: [
												{
													name: "operationId",
										            header: this.$t('head.id'),
										            align: "left"
												}			        		
											],
										},						
									},
									rowClickedCallback: function(info) {
										return info.operationId;
									}
								}
							},
							{
								type: 'select',
								vModel: 'instanceId',
								label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
								val: ' ',
								optionInfo: {
									url: '/igate/instance/list.json',
									optionListName: 'instances',
									optionFor: 'option in instances',
									optionValue: 'option.instanceId',
									optionText: 'option.instanceId',
									isViewEmpty: true,
								},
							},
						],							
					],
				],
			}
		]
	}
};