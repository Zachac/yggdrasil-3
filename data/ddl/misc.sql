
CREATE TABLE actions (
    item_name VARCHAR(80) NOT NULL,
    action VARCHAR(80) NOT NULL,
    script VARCHAR(200) NOT NULL,
    consume BOOLEAN,
    UNIQUE(item_name, action)
);

CREATE TABLE resource (
    resource_name VARCHAR(80) NOT NULL,
    skill VARCHAR(80) NOT NULL,
    level INTEGER NOT NULL DEFAULT 0,
    produces VARCHAR(80),
    wheight INTEGER NOT NULL DEFAULT 1,
    UNIQUE(resource_name, skill, level, produces)
);
