
CREATE TABLE recipe (
    item_name VARCHAR(80) NOT NULL PRIMARY KEY,
    skill_name VARCHAR(80),
    required_level INTEGER NOT NULL DEFAULT 0,
    experience INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE recipe_requirements (
    item_name VARCHAR(80) NOT NULL,
    required_name VARCHAR(80) NOT NULL,
    count INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(item_name, required_name),
    FOREIGN KEY (item_name) 
        REFERENCES recipe(item_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
