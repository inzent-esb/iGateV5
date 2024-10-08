const info = {
	type: "basic",
	cudUrl: '/api/entity/jobResult/object',
	search: {
		load: true,
		list: [
			{
				type: "singleDaterange",
				vModel: "fromScheduledDateTime",
				label: this.$t("head.from"),
				dateRangeType: "from"
			},
			{
				type: "singleDaterange",
				vModel: "toScheduledDateTime",
				label: this.$t("head.to"),
				dateRangeType: "to"
			},
			{
				type: "modal",
				vModel: "pk.jobId",
				label: this.$t("igate.job") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
				modalInfo: {
					title: this.$t("igate.job"),
					search: {
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
								vModel: "jobDesc",
								label: this.$t("head.description"),
								placeholder: this.$t("head.searchComment"),
								regExpType: "desc"
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
									width: "25%"
								},
								{
									name: "jobDesc",
									header: this.$t("head.description"),
									width: "25%"
								},
								{
									name: "jobType",
									header: this.$t("common.type"),
									width: "25%",
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
									name: "cronExpression",
									header: this.$t("igate.job.cronExpression"),
									width: "25%"
								}
							]
						}
					},
					rowClickedCallback: function (info) {
						return info.jobId;
					}
				}
			},
			{
				type: "modal",
				modalInfo: {
					title: this.$t("igate.instance"),
					search: {
						list: [
							{
								type: "text",
								vModel: "instanceId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "instanceNode",
								label: this.$t("igate.instance.node"),
								placeholder: this.$t("head.searchData")
							},
							{
								type: "select",
								vModel: "instanceType",
								label: this.$t("common.type"),
								val: "T",
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Instance.InstanceType'
										},
										orderByKey: true
									},
									optionListName: "instanceTypes",
									optionFor: "option in instanceTypes",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue",
									optionIf: "option.pk.propertyKey == 'T'",
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
						url: '/api/entity/instance/search',
						totalCntUrl: '/api/entity/instance/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "instanceId",
									header: this.$t("head.id"),
									width: "25%"
								},
								{
									name: "instanceType",
									header: this.$t("common.type"),
									width: "25%",
									formatter: function (value) {
										switch (value.row.instanceType) {
											case "T": {
												return this.$t(
													"igate.instance.type.trx"
												);
											}
											case "A": {
												return this.$t(
													"igate.instance.type.adm"
												);
											}
											case "L": {
												return this.$t(
													"igate.instance.type.log"
												);
											}
											case "M": {
												return this.$t(
													"igate.instance.type.mnt"
												);
											}
										}
									}
								},
								{
									name: "instanceAddress",
									header: this.$t("igate.instance.address"),
									width: "25%"
								},
								{
									name: "instanceNode",
									header: this.$t("igate.instance.node"),
									width: "25%"
								}
							]
						}
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.instanceId;
					}
				},
				vModel: "pk.instanceId",
				label: this.$t("igate.instance") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "select",
				vModel: "successYn",
				label: this.$t("igate.jobResult.successYn"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.Yn'
						},
						orderByKey: true
					},
					optionListName: "successYns",
					optionFor: "option in successYns",
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
		url: '/api/entity/jobResult/search',
		totalCntUrl: '/api/entity/jobResult/count',
		paging: {
			isUse: true,
			side: "client"
		},
		options: {
			columns: [
				{
					name: "pk.scheduledDateTime",
					header: this.$t("igate.jobResult.scheduledDateTime"),
					align: "center",
					width: "30%",
					formatter: function (obj) {
						return obj.value.substring(0, 19);
					}
				},
				{
					name: "pk.jobId",
					header: this.$t("igate.job") + " " + this.$t("head.id"),
					width: "25%"
				},
				{
					name: "pk.instanceId",
					header:
						this.$t("igate.instance") + " " + this.$t("head.id"),
					width: "25%"
				},
				{
					name: "successYn",
					header: this.$t("igate.jobResult.successYn"),
					align: "center",
					width: "20%",
					formatter: function (value) {
						return "Y" == value.row.successYn ? "Yes" : "No";
					}
				}
			]
		}
	},

	detail: {
		pk: ["pk.scheduledDateTime", "pk.instanceId", "pk.jobId"],
		button: {
			list: []
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
								vModel: "pk.scheduledDateTime",
								label: this.$t(
									"igate.jobResult.scheduledDateTime"
								),
								isPK: true,
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "pk.instanceId",
								label:
									this.$t("igate.instance") +
									" " +
									this.$t("head.id")
							},
							{
								type: "text",
								vModel: "pk.jobId",
								label:
									this.$t("igate.job") +
									" " +
									this.$t("head.id"),
								isPK: true,
								clickEvt: function (component) {
									openNewTab('204010', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"jobId": component.getData()['pk.jobId'], "_pageSize": "10" }));
									});
								}
							},
							{
								type: "select",
								vModel: "successYn",
								label: this.$t("igate.jobResult.successYn"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Yn'
										},
										orderByKey: true
									},
									optionListName: "successYns",
									optionFor: "option in successYns",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							}
						],
						[
							{
								type: "text",
								vModel: "executeTimestamp",
								label: this.$t(
									"igate.jobResult.executeTimestamp"
								),
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "exceptionMessage",
								label: this.$t("head.exception.message")
							},
							{
								type: "text",
								vModel: "exceptionDateTime",
								label: this.$t(
									"igate.jobResult.exceptionDateTime"
								),
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "exceptionId",
								label:
									this.$t("head.exception") +
									" " +
									this.$t("head.id"),
								clickEvt: function (component) {
									const searchData = component.getData().exceptionId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('103010', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "pk.exceptionId": searchData }));
									});
								}
							}
						]
					]
				]
			}
		]
	}
};
