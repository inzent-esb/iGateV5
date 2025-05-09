const info = {
	type: "basic",
	cudUrl: '/api/entity/standardCode/object',
	search: {
		load: true,
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
		list: [
			{ id: "add", isUse: true },
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true }
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
						this.$t("igate.standardCode") +
						" " +
						this.$t("igate.adapter") +
						" " +
						this.$t("head.id"),
					align: "left",
					width: "50%"
				},
				{
					name: "pk.standardCode",
					header: this.$t("igate.standardCode"),
					align: "left",
					width: "50%"
				}
			]
		}
	},
	detail: {
		pk: ["pk.adapterId", "pk.standardCode"],
		controlParams: function (detailData) {
			return detailData;
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/standardCode/dump' }
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
								vModel: "pk.adapterId",
								label:
									this.$t("igate.standardCode") +
									" " +
									this.$t("igate.adapter") +
									" " +
									this.$t("head.id"),
								isPK: true,
								clickEvt: function (component) {
									openNewTab('202030', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"adapterId": component.getData()['pk.adapterId'] }));
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
								isPK: true
							},
							{
								type: "text",
								vModel: "localCode",
								label: this.$t("igate.standardCode.localCode")
							}
						],
						[
							{
								type: "text",
								vModel: "message1",
								label: this.$t("igate.standardCode.message1")
							},
							{
								type: "text",
								vModel: "message2",
								label: this.$t("igate.standardCode.message2")
							},
							{
								type: "text",
								vModel: "message3",
								label: this.$t("igate.standardCode.message3")
							}
						]
					]
				]
			},
			{
				type: "property",
				label: this.$t("head.property"),
				dataKey: "standardCodeLocales",
				content: [
					{
						type: "text",
						vModel: "pk.localeCode",
						label: this.$t("igate.message.locale")
					},
					{
						type: "text",
						vModel: "message1",
						label: this.$t("igate.standardCode.message1")
					},
					{
						type: "text",
						vModel: "message2",
						label: this.$t("igate.standardCode.message2")
					},
					{
						type: "text",
						vModel: "message3",
						label: this.$t("igate.standardCode.message3")
					}
				]
			}
		]
	}
};
