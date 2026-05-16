-- Migration 004: CV Output Schema
-- Membuat tabel Cluster 5 dan 6: cv_outputs, qc_results, qc_overall_scores
-- Depends on: 001_initial_schema.sql

-- ============================================================
-- CV OUTPUTS — Cluster 5
-- Setiap iterasi revisi menghasilkan versi baru — tidak ada overwrite.
--
-- State machine status:
--   draft → qc_passed → user_approved → final
-- ============================================================
CREATE TABLE IF NOT EXISTS cv_outputs (
    id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id      UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    version             INTEGER         NOT NULL,
    -- Final Structured Output — semua section CV dalam satu JSON
    content             JSONB,
    revision_type       VARCHAR(20)     CHECK (revision_type IN ('initial', 'qc_driven', 'user_driven')),
    -- NULL berarti initial generation (seluruh CV)
    section_revised     VARCHAR(50),
    -- Status approval user per section di INTERRUPT 3. Nullable.
    section_approvals   JSONB,
    status              VARCHAR(20)     CHECK (status IN ('draft', 'qc_passed', 'user_approved', 'final')),
    created_at          TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- QC RESULTS — Cluster 6
-- Hasil evaluasi QC per section per iterasi.
-- action_required = TRUE jika ats_status = failed ATAU semantic_status = failed.
-- ============================================================
CREATE TABLE IF NOT EXISTS qc_results (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id  UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    cv_version      INTEGER         NOT NULL,
    iteration       INTEGER         NOT NULL,
    section         VARCHAR(50),
    -- Nullable: diisi jika section punya banyak entry (mis. setiap experience punya entry_id)
    entry_id        UUID,
    ats_score       NUMERIC(5,2),
    ats_status      VARCHAR(10)     CHECK (ats_status IN ('passed', 'failed')),
    semantic_score  NUMERIC(5,2),
    semantic_status VARCHAR(10)     CHECK (semantic_status IN ('passed', 'failed')),
    -- Single source of truth untuk Cluster 4: perlu revisi atau tidak
    action_required BOOLEAN,
    -- Elemen yang harus dipertahankan saat revisi
    preserve        JSONB,
    -- Instruksi perbaikan yang spesifik
    revise          JSONB,
    missed_keywords TEXT[],
    -- Rata-rata tertimbang ATS + Semantic. Digunakan untuk best version selection.
    combined_score  NUMERIC(5,2),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ============================================================
-- QC OVERALL SCORES — Cluster 6
-- Ringkasan QC per iterasi. Digunakan untuk tracking progress
-- dan best version selection via overall_combined_score.
-- ============================================================
CREATE TABLE IF NOT EXISTS qc_overall_scores (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id          UUID            NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    cv_version              INTEGER         NOT NULL,
    iteration               INTEGER         NOT NULL,
    overall_ats_score       NUMERIC(5,2),
    overall_semantic_score  NUMERIC(5,2),
    -- Kolom utama untuk best version selection
    overall_combined_score  NUMERIC(5,2),
    sections_passed         INTEGER,
    sections_failed         INTEGER,
    created_at              TIMESTAMP       NOT NULL DEFAULT NOW()
);
