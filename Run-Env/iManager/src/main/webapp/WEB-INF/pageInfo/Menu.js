const info = {
	type: "basic",
	cudUrl: '/api/entity/menu/object',
	search: {
		load: true,
		list: [
			{
				type: "text",
				vModel: "menuId",
				label: this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				regExpType: "searchId"
			},
			{
				type: "text",
				vModel: "menuName",
				label: this.$t("head.name"),
				placeholder: this.$t("head.searchName")
			},
			{
				type: "text",
				vModel: "menuUrl",
				label: this.$t("common.menu.url"),
				placeholder: this.$t("head.searchData"),
				regExpType: "url"
			},
			{
				type: "text",
				vModel: "menuEditor",
				label: this.$t("common.menu.editor"),
				placeholder: this.$t("head.searchData")
			},
			{
				type: "modal",
				vModel: "menuPrivilegeId",
				label: this.$t("common.privilege") + " " + this.$t("head.id"),
				placeholder: this.$t("head.searchId"),
				modalInfo: {
					title: this.$t("common.privilege"),
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
										return value.row.privilegeType == "S"
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
					rowClickedCallback: function (rowInfo) {
						return rowInfo.privilegeId;
					}
				}
			},
			{
				type: "text",
				vModel: "parentMenuId",
				label: this.$t("common.menu.parent"),
				placeholder: this.$t("head.searchData"),
				regExpType: "num"
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
		url: '/api/entity/menu/search',
		totalCntUrl: '/api/entity/menu/count',
		paging: {
			isUse: true,
			side: "server"
		},
		options: {
			columns: [
				{
					header: this.$t("head.id"),
					name: "menuId",
					width: "10%"
				},
				{
					header: this.$t("head.name"),
					name: "menuName",
					width: "30%"
				},
				{
					header: this.$t("common.menu.url"),
					name: "menuUrl",
					width: "20%"
				},
				{
					header: this.$t("common.menu.editor"),
					name: "menuEditor",
					width: "20%"
				},
				{
					header: this.$t("common.privilege"),
					name: "menuPrivilegeId",
					width: "20%"
				},
				{
					header: this.$t("common.menu.parent"),
					name: "parentMenuId",
					width: "10%"
				}
			]
		}
	},

	detail: {
		pk: ["menuId"],
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
								vModel: "menuId",
								label: this.$t("head.id"),
								isPK: true,
								regExpType: "id"
							},
							{
								type: "text",
								vModel: "menuName",
								label: this.$t("head.name"),
								isRequired: true
							},
							{
								type: "text",
								vModel: "menuIcon",
								label: this.$t("common.menu.icon")
							},
							{
								type: "text",
								vModel: "menuUrl",
								label: this.$t("common.menu.url"),
								regExpType: "url"
							}
						],
						[
							{
								type: "select",
								vModel: "openWindow",
								label: this.$t("common.menu.openWindow"),
								val: "N",
								optionInfo: {
									url: '/api/page/properties',
									params: {
										pk: {
											propertyId: 'List.Yn'
										},
										orderByKey: true
									},
									optionListName: "openWindowList",
									optionFor: "option in openWindowList",
									optionValue: "option.pk.propertyKey",
									optionText: "option.propertyValue"
								},
								isRequired: true
							},
							{
								type: "text",
								vModel: "menuEditor",
								label: this.$t("common.menu.editor")
							},
							{
								type: "modal",
								vModel: "menuPrivilegeId",
								label: this.$t("common.privilege"),
								modalInfo: {
									title: this.$t("common.privilege"),
									search: {
										list: [
											{
												type: "text",
												vModel: "privilegeId",
												label: this.$t("head.id"),
												placeholder:
													this.$t("head.searchId"),
												regExpType: "id"
											},
											{
												type: "text",
												vModel: "privilegeDesc",
												label: this.$t(
													"head.description"
												),
												placeholder:
													this.$t(
														"head.searchComment"
													),
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
													optionListName:
														"privilegeType",
													optionFor:
														"option in privilegeType",
													optionValue:
														"option.pk.propertyKey",
													optionText:
														"option.propertyValue"
												}
											},
											{
												type: "dataList",
												vModel: "pageSize",
												label: this.$t(
													"head.listCount"
												),
												val: "10",
												optionInfo: {
													optionFor:
														"option in [10, 100, 1000]",
													optionValue: "option",
													optionText: "option"
												}
											}
										]
									},
									button: {
										list: [
											{ id: "initialize", isUse: true }
										]
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
													header: this.$t(
														"common.type"
													),
													name: "privilegeType",
													formatter: function (
														value
													) {
														return value.row
															.privilegeType ==
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
													header: this.$t(
														"head.description"
													),
													name: "privilegeDesc"
												}
											]
										}
									},
									rowClickedCallback: function (rowInfo) {
										return rowInfo.privilegeId;
									}
								}
							},
							{
								type: "text",
								vModel: "parentMenuId",
								label: this.$t("common.menu.parent"),
								regExpType: "num"
							}
						]
					]
				]
			}
		]
	}
};
