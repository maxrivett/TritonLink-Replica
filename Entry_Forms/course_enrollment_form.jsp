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
                        // INSERT the course_enrollment attrs INTO the course_enrollment table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO course_enrollment VALUES (?, ?, ?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("CLASS"));
                        pstmt.setString(3, request.getParameter("QUARTER"));
                        pstmt.setInt(4, request.getParameter("YEAR"));
                        pstmt.setString(5, request.getParameter("SECTION"));
                        pstmt.setInt(6, request.getParameter("NUMUNITS"));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE course_enrollment
                        // attributes in the course_enrollment table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE course_enrollment SET NUMUNITS = ? +
                        "WHERE STUDENTID = ?, CLASS = ?, QUARTER = ?, YEAR = ?, SECTION = ?");

                        pstmt.setInt(1, request.getParameter("NUMUNITS"));
                        pstmt.setString(2, request.getParameter("STUDENTID"));
                        pstmt.setString(3, request.getParameter("CLASS"));
                        pstmt.setString(4, request.getParameter("QUARTER"));
                        pstmt.setInt(5, request.getParameter("YEAR"));
                        pstmt.setString(6, request.getParameter("SECTION"));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the course_enrollment FROM the course_enrollment table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM course_enrollment WHERE STUDENTID = ?, CLASS = ?, QUARTER = ?, YEAR = ?, SECTION = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("CLASS"));
                        pstmt.setString(3, request.getParameter("QUARTER"));
                        pstmt.setInt(4, request.getParameter("YEAR"));
                        pstmt.setString(5, request.getParameter("SECTION"));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the course_enrollment attributes
                    // FROM the course_enrollment table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_enrollment");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Class</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Section</th>
                        <th>Number of Units</th>
                    </tr>
                    <tr>
                        <form action="course_enrollment_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="CLASS" size="20"></th>
                            <th><input value="" name="QUARTER" size="10"></th>
                            <th><input value="" name="YEAR" size="4"></th>
                            <th><input value="" name="SECTION" size="3"></th>
                            <th><input value="" name="NUMUNITS" size="1"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="course_enrollment_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getString('STUDENTID') %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getString('CLASS') %>" name="CLASS"></th>
                        <th><input value="<%= rs.getString('QUARTER') %>" name="QUARTER"></th>
                        <th><input value="<%= rs.getInt('YEAR') %>" name="YEAR"></th>
                        <th><input value="<%= rs.getString('SECTION') %>" name="SECTION"></th>
                        <th><input value="<%= rs.getInt('NUMUNITS') %>" name="NUMUNITS"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="course_enrollment_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString('STUDENTID') %>" name="STUDENTID">
                        <input type="hidden" value="<%= rs.getString('CLASS') %>" name="CLASS">
                        <input type="hidden" value="<%= rs.getString('QUARTER') %>" name="QUARTER">
                        <input type="hidden" value="<%= rs.getInt('YEAR') %>" name="YEAR">
                        <input type="hidden" value="<%= rs.getString('SECTION') %>" name="SECTION">
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