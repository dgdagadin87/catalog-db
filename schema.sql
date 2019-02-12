-- SCHEMA: catalog
-- DROP SCHEMA catalog ;
CREATE SCHEMA catalog
    AUTHORIZATION postgres;

-- DROP TABLE catalog.client;
CREATE TABLE catalog.client
(
    client_id BIGSERIAL PRIMARY KEY NOT NULL,
    client_name character varying(100) NOT NULL,
    client_agent character varying(100),
    client_email character varying(100),
    client_phone character varying(100)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.manager;
CREATE TABLE catalog.manager
(
    manager_id SERIAL PRIMARY KEY NOT NULL,
    manager_name character varying(100) NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.order_state;
CREATE TABLE catalog.order_state
(
    order_state_id SERIAL PRIMARY KEY NOT NULL,
    order_state_code character varying(50) NOT NULL,
    order_state_name character varying(50) NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

INSERT INTO catalog.order_state (order_state_code, order_state_name) VALUES
    ('BOUNCED_DONE', 'Оплачен, выполнен'),
    ('CANCELLED', 'Отменен'),
    ('DONE', 'Закрыт'),
    ('DONE_WITHOUT_BOUNCE', 'Выполнен без оплаты');

-- DROP TABLE catalog.order_source;
CREATE TABLE catalog.order_source
(
    order_source_id SERIAL PRIMARY KEY NOT NULL,
    order_source_code character varying(50) NOT NULL,
    order_source_name character varying(50) NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

INSERT INTO catalog.order_source (order_source_code, order_source_name) VALUES
    ('OUTSIDE_ARCHIVE', 'Чужой архив'),
    ('INSIDE_ARCHIVE', 'Свой архив'),
    ('OUTSIDE_PHOTOGRAPHY', 'Чужая съемка'),
    ('INSIDE_PHOTOGRAPHY', 'Своя съемка'),
    ('COMPOUND', 'Смесь');

-- DROP TABLE catalog.order;
CREATE TABLE catalog.order
(
    order_id BIGSERIAL PRIMARY KEY NOT NULL,
    order_number character varying(100) NOT NULL,
    order_create_date date NOT NULL,
    order_complete_date date,
    client_id BIGINT NOT NULL,
    manager_id INTEGER NOT NULL,
    order_state_id INTEGER NOT NULL,
    order_source_id INTEGER NOT NULL,
    FOREIGN KEY (client_id) REFERENCES catalog.client (client_id),
    FOREIGN KEY (manager_id) REFERENCES catalog.manager (manager_id),
    FOREIGN KEY (order_state_id) REFERENCES catalog.order_state (order_state_id),
    FOREIGN KEY (order_source_id) REFERENCES catalog.order_source (order_source_id)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.platform;
CREATE TABLE catalog.platform
(
    platform_id SERIAL PRIMARY KEY NOT NULL,
    platform_name character varying(50) NOT NULL,
    platform_table_name character varying(50) NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.scene;
CREATE TABLE catalog.scene
(
    scene_id character varying(4000) PRIMARY KEY COLLATE pg_catalog."default" NOT NULL,
    stereo_scene_id character varying(4000) COLLATE pg_catalog."default",
    scene_platform_id BIGINT NOT NULL,
    scene_identity_value BIGINT NOT NULL,
    FOREIGN KEY (scene_platform_id) REFERENCES catalog.platform (platform_id)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.order_2_scene;
CREATE TABLE catalog.order_2_scene
(
    order_2_scene_id BIGSERIAL PRIMARY KEY NOT NULL,
    order_id BIGINT NOT NULL,
    scene_id character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    UNIQUE (order_id, scene_id),
    FOREIGN KEY (order_id) REFERENCES catalog.order (order_id),
    FOREIGN KEY (scene_id) REFERENCES catalog.scene (scene_id)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.parameter;
CREATE TABLE catalog.parameter
(
    parameter_id BIGSERIAL PRIMARY KEY NOT NULL,
    parameter_name character varying(100) NOT NULL,
    parameter_column_name character varying(50) NOT NULL
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.platform_2_parameter;
CREATE TABLE catalog.platform_2_parameter
(
    platform_2_parameter_id BIGSERIAL PRIMARY KEY NOT NULL,
    platform_id BIGINT NOT NULL,
    parameter_id BIGINT NOT NULL,
    UNIQUE (platform_id, parameter_id),
    FOREIGN KEY (platform_id) REFERENCES catalog.platform (platform_id),
    FOREIGN KEY (parameter_id) REFERENCES catalog.parameter (parameter_id)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;

-- DROP TABLE catalog.scene_archive;
CREATE TABLE catalog.scene_archive
(
    scene_archive_id BIGSERIAL PRIMARY KEY NOT NULL,
    scene_archive_scene_id character varying(4000) COLLATE pg_catalog."default" NOT NULL,
    scene_file_path  character varying(500) NOT NULL,
    scene_file_order INTEGER DEFAULT 1,
    UNIQUE (scene_archive_scene_id, scene_file_order),
    FOREIGN KEY (scene_archive_scene_id) REFERENCES catalog.scene (scene_id)
)
WITH (
    OIDS = TRUE
)
TABLESPACE pg_default;