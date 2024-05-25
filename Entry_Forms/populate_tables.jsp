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

                        String[] weekdays = {"Monday", "Tuesday", "Wednesday"};

                        String[] bs_deg = {"MATH", "MUS"};

                        String[] ms_deg = {"CSE", "ECE"};

                        String[] categories = {"Lower", "Technical"};

                        String[] concentrations = {"Upper", "Specialty"};

                        String[] letter_grades = {"A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", 
                            "D", "IN"};
                                                
                        int grade_idx = 0;

                        int sid = 1;

                        float account_bal = (float) 40.99;

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
                            // String quarter = quarters[i % 3];
                            // int year = years[i % 3];
                            String quarter = "Spring";
                            int year = 2018;
                            String weekday = weekdays[i % 3];

                            int cid = i + 1;

                            PreparedStatement pstmt = conn.prepareStatement(
                            ("INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt.setInt(1, cid);
                            pstmt.setBoolean(2, true);
                            pstmt.setBoolean(3, true);
                            pstmt.setBoolean(4, true);
                            pstmt.setString(5, course_name);
                            pstmt.setInt(6, 4);
                            pstmt.setInt(7, 4);
                            pstmt.setBoolean(8, false);

                            pstmt.executeUpdate();

                            PreparedStatement pstmt2 = conn.prepareStatement(
                                "INSERT INTO Classes (courseid, quarter, year, title) VALUES (?, ?, ?, ?)");
                            pstmt2.setInt(1, cid);
                            pstmt2.setString(2, quarter);
                            pstmt2.setInt(3, year);
                            pstmt2.setString(4, course_name + " " + quarter + " " + year);
                            pstmt2.executeUpdate();

                            PreparedStatement pstmt3 = conn.prepareStatement(
                                "INSERT INTO Sections (FACULTYNAME, SECTIONID, NUMENROLLED, ENROLLLIMIT) VALUES (?, ?, ?, ?)");
                            pstmt3.setString(1, faculty_names[i]);
                            pstmt3.setInt(2, cid);
                            pstmt3.setInt(3, 20);
                            pstmt3.setInt(4, 30);
                            pstmt3.executeUpdate();        
                            
                            PreparedStatement pstmt4 = conn.prepareStatement(
                            ("INSERT INTO class_section VALUES (?, ?, ?, ?)"));

                            pstmt4.setInt(1, cid);
                            pstmt4.setInt(2, cid);
                            pstmt4.setString(3, quarter);
                            pstmt4.setInt(4, year);

                            pstmt4.executeUpdate();

                            PreparedStatement pstmt5 = conn.prepareStatement(
                            ("INSERT INTO regular_meeting VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));

                            pstmt5.setInt(1, cid);
                            pstmt5.setInt(2, 15);
                            pstmt5.setInt(3, 0);
                            pstmt5.setInt(4, 16);
                            pstmt5.setInt(5, 20);
                            pstmt5.setString(6, weekday);
                            pstmt5.setString(7, "Lecture");
                            pstmt5.setBoolean(8, true);
                            pstmt5.setString(9, "CENTR");
                            pstmt5.setString(10, "115");

                            pstmt5.executeUpdate();

                            for (int j = 0; j < 8; j++) {
                                PreparedStatement pstmt6 = conn.prepareStatement(
                                ("INSERT INTO classes_taken VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));

                                grade_idx = (grade_idx + 7) % 11;

                                pstmt6.setInt(1, j + 1);
                                pstmt6.setInt(2, cid);
                                pstmt6.setInt(3, cid);
                                pstmt6.setString(4, quarter);
                                pstmt6.setInt(5, year);
                                pstmt6.setInt(6, 4);
                                pstmt6.setString(7, letter_grades[grade_idx]);
                                pstmt6.setString(8, "Letter");

                                pstmt6.executeUpdate();
                                
                            }
                            
                        }


                        for (int i = 0; i < 2; i++) {

                            PreparedStatement pstmt1 = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt1.setString(1, bs_deg[i]);
                            pstmt1.setString(2, "BS");
                            pstmt1.setInt(3, 180);

                            pstmt1.executeUpdate();

                            for (int j = 0; j < 2; j++) {
                                PreparedStatement pstmt2 = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt2.setString(1, bs_deg[i]);
                                pstmt2.setString(2, categories[j]);
                                pstmt2.setFloat(3, (float) 3.0);
                                pstmt2.setInt(4, 30);

                                pstmt2.executeUpdate();
                            }
                        }

                        for (int i = 0; i < 2; i++) {

                            PreparedStatement pstmt1 = conn.prepareStatement(
                                ("INSERT INTO degree VALUES (?, ?, ?)"));
                            pstmt1.setString(1, ms_deg[i]);
                            pstmt1.setString(2, "MS");
                            pstmt1.setInt(3, 240);

                            pstmt1.executeUpdate();


                            for (int j = 0; j < 2; j++) {
                                PreparedStatement pstmt2 = conn.prepareStatement(
                                    ("INSERT INTO categories VALUES (?, ?, ?, ?)"));
                                pstmt2.setString(1, ms_deg[i]);
                                pstmt2.setString(2, categories[j]);
                                pstmt2.setFloat(3, (float) 3.0);
                                pstmt2.setInt(4, 30);

                                pstmt2.executeUpdate();
                            }

                            PreparedStatement pstmt3 = conn.prepareStatement(
                                ("INSERT INTO masters_deg VALUES (?)"));
                            pstmt3.setString(1, ms_deg[i]);

                            pstmt3.executeUpdate();

                            for (int k = 0; k < 2; k++) {
                                PreparedStatement pstmt4 = conn.prepareStatement(
                                    ("INSERT INTO concentrations VALUES (?, ?, ?, ?)"));
                                pstmt4.setString(1, ms_deg[i]);
                                pstmt4.setString(2, concentrations[k]);
                                pstmt4.setFloat(3, (float) 3.5);
                                pstmt4.setInt(4, 30);

                                pstmt4.executeUpdate();
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