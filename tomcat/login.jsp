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
    <div class="login-form">
        <h1>Login</h1>
        <form method="post" action="loginaction.jsp">
            <label for="userID">Username:</label>
            <input type="text" id="userID" name="userID" required>
            <br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <br>
            <input type="submit" value="Login">
        </form>

        <button class="join-btn" onclick="window.location.href='signup.jsp'">Join</button>
    </div>
</body>
</html>