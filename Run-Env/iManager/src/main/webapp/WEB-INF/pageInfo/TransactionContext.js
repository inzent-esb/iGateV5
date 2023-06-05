const info = {
	type: "basic",
	cudUrl: '/api/entity/transactionContext/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "variableId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "variableType",
				label: this.$t("common.type"),
				placeholder: this.$t("head.searchData"),
				regExpType: "desc"
			},
			{
				type: "text",
				vModel: "variableDesc",
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
		url: '/api/entity/transactionContext/search',
		totalCntUrl: '/api/entity/transactionContext/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					header: this.$t("head.id"),
					name: "variableId",
					align: "left",
					width: "30%"
				},
				{
					header: this.$t("common.type"),
					name: "variableType",
					align: "left",
					width: "30%"
				},
				{
					header: this.$t("head.description"),
					name: "variableDesc",
					align: "left",
					width: "40%"
				}
			]
		}
	},

	detail: {
		pk: ["variableId"],
		controlParams: function (detailData) {
			return detailData;
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/transactionContext/dump' }
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
								vModel: "variableId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "variableType",
								label: this.$t("common.type"),
								isRequired: true
							}
						],
						[]
					],
					[
						[
							{
								type: "textarea",
								vModel: "variableDesc",
								label: this.$t("head.description"),
								height: "205px",
								regExpType: "desc"
							}
						]
					]
				]
			}
		]
	}
};
