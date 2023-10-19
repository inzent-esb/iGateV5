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
					header: this.$t("head.id"),
					width: "45%"
				},
				{
					name: "threadPoolDesc",
					header: this.$t("head.description"),
					width: "55%"
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
				type: "basic",
				label: this.$t("head.basic.info"),
				content: [
					[
						[
							{
								type: "text",
								vModel: "threadPoolId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "threadMin",
								label: this.$t("igate.threadPool.min"),
								regExpType: "num"
							},
							{
								type: "text",
								vModel: "threadMax",
								label: this.$t("igate.threadPool.max"),
								regExpType: "num",
								changeEvt: function() {
									if(!this.getData().threadMax) return;
									
									var threadMax = Number(this.getData().threadMax);
									var threadMin = Number(this.$parent.getData().threadMin);
									
									if(0 === threadMax || threadMin > threadMax) {
										this.$alert({ type: 'warn', message: this.$t('igate.threadPool.max.warn') })
										
										this.setData().threadMax = null;
									}
								}
							},
							{
								type: "text",
								vModel: "threadIdle",
								label: this.$t("igate.threadPool.idle"),
								regExpType: "num"
							}
						],
						[
							{
								type: "select",
								vModel: "rejectPolicy",
								label: this.$t("igate.threadPool.rejectPolicy"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Threadpool.Rejectpolicy'
										},
										orderByKey: true
									},
									optionListName: "threadPoolRejectPolicy",
									optionFor: "option in threadPoolRejectPolicy",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								},
								isRequired: true
							},
							{
								type: "select",
								vModel: "rejectWarnYn",
								label: this.$t("igate.threadPool.rejectWarnYn"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Yn'
										},
										orderByKey: true
									},
									optionListName: "rejectWarnYns",
									optionFor: "option in rejectWarnYns",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								},
								isRequired: true
							},
							{
								type: "text",
								vModel: "threadThreshold",
								label: this.$t("igate.threadPool.threshold"),
								regExpType: "num"
							}
						]
					],
					[
						[
							{
								type: "textarea",
								vModel: "threadPoolDesc",
								label: this.$t("head.description"),
								regExpType: "desc"
							}
						]
					]
				]
			}
		]
	}
};
