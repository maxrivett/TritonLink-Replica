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

                        String[] first_name = {"Dan", "John", "Will", "Alice", "Mary"};
                        int fn_size = 5;
                        int fcount = 0;

                        String[] m_initial = {"A", "E", "M", "T"};
                        int mn_size = 4;
                        int mcount = 0;

                        String[] last_name = {"Stevenson", "Doe", "Smith", "Taylor", "Anderson", "Williams"};
                        int ln_size = 6;
                        int lcount = 0;

                        String[] course_names = {"CSE 1", "CSE 2", "CSE 3", "CSE 4", "CSE 5"};

                        String[] quarters = {"Fall", "Winter", "Spring"};

                        String[] faculty_names = {"", "", "", "", "", ""};

                        int[] years = {2016, 2017, 2018};

                        String[] weekdays = {"M", "Tu", "W", "Th", "MWF"};

                        String[] bs_deg = {"MATH", "MUS"};

                        String[] ms_deg = {"CSE", "ECE"};

                        String[] categories = {"Lower", "Technical"};

                        String[] concentrations = {"Upper", "Specialty"};

                        String[] letter_grades = {"A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", 
                            "D", "IN"};
                                                
                        int grade_idx = 0;

                        int sid = 1;

                        float account_bal = (float) 40.99;

                        int curr_hour = 0;
                        int hour_offset = 8;

                        for (int i = 0; i < 2; i++) {
                            String fname = first_name[fcount];
                            String mname = m_initial[mcount];
                            String lname = last_name[lcount];

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt.setInt(1, sid);
                            pstmt.setString(2, fname);
                            pstmt.setString(3, mname);
                            pstmt.setString(4, lname);
                            pstmt.setBoolean(5, true);
                            pstmt.setInt(6, sid);
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

                            fcount = (fcount + 1) % fn_size;
                            mcount = (mcount + 1) % mn_size;
                            lcount = (lcount + 1) % ln_size;

                        }

                        for (int i = 0; i < 2; i++) {
                            String fname = first_name[fcount];
                            String mname = m_initial[mcount];
                            String lname = last_name[lcount];

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt.setInt(1, sid);
                            pstmt.setString(2, fname);
                            pstmt.setString(3, mname);
                            pstmt.setString(4, lname);
                            pstmt.setBoolean(5, true);
                            pstmt.setInt(6, sid);
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

                            fcount = (fcount + 1) % fn_size;
                            mcount = (mcount + 1) % mn_size;
                            lcount = (lcount + 1) % ln_size;

                        }

                        for (int i = 0; i < 2; i++) {
                            String fname = first_name[fcount];
                            String mname = m_initial[mcount];
                            String lname = last_name[lcount];

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt.setInt(1, sid);
                            pstmt.setString(2, fname);
                            pstmt.setString(3, mname);
                            pstmt.setString(4, lname);
                            pstmt.setBoolean(5, true);
                            pstmt.setInt(6, sid);
                            pstmt.setString(7, "CA");
                            pstmt.setFloat(8, account_bal);

                            pstmt.executeUpdate();

                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("INSERT INTO graduate VALUES (?, ?, ?)"));

                            pstmt2.setInt(1, sid);
                            pstmt2.setString(2, "CSE");
                            pstmt2.setString(3, "PhD");

                            pstmt2.executeUpdate();

                            PreparedStatement pstmt3 = conn.prepareStatement(
                            ("INSERT INTO phd VALUES (?, ?)"));

                            pstmt3.setInt(1, sid);
                            pstmt3.setString(2, "Precandidate");

                            pstmt3.executeUpdate();


                            sid++;

                            fcount = (fcount + 1) % fn_size;
                            mcount = (mcount + 1) % mn_size;
                            lcount = (lcount + 1) % ln_size;

                        }

                        for (int i = 0; i < 2; i++) {
                            String fname = first_name[fcount];
                            String mname = m_initial[mcount];
                            String lname = last_name[lcount];

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt.setInt(1, sid);
                            pstmt.setString(2, fname);
                            pstmt.setString(3, mname);
                            pstmt.setString(4, lname);
                            pstmt.setBoolean(5, true);
                            pstmt.setInt(6, sid);
                            pstmt.setString(7, "CA");
                            pstmt.setFloat(8, account_bal);

                            pstmt.executeUpdate();

                            PreparedStatement pstmt2 = conn.prepareStatement(
                            ("INSERT INTO graduate VALUES (?, ?, ?)"));

                            pstmt2.setInt(1, sid);
                            pstmt2.setString(2, "CSE");
                            pstmt2.setString(3, "PhD");

                            pstmt2.executeUpdate();

                            PreparedStatement pstmt3 = conn.prepareStatement(
                            ("INSERT INTO phd VALUES (?, ?)"));

                            pstmt3.setInt(1, sid);
                            pstmt3.setString(2, "Candidate");

                            pstmt3.executeUpdate();

                            PreparedStatement pstmt4 = conn.prepareStatement(
                            ("INSERT INTO candidates VALUES (?)"));

                            pstmt4.setInt(1, sid);

                            pstmt4.executeUpdate();


                            sid++;

                            fcount = (fcount + 1) % fn_size;
                            mcount = (mcount + 1) % mn_size;
                            lcount = (lcount + 1) % ln_size;

                        }
                        
                        for (int i = 0; i < 5; i++) {
                            String fname = first_name[fcount];
                            String mname = m_initial[mcount];
                            String lname = last_name[lcount];

                            String faculty_name = fname + " " + mname + " " + lname;

                            faculty_names[i] = faculty_name;

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO faculty VALUES (?, ?, ?)"));

                            pstmt.setString(1, faculty_name);
                            pstmt.setString(2, "Professor");
                            pstmt.setString(3, "CSE");

                            pstmt.executeUpdate();

                            fcount = (fcount + 1) % fn_size;
                            mcount = (mcount + 1) % mn_size;
                            lcount = (lcount + 1) % ln_size;

                        }

                        for (int i = 0; i < 5; i++) {

                            String course_name = course_names[i];
                            // String quarter = quarters[i % quarters.length];
                            // int year = years[i % years.length];
                            String quarter = "Spring";
                            int year = 2018;
                            String weekday = weekdays[i % weekdays.length];

                            int cid = i + 1;

                            PreparedStatement pstmt_course = conn.prepareStatement(
                            ("INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_course.setInt(1, cid);
                            pstmt_course.setBoolean(2, true);
                            pstmt_course.setBoolean(3, true);
                            pstmt_course.setBoolean(4, true);
                            pstmt_course.setString(5, course_name);
                            pstmt_course.setInt(6, 4);
                            pstmt_course.setInt(7, 4);
                            pstmt_course.setBoolean(8, false);

                            pstmt_course.executeUpdate();

                            for (int j = 0; j < 3; j++) {

                                int curr_year = year - j;
                                int curr_sid = cid + j * 5;

                                PreparedStatement pstmt_class_curr = conn.prepareStatement(
                                    "INSERT INTO Classes (courseid, quarter, year, title) VALUES (?, ?, ?, ?)");
                                pstmt_class_curr.setInt(1, cid);
                                pstmt_class_curr.setString(2, quarter);
                                pstmt_class_curr.setInt(3, curr_year);
                                pstmt_class_curr.setString(4, course_name + " " + quarter + " " + curr_year);
                                pstmt_class_curr.executeUpdate();

                                PreparedStatement pstmt_section = conn.prepareStatement(
                                    "INSERT INTO Sections (FACULTYNAME, SECTIONID, NUMENROLLED, ENROLLLIMIT) VALUES (?, ?, ?, ?)");
                                pstmt_section.setString(1, faculty_names[i]);
                                pstmt_section.setInt(2, curr_sid);
                                pstmt_section.setInt(3, 20);
                                pstmt_section.setInt(4, 30);
                                pstmt_section.executeUpdate();        
                                
                                PreparedStatement pstmt_class_section = conn.prepareStatement(
                                ("INSERT INTO class_section VALUES (?, ?, ?, ?)"));

                                pstmt_class_section.setInt(1, curr_sid);
                                pstmt_class_section.setInt(2, cid);
                                pstmt_class_section.setString(3, quarter);
                                pstmt_class_section.setInt(4, curr_year);

                                pstmt_class_section.executeUpdate();

                            }

                            

                            PreparedStatement pstmt_regular_meetings = conn.prepareStatement(
                            ("INSERT INTO regular_meeting VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));

                            curr_hour = (curr_hour + 9) % 14;

                            pstmt_regular_meetings.setInt(1, cid);
                            pstmt_regular_meetings.setInt(2, curr_hour + hour_offset);
                            pstmt_regular_meetings.setInt(3, 0);
                            pstmt_regular_meetings.setInt(4, curr_hour + hour_offset + 1);
                            pstmt_regular_meetings.setInt(5, 20);
                            pstmt_regular_meetings.setString(6, weekday);
                            pstmt_regular_meetings.setString(7, "Lecture");
                            pstmt_regular_meetings.setBoolean(8, true);
                            pstmt_regular_meetings.setString(9, "CENTR");
                            pstmt_regular_meetings.setString(10, "115");

                            pstmt_regular_meetings.executeUpdate();

                            PreparedStatement pstmt_review_session = conn.prepareStatement(
                            ("INSERT INTO review_session_info VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt_review_session.setInt(1, cid);
                            pstmt_review_session.setInt(2, 18);
                            pstmt_review_session.setInt(3, 30);
                            pstmt_review_session.setInt(4, 19);
                            pstmt_review_session.setInt(5, 20);
                            pstmt_review_session.setInt(6, 4);
                            pstmt_review_session.setInt(7, i + 10);
                            pstmt_review_session.setString(8, "Lecture");
                            pstmt_review_session.setBoolean(9, true);
                            pstmt_review_session.setString(10, "CENTR");
                            pstmt_review_session.setString(11, "115");

                            pstmt_review_session.executeUpdate();

                            for (int j = 0; j < 8; j++) {
                                PreparedStatement pstmt_class_taking = conn.prepareStatement(
                                ("INSERT INTO course_enrollment (STUDENTID, COURSEID, SECTIONID, " + 
                                "QUARTER, YEAR, NUMUNITS, GRADINGOPTION) VALUES (?, ?, ?, ?, ?, ?, ?)"));

                                pstmt_class_taking.setInt(1, j + 1);
                                pstmt_class_taking.setInt(2, cid);
                                pstmt_class_taking.setInt(3, cid);
                                pstmt_class_taking.setString(4, quarter);
                                pstmt_class_taking.setInt(5, year);
                                pstmt_class_taking.setInt(6, 4);
                                pstmt_class_taking.setString(7, "Letter");

                                pstmt_class_taking.executeUpdate();
                                
                            }

                            for (int j = 0; j < 8; j++) {
                                PreparedStatement pstmt_class_taken = conn.prepareStatement(
                                ("INSERT INTO classes_taken VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                                grade_idx = (grade_idx + 7) % 11;

                                pstmt_class_taken.setInt(1, j + 1);
                                pstmt_class_taken.setInt(2, cid);
                                pstmt_class_taken.setInt(3, cid + 5);
                                pstmt_class_taken.setString(4, quarter);
                                pstmt_class_taken.setInt(5, year - 1);
                                pstmt_class_taken.setInt(6, 4);
                                pstmt_class_taken.setString(7, letter_grades[grade_idx]);
                                pstmt_class_taken.setString(8, "Letter");

                                pstmt_class_taken.executeUpdate();

                                PreparedStatement pstmt_class_taken2 = conn.prepareStatement(
                                ("INSERT INTO classes_taken VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                                grade_idx = (grade_idx + 7) % 11;

                                pstmt_class_taken2.setInt(1, j + 1);
                                pstmt_class_taken2.setInt(2, cid);
                                pstmt_class_taken2.setInt(3, cid + 5);
                                pstmt_class_taken2.setString(4, quarter);
                                pstmt_class_taken2.setInt(5, year - 2);
                                pstmt_class_taken2.setInt(6, 4);
                                pstmt_class_taken2.setString(7, letter_grades[grade_idx]);
                                pstmt_class_taken2.setString(8, "Letter");

                                pstmt_class_taken2.executeUpdate();
                                
                            }
                            
                        }


                        for (int i = 0; i < 2; i++) {

                            PreparedStatement pstmt_bs_deg = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt_bs_deg.setString(1, bs_deg[i]);
                            pstmt_bs_deg.setString(2, "BS");
                            pstmt_bs_deg.setInt(3, 180);

                            pstmt_bs_deg.executeUpdate();

                            for (int j = 0; j < 2; j++) {
                                PreparedStatement pstmt_bs_cat = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt_bs_cat.setString(1, bs_deg[i]);
                                pstmt_bs_cat.setString(2, categories[j]);
                                pstmt_bs_cat.setFloat(3, (float) 3.0);
                                pstmt_bs_cat.setInt(4, 30);

                                pstmt_bs_cat.executeUpdate();
                            }
                        }

                        for (int i = 0; i < 2; i++) {

                            PreparedStatement pstmt_ms_deg = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt_ms_deg.setString(1, ms_deg[i]);
                            pstmt_ms_deg.setString(2, "MS");
                            pstmt_ms_deg.setInt(3, 240);

                            pstmt_ms_deg.executeUpdate();


                            for (int j = 0; j < 2; j++) {
                                PreparedStatement pstmt_ms_cat = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt_ms_cat.setString(1, ms_deg[i]);
                                pstmt_ms_cat.setString(2, categories[j]);
                                pstmt_ms_cat.setFloat(3, (float) 3.0);
                                pstmt_ms_cat.setInt(4, 30);

                                pstmt_ms_cat.executeUpdate();
                            }

                            PreparedStatement pstmt_ms = conn.prepareStatement(
                                ("INSERT INTO masters_deg VALUES (?)"));
                            pstmt_ms.setString(1, ms_deg[i]);

                            pstmt_ms.executeUpdate();

                            for (int k = 0; k < 2; k++) {
                                PreparedStatement pstmt_ms_con = conn.prepareStatement(
                                    ("INSERT INTO concentrations VALUES (?, ?, ?, ?)"));
                                pstmt_ms_con.setString(1, ms_deg[i]);
                                pstmt_ms_con.setString(2, concentrations[k]);
                                pstmt_ms_con.setFloat(3, (float) 3.5);
                                pstmt_ms_con.setInt(4, 30);

                                pstmt_ms_con.executeUpdate();
                            }
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
                        <form action="populate_tables.jsp" method="get">
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