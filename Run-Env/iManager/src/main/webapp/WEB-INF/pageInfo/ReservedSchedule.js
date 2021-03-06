const info = {
		type: 'basic',
		cudUrl: '/igate/reservedSchedule/object.json',
		search: {
			load: true,
			list: [
				{ type: 'singleDaterange', vModel: 'fromReserveDateTime', label: this.$t('head.from'), dateRangeType : 'from'},
				{ type: 'singleDaterange', vModel: 'toReserveDateTime', label: this.$t('head.to'), dateRangeType : 'to'},
				{
					type: 'select',
					vModel: 'pk.scheduleType',
					label: this.$t('common.type'),
					optionInfo: {
						url: '/common/property/properties.json',
						params: {
							propertyId: 'List.ReservedSchedule.ScheduleType',
							orderByKey: true,
						},
						optionListName: 'scheduleTypes',
						optionFor: 'option in scheduleTypes',
						optionValue: 'option.pk.propertyKey',
						optionText: 'option.propertyValue',
					},
				},
				{
					type: 'modal', 
					modalInfo: {
						title: this.$t('igate.instance'),
						search: {
							list: [
								{ type: 'text', vModel: 'instanceId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
								{ type: 'text', vModel: 'instanceNode', label: this.$t('igate.instance.node'), placeholder: this.$t('head.searchData') },
								{
									type: 'select',
									vModel: 'instanceType',
									label: this.$t('common.type'),
									val: 'T',
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
										optionIf: "option.pk.propertyKey == 'T'",										
										isViewAll: false,
									},
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
								},
							],
						},
						button: {
							list: [{ id: 'initialize', isUse: true }],
						},
						grid: {
							url: '/igate/instance/searchPopup.json',
							totalCntUrl: '/igate/instance/rowCount.json',
							paging: {
								isUse: true,
								side: 'server',
							},
							options: {
								columns: [
									{
										name: 'instanceId',
										header: this.$t('head.id'),
										width: '25%',
									},
									{
										name: 'instanceType',
										header: this.$t('common.type'),
										width: '25%',
										formatter: function(value) {
											switch (value.row.instanceType) {
												case 'T' : {
													return this.$t('igate.instance.type.trx');
												}
												case 'A' : {
													return this.$t('igate.instance.type.adm');
												}
												case 'L' : {
													return this.$t('igate.instance.type.log');
												}
												case 'M' : {
													return this.$t('igate.instance.type.mnt');
												}
											}
										},
									},
									{
										name: 'instanceAddress',
										header: this.$t('igate.instance.address'),
										width: '25%',
									},
									{
										name: 'instanceNode',
										header: this.$t('igate.instance.node'),
										width: '25%',
									},
								],
							},
						},
						rowClickedCallback: function (rowInfo) {
							return rowInfo.instanceId;
						},
					},
					vModel: 'pk.instanceId',
					label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
					placeholder: this.$t('head.searchId'),
					regExpType: 'searchId',
				},
				{ 
					type: 'text', 	
					vModel: 'pk.reserveSchedule',		
					label: this.$t('igate.reservedSchedule'),		
					placeholder: this.$t('head.searchData'),
				},				
				{
					type: 'select',
					vModel: 'executeStatus',
					label: this.$t('igate.reservedSchedule.execute.status'),
					optionInfo: {
						url: '/common/property/properties.json',
						params: {
							propertyId: 'List.ReservedSchedule.ExecuteStatus',
							orderByKey: true,
						},
						optionListName: 'executeStatus',
						optionFor: 'option in executeStatus',
						optionValue: 'option.pk.propertyKey',
						optionText: 'option.propertyValue',
					},
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
				},
			],
		},
		button: {
			list: [
				{ id: 'initialize', isUse: true },
				{ id: 'newTab', isUse: true },
			],
		},
		grid: {
			url: '/igate/reservedSchedule/search.json',
			totalCntUrl: '/igate/reservedSchedule/rowCount.json',
			paging: {
				isUse: true,
				side: 'server',
			},
			options: {
				columns: [
					{
						name: 'pk.reserveDateTime',
						header: this.$t('igate.reservedSchedule.reserved.dateTime'),
						align: 'center',
					},
					{
						name: 'pk.scheduleType',
						header: this.$t('common.type'),
						align: 'center',
						formatter : function(type) {                	        		
        	        		if(type.value == "J") 	   return "Job";
        	        		else if(type.value == "I") return "Interface";	 
        	        		else 					   return escapeHtml(type.value);
        	        	},
					},					
					{
						name: 'pk.instanceId',
						header: this.$t('igate.instance') + ' ' + this.$t('head.id'),
					},
					{
						name: 'pk.reserveSchedule',
						header: this.$t('igate.reservedSchedule'),
					},
					{
						name: 'executeStatus',
						header: this.$t('igate.reservedSchedule.execute.status'),
						align: 'center',
						formatter : function(type) {                	        		
							return 'A' == type.value? 'Active' : 'C' == type.value? 'Cancel' : 'D' == type.value? 'Done' : 'E' == type.value? 'Error' : 'R' == type.value? 'Ready' : 'S' == type.value? 'Skip' : 'W' == type.value? 'Waiting' : '';
        	        	},						
					},					
				],
			},
		},
		
		detail: {
			pk: ['pk.reserveDateTime', 'pk.instanceId', 'pk.reserveSchedule', 'pk.scheduleType'],
			button: {
				list: [],
			},
			tabList: [
				{
					type: 'basic',
					label: this.$t('head.basic.info'),
					content: [
						[
							[
								{
									type: 'text',
									vModel: 'pk.reserveDateTime',
									label: this.$t('igate.reservedSchedule.reserved.dateTime'),
									isPK: true,
								},
								{
									type: 'text',
									vModel: 'pk.instanceId',
									label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
									isPK: true,
								},
								{
									type: 'text',
									vModel: 'pk.reserveSchedule',
									label: this.$t('igate.reservedSchedule'),
									isPK: true,
								},
								{
									type: 'select',
									vModel: 'pk.scheduleType',
									label: this.$t('common.type'),
									isPK: true,
									optionInfo: {
										url: '/common/property/properties.json',
										params: {
											propertyId: 'List.ReservedSchedule.ScheduleType',
											orderByKey: true,
										},
										optionListName: 'scheduleTypes',
										optionFor: 'option in scheduleTypes',
										optionValue: 'option.pk.propertyKey',
										optionText: 'option.propertyValue',
									},
								},								
							],
							[
								{
									type: 'select',
									vModel: 'executeStatus',
									label: this.$t('igate.reservedSchedule.execute.status'),
									optionInfo: {
										url: '/common/property/properties.json',
										params: {
											propertyId: 'List.ReservedSchedule.ExecuteStatus',
											orderByKey: true,
										},
										optionListName: 'executeStatus',
										optionFor: 'option in executeStatus',
										optionValue: 'option.pk.propertyKey',
										optionText: 'option.propertyValue',
									},
								},
								{
									type: 'text',
									vModel: 'executeTimestamp',
									label: this.$t('igate.reservedSchedule.execute.timestamp'),								
								},
							],
							[
								{
									type: 'text',
									vModel: 'exceptionMessage',
									label: this.$t('head.exception.message'),								
								},
								{
									type: 'text',
									vModel: 'exceptionDateTime',
									label: this.$t('igate.reservedSchedule.exception.dateTime'),								
								},
								{
									type: 'text',
									vModel: 'exceptionId',
									label: this.$t('head.exception') + ' ' + this.$t('head.id'),
								},
							],
						],
					],
				},
			],
		},
};