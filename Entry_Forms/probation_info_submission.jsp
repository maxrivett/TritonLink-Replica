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
                        // INSERT the probation_info attrs INTO the probation_info table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO probation_info VALUES (?, ?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("PROBSTARTTIME"));
                        pstmt.setInt(3, request.getParameter("PROBENDTIME"));
                        pstmt.setString(4, request.getParameter("REASON"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE probation_info
                        // attributes in the probation_info table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE probation_info SET REASON = ? +
                        "WHERE STUDENTID = ?, PROBSTARTTIME = ?, PROBENDTIME = ?");

                        pstmt.setString(1, request.getParameter("REASON"));
                        pstmt.setString(2, request.getParameter("STUDENTID"));
                        pstmt.setString(3, request.getParameter("PROBSTARTTIME"));
                        pstmt.setInt(4, request.getParameter("PROBENDTIME"));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the probation_info FROM the probation_info table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM probation_info WHERE STUDENTID = ?, PROBSTARTTIME = ?, PROBENDTIME = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(1, request.getParameter("PROBSTARTTIME"));
                        pstmt.setString(1, request.getParameter("PROBENDTIME"));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the probation_info attributes
                    // FROM the probation_info table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM probation_info");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Probation Start Time</th>
                        <th>Probation End Time</th>
                        <th>Reason</th>
                    </tr>
                    <tr>
                        <form action="deg_req_info_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="PROBSTARTTIME" size="10"></th>
                            <th><input value="" name="PROBENDTIME" size="10"></th>
                            <th><input value="" name="REASON" size="100"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="probation_info_submission.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getString('STUDENTID') %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getString('PROBSTARTTIME') %>" name="PROBSTARTTIME"></th>
                        <th><input value="<%= rs.getString('PROBENDTIME') %>" name="PROBENDTIME"></th>
                        <th><input value="<%= rs.getString('REASON') %>" name="REASON"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="probation_info_submission.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString('STUDENTID') %>" name="STUDENTID">
                        <input type="hidden" value="<%= rs.getString('PROBSTARTTIME') %>" name="PROBSTARTTIME">
                        <input type="hidden" value="<%= rs.getString('PROBENDTIME') %>" name="PROBENDTIME">
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