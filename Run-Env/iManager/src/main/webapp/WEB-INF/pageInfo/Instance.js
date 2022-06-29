const info = {
	type: 'basic',	
	cudUrl: '/igate/instance/object.json',
	search: {
		load: true,
		list: [
			{
				type: 'text',
				vModel: 'instanceId',
				label: this.$t('head.id'), 
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
			},		
			{
				type: 'select',
				vModel: 'instanceType',
				label: this.$t('common.type'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.Instance.InstanceType',
						orderByKey: true
					},
					optionListName: 'instanceTypes',
					optionFor: 'option in instanceTypes',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				}
			},
			{
				type: 'text',
				vModel: 'instanceNode',
				label: this.$t('igate.instance.node'), 
				placeholder: this.$t('head.searchData'),
			},	
			{
				type: 'dataList',
				vModel: 'pageSize',
				label: this.$t('head.listCount'),
				val: '10',
				optionInfo: {
					optionFor: 'option in [10, 100, 1000]',
					optionValue: 'option',
					optionText: 'option',
				},
			}			
		]
	},
	button: {
		list: [
			{ id: 'add', isUse: true },
			{ id: 'initialize', isUse: true },
			{ id: 'newTab', isUse: true },
		],
	},
	grid: {
		url: '/igate/instance/search.json',
		totalCntUrl: '/igate/instance/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
    		columns: [
    			{
    				name: "instanceId",
    				header: this.$t('head.id'),
    				align: "left",
    				width: '45%'
    			},
    			{
    				name: "instanceType",
    				header: this.$t('common.type'),
    				align: "center",
    				width: '10%',
    				formatter: function(value) {
    					switch (value.row.instanceType) {
	    					case 'T': {
	    	                  return this.$t('igate.instance.type.trx');
	    	                }
	    					case 'A': {
	    	                  return this.$t('igate.instance.type.adm');
	    	                }
	    	                case 'L': {
	    	                  return this.$t('igate.instance.type.log');
	    	                }
	    	                case 'M': {
	    	                  return this.$t('igate.instance.type.mnt');
	    	                }
    					}
    				}    				
    			},
    			{
    				name: "instanceNode",
    				header: this.$t('igate.instance.node'),
    				width: '45%'
    			}
    		]
		},
	},
	detail: {
		pk: ['instanceId'],
		controlUrl: '/igate/instance/control.json',
		controlParams: function(detailData) {
			return {
				'instanceId': detailData.instanceId
			};
		},				
		button: {
			list: [
				{ id: 'insert', isUse: true },
				{ id: 'update', isUse: true },
				{ id: 'delete', isUse: true },
				{ id: 'dump', isUse: true },
			],
		},
		tabList: [
			{
				type: 'basic',
				label: this.$t('head.basic.info'),
				content: [
					[
						[
							{ type: 'text', vModel: 'instanceId', label: this.$t('head.id'), isPK: true, regExpType: 'id' },
							{
								type: 'select',
								vModel: 'instanceType',
								label: this.$t('common.type'),
								isRequired: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Instance.InstanceType',
										orderByKey: true
									},
									optionListName: 'instanceTypes',
									optionFor: 'option in instanceTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},	
							{
								type: 'select',
								vModel: 'logLevel',
								label: this.$t('head.log.level'),
								isRequired: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.LogLevel',
										orderByKey: false
									},
									optionListName: 'instanceLoglevels',
									optionFor: 'option in instanceLoglevels',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
									optionDisabled: "'N/A' === option.propertyValue"
								},
							},							
						],
						[
							{ type: 'text', vModel: 'instanceAddress', isRequired: true, label: this.$t('igate.instance.address') },
							{ type: 'text', vModel: 'instanceNode', isRequired: true, label: this.$t('igate.instance.node') },
							{
								type: 'select',
								vModel: 'downStatus',
								label: this.$t('igate.instance.downStatus'),
								isRequired: true,
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Yn',
										orderByKey: true
									},
									optionListName: 'instanceDownStatus',
									optionFor: 'option in instanceDownStatus',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},							
						],											
					],
				],
			},
			{
				type: 'bundle',
				label: this.$t('head.property'),
				url: '/instance/Property',
			}
		]
	}
	
};