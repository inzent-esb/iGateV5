<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/html/layout/header/common_head.jsp"%>
</head>
<body>
	<div id="user" data-ready>
		<sec:authorize var="hasUserViewer" access="hasRole('UserViewer')"></sec:authorize>
		<sec:authorize var="hasUserEditor" access="hasRole('UserEditor')"></sec:authorize>
		<sec:authorize var="hasAdministrator" access="hasRole('Administrator')"></sec:authorize>
			
		<%@ include file="/WEB-INF/html/layout/component/component_search.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_list.jsp"%>
		
		<%@ include file="/WEB-INF/html/layout/component/component_detail.jsp"%>
		
		<span id="userPrivilegesTemplate" style="display: none;">
			<div class="userPrivileges" style="width: 100%;">
				<div class="btn-group" role="group" style="margin-bottom: 10px" v-if="!isReadOnlyMode">
					<a class="btn admin" @click="allAdmin" style="font-size: 0.8rem; min-width: auto">
						<fmt:message>common.user.privilege.all</fmt:message> <fmt:message>common.user.privilege.admin</fmt:message>
					</a>
					<a class="btn member" @click="allMember" style="font-size: 0.8rem; min-width: auto">
						<fmt:message>common.user.privilege.all</fmt:message> <fmt:message>common.user.privilege.member</fmt:message>
					</a>
					<a class="btn none" @click="allNone" style="font-size: 0.8rem; min-width: auto">
						<fmt:message>common.user.privilege.all</fmt:message> <fmt:message>common.user.privilege.none</fmt:message>
					</a>
				</div>
				<table class="table">
					<colgroup>
						<col width="5%" />
						<col width="5%" />
						<col width="45%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><fmt:message>common.user.privilege.grade</fmt:message></th>
							<th scope="col"><fmt:message>common.privilege</fmt:message> <fmt:message>head.type</fmt:message></th>
							<th scope="col"><fmt:message>common.privilege</fmt:message></th>
						</tr>
					</thead>
					<tbody>
						<tr v-for="(elm, idx) in totalUserPrivileges" :key="idx">
							<td class="text-center view-disabled align-middle authGrade">
								<select :class="elm.classObj" v-model="elm.privilegeName" :readonly="isReadOnlyMode || elm.readonly" @change="changePrivilege(elm)">
									<option value="None">
										<fmt:message>common.user.privilege.none</fmt:message>
									</option>
									<option value="Admin">
										<fmt:message>common.user.privilege.admin</fmt:message>
									</option>
									<option value="Member">
										<fmt:message>common.user.privilege.member</fmt:message>
									</option>
								</select>
							</td>
							<td class="px-1">
								<input type="text" class="form-control view-disabled" disabled="disabled" :value="elm.privilegeType === isSystem? '<fmt:message>common.privilege.type.system</fmt:message>' : elm.privilegeType === isBusiness? '<fmt:message>common.privilege.type.business</fmt:message>' : '<fmt:message>common.role</fmt:message>'"/>
							</td>
							<td class="px-1"><input type="text" class="form-control view-disabled" v-model="elm.privilegeId" disabled="disabled" /></td>
						</tr>
					</tbody>
				</table>
			</div>		
		</span>
	</div>
	<script>
		document.querySelector('#user').addEventListener('ready', function(evt) {
			new HttpReq('/api/page/portal').read({ withPrivilege: true }, function (res) {
				var userInfo = res.object.user;
				var userId = userInfo.userId;
				var totalUserOnlyPrivileges = userInfo.totalUserPrivileges;
				
				var hasAdminPrivilege = 0 < totalUserOnlyPrivileges.filter(function(info) { return info.admin; }).length;
				
				new HttpReq('/api/entity/user/object').read({ userId: userId }, function (res) {
					var totalUserRolePrivileges = res.object.totalUserPrivileges;
					
					var viewer = 'true' == '${hasUserViewer}' || hasAdminPrivilege;
					var editor = 'true' == '${hasUserEditor}' || hasAdminPrivilege;
					var isUserAdmin = 'true' == '${hasAdministrator}';

					var createPageObj = getCreatePageObj();

					createPageObj.setViewName('user');
					createPageObj.setIsModal(false);

					createPageObj.setSearchList([
					    {
					        type: 'text',
					        mappingDataInfo: 'object.userId',
					        name: '<fmt:message>head.id</fmt:message>',
					        placeholder: '<fmt:message>head.searchId</fmt:message>',
					        regExpType: 'searchId'
					    },
					    {
					        type: 'text',
					        mappingDataInfo: 'object.userName',
					        name: '<fmt:message>head.name</fmt:message>',
					        placeholder: '<fmt:message>head.searchName</fmt:message>',
					    },
					    {
					        type: 'text',
					        mappingDataInfo: 'object.department',
					        name: '<fmt:message>common.user.department</fmt:message>',
					        placeholder: '<fmt:message>head.searchData</fmt:message>',
					    },
					    {
					        type: 'text',
					        mappingDataInfo: 'object.telephone',
					        name: '<fmt:message>common.user.telephone</fmt:message>',
					        placeholder: '<fmt:message>head.searchData</fmt:message>',
					    },
					    {
					        type: 'text',
					        mappingDataInfo: 'object.mobilephone',
					        name: '<fmt:message>common.user.mobilephone</fmt:message>',
					        placeholder: '<fmt:message>head.searchData</fmt:message>',
					    },
					    {
					        type: 'text',
					        mappingDataInfo: 'object.email',
					        name: '<fmt:message>common.user.email</fmt:message>',
					        placeholder: '<fmt:message>head.searchData</fmt:message>',
					    },			    
					]);

					createPageObj.searchConstructor();

					createPageObj.setMainButtonList({
					    newTabBtn: viewer,
					    searchInitBtn: viewer,
					    addBtn: editor,
					    totalCnt: viewer,
					    currentCnt: viewer,
					});

					createPageObj.mainConstructor();

					createPageObj.setTabList([
					    {
					        type: 'basic',
					        id: 'MainBasic',
					        name: '<fmt:message>head.basic.info</fmt:message>',
					        detailList: [
					            {
					                className: 'col-lg-6',
					                detailSubList: [
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.userId',
					                        name: '<fmt:message>head.id</fmt:message>',
					                        isPk: true,
					                        regExpType: 'id'
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.userName',
					                        name: '<fmt:message>head.name</fmt:message>',
					                        isRequired: true,
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.department',
					                        name: '<fmt:message>common.user.department</fmt:message>',
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.telephone',
					                        name: '<fmt:message>common.user.telephone</fmt:message>',
					                    },			                    
					                ]
					            },
					            {
					                className: 'col-lg-6',
					                detailSubList: [
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.mobilephone',
					                        name: '<fmt:message>common.user.mobilephone</fmt:message>',
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.email',
					                        name: '<fmt:message>common.user.email</fmt:message>',
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.updateTimestamp',
					                        name: '<fmt:message>head.update.timestamp</fmt:message>',
					                        disabled: true
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.updateUserId',
					                        name: '<fmt:message>head.update.userId</fmt:message>',
					                        disabled: true
					                    },			                    
					                ]
					            }			            
					        ]
					    },
					    {
					        type: 'basic',
					        id: 'Authentication',
					        name: '<fmt:message>common.user.authentication.info</fmt:message>',		
					        detailList: [
					        	{
					        		className: 'col-lg-6',
					        		detailSubList: [
					                    {
					                        type: 'select',
					                        name: '<fmt:message>common.user.disable</fmt:message>',
					                        mappingDataInfo: {
					                            id: 'disableYn',
					                            selectModel: 'object.userDisableYn',
					                            optionFor: 'option in ynList',
					                            optionValue: 'option.pk.propertyKey',
					                            optionText: 'option.propertyValue',
					                        }
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.loginIp',
					                        name: '<fmt:message>common.user.loginIp</fmt:message>',
					                        disabled: true
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.allowedIp',
					                        name: '<fmt:message>common.user.allowed.ip</fmt:message>',
					                    },		
					                    {
					                        type: 'password',
					                        mappingDataInfo: 'object.newPassword',
					                        name: '<fmt:message>common.user.newPassword</fmt:message>',			  
					                        isRequired: true,
					                        warning: '<fmt:message>common.user.validationPassCheck</fmt:message>',
					                        cryptType: 'cryptType' 
					                    }
					        		]
					        	},
					        	{
					        		className: 'col-lg-6',
					        		detailSubList: [
					                    {
					                        type: 'singleDaterange',
					                        name: '<fmt:message>common.user.passwordExpiration</fmt:message>',
					                        mappingDataInfo: {
					                            id: 'passwordExpiration',
					                        }
					                    },
					                    {
					                        type: 'singleDaterange',
					                        name: '<fmt:message>common.user.userExpiration</fmt:message>',
					                        mappingDataInfo: {
					                            id: 'userExpiration',
					                        }
					                    },
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.loginAttempts',
					                        name: '<fmt:message>common.user.loginAttempts</fmt:message>',
					                        regExpType: 'num'
					                    },		
					                    {
					                        type: 'text',
					                        mappingDataInfo: 'object.loginTimestamp',
					                        name: '<fmt:message>common.user.loginTimestamp</fmt:message>',
					                        disabled: true
					                    },			                    
					        		]
					        	}
					        ]
					    },
					    {
					        type: 'custom',
					        id: 'userDetailPrivileges',
					        name: '<fmt:message>common.user</fmt:message> ' + '<fmt:message>common.privilege</fmt:message> ' + '<fmt:message>head.info</fmt:message>',
					        getDetailArea: function() {
					        	return $('#user #userPrivilegesTemplate').clone().html();
					        }
					    }
					]);

					createPageObj.setPanelButtonList({
					    removeBtn: editor,
					    goModBtn: editor,
					    saveBtn: editor,
					    updateBtn: editor,
					    goAddBtn: editor
					});

					createPageObj.panelConstructor();

					SaveImngObj.setConfig({
					    objectUrl: '/api/entity/user/object'
					});					
					
					window.vmSearch = new Vue({
					    el: '#' + createPageObj.getElementId('ImngSearchObject'),
					    data: {
					        letter: {
					        	userId: 0,
					        	userName: 0,
					        	department: 0,
					        	telephone: 0,
					        	mobilephone: 0,
					        	email: 0
					        },
					        object: {
					        	userId: null,
					        	userName: null,
					        	department: null,
					        	telephone: null,
					        	mobilephone: null,
					        	email: null,
					            pageSize: 10,
					        }
					    },
					    methods: $.extend(true, {}, searchMethodOption, {
					        inputEvt: function (info) {
					            setLengthCnt.call(this, info);
					        },
					        search: function () {
					            vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));

					            vmList.makeGridObj.search(this.object, function(info) {
					            	vmList.currentCnt = info.currentCnt;
					            	vmList.totalCnt = info.totalCnt;
					            });
					        },
					        initSearchArea: function (searchCondition) {
					            if (searchCondition) {
					                for (var key in searchCondition) {
					                    this.$data[key] = searchCondition[key];
					                }
					            } else {
					                this.object.pageSize = 10;
					                
					                this.object.userId = null;
					                this.object.userName = null;
					                this.object.department = null;
					                this.object.telephone = null;
					                this.object.mobilephone = null;
					                this.object.email = null;             
					                
					                this.letter.userId = 0;
					                this.letter.userName = 0;
					                this.letter.department = 0;
					                this.letter.telephone = 0;
					                this.letter.mobilephone = 0;
					                this.letter.email = 0;    			                
					            }
					        },
					    }),
					    mounted: function () {
					        this.initSearchArea();
					    }
					});				
					
					var vmList = new Vue({
					    el: '#' + createPageObj.getElementId('ImngListObject'),
					    data: {
					        makeGridObj: null,
					        totalCnt: null,
					        currentCnt: null
					    },
					    methods: $.extend(true, {}, listMethodOption, {
					        initSearchArea: function () {
					            window.vmSearch.initSearchArea();
					        },
					    }),
					    mounted: function () {
					        this.makeGridObj = getMakeGridObj();

					        this.makeGridObj.setConfig({
					            el: document.querySelector('#' + createPageObj.getElementId('ImngSearchGrid')),
					            searchUrl: '/api/entity/user/search',
					            totalCntUrl: '/api/entity/user/count',
					    		paging: {
					    			isUse: true,
					    			side: "server",
					    			setCurrentCnt: function(currentCnt) {
					    				this.currentCnt = currentCnt
					    			}.bind(this)
					    		},
					            columns: [
									{
										header: '<fmt:message>head.id</fmt:message>',
										name: 'userId',
										width: '15%'
									},
									{
										header: '<fmt:message>head.name</fmt:message>',
										name: 'userName',
										width: '20%'
									},
									{
										header: '<fmt:message>common.user.department</fmt:message>',
										name: 'department',
										width: '15%'
									},
									{
										header: '<fmt:message>common.user.telephone</fmt:message>',
										name: 'telephone',
										width: '15%'
									},
									{
										header: '<fmt:message>common.user.mobilephone</fmt:message>',
										name: 'mobilephone',
										width: '15%'
									},
									{
										header: '<fmt:message>common.user.email</fmt:message>',
										name: 'email',
										width: '20%'
									}
					            ],
					            onGridMounted: function(evt) {
					            	evt.instance.on('click', function(evt) {
					            		SearchImngObj.clicked(evt.instance.getRow(evt.rowKey));
					            	});
					            }
					        });
					        
					        SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();

					        this.newTabSearchGrid();
					        
				            this.$nextTick(function () {
				                window.vmSearch.search();
				            });
					    }
					});
					
					window.vmMain = new Vue({
					    el: '#MainBasic',
					    data: {
					        viewMode: 'Open',
					        letter: {
					        	userId: 0,
					        	userName: 0,
					        	department: 0,
					        	telephone: 0,
					        	mobilephone: 0,
					        	email: 0,
					        	updateTimestamp: 0,
					        	updateUserId: 0,
					        },
					        object: {
					        	userId: null,
					        	userName: null,
					        	department: null,
					        	telephone: null,
					        	mobilephone: null,
					        	email: null,
					        	updateTimestamp: null,
					        	updateUserId: null,
								userDisableYn: 'N',
								loginIp: null,
								allowedIp: null,
								newPassword: null,
								loginAttempts: 0,
								loginTimestamp: null,
								totalUserPrivileges: [],
					        },
					        panelMode: null
					    },
					    watch: {
					    	panelMode: function() {
					    		vmAuthentication.object.newPassword = null;
					    		vmAuthentication.letter.newPassword = 0;
					    	}
					    },
					    methods: {
					        inputEvt: function (info) {
					            setLengthCnt.call(this, info);
					        },
					        goDetailPanel: function () {
					            panelOpen('detail', null, function() {
						        	//vmMain
						        	if (this.object.updateTimestamp) {
						        		this.object.updateTimestamp = changeDateFormat(this.object.updateTimestamp); 
						        	}
						        	
						        	for (var key in this.letter) {
						        		if ('undefined' === typeof this.object[key]) continue;
										this.letter[key] = String(this.object[key]).length;
						        	}

						        	//vmAuthentication
									for (var key in vmAuthentication.object) {
										vmAuthentication.object[key] = ('loginTimestamp' === key || 'passwordExpiration' === key || 'userExpiration' === key)? changeDateFormat(this.object[key]) : this.object[key];
									}
						        	
						        	for (var key in vmAuthentication.letter) {
						        		if ('undefined' === typeof vmAuthentication.object[key]) continue;
						        		vmAuthentication.letter[key] = String(vmAuthentication.object[key]).length;				        		
						        	}				    
	                                
			                        initDateDetailPicker(vmAuthentication, $('#panel').find('#Authentication').find('#passwordExpiration'), 'passwordExpiration');
			                        initDateDetailPicker(vmAuthentication, $('#panel').find('#Authentication').find('#userExpiration'), 'userExpiration');
	                                
						        	//vmTotalUserPrivilegeList
						        	vmTotalUserPrivilegeList.totalUserPrivileges = JSON.parse(JSON.stringify(this.object.totalUserPrivileges)).map(function(info) {
						        		info.privilegeName = 'None';
						        		return info;
						        	});
						        	
						        	vmTotalUserPrivilegeList.setTotalUserPrivileges();
						        	
						        	$('#userDetailPrivileges .userPrivileges .table tbody tr td').removeClass('view-disabled');
					            }.bind(this));
					        },
					        initDetailArea: function (object) {
					        	if (object) return;
							        	
					        	//vmMain
				            	this.object.userId = null;
				            	this.object.userName = null;
				            	this.object.department = null;
				            	this.object.telephone = null;
				            	this.object.mobilephone = null;
				            	this.object.email = null;
				            	this.object.updateTimestamp = null;
				            	this.object.updateUserId = null;
				            	
				            	this.letter.userId = 0;
				            	this.letter.userName = 0;
				            	this.letter.department = 0;
				            	this.letter.telephone = 0;
				            	this.letter.mobilephone = 0;
				            	this.letter.email = 0;
				            	this.letter.updateTimestamp = 0;
				            	this.letter.updateUserId = 0;
				            	
				            	//vmAuthentication
								vmAuthentication.object.userDisableYn = 'N';
								vmAuthentication.object.loginIp = null;
								vmAuthentication.object.allowedIp = null;
								vmAuthentication.object.newPassword = null;
								vmAuthentication.object.loginAttempts = 0;
								vmAuthentication.object.loginTimestamp = null;
								vmAuthentication.object.passwordExpiration = moment(new Date().setMonth(new Date().getMonth() + 3)).format('YYYY-MM-DD HH:mm:ss');
								vmAuthentication.object.userExpiration = moment(new Date().setMonth(new Date().getMonth() + 3)).format('YYYY-MM-DD HH:mm:ss');
								
					        	vmAuthentication.letter.loginIp = 0;
					        	vmAuthentication.letter.allowedIp = 0;
					        	vmAuthentication.letter.newPassword = 0;
					        	vmAuthentication.letter.loginAttempts = 0;
					        	vmAuthentication.letter.loginTimestamp = 0;
					        	
		                        initDateDetailPicker(vmAuthentication, $('#panel').find('#Authentication').find('#passwordExpiration'), 'passwordExpiration');
		                        initDateDetailPicker(vmAuthentication, $('#panel').find('#Authentication').find('#userExpiration'), 'userExpiration');
					        	
					        	//vmTotalUserPrivilegeList
					        	vmTotalUserPrivilegeList.totalUserPrivileges = JSON.parse(JSON.stringify(totalUserRolePrivileges)).map(function(info) {
					        		info.privilegeName = 'None';
					        		return info;
					        	});
					        	
					        	vmTotalUserPrivilegeList.setTotalUserPrivileges();
					        },
					        saving: function() {
					        	//vmAuthentication
					        	for (var key in vmAuthentication.object) {
					        		this.object[key] = vmAuthentication.object[key];
					        	}
					        	
					        	if (this.object.newPassword) {
					        		this.object.newPassword = encryptPassword(this.object.newPassword);
					        	}
					        	
					        	//vmAuthentication
					        	this.object.totalUserPrivileges = JSON.parse(JSON.stringify(vmTotalUserPrivilegeList.totalUserPrivileges)).map(function(info) {
					        		delete info.classObj;
					        		
									if ('None' === info.privilegeName) {
										info.admin = false;
										info.member = false;
									} else if ('Member' === info.privilegeName) {
										info.admin = false;
										info.member = true;
									} else {
										info.admin = true;
										info.member = false;
									}
									
					        		return info;
					        	});
					        }
					    }
					});
					
					var vmAuthentication = new Vue({
						el: '#Authentication',
						data: {
					        letter: {
					        	loginIp: 0,
					        	allowedIp: 0,
					        	newPassword: 0,
					        	loginAttempts: 0,
					        	loginTimestamp: 0,
					        },					
							object: {
								userDisableYn: 'N',
								loginIp: null,
								allowedIp: null,
								newPassword: null,
								loginAttempts: 0,
								loginTimestamp: null,
								passwordExpiration: null,
								userExpiration: null,
							},
							ynList: [],
							cryptType: 'password'
						},
						created: function() {
							new HttpReq('/api/page/properties').read({ pk : { propertyId: 'List.Yn' }, orderByKey: true }, function (result) {
								this.ynList = result.object;
							}.bind(this));					
						},
						methods: {
					        inputEvt: function (info) {
					            setLengthCnt.call(this, info);
					        }
						}
					});
					
					var vmTotalUserPrivilegeList = new Vue({
						el: '#userDetailPrivileges',
						data: {
							totalUserPrivileges: [],
							isSystem: 'S',
							isBusiness: 'b'
						},
						computed: {
							isReadOnlyMode: function() {
								return 'detail' === window.vmMain.panelMode || 'done' === window.vmMain.panelMode;
							}
						},
						methods: {
							setTotalUserPrivileges: function() {
								if (!this.totalUserPrivileges) return;
								
								if ('add' === window.vmMain.panelMode) {
									this.totalUserPrivileges.forEach(function(info) {
										info.admin = false;
										info.member = false;
										info.privilegeName = 'None';
										info.readonly = this.getAuthFix(info);
										info.classObj = { 'form-control': true, 'view-disabled': true };
										info.classObj[info.privilegeName.toLowerCase()] = true;
									}.bind(this));
								} else {
									this.totalUserPrivileges.forEach(function(info) {
										info.privilegeName = info.admin ? 'Admin' : info.member ? 'Member' : 'None';
										info.readonly = this.getAuthFix(info);
										info.classObj = { 'form-control': true, 'view-disabled': true };
										info.classObj[info.privilegeName.toLowerCase()] = true;
									}.bind(this));
								}		
							},
							getAuthFix: function(authInfo) {
								if (isUserAdmin) {
									return false;
								} else if (
									totalUserOnlyPrivileges.find(function(userPrivilege) {
										return 'UserEditor' === userPrivilege.privilegeId && 'undefined' === typeof userPrivilege.onlyFrontPrivilege;
									})
								) {
									return false;
								} else {
									var isFix = totalUserOnlyPrivileges.find(function(totalUserPrivilege) {
										var roleType = totalUserPrivilege.roleType;
										var privilegeId = totalUserPrivilege.privilegeId;
										var admin = totalUserPrivilege.admin;
										
										return (authInfo.role ? 'R' : 'p') === roleType && privilegeId === authInfo.privilegeId && admin
									});

									return isFix ? false : true;
								}
							},					
							allAdmin: function() {
								this.totalUserPrivileges.forEach(function(info) {
									if (this.getAuthFix(info)) return;
									
									info.privilegeName = 'Admin';
									
									info.classObj = { 'form-control': true, 'view-disabled': true };
									info.classObj[info.privilegeName.toLowerCase()] = true;
								}.bind(this));
							},
							allMember: function() {
								this.totalUserPrivileges.forEach(function(info) {
									if (this.getAuthFix(info)) return;
									
									info.privilegeName = 'Member';
									
									info.classObj = { 'form-control': true, 'view-disabled': true };
									info.classObj[info.privilegeName.toLowerCase()] = true;
								}.bind(this));
							},
							allNone: function() {
								this.totalUserPrivileges.forEach(function(info) {
									if (this.getAuthFix(info)) return;
									
									info.privilegeName = 'None';
									
									info.classObj = { 'form-control': true, 'view-disabled': true };
									info.classObj[info.privilegeName.toLowerCase()] = true;
								}.bind(this));
							},	
							changePrivilege: function(info) {
								info.classObj = { 'form-control': true, 'view-disabled': true };
								info.classObj[info.privilegeName.toLowerCase()] = true;
							}
						}
					});	
					
					new Vue({
					    el: '#panel-header',
					    methods: $.extend(true, {}, panelMethodOption)
					});

					new Vue({
					    el: '#panel-footer',
					    methods: $.extend(true, {}, panelMethodOption)
					});					
				});
			});

			this.addEventListener('destroy', function (evt) {
			    $('.daterangepicker').remove();
			    $('.ui-datepicker').remove();
			    $('.backdrop').remove();
			    $('.modal').remove();
			    $('.modal-backdrop').remove();
			    $('#ct').find('script').remove();
			});
			
			function initDateDetailPicker(vueObj, selector, dataKey) {
			    selector.customDatePicker(
			    	function(time) {
						vueObj.object[dataKey] = time;
					}, 
					{
						timePicker: true, 
						timePicker24Hour: true,
						timePickerSeconds: true,
						format : 'YYYY-MM-DD HH:mm:ss',
						localeFormat : 'YYYY-MM-DD HH:mm:ss',
						showDropdowns: true,
						drops: 'auto',
						autoUpdateInput: true,
						startDate: vueObj.object[dataKey]
					}
				);
			}				
		});	
	</script>
</body>
</html>