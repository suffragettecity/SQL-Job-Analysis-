CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

-- DROP DATABASE jobs_mart;

SELECT * 
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;

-- DROP SCHEMA staging;

CREATE TABLE staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer');

USE jobs_mart;

SELECT * FROM staging.preferred_roles;

-- DROP TABLE staging.preferred_roles;

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (3, 'Data Scientist'),
    (4, 'Data Analyst');

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3 OR role_id = 4;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT * FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role to priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INT;

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

UPDATE staging.priority_roles
SET priority_lvl = 2
WHERE role_id = 4;