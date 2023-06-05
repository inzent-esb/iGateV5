const info = {
	type: "basic",
	cudUrl: "/api/entity/notice/object",
	privilegeType: "Notice",
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "noticeTitle",
				label: this.$t("igate.notice.title"),
				placeholder: this.$t("igate.notice.enter.title"),
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
		list: [
			{ id: "add", isUse: true },
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: "/api/entity/notice/search",
		totalCntUrl: "/api/entity/notice/count",
		paging: {
			isUse: true,
			side: "client"
		},
		options: {
			columns: [
				{
					header: this.$t("igate.notice.title"),
					name: "noticeTitle",
					width: "5%",
					sortable: true,
				},
				{
					header: this.$t("igate.notice.writer"),
					name: "userId",
					width: "30%"
				},
				{
					header: this.$t("igate.notice.reg.date"),
					name: "pk.createTimestamp",
					width: "30%",
					align: "center",
					sortable: true,
					sortWithColumn: ['noticeTitle'],
					sortWithColumnType: ['desc'],
					formatter: function (obj) {
						return !obj.value? obj.value : obj.value.substring(0, 19);
					}
				}
			],
			sortColumn: "pk.createTimestamp",
		},
	},
	detail: {
		pk: ["pk.createTimestamp", "pk.noticeId", "userId"],
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
								vModel: "noticeTitle",
								label: this.$t("igate.notice.title"),
								isRequired: true,
								regExpType: "name"
							}
						]
					],
					[
						[
							{
								type: "textarea",
								vModel: "noticeContent",
								label: this.$t("igate.notice.contents"),
								height: "200px",
								isRequired: true,
								regExpType: "desc"
							}
						]
					]
				]
			}
		]
	}
};
