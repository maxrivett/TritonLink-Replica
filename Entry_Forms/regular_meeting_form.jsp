<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%-- Set the scripting language to java and import the java.sql package --%>
                <%@ page language="java" import="java.sql.*" %>

                <%
                    Connection conn;
                    try {
                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=HPost1QGres!&ssl=false";
                        conn = DriverManager.getConnection(url);
                %>

                <%
                    // Check if an action is requested
                    String action = request.getParameter("action");
                    if ("insert".equals(action)) {
                        conn.setAutoCommit(false);
                        boolean mandatory = "on".equals(request.getParameter("mandatory"));
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO regular_meeting (SECTIONID, STARTHOUR, STARTMINUTE, ENDHOUR, ENDMINUTE, WEEKDAY, TYPE, MANDATORY, BUILDING, ROOM) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("STARTHOUR")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("STARTMINUTE")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("ENDHOUR")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("ENDMINUTE")));
                        pstmt.setString(6, request.getParameter("WEEKDAY"));
                        pstmt.setString(7, request.getParameter("TYPE"));
                        pstmt.setBoolean(8, mandatory);
                        pstmt.setString(9, request.getParameter("BUILDING"));
                        pstmt.setString(10, request.getParameter("ROOM"));
                        pstmt.executeUpdate();
                        conn.commit();
                        conn.setAutoCommit(true);
                    } else if ("update".equals(action)) {
                        conn.setAutoCommit(false);
                        boolean mandatory = "on".equals(request.getParameter("mandatory"));
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE regular_meeting SET TYPE = ?, MANDATORY = ?, BUILDING = ?, ROOM = ? WHERE SECTIONID = ? AND STARTHOUR = ? AND STARTMINUTE = ? AND ENDHOUR = ? AND ENDMINUTE = ? AND WEEKDAY = ?");
                        pstmt.setString(1, request.getParameter("TYPE"));
                        pstmt.setBoolean(2, mandatory);
                        pstmt.setString(3, request.getParameter("BUILDING"));
                        pstmt.setString(4, request.getParameter("ROOM"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("STARTHOUR")));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("STARTMINUTE")));
                        pstmt.setInt(8, Integer.parseInt(request.getParameter("ENDHOUR")));
                        pstmt.setInt(9, Integer.parseInt(request.getParameter("ENDMINUTE")));
                        pstmt.setString(10, request.getParameter("WEEKDAY"));
                        pstmt.executeUpdate();
                        conn.commit();
                        conn.setAutoCommit(true);
                    } else if ("delete".equals(action)) {
                        conn.setAutoCommit(false);

                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM regular_meeting WHERE SECTIONID = ? AND STARTHOUR = ? AND STARTMINUTE = ? AND ENDHOUR = ? AND ENDMINUTE = ? AND WEEKDAY = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("STARTHOUR")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("STARTMINUTE")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("ENDHOUR")));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("ENDMINUTE")));
                        pstmt.setString(6, request.getParameter("WEEKDAY"));
                        pstmt.executeUpdate();
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    Statement statement = conn.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM regular_meeting");
                %>
                <table>
                    <tr>
                        <th>Section ID</th>
                        <th>Start Hour</th>
                        <th>Start Minute</th>
                        <th>End Hour</th>
                        <th>End Minute</th>
                        <th>Weekday</th>
                        <th>Type</th>
                        <th>Mandatory</th>
                        <th>Building</th>
                        <th>Room</th>
                    </tr>
                    <tr>
                        <form action="regular_meeting_form.jsp" method="post">
                            <input type="hidden" value="insert" name="action">
                            <td><input type="text" name="SECTIONID"></td>
                            <td><input type="text" name="STARTHOUR"></td>
                            <td><input type="text" name="STARTMINUTE"></td>
                            <td><input type="text" name="ENDHOUR"></td>
                            <td><input type="text" name="ENDMINUTE"></td>
                            <td><input type="text" name="WEEKDAY"></td>
                            <td><input type="text" name="TYPE"></td>
                            <td><input type="checkbox" name="mandatory"></td>
                            <td><input type="text" name="BUILDING"></td>
                            <td><input type="text" name="ROOM"></td>
                            <td><input type="submit" value="Insert"></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="regular_meeting_form.jsp" method="get">
                            <td><input type="hidden" name="SECTIONID" value="<%= rs.getInt("SECTIONID") %>" /><%= rs.getInt("sectionid") %></td>
                            <td><input type="hidden" name="STARTHOUR" value="<%= rs.getInt("STARTHOUR") %>" /><%= rs.getInt("starthour") %></td>
                            <td><input type="hidden" name="STARTMINUTE" value="<%= rs.getInt("STARTMINUTE") %>" /><%= rs.getInt("startminute") %></td>
                            <td><input type="hidden" name="ENDHOUR" value="<%= rs.getInt("ENDHOUR") %>" /><%= rs.getInt("endhour") %></td>
                            <td><input type="hidden" name="ENDMINUTE" value="<%= rs.getInt("ENDMINUTE") %>" /><%= rs.getInt("endminute") %></td>
                            <td><input type="hidden" name="WEEKDAY" value="<%= rs.getString("WEEKDAY") %>" /><%= rs.getString("weekday") %></td>
                            <td><input type="text" name="TYPE" value="<%= rs.getString("TYPE") %>" /></td>
                            <td><input type="checkbox" name="mandatory" <%= rs.getBoolean("mandatory") ? "checked" : "" %> /></td>
                            <td><input type="text" name="BUILDING" value="<%= rs.getString("BUILDING") %>" /></td>
                            <td><input type="text" name="ROOM" value="<%= rs.getString("ROOM") %>" /></td>
                            <td>
                                <input type="submit" name="action" value="update" />
                                <input type="submit" name="action" value="delete" />
                            </td>
                        </form>
                    </tr>
                    <%
                        }
                        rs.close();
                        statement.close();
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
