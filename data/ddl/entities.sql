
-- Entity & derivatives DDL statements

CREATE TABLE entity_type (
    entity_type_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    entity_type VARCHAR(80) NOT NULL PRIMARY KEY,
    INDEX (entity_type_id)
);

CREATE TABLE entity_def (
    entity_def_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    entity_name VARCHAR(80) NOT NULL PRIMARY KEY,
    entity_type_id INTEGER NOT NULL,
    max_health INTEGER,
    description VARCHAR(200),
    INDEX(entity_def_id),
    FOREIGN KEY(entity_type_id)
        REFERENCES entity_type(entity_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE entity_instance (
    entity_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_def_id INTEGER NOT NULL,
    health INTEGER,
    location VARCHAR(40),
    INDEX(location),
    FOREIGN KEY (entity_def_id)
        REFERENCES entity_def(entity_def_id)
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

-- updatable
CREATE VIEW entity AS
SELECT instance.entity_id, typ.entity_type, def.entity_name, instance.health, def.max_health, def.description, instance.location
FROM entity_def def
JOIN entity_type typ on typ.entity_type_id = def.entity_type_id
JOIN entity_instance instance on instance.entity_def_id = def.entity_def_id;
