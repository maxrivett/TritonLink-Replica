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
                        // INSERT the section attrs INTO the section table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO section VALUES (?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("COURSEID"));
                        pstmt.setString(2, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(3, request.getParameter("FACULTYNAME"));
                        pstmt.setInt(4, request.getParameter("ENROLLMENTLIMIT"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE section
                        // attributes in the section table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE section SET FACULTYNAME = ?, ENROLLMENTLIMIT = ? " +
                        "WHERE COURSEID = ? AND SECTIONID = ?");

                        pstmt.setString(3, request.getParameter("COURSEID"));
                        pstmt.setString(4, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(1, request.getParameter("FACULTYNAME"));
                        pstmt.setInt(2, request.getParameter("ENROLLMENTLIMIT"));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the section FROM the section table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM section WHERE COURSEID = ? AND SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("COURSEID"));
                        pstmt.setString(2, Integer.parseInt(request.getParameter("SECTIONID")));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the section attributes
                    // FROM the section table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM section");
                %>
                <table>
                    <tr>
                        <th>Course ID</th>
                        <th>Section ID</th>
                        <th>Faculty Name</th>
                        <th>Enrollment Limit</th>
                    </tr>
                    <tr>
                        <form action="section_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSEID" size="10"></th>
                            <th><input value="" name="SECTIONID" size="4"></th>
                            <th><input value="" name="FACULTYNAME" size="30"></th>
                            <th><input value="" name="ENROLLMENTLIMIT" size="4"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="section_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <td><input value="<%= rs.getString("COURSEID") %>" name="COURSEID"></td>
                        <td><input value="<%= rs.getString("SECTIONID") %>" name="SECTIONID"></td>
                        <td><input value="<%= rs.getString("FACULTYNAME") %>" name="FACULTYNAME"></td>
                        <td><input value="<%= rs.getInt("ENROLLMENTLIMIT") %>" name="ENROLLMENTLIMIT"></td>
                        <td><input type="submit" value="Update"></td>
                    </form>
                    <form action="section_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString("COURSEID") %>"
                            name="COURSEID">
                        <input type="hidden" value="<%= rs.getString("SECTIONID") %>"
                            name="SECTIONID">
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