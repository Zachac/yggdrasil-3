
CREATE TABLE room (
    location VARCHAR(80) NOT NULL PRIMARY KEY,
    room_name VARCHAR(80),
    description VARCHAR(512)
);

CREATE TABLE wall (
    location VARCHAR(80) NOT NULL,
    name VARCHAR(80) NOT NULL,
    PRIMARY KEY(location, name)
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
