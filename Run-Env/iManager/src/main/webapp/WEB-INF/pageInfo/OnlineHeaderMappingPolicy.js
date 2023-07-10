const info = {
	type: "basic",
	cudUrl: '/api/entity/onlineHeaderMappingPolicy/object',
	search: {
		load: true,
		list: [
			{
				type: "modal",
				vModel: "pk.interfaceAdapterId",
				label:
					this.$t("igate.interface") +
					" " +
					this.$t("igate.adapter") +
					" " +
					this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
				modalInfo: {
					title: this.$t("igate.adapter"),
					search: {
						list: [
							{
								type: "text",
								vModel: "adapterId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "adapterName",
								label: this.$t("head.name"),
								placeholder: this.$t("head.searchName"),
								regExpType: "name"
							},
							{
								type: "text",
								vModel: "adapterDesc",
								label: this.$t("head.description"),
								placeholder: this.$t("head.searchComment"),
								regExpType: "desc"
							},
							{
								type: "dataList",
								vModel: "pageSize",
								label: this.$t("head.listCount"),
								val: "10",
								optionInfo: {
									optionFor: "option in [10, 100, 1000]",
									optionValue: "option",
									optionText: "option"
								}
							}
						]
					},
					button: {
						list: [{ id: "initialize", isUse: true }]
					},
					grid: {
						url: '/api/entity/adapter/search',
						totalCntUrl: '/api/entity/adapter/count',						
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "adapterId",
									header: this.$t("head.id"),
									align: "left"
								},
								{
									name: "adapterName",
									header: this.$t("head.name"),
									align: "left"
								},
								{
									name: "adapterDesc",
									header: this.$t("head.description"),
									align: "left"
								},
								{
									name: "requestStructure",
									header: this.$t(
										"igate.adapter.structure.request"
									),
									align: "left"
								},
								{
									name: "responseStructure",
									header: this.$t(
										"igate.adapter.structure.response"
									),
									align: "left"
								}
							]
						}
					},
					rowClickedCallback: function (info) {
						return info.adapterId;
					}
				}
			},
			{
				type: "modal",
				vModel: "pk.serviceAdapterId",
				label:
					this.$t("igate.service") +
					" " +
					this.$t("igate.adapter") +
					" " +
					this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
				modalInfo: {
					title: this.$t("igate.adapter"),
					search: {
						list: [
							{
								type: "text",
								vModel: "adapterId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "adapterName",
								label: this.$t("head.name"),
								placeholder: this.$t("head.searchName"),
								regExpType: "name"
							},
							{
								type: "text",
								vModel: "adapterDesc",
								label: this.$t("head.description"),
								placeholder: this.$t("head.searchComment"),
								regExpType: "desc"
							},
							{
								type: "dataList",
								vModel: "pageSize",
								label: this.$t("head.listCount"),
								val: "10",
								optionInfo: {
									optionFor: "option in [10, 100, 1000]",
									optionValue: "option",
									optionText: "option"
								}
							}
						]
					},
					button: {
						list: [{ id: "initialize", isUse: true }]
					},
					grid: {
						url: '/api/entity/adapter/search',
						totalCntUrl: '/api/entity/adapter/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "adapterId",
									header: this.$t("head.id"),
									align: "left"
								},
								{
									name: "adapterName",
									header: this.$t("head.name"),
									align: "left"
								},
								{
									name: "adapterDesc",
									header: this.$t("head.description"),
									align: "left"
								},
								{
									name: "requestStructure",
									header: this.$t(
										"igate.adapter.structure.request"
									),
									align: "left"
								},
								{
									name: "responseStructure",
									header: this.$t(
										"igate.adapter.structure.response"
									),
									align: "left"
								}
							]
						}
					},
					rowClickedCallback: function (info) {
						return info.adapterId;
					}
				}
			},
			{
				type: "dataList",
				vModel: "pageSize",
				label: this.$t("head.listCount"),
				val: "10",
				optionInfo: {
					optionFor: "option in [10, 100, 1000]",
					optionValue: "option",
					optionText: "option"
				}
			}
		]
	},
	button: {
		list: [
			{ id: "add", isUse: true },
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: '/api/entity/onlineHeaderMappingPolicy/search',
		totalCntUrl: '/api/entity/onlineHeaderMappingPolicy/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "pk.interfaceAdapterId",
					header:
						this.$t("igate.interface") +
						" " +
						this.$t("igate.adapter") +
						" " +
						this.$t("head.id"),
					align: "left"
				},
				{
					name: "pk.serviceAdapterId",
					header:
						this.$t("igate.service") +
						" " +
						this.$t("igate.adapter") +
						" " +
						this.$t("head.id"),
					align: "left"
				}
			]
		}
	},
	detail: {
		pk: ["pk.interfaceAdapterId", "pk.serviceAdapterId"],
		controlParams: function (detailData) {
			return detailData;
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/onlineHeaderMappingPolicy/dump' }
			]
		},
		tabList: [
			{
				type: "basic",
				label: this.$t("head.basic.info"),
				content: [
					[
						[
							{
								type: "modal",
								vModel: "pk.interfaceAdapterId",
								label:
									this.$t("igate.interface") +
									" " +
									this.$t("igate.adapter") +
									" " +
									this.$t("head.id"),
								isPK: true,
								modalInfo: {
									title: this.$t("igate.adapter"),
									search: {
										list: [
											{
												type: "text",
												vModel: "adapterId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "text",
												vModel: "adapterName",
												label: this.$t("head.name"),
												placeholder:
													this.$t("head.searchName"),
												regExpType: "name"
											},
											{
												type: "text",
												vModel: "adapterDesc",
												label: this.$t(
													"head.description"
												),
												placeholder:
													this.$t(
														"head.searchComment"
													),
												regExpType: "desc"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/adapter/search',
										totalCntUrl: '/api/entity/adapter/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "adapterId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "adapterName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "adapterDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												},
												{
													name: "requestStructure",
													header: this.$t(
														"igate.adapter.structure.request"
													),
													align: "left"
												},
												{
													name: "responseStructure",
													header: this.$t(
														"igate.adapter.structure.response"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.adapterId;
									}
								}
							},
							{
								type: "modal",
								vModel: "pk.serviceAdapterId",
								label:
									this.$t("igate.service") +
									" " +
									this.$t("igate.adapter") +
									" " +
									this.$t("head.id"),
								isPK: true,
								modalInfo: {
									title: this.$t("igate.adapter"),
									search: {
										list: [
											{
												type: "text",
												vModel: "adapterId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "text",
												vModel: "adapterName",
												label: this.$t("head.name"),
												placeholder:
													this.$t("head.searchName"),
												regExpType: "name"
											},
											{
												type: "text",
												vModel: "adapterDesc",
												label: this.$t(
													"head.description"
												),
												placeholder:
													this.$t(
														"head.searchComment"
													),
												regExpType: "desc"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/adapter/search',
										totalCntUrl: '/api/entity/adapter/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "adapterId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "adapterName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "adapterDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												},
												{
													name: "requestStructure",
													header: this.$t(
														"igate.adapter.structure.request"
													),
													align: "left"
												},
												{
													name: "responseStructure",
													header: this.$t(
														"igate.adapter.structure.response"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.adapterId;
									}
								}
							}
						],
						[
							{
								type: "modal",
								vModel: "requestMappingId",
								label: this.$t(
									"igate.onlineHeaderMappingPolicy.requestMappingId"
								),
								modalInfo: {
									title: this.$t("igate.mapping"),
									search: {
										list: [
											{
												type: "text",
												vModel: "mappingId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/mapping/search',
										totalCntUrl: '/api/entity/mapping/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "mappingId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.mappingId;
									}
								}
							},
							{
								type: "modal",
								vModel: "responseMappingId",
								label: this.$t(
									"igate.onlineHeaderMappingPolicy.responseMappingId"
								),
								modalInfo: {
									title: this.$t("igate.mapping"),
									search: {
										list: [
											{
												type: "text",
												vModel: "mappingId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/mapping/search',
										totalCntUrl: '/api/entity/mapping/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "mappingId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.mappingId;
									}
								}
							},
							{
								type: "modal",
								vModel: "replyMappingId",
								label: this.$t(
									"igate.onlineHeaderMappingPolicy.replyMappingId"
								),
								modalInfo: {
									title: this.$t("igate.mapping"),
									search: {
										list: [
											{
												type: "text",
												vModel: "mappingId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/mapping/search',
										totalCntUrl: '/api/entity/mapping/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "mappingId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.mappingId;
									}
								}
							},
							{
								type: "modal",
								vModel: "createMappingId",
								label: this.$t(
									"igate.onlineHeaderMappingPolicy.createMappingId"
								),
								modalInfo: {
									title: this.$t("igate.mapping"),
									search: {
										list: [
											{
												type: "text",
												vModel: "mappingId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
									},
									grid: {
										url: '/api/entity/mapping/search',
										totalCntUrl: '/api/entity/mapping/count',											
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "mappingId",
													header: this.$t("head.id"),
													align: "left"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info.mappingId;
									}
								}
							}
						]
					]
				]
			}
		]
	}
};
