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
                        // INSERT the class_section attrs INTO the class_section table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO class_section VALUES (?, ?, ?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt.setString(3, request.getParameter("QUARTER"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        PreparedStatement pstmt1 = conn.prepareStatement(
                        "DELETE FROM course_enrollment WHERE SECTIONID = ? AND " +
                        "COURSEID = ? AND QUARTER = ? AND YEAR = ?");

                        pstmt1.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt1.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt1.setString(3, request.getParameter("QUARTER"));
                        pstmt1.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

                        int rowCount = pstmt1.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM classes_taken WHERE SECTIONID = ? AND " +
                        "COURSEID = ? AND QUARTER = ? AND YEAR = ?");

                        pstmt2.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt2.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt2.setString(3, request.getParameter("QUARTER"));
                        pstmt2.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

                        rowCount = pstmt2.executeUpdate();

                        PreparedStatement pstmt3 = conn.prepareStatement(
                            "DELETE FROM course_waitlist WHERE SECTIONID = ? AND " +
                            "COURSEID = ? AND QUARTER = ? AND YEAR = ?");
    
                        pstmt3.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt3.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt3.setString(3, request.getParameter("QUARTER"));
                        pstmt3.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

                        rowCount = pstmt3.executeUpdate();

                        // Create the prepared statement and use it to
                        // DELETE the class taken FROM the class_section table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM class_section WHERE SECTIONID = ? AND " +
                        "COURSEID = ? AND QUARTER = ? AND YEAR = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt.setString(3, request.getParameter("QUARTER"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));

                        rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the class_taken attributes
                    // FROM the class_section table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM class_section");
                %>
                <table>
                    <tr>
                        <th>Section_ID</th>
                        <th>Course_ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                    </tr>
                    <tr>
                        <form action="class_section_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SECTIONID" size="10"></th>
                            <th><input value="" name="COURSEID" size="10"></th>
                            <th><input value="" name="QUARTER" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="class_section_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <td><input value="<%= rs.getInt("SECTIONID") %>"
                            name="SECTIONID"></td>
                        <td><input value="<%= rs.getInt("COURSEID") %>"
                            name="COURSEID"></td>
                        <td><input value="<%= rs.getString("QUARTER") %>"
                            name="QUARTER"></td>
                        <td><input value="<%= rs.getInt("YEAR") %>"
                            name="YEAR"></td>
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