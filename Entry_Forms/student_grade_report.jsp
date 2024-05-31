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

                        String studentQuery = "SELECT SSN, FIRSTNAME, MIDDLENAME, LASTNAME FROM student ORDER BY LASTNAME, FIRSTNAME";
                        pstmt = conn.prepareStatement(studentQuery);
                        rs = pstmt.executeQuery();
                %>
                <form action="student_grade_report.jsp" method="get">
                    <label for="studentSelection">Select a student by SSN:</label>
                    <select name="studentSSN" id="studentSSN">
                        <% while (rs.next()) { %>
                        <option value="<%= rs.getInt("SSN") %>">
                            <%= rs.getString("FIRSTNAME") %> <%= rs.getString("MIDDLENAME") %> <%= rs.getString("LASTNAME") %> (SSN: <%= rs.getInt("SSN") %>)
                        </option>
                        <% } %>
                    </select>
                    <input type="submit" value="Get Grade Report">
                </form>
                <%
                        if (request.getParameter("studentSSN") != null) {
                            int selectedSSN = Integer.parseInt(request.getParameter("studentSSN"));
                            String gradeQuery = "SELECT c.TITLE, ct.COURSEID, ct.QUARTER, ct.YEAR, ct.GRADE, ct.NUMUNITS, gc.GPA, gc.GPACOUNT " +
                                "FROM classes_taken ct " +
                                "JOIN classes c ON ct.COURSEID = c.COURSEID AND ct.QUARTER = c.QUARTER AND ct.YEAR = c.YEAR " +
                                "JOIN grade_conversion gc ON ct.GRADE = gc.GRADE " +
                                "WHERE ct.STUDENTID = (SELECT STUDENTID FROM student WHERE SSN = ?) " +
                                "ORDER BY ct.YEAR, ct.QUARTER";
                            pstmt = conn.prepareStatement(gradeQuery);
                            pstmt.setInt(1, selectedSSN);
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
                        <th>GPA</th>
                    </tr>
                    <% 
                        String currentQuarter = "";
                        double totalPoints = 0;
                        int totalUnits = 0;
                        double cumulativePoints = 0;
                        int cumulativeUnits = 0;
                        while (rs.next()) {
                            String quarter = rs.getString("QUARTER") + " " + rs.getInt("YEAR");
                            if (!quarter.equals(currentQuarter)) {
                                if (!currentQuarter.isEmpty()) {
                                    double gpa = (totalUnits > 0) ? totalPoints / totalUnits : 0.0;
                %>
                    <tr>
                        <td colspan="7"><strong>GPA for <%= currentQuarter %>: <%= String.format("%.2f", gpa) %></strong></td>
                    </tr>
                <% 
                                    cumulativePoints += totalPoints;
                                    cumulativeUnits += totalUnits;
                                    totalPoints = 0;
                                    totalUnits = 0;
                                }
                                currentQuarter = quarter;
                            }
                            if (rs.getInt("GPACOUNT") > 0) { 
                                double points = rs.getDouble("GPA") * rs.getInt("NUMUNITS");
                                totalPoints += points;
                                totalUnits += rs.getInt("NUMUNITS");
                            }
                %>
                    <tr>
                        <td><%= rs.getString("TITLE") %></td>
                        <td><%= rs.getInt("COURSEID") %></td>
                        <td><%= rs.getString("QUARTER") %></td>
                        <td><%= rs.getInt("YEAR") %></td>
                        <td><%= rs.getString("GRADE") %></td>
                        <td><%= rs.getInt("NUMUNITS") %></td>
                        <td><%= rs.getDouble("GPA") %></td>
                    </tr>
                    <% } 
                        if (!currentQuarter.isEmpty() && totalUnits > 0) {
                            double gpa = totalPoints / totalUnits;
                %>
                    <tr>
                        <td colspan="7"><strong>GPA for <%= currentQuarter %>: <%= String.format("%.2f", gpa) %></strong></td>
                    </tr>
                <% 
                            cumulativePoints += totalPoints;
                            cumulativeUnits += totalUnits;
                        }
                        if (cumulativeUnits > 0) {
                            double cumulativeGPA = cumulativePoints / cumulativeUnits;
                %>
                    <tr>
                        <td colspan="7"><strong>Cumulative GPA: <%= String.format("%.2f", cumulativeGPA) %></strong></td>
                    </tr>
                <% 
                        }
                    %>
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
