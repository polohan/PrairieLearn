-- A Work in Progress to discuss shared schema for group storage in PL
CREATE TABLE IF NOT EXISTS group_configs (
    id BIGSERIAL PRIMARY KEY,
    course_instance_id BIGINT NOT NULL REFERENCES course_instances(id) ON DELETE CASCADE ON UPDATE CASCADE,
    assessment_id BIGINT REFERENCES assessments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    type TEXT, -- what will these be? This might belong in groups rather than groups_config
    name TEXT, -- or maybe description is accurate here? Maybe as a base for groups created from it?
    minimum INT,
    maximum INT,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS groups (
    id BIGSERIAL PRIMARY KEY,
    course_instance_id BIGINT NOT NULL REFERENCES course_instances(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name TEXT,      -- visible name of the group
    group_config_id BIGINT REFERENCES group_configs(id) ON DELETE CASCADE ON UPDATE CASCADE,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone
);

-- simple join table, no extra metadata - that could be stored in audit logs if needed
CREATE TABLE IF NOT EXISTS group_users (
    group_id BIGINT REFERENCES groups(id),
    user_id BIGINT REFERENCES users,
    PRIMARY KEY (group_id, user_id)
);

ALTER TABLE assessments ADD COLUMN groupwork boolean DEFAULT FALSE;
ALTER TABLE assessment_instances ADD COLUMN group_id BIGINT REFERENCES groups(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE assessment_instances ADD CONSTRAINT uniqueGroupAI UNIQUE (assessment_id, group_id, number);
ALTER TABLE assessment_instances ADD CONSTRAINT user_group_XOR CHECK ((user_id IS NOT NULL AND group_id is NULL) OR (group_id IS NOT NULL AND user_id is NULL));
ALTER TABLE assessment_instances ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE audit_logs ADD COLUMN group_id BIGINT REFERENCES groups ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE variants ADD COLUMN group_id BIGINT REFERENCES groups ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE variants ADD CONSTRAINT user_group_XOR CHECK ((user_id IS NOT NULL AND group_id is NULL) OR (group_id IS NOT NULL AND user_id is NULL));
ALTER TABLE variants ALTER COLUMN user_id DROP NOT NULL;