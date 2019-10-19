
CREATE TABLE actions (
    item_name VARCHAR(80) NOT NULL,
    action VARCHAR(80) NOT NULL,
    script VARCHAR(200) NOT NULL,
    consume BOOLEAN,
    UNIQUE(item_name, action)
);


CREATE TABLE recipe_requirements (
    item_name VARCHAR(80) NOT NULL,
    required_name VARCHAR(80) NOT NULL,
    count INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY(item_name, required_name)
);

CREATE TABLE recipe (
    item_name VARCHAR(80) NOT NULL PRIMARY KEY,
    skill_name VARCHAR(80),
    required_level INTEGER NOT NULL DEFAULT 0,
    experience INTEGER NOT NULL DEFAULT 0
);


CREATE TABLE entity_instance (
    entity_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    location VARCHAR(80)
);

CREATE TABLE entity (
    entity_name VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    description VARCHAR(200),
    PRIMARY KEY(entity_name, entity_type)
);

CREATE TABLE item_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE resource (
    resource_name VARCHAR(80) NOT NULL,
    skill VARCHAR(80) NOT NULL,
    level INTEGER NOT NULL DEFAULT 0,
    produces VARCHAR(80),
    wheight INTEGER NOT NULL DEFAULT 1,
    UNIQUE(resource_name, skill, level, produces)
);

CREATE TABLE links (
    link_name VARCHAR(80),
    src_location VARCHAR(80),
    dest_location VARCHAR(80)
);
CREATE TABLE map_tiles (
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    PRIMARY KEY(x, y)
);

CREATE TABLE map_icons (
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    icon CHARACTER(3) NOT NULL,
    PRIMARY KEY(x, y)
);

CREATE TABLE biome_spawns (
    biome_name VARCHAR(80) NOT NULL,
    entity_name VARCHAR(80) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    chance FLOAT,
    PRIMARY KEY(biome_name, entity_name, entity_type)
);

CREATE TABLE room (
    location VARCHAR(80) NOT NULL PRIMARY KEY,
    room_name VARCHAR(80),
    description VARCHAR(512)
);

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

CREATE TABLE wall (
    location VARCHAR(80) NOT NULL,
    name VARCHAR(80) NOT NULL,
    PRIMARY KEY(location, name)
);
