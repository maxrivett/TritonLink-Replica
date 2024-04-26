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
                        // INSERT the category attrs INTO the category table

                        String[] courses = request.getParameter("COURSES").split(",");

                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO category VALUES (?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("CATNAME"));
                        pstmt.setFloat(3, Float.parseFloat(request.getParameter("CATGPA")));
                        pstmt.setInteger(4, Integer.parseInt(request.getParameter("CATUNITS")));
                        

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        ("INSERT INTO category_courses VALUES (?, ?)"));

                        for (int i = 0; i < courses.length; i++) {
                            pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                            pstmt2.setString(2, request.getParameter("CATNAME"));
                            pstmt2.setInt(3, courses[i]);

                            pstmt2.executeUpdate();
                        }

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE category
                        // attributes in the category table

                        String[] courses = request.getParameter("COURSES").split(",");

                        PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE category SET CATGPA = ?, CATUNITS = ? " + 
                        "WHERE DEPARTMENT = ?, CATNAME = ?");

                        pstmt.setString(3, request.getParameter("DEPARTMENT"));
                        pstmt.setString(4, request.getParameter("CATNAME"));
                        pstmt.setFloat(1, Float.parseFloat(request.getParameter("CATGPA")));
                        pstmt.setInteger(2, Integer.parseInt(request.getParameter("CATUNITS")));

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM category_courses WHERE DEPARTMENT = ?, CATNAME = ?");

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt2.setString(2, request.getParameter("CATNAME"));

                        pstmt2.executeUpdate();
                        

                        PreparedStatement pstmt3 = conn.prepareStatement(
                        ("INSERT INTO category_courses VALUES (?, ?)"));

                        for (int i = 0; i < courses.length; i++) {
                            pstmt3.setString(1, request.getParameter("DEPARTMENT"));
                            pstmt3.setString(2, request.getParameter("CATNAME"));
                            pstmt3.setInt(3, courses[i]);

                            pstmt3.executeUpdate();
                        }



                        conn.setAutocommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the category FROM the category table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM category WHERE DEPARTMENT = ?, CATNAME = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("DEPARTMENT")));
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("CATNAME")));


                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "DELETE FROM category_courses WHERE DEPARTMENT = ?, CATNAME = ?");

                        pstmt2.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt2.setString(2, request.getParameter("CATNAME"));

                        pstmt2.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the thesis_committee attributes
                    // FROM the thesis_committee table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM category");
                %>
                <table>
                    <tr>
                        <th>Department</th>
                        <th>Category Name</th>
                        <th>Category GPA</th>
                        <th>Category Units</th>
                        <th>Category Courses</th>
                    </tr>
                    <tr>
                        <form action="category_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPARTMENT" size="10"></th>
                            <th><input value="" name="CATNAME" size="10"></th>
                            <th><input value="" name="CATGPA" size="10"></th>
                            <th><input value="" name="CATUNITS" size="10"></th>
                            <th><input value="" name="COURSES" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="category_entry_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt('DEPARTMENT') %>" name="DEPARTMENT"></th>
                        <th><input value="<%= rs.getBoolean('CATNAME') %>" name="CATNAME"></th>
                        <th><input value="<%= rs.getInt('CATGPA') %>" name="CATGPA"></th>
                        <th><input value="<%= rs.getBoolean('CATUNITS') %>" name="CATUNITS"></th>
                        <th><input value="<%= rs.getInt('COURSES') %>" name="COURSES"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="category_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt('DEPARTMENT') %>"
                            name="DEPARTMENT">
                            <input type="hidden" value="<%= rs.getInt('CATNAME') %>"
                            name="CATNAME">
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