<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%-- Set the scripting language to java and import the java.sql package --%>
                <%@ page language="java" import="java.sql.*" %>

                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=HPost1QGres!&ssl=false";
                        conn = DriverManager.getConnection(url);

                        // Fetch all students ever enrolled
                        String studentQuery = "SELECT SSN, FIRSTNAME, MIDDLENAME, LASTNAME FROM student ORDER BY LASTNAME, FIRSTNAME";
                        pstmt = conn.prepareStatement(studentQuery);
                        rs = pstmt.executeQuery();
                %>
                <form action="student_grade_report.jsp" method="get">
                    <label for="studentSelection">Select a student by SSN:</label>
                    <select name="studentSSN" id="studentSSN">
                        <% while (rs.next()) { %>
                        <option value="<%= rs.getString("SSN") %>">
                            <%= rs.getString("FIRSTNAME") %> <%= rs.getString("MIDDLENAME") %> <%= rs.getString("LASTNAME") %> (SSN: <%= rs.getString("SSN") %>)
                        </option>
                        <% } %>
                    </select>
                    <input type="submit" value="Get Grade Report">
                </form>
                <%
                        if (request.getParameter("studentSSN") != null) {
                            String selectedSSN = request.getParameter("studentSSN");
                            // Fetch classes taken by the selected student, grouped by quarter
                            String gradeQuery = "SELECT c.TITLE, ct.COURSEID, ct.QUARTER, ct.YEAR, ct.GRADE, ct.NUMUNITS " +
                            "FROM classes_taken ct JOIN classes c ON ct.COURSEID = c.COURSEID " +
                            "WHERE ct.STUDENTID = (SELECT STUDENTID FROM student WHERE SSN = ?) " +
                            "ORDER BY ct.YEAR DESC, ct.QUARTER";
                            pstmt = conn.prepareStatement(gradeQuery);
                            pstmt.setInt(1, Integer.parseInt(selectedSSN)); 
                            rs = pstmt.executeQuery();

                %>
                <table border="1">
                    <tr>
                        <th>Title</th>
                        <th>Course ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Grade</th>
                        <th>Units</th>
                    </tr>
                    <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getString("TITLE") %></td>
                        <td><%= rs.getInt("COURSEID") %></td>
                        <td><%= rs.getString("QUARTER") %></td>
                        <td><%= rs.getInt("YEAR") %></td>
                        <td><%= rs.getString("GRADE") %></td>
                        <td><%= rs.getInt("NUMUNITS") %></td>
                    </tr>
                    <% } %>
                </table>
                <%
                        }
                        rs.close();
                        pstmt.close();
                    } catch (SQLException e) {
                        out.println("SQL Error: " + e.getMessage());
                    }
                %>
            </td>
        </tr>
    </table>
</body>
</html>
