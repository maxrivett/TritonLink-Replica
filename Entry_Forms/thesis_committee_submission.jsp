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
                        // INSERT the thesis_committee attrs INTO the thesis_committee table

                        String[] professors = request.getParameter("PROFESSORS").split(",");

                        if (professors.length >= 4) {
                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO thesis_committee VALUES (?, ?)"));

                            for (int i = 0; i < professors.length; i++) {
                                pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                                pstmt.setInt(2, professors[i]);

                                pstmt.executeUpdate();
                            }
                        }

                        conn.commit();
                        conn.setAutoCommit(true);
                    }

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        conn.setAutoCommit(false);

                        // Create prepared statement to UPDATE classes_taken
                        // attributes in the classes_taken table

                        String[] professors = request.getParameter("PROFESSORS").split(",");

                        if (professors.length >= 4) {

                            PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM thesis_committee WHERE STUDENTID = ?");

                            pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));

                            pstmt.executeUpdate();


                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("INSERT INTO thesis_committee VALUES (?, ?)"));

                            for (int i = 0; i < professors.length; i++) {
                                pstmt2.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                                pstmt2.setInt(2, professors[i]);

                                pstmt2.executeUpdate();
                            }
                        }


                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the committee FROM the thesis_committee table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM thesis_committee WHERE STUDENTID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));


                        int rowCount = pstmt.executeUpdate();

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
                        ("SELECT * FROM thesis_committee");
                %>
                <table>
                    <tr>
                        <th>Student_ID</th>
                        <th>Professors</th>
                    </tr>
                    <tr>
                        <form action="thesis_committee_submission.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="PROFESSORS" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="thesis_committee_submission.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getBoolean("PROFESSORS") %>" name="PROFESSORS"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="thesis_committee_submission.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt("STUDENTID") %>"
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