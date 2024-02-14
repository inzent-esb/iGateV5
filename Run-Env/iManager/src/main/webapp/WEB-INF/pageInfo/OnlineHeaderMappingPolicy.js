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
									align: "left",
									width: "20%"	
								},
								{
									name: "adapterName",
									header: this.$t("head.name"),
									align: "left",
									width: "20%"
								},
								{
									name: "adapterDesc",
									header: this.$t("head.description"),
									align: "left",
									width: "20%"
								},
								{
									name: "requestStructure",
									header: this.$t(
										"igate.adapter.structure.request"
									),
									align: "left",
									width: "20%"
								},
								{
									name: "responseStructure",
									header: this.$t(
										"igate.adapter.structure.response"
									),
									align: "left",
									width: "20%"
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
									align: "left",
									width: "20%"
								},
								{
									name: "adapterName",
									header: this.$t("head.name"),
									align: "left",
									width: "20%"
								},
								{
									name: "adapterDesc",
									header: this.$t("head.description"),
									align: "left",
									width: "20%"
								},
								{
									name: "requestStructure",
									header: this.$t("igate.adapter.structure.request"),
									align: "left",
									width: "20%"
								},
								{
									name: "responseStructure",
									header: this.$t("igate.adapter.structure.response"),
									align: "left",
									width: "20%"
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
					align: "left",
					width: "50%"
				},
				{
					name: "pk.serviceAdapterId",
					header:
						this.$t("igate.service") +
						" " +
						this.$t("igate.adapter") +
						" " +
						this.$t("head.id"),
					align: "left",
					width: "50%"
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
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/onlineHeaderMappingPolicy/dump' },
				{ id: 'reference', isUse: true, className: 'com.inzent.igate.repository.meta.OnlineHeaderMappingPolicy' }
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
								clickEvt: function (component) {
									openNewTab('202030', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"adapterId": component.getData()['pk.interfaceAdapterId']}));
									});
								},
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
													align: "left",
													width: "20%"
												},
												{
													name: "adapterName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "adapterDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "requestStructure",
													header: this.$t(
														"igate.adapter.structure.request"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "responseStructure",
													header: this.$t(
														"igate.adapter.structure.response"
													),
													align: "left",
													width: "20%"
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
								clickEvt: function (component) {
									openNewTab('202030', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"adapterId": component.getData()['pk.serviceAdapterId']}));
									});
								},
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
													align: "left",
													width: "20%"
												},
												{
													name: "adapterName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "adapterDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "requestStructure",
													header: this.$t(
														"igate.adapter.structure.request"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "responseStructure",
													header: this.$t(
														"igate.adapter.structure.response"
													),
													align: "left",
													width: "20%"
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
								clickEvt: function (component) {
									const searchData = component.getData().requestMappingId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "mappingId": searchData }));
									});
								},
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
													align: "left",
													width: "30%"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "30%"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "40%"
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
								clickEvt: function (component) {
									const searchData = component.getData().responseMappingId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "mappingId": searchData }));
									});
								},
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
													align: "left",
													width: "30%"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "30%"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "40%"
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
								clickEvt: function (component) {
									const searchData = component.getData().replyMappingId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "mappingId": searchData }));
									});
								},
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
													align: "left",
													width: "30%"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "30%"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "40%"
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
								clickEvt: function (component) {
									const searchData = component.getData().createMappingId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "mappingId": searchData }));
									});
								},
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
													align: "left",
													width: "30%"
												},
												{
													name: "mappingName",
													header: this.$t(
														"head.name"
													),
													align: "left",
													width: "30%"
												},
												{
													name: "mappingDesc",
													header: this.$t(
														"head.description"
													),
													align: "left",
													width: "40%"
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
