DROP DATABASE genomeviewer_development;
CREATE DATABASE genomeviewer_development;
USE genomeviewer_development;

CREATE TABLE users (
 id          int      PRIMARY KEY  AUTO_INCREMENT,
 login       varchar(20),
 password  varchar(20)
) ;


CREATE TABLE options (
 id          int      PRIMARY KEY  AUTO_INCREMENT,
 user_id  int UNIQUE NOT NULL REFERENCES users(id),
 anoption       varchar(20)
);


INSERT INTO users (login, password) VALUES ('admin','m1');
INSERT INTO options (user_id, anoption) VALUES (1,'DEINECONFIGURATION');
