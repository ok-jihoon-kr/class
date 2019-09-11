<%@page import="java.util.List"%>
<%@page import="java.io.File"%>

<%@page import="com.exam.dao.AttachDao"%>
<%@page import="com.exam.vo.AttachVO"%>
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

// 첨부파일 테이블 AttachDao 객체 준비 
AttachDao attachDao = AttachDao.getInstance();

// 게시판 글번호에 해당하는 첨부파일정보 가져오기
List<AttachVO> attachList = attachDao.getAttaches(num);

// 업로드한 파일이 있는 경우 
for(AttachVO attachVO: attachList){
	String realPath = application.getRealPath("/upload");
	
	// 파일 삭제를 위한 File 객체 준비 
	File file = new File(realPath,attachVO.getFilename());

	if (file.exists()) {
		file.delete(); // 해당경로에 있는 파일 삭제 수행
	} 	
}

/* // 업로드한 파일이 있는 경우 
if(attachVO != null) {
	String realPath = application.getRealPath("/upload");
	
	// 파일 삭제를 위한 File 객체 준비 
	File file = new File(realPath,attachVO.getFilename());

	if (file.exists()) {
		file.delete(); // 해당경로에 있는 파일 삭제 수행
	} 	
} */


// attach 테이블 레코드 삭제 
attachDao.deleteAttach(num);

// 게시글 삭제하기 메소드 호출
// [로그인한 사용자] 또는 [로그인안한 사용자인데 패스워드 일치한자]
boardDao.deleteBoard(num); // 글 삭제처리 

// 삭제처리 후 글목록 notice.jsp로 이동 
response.sendRedirect("fnotice.jsp?pageNum=" + pageNum);


%>

