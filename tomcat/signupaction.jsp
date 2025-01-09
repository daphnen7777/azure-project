<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

        <%@ include file = "signup_dbconn.jsp" %>
    <%
    Class.forName("com.mysql.jdbc.Driver");
    Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String fullname = request.getParameter("fullname");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String phone2 = request.getParameter("phone2");
    String phone3 = request.getParameter("phone3");
    String gender = request.getParameter("gender");
        
        String insertQuery = "INSERT INTO user_management.users(username, password, fullname, email, phone, phone2, phone3, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement psmt = connection.prepareStatement(insertQuery);
        psmt.setString(1, username);
        psmt.setString(2, password);
        psmt.setString(3, fullname);
        psmt.setString(4, email);
        psmt.setString(5, phone);
        psmt.setString(6, phone2);
        psmt.setString(7, phone3);
        psmt.setString(8, gender);

        int result = psmt.executeUpdate();

        if(result == 1){
            out.println("Successful");
            response.sendRedirect("index.html");
        } 
        else{
            out.println("Failed");
            response.sendRedirect("signup.jsp");
        }
    }
    catch (Exception ex)
    {
        out.println("오류가 발생했습니다. 오류 메시지 : " + ex.getMessage());
    }
%>