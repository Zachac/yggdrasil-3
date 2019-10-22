
-- Entity & derivatives DDL statements

CREATE TABLE entity_type (
    entity_type_id NOT NULL INTEGER AUTO_INCREMENT,
    entity_type_name VARCHAR(80) NOT NULL
    PRIMARY KEY(entity_type_id, entity_type_name)
);

CREATE TABLE entity (
    entity_def_id NOT NULL INTEGER AUTO_INCREMENT PRIMARY KEY,
    entity_type_id INTEGER NOT NULL,
    entity_name VARCHAR(80) NOT NULL,
    description VARCHAR(200),
    UNIQUE(entity_type_id, entity_name)
);

CREATE TABLE entity_instance (
    entity_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_def_id INTEGER NOT NULL,
    location VARCHAR(80),
    FOREIGN KEY (entity_def_id) 
        REFERENCES entity(entity_def_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE item_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (entity_id) 
        REFERENCES entity_instance(entity_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
