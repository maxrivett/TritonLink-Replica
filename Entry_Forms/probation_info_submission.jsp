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
                        // DriverManager.registerDriver
                        // (new oracle.jdbc.driver.OracleDriver());

                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres" + 
                            "&password=HPost1QGres!&ssl=false";

                        // Make a connection to the Oracle datasource
                        Connection conn = DriverManager.getConnection(url);
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
                        pstmt.setString(2, request.getParameter("STARTQUARTER"));
                        pstmt.setString(3, request.getParameter("ENDQUARTER"));
                        pstmt.setInt(4, request.getParameter("STARTYEAR"));
                        pstmt.setInt(5, request.getParameter("ENDYEAR"));
                        pstmt.setString(6, request.getParameter("REASON"));

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
                        "WHERE STUDENTID = ? AND STARTQUARTER = ? AND ENDQUARTER = ? AND STARTYEAR = ? AND ENDYEAR = ?");

                        pstmt.setString(1, request.getParameter("REASON"));
                        pstmt.setString(2, request.getParameter("STUDENTID"));
                        pstmt.setString(3, request.getParameter("STARTQUARTER"));
                        pstmt.setString(4, request.getParameter("ENDQUARTER"));
                        pstmt.setInt(5, request.getParameter("STARTYEAR"));
                        pstmt.setInt(6, request.getParameter("ENDYEAR"));

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
                        "DELETE FROM probation_info WHERE STUDENTID = ? AND STARTQUARTER = ? AND ENDQUARTER = ? AND STARTYEAR = ? AND ENDYEAR = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("STARTQUARTER"));
                        pstmt.setString(3, request.getParameter("ENDQUARTER"));
                        pstmt.setInt(4, request.getParameter("STARTYEAR"));
                        pstmt.setInt(5, request.getParameter("ENDYEAR"));

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
                        <th>Probation Start Quarter</th>
                        <th>Probation End Quarter</th>
                        <th>Probation Start Year</th>
                        <th>Probation End Year</th>
                        <th>Reason</th>
                    </tr>
                    <tr>
                        <form action="probation_info_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="STARTQUARTER" size="10"></th>
                            <th><input value="" name="ENDQUARTER" size="10"></th>
                            <th><input value="" name="STARTYEAR" size="4"></th>
                            <th><input value="" name="ENDYEAR" size="4"></th>
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
                        <th><input value="<%= rs.getString('STARTQUARTER') %>" name="STARTQUARTER"></th>
                        <th><input value="<%= rs.getString('ENDQUARTER') %>" name="ENDQUARTER"></th>
                        <th><input value="<%= rs.getInt('STARTYEAR') %>" name="STARTYEAR"></th>
                        <th><input value="<%= rs.getInt('ENDYEAR') %>" name="ENDYEAR"></th>
                        <th><input value="<%= rs.getString('REASON') %>" name="REASON"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="probation_info_submission.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString('STUDENTID') %>" name="STUDENTID">
                        <input type="hidden" value="<%= rs.getString('STARTQUARTER') %>" name="STARTQUARTER">
                        <input type="hidden" value="<%= rs.getString('ENDQUARTER') %>" name="ENDQUARTER">
                        <input type="hidden" value="<%= rs.getInt('STARTYEAR') %>" name="STARTYEAR">
                        <input type="hidden" value="<%= rs.getInt('ENDYEAR') %>" name="ENDYEAR">
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