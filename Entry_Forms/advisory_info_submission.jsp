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
                        // INSERT the advisor attrs INTO the advisors table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO advisors VALUES (?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("facultyname"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the advisor FROM the advisors table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM advisors WHERE STUDENTID = ? AND " +
                        "facultyname = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("facultyname"));


                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the advisor attributes
                    // FROM the advisors table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM advisors");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Faculty Name</th>
                    </tr>
                    <tr>
                        <form action="advisory_info_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input type="text" name="STUDENTID" size="10"></th>
                            <th><input type="text" name="facultyname" size="30"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="advisory_info_submission.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <th><input type="text" value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID"></th>
                            <th><input type="text" value="<%= rs.getString("facultyname") %>" name="facultyname"></th>
                            <th><input type="submit" value="Update"></th>
                        </form>
                        <form action="advisory_info_submission.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <th><input type="hidden" value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID"></th>
                            <th><input type="hidden" value="<%= rs.getString("facultyname") %>" name="facultyname"></th>
                            <th><input type="submit" value="Delete"></th>
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