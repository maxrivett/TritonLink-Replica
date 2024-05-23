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
                    if ("insert".equals(action) || "update".equals(action)) {
                        conn.setAutoCommit(false);
                        int studentId = Integer.parseInt(request.getParameter("STUDENTID"));
                        int courseId = Integer.parseInt(request.getParameter("COURSEID"));
                        int sectionId = Integer.parseInt(request.getParameter("SECTIONID"));
                        String quarter = request.getParameter("QUARTER");
                        int year = Integer.parseInt(request.getParameter("YEAR"));
                        int numunits = Integer.parseInt(request.getParameter("NUMUNITS"));
                        String grade = request.getParameter("GRADE");

                        PreparedStatement validationStmt = conn.prepareStatement(
                            "SELECT COUNT(*) FROM class_section WHERE COURSEID = ? AND SECTIONID = ? AND QUARTER = ? AND YEAR = ?");
                        validationStmt.setInt(1, courseId);
                        validationStmt.setInt(2, sectionId);
                        validationStmt.setString(3, quarter);
                        validationStmt.setInt(4, year);
                        ResultSet rs = validationStmt.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);
                        rs.close();
                        validationStmt.close();

                        if (count == 0) {
                            out.println("<p>Invalid course-section-quarter-year combination. No action performed.</p>");
                        } else {
                            PreparedStatement pstmt = null;
                            if ("insert".equals(action)) {
                                pstmt = conn.prepareStatement(
                                    "INSERT INTO classes_taken (STUDENTID, COURSEID, SECTIONID, QUARTER, YEAR, NUMUNITS, GRADE) VALUES (?, ?, ?, ?, ?, ?, ?)");
                                pstmt.setInt(1, studentId);
                                pstmt.setInt(2, courseId);
                                pstmt.setInt(3, sectionId);
                                pstmt.setString(4, quarter);
                                pstmt.setInt(5, year);
                                pstmt.setInt(6, numunits);
                                pstmt.setString(7, grade);
                            } else if ("update".equals(action)) {
                                pstmt = conn.prepareStatement(
                                    "UPDATE classes_taken SET GRADE = ? WHERE STUDENTID = ? AND COURSEID = ? AND SECTIONID = ? AND QUARTER = ? AND YEAR = ? AND NUMUNITS = ?");
                                pstmt.setString(1, grade);
                                pstmt.setInt(2, studentId);
                                pstmt.setInt(3, courseId);
                                pstmt.setInt(4, sectionId);
                                pstmt.setString(5, quarter);
                                pstmt.setInt(6, year);
                                pstmt.setInt(7, numunits);
                            }
                            pstmt.executeUpdate();
                            pstmt.close();
                            conn.setAutoCommit(false);
                            conn.commit();
                        }
                        conn.setAutoCommit(true);
                    }

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to
                        // DELETE the class taken FROM the classes_taken table.

                        PreparedStatement pstmt = conn.prepareStatement(
                        "DELETE FROM classes_taken WHERE STUDENTID = ? AND " +
                        "COURSEID = ? AND SECTIONID = ? AND QUARTER = ? AND YEAR = ? AND NUMUNITS = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(4, request.getParameter("QUARTER"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("NUMUNITS")));


                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);
                    }
                %>

                <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the class_taken attributes
                    // FROM the classes_taken table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM classes_taken");
                %>
                <table>
                    <tr>
                        <th>Student_ID</th>
                        <th>Course_ID</th>
                        <th>Section_ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Number of Units</th>
                        <th>Grade</th>
                    </tr>
                    <tr>
                        <form action="classes_taken_form.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="COURSEID" size="10"></th>
                            <th><input value="" name="SECTIONID" size="10"></th>
                            <th><input value="" name="QUARTER" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input value="" name="NUMUNITS" size="1"></th>
                            <th><input value="" name="GRADE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    while ( rs.next() ) {
                %>
                <tr>
                    <form action="classes_taken_form.jsp" method="get">
                        <input type="hidden" value="update" name="action">
                        <th><input value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID"></th>
                        <th><input value="<%= rs.getInt("COURSEID") %>" name="COURSEID"></th>
                        <th><input value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID"></th>
                        <th><input value="<%= rs.getString("QUARTER") %>" name="QUARTER"></th>
                        <th><input value="<%= rs.getInt("YEAR") %>" name="YEAR"></th>
                        <th><input value="<%= rs.getInt("NUMUNITS") %>" name="NUMUNITS"></th>
                        <th><input value="<%= rs.getString("GRADE") %>" name="GRADE"></th>
                        <th><input type="submit" value="Update"></th>
                    </form>
                    <form action="classes_taken_form.jsp" method="get">
                        <input type="hidden" value="delete" name="action">
                        <input type="hidden" value="<%= rs.getInt("STUDENTID") %>"
                            name="STUDENTID">
                        <input type="hidden" value="<%= rs.getInt("COURSEID") %>"
                            name="COURSEID">
                        <input type="hidden" value="<%= rs.getInt("SECTIONID") %>"
                            name="SECTIONID">
                        <input type="hidden" value="<%= rs.getString("QUARTER") %>"
                            name="QUARTER">
                        <input type="hidden" value="<%= rs.getInt("YEAR") %>"
                            name="YEAR">
                        <input type="hidden" value="<%= rs.getInt("NUMUNITS") %>"
                            name="NUMUNITS">
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