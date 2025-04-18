const info = {
	type: "basic",
	cudUrl: '/api/entity/externalLine/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "externalLineId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "externalLineName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "text",
				vModel: "externalLineDesc",
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
		list: [
			{ id: "add", isUse: true },
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: '/api/entity/externalLine/search',
		totalCntUrl: '/api/entity/externalLine/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "externalLineId",
					header: this.$t("head.id"),
					align: "left",
					width: "30%"
				},
				{
					name: "externalLineName",
					header: this.$t("head.name"),
					align: "left",
					width: "30%"
				},
				{
					name: "externalLineDesc",
					header: this.$t("head.description"),
					align: "left",
					width: "40%"
				}
			]
		}
	},
	detail: {
		pk: ["externalLineId"],
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true }
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
								vModel: "externalLineId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "externalLineName",
								label: this.$t("head.name"),
								regExpType: "name"
							}
						],
						[
							{
								type: "text",
								vModel: "internalNetworkManager",
								label: this.$t(
									"igate.externalLine.internalNetworkManager"
								)
							},
							{
								type: "text",
								vModel: "internalProcessManager",
								label: this.$t(
									"igate.externalLine.internalProcessManager"
								)
							}
						],
						[
							{
								type: "text",
								vModel: "externalProcessManager",
								label: this.$t(
									"igate.externalLine.externalProcessManager"
								)
							},
							{
								type: "text",
								vModel: "externalNetworkManager",
								label: this.$t(
									"igate.externalLine.externalNetworkManager"
								)
							}
						],
						[
							{
								type: "text",
								vModel: "displayOrder",
								label: this.$t(
									"igate.externalLine.displayOrder"
								),
								regExpType: "num"
							}
						]
					],
					[
						[
							{
								type: "textarea",
								vModel: "externalLineDesc",
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
				label: this.$t("igate.connector"),
				dataKey: "externalConnectors",
				content: [
					{
						type: "select",
						vModel: "lineMode",
						label: this.$t("igate.externalLine.lineMode"),
						optionInfo: {
							url: '/api/page/properties',
							params: {
								pk: {
									propertyId: 'List.Connector.RequestDirection'
								},
								orderByKey: true
							},
							optionListName: "lineModes",
							optionFor: "option in lineModes",
							optionValue: "option.pk.propertyKey",
							optionText: "option.propertyValue"
						}
					},
					{
						type: "modal",
						vModel: "pk.connectorId",
						label:
							this.$t("igate.connector") +
							" " +
							this.$t("head.id"),
						isPK: true,
						clickEvt: function(component) {
							openNewTab('202020', function() {
								localStorage.removeItem("searchObj");
								localStorage.setItem("searchObj", JSON.stringify({"connectorId": component.getData()['pk.connectorId']}));
							});
						},
						modalInfo: {
							title: this.$t("igate.connector"),
							search: {
								list: [
									{
										type: "text",
										vModel: "connectorId",
										label: this.$t("head.id"),
										placeholder: this.$t("head.searchId"),
										regExpType: "searchId"
									},
									{
										type: "text",
										vModel: "connectorName",
										label: this.$t("head.name"),
										placeholder: this.$t("head.searchName"),
										regExpType: "name"
									},
									{
										type: "select",
										vModel: "connectorType",
										label: this.$t("common.type"),
										optionInfo: {
											url: '/api/page/properties',
											params: {
												pk: {
													propertyId: 'List.Connector.Type'
												},
												orderByKey: true
											},
											optionListName: "connectorTypes",
											optionFor:
												"option in connectorTypes",
											optionValue:
												"option.pk.propertyKey",
											optionText: "option.propertyValue"
										}
									},
									{
										type: "text",
										vModel: "connectorDesc",
										label: this.$t("head.description"),
										placeholder:
											this.$t("head.searchComment"),
										regExpType: "desc"
									},
									{
										type: "dataList",
										vModel: "pageSize",
										label: this.$t("head.listCount"),
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
								list: [{ id: "initialize", isUse: true }]
							},
							grid: {
								url: '/api/entity/connector/search',
								totalCntUrl: '/api/entity/connector/count',
								paging: {
									isUse: true,
									side: "server"
								},
								options: {
									columns: [
										{
											name: "connectorId",
											header: this.$t("head.id"),
											align: "left",
											width: "30%"
										},
										{
											name: "connectorName",
											header: this.$t("head.name"),
											align: "left",
											width: "30%"
										},
										{
											name: "connectorDesc",
											header: this.$t("head.description"),
											align: "left",
											width: "40%"
										}
									]
								}
							},
							rowClickedCallback: function (info, propertyList) {
								return info.connectorId;
							}
						}
					}
				]
			}
		]
	}
};
