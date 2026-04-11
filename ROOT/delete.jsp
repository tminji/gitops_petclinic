<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
if (id == null || id.trim().isEmpty()) {
    response.sendRedirect("list.jsp");
    return;
}

// POST 요청인 경우 (삭제 처리)
if ("POST".equals(request.getMethod())) {
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Context initContext = new InitialContext();
        Context envContext = (Context)initContext.lookup("java:/comp/env");
        DataSource ds = (DataSource)envContext.lookup("jdbc/MyDB");
        conn = ds.getConnection();

        String deleteSql = "DELETE FROM posts WHERE id=?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, Integer.parseInt(id));

        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.sendRedirect("list.jsp?deleted=true");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>3Tier 게시판 - 글 삭제</title>
    <style>
        /* edit.jsp의 스타일 재사용 */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }
        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 15px;
        }
        .btn {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            padding: 15px 30px;
            border-radius: 25px;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #495057);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">3TIER BOARD</div>
            <h1>게시글 삭제</h1>
            <p>정말로 게시글 #<%= id %>을(를) 삭제하시겠습니까?</p>
        </div>

        <form method="post" action="delete.jsp?id=<%= id %>" style="text-align:center;">
            <button type="submit" class="btn">삭제하기</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </form>
    </div>
</body>
</html>
