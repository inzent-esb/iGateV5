const info = {
	type: "basic",
	cudUrl: "/igate/externalLine/object.json",
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
		url: "/igate/externalLine/search.json",
		totalCntUrl: "/igate/externalLine/rowCount.json",
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
					width: "40%"
				},
				{
					name: "externalLineName",
					header: this.$t("head.name"),
					align: "left",
					width: "60%"
				},
				{
					name: "externalLineDesc",
					header: this.$t("head.description"),
					align: "left",
					width: "60%"
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
							url: "/common/property/properties.json",
							params: {
								propertyId: "List.Connector.RequestDirection",
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
						modalInfo: {
							title: this.$t("igate.connector"),
							search: {
								list: [
									{
										type: "text",
										vModel: "connectorId",
										label: this.$t("head.id"),
										placeholder: this.$t("head.searchId"),
										regExpType: "id"
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
											url: "/common/property/properties.json",
											params: {
												propertyId:
													"List.Connector.Type",
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
								url: "/igate/connector/searchPopup.json",
								totalCntUrl: "/igate/connector/rowCount.json",
								paging: {
									isUse: true,
									side: "server"
								},
								options: {
									columns: [
										{
											name: "connectorId",
											header: this.$t("head.id"),
											align: "left"
										},
										{
											name: "connectorName",
											header: this.$t("head.name"),
											align: "left"
										},
										{
											name: "connectorDesc",
											header: this.$t("head.description"),
											align: "left"
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
