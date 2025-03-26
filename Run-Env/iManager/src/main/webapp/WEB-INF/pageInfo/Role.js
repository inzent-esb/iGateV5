const info = {
	type: "basic",
	cudUrl: '/api/entity/role/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "roleId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "roleDesc",
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
		url: '/api/entity/role/search',
		totalCntUrl: '/api/entity/role/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					header: this.$t("head.id"),
					name: "roleId",
					width: "45%"
				},
				{
					header: this.$t("head.description"),
					name: "roleDesc",
					width: "55%"
				}
			]
		}
	},
	detail: {
		pk: ["roleId"],
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
								vModel: "roleId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							}
						],
						[]
					],
					[
						[
							{
								type: "textarea",
								vModel: "roleDesc",
								label: this.$t("head.description"),
								regExpType: "desc"
							}
						]
					]
				]
			},
			{
				type: "property",
				label: this.$t("common.role.privilege.info"),
				dataKey: "rolePrivileges",
				addRowInfo: {
					type: "modal",
					modalInfo: {
						title:
							this.$t("common.privilege") +
							" " +
							this.$t("head.id"),
						search: {
							list: [
								{
									type: "text",
									vModel: "privilegeId",
									label: this.$t("head.id"),
									placeholder: this.$t("head.searchId"),
									regExpType: "searchId"
								},
								{
									type: "text",
									vModel: "privilegeDesc",
									label: this.$t("head.description"),
									placeholder: this.$t("head.searchComment"),
									regExpType: "desc"
								},
								{
									type: "select",
									vModel: "privilegeType",
									label: this.$t("common.type"),
									optionInfo: {
										url: '/api/page/properties',
										params: {
											pk: {
												propertyId: 'List.Privilege.Type'
											},
											orderByKey: true
										},
										optionListName: "privilegeType",
										optionFor: "option in privilegeType",
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
							url: '/api/entity/privilege/search',
							totalCntUrl: '/api/entity/privilege/count',
							paging: {
								isUse: true,
								side: "server"
							},
							options: {
								columns: [
									{
										header: this.$t("head.id"),
										name: "privilegeId"
									},
									{
										header: this.$t("common.type"),
										name: "privilegeType",
										formatter: function (value) {
											return value.row.privilegeType ==
												"S"
												? this.$t(
														"common.privilege.type.system"
												  )
												: this.$t(
														"common.privilege.type.business"
												  );
										}
									},
									{
										header: this.$t("head.description"),
										name: "privilegeDesc"
									}
								]
							}
						},
						rowClickedCallback: function (rowInfo, propertyList) {
							return {
								duplicate:
									0 === propertyList.length
										? false
										: propertyList.some(function (
												property
										  ) {
												return (
													property[
														"pk.privilegeId"
													] === rowInfo.privilegeId
												);
										  }),
								propertyInfo: {
									"pk.privilegeId": rowInfo.privilegeId
								}
							};
						}
					}
				},
				content: [
					{
						type: "text",
						vModel: "pk.privilegeId",
						label:
							this.$t("common.privilege") +
							" " +
							this.$t("head.id"),
						readonly: true,
						clickEvt: function (component) {
							openNewTab('303050', function() {
								localStorage.removeItem("searchObj");
								localStorage.setItem("searchObj", JSON.stringify({ "privilegeId": component.getData()['pk.privilegeId'], "_pageSize": "10" }));
							});
						}
					}
				]
			}
		]
	}
};
