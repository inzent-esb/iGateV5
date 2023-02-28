const info = {
	type: "basic",
	cudUrl: "/igate/adapterControl/object.json",
	search: {
		list: [
			{
				type: "select",
				vModel: "instanceId",
				label: this.$t("igate.instance") + " " + this.$t("head.id"),
				optionInfo: {
					url: "/igate/instance/list.json",
					optionListName: "instanceList",
					optionFor: "option in instanceList",
					optionValue: "option.instanceId",
					optionText: "option.instanceId",
					optionIf: "option.instanceType == 'T'"
				}
			},
			{
				type: "select",
				vModel: "statusInfo",
				label: this.$t("head.queue") + " " + this.$t("head.status"),
				optionInfo: {
					optionFor:
						"value in [ 'Down', 'Starting', 'Stopping', 'Fail', 'Warn', 'Normal', 'Undeployed' ]",
					optionValue: "value",
					optionText: "value"
				}
			},
			{
				type: "select",
				vModel: "queueMode",
				label: this.$t("head.queue") + " " + this.$t("head.mode"),
				optionInfo: {
					optionFor:
						"option in [ {text: 'File', value: 'F'}, {text: 'DB', value: 'D'}, {text: 'Memory', value: 'M'}, {text: 'Shared', value: 'S'} ]",
					optionValue: "option.value",
					optionText: "option.text"
				}
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
						url: "/igate/adapter/searchPopup.json",
						totalCntUrl: "/igate/adapter/rowCount.json",
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
				vModel: "adapterId",
				label: this.$t("igate.adapter") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "adapterDesc",
				label:
					this.$t("igate.adapter") +
					" " +
					this.$t("head.description"),
				placeholder: this.$t("head.searchComment"),
				regExpType: "desc"
			}
		]
	},
	button: {
		list: [
			{ id: "initialize", isUse: true },
			{ id: "newTab", isUse: true },
			{ id: "start", isUse: true },
			{ id: "stop", isUse: true }
		]
	},
	grid: {
		url: "/igate/adapterControl/searchSnapshot.json",
		totalCntUrl: null,
		paging: {
			isUse: false,
			side: "client"
		},
		options: {
			rowHeaders: ["checkbox"],
			header: {
				height: 60,
				complexColumns: [
					{
						name: "consumerInfo",
						header: this.$t("igate.adapterControl.consumerInfo"),
						childNames: ["consumerCount", "consumerMax"]
					},
					{
						name: "messageInfo",
						header: this.$t("igate.adapterControl.messageInfo"),
						childNames: ["messageCount", "messageMax"]
					}
				]
			},
			onGridMounted: function (evt) {
				evt.instance.on("click", function (clickEvt) {
					if ("processResult" !== clickEvt.columnName) return;

					if ("columnHeader" == clickEvt.targetType) return;

					if (
						" " ===
						clickEvt.instance.getFormattedValue(
							clickEvt.rowKey,
							"processResult"
						)
					)
						return;

					window.$alert({
						type: "normal",
						message: clickEvt.instance.getFormattedValue(
							clickEvt.rowKey,
							"processResult"
						)
					});
				});
			},
			columns: [
				{
					name: "instanceId",
					header:
						this.$t("igate.instance") + " " + this.$t("head.id"),
					align: "left",
					width: "10%"
				},
				{
					name: "status",
					header:
						this.$t("head.queue") + " " + this.$t("head.status"),
					align: "center",
					width: "10%",
					formatter: function (name) {
						var backgroundColor = "";
						var fontColor = "#151826";

						if (name.row.status == "Down") {
							backgroundColor = "";
						} else if (name.row.status == "Normal") {
							backgroundColor = "#62d36f";
							fontColor = "white";
						} else if (name.row.status == "Starting") {
							backgroundColor = "";
						} else if (name.row.status == "Stoping") {
							backgroundColor = "";
						} else if (name.row.status == "Error") {
							backgroundColor = "#ed3137";
							fontColor = "white";
						} else if (name.row.status == "Fail") {
							backgroundColor = "#9932a1";
							fontColor = "white";
						} else if (name.row.status == "Warn") {
							backgroundColor = "#b7bf22";
							fontColor = "white";
						} else {
							backgroundColor = "#4e464f";
							fontColor = "white";
						} //Blocking

						return (
							'<div style="width:100%; height:100%; background-color:' +
							backgroundColor +
							";color:" +
							fontColor +
							';">' +
							name.row.status.toString() +
							"</div>"
						);
					}
				},
				{
					name: "queueMode",
					header: this.$t("head.queue") + " " + this.$t("head.mode"),
					align: "center",
					width: "5%",
					formatter: function (name) {
						if (name.row.queueMode == "F") return "File";
						else if (name.row.queueMode == "D") return "DB";
						else if (name.row.queueMode == "M") return "Memory";
						else if (name.row.queueMode == "S") return "Shared";
					}
				},
				{
					name: "queueId",
					header: this.$t("igate.adapter") + " " + this.$t("head.id"),
					align: "left",
					width: "10%"
				},
				{
					name: "adapterDesc",
					header:
						this.$t("igate.adapter") +
						" " +
						this.$t("head.description"),
					align: "left",
					width: "10%"
				},
				{
					name: "consumerCount",
					header: this.$t("igate.queue.consumerCount"),
					align: "right",
					width: "10%",
					formatter: function (info) {
						return info.row.consumerCount
							.toString()
							.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
				},
				{
					name: "consumerMax",
					header: this.$t("igate.queue.consumerMax"),
					align: "right",
					width: "10%",
					formatter: function (info) {
						return info.row.consumerMax
							.toString()
							.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
				},
				{
					name: "messageCount",
					header: this.$t("igate.queue.messageCount"),
					align: "right",
					width: "10%",
					formatter: function (info) {
						return info.row.messageCount
							.toString()
							.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
				},
				{
					name: "messageMax",
					header: this.$t("igate.queue.messageMax"),
					align: "center",
					width: "10%",
					formatter: function (name) {
						if (name.row.messageMax == "2147483647") return "MAX";
						else
							return name.row.messageMax
								.toString()
								.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					}
				},
				{
					name: "processResult",
					header: this.$t("head.process.result"),
					align: "left",
					defaultValue: " ",
					width: "15%"
				}
			]
		}
	},
	detail: {
		controlUrl: "/igate/adapterControl/control.json",
		controlParams: function (param) {
			return {
				instance: param.instanceId,
				adapterId: param.queueId
			};
		}
	}
};
