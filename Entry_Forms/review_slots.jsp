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

                    // Use the statement to SELECT the aid_awarded attributes
                    // FROM the aid_awarded table
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM review_slots");
                %>
                <table>
                    <tr>
                        <th>Month</th>
                        <th>Day</th>
                        <th>Weekday</th>
                        <th>Start Hour</th>
                        <th>End Hour</th>
                    </tr>
                <%
                    // Iterate over the ResultSet
                    int count = 0;
                    while ( rs.next() && count < 50) {
                %>
                <tr>
                    <form action="review_slots.jsp" method="get">
                        <input type="hidden" value="view" name="action">
                        <td><input value="<%= rs.getInt("MONTH") %>"
                            name="MONTH"></td>
                        <td><input value="<%= rs.getInt("DAY") %>"
                            name="DAY"></td>
                        <td><input value="<%= rs.getString("WEEKDAY") %>"
                            name="WEEKDAY"></td>
                        <td><input value="<%= rs.getInt("STARTHOUR") %>"
                            name="STARTHOUR"></td>
                        <td><input value="<%= rs.getInt("ENDHOUR") %>"
                            name="ENDHOUR"></td>
                        <td><input type="submit" value="View"></td>
                    </form>
                </tr>
                <%
                        count++;
                    }
                %>
                </table>

                <%
                    // Close the ResultSet
                    rs.close();

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