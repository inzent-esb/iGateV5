<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- sapService searchArea -->
<div id="ImngSearchObject" class="ct-header">
	<button type="button" class="btn-filter collapsed d-md-none" data-toggle="collapse" data-target="#collapse-filter">
		<fmt:message>head.searchFilter</fmt:message><i class="icon-down"></i>
	</button>
	
	<div id="collapse-filter" class="collapse collapse-filter">
		<div class="filter no-gutters" >
			<div class="col" id="list-select" style="display : none">
			</div>
			<div class="col-auto">
				<button type="button" class="btn btn-primary" v-on:click="getStruct">
					<i class="icon-srch"></i>
					<fmt:message>head.search</fmt:message>
				</button></br>
			</div>
		</div>
	</div>	
</div>

<!-- sapService detailArea -->
<span id="ImngListObject" class="ct-content" style="display: none;">
	<div id="panel">
		<header class="panel-header sub-bar">
			<div class="ml-auto form-inline m-full">
				<button type="button" class="btn btn-m" v-on:click="initSearchArea">
					<i class="icon-reset"></i><span class="hide">
					<fmt:message>head.initialize</fmt:message>
				</button>
			</div>
			<h2 class="sub-bar-tit"></h2>
		</header>
		<ul class="nav nav-tabs flex-shrink-0">
			<li class="nav-item-origin" style="display: none">
				<a class="nav-link" href="#bass-info" data-toggle="tab"></a>
			</li>
			<li class="nav-item" id="item-result-parent">
				<a class="nav-link" href="#process-result" data-toggle="tab" id="item-result" ><fmt:message>head.process.result</fmt:message></a>
			</li>
		</ul>
		<div class="panel-body tab-content">			
			<div class="form-group form-group-origin">
				<label class="control-label"></label>
				<div class="input-group">
					<select class="form-control dataKey" style="display: none;"></select>
					<input type="text" class="form-control dataKey" style="display: none;">
					<textarea class="form-control dataKey" style="display: none;"></textarea>
					<input type="password" class="form-control" style="display: none;">
					<div class="input-group-append add" style="display: none;">
						<button type="button" class="btn" id="lookupBtn"><i class="icon-srch"></i><fmt:message>head.search</fmt:message></button>
						<button type="button" class="btn" id="resetBtn" style="margin-left: 5px; min-width: 0px;"><i class="icon-reset" style="margin-right: 0px;"></i></button>
					</div>
				</div>
			</div>
			<div class="tab-pane" id="process-result">
				<ul id="accordionResult" class="collapse-list collapse-list-result m-0" style="display: none">
					<li class="collapse-item-origin" style="display: none">
						<button class="collapse-link collapsed" type="button" data-toggle="collapse" data-target="#collapseResult">
							<i class="iconb-compt mr-2"></i><span class="txt"></span>
						</button>
						<div id="collapseResult" class="collapse" data-parent="#accordionResult">
							<div class="collapse-content"></div>
						</div>
					</li>	
				</ul>
			</div>
		</div>
		<footer class="panel-footer sub-bar">
			<div class="ml-auto">
				<a href="javascript:void(0);" class="btn btn-primary" v-on:click="confirmRegist"><i class="icon-plus"></i><fmt:message>head.insert</fmt:message></a>
			</div>
		</footer>		
	</div>
</span>

<style type="text/css">
	#panel { width: 100%; height: calc(100% - 4.5rem); }
	#panel .panel-body { height: calc(100% - 6.5rem) }
	#panel .tab-pane { height: 100%; }
	#panel .tab-pane .row { height: 100%; }
	#panel .tab-pane .row .table-responsive { height: 100%; }
</style>