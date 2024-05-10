<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%
                    try {
                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=HPost1QGres!&ssl=false";
                        Connection conn = DriverManager.getConnection(url);
                        conn.setAutoCommit(false);
                        String action = request.getParameter("action");

                        if ("update".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "UPDATE Sections SET FACULTYNAME = ?, ENROLLMENTLIMIT = ? WHERE COURSEID = ? AND SECTIONID = ?");
                            pstmt.setString(3, request.getParameter("COURSEID"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("SECTIONID")));
                            pstmt.setString(1, request.getParameter("FACULTYNAME"));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("ENROLLMENTLIMIT")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM Sections WHERE COURSEID = ? AND SECTIONID = ?");
                            pstmt.setString(1, request.getParameter("COURSEID"));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("SECTIONID")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO Sections (COURSEID, SECTIONID, FACULTYNAME, ENROLLMENTLIMIT) VALUES (?, ?, ?, ?)");
                            pstmt.setString(1, request.getParameter("COURSEID"));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("SECTIONID")));
                            pstmt.setString(3, request.getParameter("FACULTYNAME"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("ENROLLMENTLIMIT")));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM sections");
                %>
                <table>
                    <tr>
                        <th>Course ID</th>
                        <th>Section ID</th>
                        <th>Faculty Name</th>
                        <th>Enrollment Limit</th>
                    </tr>
                    <tr>
                        <form action="section_entry_form.jsp" method="post">
                            <td><input type="text" name="COURSEID" /></td>
                            <td><input type="text" name="SECTIONID" /></td>
                            <td><input type="text" name="FACULTYNAME" /></td>
                            <td><input type="text" name="ENROLLMENTLIMIT" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="section_entry_form.jsp" method="post">
                            <td><input type="hidden" name="COURSEID" value="<%= rs.getString("COURSEID") %>" /><%= rs.getString("COURSEID") %></td>
                            <td><input type="hidden" name="SECTIONID" value="<%= rs.getInt("SECTIONID") %>" /><%= rs.getInt("SECTIONID") %></td>
                            <td><input type="text" name="FACULTYNAME" value="<%= rs.getString("FACULTYNAME") %>" /></td>
                            <td><input type="text" name="ENROLLMENTLIMIT" value="<%= rs.getInt("ENROLLMENTLIMIT") %>" /></td>
                            <td>
                                <input type="submit" name="action" value="update" />
                                <input type="submit" name="action" value="delete" />
                            </td>
                        </form>
                    </tr>
                    <%
                        }
                        rs.close();
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException sqle) {
                        out.println(sqle.getMessage());
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                    %>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
