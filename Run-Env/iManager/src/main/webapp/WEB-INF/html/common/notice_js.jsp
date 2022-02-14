<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">

$(document).ready(function(){

	var createPageObj = getCreatePageObj();
	
	createPageObj.setViewName('notice');
	createPageObj.setIsModal(false);
	
	createPageObj.setSearchList([
		{'type': "text", 'mappingDataInfo': "object.noticeTitle",    'name': "<fmt:message>igate.notice.title</fmt:message>",     'placeholder': "<fmt:message>igate.notice.enter.title</fmt:message>"}
	]);
	
	createPageObj.searchConstructor();
	
	createPageObj.setMainButtonList({
		newTabBtn: 'b' == '<c:out value="${_client_mode}" />',
		searchInitBtn: true,
		totalCount: true,
		addBtn: hasNoticeEditor,
	});
	
	createPageObj.mainConstructor();
	
	createPageObj.setTabList([
 		{
			'type': 'custom',
			'id': 'MainBasic',
			'name': '<fmt:message>head.basic.info</fmt:message>',
			'isSubResponsive' : true,
			'getDetailArea': function() {
				var rtnHtml = '';
				
				rtnHtml += '<span style="width: 100%;">';
				rtnHtml += '	<div class="col-lg-12" style="height: 100%;">';
				rtnHtml += '		<div class="form-group">';
				rtnHtml += '			<label class="control-label"><span><fmt:message>igate.notice.title</fmt:message></span></label>';
				rtnHtml += '			<div class="input-group">';
				rtnHtml += '				<input type="text" class="form-control view-disabled" v-model="object.noticeTitle" maxlength="50">';
				rtnHtml += '			</div>';
				rtnHtml += '		</div>';
				rtnHtml += '		<div class="form-group" style="height: calc(100% - 72px);">';
				rtnHtml += '			<label class="control-label"><span><fmt:message>igate.notice.contents</fmt:message></span></label>';
				rtnHtml += '			<div class="input-group" style="height: calc(100% - 24px);">';
				rtnHtml += '				<textarea class="form-control view-disabled" v-model="object.noticeContent" style="height: 100%; min-height: 207px;" maxlength="1000"></textarea>';
				rtnHtml += '			</div>';
				rtnHtml += '		</div>';
				rtnHtml += '	</div>';
				rtnHtml += '</span>';			
				
				return rtnHtml;	
			}
		},
	]);
	
	createPageObj.setPanelButtonList({
		removeBtn: hasNoticeEditor,
		goModBtn: hasNoticeEditor,
		saveBtn: hasNoticeEditor,
		updateBtn: hasNoticeEditor,
	});
	
	createPageObj.panelConstructor();
	
    SaveImngObj.setConfig({
    	objectUri : "<c:url value='/common/notice/object.json' />"
    });

    ControlImngObj.setConfig({
    	controlUri : "<c:url value='/common/notice/control.json' />"
    });

    window.vmSearch = new Vue({
    	el : '#' + createPageObj.getElementId('ImngSearchObject'),
    	data : {
    		pageSize : '10',
    		object : {
       			noticeTitle: null,
       			noticeContent: null    				
    		}
    	},
    	methods : {
			search : function() {
				vmList.makeGridObj.noDataHidePage(createPageObj.getElementId('ImngListObject'));
				vmList.makeGridObj.search(this, function() {
	                $.ajax({
	                    type : "GET",
	                    url : "<c:url value='/common/notice/rowCount.json' />",
	                    data: JsonImngObj.serialize(this.object),
	                    processData : false,
	                    success : function(result) {
	                    	vmList.totalCount = numberWithComma(result.object);
	                    }
	                });
	            }.bind(this));
			},
            initSearchArea: function(searchCondition) {
            	if(searchCondition) {
            		for(var key in searchCondition) {
            		    this.$data[key] = searchCondition[key];
            		}
            	}else {
                	this.pageSize = '10';
            		this.object.noticeTitle = null;		
            		this.object.noticeContent = null;            		
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
            newTabPageUrl: "<c:url value='/common/notice.html' />"
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
        		onClick: function(loadParam, ev) {
        			SearchImngObj.clicked({'pk.noticeId': loadParam['pk.noticeId'], 'pk.createTimestamp': loadParam['pk.createTimestamp']}) ;
        		},
        		searchUri : "<c:url value='/common/notice/search.json' />",
        		viewMode : "${viewMode}",
              	popupResponse : "${popupResponse}",
              	popupResponsePosition : "${popupResponsePosition}",
              	columns : [
              		{
              			name : "noticeTitle",
              			header : "<fmt:message>igate.notice.title</fmt:message>",
              			align : "left",
                        width: "40%",
              		},
              		{
              			name : "userId",
              			header : "<fmt:message>igate.notice.writer</fmt:message>",
              			align : "left",
                        width: "30%",
              		},
              		{
              			name : "pk.createTimestamp",
              			header : "<fmt:message>igate.notice.reg.date</fmt:message>",
              			align : "center",
                        width: "30%",
              		},              		
              	]        	    
        	});
        	
        	SearchImngObj.searchGrid = this.makeGridObj.getSearchGrid();
        	
        	if(!this.newTabSearchGrid()) {
            	this.$nextTick(function() {
            		window.vmSearch.search();	
            	});        		
        	}
        }
    });	
    
    window.vmMain = new Vue({
    	el : '#MainBasic',
    	data : {
    		viewMode : 'Open',
    		object : {
       			noticeTitle: null,
       			noticeContent: null,
       			userId: null,
       			pk: {
       				createTimestamp: '',
       				noticeId: ''
       			}
    		},
    		openWindows : [],
    		panelMode : null    		
    	},
        methods : {
			goDetailPanel: function() {
				panelOpen('detail');
			},
        	initDetailArea: function(object) {
        		if(object) {
        			this.object = object;
        		}else{
    				this.object.noticeTitle = null;
    				this.object.noticeContent = null;
    				this.object.pk.createTimestamp = '';
    				this.object.pk.noticeId = '';
        		}
        		
			},
        },
    });
    
    new Vue({
    	el: '#panel-footer',
    	methods : $.extend(true, {}, panelMethodOption)
    });
});
</script>