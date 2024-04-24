<%@ page import="java.sql.*, javax.sql.*" %>

<!-- BACK END -->
<%
String action = request.getParameter("action");
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    DataSource ds = (DataSource) getServletContext().getAttribute("DBCPool");
    conn = ds.getConnection();
    conn.setAutoCommit(false);

    if ("update".equals(action)) {
        pstmt = conn.prepareStatement(
            "UPDATE Class SET course_ID = ?, quarter = ?, year = ?, title = ? WHERE class_ID = ?");
        pstmt.setString(1, request.getParameter("course_ID"));
        pstmt.setString(2, request.getParameter("quarter"));
        pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
        pstmt.setString(4, request.getParameter("title"));
        pstmt.setInt(5, Integer.parseInt(request.getParameter("class_ID")));
        pstmt.executeUpdate();
        conn.commit();
    } else if ("delete".equals(action)) {
        pstmt = conn.prepareStatement("DELETE FROM Class WHERE class_ID = ?");
        pstmt.setInt(1, Integer.parseInt(request.getParameter("class_ID")));
        pstmt.executeUpdate();
        conn.commit();
    }

     <!-- get current classes after any updates/deletes -->
    pstmt = conn.prepareStatement("SELECT * FROM Class");
    rs = pstmt.executeQuery();
} catch (SQLException e) {
    if (conn != null) conn.rollback();
    e.printStackTrace();
} finally {
    if (conn != null) {
        conn.setAutoCommit(true);
        conn.close();
    }
}
%>

<!-- FRONT END -->
<!DOCTYPE html>
<html>
<head>
    <title>Class Entry Management</title>
</head>
<body>
<h1>Class Management</h1>
<table border="1">
    <tr>
        <th>Class ID</th>
        <th>Course ID</th>
        <th>Quarter</th>
        <th>Year</th>
        <th>Title</th>
        <th>Update</th>
        <th>Delete</th>
    </tr>
    <%
    while (rs != null && rs.next()) {
    %>
    <tr>
        <form action="class_entry_form.jsp" method="post">
            <td><%= rs.getInt("class_ID") %></td>
            <td><input type="text" name="course_ID" value="<%= rs.getString("course_ID") %>"></td>
            <td><input type="text" name="quarter" value="<%= rs.getString("quarter") %>"></td>
            <td><input type="text" name="year" value="<%= rs.getInt("year") %>"></td>
            <td><input type="text" name="title" value="<%= rs.getString("title") %>"></td>
            <td><input type="hidden" name="class_ID" value="<%= rs.getInt("class_ID") %>"><input type="submit" name="action" value="update"></td>
        </form>
        <form action="class_entry_form.jsp" method="post">
            <td><input type="hidden" name="class_ID" value="<%= rs.getInt("class_ID") %>"><input type="submit" name="action" value="delete"></td>
        </form>
    </tr>
    <%
    }
    %>
</table>
</body>
</html>
