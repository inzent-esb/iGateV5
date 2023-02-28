const info = {
	type: "basic",
	cudUrl: "/igate/transactionContext/object.json",
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
		url: "/igate/transactionContext/search.json",
		totalCntUrl: "/igate/transactionContext/rowCount.json",
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
		controlUrl: "/igate/transactionContext/control.json",
		controlParams: function (detailData) {
			return {
				variableId: detailData.variableId
			};
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true }
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
