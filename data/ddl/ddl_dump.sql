
CREATE TABLE IF NOT EXISTS actions (
    item_name NOT NULL,
    action NOT NULL,
    script NOT NULL,
    consume,
    UNIQUE(item_name, action)
);


CREATE TABLE IF NOT EXISTS recipe_requirements (
    item_name NOT NULL,
    required_name NOT NULL,
    count NOT NULL DEFAULT 0,
    PRIMARY KEY(item_name, required_name)
);

CREATE TABLE IF NOT EXISTS recipe (
    item_name NOT NULL PRIMARY KEY,
    skill_name,
    required_level NOT NULL DEFAULT 0,
    experience NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS entity_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    entity_name NOT NULL,
    entity_type NOT NULL,
    location
);

CREATE TABLE IF NOT EXISTS entity (
    entity_name NOT NULL,
    entity_type NOT NULL,
    description,
    PRIMARY KEY(entity_name, entity_type)
);

CREATE TABLE IF NOT EXISTS item_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS resource (
    resource_name NOT NULL,
    skill NOT NULL,
    level INTEGER NOT NULL DEFAULT 0,
    produces,
    wheight INTEGER NOT NULL DEFAULT 1,
    UNIQUE(resource_name, skill, level, produces)
);

CREATE TABLE IF NOT EXISTS links (
    link_name,
    src_location,
    dest_location
);
CREATE TABLE IF NOT EXISTS map_tiles (
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    UNIQUE(x, y)
);

CREATE TABLE IF NOT EXISTS map_icons (
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    icon CHARACTER(3) NOT NULL,
    PRIMARY KEY(x, y)
);

CREATE TABLE IF NOT EXISTS biome_spawns (
    biome_name NOT NULL,
    entity_name NOT NULL,
    entity_type NOT NULL,
    chance,
    UNIQUE(biome_name, entity_name, entity_type)
);

CREATE TABLE IF NOT EXISTS room (
    location UNIQUE PRIMARY KEY,
    room_name,
    description
);

CREATE TABLE IF NOT EXISTS skills (
    user_name,
    skill_name,
    experience,
    level,
    PRIMARY KEY(user_name, skill_name)
);

CREATE TABLE IF NOT EXISTS user (
    user_name NOT NULL PRIMARY KEY,
    password NOT NULL,
    spawn NOT NULL DEFAULT 'd:0 0',
    pid
);

CREATE TABLE IF NOT EXISTS wall (
    location NOT NULL,
    name NOT NULL,
    UNIQUE(location, name)
);
