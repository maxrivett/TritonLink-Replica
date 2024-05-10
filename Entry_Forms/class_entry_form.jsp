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
                                "UPDATE Classes SET title = ? WHERE courseid = ? AND quarter = ? AND year = ?");
                            pstmt.setString(1, request.getParameter("title"));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("courseid")));
                            pstmt.setString(3, request.getParameter("quarter"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM Classes WHERE courseid = ? AND quarter = ? AND year = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("courseid")));
                            pstmt.setString(2, request.getParameter("quarter"));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO Classes (courseid, quarter, year, title) VALUES (?, ?, ?, ?)");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("courseid")));
                            pstmt.setString(2, request.getParameter("quarter"));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                            pstmt.setString(4, request.getParameter("title"));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM Classes");
                %>
                <table>
                    <tr>
                        <th>Course ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Title</th>
                    </tr>
                    <tr>
                        <form action="class_entry_form.jsp" method="post">
                            <td><input type="text" name="courseid" /></td>
                            <td><input type="text" name="quarter" /></td>
                            <td><input type="text" name="year" /></td>
                            <td><input type="text" name="title" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="class_entry_form.jsp" method="post">
                            <td><input type="hidden" name="courseid" value="<%= rs.getInt("courseid") %>" /><%= rs.getInt("courseid") %></td>
                            <td><input type="hidden" name="quarter" value="<%= rs.getString("quarter") %>" /><%= rs.getString("quarter") %></td>
                            <td><input type="hidden" name="year" value="<%= rs.getInt("year") %>" /><%= rs.getInt("year") %></td>
                            <td><input type="text" name="title" value="<%= rs.getString("title") %>" /></td>
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
