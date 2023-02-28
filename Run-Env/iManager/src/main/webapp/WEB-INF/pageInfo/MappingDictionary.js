const info = {
	type: "basic",
	cudUrl: "/igate/mappingDictionary/object.json",
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "dictionaryName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "text",
				vModel: "dictionaryDesc",
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
		url: "/igate/mappingDictionary/search.json",
		totalCntUrl: "/igate/mappingDictionary/rowCount.json",
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "dictionaryName",
					header: this.$t("head.name")
				},
				{
					name: "dictionaryDesc",
					header: this.$t("head.description")
				}
			]
		}
	},
	detail: {
		pk: ["dictionaryName"],
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
								vModel: "dictionaryName",
								label: this.$t("head.name"),
								isPK: true,
								regExpType: "name"
							}
						],
						[],
						[]
					],
					[
						[
							{
								type: "textarea",
								vModel: "dictionaryDesc",
								label: this.$t("head.description"),
								regExpType: "desc"
							}
						]
					]
				]
			},
			{
				type: "bundle",
				label:
					this.$t("igate.mappingDictionary") +
					" " +
					this.$t("head.detail"),
				url: "/mappingDictionary/DictionaryDetailInfo"
			}
		]
	}
};
