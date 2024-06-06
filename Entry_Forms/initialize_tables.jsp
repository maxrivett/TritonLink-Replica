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
                    if (action != null && action.equals("initialize")) {
                        conn.setAutoCommit(false);

                        ArrayList<String> del_strings = new ArrayList<String>();

                        ArrayList<String> create_strings = new ArrayList<String>();

                        del_strings.add("DROP TABLE IF EXISTS student CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS probation_info");
                        del_strings.add("DROP TABLE IF EXISTS previous_degrees");
                        del_strings.add("DROP TABLE IF EXISTS periods_of_attendance ");
                        del_strings.add("DROP TABLE IF EXISTS undergrad");
                        del_strings.add("DROP TABLE IF EXISTS graduate CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS phd CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS candidates CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS Faculty CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS Course CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS Prerequisites");
                        del_strings.add("DROP TABLE IF EXISTS Corequisites");
                        del_strings.add("DROP TABLE IF EXISTS classes CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS course_enrollment");
                        del_strings.add("DROP TABLE IF EXISTS course_waitlist");
                        del_strings.add("DROP TABLE IF EXISTS sections CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS regular_meeting");
                        del_strings.add("DROP TABLE IF EXISTS review_session_info");
                        del_strings.add("DROP TABLE IF EXISTS degree CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS masters_deg CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS categories CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS concentrations CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS finaid CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS payment");
                        del_strings.add("DROP TABLE IF EXISTS aid_awarded");
                        del_strings.add("DROP TABLE IF EXISTS classes_taken");
                        del_strings.add("DROP TABLE IF EXISTS advisors");
                        del_strings.add("DROP TABLE IF EXISTS thesis_committee");
                        del_strings.add("DROP TABLE IF EXISTS class_section");
                        del_strings.add("DROP TABLE IF EXISTS category_courses");
                        del_strings.add("DROP TABLE IF EXISTS concentration_courses");
                        del_strings.add("DROP TABLE IF EXISTS review_slots");
                        del_strings.add("DROP TABLE IF EXISTS grade_conversion");
                        del_strings.add("DROP TABLE IF EXISTS day_conversion");
                        

                        
                        create_strings.add("CREATE TABLE student (STUDENTID integer, FIRSTNAME varchar(255), " +
                            "MIDDLENAME varchar(255), LASTNAME varchar(255), ENROLLED boolean, " + 
                            "SSN integer, RESIDENCY varchar(255), ACCOUNTBALANCE numeric(10,2), " + 
                            "PRIMARY KEY (STUDENTID))");
                        create_strings.add("CREATE TABLE probation_info (STUDENTID integer, STARTQTR varchar(255), " +
                            "STARTYEAR integer, ENDQTR varchar(255), ENDYEAR integer, " + 
                            "REASON varchar(255), PRIMARY KEY (STUDENTID, STARTQTR, STARTYEAR, ENDQTR, ENDYEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE previous_degrees (STUDENTID integer, PREVUNI varchar(255), " +
                            "PREVDEG varchar(255), PRIMARY KEY (STUDENTID, PREVUNI, PREVDEG), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE periods_of_attendance (STUDENTID integer, STARTQTR varchar(255), " +
                            "STARTYEAR integer, ENDQTR varchar(255), ENDYEAR integer, " + 
                            "PRIMARY KEY (STUDENTID, STARTQTR, STARTYEAR, ENDQTR, ENDYEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE undergrad (STUDENTID integer, MAJOR varchar(255), " +
                            "MINOR varchar(255), COLLEGE varchar(255), BSMS boolean, " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE graduate (STUDENTID integer, " +
                            "DEPARTMENT varchar(255), GRADTYPE varchar(255), " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE phd (STUDENTID integer, " +
                            "PHDTYPE varchar(255), " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES graduate (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE candidates (STUDENTID integer, " +
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES phd (STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE Faculty (FACULTYNAME varchar(255), TITLE varchar(255), " +
                            "DEPARTMENT varchar(255), PRIMARY KEY (FACULTYNAME))");
                        create_strings.add("CREATE TABLE course (COURSEID integer, LABREQ boolean, " +
                            "SUALLOW boolean, LETTERGRADE boolean, COURSENUM varchar(255), " + 
                            "UNITMIN integer, UNITMAX integer, INSTPERM boolean, " + 
                            "PRIMARY KEY (COURSEID))");
                        create_strings.add("CREATE TABLE Prerequisites (BASECOURSE integer, " +
                            "PREREQUISITE integer, PRIMARY KEY (BASECOURSE, PREREQUISITE), " +
                            "FOREIGN KEY (BASECOURSE) REFERENCES course(COURSEID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (PREREQUISITE) REFERENCES course(COURSEID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE Corequisites (BASECOURSE integer, " +
                            "COREQUISITE integer, PRIMARY KEY (BASECOURSE, COREQUISITE), " +
                            "FOREIGN KEY (BASECOURSE) REFERENCES course(COURSEID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (COREQUISITE) REFERENCES course(COURSEID) ON DELETE CASCADE)");
                        
                        create_strings.add("CREATE TABLE classes (COURSEID integer, " +
                            "QUARTER varchar(255), YEAR integer, TITLE varchar(255), " + 
                            "PRIMARY KEY (COURSEID, QUARTER, YEAR), " +
                            "FOREIGN KEY (COURSEID) REFERENCES course(COURSEID) ON DELETE CASCADE)");
                        
                        create_strings.add("CREATE TABLE sections (SECTIONID integer, " + 
                            "FACULTYNAME varchar(255), ENROLLLIMIT integer, NUMENROLLED integer, " + 
                            "PRIMARY KEY (SECTIONID), FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE course_enrollment (STUDENTID integer, " +
                            "COURSEID integer, QUARTER varchar(255), YEAR integer, " +
                            "SECTIONID integer, NUMUNITS integer, GRADINGOPTION varchar(255), " +
                            "PRIMARY KEY (STUDENTID, SECTIONID), " +
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE course_waitlist (STUDENTID integer, " +
                            "COURSEID integer, QUARTER varchar(255), YEAR integer, " +
                            "SECTIONID integer, NUMUNITS integer, POSITION integer, " +
                            "PRIMARY KEY (STUDENTID, SECTIONID), " +
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID) ON DELETE CASCADE)");
                        
                        
                        create_strings.add("CREATE TABLE regular_meeting (SECTIONID integer, " + 
                            "STARTHOUR integer, STARTMINUTE integer, ENDHOUR integer, ENDMINUTE integer, " + 
                            "WEEKDAY varchar(255), TYPE varchar(255), MANDATORY boolean, " + 
                            "BUILDING varchar(255), ROOM varchar(255), " + 
                            "PRIMARY KEY (SECTIONID, STARTHOUR, STARTMINUTE, ENDHOUR, ENDMINUTE, WEEKDAY), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE review_session_info (SECTIONID integer, " + 
                            "STARTHOUR integer, STARTMINUTE integer, ENDHOUR integer, ENDMINUTE integer, " + 
                            "MONTH integer, DAY integer, TYPE varchar(255), MANDATORY boolean, " + 
                            "BUILDING varchar(255), ROOM varchar(255), WEEKDAY varchar(255), " + 
                            "PRIMARY KEY (SECTIONID, STARTHOUR, STARTMINUTE, ENDHOUR, ENDMINUTE, MONTH, DAY), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE degree (DEPARTMENT varchar(255), DEGTYPE varchar(255), " +
                            "TOTALUNITS integer, PRIMARY KEY (DEPARTMENT))");
                        create_strings.add("CREATE TABLE masters_deg (DEPARTMENT varchar(255), " +
                            "PRIMARY KEY (DEPARTMENT), FOREIGN KEY (DEPARTMENT) REFERENCES degree(DEPARTMENT) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE categories (DEPARTMENT varchar(255), CATNAME varchar(255), " +
                            "CATGPA numeric(3,2), CATUNITS integer, PRIMARY KEY (DEPARTMENT, CATNAME), " +
                            "FOREIGN KEY (DEPARTMENT) REFERENCES degree(DEPARTMENT) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE concentrations (DEPARTMENT varchar(255), CONNAME varchar(255), " +
                            "CONGPA numeric(3,2), CONUNITS integer, PRIMARY KEY (DEPARTMENT, CONNAME), " +
                            "FOREIGN KEY (DEPARTMENT) REFERENCES masters_deg(DEPARTMENT) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE finaid (AIDNAME varchar(255), YEAR integer, " +
                            "TYPE varchar(255), REQUIREMENTS varchar(255), AMOUNT numeric(10,2), " + 
                            "PRIMARY KEY (AIDNAME, YEAR))");
                        create_strings.add("CREATE TABLE payment (STUDENTID integer, PAYNUM integer, " +
                            "AMOUNT numeric(10,2), PRIMARY KEY (STUDENTID, PAYNUM), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE aid_awarded (STUDENTID integer, AIDNAME varchar(255), " + 
                            "YEAR integer, PRIMARY KEY(STUDENTID, AIDNAME, YEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (AIDNAME, YEAR) REFERENCES finaid(AIDNAME, YEAR) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE classes_taken (STUDENTID integer, COURSEID integer, " + 
                            "SECTIONID integer, QUARTER varchar(255), YEAR integer, NUMUNITS integer, GRADE char(2), " +
                            "GRADINGOPTION varchar(255), " + 
                            "PRIMARY KEY(STUDENTID, COURSEID, SECTIONID, QUARTER, YEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (COURSEID, QUARTER, YEAR) REFERENCES classes(COURSEID, QUARTER, YEAR) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE advisors (STUDENTID integer, FACULTYNAME varchar(255), " + 
                            "PRIMARY KEY(STUDENTID), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES candidates(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE thesis_committee (STUDENTID integer, FACULTYNAME varchar(255), " + 
                            "PRIMARY KEY(STUDENTID, FACULTYNAME), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES candidates(STUDENTID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME))");
                        create_strings.add("CREATE TABLE class_section (SECTIONID integer, COURSEID integer, " + 
                            "QUARTER varchar(255), YEAR integer, " + 
                            "PRIMARY KEY(SECTIONID, COURSEID, QUARTER, YEAR), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID) ON DELETE CASCADE, " +
                            "FOREIGN KEY (COURSEID, QUARTER, YEAR) REFERENCES classes(COURSEID, QUARTER, YEAR) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE category_courses (DEPARTMENT varchar(255), " +
                            "CATNAME varchar(255), COURSEID integer, " + 
                            "PRIMARY KEY (DEPARTMENT, CATNAME, COURSEID), " +
                            "FOREIGN KEY (DEPARTMENT, CATNAME) references categories(DEPARTMENT, CATNAME) ON DELETE CASCADE, " + 
                            "FOREIGN KEY (COURSEID) references course(COURSEID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE concentration_courses (DEPARTMENT varchar(255), " +
                            "CONNAME varchar(255), COURSEID integer, " + 
                            "PRIMARY KEY (DEPARTMENT, CONNAME, COURSEID), " +
                            "FOREIGN KEY (DEPARTMENT, CONNAME) references concentrations(DEPARTMENT, CONNAME) ON DELETE CASCADE, " + 
                            "FOREIGN KEY (COURSEID) references course(COURSEID) ON DELETE CASCADE)");
                        create_strings.add("CREATE TABLE review_slots (MONTH integer, DAY integer, WEEKDAY varchar(255), " + 
                            "STARTHOUR integer, ENDHOUR integer, MONSTR varchar(255), " + 
                            "PRIMARY KEY (MONTH, DAY, STARTHOUR, ENDHOUR))");
                        create_strings.add("CREATE TABLE grade_conversion (GRADE char(2), " + 
                            "GPA numeric(2,1), GPACOUNT integer, GRADECLASS varchar(10))");
                        create_strings.add("CREATE TABLE day_conversion (DAYCODE varchar(255), DAY varchar(255))");
                        
                        
                        // Create the prepared statement and use it to 
                        // delete any existing tables

                        for (String del_stmt : del_strings) {
                            PreparedStatement dstmt = conn.prepareStatement(del_stmt);
                            dstmt.executeUpdate();
                        }

                        for (String create_stmt : create_strings) {
                            PreparedStatement cstmt = conn.prepareStatement(create_stmt);
                            cstmt.executeUpdate();
                        }

                        int[] month_days = {31, 28, 21, 30, 31, 30, 31, 31, 30, 31, 30, 31};
                        String[] month_names = {"January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"};
                        String[] weekdays = {"M", "Tu", "W", "Th", "F", 
                            "Sa", "Su"};
                        
                        int weekday_idx = 0;
                        int min_start_hour = 8;
                        int max_end_hour = 20;

                        for (int i = 0; i < month_days.length; i++) {
                            for (int j = 0; j < month_days[i]; j++) {
                                for (int k = min_start_hour; k < max_end_hour; k++) {
                                    PreparedStatement pstmt_slot = conn.prepareStatement(
                                        ("INSERT INTO review_slots VALUES (?, ?, ?, ?, ?, ?)"));
                                    pstmt_slot.setInt(1, i + 1);
                                    pstmt_slot.setInt(2, j + 1);
                                    pstmt_slot.setString(3, weekdays[weekday_idx]);
                                    pstmt_slot.setInt(4, k);
                                    pstmt_slot.setInt(5, k + 1);
                                    pstmt_slot.setString(6, month_names[i]);

                                    pstmt_slot.executeUpdate();
                                }
                                weekday_idx = (weekday_idx + 1) % weekdays.length;
                            }
                        }

                        String[] letter_grades = {"A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", 
                            "D", "SU", "U", "IN"};

                        String[] grade_classes = {"A", "B", "C", "D", "Other", "Incomplete"};
                        
                        double[] grade_points = {4.3, 4, 3.7, 3.4, 3.1, 2.8, 2.5, 2.2, 1.9, 1.6, 
                            0, 0, 0};

                        for (int i = 0; i < letter_grades.length; i++) {
                            PreparedStatement pstmt_grade = conn.prepareStatement(
                                ("INSERT INTO grade_conversion VALUES (?, ?, ?, ?)"));
                            
                                int gpa_count = 0;
                                if (grade_points[i] > 0) {
                                    gpa_count = 1;
                                }

                                String curr_class = "Other";

                                if (i < 9) {
                                    curr_class = grade_classes[i / 3];
                                }
                                else if (i == 9) {
                                    curr_class = grade_classes[3];
                                }
                                else if (i == 12) {
                                    curr_class = grade_classes[5];
                                }


                                pstmt_grade.setString(1, letter_grades[i]);
                                pstmt_grade.setFloat(2, (float) grade_points[i]);
                                pstmt_grade.setInt(3, gpa_count);
                                pstmt_grade.setString(4, curr_class);

                                pstmt_grade.executeUpdate();
                        }

                        String[] codes = {"M", "Tu", "W", "Th", "F", "Sa", "Su", "MW", "MWF", "TuTh"};

                        String[][] code_days = {{"M"}, {"Tu"}, {"W"}, {"Th"}, {"F"}, {"Sa"}, {"Su"},
                            {"M", "W"}, {"M", "W", "F"}, {"Tu", "Th"}};


                        for (int i = 0; i < codes.length; i++) {
                            String curr_code = codes[i];
                            String[] curr_code_days = code_days[i];

                            for (int j = 0; j < curr_code_days.length; j++) {
                                String curr_day = curr_code_days[j];
                                PreparedStatement pstmt_weekday = conn.prepareStatement(
                                    ("INSERT INTO day_conversion VALUES (?, ?)"));
                                pstmt_weekday.setString(1, curr_code);
                                pstmt_weekday.setString(2, curr_day);

                                pstmt_weekday.executeUpdate();
                            }
                        }

                        /*

                        PreparedStatement pstmt_enroll_fnc = conn.prepareStatement(
                        ("CREATE OR REPLACE FUNCTION check_enroll() RETURNS trigger AS $check_enroll$ " + 
                        "BEGIN IF (NEW.SECTIONID IN (SELECT SECTIONID FROM Sections WHERE " + 
                        "NUMENROLLED = ENROLLLIMIT)) THEN RAISE EXCEPTION 'Section is full'; END IF; " + 
                        "RETURN NEW; END; $check_enroll$ LANGUAGE 'plpgsql';"));

                        pstmt_enroll_fnc.executeUpdate();

                        

                        PreparedStatement pstmt_enroll_trigger = conn.prepareStatement(
                        ("CREATE OR REPLACE TRIGGER check_enroll BEFORE INSERT ON course_enrollment " + 
                        "FOR EACH ROW EXECUTE PROCEDURE check_enroll()"));

                        pstmt_enroll_trigger.executeUpdate();

                        */

                        

                        conn.commit();
                        conn.setAutoCommit(true);
                    }
                %>

                <table>
                    <tr>
                        <form action="initialize_tables.jsp" method="get">
                            <input type="hidden" value="initialize" name="action">
                            <th><input type="submit" value="Initialize"></th>
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