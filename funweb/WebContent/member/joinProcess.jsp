<%@page import="com.exam.dao.MemberDao"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
// post 파라미터 한글처리 
request.setCharacterEncoding("utf-8");
%>


<%-- MemberVO 자바빈 객체 생성  --%>
<jsp:useBean id="memberVO" class="com.exam.vo.MemberVO"/>

<%-- 자바빈 객체에 파라미터값 찾아서 저장하기 --%>
<jsp:setProperty property="*" name="memberVO"/>

<%-- 가입날짜 생성해서 자바빈에 저장--%>
<% memberVO.setRegDate(new Timestamp(System.currentTimeMillis())); %>

<%-- DAO 객체 준비 --%>
<% MemberDao memberDao = MemberDao.getInstance();%>

<%-- 회원가입(추가) 메소드 호출 --%>
<% memberDao.insertMember(memberVO);%>

<%-- 로그인 페이지로 이동 --%>
<% //response.sendRedirect("login.jsp"); %>
<script>
	alert('회원가입 되었습니다.\n로그인 페이지로 이동합니다.');
	location.href = 'login.jsp';
</script>