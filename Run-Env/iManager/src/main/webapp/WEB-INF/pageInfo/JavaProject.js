const info = {
	type: "basic",
	cudUrl: '/api/entity/javaProject/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "projectId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "projectName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "text",
				vModel: "projectDesc",
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
		url: '/api/entity/javaProject/search',
		totalCntUrl: '/api/entity/javaProject/count',		
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "projectId",
					header: this.$t("head.id"),
					align: "left",
					width: "30%"
				},
				{
					name: "projectName",
					header: this.$t("head.name"),
					align: "left",
					width: "30%"
				},
				{
					name: "projectDesc",
					header: this.$t("head.description"),
					align: "left",
					width: "40%"
				}
			]
		}
	},
	detail: {
		pk: ["projectId"],
		controlParams: function (detailData) {
			return {
				projectId: detailData.projectId
			};
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
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
								vModel: "projectId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "projectName",
								label: this.$t("head.name"),
								regExpType: "name"
							},
							{
								type: "select",
								vModel: "projectType",
								isRequired: true,
								label: this.$t("common.type"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.JavaProject.Type'
										},
										orderByKey: true
									},
									optionListName: "projectTypes",
									optionFor: "option in projectTypes",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							}
						],
						[
							{
								type: "text",
								vModel: "projectArtifact",
								isRequired: true,
								label: this.$t("igate.javaProject.artifact")
							},
							{
								type: "text",
								vModel: "projectClassPath",
								label: this.$t("igate.javaProject.classPath")
							},
							{
								type: "text",
								vModel: "projectRepository",
								label: this.$t("igate.javaProject.repository")
							}
						]
					],
					[
						[
							{
								type: "textarea",
								vModel: "projectDesc",
								label: this.$t("head.description"),
								height: "60px",
								regExpType: "desc"
							}
						]
					]
				]
			}
		]
	}
};
