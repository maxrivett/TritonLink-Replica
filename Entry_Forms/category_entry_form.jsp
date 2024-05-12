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
                        // INSERT the category attrs INTO the categories table

                        PreparedStatement pstmt = conn.prepareStatement(
                        ("INSERT INTO categories VALUES (?, ?, ?, ?)"));

                        pstmt.setString(1, request.getParameter("DEPARTMENT").strip());
                        pstmt.setString(2, request.getParameter("CATNAME"));
                        pstmt.setFloat(3, Float.parseFloat(request.getParameter("CATGPA")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("CATUNITS")));

                        pstmt.executeUpdate();
                        

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE category
                        // attributes in the categories table

                        PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE categories SET CATGPA = ?, CATUNITS = ? " + 
                        "WHERE DEPARTMENT = ? AND CATNAME = ?");

                        pstmt.setString(3, request.getParameter("DEPARTMENT"));
                        pstmt.setString(4, request.getParameter("CATNAME"));
                        pstmt.setFloat(1, Float.parseFloat(request.getParameter("CATGPA")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("CATUNITS")));

                        int rowCount = pstmt.executeUpdate();



                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the category FROM the categories table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM categories WHERE DEPARTMENT = ? AND CATNAME = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("CATNAME"));


                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the category attributes
                    // FROM the categories table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM categories");
                %>
                <table>
                    <tr>
                        <th>Department</th>
                        <th>Category Name</th>
                        <th>Category GPA</th>
                        <th>Category Units</th>
                    </tr>
                    <tr>
                        <form action="category_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPARTMENT" size="10"></th>
                            <th><input value="" name="CATNAME" size="10"></th>
                            <th><input value="" name="CATGPA" size="10"></th>
                            <th><input value="" name="CATUNITS" size="10"></th>
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
                        <td><input value="<%= rs.getString("DEPARTMENT") %>" name="DEPARTMENT"></td>
                        <td><input value="<%= rs.getString("CATNAME") %>" name="CATNAME"></td>
                        <td><input value="<%= rs.getFloat("CATGPA") %>" name="CATGPA"></td>
                        <td><input value="<%= rs.getInt("CATUNITS") %>" name="CATUNITS"></td>
                        <td><input type="submit" value="Update"></td>
                    </form>
                    <form action="category_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getString("DEPARTMENT") %>"
                            name="DEPARTMENT">
                        <input type="hidden" value="<%= rs.getString("CATNAME") %>"
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