const info = {
	type: "basic",
	cudUrl: '/api/entity/interfaceRecognize/object',
	search: {
		load: true,
		list: [
			{
				type: "modal",
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
									width: "20%"
								},
								{
									name: "adapterName",
									header: this.$t("head.name"),
									width: "20%"
								},
								{
									name: "adapterDesc",
									header: this.$t("head.description"),
									width: "20%"
								},
								{
									name: "requestStructure",
									header: this.$t(
										"igate.adapter.structure.request"
									),
									width: "20%"
								},
								{
									name: "responseStructure",
									header: this.$t(
										"igate.adapter.structure.response"
									),
									width: "20%"
								}
							]
						}
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.adapterId;
					}
				},
				vModel: "pk.adapterId",
				label: this.$t("igate.adapter") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "pk.telegramValue",
				label: this.$t("igate.telegramValue"),
				placeholder: this.$t("head.searchTelegram"),
				regExpType: "name"
			},
			{
				type: "modal",
				modalInfo: {
					title: this.$t("igate.interface"),
					search: {
						list: [
							{
								type: "text",
								vModel: "interfaceId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "interfaceName",
								label: this.$t("head.name"),
								placeholder: this.$t("head.searchName"),
								regExpType: "name"
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
						url: '/api/entity/interface/search',
						totalCntUrl: '/api/entity/interface/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "interfaceId",
									header: this.$t("head.id"),
									width: "25%"
								},
								{
									name: "interfaceName",
									header: this.$t("head.name"),
									width: "25%"
								},
								{
									name: "interfaceDesc",
									header: this.$t("head.description"),
									width: "25%"
								},
								{
									name: "interfaceType",
									header: this.$t("common.type"),
									width: "25%"
								}
							]
						}
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.interfaceId;
					}
				},
				vModel: "interfaceId",
				label: this.$t("igate.interface") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
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
		url: '/api/entity/interfaceRecognize/search',
		totalCntUrl: '/api/entity/interfaceRecognize/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "pk.adapterId",
					header: this.$t("igate.adapter") + " " + this.$t("head.id"),
					width: "25%"
				},
				{
					name: "pk.telegramValue",
					header: this.$t("igate.telegramValue"),
					width: "50%"
				},
				{
					name: "interfaceId",
					header:
						this.$t("igate.interface") + " " + this.$t("head.id"),
					width: "25%"
				}
			]
		}
	},

	detail: {
		pk: ["pk.adapterId", "pk.telegramValue"],
		controlParams: function (detailData) {
			return detailData;
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "dump", isUse: true, dumpUrl: '/api/entity/interfaceRecognize/dump' }
			]
		},
		tabList: [
			{
				type: "bundle",
				url: "/interfaceRecognize/BasicInfo",
				label: this.$t("head.basic.info")
			}
		]
	}
};
