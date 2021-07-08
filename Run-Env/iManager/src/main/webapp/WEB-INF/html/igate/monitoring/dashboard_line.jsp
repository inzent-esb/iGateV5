<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<span id="tmpLineSkeleton" style="display: none;">
	<div class="graph" style="height: 100%;">
		<canvas></canvas>
	</div>
	<div class="legend"></div>
	<div name="chartjs-tooltip" class="chartjs-tooltip" style="position: fixed; background-color: rgba(0, 0, 0, .7); border-radius: 3px; color: #fff; z-index: 9999; display: none;"></div>
</span>
