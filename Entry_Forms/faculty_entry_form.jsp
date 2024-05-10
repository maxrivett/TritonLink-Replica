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

                        if ("update".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "UPDATE Faculty SET title = ?, department = ? WHERE facultyname = ?");
                            pstmt.setString(1, request.getParameter("title"));
                            pstmt.setString(2, request.getParameter("department"));
                            pstmt.setString(3, request.getParameter("facultyname"));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("delete".equals(action)) {

                            PreparedStatement selectTCPstmt = conn.prepareStatement(
                                "SELECT STUDENTID FROM thesis_committee WHERE facultyname = ?");
                            selectTCPstmt.setString(1, request.getParameter("facultyname"));
                            ResultSet studentsSet = selectTCPstmt.executeQuery();

                            while (rs.next()) {
                                int student_ID = rs.getInt("STUDENTID");

                                PreparedStatement numProfsStatement = conn.prepareStatement(
                                    "SELECT COUNT(*) as NUMPROFS FROM thesis_committee WHERE STUDENTID = ?");

                                numProfsStatement.setInt(1, student_ID);

                                ResultSet numProfsSet = numProfsStatement.executeQuery();

                                numProfsSet.next();

                                int numProfs = numProfsSet.getInt("NUMPROFS");

                                int rowCount = 0;

                                if (numProfs > 4) {
                                    PreparedStatement pstmt = conn.prepareStatement(
                                    "DELETE FROM thesis_committee WHERE STUDENTID = ? AND FACULTYNAME = ?");

                                    pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                                    pstmt.setString(2, request.getParameter("FACULTYNAME"));

                                    rowCount = pstmt.executeUpdate();
                                }
                                else {
                                    PreparedStatement pstmt = conn.prepareStatement(
                                    "DELETE FROM thesis_committee WHERE STUDENTID = ?");

                                    pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));

                                    rowCount = pstmt.executeUpdate();
                                }

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            PreparedStatement selectPstmt = conn.prepareStatement(
                                "SELECT SECTIONID FROM sections WHERE facultyname = ?");
                            selectPstmt.setString(1, request.getParameter("facultyname"));
                            ResultSet rs = selectPstmt.executeQuery();

                            PreparedStatement deletePstmt1 = conn.prepareStatement(
                                "DELETE FROM course_enrollment WHERE SECTIONID = ?");
                            PreparedStatement deletePstmt2 = conn.prepareStatement(
                                "DELETE FROM review_session_info WHERE SECTIONID = ?");
                            while (rs.next()) {
                                int sectionId = rs.getInt("SECTIONID");
                                deletePstmt1.setInt(1, sectionId);
                                deletePstmt1.executeUpdate();
                                deletePstmt2.setInt(1, sectionId);
                                deletePstmt2.executeUpdate();
                            }

                            PreparedStatement pstmt2 = conn.prepareStatement(
                                "DELETE FROM sections WHERE facultyname = ?");
                            pstmt2.setString(1, request.getParameter("facultyname"));
                            pstmt2.executeUpdate();
                            conn.commit();
                            PreparedStatement pstmt1 = conn.prepareStatement(
                                "DELETE FROM advisors WHERE facultyname = ?");
                            pstmt1.setString(1, request.getParameter("facultyname"));
                            pstmt1.executeUpdate();
                            conn.commit();
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM Faculty WHERE facultyname = ?");
                            pstmt.setString(1, request.getParameter("facultyname"));
                            pstmt.executeUpdate();
                            conn.commit();
                        } else if ("insert".equals(action)) {
                            PreparedStatement pstmt = conn.prepareStatement(
                                "INSERT INTO Faculty (facultyname, title, department) VALUES (?, ?, ?)");
                            pstmt.setString(1, request.getParameter("facultyname"));
                            pstmt.setString(2, request.getParameter("title"));
                            pstmt.setString(3, request.getParameter("department"));
                            pstmt.executeUpdate();
                            conn.commit();
                        }

                        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM Faculty");
                %>
                <table>
                    <tr>
                        <th>Faculty Name</th>
                        <th>Title</th>
                        <th>Department</th>
                    </tr>
                    <tr>
                        <form action="faculty_entry_form.jsp" method="post">
                            <td><input type="text" name="facultyname" /></td>
                            <td><input type="text" name="title" /></td>
                            <td><input type="text" name="department" /></td>
                            <td><input type="submit" name="action" value="insert" /></td>
                        </form>
                    </tr>
                    <%
                        while (rs.next()) {
                    %>
                    <tr>
                        <form action="faculty_entry_form.jsp" method="post">
                            <td><input type="hidden" name="facultyname" value="<%= rs.getString("facultyname") %>" /><%= rs.getString("facultyname") %></td>
                            <td><input type="text" name="title" value="<%= rs.getString("title") %>" /></td>
                            <td><input type="text" name="department" value="<%= rs.getString("department") %>" /></td>
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
                        out.println("SQL Error: " + sqle.getMessage());
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
