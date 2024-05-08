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
                        del_strings.add("DROP TABLE IF EXISTS class_courses");
                        del_strings.add("DROP TABLE IF EXISTS classes CASCADE");
                        del_strings.add("DROP TABLE IF EXISTS course_enrollment");
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
                        

                        
                        create_strings.add("CREATE TABLE student (STUDENTID integer, FIRSTNAME varchar(255), " +
                            "MIDDLENAME varchar(255), LASTNAME varchar(255), ENROLLED boolean, " + 
                            "SSN integer, RESIDENCY varchar(255), ACCOUNTBALANCE numeric(10,2), " + 
                            "PRIMARY KEY (STUDENTID))");
                        create_strings.add("CREATE TABLE probation_info (STUDENTID integer, STARTQTR varchar(255), " +
                            "STARTYEAR integer, ENDQTR varchar(255), ENDYEAR integer, " + 
                            "REASON varchar(255), PRIMARY KEY (STUDENTID, STARTQTR, STARTYEAR, ENDQTR, ENDYEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID))");
                        create_strings.add("CREATE TABLE previous_degrees (STUDENTID integer, PREVUNI varchar(255), " +
                            "PREVDEG varchar(255), PRIMARY KEY (STUDENTID, PREVUNI, PREVDEG), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID))");
                        create_strings.add("CREATE TABLE periods_of_attendance (STUDENTID integer, STARTQTR varchar(255), " +
                            "STARTYEAR integer, ENDQTR varchar(255), ENDYEAR integer, " + 
                            "PRIMARY KEY (STUDENTID, STARTQTR, STARTYEAR, ENDQTR, ENDYEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID))");
                        create_strings.add("CREATE TABLE undergrad (STUDENTID integer, MAJOR varchar(255), " +
                            "MINOR varchar(255), COLLEGE varchar(255), BSMS boolean, " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID))");
                        create_strings.add("CREATE TABLE graduate (STUDENTID integer, " +
                            "DEPARTMENT varchar(255), GRADTYPE varchar(255), " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES student (STUDENTID))");
                        create_strings.add("CREATE TABLE phd (STUDENTID integer, " +
                            "PHDTYPE varchar(255), " + 
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES graduate (STUDENTID))");
                        create_strings.add("CREATE TABLE candidates (STUDENTID integer, " +
                            "PRIMARY KEY (STUDENTID), FOREIGN KEY (STUDENTID) REFERENCES phd (STUDENTID))");
                        create_strings.add("CREATE TABLE Faculty (FACULTYNAME varchar(255), TITLE varchar(255), " +
                            "DEPARTMENT varchar(255), PRIMARY KEY (FACULTYNAME))");
                        create_strings.add("CREATE TABLE course (COURSEID integer, LABREQ boolean, " +
                            "SUALLOW boolean, LETTERGRADE boolean, COURSENUM varchar(255), " + 
                            "UNITMIN integer, UNITMAX integer, INSTPERM boolean, " + 
                            "PRIMARY KEY (COURSEID))");
                        create_strings.add("CREATE TABLE Prerequisites (BASECOURSE integer, " +
                            "PREREQUISITE integer, PRIMARY KEY (BASECOURSE, PREREQUISITE), " +
                            "FOREIGN KEY (BASECOURSE) REFERENCES course(COURSEID), " +
                            "FOREIGN KEY (PREREQUISITE) REFERENCES course(COURSEID))");
                        create_strings.add("CREATE TABLE Corequisites (BASECOURSE integer, " +
                            "COREQUISITE integer, PRIMARY KEY (BASECOURSE, COREQUISITE), " +
                            "FOREIGN KEY (BASECOURSE) REFERENCES course(COURSEID), " +
                            "FOREIGN KEY (COREQUISITE) REFERENCES course(COURSEID))");
                        
                        create_strings.add("CREATE TABLE classes (COURSEID integer, " +
                            "QUARTER varchar(255), YEAR integer, TITLE varchar(255), " + 
                            "PRIMARY KEY (COURSEID, QUARTER, YEAR), " +
                            "FOREIGN KEY (COURSEID) REFERENCES course(COURSEID))");
                        
                        create_strings.add("CREATE TABLE sections (SECTIONID integer, " + 
                            "FACULTYNAME varchar(255), ENROLLLIMIT integer, NUMENROLLED integer, " + 
                            "PRIMARY KEY (SECTIONID), FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME))");
                        create_strings.add("CREATE TABLE course_enrollment (STUDENTID integer, " +
                            "COURSEID integer, QUARTER varchar(255), YEAR integer, " +
                            "SECTIONID integer, GRADE varchar(2), " +
                            "PRIMARY KEY (STUDENTID, SECTIONID), " +
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID), " +
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID))");
                        
                        
                        create_strings.add("CREATE TABLE regular_meeting (SECTIONID integer, " + 
                            "STARTHOUR integer, STARTMINUTE integer, ENDHOUR integer, ENDMINUTE integer, " + 
                            "WEEKDAY varchar(255), TYPE varchar(255), MANDATORY boolean, " + 
                            "BUILDING varchar(255), ROOM varchar(255), " + 
                            "PRIMARY KEY (SECTIONID, STARTHOUR, STARTMINUTE, ENDHOUR, ENDMINUTE, WEEKDAY), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID))");
                        create_strings.add("CREATE TABLE review_session_info (SECTIONID integer, " + 
                            "STARTHOUR integer, STARTMINUTE integer, ENDHOUR integer, ENDMINUTE integer, " + 
                            "MONTH integer, DAY integer, TYPE varchar(255), MANDATORY boolean, " + 
                            "BUILDING varchar(255), ROOM varchar(255), " + 
                            "PRIMARY KEY (SECTIONID, STARTHOUR, STARTMINUTE, ENDHOUR, ENDMINUTE, MONTH, DAY), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID))");
                        create_strings.add("CREATE TABLE degree (DEPARTMENT varchar(255), DEGTYPE varchar(255), " +
                            "TOTALUNITS integer, PRIMARY KEY (DEPARTMENT))");
                        create_strings.add("CREATE TABLE masters_deg (DEPARTMENT varchar(255), " +
                            "PRIMARY KEY (DEPARTMENT), FOREIGN KEY (DEPARTMENT) REFERENCES degree(DEPARTMENT))");
                        create_strings.add("CREATE TABLE categories (DEPARTMENT varchar(255), CATNAME varchar(255), " +
                            "CATGPA numeric(3,2), CATUNITS integer, PRIMARY KEY (DEPARTMENT, CATNAME), " +
                            "FOREIGN KEY (DEPARTMENT) REFERENCES degree(DEPARTMENT))");
                        create_strings.add("CREATE TABLE concentrations (DEPARTMENT varchar(255), CONNAME varchar(255), " +
                            "CONGPA numeric(3,2), CONUNITS integer, PRIMARY KEY (DEPARTMENT, CONNAME), " +
                            "FOREIGN KEY (DEPARTMENT) REFERENCES masters_deg(DEPARTMENT))");
                        create_strings.add("CREATE TABLE finaid (AIDNAME varchar(255), YEAR integer, " +
                            "TYPE varchar(255), REQUIREMENTS varchar(255), AMOUNT numeric(10,2), " + 
                            "PRIMARY KEY (AIDNAME, YEAR))");
                        create_strings.add("CREATE TABLE payment (STUDENTID integer, PAYNUM integer, " +
                            "AMOUNT numeric(10,2), PRIMARY KEY (STUDENTID, PAYNUM), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID))");
                        create_strings.add("CREATE TABLE aid_awarded (STUDENTID integer, AIDNAME varchar(255), " + 
                            "YEAR integer, PRIMARY KEY(STUDENTID, AIDNAME, YEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID), " +
                            "FOREIGN KEY (AIDNAME, YEAR) REFERENCES finaid(AIDNAME, YEAR))");
                        create_strings.add("CREATE TABLE classes_taken (STUDENTID integer, COURSEID integer, " + 
                            "QUARTER varchar(255), YEAR integer, GRADE varchar(2), " + 
                            "PRIMARY KEY(STUDENTID, COURSEID, QUARTER, YEAR), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID), " +
                            "FOREIGN KEY (COURSEID, QUARTER, YEAR) REFERENCES classes(COURSEID, QUARTER, YEAR))");
                        create_strings.add("CREATE TABLE advisors (STUDENTID integer, FACULTYNAME varchar(255), " + 
                            "PRIMARY KEY(STUDENTID, FACULTYNAME), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID), " +
                            "FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME))");
                        create_strings.add("CREATE TABLE thesis_committee (STUDENTID integer, FACULTYNAME varchar(255), " + 
                            "PRIMARY KEY(STUDENTID, FACULTYNAME), " + 
                            "FOREIGN KEY (STUDENTID) REFERENCES student(STUDENTID), " +
                            "FOREIGN KEY (FACULTYNAME) REFERENCES Faculty(FACULTYNAME))");
                        create_strings.add("CREATE TABLE class_section (SECTIONID integer, COURSEID integer, " + 
                            "QUARTER varchar(255), YEAR integer, " + 
                            "PRIMARY KEY(SECTIONID, COURSEID, QUARTER, YEAR), " + 
                            "FOREIGN KEY (SECTIONID) REFERENCES sections(SECTIONID), " +
                            "FOREIGN KEY (COURSEID, QUARTER, YEAR) REFERENCES classes(COURSEID, QUARTER, YEAR))");
                        create_strings.add("CREATE TABLE category_courses (DEPARTMENT varchar(255), " +
                            "CATNAME varchar(255), COURSEID integer, " + 
                            "PRIMARY KEY (DEPARTMENT, CATNAME, COURSEID), " +
                            "FOREIGN KEY (DEPARTMENT, CATNAME) references categories(DEPARTMENT, CATNAME), " + 
                            "FOREIGN KEY (COURSEID) references course(COURSEID))");
                        create_strings.add("CREATE TABLE concentration_courses (DEPARTMENT varchar(255), " +
                            "CONNAME varchar(255), COURSEID integer, " + 
                            "PRIMARY KEY (DEPARTMENT, CONNAME, COURSEID), " +
                            "FOREIGN KEY (DEPARTMENT, CONNAME) references concentrations(DEPARTMENT, CONNAME), " + 
                            "FOREIGN KEY (COURSEID) references course(COURSEID))");
                        
                        
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