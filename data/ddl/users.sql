
CREATE TABLE skills (
    user_name VARCHAR(30),
    skill_name VARCHAR(80),
    experience BIGINT,
    level INTEGER,
    PRIMARY KEY(user_name, skill_name)
);

CREATE TABLE user (
    user_name VARCHAR(30) NOT NULL PRIMARY KEY,
    password CHAR(44) NOT NULL,
    spawn VARCHAR(80) NOT NULL DEFAULT 'd:0 0',
    pid INTEGER
);
