package com.exam.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBManager {
	public static Connection getConnection() throws Exception {
		// DB접속정보
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "scott";
		String password = "tiger";
		
		Connection con = null;
		// 1단계: DB 드라이버 로딩
		Class.forName("oracle.jdbc.OracleDriver");
		// 2단계: DB연결
		con = DriverManager.getConnection(url, user, password);
		return con;
	}
	
	// SELECT문을 수행한 후 리소스 해제를 위한 메소드 
	public static void close(Connection con, Statement stmt, ResultSet rs) {
		try {
			if (rs != null ) {
				rs.close();	
			}
		} catch(Exception e)	{
			e.printStackTrace();
		}
		try {
			if (stmt != null ) {
				stmt.close();	
			}
		} catch(Exception e)	{
			e.printStackTrace();
		}
		try {
			if (con != null ) {
				con.close();	
			}
		} catch(Exception e)	{
			e.printStackTrace();
		}
	}
	// INSERT, UPDATE, DELETE문을 수행한 후 리소스 해제를 위한 메소드
		public static void close(Connection con, Statement stmt) {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		} // close method
}
