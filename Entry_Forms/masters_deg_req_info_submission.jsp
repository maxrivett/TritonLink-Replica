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
                        // INSERT the degree attrs INTO the degree table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO degree VALUES (?, ?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("DEGTYPE"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("TOTALUNITS")));

                        pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        ("INSERT INTO masters_deg VALUES (?)"));

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));

                        pstmt2.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE degree
                        // attributes in the degree table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE degree SET DEGTYPE = ?, TOTALUNITS = ? " +
                        "WHERE DEPARTMENT = ?");

                        pstatement.setString(3, request.getParameter("DEPARTMENT"));
                        pstatement.setString(1, request.getParameter("DEGTYPE"));
                        pstatement.setInt(2, Integer.parseInt(request.getParameter("TOTALUNITS")));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the degree FROM the degree table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM degree WHERE DEPARTMENT = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));

                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM categories WHERE DEPARTMENT = ?");

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));

                        pstmt2.executeUpdate();

                        PreparedStatement pstmt3 = conn.prepareStatement(
                        "DELETE FROM masters_deg WHERE DEPARTMENT = ?");

                        pstmt3.setString(1, request.getParameter("DEPARTMENT"));

                        pstmt3.executeUpdate();

                        PreparedStatement pstmt4 = conn.prepareStatement(
                        "DELETE FROM concentrations WHERE DEPARTMENT = ?");

                        pstmt4.setString(1, request.getParameter("DEPARTMENT"));

                        pstmt4.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the degree attributes
                    // FROM the degree table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM masters_deg");
                %>
                <table>
                    <tr>
                        <th>Department</th>
                        <th>Degree Type</th>
                        <th>Total Units</th>
                    </tr>
                    <tr>
                        <form action="masters_deg_req_info_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPARTMENT" size="10"></th>
                            <th><input value="" name="DEGTYPE" size="10"></th>
                            <th><input value="" name="TOTALUNITS" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                        PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT * FROM degree WHERE DEPARTMENT = ?");

                        pstmt.setString(1, rs.getString("DEPARTMENT"));

                        ResultSet rs2 = pstmt.executeQuery();
                %>
                <tr>
                    <form action="masters_deg_req_info_submission.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs2.getString("DEPARTMENT") %>" name="DEPARTMENT"></th>
                        <th><input value="<%= rs2.getString("DEGTYPE") %>" name="DEGTYPE"></th>
                        <th><input value="<%= rs2.getInt("TOTALUNITS") %>" name="TOTALUNITS"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="masters_deg_req_info_submission.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString("DEPARTMENT") %>"
                            name="DEPARTMENT">
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