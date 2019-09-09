<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.exam.vo.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="com.exam.dao.BoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>Welcome to Fun Web</title>
<link href="../css/default.css" rel="stylesheet" type="text/css"
	media="all">
<link href="../css/subpage.css" rel="stylesheet" type="text/css"
	media="all">
<link href="../css/print.css" rel="stylesheet" type="text/css"
	media="print">
<link href="../css/iphone.css" rel="stylesheet" type="text/css"
	media="screen">
</head>
<%
// 파라미터값 search  pageNum 가져오기 
String search = request.getParameter("search"); // 검색어(처음에 아무것도 입력안하면 null이다)
if(search== null){
	search = "";
}
String strPageNum = request.getParameter("pageNum");
if(strPageNum == null){
	strPageNum = "1";
}
// 페이지 번호
int pageNum = Integer.parseInt(strPageNum); // 사용자가 페이지를 넘겨준다 
// DAO 객체 준비 
BoardDao boardDao = BoardDao.getInstance();
// 한페이지(화면)에 보여줄 글 개수 
int pageSize = 10;
//시작행번호 구하기 
int startRow =  (pageNum-1) * pageSize + 1; // 첫번째 페이지를 1로 시작하기 위해 -1 을한다. 
// board테이블 전체글개수 가져오기 메소드 호출 
int count = boardDao.getBoardCount(search);


// 글목록 가져오기 메소드 호출
List<BoardVO> boardList = boardDao.getBoards(startRow, pageSize, search);

// 날짜 포맷 준비 SimpleDateFormat
SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");


%>
<body>
	<div id="wrap">
		<!-- 헤더영역 -->
		<jsp:include page="../include/header.jsp" />
		<div class="clear"></div>
		<div id="sub_img_center"></div>
		<div class="clear"></div>
		<nav id="sub_menu">
			<ul>
				<li><a href="#">Notice</a></li>
				<li><a href="#">Public News</a></li>
				<li><a href="#">Driver Download</a></li>
				<li><a href="#">Service Policy</a></li>
			</ul>
		</nav>
		<article>
			<h1>Notice [전체글개수 : <%=count %>]</h1>
			
			<table id="notice">
				<tr>
					<th scope="col" class="tno">no.</th>
					<th scope="col" class="ttitle">title</th>
					<th scope="col" class="twrite">writer</th>
					<th scope="col" class="tdate">date</th>
					<th scope="col" class="tread">read</th>
				</tr>
				<%
				if(count > 0){
					for(BoardVO boardVO : boardList){
					%>
					<!--get방식으로 넘겨준다. -->
					<tr onclick="location.href='content.jsp?num=<%=boardVO.getNum() %>&pageNum=<%=pageNum%>&search=<%=search %>';"> 
						<td><%=boardVO.getNum() %></td>
						<td class="left">
						<%
						if(boardVO.getReLev() > 0){ // 답글일때
							int level = boardVO.getReLev() * 10;
							%>
							<img src="../images/center/level.gif" height="13" width="<%=level %>" />
							<img src="../images/center/re.gif" />
							<%
							
						}
						%>
							<%=boardVO.getSubject() %>
						</td>
						<td><%=boardVO.getUsername() %></td>
						<td><%=sdf.format(boardVO.getRegDate()) %></td>
						<td><%=boardVO.getReadcount() %></td>
					</tr>
					<%
					}
				} else { // count == 0
					%>
					<tr>
						<td colspan = "5">게시판 글이 없습니다.</td>
					</tr>
					<%
					
				}
				%>
			</table>
			<div id="table_search">
			 <input type="button"  value="글쓰기" class="btn" onclick="location.href='write.jsp';"/>
			 <input type="button" value="목록보기" class="btn" onclick="location.href='notice.jsp?pageNum=<%=pageNum %>';">
			</div>
			
			<form action="notice.jsp" method="get">
				<div id="table_search">
					<input type="text" name="search" value="<%=search %>" class="input_box">
					<input type="submit" value="제목검색" class="btn">
				</div>
			</form>
			
			<div class="clear"></div>
			<div id="page_control">
			<%
				if(count > 0) {
					// 총 페이지 개수 구하기
					// 전체 글개수 나누기 한페이지당 글개수 (+ 1 : 나머지 있을때) 
				int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
				
				// 페이지블록 수 설정 
				int pageBlock = 5;
				
				// 시작페이지번호 startPage 구하기 
				// pageNum값이 1~5이면 -> 시작페이지는 항상 1이 나와야한다.
				
				// (1 - 1 / 5) * 5 + 1 -> 1
				// (2 - 1 / 5) * 5 + 1 -> 1
				// (3 - 1 / 5) * 5 + 1 -> 1
				// (4 - 1 / 5) * 5 + 1 -> 1
				// (5 - 1 / 5) * 5 + 1 -> 1    // 번호 6번일때 다시 페이지번호를 1번으로 돌려준다. 
						
				// (6 - 1 / 5) * 5 + 1 -> 6 // 시작페이지가 항상 6 
				// (7 - 1 / 5) * 5 + 1 -> 6
				// (8 - 1 / 5) * 5 + 1 -> 6
				// (9 - 1 / 5) * 5 + 1 -> 6
				// (10 - 1 / 5) * 5 + 1 -> 6
				int startPage = ( (pageNum - 1) / pageBlock ) * pageBlock + 1;
				
				// 끝페이지번호는 endPage 구하기 
				int endPage = startPage + pageBlock - 1;
				if(endPage > pageCount){
					endPage = pageCount;
				}
				
				// [이전]
				if(startPage > pageBlock) {
					%>
					<a href="notice.jsp?pageNum=<%=startPage-pageBlock%>&search=<%=search %>">[Prev]</a>
				
					<%
				}
				
				
				// 페이지블록 페이지 5개 출력 
				for(int i = startPage; i<= endPage; i++){
					
					if (i==pageNum) {
					%>
					<a href="notice.jsp?pageNum=<%=i %>&search=<%=search %>"><font color='red'><%=i %></font></a> 	
					<%
					} else {
						%>
						<a href="notice.jsp?pageNum=<%=i %>&search=<%=search %>"><%=i %></a> 	
						<%
					}

				}
		
				// [다음]
				if(endPage < pageCount) {
					%>
					<a href="notice.jsp?pageNum=<%=startPage+pageBlock%>&search=<%=search %>">[next]</a>
					<%
				}
				
				}
			%>			
			</div>
			
			
		</article>
		<div class="clear"></div>
		<!-- 푸터영역 -->
		<jsp:include page="../include/footer.jsp" />
	</div>
</body>
</html>