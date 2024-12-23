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
                            boolean mandatory = "on".equals(request.getParameter("mandatory"));
                            PreparedStatement pstmt = conn.prepareStatement(
                                "UPDATE review_session_info SET type = ?, mandatory = ?, building = ?, room = ?, WEEKDAY = ? WHERE sectionid = ? AND starthour = ? AND startminute = ? AND endhour = ? AND endminute = ? AND month = ? AND day = ?");                            
                            pstmt.setString(1, request.getParameter("type"));
                            pstmt.setBoolean(2, mandatory);
                            pstmt.setString(3, request.getParameter("building"));
                            pstmt.setString(4, request.getParameter("room"));
                            pstmt.setString(5, request.getParameter("WEEKDAY"));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("sectionid")));
                            pstmt.setInt(7, Integer.parseInt(request.getParameter("starthour")));
                            pstmt.setInt(8, Integer.parseInt(request.getParameter("startminute")));
                            pstmt.setInt(9, Integer.parseInt(request.getParameter("endhour")));
                            pstmt.setInt(10, Integer.parseInt(request.getParameter("endminute")));
                            pstmt.setInt(11, Integer.parseInt(request.getParameter("month")));
                            pstmt.setInt(12, Integer.parseInt(request.getParameter("day")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM review_session_info WHERE sectionid = ? AND starthour = ? AND startminute = ? AND endhour = ? AND endminute = ? AND month = ? AND day = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("sectionid")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("starthour")));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("startminute")));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("endhour")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("endminute")));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("month")));
                            pstmt.setInt(7, Integer.parseInt(request.getParameter("day")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            boolean mandatory = "on".equals(request.getParameter("mandatory"));
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO review_session_info (sectionid, starthour, startminute, endhour, endminute, month, day, type, mandatory, building, room, WEEKDAY) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("sectionid")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("starthour")));
                            pstmt.setInt(3, Integer.parseInt(request.getParameter("startminute")));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("endhour")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("endminute")));
                            pstmt.setInt(6, Integer.parseInt(request.getParameter("month")));
                            pstmt.setInt(7, Integer.parseInt(request.getParameter("day")));
                            pstmt.setString(8, request.getParameter("type"));
                            pstmt.setBoolean(9, mandatory);
                            pstmt.setString(10, request.getParameter("building"));
                            pstmt.setString(11, request.getParameter("room"));
                            pstmt.setString(12, request.getParameter("WEEKDAY"));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM review_session_info");
                %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Start Hour</th>
                        <th>Start Minute</th>
                        <th>End Hour</th>
                        <th>End Minute</th>
                        <th>Month</th>
                        <th>Day</th>
                        <th>Type</th>
                        <th>Mandatory</th>
                        <th>Building</th>
                        <th>Room</th>
                        <th>Weekday</th>
                    </tr>
                    <tr>
                        <form action="review_session_info_submission.jsp" method="post">
                            <td><input type="text" name="sectionid" /></td>
                            <td><input type="text" name="starthour" /></td>
                            <td><input type="text" name="startminute" /></td>
                            <td><input type="text" name="endhour" /></td>
                            <td><input type="text" name="endminute" /></td>
                            <td><input type="text" name="month" /></td>
                            <td><input type="text" name="day" /></td>
                            <td><input type="text" name="type" /></td>
                            <td><input type="checkbox" name="mandatory" /></td>
                            <td><input type="text" name="building" /></td>
                            <td><input type="text" name="room" /></td>
                            <td><input type="text" name="WEEKDAY" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="review_session_info_submission.jsp" method="get">
                            <td><input type="hidden" name="sectionid" value="<%= rs.getInt("sectionid") %>" /><%= rs.getInt("sectionid") %></td>
                            <td><input type="hidden" name="starthour" value="<%= rs.getInt("starthour") %>" /><%= rs.getInt("starthour") %></td>
                            <td><input type="hidden" name="startminute" value="<%= rs.getInt("startminute") %>" /><%= rs.getInt("startminute") %></td>
                            <td><input type="hidden" name="endhour" value="<%= rs.getInt("endhour") %>" /><%= rs.getInt("endhour") %></td>
                            <td><input type="hidden" name="endminute" value="<%= rs.getInt("endminute") %>" /><%= rs.getInt("endminute") %></td>
                            <td><input type="hidden" name="month" value="<%= rs.getInt("month") %>" /><%= rs.getInt("month") %></td>
                            <td><input type="hidden" name="day" value="<%= rs.getInt("day") %>" /><%= rs.getInt("day") %></td>
                            <td><input type="text" name="type" value="<%= rs.getString("type") %>" /></td>
                            <td><input type="checkbox" name="mandatory" <%= rs.getBoolean("mandatory") ? "checked" : "" %> /></td>
                            <td><input type="text" name="building" value="<%= rs.getString("building") %>" /></td>
                            <td><input type="text" name="room" value="<%= rs.getString("room") %>" /></td>
                            <td><input type="text" name="WEEKDAY" value="<%= rs.getString("WEEKDAY") %>" /></td>
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
