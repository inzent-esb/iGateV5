<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function() {
	var isDisabled = true;
	var btnFlag = true;
	
	if('Open' === '${viewMode}' && '' === '${string}') {
		isDisabled = false;
	}else if ('Open' === '${viewMode}' && 'ADM' === '${string}') {
		isDisabled = true;
	}
	else if ('View' === '${viewMode}') {
	    btnFlag = false;
	}
	
	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('user');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text",  'mappingDataInfo': "object.userId",   'name': "<fmt:message>common.user</fmt:message> <fmt:message>head.id</fmt:message>",    'placeholder': "<fmt:message>head.searchId</fmt:message>"},
		{'type': "text",  'mappingDataInfo': "object.userName", 'name': "<fmt:message>common.user</fmt:message> <fmt:message>head.name</fmt:message>",  'placeholder': "<fmt:message>head.searchName</fmt:message>"},		
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		totalCount: true,
		addBtn: btnFlag,
	});
	
	createPageObj.mainConstructor();
	
	createPageObj.setTabList([
		{
			'type': 'basic',
			'id': 'MainBasic',
			'name': '<fmt:message>head.basic.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.userId", 'name': "<fmt:message>common.user</fmt:message> <fmt:message>head.id</fmt:message>", isPk: true}, 
						{'type': "text", 'mappingDataInfo': "object.userName", 'name': "<fmt:message>common.user</fmt:message> <fmt:message>head.name</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': "object.department", 'name': "<fmt:message>common.user.department</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': "object.telephone", 'name': "<fmt:message>common.user.telephone</fmt:message>", 'disabled' : isDisabled},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.mobilephone", 'name': "<fmt:message>common.user.mobilephone</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': "object.email", 'name': "<fmt:message>common.user.email</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': "object.updateTimestamp", 'name': "<fmt:message>head.update.timestamp</fmt:message>",'disabled' : true},
						{'type': "text", 'mappingDataInfo': "object.updateUserId", 'name': "<fmt:message>head.update.userId</fmt:message>",'disabled' : true},
					]
				},					
			]
		},
		{
			'type': 'basic',
			'id': 'Authentication',
			'name': '<fmt:message>common.user.authentication.info</fmt:message>',
			'detailList': [
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.userDisableYn', 'optionFor': 'option in disableYns', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue'}, 'name': "<fmt:message>common.user.disable</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': 'object.loginIp', 'name': "<fmt:message>common.user.loginIp</fmt:message>",'disabled' : true},
						{'type': "password", 'mappingDataInfo': 'object.password', 'name': "<fmt:message>common.user.newPassword</fmt:message>", 'cryptType': 'cryptType','disabled' : isDisabled},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "singleDaterange", 'mappingDataInfo': {'vModel' : 'object.passwordExpiration', 'id': 'passwordExpiration', 'dataDrops': 'up'}, 'name': "<fmt:message>common.user.passwordExpiration</fmt:message>" ,'disabled' : isDisabled},
						{'type': "singleDaterange", 'mappingDataInfo': {'vModel' : 'object.userExpiration', 'id': 'userExpiration', 'dataDrops': 'up'}, 'name': "<fmt:message>common.user.userExpiration</fmt:message>" ,'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': 'object.loginAttempts', 'name': "<fmt:message>common.user.loginAttempts</fmt:message>", 'disabled' : isDisabled},
						{'type': "text", 'mappingDataInfo': 'object.loginTimestamp', 'name': "<fmt:message>common.user.loginTimestamp</fmt:message>",'disabled' : true},
					]
				},					
			]
		},
		{
			'type': 'custom',
			'id': 'TotalUserPrivileges',
			'name': '<fmt:message>common.user</fmt:message> <fmt:message>common.privilege</fmt:message> <fmt:message>head.info</fmt:message>',
			'getDetailArea': function() {
				
				var detailHtml = '';
				
				detailHtml += '<table class="table">';
				detailHtml += '    <colgroup>';
				detailHtml += '        <col span="2" style="width: 1%">';
				detailHtml += '        <col style="width: 17%">';
				detailHtml += '        <col>';
				detailHtml += '    </colgroup>';
				detailHtml += '    <thead>';
				detailHtml += '        <tr>';
				detailHtml += '		       <th scope="col" style="text-align: center;"><fmt:message>head.admin</fmt:message>';
				detailHtml += '	 		   		 <label class="custom-control custom-checkbox single view-disabled">';
				detailHtml += '				     	<input type="checkbox" class="custom-control-input" v-on:click="allAdmin();" :disabled="${'ADM' == string}">';
				detailHtml += '				     	<span class="custom-control-label"></span>';
				detailHtml += '			    	 </label>';
				detailHtml += '		       </th>'
				detailHtml += '			   <th scope="col" style="text-align: center;"><fmt:message>common.user.privilege.member</fmt:message>'
				detailHtml += '	 		   		 <label class="custom-control custom-checkbox single view-disabled">';
				detailHtml += '				     	<input type="checkbox" class="custom-control-input" v-on:click="allMember();" :disabled="${'ADM' == string}">';
				detailHtml += '				     	<span class="custom-control-label"></span>';
				detailHtml += '			    	 </label>';
				detailHtml += '		       </th>';
				detailHtml += '			   <th scope="col"><fmt:message>common.privilege</fmt:message> <fmt:message>head.type</fmt:message></th>';
				detailHtml += '			   <th scope="col"><fmt:message>common.privilege</fmt:message></th>';
				detailHtml += '		   </tr>';
				detailHtml += '	   </thead>';
				detailHtml += '	   <tbody>';
				detailHtml += '	       <tr v-for="elm in totalUserPrivileges">';
				detailHtml += '			 <td class="text-center view-disabled align-middle">';
				detailHtml += '			     <label class="custom-control custom-checkbox single">';
				detailHtml += '				     <input type="checkbox" class="custom-control-input" v-model="elm.admin" v-checked="elm.admin" :disabled="elm.readOnly">';
				detailHtml += '				     <span class="custom-control-label"></span>';
				detailHtml += '			     </label>';
				detailHtml += '			 </td>';
				detailHtml += '			 <td class="text-center view-disabled align-middle">';
				detailHtml += '		         <label class="custom-control custom-checkbox single">';
				detailHtml += '                  <input type="checkbox" class="custom-control-input" v-model="elm.member" v-checked="elm.member" :disabled="elm.readOnly">';
				detailHtml += '					 <span class="custom-control-label"></span>';
				detailHtml += '				 </label>';
				detailHtml += '			 </td>';
				detailHtml += '			 <td class="px-1" v-if="elm.privilegeType===isSystem"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.privilege.type.system</fmt:message>></td>';
				detailHtml += '			 <td class="px-1" v-if="elm.privilegeType===isBusiness"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.privilege.type.business</fmt:message>></td>';
				detailHtml += '			 <td class="px-1" v-if="elm.privilegeType!==isSystem && elm.privilegeType!==isBusiness"><input type="text" class="form-control view-disabled" disabled="disabled" value=<fmt:message>common.role</fmt:message>></td>';
				detailHtml += '			 <td class="px-1"><input type="text" class="form-control view-disabled" v-model="elm.privilegeId" disabled="disabled"></td>';
				detailHtml += '		  </tr>';
				detailHtml += '	   </tbody>';
				detailHtml += '</table>';
				
				return detailHtml;
			}
		},		
	]);	
	
	createPageObj.setPanelButtonList({
		removeBtn: btnFlag,
		goModBtn: btnFlag,
		saveBtn: btnFlag,
		updateBtn: btnFlag,
		goAddBtn: btnFlag,
	});
	
	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/common/user/edit.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {}
    	},
    	methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				
				
				$.ajax({
					type : "GET",
					url : "<c:url value='/common/user/clear.json' />",
			        processData : false,
			        success : function(result) {
			        	vmList.makeGridObj.search(this, function() {
			                $.ajax({
			                    type : "GET",
			                    url : "<c:url value='/common/user/rowCount.json' />",
			                    data: JsonImngObj.serialize(this.object), 
			                    processData : false,
			                    success : function(result) {
			                    	vmList.totalCount = result.object;
			                    }
			                });
			            }.bind(this));
			        }.bind(this),
			        error : function(request, status, error) {

			        }
				});
			},
            initSearchArea: function(searchCondition) {
            	if(searchCondition) {
            		for(var key in searchCondition) {
            		    this.$data[key] = searchCondition[key];
            		}
            	}else {
                	this.pageSize = '10';
            		this.object.userId = null;
            		this.object.userName = null;            		
            	}
            	
        		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
            }    		
    	},
    	mounted: function() {
    		initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
    	}
    });
    
    var vmList = new Vue({
        el: '#' + createPageObj.getElementId('ImngListObject'),
        data: {
        	makeGridObj: null,
            totalCount: '0',
        	newTabPageUrl: "<c:url value='/common/user.html' />"
        },        
        methods : $.extend(true, {}, listMethodOption, {
           	goSavePanel: function() {
           		panelOpen('add', null, function() {
           		    $.ajax({
           		    	type: "GET",
           		    	url: SaveImngObj.objectUri,
           		    	processData: false,
           		    	dataType: "json",
           		    	success: function(result) {
           		    		window.vmTotalUserPrivileges.totalUserPrivileges = result.object.totalUserPrivileges;
           		    	}
           		    });
           		});
           	},        	
        	initSearchArea: function() {
        		window.vmSearch.initSearchArea();
        	}
        }),
        mounted: function() {
        	
        	this.makeGridObj = getMakeGridObj();
        	
        	this.makeGridObj.setConfig({
        		elementId: createPageObj.getElementId('ImngSearchGrid'),
        		onClick: SearchImngObj.clicked,
        		searchUri : "<c:url value='/common/user/search.json' />",
              	viewMode : "${viewMode}",
              	popupResponse : "${popupResponse}",
              	popupResponsePosition : "${popupResponsePosition}",
              	columns : [
              		{
        	      		name : "userId",
              			header : "<fmt:message>common.user</fmt:message> <fmt:message>head.id</fmt:message>",
              			align : "left",
                        width: "30%",
              		}, 
              		{
              			name : "userName",
              			header : "<fmt:message>common.user</fmt:message> <fmt:message>head.name</fmt:message>",
              			align : "left",
                        width: "40%",
              		}, 
              		{
              			name : "department",
              			header : "<fmt:message>common.user.department</fmt:message>",
              			align : "left",
                        width: "30%",
              		}
              	]        	    
        	});
        	
        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
        	
        	this.newTabSearchGrid();
        }        
    });	
    
    window.vmMain = new Vue({
    	el : '#MainBasic',
        data : {
        	viewMode : 'Open',
        	object : {
        		totalUserPrivileges : [],
        	},
    		panelMode : null
        },
        computed : {
        	pk : function() {
        		return {
        			userId : this.object.userId
        		};
        	}
        },
        methods : {
			goDetailPanel: function() {
				window.vmAuthentication.cryptType = 'password';
				panelOpen('detail');
			},
        	loaded : function() {
        		window.vmAuthentication.object = this.object;
        		window.vmTotalUserPrivileges.object = this.object;
        	},
        	saving: function() {
        		for(var key in window.vmAuthentication.object) {
        			this.object[key] = window.vmAuthentication.object[key];
        		}
        		
        		this.object.passwordNew = encryptPassword(window.vmAuthentication.object.password);
        		window.vmAuthentication.object.password = null;
        	},
        	initDetailArea: function(object) {
        		
        		if(object) {
        			this.object = object;
        		}else{
    				this.object.userName = null;
    				this.object.department = null;
    				this.object.telephone = null;
    				this.object.mobilephone = null;
    				this.object.email = null;
    				this.object.updateTimestamp = null;
    				this.object.updateUserId = null;
    				this.object.userDisableYn = null;
    				this.object.userExpiration = null;
    				this.object.passwordNew = null;
    				this.object.passwordExpiration = null;
    				this.object.loginIp = null;
    				this.object.loginAttempts = null;
    				this.object.loginTimestamp = null;
    				this.object.totalUserPrivileges = null;
    				this.object.userId = null;
    				
    				window.vmAuthentication.object.userDisableYn = null;
					window.vmAuthentication.object.userExpiration = null;
					window.vmAuthentication.object.passwordNew = null;
					window.vmAuthentication.object.passwordExpiration = null;
					window.vmAuthentication.object.loginIp = null;
					window.vmAuthentication.object.loginAttempts = null;
					window.vmAuthentication.object.loginTimestamp = null;
					
    				window.vmTotalUserPrivileges.totalUserPrivileges = [];
        		}
        		
        		window.vmAuthentication.cryptType = 'password';
			}    		
        },
        watch: {
        	panelMode: function() {
        		window.vmAuthentication.cryptType = 'password';
        	}
        }
    });
    
    window.vmAuthentication = new Vue({
    	el : '#Authentication',
    	data : {
    		viewMode : 'Open',
    		object : {
				userDisableYn : null,
				userExpiration : null,
				password : null,
				passwordExpiration : null,
				loginIp : null,
				loginAttempts : null,
				loginTimestamp : null
    		},
    		pwdCheck : true,
    		disableYns: [],
    		cryptType: 'password',
    	},
    	created : function() {
        	PropertyImngObj.getProperties('List.Yn', true, function(properties) {
        		this.disableYns = properties;
        	}.bind(this));
    	},
    	mounted: function() {
    		
    		<%-- userExpiration --%>
    		$('#panel').find('#Authentication').find('#userExpiration').daterangepicker({
    			singleDatePicker: true,
    			timePicker: true,
    			timePicker24Hour: true,
    			timePickerSeconds: true,
    			autoApply: true,
    			autoUpdateInput: false,
    			locale: {
    				format: "YYYY.MM.DD HH:mm:ss",
    				separator: " ~ ",
    				daysOfWeek: [weekSunday,weekMonday,weekThesday,weekWednesday, weekThurday,weekFriday,weekSaturday],
    		        monthNames: [monthJanuary,monthFebruary,monthMarch,monthApril,monthMay,monthJune,monthJuly,monthAugust,monthSeptember,monthOctober,monthNovember, monthDecember],
    			},
    			drops: $(this).attr('data-drops')
    		});
    		
    		$('#panel').find('#Authentication').find('#userExpiration').on('hide.daterangepicker', function(ev, picker) {
    			this.object.userExpiration = picker.startDate.format('YYYY-MM-DD HH:mm:ss');
    			$('#panel').find('#Authentication').find('#userExpiration').val(picker.startDate.format('YYYY-MM-DD HH:mm:ss'));
    		}.bind(this));
    		
    		<%-- passwordExpiration --%>
    		$('#panel').find('#Authentication').find('#passwordExpiration').daterangepicker({
    			singleDatePicker: true,
    			timePicker: true,
    			timePicker24Hour: true,
    			timePickerSeconds: true,
    			autoApply: true,
    			autoUpdateInput: false,
    			locale: {
    				format: "YYYY.MM.DD HH:mm:ss",
    				separator: " ~ ",
    				daysOfWeek: [weekSunday,weekMonday,weekThesday,weekWednesday, weekThurday,weekFriday,weekSaturday],
    		        monthNames: [monthJanuary,monthFebruary,monthMarch,monthApril,monthMay,monthJune,monthJuly,monthAugust,monthSeptember,monthOctober,monthNovember, monthDecember],
    			},
    			drops: $(this).attr('data-drops')
    		});
    		
    		$('#panel').find('#Authentication').find('#passwordExpiration').on('hide.daterangepicker', function(ev, picker) {
    			this.object.passwordExpiration = picker.startDate.format('YYYY-MM-DD HH:mm:ss');
    			$('#panel').find('#Authentication').find('#passwordExpiration').val(picker.startDate.format('YYYY-MM-DD HH:mm:ss'));
    		}.bind(this));    		
    	}
    });

    window.vmTotalUserPrivileges = new Vue({
    	el : '#TotalUserPrivileges',
    	data : {
    		viewMode : 'Open',
    		totalUserPrivileges : [],
    		defaultAdmin : false,
    		defaultMember : false,
    		isSystem : 'S',
    		isBusiness : 'b'
    	},
    	methods : {
    		allAdmin : function() {

    			var i = 0;
            
    			if (!this.defaultAdmin) {
              
    				while (this.totalUserPrivileges[i] != null) {
    					this.totalUserPrivileges[i].admin = true;
    					i++;
    				}
    				
    				this.defaultAdmin = true;
    			}else{
              
    				while (this.totalUserPrivileges[i] != null) {
    					this.totalUserPrivileges[i].admin = false;
    					i++;
    				}
    				this.defaultAdmin = false;
    			}
    		},
    		allMember : function() {
            
    			var j = 0;
            
    			if (!this.defaultMember) {
    				while (this.totalUserPrivileges[j] != null) {
    					this.totalUserPrivileges[j].member = true;
    					j++;
    				}

    				this.defaultMember = true;
    			}else{
    				while (this.totalUserPrivileges[j] != null){
    					this.totalUserPrivileges[j].member = false;
    					j++;
    				}

    				this.defaultMember = false;
    			}
    		},
    	}
    });
	
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption, {
			setInfo: function(_method) {
				var vmMain = window.vmMain;
			    var object = vmMain.object;
			    
			    for(var key in object) {
			    	var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1);
			    	if (window.hasOwnProperty(name))
			    		object[key] = window[name][key];
			    }

			    vmMain.saving();
			    
			    object._method = _method;

			    var message = 'PUT' == _method? '<fmt:message>head.insert.notice</fmt:message>' : '<fmt:message>head.update.notice</fmt:message>';
			    		
			    SaveImngObj.submit(SaveImngObj.objectUri, JsonImngObj.serialize(object), message, function(result) {
			    	startSpinner();
	                
	                $.ajax({
	                   type : "GET",
	                   url : SaveImngObj.objectUri,
	                   processData : false,
	                   data : $.param({userId: window.vmMain.object.userId}),
	                   dataType : "json",
	                   complete: function() {
	                      stopSpinner();
	                   }
	                })
			    });				
			},
			saveInfo: function() {
				this.setInfo('PUT');
			},
			updateInfo: function() {
				this.setInfo('POST');
			}
		})
	});
});
</script>
</html>