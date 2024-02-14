const info = {
	type: "basic",
	cudUrl: '/api/entity/safMessage/object',
	updateStatusFunc: function (row, mod) {
		return {
			url: "/api/entity/safMessage/control?command=" + ("retry" === mod? "retry" : "cancel"),
			params: {},
			columnName: "safStatus"
		};
	},
	search: {
		list: [
			{
				type: "singleDaterange",
				vModel: "fromCreateDateTime",
				label: this.$t("head.from"),
				dateRangeType: "from"
			},
			{
				type: "singleDaterange",
				vModel: "toCreateDateTime",
				label: this.$t("head.to"),
				dateRangeType: "to"
			},
			{
				type: "text",
				vModel: "transactionId",
				label: this.$t("head.transaction") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "modal",
				modalInfo: {
					title: this.$t("igate.service"),
					search: {
						list: [
							{
								type: "text",
								vModel: "serviceId",
								label: this.$t("head.id"),
								placeholder: this.$t("head.searchId"),
								regExpType: "searchId"
							},
							{
								type: "text",
								vModel: "serviceName",
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
						url: '/api/entity/service/search',
						totalCntUrl: '/api/entity/service/count',
						paging: {
							isUse: true,
							side: "server"
						},
						options: {
							columns: [
								{
									name: "serviceId",
									header: this.$t("head.id"),
									width: "25%"
								},
								{
									name: "serviceName",
									header: this.$t("head.name"),
									width: "25%"
								},
								{
									name: "serviceDesc",
									header: this.$t("head.description"),
									width: "25%"
								},
								{
									name: "serviceType",
									header: this.$t("common.type"),
									width: "25%"
								}
							]
						}
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.serviceId;
					}
				},
				vModel: "serviceId",
				label: this.$t("igate.service") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "select",
				vModel: "safStatus",
				label: this.$t("head.status"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.SafMessage.Status'
						},
						orderByKey: true
					},
					optionListName: "safStatusList",
					optionFor: "option in safStatusList",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "modal",
				vModel: "interfaceId",
				label: this.$t("igate.interface") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
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
									header: this.$t("head.id"),
									name: "interfaceId"
								},
								{
									header: this.$t("head.name"),
									name: "interfaceName"
								},
								{
									header: this.$t("head.description"),
									name: "interfaceDesc"
								},
								{
									header: this.$t("common.type"),
									name: "interfaceType"
								}
							]
						}
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.interfaceId;
					}
				}
			},
			{
				type: "text",
				vModel: "pk.safId",
				label: this.$t("igate.saf") + " " + this.$t("head.id"),
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
			{ id: "initialize", isUse: true },
			{ id: "updateCancel", isUse: function(gridInfo) {
				if (null === gridInfo) return true;
				
				var isUse = true;
				
				var checkedRows = gridInfo.getCheckedRows();

				for (var i = 0; i < checkedRows.length; i++) {
					if ('R' === checkedRows[i].safStatus) {
						isUse = false;
						break;
					}
				}
				
				return isUse;				
			}},
			{ id: "updateRetry", isUse: function(gridInfo) {
				if (null === gridInfo) return true;
				
				var isUse = true;
				
				var checkedRows = gridInfo.getCheckedRows();

				for (var i = 0; i < checkedRows.length; i++) {
					if ('A' === checkedRows[i].safStatus) {
						isUse = false;
						break;
					}
				}
				
				return isUse;
			}},
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: '/api/entity/safMessage/search',
		totalCntUrl: '/api/entity/safMessage/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			rowHeaders: ["checkbox"],
			columns: [
				{
					name: "pk.createDateTime",
					header: this.$t("igate.connectorControl.create") + " " + this.$t("head.date"),
					align: "center",
					width: "20%",
					formatter: function (obj) {
						return obj.value.substring(0, 19);
					}
				},
				{
					name: "transactionId",
					header: this.$t("head.transaction") + " " + this.$t("head.id"),
					width: "20%"
				},
				{
					name: "serviceId",
					header: this.$t("igate.service") + " " + this.$t("head.id"),
					width: "15%"
				},
				{
					name: "safStatus",
					header: this.$t("igate.saf") + " " + this.$t("head.status"),
					align: "center",
					width: "10%",
					formatter: function (value) {
						switch (value.row.safStatus) {
							case "R": {
								return this.$t("igate.safMessage.ready");
							}
							case "A": {
								return this.$t("igate.safMessage.active");
							}
							case "E": {
								return this.$t("igate.safMessage.expired");
							}
							case "D": {
								return this.$t("igate.safMessage.done");
							}
							case "C": {
								return this.$t("igate.safMessage.cancel");
							}
						}
					}
				},
				{
					name: "interfaceId",
					header: this.$t("igate.interface") + " " + this.$t("head.id"),
					width: "15%"
				},
				{
					name: "pk.safId",
					header: this.$t("igate.saf") + " " + this.$t("head.id"),
					width: "20%"
				}
			]
		}
	},

	detail: {
		pk: ["pk.createDateTime", "pk.adapterId", "pk.instanceId", "pk.safId"],
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
								vModel: "pk.createDateTime",
								label:
									this.$t("igate.connectorControl.create") +
									" " +
									this.$t("head.date"),
								isPK: true,
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "pk.adapterId",
								label:
									this.$t("igate.adapter") +
									" " +
									this.$t("head.id"),
								isPK: true,
								clickEvt: function (component) {
									openNewTab('202030', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "adapterId": component.getData()['pk.adapterId'] }));
									});
								}
							},
							{
								type: "text",
								vModel: "pk.instanceId",
								label:
									this.$t("igate.instance") +
									" " +
									this.$t("head.id"),
								isPK: true
							},
							{
								type: "text",
								vModel: "pk.safId",
								label:
									this.$t("igate.saf") +
									" " +
									this.$t("head.id"),
								isPK: true
							}
						],
						[
							{
								type: "text",
								vModel: "transactionId",
								label:
									this.$t("head.transaction") +
									" " +
									this.$t("head.id")
							},
							{
								type: "text",
								vModel: "messageId",
								label:
									this.$t("igate.message") +
									" " +
									this.$t("head.id")
							},
							{
								type: "text",
								vModel: "interfaceId",
								label:
									this.$t("igate.interface") +
									" " +
									this.$t("head.id"),
								clickEvt: function (component) {
									const searchData = component.getData().interfaceId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101050', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({ "interfaceId": searchData }));
									});
								}
							},
							{
								type: "text",
								vModel: "serviceId",
								label:
									this.$t("igate.service") +
									" " +
									this.$t("head.id"),
								clickEvt: function (component) {
									const searchData = component.getData().serviceId;
									
									if (!searchData) {
										$alert({ type: 'warn', message: $t('head.no.data.warn') });
										return;
									}
									
									openNewTab('101030', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"serviceId": searchData }));
									});
								}
							},
							{
								type: "text",
								vModel: "safStatus",
								label:
									this.$t("igate.saf") +
									" " +
									this.$t("head.status"),
								formatter: function (value) {
									switch (value) {
										case "R": {
											return this.$t(
												"igate.safMessage.ready"
											);
										}
										case "A": {
											return this.$t(
												"igate.safMessage.active"
											);
										}
										case "E": {
											return this.$t(
												"igate.safMessage.expired"
											);
										}
										case "D": {
											return this.$t(
												"igate.safMessage.done"
											);
										}
										case "C": {
											return this.$t(
												"igate.safMessage.cancel"
											);
										}
									}
								}.bind(this)
							}
						]
					]
				]
			}
		]
	}
};
