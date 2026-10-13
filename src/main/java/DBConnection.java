import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Central JDBC connection utility.
 * Reads DB config from environment variables (for deployment),
 * falls back to localhost defaults (for local development).
 * Used by every Servlet — no duplicate connection logic anywhere else.
 */
public class DBConnection {

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.trim().isEmpty()) ? defaultValue : value;
    }

    public static Connection getConnection() throws SQLException {

        String host = getEnvOrDefault("DB_HOST", "bjlmnr3o8djbssgsdlgy-mysql.services.clever-cloud.com");
        String port = getEnvOrDefault("DB_PORT", "3306");
        String dbName = getEnvOrDefault("DB_NAME", "bjlmnr3o8djbssgsdlgy");
        String username = getEnvOrDefault("DB_USERNAME", "ullz34v9b6p0kclv");
        String password = getEnvOrDefault("DB_PASSWORD", "whIkZolJBoNr33DHZyDD");

        String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }

        return DriverManager.getConnection(url, username, password);
    }
}