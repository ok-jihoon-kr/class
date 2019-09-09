<%@page import="com.exam.dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
//세션값 가져오기 (로그인 여부 확인)
String id = (String) session.getAttribute("id");
%>



<%
// post 파라미터값 한글처리 
request.setCharacterEncoding("utf-8");

// 파라미터값 가져오기
String pageNum = request.getParameter("pageNum");
int num = Integer.parseInt(request.getParameter("num"));
//로그인 사용자일 경우 null
String passwd = request.getParameter("passwd"); 

// DAO 객체준비
BoardDao boardDao = BoardDao.getInstance();


// 로그인 안한 사용자는 입력한 패스워드와 글패스워드를 비교해서 
// 같을때는 삭제처리 
// 다를때는 "글 패스워드 다름" 뒤로가기 
if(id == null){
	if(!boardDao.isPasswdEqual(num, passwd)){
		%>
		<script>
			alert('글 패스워드 다름');
			history.back();
		</script>
		<%
		return;
	} 
}

// 게시글 삭제하기 메소드 호출
// [로그인한 사용자] 또는 [로그인안한 사용자인데 패스워드 일치한자]
boardDao.deleteBoard(num); // 글 삭제처리 

// 삭제처리 후 글목록 notice.jsp로 이동 
response.sendRedirect("notice.jsp?pageNum=" + pageNum);


%>

