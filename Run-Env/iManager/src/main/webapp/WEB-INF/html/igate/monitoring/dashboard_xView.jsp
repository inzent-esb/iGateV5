<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpXviewSkeleton" style="display: none;">
	<div class="graph" style="height: 100%;">
		<div name="background" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;"></div> <%-- background --%>
		<div name="body" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;"></div> <%-- body --%>
	</div>
	<div class="legend">
		<span class="status"><i class="dot bg-normal"></i><fmt:message>dashboard.head.success</fmt:message></span>
		<span class="status"><i class="dot bg-warn"></i><fmt:message>dashboard.head.time.out</fmt:message></span>
		<span class="status"><i class="dot bg-danger"></i><fmt:message>dashboard.head.error</fmt:message></span>
	</div>	
</span>

<span id="xLogDetailModalSkeleton" style="display: none;">
	<div id="xLogDetail" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title"><fmt:message>dashboard.head.detail.xView</fmt:message></h2>
					<ul>
						<li style="float: left;">
							<button type="button" class="btn-icon" name="exportXlogDetailCsvIcon" title="Export CSV"><i class="icon-export"></i></button>
						</li>				
						<li style="float: left;">
							<button type="button" class="btn-icon" title="<fmt:message>head.close</fmt:message>" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>
						</li>				
					</ul>
				</div>
				<div class="modal-body">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn" data-dismiss="modal" id="modalClose"><fmt:message>head.close</fmt:message></button>
				</div>
			</div>
		</div>
	</div>
</span>

<span id="xLogFilterModalSkeleton" style="display: none;">
	<div id="xLogFilterModal" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title"><fmt:message>dashboard.head.filter</fmt:message></h2>
					<button type="button" class="btn-icon" title="<fmt:message>head.close</fmt:message>" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>
				</div>
				<div class="modal-body">
					<div class="form-group">
				        <label class="control-label"><fmt:message>igate.adapter.id</fmt:message></label>
				        <div class="input-group">
				        	<input type="text" name="adapterFilterInput" class="form-control view-disabled dataKey" disabled>
				        	 <div class="input-group-append saveGroup">
				        	 	<button type="button" id="adapterFilterBtn" class="btn" style="margin-left: 5px; min-width: 0px;"><i class="icon-srch" style="margin-right: 0px;"></i></button>
					        </div>
				      	</div>
				    </div>
				    <div class="form-group">
				         <label class="control-label"><fmt:message>igate.instance.id</fmt:message></label>
				        <div class="input-group">
				        	<input type="text" name="instanceFilterInput" class="form-control view-disabled dataKey" disabled>
				        	 <div class="input-group-append saveGroup">
				        	 	<button type="button" id="instanceFilterBtn" class="btn" style="margin-left: 5px; min-width: 0px;"><i class="icon-srch" style="margin-right: 0px;"></i></button>
					        </div>
				      	</div>
				    </div>
				    <div class="form-group">
				         <label class="control-label"><fmt:message>dashboard.head.interface.service.id</fmt:message></label>
				        <input type="text" name="transactionFilterInput" class="form-control">
				    </div>
				</div>
				<div class="modal-footer">
					<button type="button" id="modalClose" class="btn" data-dismiss="modal"><fmt:message>head.close</fmt:message></button>
					<button type="button" id="xLogFilterSetBtn" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>
				</div>
			</div>
		</div>
	</div>
</span>	
<span id="xLogFilterDetailModalSkeleton" style="display: none;">
	<div id="xLogFilterDetailModal" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title"><fmt:message>dashboard.head.filter</fmt:message></h2>
					<button type="button" class="btn-icon" title="<fmt:message>head.close</fmt:message>" data-dismiss="modal" aria-label="Close"><i class="icon-close"></i></button>
				</div>
				<div class="modal-body">
					<table>
						<colgroup>
							<col width="45%">
							<col width="10%">
							<col width="45%">
						</colgroup>
						<tr>
							<td><div id="allGridArea"></div></td>
							<td>
								<div id="gridBtnArea" style="text-align: center; vertical-align: middle; display: none;">
									<div style="display: inline-block;">
								    	<div class="row">
								    		<button type="button" id="addFilter" class="btn" style="min-width: 0px; margin-bottom: 10px;"><i class="icon-right" style="margin-right: 0px;"></i></button>
								    	</div>
								    	<div class="row">
								    		 <button type="button" id="deleteFilter" class="btn" style="min-width: 0px;"><i class="icon-left" style="margin-right: 0px;"></i></button>
								    	</div>
						    		</div>
					    		</div>
							</td>
							<td><div id="selectGridArea"></div></td>
						</tr>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" id="modalClose" class="btn" data-dismiss="modal"><fmt:message>head.close</fmt:message></button>
					<button type="button" id="selectFilterBtn" class="btn btn-primary" data-dismiss="modal"><fmt:message>head.ok</fmt:message></button>
				</div>
			</div>
		</div>
	</div>
</span>