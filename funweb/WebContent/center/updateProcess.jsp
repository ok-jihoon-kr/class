<%@page import="com.exam.vo.BoardVO"%>
<%@page import="com.exam.dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%-- post 파라미터값 한글처리 --%>
<% request.setCharacterEncoding("utf-8"); %>

<%-- BoardVO 자바빈 객체 생성--%>
<jsp:useBean id="boardVO" class="com.exam.vo.BoardVO"/>

<%-- 자바빈 객체에 파라미터값 찾아서 저장(패스워드값은 안온다!) --%>
<jsp:setProperty property="*" name="boardVO"/> 

<%
// DAO 객체 준비 
BoardDao boardDao = BoardDao.getInstance();
//파라미터값 가져오기 num, pageNum
int num = Integer.parseInt(request.getParameter("num"));
String pageNum  = request.getParameter("pageNum");
System.out.println(pageNum);
// BoardVO dbBoardVO = boardDao.getBoard(boardVO.getNum());

// 세션값 가져오기 (로그인 여부 확인)
String id = (String) session.getAttribute("id");



// *로그인 안한 사용자가 로그인
// 로그인 안한 사용자(글패스워드값이 있는 사용자)는
// 패스워드 일치 여부를 확인 후 일치하면 글 수정하고 
// 일치하지 않으면 "글패스워드 다름" 뒤로가기 
if(id == null){
	boolean isPasswdEqual = boardDao.isPasswdEqual(boardVO.getNum(), boardVO.getPasswd());
	if(!isPasswdEqual){
		%>
		<script>
			alert('글패스워드가 다릅니다.');
			history.back();
		</script>
		<%		
		return; // 여기서 흐름을 끊어줘서 밑으로 코드가 안내려간다 로그인 안한 사용자들 
	}
} 


// 게시글 수정하기 메소드 호출
boardDao.updateBoard(boardVO);

// 수정이 안료되면 글목록 notice.jsp 로 이동 
//response.sendRedirect("notice.jsp");
%>

<script>
	alert('글 수정 성공');
	location.href = 'content.jsp?num=<%=num%>&pageNum=<%=pageNum%>';
</script>