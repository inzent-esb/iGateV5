const info = {
	type: 'basic',	
	cudUrl: '/igate/servicePolicy/object.json',
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
				vModel: 'pk.serviceType',
				label: this.$t('common.type'),
				isPK: true,
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.Service.ServiceType',
						orderByKey: true
					},
					optionListName: 'serviceTypes',
					optionFor: 'option in serviceTypes',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
			},
			{
				type: 'modal',
				vModel: 'activityId',
				label: this.$t('igate.activity') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
				modalInfo: {
					title: this.$t('igate.activity'),
					search: {
						list: [
							{ type: 'text', vModel: 'activityId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
							{
								type: 'select',
								vModel: 'activityType',
								label: this.$t('common.type'),
								val: 'S',
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Activity.ActivityType',
										orderByKey: true
									},
									isViewAll: false,
									optionListName: 'activityTypes',
									optionFor: 'option in activityTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
									optionIf: "'S' === option.pk.propertyKey"
								},
							},							
							{ type: 'text', vModel: 'activityDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
						url: '/igate/activity/searchPopup.json',
						totalCntUrl: '/igate/activity/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: "activityId",
									header: this.$t('head.id'),
									align: "left"
								}, 
								{
									name: "activityName",
									header: this.$t('head.name'),
									align: "left"
								}, 
								{
									name: "activityType",
									header: this.$t('common.type'),
									align: "center",
									formatter: function(value) {
										var activityType = value.row.activityType;
										var messageKey = 'igate.activity.type.control';
										
										if ("F" === activityType) 			messageKey = 'igate.activity.type.control';
										else if ("A" === activityType)		messageKey = 'igate.activity.type.activity';
										else if ("S" === activityType)		messageKey = 'igate.activity.type.service';
										else if ("C" === activityType)		messageKey = 'igate.activity.type.codec';
										else if ("T" === activityType)		messageKey = 'igate.activity.type.transform';
						                else if ("I" === activityType)		messageKey = 'igate.activity.type.internal';
						                else if ("H" === activityType)		messageKey = 'igate.activity.type.telegram.handler';
										
										return this.$t(messageKey);
									}
								}, 
								{
									name: "activityDesc",
									header: this.$t('head.description'),
									align: "left"
								}			      
							],
						},						
					},
					rowClickedCallback: function(info) {
						return info.activityId;
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
		url: '/igate/servicePolicy/search.json',
		totalCntUrl: '/igate/servicePolicy/rowCount.json',
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
		            width: "40%",
				}, 
				{
					name: "pk.serviceType",
		            header: this.$t('common.type'),
		            align: "center",
		            width: "20%",
		            formatter: function(value) {
		            	var serviceType = value.row['pk.serviceType'];
		            	var messageKey = 'DB' === serviceType? 'head.db' : 'File' === serviceType? 'head.file' : 'head.online';

		            	return this.$t(messageKey);
		            }
				}, 
				{
					name: "activityId",
		            header: this.$t('igate.activity') + ' ' + this.$t('head.id'),
		            align: "left",
		            width: "40%",
				}
			]
		},
	},	
	detail: {
		pk: ['pk.adapterId', 'pk.serviceType'],
		controlUrl: '/igate/servicePolicy/control.json',
		controlParams: function(detailData) {
			return {
				'pk.adapterId': detailData['pk.adapterId'], 
				'pk.serviceType': detailData['pk.serviceType']
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
								vModel: 'pk.serviceType',
								label: this.$t('common.type'),
								isPK: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Service.ServiceType',
										orderByKey: true
									},
									optionListName: 'serviceTypes',
									optionFor: 'option in serviceTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},
							{
								type: 'modal',
								vModel: 'activityId',
								label: this.$t('igate.activity') + ' ' + this.$t('head.id'),
								isRequired: true,
								placeholder: this.$t('head.searchId'),
								modalInfo: {
									title: this.$t('igate.activity'),
									search: {
										list: [
											{ type: 'text', vModel: 'activityId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'id' },
											{
												type: 'select',
												vModel: 'activityType',
												label: this.$t('common.type'),
												val: 'S',
												optionInfo: {
													url: '/common/property/properties.json',
													params: {
														propertyId: 'List.Activity.ActivityType',
														orderByKey: true
													},
													isViewAll: false,
													optionListName: 'activityTypes',
													optionFor: 'option in activityTypes',
													optionValue: 'option.pk.propertyKey',
													optionText: 'option.propertyValue',
													optionIf: "'S' === option.pk.propertyKey"
												},
											},							
											{ type: 'text', vModel: 'activityDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
										url: '/igate/activity/searchPopup.json',
										totalCntUrl: '/igate/activity/rowCount.json',
										paging: {
											isUse: true,
											side: 'server',
										},
										options: {
											columns: [
												{
													name: "activityId",
													header: this.$t('head.id'),
													align: "left"
												}, 
												{
													name: "activityName",
													header: this.$t('head.name'),
													align: "left"
												}, 
												{
													name: "activityType",
													header: this.$t('common.type'),
													align: "center",
													formatter: function(value) {
														var activityType = value.row.activityType;
														var messageKey = 'igate.activity.type.control';
														
														if ("F" === activityType) 			messageKey = 'igate.activity.type.control';
														else if ("A" === activityType)		messageKey = 'igate.activity.type.activity';
														else if ("S" === activityType)		messageKey = 'igate.activity.type.service';
														else if ("C" === activityType)		messageKey = 'igate.activity.type.codec';
														else if ("T" === activityType)		messageKey = 'igate.activity.type.transform';
										                else if ("I" === activityType)		messageKey = 'igate.activity.type.internal';
										                else if ("H" === activityType)		messageKey = 'igate.activity.type.telegram.handler';
														
														return this.$t(messageKey);
													}
												}, 
												{
													name: "activityDesc",
													header: this.$t('head.description'),
													align: "left"
												}			      
											],
										},						
									},
									rowClickedCallback: function(info) {
										return info.activityId;
									}
								}
							},
						],
						[],
					],
				]
			}
		]
	}
};