const info = {
	type: "basic",
	cudUrl: '/api/entity/metaHistory/object',
	search: {
		list: [
			{
				type: "singleDaterange",
				vModel: "modifyDateTimeFrom",
				label: this.$t("head.from"),
				dateRangeType: "from"
			},
			{
				type: "singleDaterange",
				vModel: "modifyDateTimeTo",
				label: this.$t("head.to"),
				dateRangeType: "to"
			},
			{
				type: "text",
				vModel: "entityName",
				label: this.$t("common.metaHistory.entityName"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "text",
				vModel: "entityId",
				label: this.$t("common.metaHistory.entityId"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "select",
				vModel: "modifyType",
				label: this.$t("common.metaHistory.modifyType"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.MetaHistory.Type'
						},
						orderByKey: true
					},
					optionListName: "metaHistoryTypes",
					optionFor: "option in metaHistoryTypes",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
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
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: '/api/entity/metaHistory/search',
		totalCntUrl: '/api/entity/metaHistory/count',
		paging: {
			isUse: true,
			side: "client"
		},
		options: {
			columns: [
				{
					header: this.$t("head.update.timestamp"),
					name: "pk.modifyDateTime",
					width: "20%",
					align: "center",
					formatter: function (obj) {
						return obj.value.substring(0, 19);
					}
				},
				{
					header: this.$t("common.metaHistory.entityName"),
					name: "entityName",
					width: "20%"
				},
				{
					header: this.$t("common.metaHistory.entityId"),
					name: "entityId",
					width: "20%"
				},
				{
					header: "Entity Version",
					name: "entityVersion",
					width: "10%",
					align: 'right'
				},
				{
					header: this.$t("common.metaHistory.modifyType"),
					name: "modifyType",
					width: "20%",
					align: "center",
					formatter: function (value) {
						var modifyType = value.row.modifyType;
						return "D" == modifyType
							? this.$t("head.delete")
							: "I" == modifyType
							? this.$t("head.insert")
							: "R" == modifyType
							? this.$t("common.metaHistory.restore")
							: "U" == modifyType
							? this.$t("head.update")
							: "";
					}
				},
				{
					header: this.$t("head.update.userId"),
					name: "updateUserId",
					width: "10%"
				},
			]
		}
	},

	detail: {
		pk: ["pk.modifyDateTime", "pk.modifyId"],
		button: {
			list: [
				{
					id: "restore",
					isUse: function (object) {
						return object.entityName !==
							"com.inzent.imanager.repository.meta.User" &&
							object.beforeDataString
							? true
							: false;
					}
				}
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
								vModel: "pk.modifyDateTime",
								label: this.$t("head.update.timestamp"),
								isPK: true,
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "entityName",
								label: this.$t("common.metaHistory.entityName")
							},
							{
								type: "text",
								vModel: "entityId",
								label: this.$t("common.metaHistory.entityId")
							},
							{
								type: "text",
								vModel: "entityVersion",
								label: 'Entity Version',
							}							
						],
						[
							{
								type: "select",
								vModel: "modifyType",
								label: this.$t("common.metaHistory.modifyType"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.MetaHistory.Type'
										},
										orderByKey: true
									},
									optionListName: "metaHistoryTypes",
									optionFor: "option in metaHistoryTypes",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							},							
							{
								type: "text",
								vModel: "updateUserId",
								label: this.$t("common.user.id")
							},
							{
								type: "text",
								vModel: "updateRemoteAddress",
								label: this.$t(
									"common.metaHistory.updateRemoteAddress"
								)
							},
							{
								type: "text",
								vModel: "pk.modifyId",
								label:
									this.$t("head.modify") +
									" " +
									this.$t("head.id"),
								isPK: true
							},							
						]
					]
				]
			},
			{
				type: "bundle",
				label: "Modified Contents",
				url: "/metaHistory/Modified"
			}
		]
	}
};
