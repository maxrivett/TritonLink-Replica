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
                        // INSERT the student attrs INTO the Student table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("FIRSTNAME"));
                        pstmt.setString(3, request.getParameter("MIDDLENAME"));
                        pstmt.setString(4, request.getParameter("LASTNAME"));
                        pstmt.setBoolean(5, Boolean.parseBoolean(request.getParameter("ENROLLED")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(7, request.getParameter("RESIDENCY"));
                        pstmt.setFloat(8, Float.parseFloat(request.getParameter("ACCOUNTBALANCE")));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE student
                        // attributes in the Student table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE Student SET FIRSTNAME = ?, MIDDLENAME = ?, LASTNAME = ?, " +
                        "ENROLLED = ?, SSN = ?, RESIDENCY = ?, ACCOUNTBALANCE = ? WHERE STUDENTID = ?");

                        pstatement.setInt(8, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstatement.setString(1, request.getParameter("FIRSTNAME"));
                        pstatement.setString(2, request.getParameter("MIDDLENAME"));
                        pstatement.setString(3, request.getParameter("LASTNAME"));
                        pstatement.setBoolean(4, Boolean.parseBoolean(request.getParameter("ENROLLED")));
                        pstatement.setInt(5, Integer.parseInt(request.getParameter("SSN")));
                        pstatement.setString(6, request.getParameter("RESIDENCY"));
                        pstatement.setFloat(7, Float.parseFloat(request.getParameter("ACCOUNTBALANCE")));

                        int rowCount = pstatement.executeUpdate();

                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM Student WHERE STUDENTID = ?");

                        pstmt.setInt(1,
                            Integer.parseInt(request.getParameter("STUDENTID")));
                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM thesis_committee WHERE STUDENTID = ?");

                        pstmt2.setInt(1,
                            Integer.parseInt(request.getParameter("STUDENTID")));
                        int rowCount = pstmt2.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the Student table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Student");
                %>
                <table>
                    <tr>
                        <th>Student_ID</th>
                        <th>First</th>
                        <th>Middle</th>
                        <th>Last</th>
                        <th>Enrolled</th>
                        <th>SSN</th>
                        <th>Residency</th>
                        <th>Account_Balance</th>
                    </tr>
                    <tr>
                        <form action="student_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="FIRSTNAME" size="10"></th>
                            <th><input value="" name="MIDDLENAME" size="10"></th>
                            <th><input value="" name="LASTNAME" size="10"></th>
                            <th><input value="" name="ENROLLED" size="10"></th>
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="RESIDENCY" size="10"></th>
                            <th><input value="" name="ACCOUNTBALANCE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="student_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt('STUDENTID') %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getBoolean('FIRSTNAME') %>" name="FIRSTNAME"></th>
                        <th><input value="<%= rs.getBoolean('MIDDLENAME') %>" name="MIDDLENAME"></th>
                        <th><input value="<%= rs.getBoolean('LASTNAME') %>" name="LASTNAME"></th>
                        <th><input value="<%= rs.getString('ENROLLED') %>" name="ENROLLED"></th>
                        <th><input value="<%= rs.getInt('SSN') %>" name="SSN"></th>
                        <th><input value="<%= rs.getInt('RESIDENCY') %>" name="RESIDENCY"></th>
                        <th><input value="<%= rs.getBoolean('ACCOUNTBALANCE') %>" name="ACCOUNTBALANCE"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="student_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt('STUDENTID') %>"
                            name="STUDENTID">
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