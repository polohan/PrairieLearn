CREATE TABLE IF NOT EXISTS jobs (
    id SERIAL PRIMARY KEY,
    start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP;
    finish_date TIMESTAMP WITH TIME ZONE,
    course_id INTEGER NOT NULL REFERENCES courses ON DELETE CASCADE ON UPDATE CASCADE,
    number INTEGER,
    user_id INTEGER NOT NULL REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    authn_user_id INTEGER REFERENCES users ON DELETE CASCADE ON UPDATE CASCADE,
    type enum_job_type,
    status enum_job_status,
    stdin TEXT,
    stdout TEXT,
    stderr TEXT,
    pid INTEGER,
    command TEXT,
    arguments TEXT[],
    working_directory TEXT,
    return_code INTEGER,
    UNIQUE (course_id, number)
);
