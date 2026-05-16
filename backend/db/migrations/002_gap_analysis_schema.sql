-- Migration 002: Gap Analysis Schema
-- Membuat tabel Cluster 3: gap_analysis_results dan gap_analysis_scores
-- Depends on: 001_initial_schema.sql

-- ============================================================
-- GAP ANALYSIS RESULTS
-- Hasil analisis per item requirement oleh Gap Analyzer Agent.
-- Setiap item dari job_requirements menghasilkan satu record.
-- ============================================================
CREATE TABLE IF NOT EXISTS gap_analysis_results (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    item_id         VARCHAR(10),
    text            TEXT,
    dimension       VARCHAR(5)      CHECK (dimension IN ('JD', 'JR')),
    category        VARCHAR(20)     CHECK (category IN ('exact_match', 'implicit_match', 'gap')),
    priority        VARCHAR(20)     CHECK (priority IN ('must', 'nice_to_have')),
    -- Array bukti dari Master Data. NULL jika category = 'gap'.
    -- Struktur: [{"source": "experience", "entry_id": "uuid", "entry_title": "...", "detail": "..."}]
    evidence        JSONB,
    -- Wajib diisi jika category = 'implicit_match'
    reasoning       TEXT,
    -- Wajib diisi jika category = 'gap'
    suggestion      TEXT,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- GAP ANALYSIS SCORES
-- Skor kesesuaian per lamaran. One-to-one dengan applications.
-- Formula: (exact_match×1.0 + implicit_match×0.7) / total_items × 100
-- ============================================================
CREATE TABLE IF NOT EXISTS gap_analysis_scores (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id          UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    quantitative_score      NUMERIC(5,2),
    verdict                 VARCHAR(20)     CHECK (verdict IN ('sangat_cocok', 'cukup_cocok', 'kurang_cocok')),
    strength                TEXT,
    concern                 TEXT,
    recommendation          TEXT,
    proceed_recommendation  VARCHAR(10)     CHECK (proceed_recommendation IN ('lanjut', 'tinjau')),
    created_at              TIMESTAMP       NOT NULL DEFAULT NOW()
);
