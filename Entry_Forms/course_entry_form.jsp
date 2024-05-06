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
                        // INSERT the course attrs INTO the Course table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"));

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt.setBoolean(2, Boolean.parseBoolean(request.getParameter("LABREQ")));
                        pstmt.setBoolean(3, Boolean.parseBoolean(request.getParameter("SUALLOW")));
                        pstmt.setBoolean(4, Boolean.parseBoolean(request.getParameter("LETTERGRADE")));
                        pstmt.setString(5, request.getParameter("COURSENUM"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("UNITMIN")));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("UNITMAX")));
                        pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("INSTPERM")));

                        pstmt.executeUpdate();


                        
                        String[] prereq_array = request.getParameter("PREREQUISITES").split(",");

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        ("INSERT INTO Prerequisites VALUES (?, ?)"));

                        for (int i = 0; i < prereq_array.length; i++) {
                            pstmt2.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));
                            pstmt2.setInt(2, Integer.parseInt(prereq_array[i]));
                        }

                        pstmt2.executeUpdate();

                        if (Boolean.parseBoolean(request.getParameter("LABREQ"))) {
                            PreparedStatement pstmt3 = conn.prepareStatement(
                            ("INSERT INTO Corequisites VALUES (?, ?)"));

                            pstmt3.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));
                            pstmt3.setInt(2, Integer.parseInt(request.getParameter("COREQUISITE")));

                            pstmt3.executeUpdate();

                        }

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE course
                        // attributes in the Course table
                        PreparedStatement pstatement = conn.prepareStatement(
                        "UPDATE Course SET LABREQ = ?, SUALLOW = ?, LETTERGRADE = ?, COURSENUM = ?, " +
                        "UNITMIN = ?, UNITMAX = ?, INSTPERM = ? WHERE COURSEID = ?");

                        pstatement.setInt(8, Integer.parseInt(request.getParameter("COURSEID")));
                        pstatement.setBoolean(1, Boolean.parseBoolean(request.getParameter("LABREQ")));
                        pstatement.setBoolean(2, Boolean.parseBoolean(request.getParameter("SUALLOW")));
                        pstatement.setBoolean(3, Boolean.parseBoolean(request.getParameter("LETTERGRADE")));
                        pstatement.setString(4, request.getParameter("COURSENUM"));
                        pstatement.setInt(5, Integer.parseInt(request.getParameter("UNITMIN")));
                        pstatement.setInt(6, Integer.parseInt(request.getParameter("UNITMAX")));
                        pstatement.setBoolean(7, Boolean.parseBoolean(request.getParameter("INSTPERM")));

                        int rowCount = pstatement.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        ("DELETE FROM Prerequisites WHERE BASECOURSE = ?"));

                        pstmt2.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt2.executeUpdate();

                        
                        String[] prereq_array = request.getParameter("PREREQUISITES").split(",");
                        
                        PreparedStatement pstmt3 = conn.prepareStatement(
                        ("INSERT INTO Prerequisites VALUES (?, ?)"));
                        

                        for (int i = 0; i < prereq_array.length; i++) {
                            pstmt3.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));
                            pstmt3.setInt(2, Integer.parseInt(prereq_array[i]));
                        }

                        pstmt3.executeUpdate();

                        PreparedStatement pstmt4 = conn.prepareStatement(
                        ("DELETE FROM Corequisites WHERE BASECOURSE = ?"));

                        pstmt4.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt4.executeUpdate();

                        if (Boolean.parseBoolean(request.getParameter("LABREQ"))) {
                            PreparedStatement pstmt5 = conn.prepareStatement(
                            ("INSERT INTO Corequisites VALUES (?, ?)"));

                            pstmt5.setInt(1, Integer.parseInt(request.getParameter("COURSEID")));
                            pstmt5.setInt(2, Integer.parseInt(request.getParameter("COREQUISITE")));

                            pstmt5.executeUpdate();

                        }

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the course FROM the Course table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM Course WHERE COURSEID = ?");

                        pstmt.setInt(1,
                            Integer.parseInt(request.getParameter("COURSEID")));
                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM Prerequisites WHERE BASECOURSE = ?");

                        pstmt2.setInt(1,
                            Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt2.executeUpdate();

                        PreparedStatement pstmt3 = conn.prepareStatement(
                        "DELETE FROM Corequisites WHERE COURSEID = ?");

                        pstmt3.setInt(1,
                            Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt3.executeUpdate();

                        PreparedStatement pstmt4 = conn.prepareStatement(
                        "DELETE FROM classes WHERE COURSEID = ?");

                        pstmt4.setInt(1,
                            Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt4.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the course attributes
                    // FROM the Course table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Course");
                %>
                <table>
                    <tr>
                        <th>Course_ID</th>
                        <th>Lab Required?</th>
                        <th>S/U Allowed?</th>
                        <th>Letter Grade Allowed?</th>
                        <th>Course Nu,</th>
                        <th>Units Minimum</th>
                        <th>Units Maximum</th>
                        <th>Instructor Permission</th>
                        <th>Prerequisites</th>
                    </tr>
                    <tr>
                        <form action="course_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSEID" size="10"></th>
                            <th><input value="" name="LABREQ" size="10"></th>
                            <th><input value="" name="SUALLOW" size="10"></th>
                            <th><input value="" name="LETTERGRADE" size="10"></th>
                            <th><input value="" name="COURSENUM" size="10"></th>
                            <th><input value="" name="UNITMIN" size="10"></th>
                            <th><input value="" name="UNITMAX" size="10"></th>
                            <th><input value="" name="INSTPERM" size="10"></th>
                            <th><input value="" name="PREREQUISITES" size="10"></th>
                            <th><input value="" name="COREQUISITE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="course_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <td><input value="<%= rs.getInt("COURSEID") %>" name="COURSEID"></td>
                        <td><input value="<%= rs.getBoolean("LABREQ") %>" name="LABREQ"></td>
                        <td><input value="<%= rs.getBoolean("SUALLOW") %>" name="SUALLOW"></td>
                        <td><input value="<%= rs.getBoolean("LETTERGRADE") %>" name="LETTERGRADE"></td>
                        <td><input value="<%= rs.getString("COURSENUM") %>" name="COURSENUM"></td>
                        <td><input value="<%= rs.getInt("UNITMIN") %>" name="UNITMIN"></td>
                        <td><input value="<%= rs.getInt("UNITMAX") %>" name="UNITMAX"></td>
                        <td><input value="<%= rs.getBoolean("INSTPERM") %>" name="INSTPERM"></td>
                        <td><input value="<%= rs.getString("PREREQUISITES") %>" name="PREREQUISITES"></td>
                        <td><input value="<%= rs.getString("COREQUISITE") %>" name="COREQUISITE"></td>
                        <td><input type="submit" value="Update"></td>
                    </form>
                    <form action="course_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt("COURSEID") %>"
                            name="COURSEID">
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