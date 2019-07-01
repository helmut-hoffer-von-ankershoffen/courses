CREATE USER 'root'@'%' IDENTIFIED BY 'secret';
CREATE USER 'root'@'localhost' IDENTIFIED BY 'secret';
CREATE DATABASE IF NOT EXISTS app;
GRANT ALL PRIVILEGES ON app.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON app.* TO 'root'@'localhost';
