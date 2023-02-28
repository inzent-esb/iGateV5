const info = {
	type: "basic",
	cudUrl: "/igate/fieldMeta/object.json",
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "pk.metaDomain",
				label: this.$t("igate.fieldMeta.metaDomain"),
				placeholder: this.$t("head.searchData")
			},
			{
				type: "text",
				vModel: "fieldId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "fieldName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "select",
				vModel: "fieldType",
				label: this.$t("common.type"),
				optionInfo: {
					url: "/common/property/properties.json",
					params: {
						propertyId: "List.FieldMeta.FieldType",
						orderByKey: true
					},
					optionListName: "fieldTypeList",
					optionFor: "option in fieldTypeList",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "text",
				vModel: "fieldDesc",
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
		url: "/igate/fieldMeta/search.json",
		totalCntUrl: "/igate/fieldMeta/rowCount.json",
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					header: this.$t("igate.fieldMeta.metaDomain"),
					name: "pk.metaDomain",
					width: "20%"
				},
				{
					header: this.$t("head.id"),
					name: "pk.fieldId",
					width: "20%"
				},
				{
					header: this.$t("head.name"),
					name: "fieldName",
					width: "20%"
				},
				{
					header: this.$t("common.type"),
					name: "fieldType",
					align: "center",
					width: "10%",
					formatter: function (value) {
						const msgObj = {
							B: this.$t("igate.fieldMeta.fieldType.byte"),
							S: this.$t("igate.fieldMeta.fieldType.short"),
							I: this.$t("igate.fieldMeta.fieldType.int"),
							L: this.$t("igate.fieldMeta.fieldType.long"),
							F: this.$t("igate.fieldMeta.fieldType.float"),
							D: this.$t("igate.fieldMeta.fieldType.double"),
							N: this.$t("igate.fieldMeta.fieldType.numeric"),
							p: this.$t("igate.fieldMeta.fieldType.timeStamp"),
							b: this.$t("igate.fieldMeta.fieldType.boolean"),
							v: this.$t("igate.fieldMeta.fieldType.individual"),
							A: this.$t("igate.fieldMeta.fieldType.raw"),
							P: this.$t(
								"igate.fieldMeta.fieldType.packedDecimal"
							),
							R: this.$t("igate.fieldMeta.fieldType.record"),
							T: this.$t("igate.fieldMeta.fieldType.string")
						};

						return msgObj[value.row.fieldType];
					}
				},
				{
					header: this.$t("head.description"),
					name: "fieldDesc",
					width: "30%"
				}
			]
		}
	},
	detail: {
		pk: ["pk.metaDomain", "pk.fieldId"],
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
								vModel: "pk.metaDomain",
								label: this.$t("igate.fieldMeta.metaDomain"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "pk.fieldId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "fieldName",
								label: this.$t("head.name"),
								isRequired: true,
								regExpType: "name"
							},
							{
								type: "text",
								vModel: "fieldIndex",
								label: "Index"
							}
						],
						[
							{
								type: "text",
								vModel: "originalType",
								label: "Original " + this.$t("common.type")
							},
							{
								type: "text",
								vModel: "originalLength",
								label: "Original " + this.$t("head.length"),
								regExpType: "num"
							},
							{
								type: "text",
								vModel: "originalScale",
								label: "Original Scale",
								regExpType: "num"
							}
						],
						[
							{
								type: "select",
								vModel: "fieldType",
								label: this.$t("common.type"),
								optionInfo: {
									url: "/common/property/properties.json",
									params: {
										propertyId: "List.FieldMeta.FieldType",
										orderByKey: true
									},
									optionListName: "fieldTypeList",
									optionFor: "option in fieldTypeList",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								},
								isRequired: true
							},
							{
								type: "text",
								vModel: "fieldLength",
								label: this.$t("head.length"),
								regExpType: "num"
							},
							{
								type: "text",
								vModel: "fieldScale",
								label: "Scale",
								regExpType: "num"
							}
						],
						[
							{
								type: "select",
								vModel: "fieldRequireYn",
								label: "Require",
								val: "N",
								optionInfo: {
									url: "/common/property/properties.json",
									params: {
										propertyId: "List.Yn",
										orderByKey: true
									},
									optionListName: "ynList",
									optionFor: "option in ynList",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							},
							{
								type: "select",
								vModel: "fieldHiddenYn",
								label: "Hidden",
								val: "N",
								optionInfo: {
									url: "/common/property/properties.json",
									params: {
										propertyId: "List.Yn",
										orderByKey: true
									},
									optionListName: "ynList",
									optionFor: "option in ynList",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							},
							{
								type: "text",
								vModel: "codecId",
								label: "Codec Id",
								regExpType: "id"
							}
						]
					],
					[
						[
							{
								type: "textarea",
								vModel: "fieldDesc",
								label: this.$t("head.description"),
								height: "110px",
								regExpType: "desc"
							}
						]
					]
				]
			}
		]
	}
};
