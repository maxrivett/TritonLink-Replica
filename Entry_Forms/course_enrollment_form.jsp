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
                                "UPDATE course_enrollment SET NUMUNITS = ? WHERE STUDENTID = ? AND CLASS = ? AND QUARTER = ? AND YEAR = ? AND SECTION = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("NUMUNITS")));
                            pstmt.setString(2, request.getParameter("STUDENTID"));
                            pstmt.setString(3, request.getParameter("CLASS"));
                            pstmt.setString(4, request.getParameter("QUARTER"));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
                            pstmt.setString(6, request.getParameter("SECTION"));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM course_enrollment WHERE STUDENTID = ? AND CLASS = ? AND QUARTER = ? AND YEAR = ? AND SECTION = ?");
                            pstmt.setString(1, request.getParameter("STUDENTID"));
                            pstmt.setString(2, request.getParameter("CLASS"));
                            pstmt.setString(3, request.getParameter("QUARTER"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
                            pstmt.setString(5, request.getParameter("SECTION"));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO course_enrollment (STUDENTID, CLASS, QUARTER, YEAR, SECTION, NUMUNITS) VALUES (?, ?, ?, ?, ?, ?)");
                            pstmt.setString(1, request.getParameter("STUDENTID"));
                            pstmt.setString(2, request.getParameter("CLASS"));
                            pstmt.setString(3, request.getParameter("QUARTER"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
                            pstmt.setString(5, request.getParameter("SECTION"));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("NUMUNITS")));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM course_enrollment");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Class</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Section</th>
                        <th>Number of Units</th>
                        <th>Actions</th>
                    </tr>
                    <tr>
                        <form action="course_enrollment_form.jsp" method="post">
                            <td><input type="text" name="STUDENTID" /></td>
                            <td><input type="text" name="CLASS" /></td>
                            <td><input type="text" name="QUARTER" /></td>
                            <td><input type="text" name="YEAR" /></td>
                            <td><input type="text" name="SECTION" /></td>
                            <td><input type="text" name="NUMUNITS" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="course_enrollment_form.jsp" method="post">
                            <td><input type="hidden" name="STUDENTID" value="<%= rs.getString("STUDENTID") %>" /><%= rs.getString("STUDENTID") %></td>
                            <td><input type="hidden" name="CLASS" value="<%= rs.getString("CLASS") %>" /><%= rs.getString("CLASS") %></td>
                            <td><input type="hidden" name="QUARTER" value="<%= rs.getString("QUARTER") %>" /><%= rs.getString("QUARTER") %></td>
                            <td><input type="hidden" name="YEAR" value="<%= rs.getInt("YEAR") %>" /><%= rs.getInt("YEAR") %></td>
                            <td><input type="hidden" name="SECTION" value="<%= rs.getString("SECTION") %>" /><%= rs.getString("SECTION") %></td>
                            <td><input type="text" name="NUMUNITS" value="<%= rs.getInt("NUMUNITS") %>" /></td>
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
