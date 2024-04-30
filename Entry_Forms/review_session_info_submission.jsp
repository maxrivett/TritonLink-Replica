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
                        // INSERT the review_session_info attrs INTO the review_session_info table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO review_session_info VALUES (?, ?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DATE"));
                        pstmt.setString(2, request.getParameter("CLASS"));
                        pstmt.setString(3, request.getParameter("STARTTIME"));
                        pstmt.setString(4, request.getParameter("ENDTIME"));
                        pstmt.setString(5, request.getParameter("BUILDING"));
                        pstmt.setInt(6, request.getParameter("ROOM"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE review_session_info
                        // attributes in the review_session_info table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE review_session_info SET CLASS = ? +
                        "WHERE DATE = ?, STARTTIME = ?, ENDTIME = ?, BUILDING = ?, ROOM = ?");

                        pstmt.setString(1, request.getParameter("CLASS"));
                        pstmt.setString(2, request.getParameter("DATE"));
                        pstmt.setString(3, request.getParameter("STARTTIME"));
                        pstmt.setString(4, request.getParameter("ENDTIME"));
                        pstmt.setString(5, request.getParameter("BUILDING"));
                        pstmt.setInt(6, request.getParameter("ROOM"));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the review_session_info FROM the review_session_info table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM review_session_info WHERE DATE = ?, STARTTIME = ?, ENDTIME = ?, BUILDING = ?, ROOM = ?");

                        pstmt.setString(1, request.getParameter("DATE"));
                        pstmt.setString(1, request.getParameter("STARTTIME"));
                        pstmt.setString(1, request.getParameter("ENDTIME"));
                        pstmt.setString(1, request.getParameter("BUILDING"));
                        pstmt.setInt(1, request.getParameter("ROOM"));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the review_session_info attributes
                    // FROM the review_session_info table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM review_session_info");
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
                        <form action="review_session_info_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DATE" size="10"></th>
                            <th><input value="" name="CLASS" size="10"></th>
                            <th><input value="" name="STARTTIME" size="10"></th>
                            <th><input value="" name="ENDTIME" size="10"></th>
                            <th><input value="" name="BUILDING" size="30"></th>
                            <th><input value="" name="ROOM" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="review_session_info_submission.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getString('DATE') %>" name="DATE"></th>
                        <th><input value="<%= rs.getString('CLASS') %>" name="CLASS"></th>
                        <th><input value="<%= rs.getString('STARTTIME') %>" name="STARTTIME"></th>
                        <th><input value="<%= rs.getString('ENDTIME') %>" name="ENDTIME"></th>
                        <th><input value="<%= rs.getString('BUILDING') %>" name="BUILDING"></th>
                        <th><input value="<%= rs.getInt('ROOM') %>" name="ROOM"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="review_session_info_submission.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString('DATE') %>" name="DATE">
                        <input type="hidden" value="<%= rs.getString('STARTTIME') %>" name="STARTTIME">
                        <input type="hidden" value="<%= rs.getString('ENDTIME') %>" name="ENDTIME">
                        <input type="hidden" value="<%= rs.getString('BUILDING') %>" name="BUILDING">
                        <input type="hidden" value="<%= rs.getInt('ROOM') %>" name="ROOM">
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