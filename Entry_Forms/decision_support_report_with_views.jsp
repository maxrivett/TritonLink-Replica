<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%@ page language="java" import="java.sql.*" %>
                <%
                    Connection conn = null;
                    Statement course_statement = null;
                    ResultSet course_rs = null;
                    Statement faculty_statement = null;
                    ResultSet faculty_rs = null;
                    Statement year_statement = null;
                    ResultSet year_rs = null;
                    PreparedStatement pstmtCPQG = null;
                    ResultSet rsCPQG = null;
                    PreparedStatement pstmtCPG = null;
                    ResultSet rsCPG = null;

                    try {
                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=HPost1QGres!&ssl=false";
                        conn = DriverManager.getConnection(url);
                        course_statement = conn.createStatement();
                        course_rs = course_statement.executeQuery("SELECT * FROM Course");
                        faculty_statement = conn.createStatement();
                        faculty_rs = faculty_statement.executeQuery("SELECT * FROM Faculty");
                        year_statement = conn.createStatement();
                        year_rs = year_statement.executeQuery("SELECT DISTINCT YEAR FROM Classes ORDER BY YEAR");
                %>

                <form action="decision_support_report_with_views.jsp" method="get">
                    <label>Choose a course, professor, quarter, and year:</label>
                    <input type="hidden" name="action" value="submit">
                    <select name="COURSEID" id="COURSEID">
                        <% while (course_rs.next()) { %>
                            <option value="<%= course_rs.getInt("COURSEID") %>"><%= course_rs.getString("COURSENUM") %></option>
                        <% } %>
                    </select>
                    <select name="FACULTYNAME" id="FACULTYNAME">
                        <% while (faculty_rs.next()) { %>
                            <option value="<%= faculty_rs.getString("FACULTYNAME") %>"><%= faculty_rs.getString("FACULTYNAME") %></option>
                        <% } %>
                    </select>
                    <select name="QUARTER" id="QUARTER">
                        <option value="Winter">Winter</option>
                        <option value="Spring">Spring</option>
                        <option value="Fall">Fall</option>
                    </select>
                    <select name="YEAR" id="YEAR">
                        <% while (year_rs.next()) { %>
                            <option value="<%= year_rs.getInt("YEAR") %>"><%= year_rs.getInt("YEAR") %></option>
                        <% } %>
                    </select>
                    <input type="submit" value="Submit">
                </form>

                <% if ("submit".equals(request.getParameter("action"))) {
                        int courseId = Integer.parseInt(request.getParameter("COURSEID"));
                        String facultyName = request.getParameter("FACULTYNAME");
                        String quarter = request.getParameter("QUARTER");
                        int year = Integer.parseInt(request.getParameter("YEAR"));

                        String sqlCPQG = "SELECT GRADE, COUNT FROM CPQG WHERE COURSEID = ? AND PROFESSOR = ? AND QUARTER = ? AND YEAR = ?";
                        pstmtCPQG = conn.prepareStatement(sqlCPQG);
                        pstmtCPQG.setInt(1, courseId);
                        pstmtCPQG.setString(2, facultyName);
                        pstmtCPQG.setString(3, quarter);
                        pstmtCPQG.setInt(4, year);
                        rsCPQG = pstmtCPQG.executeQuery();

                        String sqlCPG = "SELECT GRADE, COUNT FROM CPG WHERE COURSEID = ? AND PROFESSOR = ?";
                        pstmtCPG = conn.prepareStatement(sqlCPG);
                        pstmtCPG.setInt(1, courseId);
                        pstmtCPG.setString(2, facultyName);
                        rsCPG = pstmtCPG.executeQuery();

                        %><h2>Course Performance per Quarter and Grade (CPQG)</h2>
                        <table border="1">
                            <tr><th>Grade</th><th>Count</th></tr>
                            <% while (rsCPQG.next()) { %>
                                <tr><td><%= rsCPQG.getString("GRADE") %></td><td><%= rsCPQG.getInt("COUNT") %></td></tr>
                            <% } %>
                        </table>

                        <h2>Course Performance per Grade (CPG)</h2>
                        <table border="1">
                            <tr><th>Grade</th><th>Count</th></tr>
                            <% while (rsCPG.next()) { %>
                                <tr><td><%= rsCPG.getString("GRADE") %></td><td><%= rsCPG.getInt("COUNT") %></td></tr>
                            <% } %>
                        </table><%
                    }
                } catch (SQLException sqle) {
                    out.println("SQL Error: " + sqle.getMessage());
                } finally {
                    if (rsCPQG != null) try { rsCPQG.close(); } catch (SQLException e) { }
                    if (pstmtCPQG != null) try { pstmtCPQG.close(); } catch (SQLException e) { }
                    if (rsCPG != null) try { rsCPG.close(); } catch (SQLException e) { }
                    if (pstmtCPG != null) try { pstmtCPG.close(); } catch (SQLException e) { }
                    if (course_rs != null) try { course_rs.close(); } catch (SQLException e) { }
                    if (faculty_rs != null) try { faculty_rs.close(); } catch (SQLException e) { }
                    if (year_rs != null) try { year_rs.close(); } catch (SQLException e) { }
                    if (course_statement != null) try { course_statement.close(); } catch (SQLException e) { }
                    if (faculty_statement != null) try { faculty_statement.close(); } catch (SQLException e) { }
                    if (year_statement != null) try { year_statement.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
                %>
            </td>
        </tr>
    </table>
</body>
</html>
