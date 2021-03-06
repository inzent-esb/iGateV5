const info = {
	type: 'basic',
	cudUrl: '/igate/fileRepository/object.json',
	updateStatusFunc: function(row, mod) {
		return {
			url: 'R' === mod? '/igate/fileRepository/updateReady.json' : '/igate/fileRepository/updateCancel.json',
			params: {
				fileStatus: row.fileStatus
			},
			columnName: 'fileStatus',
		}
	},
	search: {
		list: [
			{ type: 'singleDaterange', vModel: 'fromCreateDateTime', label: this.$t('head.from'), dateRangeType : 'from'},
			{ type: 'singleDaterange', vModel: 'toCreateDateTime', label: this.$t('head.to'), dateRangeType : 'to'},
			{
				type: 'select',
				vModel: 'pk.fileMode',
				label: this.$t('head.mode'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.FileRepository.Mode',
						orderByKey: true,
					},
					optionListName: 'fileMode',
					optionFor: 'option in fileMode',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
			},
			{ type: 'text', vModel: 'pk.fileName', label: this.$t('head.name'), placeholder: this.$t('head.searchName'), regExpType: 'name'},
			{
				type: 'select',
				vModel: 'fileStatus',
				label: this.$t('head.status'),
				optionInfo: {
					url: '/common/property/properties.json',
					params: {
						propertyId: 'List.FileRepository.Status',
						orderByKey: true,
					},
					optionListName: 'fileStatus',
					optionFor: 'option in fileStatus',
					optionValue: 'option.pk.propertyKey',
					optionText: 'option.propertyValue',
				},
			},
			{ type: 'singleDate', vModel: 'pk.fileDate', label: this.$t('head.date'), dateFormat: "YYYYMMDD"},
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
				vModel: 'pk.adapterId',
				label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',
			},
			{
				type: 'modal',
				vModel: 'interfaceServiceId',
				label: this.$t('igate.interface') + ' ' + this.$t('igate.service') + ' ' + this.$t('head.id'),
				placeholder: this.$t('head.searchId'),
				regExpType: 'searchId',				
				modalInfo: {
					title: this.$t('igate.service'),
					search: {
						list: [
							{
								type: 'text',
								vModel: 'serviceId',
								label: this.$t('head.id'),
								placeholder: this.$t('head.searchId'),
								regExpType: 'searchId',
							},
							{
								type: 'text',
								vModel: 'serviceName',
								label: this.$t('head.name'),
								placeholder: this.$t('head.searchName'),
								regExpType: 'name',
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
						url: '/igate/service/searchPopup.json',
						totalCntUrl: '/igate/service/rowCount.json',
						paging: {
							isUse: true,
							side: 'server',
						},
						options: {
							columns: [
								{
									name: 'serviceId',
									header: this.$t('head.id'),
									width: '25%',
								},
								{
									name: 'serviceName',
									header: this.$t('head.name'),
									width: '25%',
								},
								{
									name: 'serviceDesc',
									header: this.$t('head.description'),
									width: '25%',
								},
								{
									name: 'serviceType',
									header: this.$t('common.type'),
									width: '25%',
								},
							],
						},
					},
					rowClickedCallback: function (rowInfo) {
						return rowInfo.serviceId;
					},
				},
			},
			{ type: 'text', vModel: 'transactionId', label: this.$t('head.transaction') + ' ' + this.$t('head.id'), placeholder: this.$t('head.searchId'), regExpType: 'searchId'},			
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
			{ id: 'updateCancel', isUse: true },
			{ id: 'updateReady', isUse: true },
			{ id: 'newTab', isUse: true },
		],
	},
	grid: {
		url: '/igate/fileRepository/search.json',
		totalCntUrl: '/igate/fileRepository/rowCount.json',
		paging: {
			isUse: true,
			side: 'server',
		},
		options: {
			rowHeaders: ['checkbox'],
			columns: [
				{
					name: 'createDateTime',
					header: this.$t('igate.connectorControl.create') + ' ' + this.$t('head.date'),
					align: 'center',
				},				
				{
					name: 'pk.fileMode',
					header: this.$t('head.file') + ' ' + this.$t('head.mode'),
					align: 'center',
					width: '6%',
					formatter: function(value) {
						switch (value.row['pk.fileMode']) {
							case 'R' : {
								return this.$t('head.recv');
							}
							case 'S' : {
								return this.$t('head.send');
							}
						}						
					},
				},
				{
					name: 'pk.fileName',
					header: this.$t('head.file') + ' ' + this.$t('head.name'),
				},	
				{
					name: 'fileStatus',
					header: this.$t('head.file') + ' ' + this.$t('head.status'),
					align: 'center',
					formatter : function(value)
	                {
	                  switch (value.row.fileStatus) {
		                  case 'R' : {
		                    return this.$t('igate.fileRepository.ready');
		                  }
		                  case 'W' : {
		                	  return this.$t('igate.fileRepository.wait');
		                  }
		                  case 'M' : {
		                	  return this.$t('igate.fileRepository.making');
		                  }
		                  case 'A' : {
		                	  return this.$t('igate.fileRepository.active');
		                  }
		                  case 'E' : {
		                	  return this.$t('igate.fileRepository.error');
		                  }
		                  case 'D' : {
		                	  return this.$t('igate.fileRepository.done');
		                  }
		                  case 'P' : {
		                	  return this.$t('igate.fileRepository.process');
		                  }
		                  case 'X' : {
		                	  return this.$t('igate.fileRepository.expire');
		                  }
		                  case 'C' : {
		                	  return this.$t('igate.fileRepository.cancel');
		                  }
		                  case 'H' : {
		                	  return this.$t('igate.fileRepository.finish');
		                  }
		                  case 'F' : {
		                	  return this.$t('igate.fileRepository.fail');
		                  }
	                  }
	                },
				},
				{
					name: 'pk.fileDate',
					header: this.$t('head.file') + ' ' + this.$t('head.date'),
					align: 'center',
				},
				{
					name: 'pk.adapterId',
					header: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
				},
				{
					name: 'interfaceServiceId',
					header: this.$t('igate.interface') + ' ' + this.$t('igate.service') + ' ' + this.$t('head.id'),
				},
				{
					name: 'transactionId',
					header: this.$t('head.transaction') + ' ' + this.$t('head.id'),
				},
				{
					name: 'fileLength',
					header: this.$t('head.file') + ' ' + this.$t('head.length'),
					align: 'right',
					formatter: function(info) {
						const  number = info.row.fileLength;
						return number ? number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '';
					},
				},
			],
		},
	},
	
	detail: {
		pk: ['pk.fileMode', 'pk.adapterId', 'pk.fileDate', 'pk.fileName', 'pk.fileSequence'],
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
								vModel: 'pk.fileMode',
								label: this.$t('head.file') + ' ' + this.$t('head.mode'),
								isPK: true,
								formatter: function(value) {
									switch (value) {
										case 'R' : {
											return 'Recv';
										}
										case 'S' : {
											return 'Send';
										}
									}
								},
							},
							{
								type: 'text',
								vModel: 'pk.fileDate',
								label: this.$t('head.file') + ' ' + this.$t('head.date'),
								isPK: true,
							},
							{
								type: 'text',
								vModel: 'pk.adapterId',
								label: this.$t('igate.adapter') + ' ' + this.$t('head.id'),
								isPK: true,
							},
							{
								type: 'text',
								vModel: 'pk.fileName',
								label: this.$t('head.file') + ' ' + this.$t('head.name'),
								isPK: true,
							},
							{
								type: 'text',
								vModel: 'pk.fileSequence',
								label: this.$t('head.file') + ' ' + this.$t('head.sequence'),
								isPK: true,
							},
						],
						[
							{
								type: 'text',
								vModel: 'transactionId',
								label: this.$t('head.transaction') + ' ' + this.$t('head.id'),
							},
							{
								type: 'text',
								vModel: 'interfaceServiceId',
								label: this.$t('igate.interface') + ' ' + this.$t('igate.service') + ' ' + this.$t('head.id'),
							},
							{
								type: 'text',
								vModel: 'createDateTime',
								label: this.$t('igate.connectorControl.create') + ' ' + this.$t('head.date'),
							},							
						],
						[
							{
								type: 'text',
								vModel: 'fileRemoteName',
								label: this.$t('head.file') + ' ' + this.$t('head.id'),
							},
							{
								type: 'text',
								vModel: 'filePath',
								label: this.$t('head.file') + ' ' + this.$t('head.path'),
							},		
							{
								type: 'text',
								vModel: 'fileLength',
								label: this.$t('head.file') + ' ' + this.$t('head.length'),
							},
							{
								type: 'text',
								vModel: 'fileOffset',
								label: this.$t('head.file') + ' ' + this.$t('head.offset'),
							},
							{
								type: 'text',
								vModel: 'fileStatus',
								label: this.$t('head.file') + ' ' + this.$t('head.status'),
								formatter : function(value)
				                {
				                  switch (value) {
					                  case 'R' : {
					                    return this.$t('igate.fileRepository.ready');
					                  }
					                  case 'W' : {
					                	  return this.$t('igate.fileRepository.wait');
					                  }
					                  case 'M' : {
					                	  return this.$t('igate.fileRepository.making');
					                  }
					                  case 'A' : {
					                	  return this.$t('igate.fileRepository.active');
					                  }
					                  case 'E' : {
					                	  return this.$t('igate.fileRepository.error');
					                  }
					                  case 'D' : {
					                	  return this.$t('igate.fileRepository.done');
					                  }
					                  case 'P' : {
					                	  return this.$t('igate.fileRepository.process');
					                  }
					                  case 'X' : {
					                	  return this.$t('igate.fileRepository.expire');
					                  }
					                  case 'C' : {
					                	  return this.$t('igate.fileRepository.cancel');
					                  }
					                  case 'H' : {
					                	  return this.$t('igate.fileRepository.finish');
					                  }
					                  case 'F' : {
					                	  return this.$t('igate.fileRepository.fail');
					                  }
				                  }
				                }.bind(this),
							},
							{
								type: 'text',
								vModel: 'instanceId',
								label: this.$t('igate.instance') + ' ' + this.$t('head.id'),
							},	
						],
					],					
				]
			}
		]
	}
	
};