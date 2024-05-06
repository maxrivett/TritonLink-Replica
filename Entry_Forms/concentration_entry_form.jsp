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
                        // INSERT the concentration attrs INTO the concentration table

                        String[] courses = request.getParameter("COURSES").split(",");

                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO category VALUES (?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("CONNAME"));
                        pstmt.setFloat(3, Float.parseFloat(request.getParameter("CONGPA")));
                        pstmt.setInteger(4, Integer.parseInt(request.getParameter("CONUNITS")));
                        

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        ("INSERT INTO concentration_courses VALUES (?, ?)"));

                        for (int i = 0; i < courses.length; i++) {
                            pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                            pstmt2.setString(2, request.getParameter("CONNAME"));
                            pstmt2.setInt(3, courses[i]);

                            pstmt2.executeUpdate();
                        }

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE concentration
                        // attributes in the concentration table

                        String[] courses = request.getParameter("COURSES").split(",");

                        PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE concentration SET CONGPA = ?, CONUNITS = ? " + 
                        "WHERE DEPARTMENT = ? AND CONNAME = ?");

                        pstmt.setString(3, request.getParameter("DEPARTMENT"));
                        pstmt.setString(4, request.getParameter("CONNAME"));
                        pstmt.setFloat(1, Float.parseFloat(request.getParameter("CONGPA")));
                        pstmt.setInteger(2, Integer.parseInt(request.getParameter("CONUNITS")));

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM concentration_courses WHERE DEPARTMENT = ? AND CONNAME = ?");

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt2.setString(2, request.getParameter("CONNAME"));

                        pstmt2.executeUpdate();
                        

                        PreparedStatement pstmt3 = conn.prepareStatement(
                        ("INSERT INTO concentration_courses VALUES (?, ?)"));

                        for (int i = 0; i < courses.length; i++) {
                            pstmt3.setString(1, request.getParameter("DEPARTMENT"));
                            pstmt3.setString(2, request.getParameter("CONNAME"));
                            pstmt3.setInt(3, courses[i]);

                            pstmt3.executeUpdate();
                        }



                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the concentration FROM the concentration table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM concentration WHERE DEPARTMENT = ?, CONNAME = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("DEPARTMENT")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("CONNAME")));


                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM concentration_courses WHERE DEPARTMENT = ?, CONNAME = ?");

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt2.setString(2, request.getParameter("CONNAME"));

                        pstmt2.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the concentration attributes
                    // FROM the concentration table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM concentration");
                %>
                <table>
                    <tr>
                        <th>Department</th>
                        <th>Concentration Name</th>
                        <th>Concentration GPA</th>
                        <th>Concentration Units</th>
                        <th>Concentration Courses</th>
                    </tr>
                    <tr>
                        <form action="concentration_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPARTMENT" size="10"></th>
                            <th><input value="" name="CONNAME" size="10"></th>
                            <th><input value="" name="CONGPA" size="10"></th>
                            <th><input value="" name="CONUNITS" size="10"></th>
                            <th><input value="" name="COURSES" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="concentration_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt("DEPARTMENT") %>" name="DEPARTMENT"></th>
                        <th><input value="<%= rs.getBoolean("CONNAME") %>" name="CONNAME"></th>
                        <th><input value="<%= rs.getInt("CONGPA") %>" name="CONGPA"></th>
                        <th><input value="<%= rs.getBoolean("CONUNITS") %>" name="CONUNITS"></th>
                        <th><input value="<%= rs.getInt("COURSES") %>" name="COURSES"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="concentration_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt("DEPARTMENT") %>"
                            name="DEPARTMENT">
                            <input type="hidden" value="<%= rs.getInt("CONNAME") %>"
                            name="CONNAME">
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