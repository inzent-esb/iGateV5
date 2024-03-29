const info = {
	type: "basic",
	cudUrl: '/api/entity/job/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "jobId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "jobName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "select",
				vModel: "jobType",
				label: this.$t("common.type"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.Job.JobType'
						},
						orderByKey: true
					},
					optionListName: "jobTypes",
					optionFor: "option in jobTypes",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "modal",
				vModel: "operationId",
				label: this.$t("igate.operation.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
				modalInfo: {
					title: this.$t("igate.operation"),
					search: {
						list: [
							{
								type: "text",
								vModel: "operationId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "operationName",
								label: this.$t("head.name"),
								placeholder: this.$t("head.searchName"),
								regExpType: "name"
							},
							{
								type: "select",
								vModel: "operationType",
								label: this.$t("common.type"),
								val: "J",
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Operation.OperationType'
										},
										orderByKey: true
									},
									optionListName: "operationTypeList",
									optionFor: "option in operationTypeList",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue",
									optionIf: "option.pk.propertyKey === 'J'",
									isViewAll: false
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
						list: [{ id: "initialize", isUse: true }]
					},
					grid: {
						url: '/api/entity/operation/search',
						totalCntUrl: '/api/entity/operation/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "operationId",
									header: this.$t("head.id"),
									align: "left",
									width: "50%"
								},
								{
									name: "operationName",
									header: this.$t("head.name"),
									align: "left",
									width: "50%"
								}
							]
						}
					},
					rowClickedCallback: function (info) {
						return info.operationId;
					}
				}
			},
			{
				type: "text",
				vModel: "jobDesc",
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
		url: '/api/entity/job/search',
		totalCntUrl: '/api/entity/job/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					name: "jobId",
					header: this.$t("head.id"),
					width: "15%"
				},
				{
					name: "jobName",
					header: this.$t("head.name"),
					width: "15%"
				},
				{
					name: "jobType",
					header: this.$t("common.type"),
					width: "20%",
					align: "center",
					formatter: function (value) {
						if (value.row.jobType == "R")
							return this.$t("igate.job.type.reserve");
						else if (value.row.jobType == "S")
							return this.$t("igate.job.type.schdule");
						else if (value.row.jobType == "M")
							return this.$t("igate.job.type.manual");
					}
				},
				{
					name: "operationId",
					header: this.$t("igate.operation.id"),
					width: "20%"
				},
				{
					name: "jobDesc",
					header: this.$t("head.description"),
					width: "30%"
				}
			]
		}
	},

	detail: {
		pk: ["jobId"],
		controlUrl: "/api/entity/job/control",
		controlParams: function (detailData) {
			return {
				jobId: detailData.jobId
			};
		},
		button: {
			list: [
				{ id: "insert", isUse: true },
				{ id: "update", isUse: true },
				{ id: "delete", isUse: true },
				{ id: "execute", isUse: true },
				{ id: "interrupt", isUse: true },
				{ id: 'reference', isUse: true, className: 'com.inzent.igate.repository.meta.Job' }
			]
		},
		tabList: [
			{
				type: "bundle",
				label: this.$t("head.basic.info"),
				url: "/job/BasicInfo"
			},
			{
				type: "property",
				label: this.$t("igate.job.jobParameter"),
				dataKey: "jobParameter",
				content: [
					{
						type: "text",
						vModel: "parameterValue",
						label: this.$t("common.property.value")
					},
					{
						type: "text",
						vModel: "parameterDesc",
						label: this.$t("head.description"),
						regExpType: "desc"
					}
				]
			},
			{
				type: "bundle",
				label: this.$t("igate.instance") + " " + this.$t("head.id"),
				url: "/job/InstanceId"
			}
		]
	}
};
