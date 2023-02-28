<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="connectorPropertiesTemplate" style="display: none;">
	<div class="propertyTab" style="width: 100%">
		<div class="form-table form-table-responsive">
	        <div class="form-table-wrap">
	        	<div class="form-table-head">
	            	<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="addProperty();"><i class="icon-plus-circle"></i></button>
	    			<label class="col"><fmt:message>common.property.key</fmt:message></label>
	    			<label class="col"><fmt:message>common.property.value</fmt:message></label>
	    			<label class="col"><fmt:message>head.description</fmt:message></label>
	            </div>
	            <div class="form-table-body" v-for="(elm, index) in connectorProperties">  
	            	<button type="button" class="btn-icon saveGroup updateGroup" v-if="elm.require"><i class="icon-star"></i></button>
	             	<button type="button" class="btn-icon saveGroup updateGroup" v-on:click="removeProperty(index);" v-else><i class="icon-minus-circle"></i></button>

             		<div class="col">
             			<div v-if="elm.require" style="width: 100%;">
             				<input type="text" class="form-control readonly" list="propertyKeys" v-model="elm.pk.propertyKey" readonly>
	             			<datalist id="propertyKeys">
	             				<option v-for="option in propertyKeys" :value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>
	             			</datalist>
             			</div>
             			<div class="detail-content-regExp" v-else>
             				<input type="text" class="regExp-text view-disabled" list="propertyKeys" v-model.trim="elm.pk.propertyKey" @input="inputEvt('pk.propertyKey', index)" @change="changePropertyKey(index)">
	             			<datalist id="propertyKeys">
	             				<option v-for="option in propertyKeys" value="option.pk.propertyKey">{{option.pk.propertyKey}}</option>
	             			</datalist>
	             			<span class="letterLength"> ( {{ curLengthArr[index]['pk.propertyKey'] }} / {{ maxLengthArr[index]['pk.propertyKey'] }} ) </span>
             			</div>
             		</div>
	             		
             		<div class="col">
	             		<div class="detail-content-regExp" v-if="elm.cipher">
	             			<input type="password" class="regExp-text view-disabled" v-model="elm.propertyValue" @input="inputEvt('propertyValue', index)">
	             			<span class="letterLength"> ( {{ curLengthArr[index].propertyValue }} / {{ maxLengthArr[index].propertyValue }} ) </span>
	             		</div>
             			<div class="detail-content-regExp" v-else>
             				<input type="text" class="regExp-text view-disabled" v-model="elm.propertyValue" @input="inputEvt('propertyValue', index)">
	             			<span class="letterLength"> ( {{ curLengthArr[index].propertyValue }} / {{ maxLengthArr[index].propertyValue }} ) </span>
             			</div>             			
             		</div>
	     
             		<div class="col">
             			<input type="text" class="form-control readonly" v-model="elm.propertyDesc" readonly>
             		</div>
	             </div>
	         </div>
	     </div>	
     </div>
</span>

<span id="connectorDeploiesTemplate" style="display: none;">
	<ul class="list-group" style="width: 100%;">
	   <li class="list-group-item" v-for="(element, index) in instanceList">
	       <label class="custom-control custom-checkbox">
	           <input type="checkbox" class="custom-control-input view-disabled" v-model="connectorCheckList[index]" @change="setPropertyList(element.instanceId, $event)">
	           <span class="custom-control-label">{{element.instanceId}}</span>
	       </label>
	   </li>
	</ul>
</span>