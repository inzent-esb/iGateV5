<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="ct-header" id="ImngSearchObject" style="display: none;">
	<button type="button" class="btn-filter collapsed d-md-none" data-toggle="collapse" data-target="#collapse-filter">
		<fmt:message>head.searchFilter</fmt:message>
		<i class="icon-down"></i>
	</button>

	<div id="collapse-filter" class="collapse collapse-filter">
		<div class="filter no-gutters">
			<input type="password" style="display: none;">
			<%-- 자동완성 오류 때문에 추가함. --%>
			<div class="col" id="list-select">
				<label class="form-control-label"> 
				<b class="control-label"><fmt:message>head.listCount</fmt:message></b> 
					<input type="text" class="form-control view-disabled" list="listCount" v-model="pageSize" v-on:input="pageSizeInput" v-on:keyup.enter="pageSizeEnter($event)" v-on:blur="pageSizeBlur"> 
					<datalist id="listCount">
						<option v-for="listCount in [10,100,1000]">{{listCount}}</option>
					</datalist>
				</label>
			</div>
			<div class="col-auto">
				<button type="button" class="btn btn-primary" v-on:click="search" style="z-index: 1">
					<i class="icon-srch"></i>
					<fmt:message>head.search</fmt:message>
				</button>
			</div>
		</div>
		
		<div class="toggleSearchExpandBtn collapsed" data-toggle="collapse" data-target=".toggleSearchExpandArea" style="display: none;" v-on:click="collapseFilter">
			<i class="icon-down"></i>
		</div>		
		
		<div class="collapse toggleSearchExpandArea">
			<div class="filter no-gutters">
				<div class="col-auto">
					<button type="button" class="btn btn-primary" v-on:click="search">
						<i class="icon-srch"></i>
						<fmt:message>head.search</fmt:message>
					</button>
				</div>			
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var searchMethodOption = {
	pageSizeInput: function() {
   		return this.pageSize = this.pageSize.replace(/constants.regExpList.pageSize/g, '');
   	},
   	pageSizeEnter: function(e) {
   		e.target.blur();
   		window.vmSearch.search();
   	},
   	pageSizeBlur: function() {
   		return this.pageSize = 10 > window.vmSearch.pageSize ? 10 : window.vmSearch.pageSize;
   	},
   	collapseFilter: function() {
   		setTimeout(function() {
   			windowResizeSearchGrid();
   		}, 0);
   	}
};
</script>
   	