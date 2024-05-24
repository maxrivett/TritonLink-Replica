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

                        // Fetch all classes for the dropdown
                        String classQuery = "SELECT DISTINCT TITLE, QUARTER, YEAR FROM classes  WHERE QUARTER = ? AND " + 
                        "YEAR = ? ORDER BY YEAR DESC, QUARTER, TITLE";
                        pstmt = conn.prepareStatement(classQuery);
                        pstmt.setString(1, "Spring");
                        pstmt.setInt(2, 2018);
                        rs = pstmt.executeQuery();
                %>
                <form method="get">
                    <label for="classInfo">Select a class:</label>
                    <select name="classInfo" id="classInfo">
                        <%
                            while (rs.next()) {
                        %>
                        <option value="<%= rs.getString("TITLE") %>_<%= rs.getString("QUARTER") %>_<%= rs.getInt("YEAR") %>">
                            <%= rs.getString("TITLE") %> - <%= rs.getString("QUARTER") %> <%= rs.getInt("YEAR") %>
                        </option>
                        <%
                            }
                            rs.close();
                            pstmt.close();
                        %>
                    </select>
                    <input type="submit" value="Show Roster">
                </form>
                <%
                    // Handling roster display after form submission
                    String selectedClass = request.getParameter("classInfo");
                    if (selectedClass != null) {
                        String[] parts = selectedClass.split("_");
                        String title = parts[0];
                        String quarter = parts[1];
                        int year = Integer.parseInt(parts[2]);

                        // Fetch students enrolled in the selected class
                        String rosterQuery = "SELECT s.*, ce.NUMUNITS, ce.GRADINGOPTION FROM student s JOIN course_enrollment ce ON s.STUDENTID = ce.STUDENTID JOIN classes c ON ce.COURSEID = c.COURSEID WHERE c.TITLE = ? AND c.QUARTER = ? AND c.YEAR = ?";
                        pstmt = conn.prepareStatement(rosterQuery);
                        pstmt.setString(1, title);
                        pstmt.setString(2, quarter);
                        pstmt.setInt(3, year);
                        rs = pstmt.executeQuery();
                %>
                <table border="1">
                    <tr>
                        <th>Student_ID</th>
                        <th>First Name</th>
                        <th>Middle Name</th>
                        <th>Last Name</th>
                        <th>Enrolled</th>
                        <th>SSN</th>
                        <th>Residency</th>
                        <th>Account_Balance</th>
                        <th>Units</th>
                        <th>Grade Option</th>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("STUDENTID") %></td>
                        <td><%= rs.getString("FIRSTNAME") %></td>
                        <td><%= rs.getString("MIDDLENAME") %></td>
                        <td><%= rs.getString("LASTNAME") %></td>
                        <td><%= rs.getBoolean("ENROLLED") %></td>
                        <td><%= rs.getInt("SSN") %></td>
                        <td><%= rs.getString("RESIDENCY") %></td>
                        <td><%= rs.getFloat("ACCOUNTBALANCE") %></td>
                        <td><%= rs.getInt("NUMUNITS") %></td>
                        <td><%= rs.getString("GRADINGOPTION") %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <%
                    }
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    } catch (SQLException e) {
                        out.println("SQL Error: " + e.getMessage());
                    }
                %>
            </td>
        </tr>
    </table>
</body>
</html>
