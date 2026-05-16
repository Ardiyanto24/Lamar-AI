-- Migration 001: Initial Schema
-- Membuat tabel fondasi: users, 7 komponen Master Data, applications, job_postings, job_requirements
-- Catatan: RLS belum diaktifkan di sini — ada di migration 006

-- ============================================================
-- USERS
-- Extension dari auth.users. Record dibuat via trigger (007),
-- bukan insert langsung oleh aplikasi.
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id              UUID            PRIMARY KEY,  -- sama dengan auth.users.id
    name            VARCHAR(255)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    avatar_url      VARCHAR(500),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- MASTER DATA — Cluster 1
-- ============================================================

CREATE TABLE IF NOT EXISTS education (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    institution     VARCHAR(255)    NOT NULL,
    degree          VARCHAR(255),
    field_of_study  VARCHAR(255),
    start_date      DATE,
    end_date        DATE,
    is_current      BOOLEAN         NOT NULL DEFAULT FALSE,
    what_i_did      TEXT[],
    challenge       TEXT[],
    impact          TEXT[],
    skills_used     TEXT[],
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS experience (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company         VARCHAR(255)    NOT NULL,
    role            VARCHAR(255)    NOT NULL,
    start_date      DATE,
    end_date        DATE,
    is_current      BOOLEAN         NOT NULL DEFAULT FALSE,
    what_i_did      TEXT[]          NOT NULL,
    challenge       TEXT[],
    impact          TEXT[],
    skills_used     TEXT[],
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS projects (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           VARCHAR(255)    NOT NULL,
    url             VARCHAR(500),
    start_date      DATE,
    end_date        DATE,
    what_i_did      TEXT[]          NOT NULL,
    challenge       TEXT[],
    impact          TEXT[],
    skills_used     TEXT[],
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS awards (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title           VARCHAR(255)    NOT NULL,
    issuer          VARCHAR(255),
    date            DATE,
    what_i_did      TEXT[],
    challenge       TEXT[],
    impact          TEXT[],
    skills_used     TEXT[],
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS organizations (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(255)    NOT NULL,
    role            VARCHAR(255),
    start_date      DATE,
    end_date        DATE,
    is_current      BOOLEAN         NOT NULL DEFAULT FALSE,
    what_i_did      TEXT[],
    challenge       TEXT[],
    impact          TEXT[],
    skills_used     TEXT[],
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS certificates (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(255)    NOT NULL,
    issuer          VARCHAR(255),
    issue_date      DATE,
    expiry_date     DATE,
    url             VARCHAR(500),
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS skills (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(255)    NOT NULL,
    category        VARCHAR(50)     CHECK (category IN ('technical', 'soft', 'tool')),
    is_inferred     BOOLEAN         NOT NULL DEFAULT FALSE,
    source          TEXT,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    -- case-insensitive uniqueness dihandle di level aplikasi sebelum insert;
    -- constraint ini mencegah duplikat exact-case
    CONSTRAINT uq_skills_user_name UNIQUE (user_id, name)
);

-- ============================================================
-- APPLICATIONS — Cluster 2
-- ============================================================

CREATE TABLE IF NOT EXISTS applications (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_name        VARCHAR(255)    NOT NULL,
    position            VARCHAR(255)    NOT NULL,
    cv_language         VARCHAR(10)     NOT NULL CHECK (cv_language IN ('id', 'en')),
    status              VARCHAR(20)     NOT NULL DEFAULT 'draft'
                            CHECK (status IN ('draft', 'applied', 'interview', 'offer', 'rejected', 'accepted')),
    workflow_status     VARCHAR(50),
    is_workflow_active  BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS job_postings (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL UNIQUE REFERENCES applications(id) ON DELETE CASCADE,
    jd_raw          TEXT,
    jr_raw          TEXT,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS job_requirements (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    requirement_id  VARCHAR(10),
    text            TEXT            NOT NULL,
    source          VARCHAR(10)     CHECK (source IN ('JD', 'JR', 'JD+JR')),
    priority        VARCHAR(20)     CHECK (priority IN ('must', 'nice_to_have')),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);
