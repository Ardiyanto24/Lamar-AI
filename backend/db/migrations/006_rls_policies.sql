-- Migration 006: Row Level Security Policies
-- Mengaktifkan RLS dan mendefinisikan policy akses di semua tabel dari 001–005.
-- Depends on: 001 sampai 005 harus sudah dijalankan.
--
-- Ada dua pola:
--   Pola A — tabel dengan kolom user_id langsung
--   Pola B — tabel yang FK ke applications (tidak punya user_id langsung)

-- ============================================================
-- POLA A — tabel dengan user_id langsung
-- Policy: user hanya bisa akses row milik sendiri
-- ============================================================

-- users: SELECT dan UPDATE saja (INSERT dihandle trigger 007, bukan user langsung)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data_select"
    ON users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "users_own_data_update"
    ON users FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- education
ALTER TABLE education ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON education FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- experience
ALTER TABLE experience ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON experience FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- projects
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON projects FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- awards
ALTER TABLE awards ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON awards FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- organizations
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON organizations FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- certificates
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON certificates FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- skills
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON skills FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- applications
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON applications FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- upgrade_requests
ALTER TABLE upgrade_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON upgrade_requests FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- POLA B — tabel yang FK ke applications
-- Policy: user bisa akses row hanya jika application_id milik mereka
-- ============================================================

-- job_postings
ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON job_postings FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- job_requirements
ALTER TABLE job_requirements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON job_requirements FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- gap_analysis_results
ALTER TABLE gap_analysis_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON gap_analysis_results FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- gap_analysis_scores
ALTER TABLE gap_analysis_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON gap_analysis_scores FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- cv_strategy_briefs
ALTER TABLE cv_strategy_briefs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON cv_strategy_briefs FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- selected_content_packages
ALTER TABLE selected_content_packages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON selected_content_packages FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- revision_history
ALTER TABLE revision_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON revision_history FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- cv_outputs
ALTER TABLE cv_outputs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON cv_outputs FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- qc_results
ALTER TABLE qc_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON qc_results FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- qc_overall_scores
ALTER TABLE qc_overall_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_data"
    ON qc_overall_scores FOR ALL
    USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    )
    WITH CHECK (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );
