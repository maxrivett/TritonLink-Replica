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
                <%@ page language="java" import="java.sql.*, java.util.ArrayList" %>

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
                    Statement student_statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the student table
                    ResultSet student_rs = student_statement.executeQuery
                        ("SELECT * FROM student WHERE STUDENTID IN " + 
                        "(SELECT STUDENTID FROM graduate WHERE gradtype = 'Masters')");
                %>

                <%
                    // Create the statement
                    Statement department_statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the student table
                    ResultSet department_rs = department_statement.executeQuery
                        ("SELECT * FROM degree WHERE DEPARTMENT IN " + 
                        "(SELECT DEPARTMENT FROM masters_deg)");
                %>

                
                <form action="masters_deg_report.jsp" method="get">
                    <label for="students">Choose a student by Student ID and degree by department: </label>
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
                    <select name="DEPARTMENT" id="DEPARTMENT">
                        <%
                            while (department_rs.next()) {
                                String dept_opt = "";
                                dept_opt = dept_opt + "Department: " + department_rs.getString("DEPARTMENT") + ", ";
                                dept_opt = dept_opt + "Degree Type: " + department_rs.getString("DEGTYPE");
                        %>
                        <option value="<%= department_rs.getString("DEPARTMENT") %>">
                            <%= dept_opt %>
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
                                && !(request.getParameter("STUDENTID").equals("None"))
                                && !(request.getParameter("DEPARTMENT").equals("None"))) {
                            conn.setAutoCommit(false);

                            int curr_id = Integer.parseInt(request.getParameter("STUDENTID"));

                            String curr_dep = request.getParameter("DEPARTMENT");

                            PreparedStatement pstmt1 = conn.prepareStatement(
                            ("SELECT * FROM student WHERE STUDENTID = ?"));

                            pstmt1.setInt(1, curr_id);

                            ResultSet curr_student_rs = pstmt1.executeQuery();

                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("SELECT * FROM degree WHERE DEPARTMENT = ?"));

                            pstmt2.setString(1, curr_dep);

                            ResultSet curr_dep_rs = pstmt2.executeQuery();

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
                        <tr>
                            <th>Department Name</th>
                            <th>Degree Type</th>
                        </tr>
                    <%
                        while (curr_dep_rs.next()) {
                    %>
                        <tr>
                            <form>
                                <td><input type="text" value="<%= curr_dep_rs.getString("DEPARTMENT") %>" name="DEPARTMENT"></td>
                                <td><input type="text" value="<%= curr_dep_rs.getString("DEGTYPE") %>" name="DEGTYPE"></td>
                            </form>
                        </tr>
                        <th>General Requirements</th>
                        <tr>
                            <td>Number of units needed, total: </td>
                            <td><%= curr_dep_rs.getInt("TOTALUNITS") %></td>
                        </tr>
                    
                        <%
                            PreparedStatement pstmt_classes_taken = conn.prepareStatement(
                            ("SELECT SUM(NUMUNITS) AS UNITCOUNT FROM classes_taken WHERE STUDENTID = ?"));

                            pstmt_classes_taken.setInt(1, curr_id);

                            ResultSet total_units_rs = pstmt_classes_taken.executeQuery();

                            int total_units_taken = 0;

                            if (total_units_rs.next()) {
                                total_units_taken = total_units_rs.getInt("UNITCOUNT");
                            }

                            int remaining_general_units = curr_dep_rs.getInt("TOTALUNITS") - total_units_taken;

                            if (remaining_general_units < 0) {
                                remaining_general_units = 0;
                            }
                        %>

                        <tr>
                            <td>Number of units taken, total: </td>
                            <td><%= total_units_taken %></td>
                        </tr>
                        <tr>
                            <td>Number of units needed, remaining: </td>
                            <td><%= remaining_general_units %></td>
                        </tr>

                        <%
                            PreparedStatement pstmt3 = conn.prepareStatement(
                            ("SELECT * FROM categories WHERE DEPARTMENT = ?"));

                            pstmt3.setString(1, curr_dep_rs.getString("DEPARTMENT"));

                            ResultSet categories_rs = pstmt3.executeQuery();
                        %>

                        <tr>
                            <th>Category Name</th>
                            <th>Category Units Total</th>
                            <th>Category Units Taken</th>
                            <th>Category Units Remaining</th>
                        </tr>

                        <%
                            while (categories_rs.next()) {
                                String curr_cat_name = categories_rs.getString("CATNAME");
                                int curr_cat_units_taken = 0;

                                PreparedStatement pstmt_cat_classes_taken = conn.prepareStatement(
                                ("SELECT SUM(NUMUNITS) AS CATUNITS FROM classes_taken WHERE STUDENTID = ? " + 
                                "AND COURSEID IN (SELECT COURSEID FROM category_courses WHERE CATNAME = ? AND DEPARTMENT = ?)"));

                                pstmt_cat_classes_taken.setInt(1, curr_id);
                                pstmt_cat_classes_taken.setString(2, curr_cat_name);
                                pstmt_cat_classes_taken.setString(3, curr_dep_rs.getString("DEPARTMENT"));

                                ResultSet curr_cat_units_rs = pstmt_cat_classes_taken.executeQuery();
                                
                                if (curr_cat_units_rs.next()) {
                                    curr_cat_units_taken = curr_cat_units_rs.getInt("CATUNITS");
                                }

                                int remaining_cat_units = categories_rs.getInt("CATUNITS") - curr_cat_units_taken;

                                if (remaining_cat_units < 0) {
                                    remaining_cat_units = 0;
                                }
                        %>

                        <tr>
                            <form>
                                <td><input type="text" value="<%= categories_rs.getString("CATNAME") %>" name="CATNAME"></td>
                                <td><input type="text" value="<%= categories_rs.getInt("CATUNITS") %>" name="CATUNITS"></td>
                                <td><input type="text" value="<%= curr_cat_units_taken %>" name="CATUNITS"></td>
                                <td><input type="text" value="<%= remaining_cat_units %>" name="CATUNITS"></td>
                            </form>
                        </tr>

                        <%
                            }
                        %>

                        <%
                            PreparedStatement pstmt4 = conn.prepareStatement(
                            ("SELECT * FROM concentrations WHERE DEPARTMENT = ?"));

                            pstmt4.setString(1, curr_dep_rs.getString("DEPARTMENT"));

                            ResultSet concentrations_rs = pstmt4.executeQuery();

                            ArrayList<String> finished_cons = new ArrayList<String>();
                        %>

                        <tr>
                            <th>Concentration Name</th>
                            <th>Concentration Total Units</th>
                            <th>Concentration Units Taken</th>
                            <th>Concentration Units Remaining</th>
                            <th>Concentration Minimum GPA</th>
                            <th>Concentration Current GPA</th>
                            <th>Concentration Finished?</th>
                        </tr>

                        <%
                            while (concentrations_rs.next()) {

                                String curr_con_name = concentrations_rs.getString("CONNAME");
                                int curr_con_units_taken = 0;
                                float curr_con_gpa = (float) 0.0;
                                float min_con_gpa = concentrations_rs.getFloat("CONGPA");
                                String finished = "Unfinished.";
                                boolean good_enough = false;
                                float epsilon = (float) 0.0000000001;
                                int curr_con_gpa_count = 1;
                                float temp = (float) 0.0;

                                PreparedStatement pstmt_con_units_taken = conn.prepareStatement(
                                ("SELECT SUM(NUMUNITS) AS CONUNITS FROM classes_taken WHERE STUDENTID = ? " + 
                                "AND COURSEID IN (SELECT COURSEID FROM concentration_courses WHERE CONNAME = ? " + 
                                "AND DEPARTMENT = ?)"));

                                pstmt_con_units_taken.setInt(1, curr_id);
                                pstmt_con_units_taken.setString(2, curr_con_name);
                                pstmt_con_units_taken.setString(3, curr_dep_rs.getString("DEPARTMENT"));

                                ResultSet curr_con_units_rs = pstmt_con_units_taken.executeQuery();
                                
                                if (curr_con_units_rs.next()) {
                                    curr_con_units_taken = curr_con_units_rs.getInt("CONUNITS");
                                }

                                PreparedStatement pstmt_con_gpa = conn.prepareStatement(
                                ("SELECT SUM(GPA) AS CONGPA FROM classes_taken, grade_conversion WHERE STUDENTID = ? " + 
                                "AND COURSEID IN (SELECT COURSEID FROM concentration_courses WHERE CONNAME = ? " + 
                                "AND DEPARTMENT = ?) AND classes_taken.GRADE = grade_conversion.GRADE"));


                                pstmt_con_gpa.setInt(1, curr_id);
                                pstmt_con_gpa.setString(2, curr_con_name);
                                pstmt_con_gpa.setString(3, curr_dep_rs.getString("DEPARTMENT"));

                                ResultSet curr_con_gpa_rs = pstmt_con_gpa.executeQuery();

                                PreparedStatement pstmt_con_gpa_courses = conn.prepareStatement(
                                ("SELECT SUM(GPACOUNT) AS CONGPACOUNT FROM classes_taken, grade_conversion WHERE STUDENTID = ? " + 
                                "AND COURSEID IN (SELECT COURSEID FROM concentration_courses WHERE CONNAME = ? " + 
                                "AND DEPARTMENT = ?) AND classes_taken.GRADE = grade_conversion.GRADE"));

                                pstmt_con_gpa_courses.setInt(1, curr_id);
                                pstmt_con_gpa_courses.setString(2, curr_con_name);
                                pstmt_con_gpa_courses.setString(3, curr_dep_rs.getString("DEPARTMENT"));

                                ResultSet curr_con_gpa_count_rs = pstmt_con_gpa_courses.executeQuery();
                                
                                if (curr_con_gpa_rs.next()) {
                                    curr_con_gpa = curr_con_gpa_rs.getFloat("CONGPA");
                                }

                                if (curr_con_gpa_count_rs.next()) {
                                    curr_con_gpa_count = curr_con_gpa_count_rs.getInt("CONGPACOUNT");
                                }

                                if (curr_con_gpa_count < 1) {
                                    curr_con_gpa_count = 1;
                                }

                                curr_con_gpa = curr_con_gpa / curr_con_gpa_count;

                                int remaining_con_units = concentrations_rs.getInt("CONUNITS") - curr_con_units_taken;

                                if (remaining_con_units <= 0) {
                                    remaining_con_units = 0;
                                }

                                temp = (curr_con_gpa - min_con_gpa);

                                if (temp < 0) {
                                    temp = temp * -1;
                                }

                                if (temp < epsilon) {
                                    good_enough = true;
                                }

                                if (curr_con_gpa > min_con_gpa) {
                                    good_enough = true;
                                }

                                if (remaining_con_units == 0 && good_enough) {
                                    finished_cons.add(concentrations_rs.getString("CONNAME"));
                                    finished = "Finished.";
                                }
                        %>

                        <tr>
                            <form>
                                <td><input type="text" value="<%= concentrations_rs.getString("CONNAME") %>" name="CONNAME"></td>
                                <td><input type="text" value="<%= concentrations_rs.getInt("CONUNITS") %>" name="CONUNITS"></td>
                                <td><input type="text" value="<%= curr_con_units_taken %>" name="CONUNITS"></td>
                                <td><input type="text" value="<%= remaining_con_units %>" name="CONUNITS"></td>
                                <td><input type="text" value="<%= min_con_gpa %>" name="CONGPA"></td>
                                <td><input type="text" value="<%= curr_con_gpa %>" name="CONGPA"></td>
                                <td><input type="text" value="<%= finished %>" name="FINISHED"></td>
                            </form>
                        </tr>

                        <%
                            }
                        %>

                        <tr>
                            <th>Finished Concentrations</th>
                        </tr>

                        <%
                            for (String con_name : finished_cons) {
                        %>

                        <tr>
                            <form>
                                <td><input type="text" value="<%= con_name %>" name="CONNAME"></td>
                            </form>
                        </tr>

                        <%
                            }
                        %>


                        <%
                            PreparedStatement pstmt5 = conn.prepareStatement(
                            ("SELECT * FROM concentrations WHERE DEPARTMENT = ?"));

                            pstmt5.setString(1, curr_dep_rs.getString("DEPARTMENT"));

                            ResultSet concentrations_rs2 = pstmt5.executeQuery();
                        %>

                        <tr>
                            <th>Unfinished Concentration Courses</th>
                        </tr>

                        <%
                            while (concentrations_rs2.next()) {
                        %>

                            <tr>
                                <th>Concentration Name: </th>
                                <th><%= concentrations_rs2.getString("CONNAME") %></th>
                            </tr>

                            <tr>
                                <th>Course ID</th>
                                <th>Course Name</th>
                                <th>Next Offered Quarter</th>
                                <th>Next Offered Year</th>
                            </tr>

                            <%
                                String curr_con_name = concentrations_rs2.getString("CONNAME");

                                PreparedStatement pstmt_unf_courses = conn.prepareStatement(
                                ("SELECT * FROM Course WHERE COURSEID IN (SELECT COURSEID FROM " +
                                "concentration_courses WHERE DEPARTMENT = ? AND CONNAME = ?) AND COURSEID " + 
                                "NOT IN (SELECT COURSEID FROM classes_taken WHERE STUDENTID = ?)"));

                                pstmt_unf_courses.setString(1, curr_dep_rs.getString("DEPARTMENT"));
                                pstmt_unf_courses.setString(2, curr_con_name);
                                pstmt_unf_courses.setInt(3, curr_id);

                                ResultSet unf_courses_rs = pstmt_unf_courses.executeQuery();

                                while (unf_courses_rs.next()) {

                                    int unf_course_id = unf_courses_rs.getInt("COURSEID");

                                    String min_qtr = "TBA";
                                    String min_year_string = "TBA";
                                    int min_year = 0;

                                    PreparedStatement pstmt_next_class = conn.prepareStatement(
                                    ("SELECT * FROM Classes WHERE COURSEID = ? AND (YEAR > ? " + 
                                    "OR YEAR = ? AND QUARTER = ?)"));

                                    pstmt_next_class.setInt(1, unf_course_id);
                                    pstmt_next_class.setInt(2, 2018);
                                    pstmt_next_class.setInt(3, 2018);
                                    pstmt_next_class.setString(4, "Fall");

                                    ResultSet next_class_rs = pstmt_next_class.executeQuery();

                                    while (next_class_rs.next()) {
                                        String next_class_qtr = next_class_rs.getString("QUARTER");
                                        int next_class_year = next_class_rs.getInt("YEAR");


                                        if (min_qtr.equals("TBA")) {
                                            min_qtr = next_class_qtr;
                                        }
                                        if (min_year == 0) {
                                            min_year = next_class_year;
                                        }

                                        if (next_class_year < min_year) {
                                            min_qtr = next_class_qtr;
                                            min_year = next_class_year;
                                        }
                                        else if (next_class_qtr.compareTo(min_qtr) > 0 && 
                                                next_class_year == min_year) {
                                            min_qtr = next_class_qtr;
                                            min_year = next_class_year;
                                        }
                                    }

                                    if (min_year != 0) {
                                        min_year_string = Integer.toString(min_year);
                                    }


                            %>

                            <tr>
                                <td><input type="text" value="<%= unf_course_id %>" name="COURSEID"></td>
                                <td><input type="text" value="<%= unf_courses_rs.getString("COURSENUM") %>" name="COURSENUM"></td>
                                <td><input type="text" value="<%= min_qtr %>" name="CONNAME"></td>
                                <td><input type="text" value="<%= min_year_string %>" name="CONNAME"></td>

                            </tr>


                            <%
                                }
                            %>






                        <%
                            }
                        %>


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
                    department_rs.close();

                    // Close the Statement
                    student_statement.close();
                    department_statement.close();

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