<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Fruits Basket</title>
    <link rel="stylesheet" href="style.css">
<body>
    <!-- Header -->
    <header>
        <a href="index.html" style="text-decoration: none; color: white;">Fruits Basket</a>
    </header>
    <!-- Navigation -->
    <nav>
        <a href="index.html">Home</a>
        <a href="products.html">Products</a>
        <a href="about.html">About</a>
        <a href="post_list.jsp">Board</a>
        <div class = "topnav-right">
            <a href="signup.jsp">Sign Up</a>
            <a href="login.jsp">Login</a>
    </nav>
    <%
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String db_address = "jdbc:mysql://10.10.130.30:3306/user_management"; // 데이터베이스 URL 수정 필요
        String db_username = "root"; // 데이터베이스 사용자명 수정 필요
        String db_pwd = "root"; // 데이터베이스 비밀번호 수정 필요

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM user WHERE username=? AND password=?";
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(db_address, db_username, db_pwd);

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                username = rs.getString("username");
                out.println("Login Successful");
            } else {
                out.println("Invalid credentials. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
           try{
                if(conn != null) conn.close();
                if(pstmt != null) pstmt.close();
                if(rs != null) rs.close();
           }
           catch(Exception e) {
                e.printStackTrace();
           }
        }
    %>
    <button class="return.btt" onclick="window.location.href='index.html'">Return</button>
</body>
</html>
