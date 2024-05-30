<%@ page language="java" import="java.sql.*" %>
<html>
<body>
    <table>
        <tr>
            <td>
                <jsp:include page="menu.html" />
            </td>
            <td>
                <%
                    try {
                        String url = "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=HPost1QGres!&ssl=false";
                        Connection conn = DriverManager.getConnection(url);
                        conn.setAutoCommit(false);
                        String action = request.getParameter("action");
                        if ("insert".equals(action) || "update".equals(action)) {
                            conn.setAutoCommit(false);
                            int studentId = Integer.parseInt(request.getParameter("STUDENTID"));
                            int courseId = Integer.parseInt(request.getParameter("COURSEID"));
                            int sectionId = Integer.parseInt(request.getParameter("SECTIONID"));
                            String quarter = request.getParameter("QUARTER");
                            int year = Integer.parseInt(request.getParameter("YEAR"));
                            int numUnits = Integer.parseInt(request.getParameter("NUMUNITS"));
                            int position = Integer.parseInt(request.getParameter("POSITION"));

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
                            conn.setAutoCommit(false);

                            if (count == 0) {
                                out.println("<p>Invalid course-section-quarter-year combination. No action performed.</p>");
                            } else {
                                PreparedStatement pstmt = null;
                                if ("insert".equals(action)) {

                                    PreparedStatement pstmt_get_count = conn.prepareStatement(
                                        "SELECT MAX(POSITION) AS MAXCOUNT FROM course_waitlist WHERE COURSEID = ? " + 
                                        "AND SECTIONID = ? AND QUARTER = ? AND YEAR = ?");
                                    
                                    pstmt_get_count.setInt(1, courseId);
                                    pstmt_get_count.setInt(2, sectionId);
                                    pstmt_get_count.setString(3, quarter);
                                    pstmt_get_count.setInt(4, year);
                                    
                                    int max_count = 0;
                                    
                                    ResultSet max_count_rs = pstmt_get_count.executeQuery();

                                    if (max_count_rs.next()) {
                                        max_count = max_count_rs.getInt("MAXCOUNT") + 1;
                                    }

                                    pstmt = conn.prepareStatement(
                                        "INSERT INTO course_waitlist (STUDENTID, COURSEID, SECTIONID, QUARTER, YEAR, NUMUNITS, POSITION) VALUES (?, ?, ?, ?, ?, ?, ?)");
                                    pstmt.setInt(1, studentId);
                                    pstmt.setInt(2, courseId);
                                    pstmt.setInt(3, sectionId);
                                    pstmt.setString(4, quarter);
                                    pstmt.setInt(5, year);
                                    pstmt.setInt(6, numUnits);
                                    pstmt.setInt(7, max_count);
                                } else if ("update".equals(action)) {
                                    pstmt = conn.prepareStatement(
                                        "UPDATE course_waitlist SET NUMUNITS = ?, POSITION = ? WHERE STUDENTID = ? AND COURSEID = ? AND SECTIONID = ? AND QUARTER = ? AND YEAR = ?");
                                    pstmt.setInt(1, numUnits);
                                    pstmt.setInt(2, position);
                                    pstmt.setInt(3, studentId);
                                    pstmt.setInt(4, courseId);
                                    pstmt.setInt(5, sectionId);
                                    pstmt.setString(6, quarter);
                                    pstmt.setInt(7, year);
                                }
                                pstmt.executeUpdate();
                                pstmt.close();
                                conn.setAutoCommit(false);

                                conn.commit();
                            }
                            conn.setAutoCommit(true);
                        } else if ("delete".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM course_waitlist WHERE STUDENTID = ? AND COURSEID = ? AND QUARTER = ? AND YEAR = ? AND SECTIONID = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSEID")));
                            pstmt.setString(3, request.getParameter("QUARTER"));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("SECTIONID")));
                            pstmt.executeUpdate();
                            conn.commit();
                        } 

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM course_waitlist ORDER BY POSITION");
                %>
                <table>
                    <tr>
                        <th>Student ID</th>
                        <th>Course ID</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Section ID</th>
                        <th>Number of Units</th>
                        <th>Position</th>
                    </tr>
                    <tr>
                        <form action="course_waitlist_form.jsp" method="post">
                            <td><input type="text" name="STUDENTID" /></td>
                            <td><input type="text" name="COURSEID" /></td>
                            <td><input type="text" name="QUARTER" /></td>
                            <td><input type="text" name="YEAR" /></td>
                            <td><input type="text" name="SECTIONID" /></td>
                            <td><input type="text" name="NUMUNITS" /></td>
                            <td><input type="text" name="POSITION" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="course_waitlist_form.jsp" method="post">
                            <td><input type="hidden" name="STUDENTID" value="<%= rs.getInt("STUDENTID") %>" /><%= rs.getInt("STUDENTID") %></td>
                            <td><input type="hidden" name="COURSEID" value="<%= rs.getInt("COURSEID") %>" /><%= rs.getInt("COURSEID") %></td>
                            <td><input type="hidden" name="QUARTER" value="<%= rs.getString("QUARTER") %>" /><%= rs.getString("QUARTER") %></td>
                            <td><input type="hidden" name="YEAR" value="<%= rs.getInt("YEAR") %>" /><%= rs.getInt("YEAR") %></td>
                            <td><input type="hidden" name="SECTIONID" value="<%= rs.getInt("SECTIONID") %>" /><%= rs.getInt("SECTIONID") %></td>
                            <td><input type="text" name="NUMUNITS" value="<%= rs.getInt("NUMUNITS") %>" /></td>
                            <td><input type="text" name="POSITION" value="<%= rs.getInt("POSITION") %>" /></td>
                            <td>
                                <input type="submit" name="action" value="update" />
                                <input type="submit" name="action" value="delete" />
                            </td>
                        </form>
                    </tr>
                    <%
                        }
                        rs.close();
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException sqle) {
                        out.println(sqle.getMessage());
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                    %>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
