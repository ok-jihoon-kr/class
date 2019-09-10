package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.exam.vo.AttachVO;
import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;

public class AttachDao {
	private static AttachDao instance = new AttachDao();

	public static AttachDao getInstance() {
		return instance;
	}

	private AttachDao() {
	}
	
	// 첨부파일 정보
	public void insertAttach(AttachVO attachVO) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = DBManager.getConnection();
			String sql = "INSERT INTO attach (uuid, filename, filetype, bno) ";
			sql += "VALUES (?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, attachVO.getUuid());
			pstmt.setString(2, attachVO.getFilename());
			pstmt.setString(3, attachVO.getFiletype());
			pstmt.setInt(4, attachVO.getBno());
			
			// 실행 
			pstmt.executeUpdate();
			
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBManager.close(con, pstmt);
		}
	}
	
	// 글번호에 해당하는 첨부파일정보 가져오기 
	public AttachVO getAttach(int bno) {
		AttachVO attachVO = null;
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		
		try {
			con = DBManager.getConnection();
			String sql ="SELECT * FROM attach WHERE bno = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bno);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				attachVO = new AttachVO();
				attachVO.setBno(rs.getInt("bno"));
				attachVO.setUuid(rs.getString("uuid"));
				attachVO.setFilename(rs.getString("filename"));
				attachVO.setFiletype(rs.getString("filetype"));
				
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBManager.close(con, pstmt, rs);
		}
		return attachVO;
	}
	
	
}
