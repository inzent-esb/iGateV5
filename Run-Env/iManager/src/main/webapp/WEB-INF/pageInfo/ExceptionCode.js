const info = {
	type: "basic",
	cudUrl: '/api/entity/exceptionCode/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "exceptionCode",
				label: this.$t("igate.exceptionCode"),
				placeholder: this.$t("head.searchCode")
			},
			{
				type: "modal",
				vModel: "standardCode",
				label: this.$t("igate.standardCode"),
				placeholder: this.$t("head.searchCode"),
				modalInfo: {
					title: this.$t("igate.standardCode"),
					search: {
						list: [
							{
								type: "modal",
								vModel: "pk.adapterId",
								label:
									this.$t("igate.standardCode") +
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
												placeholder:
													this.$t("head.searchId"),
												regExpType: "searchId"
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
								type: "text",
								vModel: "pk.standardCode",
								label: this.$t("igate.standardCode"),
								placeholder: this.$t("head.searchCode")
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
						url: '/api/entity/standardCode/search',
						totalCntUrl: '/api/entity/standardCode/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "pk.adapterId",
									header:
										this.$t("igate.standardCode") +
										" " +
										this.$t("igate.adapter") +
										" " +
										this.$t("head.id"),
									align: "left",
									width: "15%"
								},
								{
									name: "pk.standardCode",
									header: this.$t("igate.standardCode"),
									align: "left",
									width: "12%"
								},
								{
									name: "message1",
									header: this.$t(
										"igate.standardCode.message1"
									),
									align: "left",
									width: "20%"
								},
								{
									name: "message2",
									header: this.$t(
										"igate.standardCode.message2"
									),
									align: "left",
									width: "20%"
								},
								{
									name: "message3",
									header: this.$t(
										"igate.standardCode.message3"
									),
									align: "left",
									width: "20%"
								},
								{
									name: "localCode",
									header: this.$t(
										"igate.standardCode.localCode"
									),
									align: "left",
									width: "12%"
								}
							]
						}
					},
					rowClickedCallback: function (info) {
						return info["pk.standardCode"];
					}
				}
			},
			{
				type: "text",
				vModel: "exceptionDesc",
				label: this.$t("head.description"),
				placeholder: this.$t("head.searchComment")
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
		url: '/api/entity/exceptionCode/search',
		totalCntUrl: '/api/entity/exceptionCode/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "exceptionCode",
					header: this.$t("igate.exceptionCode"),
					align: "left",
					width: "30%"
				},
				{
					name: "standardCode",
					header: this.$t("igate.standardCode"),
					align: "left",
					width: "30%"
				},
				{
					name: "exceptionDesc",
					header: this.$t("head.description"),
					align: "left",
					width: "40%"
				}
			]
		}
	},

	detail: {
		pk: ["exceptionCode"],
		controlParams: function (detailData) {
			return detailData;
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/exceptionCode/dump' }
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
								type: "text",
								vModel: "exceptionCode",
								label: this.$t("igate.exceptionCode"),
								isPK: true
							}
						],
						[]
					],
					[
						[
							{
								type: "modal",
								vModel: "standardCode",
								label: this.$t("igate.standardCode"),
								placeholder: this.$t("head.searchCode"),
								isRequired: true,
								clickEvt: function (component) {
									openNewTab('102020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"pk.standardCode": component.getData().standardCode, "_pageSize": "10" }));
									});
								},
								modalInfo: {
									title: this.$t("igate.standardCode"),
									search: {
										list: [
											{
												type: "modal",
												vModel: "pk.adapterId",
												label:
													this.$t(
														"igate.standardCode"
													) +
													" " +
													this.$t("igate.adapter") +
													" " +
													this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id",
												modalInfo: {
													title: this.$t(
														"igate.adapter"
													),
													search: {
														list: [
															{
																type: "text",
																vModel: "adapterId",
																label: this.$t(
																	"head.id"
																),
																placeholder:
																	this.$t(
																		"head.searchId"
																	)
															},
															{
																type: "text",
																vModel: "adapterName",
																label: this.$t(
																	"head.name"
																),
																placeholder:
																	this.$t(
																		"head.searchName"
																	)
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
																	)
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
																	optionValue:
																		"option",
																	optionText:
																		"option"
																}
															}
														]
													},
													button: {
														list: [
															{
																id: "initialize",
																isUse: true
															}
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
																	header: this.$t(
																		"head.id"
																	),
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
													rowClickedCallback:
														function (info) {
															return info.adapterId;
														}
												}
											},
											{
												type: "text",
												vModel: "pk.standardCode",
												label: this.$t(
													"igate.standardCode"
												),
												placeholder:
													this.$t("head.searchCode")
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
										url: '/api/entity/standardCode/search',
										totalCntUrl: '/api/entity/standardCode/count',
										paging: {
											isUse: true,
											side: "server"
										},
										options: {
											columns: [
												{
													name: "pk.adapterId",
													header:
														this.$t(
															"igate.standardCode"
														) +
														" " +
														this.$t(
															"igate.adapter"
														) +
														" " +
														this.$t("head.id"),
													align: "left",
													width: "15%"
												},
												{
													name: "pk.standardCode",
													header: this.$t(
														"igate.standardCode"
													),
													align: "left",
													width: "12%"
												},
												{
													name: "message1",
													header: this.$t(
														"igate.standardCode.message1"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "message2",
													header: this.$t(
														"igate.standardCode.message2"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "message3",
													header: this.$t(
														"igate.standardCode.message3"
													),
													align: "left",
													width: "20%"
												},
												{
													name: "localCode",
													header: this.$t(
														"igate.standardCode.localCode"
													),
													align: "left",
													width: "12%"
												}
											]
										}
									},
									rowClickedCallback: function (info) {
										return info["pk.standardCode"];
									}
								}
							}
						],
						[]
					],
					[
						[
							{
								type: "textarea",
								vModel: "exceptionDesc",
								label: this.$t("head.description"),
								height: "200px",
								regExpType: "desc"
							}
						]
					]
				]
			},
			{
				type: "property",
				label: this.$t("igate.exceptionCode.exceptionProperty"),
				dataKey: "exceptionProperties",
				content: [
					{
						type: "text",
						vModel: "pk.propertyKey",
						label: this.$t("common.property.key"),
						regExpType: "id"
					},
					{
						type: "text",
						vModel: "propertyValue",
						label: this.$t("common.property.value"),
						regExpType: "value"
					}
				]
			}
		]
	}
};
