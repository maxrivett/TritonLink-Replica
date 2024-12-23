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
                        ("SELECT * FROM student");
                %>

                <form action="class_schedule_report.jsp" method="get">
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
                        <option value="None">
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
                            ("SELECT DISTINCT class_top.* FROM classes class_top WHERE " + 
                            "class_top.QUARTER = ? AND class_top.YEAR = ? AND (class_top.COURSEID, " + 
                            "class_top.QUARTER, class_top.YEAR) NOT IN " + 
                            "(SELECT classes.COURSEID, classes.QUARTER, classes.YEAR FROM classes WHERE EXISTS " + 
                            "(SELECT * FROM class_section WHERE classes.YEAR = ? AND classes.QUARTER = ? " + 
                            "AND classes.YEAR = class_section.YEAR AND classes.QUARTER = class_section.QUARTER " + 
                            "AND classes.COURSEID = class_section.COURSEID " +
                            "AND (class_section.SECTIONID, class_section.COURSEID, " + 
                            "class_section.QUARTER, class_section.YEAR) " + 
                            
                            // selects all sections S2 such that there is a conflict with some regular meeting that it has that conflicts
                            // with another meeting S1 that student is enrolled in
                            
                            "NOT IN ((SELECT DISTINCT section2.SECTIONID, section2.COURSEID, " + 
                            "section2.QUARTER, section2.YEAR FROM course_enrollment, " + 
                            "class_section section1, class_section section2, regular_meeting rm1, " + 
                            "regular_meeting rm2, day_conversion dc1, day_conversion dc2 WHERE " + 
                            "course_enrollment.QUARTER = ? AND course_enrollment.YEAR = ? AND " + 
                            "course_enrollment.SECTIONID = section1.SECTIONID AND " + 
                            "course_enrollment.COURSEID = section1.COURSEID AND " + 
                            "course_enrollment.QUARTER = section1.QUARTER AND " + 
                            "course_enrollment.YEAR = section1.YEAR AND " + 
                            "course_enrollment.STUDENTID = ? AND " + 
                            "section1.SECTIONID = rm1.SECTIONID AND " + 
                            "(((rm1.STARTHOUR * 60 + rm1.STARTMINUTE >= rm2.STARTHOUR * 60 + rm2.STARTMINUTE) AND " + 
                            "(rm1.STARTHOUR * 60 + rm1.STARTMINUTE <= rm2.ENDHOUR * 60 + rm2.ENDMINUTE)) OR " + 
                            "((rm1.ENDHOUR * 60 + rm1.ENDMINUTE >= rm2.STARTHOUR * 60 + rm2.STARTMINUTE) AND " + 
                            "(rm1.ENDHOUR * 60 + rm1.ENDMINUTE <= rm2.ENDHOUR * 60 + rm2.ENDMINUTE)) " + 
                            "OR (rm1.STARTHOUR * 60 + rm1.STARTMINUTE <= rm2.STARTHOUR * 60 + rm2.STARTMINUTE AND rm2.STARTHOUR * 60 + rm2.STARTMINUTE <= rm1.ENDHOUR * 60 + rm1.ENDMINUTE) " + 
                            "OR (rm2.STARTHOUR * 60 + rm2.STARTMINUTE <= rm1.STARTHOUR * 60 + rm1.STARTMINUTE AND rm1.STARTHOUR * 60 + rm1.STARTMINUTE <= rm2.ENDHOUR * 60 + rm2.ENDMINUTE)) " + 
                            "AND rm1.WEEKDAY = dc1.DAYCODE AND rm2.WEEKDAY = dc2.DAYCODE " + 
                            "AND dc1.DAY = dc2.DAY AND rm2.SECTIONID = section2.SECTIONID " + 
                            "AND (section1.COURSEID, section1.QUARTER, section1.YEAR) <> " + 
                            "(section2.COURSEID, section2.QUARTER, section2.YEAR))))) " + 
                            "AND (class_top.COURSEID, class_top.QUARTER, class_top.YEAR) " + 
                            "NOT IN (SELECT COURSEID, QUARTER, YEAR FROM course_enrollment WHERE " + 
                            "STUDENTID = ?)"));

                            int curr_id = Integer.parseInt(request.getParameter("STUDENTID"));

                            pstmt.setString(1, "Spring");
                            pstmt.setInt(2, 2018);
                            pstmt.setInt(3, 2018);
                            pstmt.setString(4, "Spring");
                            pstmt.setString(5, "Spring");
                            pstmt.setInt(6, 2018);
                            pstmt.setInt(7, curr_id);
                            pstmt.setInt(8, curr_id);

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
                        <th>Can't take / Because of</th>
                        <th>Title</th>
                        <th>Course ID</th>
                    </tr>

                    <%
                        while (classes_rs.next()) {
                    %>

                    <tr>
                        <form>
                            <td><input type="text" value="Can't take" name="REASON"></td>
                            <td><input type="text" value="<%= classes_rs.getString("TITLE") %>" name="TITLE"></td>
                            <td><input type="text" value="<%= classes_rs.getInt("COURSEID") %>" name="COURSEID"></td>
                        </form>
                    </tr>

                        <%
                            PreparedStatement pstmt_bad_classes = conn.prepareStatement(
                                ("SELECT DISTINCT classes.* FROM classes, class_section WHERE " + 
                                "classes.YEAR = ? AND classes.QUARTER = ? " + 
                                "AND classes.YEAR = class_section.YEAR AND classes.QUARTER = class_section.QUARTER " + 
                                "AND classes.COURSEID = class_section.COURSEID " +
                                "AND (classes.COURSEID, classes.QUARTER, classes.YEAR) IN " + 
                                "(SELECT COURSEID, QUARTER, YEAR FROM class_section WHERE " + 
                                "(SECTIONID, COURSEID, QUARTER, YEAR) " + 
                                "IN ((SELECT section2.SECTIONID, section2.COURSEID, " + 
                                "section2.QUARTER, section2.YEAR FROM course_enrollment, " + 
                                "class_section section1, class_section section2, regular_meeting rm1, " + 
                                "regular_meeting rm2, day_conversion dc1, day_conversion dc2 WHERE " + 
                                "section1.QUARTER = ? AND section1.YEAR = ? AND " + 
                                "section1.COURSEID = ? AND " + 
                                "course_enrollment.SECTIONID = section2.SECTIONID AND " + 
                                "course_enrollment.COURSEID = section2.COURSEID AND " + 
                                "course_enrollment.QUARTER = section2.QUARTER AND " + 
                                "course_enrollment.YEAR = section2.YEAR AND " + 
                                "course_enrollment.STUDENTID = ? AND " + 
                                "section1.SECTIONID = rm1.SECTIONID AND " + 
                                "(((rm1.STARTHOUR * 60 + rm1.STARTMINUTE >= rm2.STARTHOUR * 60 + rm2.STARTMINUTE) AND " + 
                                "(rm1.STARTHOUR * 60 + rm1.STARTMINUTE <= rm2.ENDHOUR * 60 + rm2.ENDMINUTE)) OR " + 
                                "((rm1.ENDHOUR * 60 + rm1.ENDMINUTE >= rm2.STARTHOUR * 60 + rm2.STARTMINUTE) AND " + 
                                "(rm1.ENDHOUR * 60 + rm1.ENDMINUTE <= rm2.ENDHOUR * 60 + rm2.ENDMINUTE))) " + 
                                "AND rm1.WEEKDAY = dc1.DAYCODE AND rm2.WEEKDAY = dc2.DAYCODE " + 
                                "AND dc1.DAY = dc2.DAY AND rm2.SECTIONID = section2.SECTIONID " + 
                                "AND (section1.COURSEID, section1.QUARTER, section1.YEAR) <> " + 
                                "(section2.COURSEID, section2.QUARTER, section2.YEAR))))"));

                            pstmt_bad_classes.setInt(1, 2018);
                            pstmt_bad_classes.setString(2, "Spring");
                            pstmt_bad_classes.setString(3, "Spring");
                            pstmt_bad_classes.setInt(4, 2018);
                            pstmt_bad_classes.setInt(5, classes_rs.getInt("COURSEID"));
                            pstmt_bad_classes.setInt(6, curr_id);

                            ResultSet bad_classes_rs = pstmt_bad_classes.executeQuery();

                            while (bad_classes_rs.next()) {
                        %>


                        <tr>
                            <form>
                                <td><input type="text" value="Because of" name="REASON"></td>
                                <td><input type="text" value="<%= bad_classes_rs.getString("TITLE") %>" name="TITLE"></td>
                                <td><input type="text" value="<%= bad_classes_rs.getInt("COURSEID") %>" name="COURSEID"></td>
                            </form>
                        </tr>



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