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
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the student table
                    ResultSet student_rs = statement.executeQuery
                        ("SELECT * FROM student WHERE ENROLLED = true");
                %>

                <form action="student_class_report.jsp" method="get">
                    <label for="students">Choose a student by Student ID: </label>
                    <input type="hidden" value="submit" name="action">
                    <select name="STUDENTID" id="STUDENTID">
                        <%
                            while (student_rs.next()) {
                                String student_opt = "";
                                student_opt = student_opt + "ID: " + student_rs.getInt("STUDENTID") + ", ";
                                student_opt = student_opt + "Name: " + student_rs.getString("FIRSTNAME") + " ";
                                student_opt = student_opt + student_rs.getString("MIDDLENAME") + " ";
                                student_opt = student_opt + student_rs.getString("LASTNAME") + ", ";
                                student_opt = student_opt + "SSN: " + student_rs.getInt("SSN");
                                
                        %>
                        <option value="<%= student_rs.getInt("STUDENTID") %>">
                            <%= student_opt %>
                        </option>
                        <% } %>
                        <option value="None"">
                            None
                        </option>
                    </select>
                    <th><input type="submit" value="Submit"></th>
                </form>


                    
                    <%
                        // Iterate over the ResultSet
                        String action = request.getParameter("action");
                        // Check if an insertion is requested
                        if (action != null && action.equals("submit") 
                                && !(request.getParameter("STUDENTID").equals("None"))) {
                            conn.setAutoCommit(false);
                            
                            // Create the prepared statement and use it to 
                            // INSERT the advisor attrs INTO the advisors table
                            PreparedStatement pstmt = conn.prepareStatement(
                            ("SELECT * FROM course_enrollment, Sections WHERE course_enrollment.STUDENTID = ? AND " + 
                            "course_enrollment.SECTIONID = Sections.SECTIONID"));

                            int curr_id = Integer.parseInt(request.getParameter("STUDENTID"));

                            pstmt.setInt(1, curr_id);

                            ResultSet classes_rs = pstmt.executeQuery();

                            // Create the prepared statement and use it to 
                            // INSERT the advisor attrs INTO the advisors table
                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("SELECT * FROM student WHERE STUDENTID = ?"));

                            pstmt2.setInt(1, curr_id);

                            ResultSet curr_student_rs = pstmt2.executeQuery();

                            conn.commit();
                            conn.setAutoCommit(true);
                    %>
                
                    <table>
                        <tr>
                            <th>Student ID</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Last Name</th>
                            <th>SSN</th>
                        </tr>
                    <%
                        while (curr_student_rs.next()) {
                    %>
                            
                        
                            <tr>
                                <form>
                                    <td><input type="text" value="<%= curr_student_rs.getInt("STUDENTID") %>" name="STUDENTID"></td>
                                    <td><input type="text" value="<%= curr_student_rs.getString("FIRSTNAME") %>" name="FIRSTNAME"></td>
                                    <td><input type="text" value="<%= curr_student_rs.getString("MIDDLENAME") %>" name="MIDDLENAME"></td>
                                    <td><input type="text" value="<%= curr_student_rs.getString("LASTNAME") %>" name="LASTNAME"></td>
                                    <td><input type="text" value="<%= curr_student_rs.getInt("SSN") %>" name="SSN"></td>
                                </form>
                            </tr>
                    <%
                        }
                    %>
                    </table>

                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Course ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Number of Units</th>
                        <th>Section ID</th>
                        <th>Number of Students Enrolled</th>
                        <th>Faculty Name</th>
                        <th>Enrollment Limit</th>
                    </tr>

                    <%
                            while (classes_rs.next()) {
                    %>
                    <tr>
                        <form>
                            <td><input type="text" value="<%= classes_rs.getInt("STUDENTID") %>" name="STUDENTID"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("COURSEID") %>" name="COURSEID"></td>
                            <td><input type="text" value="<%= classes_rs.getString("QUARTER") %>" name="QUARTER"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("YEAR") %>" name="YEAR"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("NUMUNITS") %>" name="NUMUNITS"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("SECTIONID") %>" name="SECTIONID"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("NUMENROLLED") %>" name="NUMENROLLED"></td>
                            <td><input type="text" value="<%= classes_rs.getString("FACULTYNAME") %>" name="FACULTYNAME"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("ENROLLLIMIT") %>" name="ENROLLLIMIT"></td>
                        </form>
                    </tr>
                
                    </table>
                
                <%
                        }
                %>
                    </table>
                <%
                    }
                %>
                

                <%
                    // Close the ResultSet
                    student_rs.close();

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