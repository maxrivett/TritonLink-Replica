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
                        // INSERT the corequisite attrs INTO the Corequisites table

                        PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT COUNT(*) AS duplicates FROM Corequisites WHERE " + 
                            "BASECOURSE = ? AND COREQUISITE = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COREQUISITE")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("BASECOURSE")));
                        ResultSet rs = pstmt.executeQuery();
                        int rowCount = 0;

                        if (rs.next()) {
                            rowCount = rs.getInt("duplicates");
                        }

                        if (rowCount <= 0) {
                            PreparedStatement pstmt2 = conn.prepareStatement(
                                ("INSERT INTO Corequisites VALUES (?, ?)"));
                            pstmt2.setInt(1, Integer.parseInt(request.getParameter("BASECOURSE")));
                            pstmt2.setInt(2, Integer.parseInt(request.getParameter("COREQUISITE")));
                            pstmt2.executeUpdate();
                        }
                    

                        conn.commit();
                        conn.setAutoCommit(true);
                    }


                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the corequisite FROM the Corequisites table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM Corequisites WHERE BASECOURSE = ? AND COREQUISITE = ?");

                        pstmt.setInt(1,
                            Integer.parseInt(request.getParameter("BASECOURSE")));
                        pstmt.setInt(2,
                            Integer.parseInt(request.getParameter("COREQUISITE")));

                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the course attributes
                    // FROM the Corequisites table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Corequisites");
                %>
                <table>
                    <tr>
                        <th>BASECOURSE</th>
                        <th>COREQUISITE</th>
                    </tr>
                    <tr>
                        <form action="corequisite_entry_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="BASECOURSE" size="10"></th>
                            <th><input value="" name="COREQUISITE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="corequisite_entry_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <td><input value="<%= rs.getInt("BASECOURSE") %>"
                            name="BASECOURSE"></td>
                        <td><input value="<%= rs.getInt("COREQUISITE") %>"
                            name="COREQUISITE"></td>
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