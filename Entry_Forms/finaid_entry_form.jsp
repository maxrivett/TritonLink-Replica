<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page=""menu.html" />
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
                        // INSERT the finaid attrs INTO the finaid table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO finaid VALUES (?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("AIDNAME"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("YEAR")));
                        pstmt.setString(3, request.getParameter("TYPE"));
                        pstmt.setString(4, request.getParameter("REQUIREMENTS"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("AMOUNT")));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE finaid
                        // attributes in the finaid table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE finaid SET TYPE = ?, REQUIREMENTS = ?, " +
                        "AMOUNT = ? WHERE AIDNAME = ?, YEAR = ?");

                        pstatement.setString(4, request.getParameter("AIDNAME"));
                        pstatement.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
                        pstatement.setString(1, request.getParameter("TYPE"));
                        pstatement.setString(2, request.getParameter("REQUIREMENTS"));
                        pstatement.setInt(3, Integer.parseInt(request.getParameter("AMOUNT")));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the finaid FROM the finaid table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM finaid WHERE AIDNAME = ?, YEAR = ?");

                        pstmt.setString(1, request.getParameter("AIDNAME"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("YEAR")));

                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM aid_awarded WHERE AIDNAME = ?, YEAR = ?");

                        pstmt2.setString(1, request.getParameter("AIDNAME"));
                        pstmt2.setInt(2, Integer.parseInt(request.getParameter("YEAR")));

                        pstmt2.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the finaid attributes
                    // FROM the finaid table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM finaid");
                %>
                <table>
                    <tr>
                        <th>Aid Name</th>
                        <th>Aid Year</th>
                        <th>Aid Type</th>
                        <th>Aid Requirements</th>
                        <th>Aid Amount</th>
                    </tr>
                    <tr>
                        <form action="finaid_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="AIDNAME" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input value="" name="TYPE" size="10"></th>
                            <th><input value="" name="REQUIREMENTS" size="10"></th>
                            <th><input value="" name="AMOUNT" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="finaid_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt('AIDNAME') %>" name="AIDNAME"></th>
                        <th><input value="<%= rs.getBoolean('YEAR') %>" name="YEAR"></th>
                        <th><input value="<%= rs.getBoolean('TYPE') %>" name="TYPE"></th>
                        <th><input value="<%= rs.getBoolean('REQUIREMENTS') %>" name="REQUIREMENTS"></th>
                        <th><input value="<%= rs.getBoolean('AMOUNT') %>" name="AMOUNT"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="finaid_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt('AIDNAME') %>"
                            name="AIDNAME">
                        <input type="hidden" value="<%= rs.getInt('YEAR') %>"
                            name="YEAR">
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