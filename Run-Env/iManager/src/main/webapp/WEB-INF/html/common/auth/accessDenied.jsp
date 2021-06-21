<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="imc" uri="http://www.inzent.com/imanager/tags/core" %>
<html>
<head>
<%@ include file="/WEB-INF/html/layout/header/head_vue.jsp"%>
</head>
<body class="container-fluid ImngBackGround">
  <h1>AccessDenied</h1>
  <imc:throwable name="string" throwable="${error}" />
</body>
</html>