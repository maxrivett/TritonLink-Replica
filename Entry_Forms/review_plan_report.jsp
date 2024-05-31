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
                    PreparedStatement pstmt_section = conn.prepareStatement(
                        ("SELECT * FROM class_section WHERE QUARTER = ? AND YEAR = ?"));

                    pstmt_section.setString(1, "Spring");
                    pstmt_section.setInt(2, 2018);

                    ResultSet section_rs = pstmt_section.executeQuery();

                    PreparedStatement pstmt_days = conn.prepareStatement(
                        ("SELECT DISTINCT MONTH, DAY FROM review_slots " + 
                        "WHERE MONTH >= 4 AND MONTH <= 6 ORDER BY MONTH, DAY"));

                    // pstmt_section.setString(1, "Spring");
                    // pstmt_section.setInt(2, 2018);

                    ResultSet start_days_rs = pstmt_days.executeQuery();

                    pstmt_days = conn.prepareStatement(
                        ("SELECT DISTINCT MONTH, DAY FROM review_slots " + 
                        "WHERE MONTH >= 4 AND MONTH <= 6 ORDER BY MONTH, DAY"));

                    ResultSet end_days_rs = pstmt_days.executeQuery();
                    
                %>

                <form action="review_plan_report.jsp" method="get">
                    <label for="sections">Choose a section and range: </label>
                    <input type="hidden" value="submit" name="action">
                    <select name="SECTIONDATA" id="SECTIONDATA">
                        <%
                            while (section_rs.next()) {
                                String section_opt = "";
                                section_opt = section_opt + "Section ID: " + section_rs.getInt("SECTIONID") + ", ";
                                section_opt = section_opt + "Course ID: " + section_rs.getInt("COURSEID") + ", ";
                                section_opt = section_opt + section_rs.getString("QUARTER") + " ";
                                section_opt = section_opt + section_rs.getInt("YEAR");

                                String section_data = "";
                                section_data = section_data + section_rs.getInt("SECTIONID") + "_";
                                section_data = section_data + section_rs.getInt("COURSEID") + "_";
                                section_data = section_data + section_rs.getString("QUARTER") + "_";
                                section_data = section_data + section_rs.getInt("YEAR");
                                
                        %>
                        <option value="<%= section_data %>">
                            <%= section_opt %>
                        </option>
                        <% } %>
                        <option>
                            None
                        </option>
                    </select>
                    <select name="STARTDATE" id="STARTDATE">
                        <%
                            while (start_days_rs.next()) {
                                String start_opt = "";
                                start_opt = start_opt + "Start Month: " + start_days_rs.getInt("MONTH") + ", ";
                                start_opt = start_opt + "Day: " + start_days_rs.getInt("DAY");

                                String start_data = "";
                                start_data = start_data + start_days_rs.getInt("MONTH") + "_";
                                start_data = start_data + start_days_rs.getInt("DAY");
                                
                        %>
                        <option value="<%= start_data %>">
                            <%= start_opt %>
                        </option>
                        <% } %>
                    </select>
                    <select name="ENDDATE" id="ENDDATE">
                        <%
                            while (end_days_rs.next()) {
                                String end_opt = "";
                                end_opt = end_opt + "End Month: " + end_days_rs.getInt("MONTH") + ", ";
                                end_opt = end_opt + "Day: " + end_days_rs.getInt("DAY");

                                String end_data = "";
                                end_data = end_data + end_days_rs.getInt("MONTH") + "_";
                                end_data = end_data + end_days_rs.getInt("DAY");
                                
                        %>
                        <option value="<%= end_data %>">
                            <%= end_opt %>
                        </option>
                        <% } %>
                    </select>
                    <th><input type="submit" value="Submit"></th>
                </form>


                    
                    <%
                        // Iterate over the ResultSet
                        String action = request.getParameter("action");
                        // Check if an insertion is requested
                        if (action != null && action.equals("submit")
                                && !(request.getParameter("SECTIONDATA").equals("None"))) {
                            conn.setAutoCommit(false);

                            String section_data_str = request.getParameter("SECTIONDATA");
                            String[] section_data_arr = section_data_str.split("_");

                            String start_data_str = request.getParameter("STARTDATE");
                            String[] start_data_arr = start_data_str.split("_");

                            String end_data_str = request.getParameter("ENDDATE");
                            String[] end_data_arr = end_data_str.split("_");


                            int curr_sid = Integer.parseInt(section_data_arr[0]);
                            int curr_cid = Integer.parseInt(section_data_arr[1]);
                            String curr_qtr = section_data_arr[2];
                            int curr_year = Integer.parseInt(section_data_arr[3]);

                            int curr_start_mon = Integer.parseInt(start_data_arr[0]);
                            int curr_start_day = Integer.parseInt(start_data_arr[1]);

                            int curr_end_mon = Integer.parseInt(end_data_arr[0]);
                            int curr_end_day = Integer.parseInt(end_data_arr[1]);

                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("SELECT * FROM class_section WHERE SECTIONID = ? AND " + 
                            "COURSEID = ? AND QUARTER = ? AND YEAR = ?"));

                            pstmt2.setInt(1, curr_sid);
                            pstmt2.setInt(2, curr_cid);
                            pstmt2.setString(3, curr_qtr);
                            pstmt2.setInt(4, curr_year);

                            ResultSet curr_section_rs = pstmt2.executeQuery();

                            conn.commit();
                            conn.setAutoCommit(true);
                    %>
                
                    <table>
                        <tr>
                            <th>Section ID</th>
                            <th>Course ID</th>
                            <th>Quarter</th>
                            <th>Year</th>
                        </tr>
                        <%
                            while (curr_section_rs.next()) {
                        %>
                            
                        <tr>
                            <form>
                                <td><input type="text" value="<%= curr_section_rs.getInt("SECTIONID") %>" name="SECTIONID"></td>
                                <td><input type="text" value="<%= curr_section_rs.getInt("COURSEID") %>" name="COURSEID"></td>
                                <td><input type="text" value="<%= curr_section_rs.getString("QUARTER") %>" name="QUARTER"></td>
                                <td><input type="text" value="<%= curr_section_rs.getInt("YEAR") %>" name="YEAR"></td>
                            </form>
                        </tr>

                        <%
                            }

                            boolean possible_range = true;

                            if (curr_start_mon > curr_end_mon) {
                                possible_range = false;
                            }
                            else if (curr_start_mon == curr_end_mon && curr_start_day > curr_end_day) {
                                possible_range = false;
                            }
                            else if (curr_start_mon < 4 || (curr_start_day < 2 && curr_start_mon == 4)) {
                                possible_range = false;
                            }
                            else if ((curr_end_day > 15 && curr_end_mon == 6) || curr_end_mon > 6) {
                                possible_range = false;
                            }

                            if (!possible_range) {
                        %>

                        <th>Impossible range.</th>

                        <%
                            }

                            else {

                                PreparedStatement pstmt_range = conn.prepareStatement(
                                ("SELECT * FROM review_slots WHERE ((MONTH > ? AND MONTH < ?) OR " + 
                                "((? < ?) AND ((MONTH = ? AND DAY >= ?) OR (MONTH = ? AND DAY <= ?))) OR " + 
                                "((? = ?) AND ((MONTH = ? AND DAY >= ? AND DAY <= ?)))) AND " + 
                                "(MONTH, DAY, STARTHOUR, ENDHOUR) NOT IN ((SELECT rev.MONTH, rev.DAY, rev.STARTHOUR, " + 
                                "rev.ENDHOUR FROM review_slots rev, day_conversion dc, regular_meeting rm, course_enrollment ce1, " + 
                                "course_enrollment ce2 WHERE ce1.SECTIONID = ? AND ce1.COURSEID = ? AND ce1.QUARTER = ? " + 
                                "AND ce1.YEAR = ? AND ce1.STUDENTID = ce2.STUDENTID AND ce2.SECTIONID = rm.SECTIONID " + 
                                "AND rm.WEEKDAY = dc.DAYCODE AND rev.WEEKDAY = dc.DAY AND " + 
                                "(((rev.STARTHOUR * 60 >= rm.STARTHOUR * 60 + rm.STARTMINUTE) AND " + 
                                "(rev.STARTHOUR * 60 <= rm.ENDHOUR * 60 + rm.ENDMINUTE)) OR " + 
                                "((rev.ENDHOUR * 60 >= rm.STARTHOUR * 60 + rm.STARTMINUTE) AND " + 
                                "(rev.ENDHOUR * 60 <= rm.ENDHOUR * 60 + rm.ENDMINUTE)))) " + 
                                "UNION (SELECT rev.MONTH, rev.DAY, rev.STARTHOUR, " + 
                                "rev.ENDHOUR FROM review_slots rev, review_session_info rm, course_enrollment ce1, " + 
                                "course_enrollment ce2 WHERE ce1.SECTIONID = ? AND ce1.COURSEID = ? AND ce1.QUARTER = ? " + 
                                "AND ce1.YEAR = ? AND ce1.STUDENTID = ce2.STUDENTID AND ce2.SECTIONID = rm.SECTIONID AND " + 
                                "rev.MONTH = rm.MONTH AND rev.DAY = rm.DAY AND " + 
                                "(((rev.STARTHOUR * 60 >= rm.STARTHOUR * 60 + rm.STARTMINUTE) AND " + 
                                "(rev.STARTHOUR * 60 <= rm.ENDHOUR * 60 + rm.ENDMINUTE)) OR " + 
                                "((rev.ENDHOUR * 60 >= rm.STARTHOUR * 60 + rm.STARTMINUTE) AND " + 
                                "(rev.ENDHOUR * 60 <= rm.ENDHOUR * 60 + rm.ENDMINUTE))))) " +
                                "ORDER BY MONTH, DAY, STARTHOUR"));

                                pstmt_range.setInt(1, curr_start_mon);
                                pstmt_range.setInt(2, curr_end_mon);
                                pstmt_range.setInt(3, curr_start_mon);
                                pstmt_range.setInt(4, curr_end_mon);
                                pstmt_range.setInt(5, curr_start_mon);
                                pstmt_range.setInt(6, curr_start_day);
                                pstmt_range.setInt(7, curr_end_mon);
                                pstmt_range.setInt(8, curr_end_day);
                                
                                pstmt_range.setInt(9, curr_start_mon);
                                pstmt_range.setInt(10, curr_end_mon);
                                pstmt_range.setInt(11, curr_start_mon);
                                pstmt_range.setInt(12, curr_start_day);
                                pstmt_range.setInt(13, curr_end_day);

                                pstmt_range.setInt(14, curr_sid);
                                pstmt_range.setInt(15, curr_cid);
                                pstmt_range.setString(16, curr_qtr);
                                pstmt_range.setInt(17, curr_year);

                                pstmt_range.setInt(18, curr_sid);
                                pstmt_range.setInt(19, curr_cid);
                                pstmt_range.setString(20, curr_qtr);
                                pstmt_range.setInt(21, curr_year);
                                

                                ResultSet range_rs = pstmt_range.executeQuery();

                        %>

                        <tr>
                            <th>Month</th>
                            <th>Day</th>
                            <th>Weekday</th>
                            <th>Start Hour</th>
                            <th>End Hour</th>
                        </tr>

                        <%
                            while(range_rs.next()) {
                        %>

                        <tr>
                            <form action="review_plan_report.jsp" method="get">
                                <input type="hidden" value="view" name="action">
                                <td><input value="<%= range_rs.getString("MONSTR") %>"
                                    name="MONTH"></td>
                                <td><input value="<%= range_rs.getInt("DAY") %>"
                                    name="DAY"></td>
                                <td><input value="<%= range_rs.getString("WEEKDAY") %>"
                                    name="WEEKDAY"></td>
                                <td><input value="<%= range_rs.getInt("STARTHOUR") %>"
                                    name="STARTHOUR"></td>
                                <td><input value="<%= range_rs.getInt("ENDHOUR") %>"
                                    name="ENDHOUR"></td>
                                <td><input type="submit" value="View"></td>
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
                    section_rs.close();

                    // Close the Statement
                    pstmt_section.close();

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