import ballerinax/java.jdbc;
import ballerinax/mysql.driver as _;

final jdbc:Client dbClient = check new ("jdbc:mysql://localhost:3306/mydatabase", "root", "password");
