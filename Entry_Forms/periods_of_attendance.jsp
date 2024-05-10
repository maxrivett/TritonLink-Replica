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

                        if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM periods_of_attendance WHERE STUDENTID = ? AND STARTQTR = ? AND ENDQTR = ? AND STARTYEAR = ? AND ENDYEAR = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                            pstmt.setString(2, request.getParameter("STARTQTR"));
                            pstmt.setString(3, request.getParameter("ENDQTR"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("STARTYEAR")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("ENDYEAR")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO periods_of_attendance (STUDENTID, STARTQTR, ENDQTR, STARTYEAR, ENDYEAR) VALUES (?, ?, ?, ?, ?)");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                            pstmt.setString(2, request.getParameter("STARTQTR"));
                            pstmt.setString(3, request.getParameter("ENDQTR"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("STARTYEAR")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("ENDYEAR")));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM periods_of_attendance");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Probation Start Quarter</th>
                        <th>Probation End Quarter</th>
                        <th>Probation Start Year</th>
                        <th>Probation End Year</th>
                    </tr>
                    <tr>
                        <form action="periods_of_attendance.jsp" method="post">
                            <td><input type="text" name="STUDENTID" /></td>
                            <td><input type="text" name="STARTQTR" /></td>
                            <td><input type="text" name="ENDQTR" /></td>
                            <td><input type="text" name="STARTYEAR" /></td>
                            <td><input type="text" name="ENDYEAR" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="periods_of_attendance.jsp" method="post">
                            <td><input type="hidden" name="STUDENTID" value="<%= rs.getInt("STUDENTID") %>" /><%= rs.getInt("STUDENTID") %></td>
                            <td><input type="hidden" name="STARTQTR" value="<%= rs.getString("STARTQTR") %>" /><%= rs.getString("STARTQTR") %></td>
                            <td><input type="hidden" name="ENDQTR" value="<%= rs.getString("ENDQTR") %>" /><%= rs.getString("ENDQTR") %></td>
                            <td><input type="hidden" name="STARTYEAR" value="<%= rs.getInt("STARTYEAR") %>" /><%= rs.getInt("STARTYEAR") %></td>
                            <td><input type="hidden" name="ENDYEAR" value="<%= rs.getInt("ENDYEAR") %>" /><%= rs.getInt("ENDYEAR") %></td>
                            <td>
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
