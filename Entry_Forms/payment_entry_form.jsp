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
                        // INSERT the payment attrs INTO the payment table

                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO payment VALUES (?, ?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("PAYNUM")));
                        pstmt.setFloat(3, Float.parseFloat(request.getParameter("PAYAMT")));

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE payment
                        // attributes in the payment table

                        PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE payment SET PAYAMT = ? " + 
                        "WHERE STUDENTID = ?, PAYNUM = ?");

                        pstmt.setInt(2, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("PAYNUM")));
                        pstmt.setFloat(1, Float.parseFloat(request.getParameter("PAYAMT")));

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the payment FROM the payment table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM payment WHERE STUDENTID = ?, PAYNUM = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("PAYNUM")));


                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the payment attributes
                    // FROM the payment table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM payment");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Payment Number</th>
                        <th>Payment Amount</th>
                    </tr>
                    <tr>
                        <form action="payment_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="PAYNUM" size="10"></th>
                            <th><input value="" name="PAYAMT" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="payment_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt('STUDENTID') %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getBoolean('PAYNUM') %>" name="PAYNUM"></th>
                        <th><input value="<%= rs.getInt('PAYAMT') %>" name="PAYAMT"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="payment_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt('STUDENTID') %>"
                            name="STUDENTID">
                            <input type="hidden" value="<%= rs.getInt('PAYNUM') %>"
                            name="PAYNUM">
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