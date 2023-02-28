const info = {
	type: "basic",
	cudUrl: "/igate/message/object.json",
	search: {
		load: true,
		list: [
			{
				type: "select",
				vModel: "messageCategory",
				label: this.$t("igate.message.category"),
				optionInfo: {
					url: "/common/property/properties.json",
					params: {
						propertyId: "List.Message.MessageCategory",
						orderByKey: true
					},
					optionListName: "messageCategories",
					optionFor: "option in messageCategories",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "dataList",
				vModel: "pk.messageLocale",
				label: this.$t("igate.message.locale"),
				placeholder: this.$t("head.searchData"),
				optionInfo: {
					url: "/igate/message/groups.json",
					optionListName: "messageLocales",
					optionFor: "option in messageLocales",
					optionValue: "option",
					optionText: "option"
				}
			},
			{
				type: "text",
				vModel: "pk.messageCode",
				label: this.$t("igate.message.code"),
				placeholder: this.$t("head.searchCode")
			},
			{
				type: "text",
				vModel: "messageFormat",
				label: this.$t("igate.message.format"),
				placeholder: this.$t("head.searchData")
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
		url: "/igate/message/search.json",
		totalCntUrl: "/igate/message/rowCount.json",
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "messageCategory",
					header: this.$t("igate.message.category"),
					align: "center",
					width: "25%"
				},
				{
					name: "pk.messageLocale",
					header: this.$t("igate.message.locale"),
					align: "center",
					width: "15%"
				},
				{
					name: "pk.messageCode",
					header: this.$t("igate.message.code"),
					align: "left",
					width: "30%"
				},
				{
					name: "messageFormat",
					header: this.$t("igate.message.format"),
					align: "left",
					width: "30%"
				}
			]
		}
	},

	detail: {
		pk: ["pk.messageCode", "pk.messageLocale"],
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
								vModel: "pk.messageCode",
								label: this.$t("igate.message.code"),
								isPK: true
							},
							{
								type: "dataList",
								vModel: "pk.messageLocale",
								isPK: true,
								label: this.$t("igate.message.locale"),
								optionInfo: {
									url: "/igate/message/groups.json",
									optionListName: "messageLocales",
									optionFor: "option in messageLocales",
									optionValue: "option",
									optionText: "option"
								}
							}
						],
						[
							{
								type: "select",
								vModel: "messageCategory",
								label: this.$t("igate.message.category"),
								isRequired: true,
								optionInfo: {
									url: "/common/property/properties.json",
									params: {
										propertyId:
											"List.Message.MessageCategory",
										orderByKey: true
									},
									optionListName: "messageCategory",
									optionFor: "option in messageCategory",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							},
							{
								type: "text",
								vModel: "messageFormat",
								label: this.$t("igate.message.format")
							}
						]
					]
				]
			}
		]
	}
};
