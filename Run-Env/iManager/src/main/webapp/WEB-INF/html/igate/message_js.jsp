<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('message');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.messageCategory",
  				'optionFor': 'option in messageCategories',
  				'optionValue': 'option.pk.propertyKey',
  				'optionText': 'option.propertyValue',
  				'id': 'messageCategories'
  			},				
			'name': "<fmt:message>igate.message.category</fmt:message>", 
			'placeholder': "<fmt:message>head.all</fmt:message>"
		},
		{
			'type': "select", 
  			'mappingDataInfo': {
  				'selectModel': "object.pk.messageLocale",
  				'optionFor': 'option in messageLocales',
  				'optionValue': 'option',
  				'optionText': 'option',
  				'id': 'messageLocales'
  			},
			'name': "<fmt:message>igate.message.locale</fmt:message>",
			'placeholder': "<fmt:message>head.all</fmt:message>"
    	},
    	{'type': "text", 'mappingDataInfo': "object.pk.messageCode", 'name': "<fmt:message>igate.message.code</fmt:message>", 'placeholder': "<fmt:message>head.searchCode</fmt:message>"},
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		addBtn: hasMessageEditor,
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
						{'type': "datalist", 'mappingDataInfo': {'dataListId': 'messageLocale', 'vModel': 'object.pk.messageLocale', 'dataListFor': 'et in messageLocales', 'dataListText': 'et'}, 'name': "<fmt:message>igate.message.locale</fmt:message>", isPk: true},
						{'type': "select", 'mappingDataInfo': {'selectModel': 'object.messageCategory', 'optionFor': 'option in messageCategories', 'optionValue': 'option.pk.propertyKey', 'optionText': 'option.propertyValue' }, 'name': "<fmt:message>igate.message.category</fmt:message>"},
					]
				},
				{
					'className': 'col-lg-6',
					'detailSubList': [
						{'type': "text", 'mappingDataInfo': "object.pk.messageCode", 'name': "<fmt:message>igate.message.code</fmt:message>", isPk: true},
						{'type': "text", 'mappingDataInfo': "object.messageFormat", 'name': "<fmt:message>igate.message.format</fmt:message>"},
					]
				},
			]
		}		
	]);
	
	createPageObj.setPanelButtonList({
		removeBtn: hasMessageEditor,
		goModBtn: hasMessageEditor,
		saveBtn: hasMessageEditor,
		updateBtn: hasMessageEditor,
		goAddBtn: hasMessageEditor,
	});
	
	createPageObj.panelConstructor();
	
	SaveImngObj.setConfig({
		objectUri : "<c:url value='/igate/message/object.json' />",
	});		
	
    window.vmMain = new Vue({
    	el : '#MainBasic',
    	data : {
    		viewMode : 'Open',
    		object : {
    			pk : {}
    		},
    		messageCategories : [],
    		messageLocales : [],
    		panelMode : null
    	},
    	computed : {
    		pk : function() { 
    			return{
    				"pk.messageCode" : this.object.pk.messageCode,
    				"pk.messageLocale" : this.object.pk.messageLocale
    			} ;
    		}
    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object=object;
        			this.object.pk.messageCode = this.object.pk.messageCode.replace(/[1-9]/g, '')  +  (Number(this.object.pk.messageCode.replace(/[^0-9]/g, '')) + 1);
        		}else {
    				this.object.messageCategory = null;
    				this.object.messageFormat = null;
        			this.object.pk.messageLocale = null;
    				this.object.pk.messageCode = null;
        		}	
			}
        },    	
    }) ;
    
	new Vue({
		el: '#panel-footer',
		methods : $.extend(true, {}, panelMethodOption)
	});    
	
	PropertyImngObj.getProperties('List.Message.MessageCategory', true, function(messageCategories) {
		
		$.getJSON("<c:url value='/igate/message/groups.json' />", function(data) {
			
			window.vmSearch = new Vue({
				el : '#' + createPageObj.getElementId('ImngSearchObject'),
				data : {
					pageSize : '10',
					en : ' ',
					ko : ' ',
				    object : {
				    	pk : {
				    		messageCode : ''
				    	},
				    	messageCategory : ' ',
				    	messageLocale : ' '
				    },
				    uri : "<c:url value='/igate/message/groups.json' />",
				    messageCategories : [],
				    messageLocales : []
				},
				methods : {
					search : function() {
						if('none' != $('#' + createPageObj.getElementId('ImngListObject')).next('.empty').css('display')) {
							$('#' + createPageObj.getElementId('ImngListObject')).show();
							$('#' + createPageObj.getElementId('ImngListObject')).next('.empty').hide();					
						}
						
						vmList.makeGridObj.search(this);
					},
					initSearchArea: function(searchCondition) {
						if(searchCondition) {
							for(var key in searchCondition) {
							    this.$data[key] = searchCondition[key];
							}
						}else {
							this.pageSize = '10';
					    	this.object.pk.messageCode = null;
							this.object.messageCategory = ' ';
					    	this.object.pk.messageLocale = ' ';							
						}
				    	
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#pageSize'), this.pageSize);
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#messageCategories'), this.object.messageCategory);
						initSelectPicker($('#' + createPageObj.getElementId('ImngSearchObject')).find('#messageLocales'),  this.object.pk.messageLocale);				    	
					}					
				},
				mounted: function(){
					this.initSearchArea();
				},
				created: function() {
					this.messageCategories = messageCategories;
					this.messageLocales = data.object;
					
					window.vmMain.messageCategories = messageCategories;
					window.vmMain.messageLocales = data.object;
				}
			});
			
			var vmList = new Vue({
		        el: '#' + createPageObj.getElementId('ImngListObject'),
		        data: {
		        	makeGridObj: null,
		        	newTabPageUrl: "<c:url value='/igate/message.html' />"
		        },
		        methods : $.extend(true, {}, listMethodOption, {
		        	initSearchArea: function() {
		        		window.vmSearch.initSearchArea();
		        	}
		        }),
		        mounted: function() {
		        	
		        	this.makeGridObj = getMakeGridObj();
		        	
		        	this.makeGridObj.setConfig({
		        		elementId: createPageObj.getElementId('ImngSearchGrid'),
		        		onClick: SearchImngObj.clicked,
		        		searchUri : "<c:url value='/igate/message/search.json' />",
		                viewMode : "${viewMode}",
		                popupResponse : "${popupResponse}",
		                popupResponsePosition : "${popupResponsePosition}",
		                columns : [
		                	{
		                  		name : "messageCategory",
		                  		header : "<fmt:message>igate.message.category</fmt:message>",
		                  		align : "center",
		                        width: "25%",
		                	},
		                	{
		                  		name : "pk.messageLocale",
		                  		header : "<fmt:message>igate.message.locale</fmt:message>",
		                  		align : "center",
		                        width: "15%",
		                	},
		                	{
		                  		name : "pk.messageCode",
		                  		header : "<fmt:message>igate.message.code</fmt:message>",
		                  		align : "left",
		                        width: "30%",
		                	},
		                	{
		                  		name : "messageFormat",
		                  		header : "<fmt:message>igate.message.format</fmt:message>",
		                  		align : "left",
		                        width: "30%",
		                	}
		                ]		        	    
		        	});
		        	
		        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
		        	
		        	this.newTabSearchGrid();
		        }		        
		    });			
		});
	});
});
</script>