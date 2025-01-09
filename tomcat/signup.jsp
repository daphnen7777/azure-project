<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fruits Basket</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Header -->
    <header>
        <a href="index.html">Fruits Basket</a>
    </header>

    <!-- Navigation -->
    <nav>
        <a href="index.html">Home</a>
        <a href="products.html">Products</a>
        <a href="about.html">About</a>
        <a href="post_list.jsp">Board</a>
        <div class="topnav-right">
            <a href="signup.jsp">Sign Up</a>
            <a href="login.jsp">Login</a>
        </div>
    </nav>

    <!-- 회원가입 폼 (클래스를 추가하여 스타일을 적용) -->
    <div class="signup-form">
        <h1>Sign Up</h1>
        <form method="post" action="signupaction.jsp">
            <label for="username">ID:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <label for="fullname">Name:</label>
            <input type="text" id="fullname" name="fullname" required>
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="phone">Phone:</label>
            <select name="phone">
                <option>010</option>
                <option>011</option>
                <option>012</option>
            </select>
            - <input type="text" name="phone2" size="5"> - 
            <input type="text" name="phone3" size="5">
            
            <label>Gender:</label>
            <input type="radio" name="gender" value="m" checked>Male
            <input type="radio" name="gender" value="f">Female
            
            <input type="submit" value="Join">
        </form>
    </div>
</body>
</html>
