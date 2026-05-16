-- Migration 003: Strategy Schema
-- Membuat tabel Cluster 4: cv_strategy_briefs, selected_content_packages, revision_history
-- Depends on: 001_initial_schema.sql

-- ============================================================
-- CV STRATEGY BRIEFS
-- Brief yang dibuat Planner Agent dan di-adjust oleh user.
-- Instruksi ini dikonsumsi Cluster 5 untuk generate konten CV.
-- ============================================================
CREATE TABLE IF NOT EXISTS cv_strategy_briefs (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id          UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    -- Zona Merah: instruksi konten dikontrol agent (entry mana yang masuk, berapa top-N)
    content_instructions    JSONB,
    -- Zona Kuning: instruksi narasi per gap / implicit match
    narrative_instructions  JSONB,
    -- Zona Kuning: keyword yang harus diinjeksi ke narasi CV
    keyword_targets         TEXT[],
    -- Zona Hijau: bebas diedit user
    primary_angle           TEXT,
    summary_hook_direction  TEXT,
    tone                    VARCHAR(30)     CHECK (tone IN ('technical_concise', 'professional_formal', 'professional_conversational')),
    user_approved           BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- SELECTED CONTENT PACKAGES
-- Hasil seleksi top-N entry dari Master Data oleh Selection Agent.
-- FK ke cv_strategy_briefs karena seleksi terikat ke satu brief.
-- ============================================================
CREATE TABLE IF NOT EXISTS selected_content_packages (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    brief_id        UUID            NOT NULL REFERENCES cv_strategy_briefs(id) ON DELETE CASCADE,
    -- Entry yang dipilih per komponen, lengkap dengan data dari Master Data
    content         JSONB,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- REVISION HISTORY
-- Rekaman setiap instruksi revisi ke Cluster 5,
-- baik yang dipicu QC maupun user.
-- ============================================================
CREATE TABLE IF NOT EXISTS revision_history (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    revision_type   VARCHAR(20)     CHECK (revision_type IN ('qc_driven', 'user_driven')),
    iteration       INTEGER         NOT NULL,
    -- Section yang direvisi beserta instruksinya
    sections        JSONB,
    status          VARCHAR(20)     CHECK (status IN ('pending', 'completed', 'max_reached')),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);
