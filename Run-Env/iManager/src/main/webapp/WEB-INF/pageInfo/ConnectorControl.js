const info = {
	type: 'basic',	
	cudUrl: '/igate/connectorControl/object.json',
	search: {
		list: [
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
				vModel: 'instanceIdId',
				label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
			},
			{
				type: 'select',
				vModel: 'statusInfo',
				label: this.$t('head.status') + ' ' + this.$t('head.info'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.Connector.StatusInfo',
						orderByKey: true,
					},
					optionListName: 'connectorStatusList',
					optionFor: 'option in connectorStatusList',
					'optionValue': 'option.pk.propertyKey',
	  				'optionText': 'option.propertyValue',
				},
			},
			{ 
				type: 'modal', 
				modalInfo: {
					title: this.$t('igate.adapter'),
					search: {
						list: [
							{ type: 'text', vModel: 'adapterId', label: this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId' },
							{ type: 'text', vModel: 'adapterName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name' },
							{ type: 'text', vModel: 'adapterDesc', label: this.$t('head.description'), placeholder: this.$t('head.searchComment'), regExpType: 'desc' },
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
						url: '/igate/adapter/searchPopup.json',
						totalCntUrl: '/igate/adapter/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: 'adapterId',
									header: this.$t('head.id'),
									width: '20%',
								},
								{
									name: 'adapterName',
									header: this.$t('head.name'),
									width: '20%',
								},
								{
									name: 'adapterDesc',
									header: this.$t('head.description'),
									width: '20%',
								},
								{
									name: 'requestStructure',
									header: this.$t('igate.adapter.structure.request'),
									width: '20%',
								},
								{
									name: 'responseStructure',
									header: this.$t('igate.adapter.structure.response'),
									width: '20%',
								},
							],
						},
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.adapterId;
					},
				},
				vModel: 'adapterId',
				label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId') ,
				regExpType: 'searchId',
			},				
			{
				type: 'modal',
				modalInfo: {
					title: this.$t('igate.connector'),
					search: {
						list: [
							{
								type: 'text',
								vModel: 'connectorId',
								label: this.$t('head.id'),
								placeholder: this.$t('head.searchId'),
								regExpType: 'searchId',
							},
							{
								type: 'text',
								vModel: 'connectorName',
								label: this.$t('head.name'),
								placeholder: this.$t('head.searchName'),
								regExpType: 'name',
							},
							{
								type: 'select',
								vModel: 'connectorType',
								label: this.$t('common.type'),
								optionInfo: {
									url: '/common/property/properties.json',
									params: {
										propertyId: 'List.Connector.Type',
										orderByKey: true,
									},
									optionListName: 'connectorTypes',
									optionFor: 'option in connectorTypes',
									optionValue: 'option.pk.propertyKey',
									optionText: 'option.propertyValue',
								},
							},
							{
								type: 'text',
								vModel: 'connectorDesc',
								label: this.$t('head.description'),
								placeholder: this.$t('head.searchComment'),
								regExpType: 'desc',
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
						url: '/igate/connector/searchPopup.json',
						totalCntUrl: '/igate/connector/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: 'connectorId',
									header: this.$t('head.id'),
								},
								{
									name: 'connectorName',
									header: this.$t('head.name'),
								},
								{
									name: 'connectorDesc',
									header: this.$t('head.description'),
								},
							],
						},
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.connectorId;
					},
				},
				vModel: 'connectorId',
				label: this.$t('igate.connector') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
			},
			{
				type: 'text',
				vModel: 'connectorName',
				label: this.$t('igate.connector') + ' ' + this.$t('head.name'),
				placeholder: this.$t('head.searchName'),
				regExpType: 'name',
			},
			{
				type: 'text',
				vModel: 'socketAddress',
				label: 'Socket Address',
				placeholder: this.$t('head.searchData'),
			},
			{
				type: 'text',
				vModel: 'socketPortSnapshot',
				label: 'Socket Port',
				placeholder: this.$t('head.searchData'),
				regExpType: 'num',
			},			
			{
				type: 'text',
				vModel: 'connectorDesc',
				label: this.$t('igate.connector') + ' ' + this.$t('head.description'),
				placeholder: this.$t('head.searchComment'),
				regExpType: 'desc',
			},			
		]
	},
	button: {
		list: [
			{ id: 'initialize', isUse: true },
			{ id: 'newTab', isUse: true },
			{ id: 'start', isUse: true },
			{ id: 'stop', isUse: true },
			{ id: 'stopForce', isUse: true },
			{ id: 'interrupt', isUse: true },
			{ id: 'block', isUse: true },
			{ id: 'unblock', isUse: true },
		],
	},
	grid: {
		url: '/igate/connectorControl/searchSnapshot.json',
		totalCntUrl: null,
		paging: {
			isUse: false,
			side: 'client',
		},
		options: {
			rowHeaders : ['checkbox'],
    		header : {
    			height : 60,
    			complexColumns : [
    				{
    					name : "sessioninfo",
    					header : this.$t('igate.connectorControl.session') + ' ' + this.$t('head.info'),
    					childNames : ["sessionCount", "sessionInuse", "sessionMaxCount"]
    				}, 
    				{
    					name : "threadinfo",
    					header : this.$t('igate.connectorControl.threadInfo'),
    					childNames : ["threadCount", "threadInuse", "threadMax"]
    				}
    			]
    		},
    		columns : [
    	      	{
    	        	name : "instanceId",
    	        	header : this.$t('igate.instance') + ' ' + this.$t('head.id'),
    	        	align : "left",
                    width: "8%"
    	      	},     		
    	      	{
    	        	name : "status",
    	        	header : this.$t('head.status') + ' ' + this.$t('head.info'),
    	        	align : "center",
                    width: "7%",
    	        	formatter : function(name) {	        		
    	        		var backgroundColor = "";
    	        		var fontColor = "#151826";
    	        		
    	        		if(name.row.status == "Down")          {backgroundColor = "" ;}
    	        		else if(name.row.status == "Normal")   {backgroundColor = "#62d36f" ; fontColor = "white" ;}
    	        		else if(name.row.status == "Starting") {backgroundColor = "" ;}
    	        		else if(name.row.status == "Stoping")  {backgroundColor = "" ;}
    	        		else if(name.row.status == "Error")    {backgroundColor = "#ed3137" ; fontColor = "white" ;}
    	        		else if(name.row.status == "Fail")     {backgroundColor = "#9932a1" ; fontColor = "white" ;}
    	        		else if(name.row.status == "Warn")     {backgroundColor = "#b7bf22" ; fontColor = "white" ;}
    	        		else                                   {backgroundColor = "#4e464f" ; fontColor = "white" ;}//Blocking
    	        		
    	        		return '<div style="width:100%;height:100%;background-color:' + backgroundColor + ';color:' +fontColor +';">' + name.row.status.toString() + '</div>';
    	        	}
    	      	},   
    	      	{
    	        	name : "adapterId",
    	        	header : this.$t('igate.adapter') + ' ' + this.$t('head.id'),
    	        	align : "left",
                    width: "10%"
    	      	},     	      	
    			{
    	        	name : "connectorId",
    	        	header : this.$t('igate.connector') + ' ' + this.$t('head.id'),
    		        align : "left",
                    width: "10%"
    	      	}, 
    	      	{
    	        	name : "connectorName",
    	        	header : this.$t('igate.connector') + ' ' + this.$t('head.name'),
    	        	align : "left",
                    width: "11%"
    	      	}, 
    	      	{
    	        	name : "socketAddress",
    	        	header : 'Socket Address',
    	        	align : "left",
                    width: "8%"
    	      	}, 
    	      	{
    	        	name : "socketPort",
    	        	header : 'Socket Port',
    	        	align : "center",
                    width: "6%"
    	      	}, 
    	      	{
    	        	name : "connectorDesc",
    	        	header : this.$t('igate.connector') + ' ' + this.$t('head.description'),
    	        	align : "left",
                    width: "11%"
    	      	},     	      	
    	      	{
    	        	name : "sessionCount",
    	        	header : this.$t('igate.connectorControl.create'),
    	        	align : "right",
                    width: "5%",
	    	      	formatter: function(info) {
	            		return info.row.sessionCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
	                }
    	      	}, 
    	      	{
    	        	name : "sessionInuse",
    	        	header : this.$t('igate.connectorControl.inuse'),
    	        	align : "right",
                    width: "5%",
                    formatter: function(info) {
                		return new String(info.row.sessionInuse).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                  	}
    	      	}, 	
    	      	{
    	        	name : "sessionMaxCount",
    	        	header : this.$t('igate.connectorControl.max'),
    	        	align : "right",
                    width: "5%",
    	        	formatter : function(name) {
    	        		if(name.row.sessionMaxCount == "2147483647") return "MAX";
    	        		else										 return name.row.sessionMaxCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    	        	}
    	      	}, 
    	      	{
    	      		name : "threadCount",
    	      		header : this.$t('igate.connectorControl.create'),
    	      		align : "right",
                    width: "5%",
                    formatter: function(info) {
                		return info.row.threadCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                  	}
    	      	}, 
    	      	{
    	        	name : "threadInuse",
    	        	header : this.$t('igate.connectorControl.inuse'),
    	        	align : "right",
                    width: "5%",
                    formatter: function(info) {
                    	return info.row.threadInuse.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                  	}
    	      	}, 
    	      	{
    	        	name : "threadMax",
    	        	header : this.$t('igate.connectorControl.max'),
    	        	align : "right",
                    width: "5%",
    	        	formatter : function(name) {
    	        		if(name.row.threadMax == "2147483647")  return "MAX";
    	        		else									return name.row.threadMax.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    	        	}
    	      	}, 
 
    	      	{
    	        	name : "processResult",
    	        	header : this.$t('head.process.result'),
    	        	defaultValue : " ",
                    width: "10%"
    	      	}
    	    ]
		},
	},
	detail: {
		controlUrl: '/igate/connectorControl/control.json',
		controlParams: function(param) {
			return {
				instance: param.instanceId,
				connectorId: param.connectorId
			}
		}		
	}
};