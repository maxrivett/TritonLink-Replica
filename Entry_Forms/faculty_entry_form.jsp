<!-- Faculty = (faculty_name, title, department) -->
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
    
    if (action == null) {
        <!-- throw error if action is null -->
        throw new IllegalArgumentException("No action specified.");
    } else if (action.equals("update")) {
        pstmt = conn.prepareStatement(
            "UPDATE Faculty SET title = ? AND department = ? WHERE faculty_name = ?");
        pstmt.setString(1, request.getParameter("title"));
        pstmt.setString(2, request.getParameter("department"));
        pstmt.setString(3, request.getParameter("faculty_name"));
        pstmt.executeUpdate();
        conn.commit();
    } else if ("delete".equals(action)) {
        pstmt = conn.prepareStatement("DELETE FROM Faculty WHERE faculty_name = ?");
        pstmt.setString(1, request.getParameter("faculty_name"));
        pstmt.executeUpdate();
        conn.commit();
    }

     <!-- get current faculty after any updates/deletes -->
    pstmt = conn.prepareStatement("SELECT * FROM Faculty");
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
    <title>Faculty Entry Management</title>
</head>
<body>
<h1>Faculty Management</h1>
<table border="1">
    <tr>
        <th>Faculty Name</th>
        <th>Title</th>
        <th>Department</th>
        <th>Update</th>
        <th>Delete</th>
    </tr>
    <%
    while (rs != null && rs.next()) {
    %>
    <tr>
        <form action="faculty_entry_form.jsp" method="post">
            <td><%= rs.getString("faculty_name") %><input type="hidden" name="faculty_name" value="<%= rs.getString("faculty_name") %>"></td>
            <td><input type="text" name="title" value="<%= rs.getString("title") %>"></td>
            <td><input type="text" name="department" value="<%= rs.getString("department") %>"></td>
            <td><input type="submit" name="action" value="update"></td>
        </form>
        <form action="faculty_entry_form.jsp" method="post">
            <td><input type="submit" name="action" value="delete"></td>
        </form>
    </tr>
    <%
    }
    %>
</table>
</body>
</html>
