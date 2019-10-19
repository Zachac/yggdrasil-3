
CREATE TABLE entity (
    entity_name VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    description VARCHAR(200),
    PRIMARY KEY(entity_name, entity_type)
);

CREATE TABLE entity_instance (
    entity_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    location VARCHAR(80)
);

CREATE TABLE item_stack (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (entity_id) 
        REFERENCES entity_instance(entity_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
