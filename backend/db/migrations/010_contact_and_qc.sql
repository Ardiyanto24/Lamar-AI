-- Migration 010: Contact Fields dan QC Score Updates
-- Menambahkan field kontak ke users (header CV), kolom skor tambahan ke
-- qc_overall_scores (best version selection), section_approvals ke cv_outputs
-- (persistensi INTERRUPT 3), dan is_workflow_active ke applications.
--
-- Semua menggunakan ADD COLUMN IF NOT EXISTS agar idempoten jika kolom
-- sudah ada dari migration awal.

-- Field kontak untuk header CV (diisi user manual di halaman Settings)
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS phone_number  VARCHAR(20),
    ADD COLUMN IF NOT EXISTS linkedin_url  VARCHAR(500),
    ADD COLUMN IF NOT EXISTS github_url    VARCHAR(500);

-- Kolom skor tambahan untuk best version selection yang akurat
-- overall_combined_score adalah kolom utama yang dipakai Cluster 4
ALTER TABLE qc_overall_scores
    ADD COLUMN IF NOT EXISTS overall_semantic_score  NUMERIC(5,2),
    ADD COLUMN IF NOT EXISTS overall_combined_score  NUMERIC(5,2);

-- Persistensi status approval user per section di INTERRUPT 3
-- Mencegah hilangnya keputusan approval jika browser crash atau user pindah tab
ALTER TABLE cv_outputs
    ADD COLUMN IF NOT EXISTS section_approvals JSONB;

-- Flag untuk mencegah dua workflow berjalan bersamaan untuk satu user
ALTER TABLE applications
    ADD COLUMN IF NOT EXISTS is_workflow_active BOOLEAN NOT NULL DEFAULT FALSE;

-- Partial index untuk concurrent workflow check — hanya row aktif
CREATE INDEX IF NOT EXISTS idx_applications_workflow_active
    ON applications(user_id, is_workflow_active)
    WHERE is_workflow_active = TRUE;
