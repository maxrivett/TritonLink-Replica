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
                    Statement course_statement = conn.createStatement();

                    ResultSet course_rs = course_statement.executeQuery
                        ("SELECT * FROM Course");
                    
                    // Create the statement
                    Statement faculty_statement = conn.createStatement();

                    ResultSet faculty_rs = faculty_statement.executeQuery
                        ("SELECT * FROM Faculty");

                    // Create the statement
                    Statement year_statement = conn.createStatement();

                    ResultSet year_rs = year_statement.executeQuery
                        ("SELECT DISTINCT YEAR FROM Classes ORDER BY YEAR");
                %>

                
                <form action="decision_support_report.jsp" method="get">
                    <label for="courses">Choose a course and (optionally) a professor and quarter: </label>
                    <input type="hidden" value="submit" name="action">
                    <select name="COURSEID" id="COURSEID">
                        <%
                            while (course_rs.next()) {
                                String course_opt = "";
                                course_opt = course_opt + "ID: " + course_rs.getInt("COURSEID") + ", ";
                                course_opt = course_opt + "Name: " + course_rs.getString("COURSENUM");
                        %>
                        <option value="<%= course_rs.getInt("COURSEID") %>">
                            <%= course_opt %>
                        </option>
                        <% } %>
                        <option value="None">
                            None
                        </option>
                    </select>
                    <select name="FACULTYNAME" id="FACULTYNAME">
                        <%
                            while (faculty_rs.next()) {
                                String faculty_opt = "Faculty: " + faculty_rs.getString("FACULTYNAME");
                        %>
                        <option value="<%= faculty_rs.getString("FACULTYNAME") %>">
                            <%= faculty_opt %>
                        </option>
                        <% } %>
                        <option value="None">
                            Faculty: None
                        </option>
                    </select>
                    <select name="QUARTER" id="QUARTER">
                        <option value="Winter">
                            Quarter: Winter
                        </option>
                        <option value="Spring">
                            Quarter: Spring
                        </option>
                        <option value="Fall">
                            Quarter: Fall
                        </option>
                        <option value="None">
                            Quarter: None
                        </option>
                    </select>
                    <select name="YEAR" id="YEAR">
                        <%
                            while (year_rs.next()) {
                                String year_opt = "Year: " + year_rs.getInt("YEAR");
                        %>
                        <option value="<%= year_rs.getInt("YEAR") %>">
                            <%= year_opt %>
                        </option>
                        <% } %>
                        <option value="None">
                            Year: None
                        </option>
                    </select>
                    <th><input type="submit" value="Submit"></th>
                </form>


                    
                    <%
                        // Iterate over the ResultSet
                        String action = request.getParameter("action");
                        // Check if an insertion is requested
                        if (action != null && action.equals("submit")
                                && !(request.getParameter("COURSEID").equals("None"))) {
                            conn.setAutoCommit(false);

                            int curr_id = Integer.parseInt(request.getParameter("COURSEID"));

                            String curr_fac_name = request.getParameter("FACULTYNAME");

                            String curr_qtr = request.getParameter("QUARTER");

                            String curr_year = request.getParameter("YEAR");

                            PreparedStatement pstmt1 = conn.prepareStatement(
                            ("SELECT * FROM Course WHERE COURSEID = ?"));

                            pstmt1.setInt(1, curr_id);

                            ResultSet curr_course_rs = pstmt1.executeQuery();

                            conn.commit();
                            conn.setAutoCommit(true);
                    %>
                
                    <table>
                        <tr>
                            <th>Course ID</th>
                            <th>Course Name</th>
                            <th>Faculty Name</th>
                            <th>Quarter</th>
                            <th>Year</th>

                        </tr>
                    <%
                        while (curr_course_rs.next()) {
                    %>
                            <tr>
                                <form>
                                    <td><input type="text" value="<%= curr_id %>" name="COURSEID"></td>
                                    <td><input type="text" value="<%= curr_course_rs.getString("COURSENUM") %>" name="COURSENUM"></td>
                                    <td><input type="text" value="<%= curr_fac_name %>" name="FACULTYNAME"></td>
                                    <td><input type="text" value="<%= curr_qtr %>" name="QUARTER"></td>
                                    <td><input type="text" value="<%= curr_year %>" name="YEAR"></td>
                                </form>
                            </tr>
                    <%
                        }
                    %>

                        <tr>
                            <th>Course Grades and Counts</th>
                            <th>Total</th>
                        </tr>

                        <tr>
                            <th>Course Grade</th>
                            <th>Count</th>
                        </tr>

                    <%

                        PreparedStatement pstmt_course_grade_count = conn.prepareStatement(
                        ("SELECT GRADECLASS, COUNT(STUDENTID) AS GRADECOUNT FROM grade_conversion LEFT JOIN " + 
                        "(SELECT * FROM classes_taken WHERE COURSEID = ?) AS course_classes_taken " + 
                        "ON course_classes_taken.GRADE = grade_conversion.GRADE " + 
                        "GROUP BY GRADECLASS ORDER BY GRADECLASS"));

                        pstmt_course_grade_count.setInt(1, curr_id);

                        ResultSet course_grade_count_rs = pstmt_course_grade_count.executeQuery();

                        while (course_grade_count_rs.next()) {
                    %>

                            <tr>
                                <form>
                                    <td><input type="text" value="<%= course_grade_count_rs.getString("GRADECLASS") %>" name="GRADECLASS"></td>
                                    <td><input type="text" value="<%= course_grade_count_rs.getInt("GRADECOUNT") %>" name="GRADECOUNT"></td>
                                </form>
                            </tr>

                    <%
                        }

                        if (!curr_fac_name.equals("None")) {

                    %>

                        <tr>
                            <th>Course Grades and Counts</th>
                            <th>Professor: <%= curr_fac_name %></th>
                        </tr>

                        <tr>
                            <th>Course Grade</th>
                            <th>Count</th>
                        </tr>

                        <%

                            PreparedStatement pstmt_course_prof_grade_count = conn.prepareStatement(
                            ("SELECT GRADECLASS, COUNT(prof_classes_taken.GRADE) AS GRADECOUNT FROM grade_conversion LEFT JOIN " + 
                            "(SELECT * FROM classes_taken WHERE (SECTIONID, COURSEID, QUARTER, YEAR) IN " + 
                            "(SELECT class_section.SECTIONID, class_section.COURSEID, " + 
                            "class_section.QUARTER, class_section.YEAR FROM class_section, Sections " + 
                            "WHERE class_section.SECTIONID = Sections.SECTIONID AND Sections.FACULTYNAME = ? " + 
                            "AND COURSEID = ?)) " + 
                            "as prof_classes_taken ON prof_classes_taken.GRADE = grade_conversion.GRADE " + 
                            "GROUP BY GRADECLASS ORDER BY GRADECLASS"));

                            
                            pstmt_course_prof_grade_count.setString(1, curr_fac_name);
                            pstmt_course_prof_grade_count.setInt(2, curr_id);



                            ResultSet course_prof_grade_count_rs = pstmt_course_prof_grade_count.executeQuery();

                            while (course_prof_grade_count_rs.next()) {
                        %>

                                <tr>
                                    <form>
                                        <td><input type="text" value="<%= course_prof_grade_count_rs.getString("GRADECLASS") %>" name="GRADECLASS"></td>
                                        <td><input type="text" value="<%= course_prof_grade_count_rs.getInt("GRADECOUNT") %>" name="GRADECOUNT"></td>
                                    </form>
                                </tr>

                            
                        <%
                            }
                        %>

                        <%

                            float gpa_total = (float) 0.0;
                            int gpa_count = 1;

                            PreparedStatement pstmt_course_prof_gpa_total = conn.prepareStatement(
                            ("SELECT SUM(GPA) AS GPATOTAL, SUM(GPACOUNT) AS GPACOUNT FROM grade_conversion RIGHT JOIN " + 
                            "(SELECT * FROM classes_taken WHERE (SECTIONID, COURSEID, QUARTER, YEAR) IN " + 
                            "(SELECT class_section.SECTIONID, class_section.COURSEID, " + 
                            "class_section.QUARTER, class_section.YEAR FROM class_section, Sections " + 
                            "WHERE class_section.SECTIONID = Sections.SECTIONID AND Sections.FACULTYNAME = ? " + 
                            "AND COURSEID = ?)) " + 
                            "as prof_classes_taken ON prof_classes_taken.GRADE = grade_conversion.GRADE"));

                            
                            pstmt_course_prof_gpa_total.setString(1, curr_fac_name);
                            pstmt_course_prof_gpa_total.setInt(2, curr_id);



                            ResultSet course_prof_gpa_total_rs = pstmt_course_prof_gpa_total.executeQuery();

                            if (course_prof_gpa_total_rs.next()) {
                                gpa_total = course_prof_gpa_total_rs.getFloat("GPATOTAL");
                                gpa_count = course_prof_gpa_total_rs.getInt("GPACOUNT");
                            }

                            if (gpa_count < 1) {
                                gpa_count = 1;
                            }

                            float gpa_final = gpa_total / gpa_count;

                        %>

                        <tr>
                            <th>Overall GPA: <%= gpa_final %></th>
                        </tr>



                        <%
                            if (!(curr_qtr.equals("None") || curr_year.equals("None"))) {
                        %>

                            <tr>
                                <th>Course Grades and Counts</th>
                                <th>Professor: <%= curr_fac_name %></th>
                                <th>Quarter: <%= curr_qtr %></th>
                                <th>Year: <%= curr_year %></th>
                            </tr>

                            <tr>
                                <th>Course Grade</th>
                                <th>Count</th>
                            </tr>

                            <%

                                PreparedStatement pstmt_course_prof_qtr_grade_count = conn.prepareStatement(
                                ("SELECT GRADECLASS, COUNT(prof_classes_taken.GRADE) AS GRADECOUNT FROM grade_conversion LEFT JOIN " + 
                                "(SELECT * FROM classes_taken WHERE (SECTIONID, COURSEID, QUARTER, YEAR) IN " + 
                                "(SELECT class_section.SECTIONID, class_section.COURSEID, " + 
                                "class_section.QUARTER, class_section.YEAR FROM class_section, Sections " + 
                                "WHERE class_section.SECTIONID = Sections.SECTIONID AND Sections.FACULTYNAME = ? " + 
                                "AND COURSEID = ? AND QUARTER = ? AND YEAR = ?)) " + 
                                "as prof_classes_taken ON prof_classes_taken.GRADE = grade_conversion.GRADE " + 
                                "GROUP BY GRADECLASS ORDER BY GRADECLASS"));

                                
                                pstmt_course_prof_qtr_grade_count.setString(1, curr_fac_name);
                                pstmt_course_prof_qtr_grade_count.setInt(2, curr_id);
                                pstmt_course_prof_qtr_grade_count.setString(3, curr_qtr);
                                pstmt_course_prof_qtr_grade_count.setInt(4, Integer.parseInt(curr_year));



                                ResultSet course_prof_qtr_grade_count_rs = pstmt_course_prof_qtr_grade_count.executeQuery();

                                while (course_prof_qtr_grade_count_rs.next()) {
                            %>

                                    <tr>
                                        <form>
                                            <td><input type="text" value="<%= course_prof_qtr_grade_count_rs.getString("GRADECLASS") %>" name="GRADECLASS"></td>
                                            <td><input type="text" value="<%= course_prof_qtr_grade_count_rs.getInt("GRADECOUNT") %>" name="GRADECOUNT"></td>
                                        </form>
                                    </tr>

                                
                            <%
                                }
                            %>

                        <%
                            }
                            
                            else {
                        %>
                                <tr>
                                    <th>No quarter specified.</th>
                                </tr>
                        <%
                            }
                        %>

                        




                    <%
                        }

                        else {
                    %>
                            <tr>
                                <th>No faculty specified.</th>
                            </tr>
                    <%
                        }
                    %>



                    </table>
                <%
                    }
                %>
                

                <%
                    // Close the ResultSet
                    course_rs.close();
                    faculty_rs.close();

                    // Close the Statement
                    course_statement.close();
                    faculty_statement.close();

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