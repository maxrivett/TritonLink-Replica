<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%-- Set the scripting langauge to java and --%>
                <%-- import the java.sql package --%>
                <%@ page language="java" import="java.sql.*" %>

                <%
                    try {
                        // Load Oracle Driver class file
                        DriverManager.registerDriver
                        (new oracle.jdbc.driver.OracleDriver());

                        // Make a connection to the Oracle datasource
                        Connection conn = DriverManager.getConnection
                        ("jdbc:oracle:thin:@feast.ucsd.edu:1521:source",
                        "user", "pass");
                %>

                <%
                    // Check if an insertion is requested
                    String action = request.getParameter("action");
                    if (action != null && action.equals("insert")) {
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to 
                        // INSERT the regular_meeting attrs INTO the regular_meeting table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO regular_meeting VALUES (?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("WEEKDAY"));
                        pstmt.setString(2, request.getParameter("CLASS"));
                        pstmt.setString(3, request.getParameter("STARTTIME"));
                        pstmt.setString(4, request.getParameter("ENDTIME"));
                        pstmt.setString(5, request.getParameter("TYPE"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE regular_meeting
                        // attributes in the regular_meeting table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE regular_meeting SET TYPE = ? +
                        "WHERE WEEKDAY = ?, CLASS = ?, STARTTIME = ?, ENDTIME = ?");

                        pstmt.setString(1, request.getParameter("TYPE"));
                        pstmt.setString(2, request.getParameter("WEEKDAY"));
                        pstmt.setString(3, request.getParameter("CLASS"));
                        pstmt.setString(4, request.getParameter("STARTTIME"));
                        pstmt.setString(5, request.getParameter("ENDTIME"));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the regular_meeting FROM the regular_meeting table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM regular_meeting WHERE WEEKDAY = ?, CLASS = ?, STARTTIME = ?, ENDTIME = ?");

                        pstmt.setString(1, request.getParameter("WEEKDAY"));
                        pstmt.setString(2, request.getParameter("CLASS"));
                        pstmt.setString(3, request.getParameter("STARTTIME"));
                        pstmt.setString(4, request.getParameter("ENDTIME"));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the regular_meeting attributes
                    // FROM the regular_meeting table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM regular_meeting");
                %>
                <table>
                    <tr>
                        <th>Day of Week</th>
                        <th>Class</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Type</th>
                    </tr>
                    <tr>
                        <form action="regular_meeting_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="WEEKDAY" size="10"></th>
                            <th><input value="" name="CLASS" size="20"></th>
                            <th><input value="" name="STARTTIME" size="10"></th>
                            <th><input value="" name="ENDTIME" size="10"></th>
                            <th><input value="" name="TYPE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="regular_meeting_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getString('WEEKDAY') %>" name="WEEKDAY"></th>
                        <th><input value="<%= rs.getString('CLASS') %>" name="CLASS"></th>
                        <th><input value="<%= rs.getString('STARTTIME') %>" name="STARTTIME"></th>
                        <th><input value="<%= rs.getString('ENDTIME') %>" name="ENDTIME"></th>
                        <th><input value="<%= rs.getString('TYPE') %>" name="TYPE"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="regular_meeting_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString('WEEKDAY') %>" name="DATE">
                        <input type="hidden" value="<%= rs.getString('CLASS') %>" name="CLASS">
                        <input type="hidden" value="<%= rs.getString('STARTTIME') %>" name="STARTTIME">
                        <input type="hidden" value="<%= rs.getString('ENDTIME') %>" name="ENDTIME">
                        <td><input type="submit" value="Delete"></td>
                    </form>
                </tr>
                <%
                    }
                %>
                </table>

                <%
                    // Close the ResultSet
                    rs.close();

                    // Close the Statement
                    statement.close();

                    // Close the Connection
                    conn.close();

                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
                %>
            </td>
        </tr>
    </table>
</body>
</html>