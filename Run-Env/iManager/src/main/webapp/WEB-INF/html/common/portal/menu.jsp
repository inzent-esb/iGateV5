<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header id="hd">
	<div class="hd-brand">
		<h1 class="logo text-hide">
			<a href="javascript:void(0);" id="homeLogo">
				<img src="<c:url value='/img/logo.svg' />" alt="INZENT">INZENT
			</a>
		</h1>
		<button type="button" class="menu-toggler d-none d-lg-block"><i class="icon-hamburger-back"></i></button>
		<button type="button" class="menu-toggler d-lg-none"><i class="icon-hamburger-back"></i></button>
	</div>
	<ul class="breadcrumb">
	</ul>
	<div class="hd-side">
		<a href="javascript:void(0);" id="userInfoBtn" title="<fmt:message>head.mypage</fmt:message>"><i class="icon-profile"></i></a>
		<a href="javascript:void(0);" id="logoutBtn" title="<fmt:message>common.auth.logout</fmt:message>"><i class="icon-logout"></i></a>
	</div>
</header>

<nav id="sidebar" class="panel">
	<div class="panel-content">
		<ul class="menu">
			<li class="menu-item">
				<a href="javascript:void(0);" id="menu-home" class="menu-link"><i class="icon-home"></i><fmt:message>head.home</fmt:message></a>
			</li>
		</ul>
		<div class="menu-divider"></div>
		<div class="menu-collapse-item">
			<a id="menu-bookmark-parent" href="#menu-bookmark" class="menu-collapse-link collapsed disabled" data-toggle="collapse"><fmt:message>head.favorites</fmt:message><i class="icon-down"></i></a>
			<div id="menu-bookmark" class="collapse">
				<ul class="menu"></ul>
			</div>
			<p id="menu-bookmark-no-data" class="bookmark-text" style="display: none;"><i class="icon-bookmark active"></i><fmt:message>common.portal.favoriteRegister</fmt:message></p>
		</div>		
		<div class="menu-divider"></div>
		<ul id="gnb"></ul>
	</div>
</nav>