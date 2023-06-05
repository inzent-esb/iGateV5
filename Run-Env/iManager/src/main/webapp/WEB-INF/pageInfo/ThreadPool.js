const info = {
	type: "basic",
	cudUrl: '/api/entity/threadPool/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "threadPoolId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "threadPoolDesc",
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
		url: '/api/entity/threadPool/search',
		totalCntUrl: '/api/entity/threadPool/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "threadPoolId",
					header: this.$t("head.id")
				},
				{
					name: "threadPoolDesc",
					header: this.$t("head.description")
				}
			]
		}
	},

	detail: {
		pk: ["threadPoolId"],
		controlParams: function (detailData) {
			return {
				threadPoolId: detailData.threadPoolId
			};
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/threadPool/dump' }
			]
		},
		tabList: [
			{
				type: "bundle",
				label: this.$t("head.basic.info"),
				url: "/threadPool/BasicInfo"
			}
		]
	}
};
