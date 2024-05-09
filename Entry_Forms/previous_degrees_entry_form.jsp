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
                        // INSERT the previous degree attrs INTO the previous degrees table

                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO previous_degrees VALUES (?, ?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("PREVUNI").strip());
                        pstmt.setString(3, request.getParameter("PREVDEG").strip());

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the previous_degrees FROM the previous_degrees table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM previous_degrees WHERE STUDENTID = ? AND PREVUNI = ? AND PREVDEG = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("PREVUNI"));
                        pstmt.setString(3, request.getParameter("PREVDEG"));


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
                        ("SELECT * FROM previous_degrees");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Previous University</th>
                        <th>Previous Degree</th>
                    </tr>
                    <tr>
                        <form action="previous_degrees_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="PREVUNI" size="10"></th>
                            <th><input value="" name="PREVDEG" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="previous_degrees_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <td><input value="<%= rs.getInt("STUDENTID") %>"
                            name="STUDENTID">
                        <td><input value="<%= rs.getString("PREVUNI") %>"
                            name="PREVUNI"></td>
                        <td><input value="<%= rs.getString("PREVDEG") %>"
                            name="PREVDEG"></td>
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