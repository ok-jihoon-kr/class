<%@page import="com.exam.dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
function useId(){
	// 현재창을 생성한 부모창 참조 
	// window.opener(window는 생략가능)
	opener.document.frm.id.value = window.document.wfrm.userid.value;
	// 현재 창닫기 window.close();
	close();

}
</script>

</head>
<body>
<%
	// "userid"	중복확인할 아이디 파라미터값 가져오기 
	String userid = request.getParameter("userid");
	// DAO 객체 준비 
	MemberDao memberDao = MemberDao.getInstance();
	// 아이디 중복확인 메소드 호출
	boolean isIdDup = memberDao.isIdDuplicated(userid);
	if(isIdDup){ //  isIdDup == true 아이디중복
		%>
		아이디 중복, 사용중인 ID입니다.<br>
		<%
	} else { // isIdDup == false 아이디중복아님
		%>
		사용가능한 ID입니다.<br>
		<button type="submit" onclick="useId()">사용</button>
		<%
	}
	
	
%>
<form action="joinIdDupCheck.jsp" method="get" name="wfrm">
	<input type="text" name="userid" value="<%=userid %>">
	<button type="submit">중복확인</button>
</form>


</body>
</html>