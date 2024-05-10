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
                        // INSERT the category_courses attrs INTO the category_courses table
                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO category_courses VALUES (?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("CATNAME"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSEID")));

                        pstmt.executeUpdate();

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the category_courses FROM the category_courses table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM category_courses WHERE DEPARTMENT = ? AND " +
                        "CATNAME = ? AND COURSEID = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("CATNAME"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSEID")));


                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the category_courses attributes
                    // FROM the category_courses table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM category_courses");
                %>
                <table>
                    <tr>
                        <th>Department</th>
                        <th>Category Name</th>
                        <th>Course ID</th>
                    </tr>
                    <tr>
                        <form action="category_courses_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <td><input value="" name="DEPARTMENT" size="10"></td>
                            <td><input value="" name="CATNAME" size="10"></td>
                            <td><input value="" name="COURSEID" size="10"></td>
                            <td><input type="submit" value="Insert"></td>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="category_courses_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <td><input value="<%= rs.getString("DEPARTMENT") %>"
                            name="DEPARTMENT"></td>
                        <td><input value="<%= rs.getString("CATNAME") %>"
                            name="CATNAME"></td>
                        <td><input value="<%= rs.getInt("COURSEID") %>"
                            name="COURSEID"></td>
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