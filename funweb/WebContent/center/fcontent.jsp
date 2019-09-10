<%@page import="com.exam.vo.AttachVO"%>
<%@page import="com.exam.dao.AttachDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.exam.vo.BoardVO"%>
<%@page import="com.exam.dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>Welcome to Fun Web</title>
<link href="../css/default.css" rel="stylesheet" type="text/css" media="all">
<link href="../css/subpage.css" rel="stylesheet" type="text/css"  media="all">
<link href="../css/print.css" rel="stylesheet" type="text/css"  media="print">
<link href="../css/iphone.css" rel="stylesheet" type="text/css" media="screen">
</head>
<%
// 글번호 num 파라미터값 가져오기
int num = Integer.parseInt(request.getParameter("num"));
//파라미터값 search  pageNum 가져오기 
String search = request.getParameter("search"); // 검색어(처음에 아무것도 입력안하면 null이다)
if(search== null){
	search = "";
}

// 페이지 번호 pageNum 파라미터값 가져오기 
String pageNum = request.getParameter("pageNum");
// DAO 객체준비
BoardDao boardDao = BoardDao.getInstance();
//조회수 1증가시키는 메소드 호출
boardDao.updateReadcount(num); // 특정레코드에 조회수를 증가시키기 위해 
// 글번호에 해당하는 레코드 한개 가져오기 
BoardVO boardVO = boardDao.getBoard(num);
//날짜 포맷 준비 SimpleDateFormat
// 글작성날짜 형식 'yyyy년 MM월 dd일 hh시 mm분 ss초'
SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 hh시 mm분");

// AttachDao 객체 준비 
AttachDao attachDao = AttachDao.getInstance();
// 글 번호에 해당하는 첨부파일정보 가져오기
AttachVO attachVO = attachDao.getAttach(num);





%>
<body>
<div id="wrap">
	<!-- 헤더 영역 -->
	<jsp:include page="../include/header.jsp" />

	<div class="clear"></div>
	<div id="sub_img_center"></div>
	
	<div class="clear"></div>
	<%-- nav 영역 --%>
	<jsp:include page="../include/nav_center.jsp" />
<article>
    
<h1>Notice Content</h1>
<table id="notice">
	<tr>
		<th class="twrite">글번호</th>
		<td class="left" width="170"><%=boardVO.getNum() %></td>
		<th class="twrite">조회수</th>
		<td class="left" width="170"><%=boardVO.getReadcount() %></td>
	</tr>
	<tr>
		<th class="twrite">작성자명</th>
		<td class="left"><%=boardVO.getUsername() %></td>
		<th class="twrite">작성일자</th>
		<td class="left"><%=sdf.format(boardVO.getRegDate())  %></td>
	</tr>
	<tr>
		<th class="twrite">글제목</th>
		<td class="left" colspan="3"><%=boardVO.getSubject()%></td>
	</tr>
	<tr>
		<th class="twrite">파일</th>
		<td class="left" colspan="3">
			<%
			if(attachVO != null){
			if (attachVO.getFiletype().equals("I")) { // 이미지 타입
				%>
				<a href="../upload/<%=attachVO.getFilename() %>">
					<img src="../upload/<%=attachVO.getFilename() %>" width="50" height="50">
				</a>
				<%
			} else {
				%>
				<a href="../upload/<%=attachVO.getFilename() %>">
					<%=attachVO.getFilename() %>
				</a>
				<%
			}
			}
			%>
		</td>
	</tr>
	<tr>
		<th class="twrite">글내용</th>
		<td class="left" colspan="3"><pre><%=boardVO.getContent() %></pre></td>
	</tr>
</table>

<div id="table_search">
	<input type="button" value="글수정" class="btn" onclick="location.href='update.jsp?num=<%=boardVO.getNum()%>&pageNum=<%=pageNum%>';">
	<input type="button" value="글삭제" class="btn"  onclick="checkDelete();">
	<input type="button" value="답글쓰기" class="btn" onclick="location.href='reWrite.jsp?reRef=<%=boardVO.getReRef() %>&reLev=<%=boardVO.getReLev() %>&reSeq=<%=boardVO.getReSeq() %>';">
	<input type="button" value="목록보기" class="btn" onclick="location.href='fnotice.jsp?pageNum=<%=pageNum%>&search=<%=search%>';">
</div>


</article>
    
	<div class="clear"></div>
    
    <!-- 푸터 영역 -->
	<jsp:include page="../include/footer.jsp" />
</div>

<script>
	function checkDelete(){
		var result = confirm('<%=boardVO.getNum()%>번 글을 정말로 삭제하시겠습니까?');
		if(result == true){
			location.href = 'delete.jsp?num=<%=boardVO.getNum()%>&pageNum=<%=pageNum%>';	
		}
		
		
	}
</script>

</body>
</html>   

    