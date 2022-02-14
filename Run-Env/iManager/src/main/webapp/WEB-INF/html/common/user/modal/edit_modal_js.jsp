<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
  $(document).ready(function()
  {
	var modalParam = $('#editUserModalModalSearch').data('modalParam');
	  
    var headerHTML = '<h2 class="modal-title"><fmt:message>common.user.userInfo</fmt:message></h2>' ;
    headerHTML += '<button type="button" class="btn-icon" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>' ;

    var footerHTML = '' ;
    footerHTML += '<button type="button" id="modifyBtn" class="btn" v-on:click="modifyModeChange"><i class="icon-edit" ></i><fmt:message>head.update</fmt:message></button>' ;
    footerHTML += '<button type="button" id="okBtn" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.close</fmt:message></button>' ;
    footerHTML += '<button type="button" id="closeBtn" class="btn" v-on:click="cancelModeChange" style="display : none"><fmt:message>head.cancel</fmt:message></button>' ;
    footerHTML += '<button type="button" id="saveBtn" class="btn btn-primary" v-on:click="updateAccountInfo" style="display : none"><fmt:message>head.save</fmt:message></button>' ;

    $('#editUserModalModalSearch').find('.modal-header').empty().append(headerHTML) ;
    $('#editUserModalModalSearch').find('.modal-footer').attr({
      'id' : 'edit-footer'
    }).empty().append(footerHTML) ;

    window.vmDetail = new Vue({
      el : '#baseInfo',
      data : {
        viewMode : 'Open',
        object : {},
      },
      mounted : function()
      {
	    this.initDetail() ;
      },
      methods : 
      {
        initDetail : function()
        {
         startSpinner(modalParam.spinnerMode) ;	
        	
          $.ajax({
        	  type : "GET",
        	  url : "<c:url value='/common/user/edit.json' />",
        	  processData : {
        		  userId : $("#accountId").val()
        	  },
        	  data : {
        		  userId : $("#accountId").val()
        	  },
        	  dataType : "json",
        	  success : function(result)
        	  {
        	    window.vmDetail.object = result.object ;
        	    window.vmCrtfcInfo.object = result.object ;
        	    window.vmAuthorInfo.totalUserPrivileges = result.object.totalUserPrivileges.map(function(info){
        	    	info.privilegeName = (info.admin)? "Admin" : (info.member)? "Member" : " ";
        	    	return info;
        	    });
        	    
        	    stopSpinner() ;
        	  },
          }) ; 
        }
      }
    }) ;

    window.vmCrtfcInfo = new Vue({
      el : '#crtfcInfo',
      data : {
        viewMode : 'Open',
        object : {
          userExpiration : '',
          passwordExpiration : '',
          passwordNew : '',
          passwordOld : ''
        },
        pwdCheck : true,
        passwordNewType : 'password',
        passwordOldType : 'password'
      },
      created : function()
      {
        PropertyImngObj.getProperties('List.Yn', true, function(properties)
        {
          this.disableYns = properties ;
        }.bind(this)) ;
      },
      mounted : function()
      {
        initDateSinglePicker(this.object.userExpiration, $('#crtfcInfo').find('#userExpiration')) ;
        initDateSinglePicker(this.object.passwordExpiration, $('#crtfcInfo').find('#passwordExpiration')) ;
      },
      methods : {
        changeType : function(elementId)
        {
    	  if('passwordNew' == elementId)
    	    this.passwordNewType = ('password' == this.passwordNewType)? 'text' : 'password' ;
    	  else
    	    this.passwordOldType = ('password' == this.passwordOldType)? 'text' : 'password' ;
        }
      }
    }) ;

    window.vmAuthorInfo = new Vue({
      el : '#authorInfo',
      data : {
        viewMode : 'Open',
        totalUserPrivileges : [],
        defaultAdmin : false,
        defaultMember : false,
        modifyMode : false,
        isSystem : 'S',
		isBusiness : 'b'
      }
    }) ;

    new Vue({
      el : '#edit-footer',
      methods : {
        modifyModeChange : function()
        {
          window.vmAuthorInfo.modifyMode = true ;
          $('#editUserModalModalSearch').find('.form-control').not('.readonlyField').not('.dataKey').attr('disabled', true) ;
          $('#editUserModalModalSearch').find('.custom-control').attr('disabled', false) ;
          $('#editUserModalModalSearch').find('#modifyBtn').hide() ;
          $('#editUserModalModalSearch').find('#okBtn').hide() ;
          $('#editUserModalModalSearch').find('#closeBtn').show() ;
          $('#editUserModalModalSearch').find('#saveBtn').show() ;
        },
        cancelModeChange : function()
        {
          window.vmAuthorInfo.modifyMode = false ;
          $('#editUserModalModalSearch').find(('.form-control')).not('.readonlyField').attr('disabled', true) ;
          $('#editUserModalModalSearch').find('#modifyBtn').show() ;
          $('#editUserModalModalSearch').find('#okBtn').show() ;
          $('#editUserModalModalSearch').find('#closeBtn').hide() ;
          $('#editUserModalModalSearch').find('#saveBtn').hide() ;
        },
        updateAccountInfo : function()
        {
          var passwordObj = window.vmCrtfcInfo.object ;
          var object = window.vmDetail.object ;
          object._method = "POST" ;
          object.myInfo = true ;

          for ( var key in object)
          {
            var name = 'vm' + key.charAt(0).toUpperCase() + key.slice(1) ;
            if (window.hasOwnProperty(name))
              object[key] = window[name][key] ;
          }

          object.passwordNew = encryptPassword(passwordObj.passwordNew) ;
          object.passwordOld = encryptPassword(passwordObj.passwordOld) ;
          
          startSpinner() ;

          $.ajax(
          {
            type : "POST",
            url : "<c:url value='/common/user/edit.json'/>",
            processData : false,
            data : JsonImngObj.serialize(object),
            dataType : "json",
            success : function(result)
            {
              if ("ok" == result.result)
              {
                ResultImngObj.resultResponseHandler(result) ;

                normalAlert({message : '<fmt:message>head.update.notice</fmt:message>', isSpinnerMode : modalParam.spinnerMode});

                stopSpinner() ;
              }
              else
              {
                ResultImngObj.resultErrorHandler(result) ;
               
                warnAlert({message :result.error[0].message, isSpinnerMode : modalParam.spinnerMode}) ;
          	  }
            },
            error : function(request, status, error)
            {
              ResultImngObj.errorHandler(request, status, error) ;
            },
            complete : function(jqXHR, textStatus )
            {
              this.cancelModeChange() ;
           	  window.vmDetail.initDetail() ;
            }.bind(this)
          }) ;
        }
      },
      mounted : function()
      {
        window.vmAuthorInfo.modifyMode = false ;
        $('#editUserModalModalSearch').find($('.form-control').not('.readonlyField')).attr('disabled', true) ;
      }
    })
  }) ;

  function initDateSinglePicker(vueObj, dateRangeSelector)
  {

    var paramOption = {
      timePicker : true,
      timePicker24Hour : true,
      timePickerSeconds : true,
      format : "YYYY.MM.DD HH:mm:ss",
      localeFormat : "YYYY.MM.DD HH:mm:ss"
    } ;

    dateRangeSelector.customDatePicker(dateRangeSelector, function(time)
    {
      vueObj = time ;
    }, paramOption) ;
  }
</script>