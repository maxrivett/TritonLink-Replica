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
                                "UPDATE review_session_info SET CLASS = ?, STARTTIME = ?, ENDTIME = ?, BUILDING = ?, ROOM = ? WHERE DATE = ?");
                            pstmt.setString(1, request.getParameter("CLASS"));
                            pstmt.setString(2, request.getParameter("STARTTIME"));
                            pstmt.setString(3, request.getParameter("ENDTIME"));
                            pstmt.setString(4, request.getParameter("BUILDING"));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("ROOM")));
                            pstmt.setString(6, request.getParameter("DATE"));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM review_session_info WHERE DATE = ? AND STARTTIME = ? AND ENDTIME = ? AND BUILDING = ? AND ROOM = ?");
                            pstmt.setString(1, request.getParameter("DATE"));
                            pstmt.setString(2, request.getParameter("STARTTIME"));
                            pstmt.setString(3, request.getParameter("ENDTIME"));
                            pstmt.setString(4, request.getParameter("BUILDING"));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("ROOM")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO review_session_info (DATE, CLASS, STARTTIME, ENDTIME, BUILDING, ROOM) VALUES (?, ?, ?, ?, ?, ?)");
                            pstmt.setString(1, request.getParameter("DATE"));
                            pstmt.setString(2, request.getParameter("CLASS"));
                            pstmt.setString(3, request.getParameter("STARTTIME"));
                            pstmt.setString(4, request.getParameter("ENDTIME"));
                            pstmt.setString(5, request.getParameter("BUILDING"));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("ROOM")));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM review_session_info");
                %>
                <table>
                    <tr>
                        <th>Date</th>
                        <th>Class</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Building</th>
                        <th>Room</th>
                    </tr>
                    <tr>
                        <form action="review_session_info_submission.jsp" method="post">
                            <td><input type="text" name="DATE" /></td>
                            <td><input type="text" name="CLASS" /></td>
                            <td><input type="text" name="STARTTIME" /></td>
                            <td><input type="text" name="ENDTIME" /></td>
                            <td><input type="text" name="BUILDING" /></td>
                            <td><input type="text" name="ROOM" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="review_session_info_submission.jsp" method="post">
                            <td><input type="hidden" name="DATE" value="<%= rs.getString("DATE") %>" /><%= rs.getString("DATE") %></td>
                            <td><input type="text" name="CLASS" value="<%= rs.getString("CLASS") %>" /></td>
                            <td><input type="text" name="STARTTIME" value="<%= rs.getString("STARTTIME") %>" /></td>
                            <td><input type="text" name="ENDTIME" value="<%= rs.getString("ENDTIME") %>" /></td>
                            <td><input type="text" name="BUILDING" value="<%= rs.getString("BUILDING") %>" /></td>
                            <td><input type="text" name="ROOM" value="<%= rs.getInt("ROOM") %>" /></td>
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
