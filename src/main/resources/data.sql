INSERT INTO kojibello.user (userid, email_address, first_name, last_name, password, ssn, user_name)
VALUES ("101", "kojibello@gmail.com", "koji", "bello", "$2a$10$w.2Z0pQl9K5GOMVT.y2Jz.UW4Au7819nbzNh8nZIYhbnjCi6MG8Qu", "202XXX", "kojibello");
INSERT INTO kojibello.role (roleid, role) VALUES ("201", "ADMIN");
INSERT INTO kojibello.user_role (userid, roleid) VALUES ("101", "201");