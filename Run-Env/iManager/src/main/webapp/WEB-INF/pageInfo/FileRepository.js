const info = {
	type: "basic",
	cudUrl: '/api/entity/fileRepository/object',
	updateStatusFunc: function (row, mod) {
		return {
			url: "/api/entity/fileRepository/control?command=" + ("retry" === mod? "retry" : "cancel"),
			params: {},
			columnName: "fileStatus"
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
				type: "select",
				vModel: "pk.fileMode",
				label: this.$t("head.mode"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.FileRepository.Mode'
						},
						orderByKey: true
					},
					optionListName: "fileMode",
					optionFor: "option in fileMode",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "text",
				vModel: "pk.fileName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName"),
				regExpType: "name"
			},
			{
				type: "select",
				vModel: "fileStatus",
				label: this.$t("head.status"),
				optionInfo: {
					url: '/api/page/properties',
					params: {
						pk: {
							propertyId: 'List.FileRepository.Status'
						},
						orderByKey: true
					},
					optionListName: "fileStatus",
					optionFor: "option in fileStatus",
					optionValue: "option.pk.propertyKey",
					optionText: "option.propertyValue"
				}
			},
			{
				type: "singleDate",
				vModel: "pk.fileDate",
				label: this.$t("head.date"),
				dateFormat: "YYYYMMDD"
			},
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
									header: this.$t("igate.adapter.structure.request"),
									width: "20%"
								},
								{
									name: "responseStructure",
									header: this.$t("igate.adapter.structure.response"),
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
				type: "modal",
				vModel: "interfaceServiceId",
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
				}
			},
			{
				type: "modal",
				vModel: "interfaceServiceId",
				label:this.$t("igate.service") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId",
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
				}
			},
			{
				type: "text",
				vModel: "transactionId",
				label: this.$t("head.transaction") + " " + this.$t("head.id"),
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
			{
				id: "updateCancel",
				isUse: function (gridInfo) {
					if (null === gridInfo) return true;

					var isUse = true;

					var checkedRows = gridInfo.getCheckedRows();

					for (var i = 0; i < checkedRows.length; i++) {
						var checkedRow = checkedRows[i];
						var fileMode = checkedRow["pk.fileMode"];
						var fileStatus = checkedRow.fileStatus;

						if ("S" === fileMode) {
							if (
								!(
									"R" === fileStatus ||
									"W" === fileStatus ||
									"E" === fileStatus
								)
							) {
								isUse = false;
								break;
							}
						} else {
							if (
								!(
									"A" === fileStatus ||
									"F" === fileStatus
								)
							) {
								isUse = false;
								break;
							}
						}
					}

					return isUse;
				}
			},
			{
				id: "updateRetry",
				isUse: function (gridInfo) {
					if (null === gridInfo) return true;

					var isUse = true;

					var checkedRows = gridInfo.getCheckedRows();

					for (var i = 0; i < checkedRows.length; i++) {
						var checkedRow = checkedRows[i];
						var fileMode = checkedRow["pk.fileMode"];
						var fileStatus = checkedRow.fileStatus;

						if ("S" === fileMode) {
							if (
								!(
									"X" === fileStatus ||
									"C" === fileStatus ||
									"D" === fileStatus ||
									"S" === fileStatus
								)
							) {
								isUse = false;
								break;
							}
						} else {
							if (
								!(
									"X" === fileStatus ||
									"C" === fileStatus ||
									"H" === fileStatus
								)
							) {
								isUse = false;
								break;
							}
						}
					}

					return isUse;
				}
			},
			{ id: "newTab", isUse: true }
		]
	},
	grid: {
		url: '/api/entity/fileRepository/search',
		totalCntUrl: '/api/entity/fileRepository/count',
		paging: {
			isUse: true,
			side: "client"
		},
		options: {
			rowHeaders: ["checkbox"],
			columns: [
				{
					name: "createDateTime",
					header: this.$t("igate.connectorControl.create") + " " + this.$t("head.date"),
					align: "center",
					width: "10%",
					formatter: function (obj) {
						return obj.value.substring(0, 19);
					}
				},
				{
					name: "pk.fileMode",
					header: this.$t("head.file") + " " + this.$t("head.mode"),
					align: "center",
					width: "5%",
					formatter: function (value) {
						switch (value.row["pk.fileMode"]) {
							case "R": {
								return this.$t("head.recv");
							}
							case "S": {
								return this.$t("head.send");
							}
						}
					}
				},
				{
					name: "pk.fileName",
					header: this.$t("head.file") + " " + this.$t("head.name"),
					width: "20%"
				},
				{
					name: "fileStatus",
					header: this.$t("head.file") + " " + this.$t("head.status"),
					align: "center",
					width: "10%",
					formatter: function (value) {
						var fileStatus = "";
						var fileStatusList = value.formatterData.fileStatusList;

						for (var i = 0; i < fileStatusList.length; i++) {
							if (
								value.row.fileStatus ===
								fileStatusList[i].pk.propertyKey
							) {
								fileStatus = fileStatusList[i].propertyValue;
								break;
							}
						}

						return fileStatus;
					}
				},
				{
					name: "pk.fileDate",
					header: this.$t("head.file") + " " + this.$t("head.date"),
					align: "center",
					width: "10%"
				},
				{
					name: "pk.adapterId",
					header: this.$t("igate.adapter") + " " + this.$t("head.id"),
					width: "10%"
				},
				{
					name: "interfaceServiceId",
					header: this.$t("igate.interface") + " " + this.$t("igate.service") + " " + this.$t("head.id"),
					width: "15%"
				},
				{
					name: "transactionId",
					header: this.$t("head.transaction") + " " + this.$t("head.id"),
					width: "15%"
				},
				{
					name: "fileLength",
					header: this.$t("head.file") + " " + this.$t("head.length"),
					align: "right",
					width: "5%",
					formatter: function (info) {
						const number = info.row.fileLength;
						return number
							? number
									.toString()
									.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
							: "";
					}
				}
			]
		},
		formatterDataUrlList: [
			{
				key: "fileStatusList",
				url: "/api/page/properties",
				param: {
					pk: {
						propertyId: "List.FileRepository.Status"	
					},
					orderByKey: true
				}
			}
		]
	},

	detail: {
		pk: [
			"pk.fileMode",
			"pk.adapterId",
			"pk.fileDate",
			"pk.fileName",
			"pk.fileSequence"
		],
		button: {
			list: []
		},
		tabList: [
			{
				type: "bundle",
				label: this.$t("head.basic.info"),
				url: "/fileRepository/DetailBasic",
				content: [
					[
						[
							{
								type: "text",
								vModel: "pk.fileMode",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.mode"),
								isPK: true,
								formatter: function (value) {
									switch (value) {
										case "R": {
											return this.$t("head.recv");
										}
										case "S": {
											return this.$t("head.send");
										}
									}
								}.bind(this)
							},
							{
								type: "text",
								vModel: "pk.fileDate",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.date"),
								isPK: true
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
										localStorage.setItem("searchObj", JSON.stringify({"adapterId": component.getData()['pk.adapterId']}));
									});
								}
							},
							{
								type: "text",
								vModel: "pk.fileName",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.name"),
								isPK: true
							},
							{
								type: "text",
								vModel: "pk.fileSequence",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.sequence"),
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
									this.$t("head.id"),
								clickEvt: function (component) {
									openNewTab('103020', function() {
										localStorage.removeItem("searchObj");
										localStorage.setItem("searchObj", JSON.stringify({"transactionId": component.getData().transactionId}));
									});
								}
							},
							{
								type: "text",
								vModel: "interfaceServiceId",
								label:
									this.$t("igate.interface") +
									" " +
									this.$t("igate.service") +
									" " +
									this.$t("head.id")
							},
							{
								type: "text",
								vModel: "createDateTime",
								label:
									this.$t("igate.connectorControl.create") +
									" " +
									this.$t("head.date"),
								formatter: function (value) {
									return value
										? value.substring(0, 19)
										: value;
								}
							},
							{
								type: "text",
								vModel: "instanceId",
								label:
									this.$t("igate.instance") +
									" " +
									this.$t("head.id")
							},
							{
								type: "text",
								vModel: "fileRemoteName",
								label:
									this.$t("head.file") +
									" " +
									this.$t("igate.fileRepository.remote") +
									" " +
									this.$t("head.name")
							}
						],
						[	
							{
								type: "text",
								vModel: "filePath",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.path")
							},
							{
								type: "text",
								vModel: "fileLength",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.length")
							},
							{
								type: "text",
								vModel: "fileOffset",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.offset")
							},
							{
								type: "select",
								vModel: "fileStatus",
								label:
									this.$t("head.file") +
									" " +
									this.$t("head.status"),
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.FileRepository.Status'
										},
										orderByKey: true
									},
									optionListName: "fileStatus",
									optionFor: "option in fileStatus",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								}
							}
						]
					]
				]
			}
		]
	}
};
