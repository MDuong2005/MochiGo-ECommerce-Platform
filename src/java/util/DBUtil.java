package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {

    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=MochiGoDB;encrypt=false";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    public static Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}