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
                    // Check if an initialization is requested
                    String action = request.getParameter("action");
                    if (action != null && action.equals("populate")) {
                        conn.setAutoCommit(false);

                        ArrayList<String> insertion_strings = new ArrayList<String>();

                        String[] first_name = {"John", "Jane", "Alice", "Bob", "Carol", "David", "Eve", "Vincent"};
                        int student_count = 0;

                        String[] m_initial = {"A", "B", "C", "D", "E", "F", "G", "N"};

                        String[] last_name = {"Doe", "Smith", "Johnson", "Brown", "Davis", "Miller", "Wilson", "Terry"};

                        int[] ssns = {123456789, 987654321, 567891234, 234567890, 345678901, 456789012, 567890123, 737690125};

                        String[] course_names = {"CSE132A", "CSE291", "CSE101", "CSE132B", "CSE232A", "MATH101", "PHYS101", "BIO101", 
                            "CHEM101", "STAT101", "CSE132C", "CSE291B"};
                        boolean[] course_labs = {true, false, true, true, true, false, true, true, true, false, false, false};

                        String[] class_names = {"DB System Principles", "Advanced Topics in CS", "Introduction to Programming", 
                            "Advanced Databases", "Machine Learning Algorithms", "Calculus 1", "Physics 1", 
                            "Introduction to Biology", "General Chemistry", "Introduction to Statistics",
                            "DB System Principles 2", "Advanced Topics in Machine Learning 2", "Database System Applications"};
                        
                        String[] class_quarters = {"Spring", "Fall", "Winter", "Winter", "Spring", "Spring", "Fall", "Spring", 
                            "Fall", "Winter", "Fall", "Winter", "Spring"};
                        
                        int[] class_years = {2018, 2017, 2017, 2018, 2018, 2017, 2017, 2017, 2017, 2018, 2017, 2019, 2018};

                        int[] class_courses = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 12, 11};

                        String[] faculty_names = {"Dr. Alan Turing", "Dr. Ada Lovelace", "Dr. Andrew Ng", "Dr. Geoffrey Hinton", 
                            "Dr. Carl Gauss", "Dr. Albert Einstein", "Dr. James Watson", "Dr. Marie Curie", "Dr. John Tukey", 
                            "Dr. Ian Goodfellow", "Dr. Alin D"};

                        String[] section_faculty = {"Dr. Alan Turing", "Dr. Ada Lovelace", "Dr. Andrew Ng", "Dr. Alan Turing", 
                            "Dr. Geoffrey Hinton", "Dr. Carl Gauss", "Dr. Albert Einstein", "Dr. James Watson", "Dr. Marie Curie", 
                            "Dr. John Tukey", "Dr. Alan Turing", "Dr. Ian Goodfellow", "Dr. Alin D"};
                        
                        int[] meet_start_hrs = {10, 11, 13, 14, 11, 9, 8, 10, 11, 12, 10, 13, 11};

                        int[] past_section_id = {2, 3, 3, 4, 6, 7, 8, 9, 10, 11, 2, 3, 3, 4, 4, 4};
                        int[] past_student_id = {1, 1, 2, 3, 4, 5, 6, 7, 1, 1, 2, 7, 6, 4, 5, 6};
                        String[] past_grades = {"A", "B+", "B", "A-", "B+", "A", "A", "B+", "A-", "A", "A-", "A", "A", "B-", "B-", "IN"};

                        int[] curr_section_id = {1, 1, 5, 1, 1, 1, 1, 1};
                        int[] curr_student_id = {1, 2, 2, 3, 4, 5, 6, 7};


                        String[] weekdays = {"M", "Tu", "W", "Th", "MWF"};

                        String[] bs_deg = {"BSC in Computer Science", "BSC in Mathematics", "BSC in Physics", "BSC in Biology", 
                            "BSC in Chemistry", "BSC in Statistics"};
                        
                        int[] bs_total_units = {134, 120, 120, 120, 120, 120};
                        int[][] cat_units = {{70, 60, 60, 60, 60, 60}, {40, 40, 40, 40, 40, 40}, 
                            {24, 20, 20, 20, 20, 20}};

                        String[] ms_deg = {"MS in Computer Science"};

                        String[] categories = {"lower division", "upper division", "technical elective"};

                        String[] concentrations = {"Machine Learning"};

                        int[] ms_cat_units = {0, 25, 20};

                        int[] con_courses = {2, 5, 12};

                        String[][] course_categories = {{"upper division"}, {"technical elective"}, {"lower division"}, 
                            {"upper division", "technical elective"}, {"technical elective"}, 
                            {"lower division"}, {"lower division"}, {"lower division"}, {"lower division"}, 
                            {"lower division"}, {"lower division"}, {"lower division"}};

                        String[] course_departments = {"BSC in Computer Science", "BSC in Computer Science", 
                            "BSC in Computer Science", "BSC in Computer Science", "BSC in Computer Science", 
                            "BSC in Mathematics", "BSC in Physics", "BSC in Biology", "BSC in Chemistry", 
                            "BSC in Statistics", "BSC in Computer Science", "BSC in Computer Science"};


                        int[] base_course = {1, 4, 5};
                        int[] prerequisite = {3, 1, 1};


                        String[] letter_grades = {"A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", 
                            "D", "IN"};
                                                
                        int grade_idx = 0;

                        int sid = 1;

                        float account_bal = (float) 40.99;

                        int curr_hour = 0;
                        int hour_offset = 8;

                        for (int i = 0; i < first_name.length; i++) {
                            if (i == 1) {
                                String fname = first_name[student_count];
                                String mname = m_initial[student_count];
                                String lname = last_name[student_count];

                                PreparedStatement pstmt = conn.prepareStatement(
                                ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                                pstmt.setInt(1, sid);
                                pstmt.setString(2, fname);
                                pstmt.setString(3, mname);
                                pstmt.setString(4, lname);
                                pstmt.setBoolean(5, true);
                                pstmt.setInt(6, ssns[student_count]);
                                pstmt.setString(7, "CA");
                                pstmt.setFloat(8, account_bal);

                                pstmt.executeUpdate();

                                PreparedStatement pstmt2 = conn.prepareStatement(
                                ("INSERT INTO graduate VALUES (?, ?, ?)"));

                                pstmt2.setInt(1, sid);
                                pstmt2.setString(2, "CSE");
                                pstmt2.setString(3, "Masters");

                                pstmt2.executeUpdate();

                                sid++;

                                student_count = (student_count + 1) % first_name.length;
                            }
                            else {
                                String fname = first_name[student_count];
                                String mname = m_initial[student_count];
                                String lname = last_name[student_count];

                                PreparedStatement pstmt = conn.prepareStatement(
                                ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                                pstmt.setInt(1, sid);
                                pstmt.setString(2, fname);
                                pstmt.setString(3, mname);
                                pstmt.setString(4, lname);
                                pstmt.setBoolean(5, true);
                                pstmt.setInt(6, ssns[student_count]);
                                pstmt.setString(7, "CA");
                                pstmt.setFloat(8, account_bal);

                                pstmt.executeUpdate();

                                PreparedStatement pstmt2 = conn.prepareStatement(
                                ("INSERT INTO undergrad VALUES (?, ?, ?, ?, ?)"));

                                pstmt2.setInt(1, sid);
                                pstmt2.setString(2, "CSE");
                                pstmt2.setString(3, "MUS");
                                pstmt2.setString(4, "Sixth");
                                pstmt2.setBoolean(5, false);
                                
                                pstmt2.executeUpdate();

                                sid++;

                                student_count = (student_count + 1) % first_name.length;
                            }
                        
                        }
                        
                        for (int i = 0; i < faculty_names.length; i++) {

                            String faculty_name = faculty_names[i];

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO faculty VALUES (?, ?, ?)"));

                            pstmt.setString(1, faculty_name);
                            pstmt.setString(2, "Professor");
                            pstmt.setString(3, "CSE");

                            pstmt.executeUpdate();

                        }

                        for (int i = 0; i < 12; i++) {

                            String course_name = course_names[i];
                            int cid = i + 1;
                            Boolean su = false;
                            if (i == 1) {
                                su = true;
                            }

                            PreparedStatement pstmt_course = conn.prepareStatement(
                            ("INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_course.setInt(1, cid);
                            pstmt_course.setBoolean(2, course_labs[i]);
                            pstmt_course.setBoolean(3, su);
                            pstmt_course.setBoolean(4, true);
                            pstmt_course.setString(5, course_name);
                            pstmt_course.setInt(6, 4);
                            pstmt_course.setInt(7, 4);
                            pstmt_course.setBoolean(8, false);

                            pstmt_course.executeUpdate();
                        }

                        for (int i = 0; i < 13; i++) {
                            PreparedStatement pstmt_class = conn.prepareStatement(
                            ("INSERT INTO Classes VALUES (?, ?, ?, ?)"));

                            pstmt_class.setInt(1, class_courses[i]);
                            pstmt_class.setString(2, class_quarters[i]);
                            pstmt_class.setInt(3, class_years[i]);
                            pstmt_class.setString(4, class_names[i]);

                            pstmt_class.executeUpdate();

                            PreparedStatement pstmt_section = conn.prepareStatement(
                            ("INSERT INTO Sections (SECTIONID, FACULTYNAME, NUMENROLLED, ENROLLLIMIT) VALUES (?, ?, ?, ?)"));

                            pstmt_section.setInt(1, i+1);
                            pstmt_section.setString(2, section_faculty[i]);
                            pstmt_section.setInt(3, 0);
                            pstmt_section.setInt(4, 7);

                            pstmt_section.executeUpdate();

                            PreparedStatement pstmt_class_section = conn.prepareStatement(
                            ("INSERT INTO class_section VALUES (?, ?, ?, ?)"));

                            pstmt_class_section.setInt(1, i+1);
                            pstmt_class_section.setInt(2, class_courses[i]);
                            pstmt_class_section.setString(3, class_quarters[i]);
                            pstmt_class_section.setInt(4, class_years[i]);

                            pstmt_class_section.executeUpdate();

                            PreparedStatement pstmt_meeting = conn.prepareStatement(
                            ("INSERT INTO regular_meeting VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_meeting.setInt(1, i+1);
                            pstmt_meeting.setInt(2, meet_start_hrs[i]);
                            pstmt_meeting.setInt(3, 0);
                            pstmt_meeting.setInt(4, meet_start_hrs[i]);
                            pstmt_meeting.setInt(5, 50);
                            pstmt_meeting.setString(6, "MWF");
                            pstmt_meeting.setString(7, "Lecture");
                            pstmt_meeting.setBoolean(8, true);
                            pstmt_meeting.setString(9, "CENTR");
                            pstmt_meeting.setString(10, "115");

                            pstmt_meeting.executeUpdate();
                        }

                        for (int i = 0; i < past_section_id.length; i++) {
                            PreparedStatement pstmt_classes_taken = conn.prepareStatement(
                            ("INSERT INTO classes_taken VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_classes_taken.setInt(1, past_student_id[i]);
                            pstmt_classes_taken.setInt(2, class_courses[past_section_id[i] - 1]);
                            pstmt_classes_taken.setInt(3, past_section_id[i]);
                            pstmt_classes_taken.setString(4, class_quarters[past_section_id[i] - 1]);
                            pstmt_classes_taken.setInt(5, class_years[past_section_id[i] - 1]);
                            pstmt_classes_taken.setInt(6, 4);
                            pstmt_classes_taken.setString(7, past_grades[i]);
                            pstmt_classes_taken.setString(8, "Letter");

                            pstmt_classes_taken.executeUpdate();
                        }

                        for (int i = 0; i < curr_section_id.length; i++) {
                            PreparedStatement pstmt_classes_taking = conn.prepareStatement(
                            ("INSERT INTO course_enrollment VALUES (?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_classes_taking.setInt(1, curr_student_id[i]);
                            pstmt_classes_taking.setInt(2, class_courses[curr_section_id[i] - 1]);
                            pstmt_classes_taking.setString(3, class_quarters[curr_section_id[i] - 1]);
                            pstmt_classes_taking.setInt(4, class_years[curr_section_id[i] - 1]);
                            pstmt_classes_taking.setInt(5, curr_section_id[i]);
                            pstmt_classes_taking.setInt(6, 4);
                            pstmt_classes_taking.setString(7, "Letter");

                            pstmt_classes_taking.executeUpdate();
                        }


                        for (int i = 0; i < bs_deg.length; i++) {

                            PreparedStatement pstmt_bs_deg = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt_bs_deg.setString(1, bs_deg[i]);
                            pstmt_bs_deg.setString(2, "BS");
                            pstmt_bs_deg.setInt(3, bs_total_units[i]);

                            pstmt_bs_deg.executeUpdate();

                            for (int j = 0; j < categories.length; j++) {
                                PreparedStatement pstmt_bs_cat = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt_bs_cat.setString(1, bs_deg[i]);
                                pstmt_bs_cat.setString(2, categories[j]);
                                pstmt_bs_cat.setFloat(3, (float) 3.0);
                                pstmt_bs_cat.setInt(4, cat_units[j][i]);

                                pstmt_bs_cat.executeUpdate();
                            }
                        }

                        for (int i = 0; i < ms_deg.length; i++) {

                            PreparedStatement pstmt_ms_deg = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt_ms_deg.setString(1, ms_deg[i]);
                            pstmt_ms_deg.setString(2, "MS");
                            pstmt_ms_deg.setInt(3, 45);

                            pstmt_ms_deg.executeUpdate();


                            for (int j = 0; j < categories.length; j++) {
                                PreparedStatement pstmt_ms_cat = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt_ms_cat.setString(1, ms_deg[i]);
                                pstmt_ms_cat.setString(2, categories[j]);
                                pstmt_ms_cat.setFloat(3, (float) 3.0);
                                pstmt_ms_cat.setInt(4, ms_cat_units[j]);

                                pstmt_ms_cat.executeUpdate();
                            }

                            PreparedStatement pstmt_ms = conn.prepareStatement(
                                ("INSERT INTO masters_deg VALUES (?)"));
                            pstmt_ms.setString(1, ms_deg[i]);

                            pstmt_ms.executeUpdate();

                            PreparedStatement pstmt_ms_con = conn.prepareStatement(
                                ("INSERT INTO concentrations VALUES (?, ?, ?, ?)"));
                            pstmt_ms_con.setString(1, ms_deg[i]);
                            pstmt_ms_con.setString(2, "Machine Learning");
                            pstmt_ms_con.setFloat(3, (float) 3.0);
                            pstmt_ms_con.setInt(4, 12);

                            pstmt_ms_con.executeUpdate();
                            
                        }

                        for (int i = 0; i < course_categories.length; i++) {
                            for (int j = 0; j < course_categories[i].length; j++) {
                                PreparedStatement pstmt_course_cat = conn.prepareStatement(
                                ("INSERT INTO category_courses VALUES (?, ?, ?)"));

                                pstmt_course_cat.setString(1, course_departments[i]);
                                pstmt_course_cat.setString(2, course_categories[i][j]);
                                pstmt_course_cat.setInt(3, i + 1);

                                pstmt_course_cat.executeUpdate();
                            }
                            if (i < 5 || i > 9) {
                                for (int j = 0; j < course_categories[i].length; j++) {
                                    PreparedStatement pstmt_course_cat = conn.prepareStatement(
                                    ("INSERT INTO category_courses VALUES (?, ?, ?)"));
    
                                    pstmt_course_cat.setString(1, ms_deg[0]);
                                    pstmt_course_cat.setString(2, course_categories[i][j]);
                                    pstmt_course_cat.setInt(3, i + 1);
    
                                    pstmt_course_cat.executeUpdate();
                                }
                            }
                        }

                        for (int i = 0; i < base_course.length; i++) {
                            PreparedStatement pstmt_prereq = conn.prepareStatement(
                            ("INSERT INTO prerequisites VALUES (?, ?)"));

                            pstmt_prereq.setInt(1, base_course[i]);
                            pstmt_prereq.setInt(2, prerequisite[i]);

                            pstmt_prereq.executeUpdate();
                        }

                        for (int i = 0; i < con_courses.length; i++) {
                            PreparedStatement pstmt_con_cat = conn.prepareStatement(
                            ("INSERT INTO concentration_courses VALUES (?, ?, ?)"));

                            pstmt_con_cat.setString(1, "MS in Computer Science");
                            pstmt_con_cat.setString(2, "Machine Learning");
                            pstmt_con_cat.setInt(3, con_courses[i]);

                            pstmt_con_cat.executeUpdate();
                        }


                        

                        for (String create_stmt : insertion_strings) {
                            PreparedStatement cstmt = conn.prepareStatement(create_stmt);
                            cstmt.executeUpdate();
                        }

                        conn.commit();
                        conn.setAutoCommit(true);
                    }
                %>

                <table>
                    <tr>
                        <form action="populate_tables_standard.jsp" method="get">
                            <input type="hidden" value="populate" name="action">
                            <th><input type="submit" value="Populate"></th>
                        </form>
                    </tr>
                </table>

                <%

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