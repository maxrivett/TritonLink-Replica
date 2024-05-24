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
                    Statement student_statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the student table
                    ResultSet student_rs = student_statement.executeQuery
                        ("SELECT * FROM student WHERE STUDENTID IN " + 
                        "(SELECT STUDENTID FROM undergrad)");
                %>

                <%
                    // Create the statement
                    Statement department_statement = conn.createStatement();

                    // Use the statement to SELECT the student attributes
                    // FROM the student table
                    ResultSet department_rs = department_statement.executeQuery
                        ("SELECT * FROM degree WHERE DEPARTMENT NOT IN " + 
                        "(SELECT DEPARTMENT FROM masters_deg)");
                %>

                
                <form action="undergrad_deg_report.jsp" method="get">
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
                    </select>
                    <th><input type="submit" value="Submit"></th>
                </form>


                    
                    <%
                        // Iterate over the ResultSet
                        String action = request.getParameter("action");
                        // Check if an insertion is requested
                        if (action != null && action.equals("submit")) {
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
                            "AND COURSEID IN (SELECT COURSEID FROM category_courses WHERE CATNAME = ?)"));

                            pstmt_cat_classes_taken.setInt(1, curr_id);
                            pstmt_cat_classes_taken.setString(2, curr_cat_name);

                            ResultSet curr_cat_units_rs = pstmt_cat_classes_taken.executeQuery();
                            
                            if (curr_cat_units_rs.next()) {
                                curr_cat_units_taken = curr_cat_units_rs.getInt("CATUNITS");
                            }

                            int remaining_cat_units = categories_rs.getInt("CATUNITS") - curr_cat_units_taken;
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