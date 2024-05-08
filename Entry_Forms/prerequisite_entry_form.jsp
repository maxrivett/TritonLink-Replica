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
                        // INSERT the prerequisite attrs INTO the Prerequisites table
                        
                        PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO Prerequisites VALUES (?, ?)"));
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("BASECOURSE")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("PREREQUISITE")));
                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }


                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the prerequisite FROM the Prerequisites table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM Prerequisites WHERE BASECOURSE = ? AND PREREQUISITE = ?");

                        pstmt.setInt(1,
                            Integer.parseInt(request.getParameter("BASECOURSE")));
                        pstmt.setInt(2,
                            Integer.parseInt(request.getParameter("PREREQUISITE")));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the course attributes
                    // FROM the Prerequisites table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Prerequisites");
                %>
                <table>
                    <tr>
                        <th>BASECOURSE</th>
                        <th>PREREQUISITE</th>
                    </tr>
                    <tr>
                        <form action="prerequisite_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="BASECOURSE" size="10"></th>
                            <th><input value="" name="PREREQUISITE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="prerequisite_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <td><input value="<%= rs.getInt("BASECOURSE") %>"
                            name="BASECOURSE"></td>
                        <td><input value="<%= rs.getInt("PREREQUISITE") %>"
                            name="PREREQUISITE"></td>
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