-- Migration 008: Indexes
-- Index untuk query yang paling sering dijalankan.
-- Semua menggunakan IF NOT EXISTS agar idempoten.

-- ============================================================
-- Cluster 1: query profil per user
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_education_user_id
    ON education(user_id);

CREATE INDEX IF NOT EXISTS idx_experience_user_id
    ON experience(user_id);

CREATE INDEX IF NOT EXISTS idx_projects_user_id
    ON projects(user_id);

CREATE INDEX IF NOT EXISTS idx_awards_user_id
    ON awards(user_id);

CREATE INDEX IF NOT EXISTS idx_organizations_user_id
    ON organizations(user_id);

CREATE INDEX IF NOT EXISTS idx_certificates_user_id
    ON certificates(user_id);

CREATE INDEX IF NOT EXISTS idx_skills_user_id
    ON skills(user_id);

-- ============================================================
-- Cluster 2: query per lamaran
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_applications_user_id
    ON applications(user_id);

CREATE INDEX IF NOT EXISTS idx_job_postings_application_id
    ON job_postings(application_id);

CREATE INDEX IF NOT EXISTS idx_job_requirements_application_id
    ON job_requirements(application_id);

-- ============================================================
-- Cluster 3: Gap Analyzer membaca per lamaran
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_gap_analysis_results_application_id
    ON gap_analysis_results(application_id);

CREATE INDEX IF NOT EXISTS idx_gap_analysis_scores_application_id
    ON gap_analysis_scores(application_id);

-- ============================================================
-- Cluster 4: Strategy lookup per lamaran
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_cv_strategy_briefs_application_id
    ON cv_strategy_briefs(application_id);

CREATE INDEX IF NOT EXISTS idx_selected_content_packages_application_id
    ON selected_content_packages(application_id);

CREATE INDEX IF NOT EXISTS idx_revision_history_application_id
    ON revision_history(application_id);

-- ============================================================
-- Cluster 5: ambil versi terbaru CV per lamaran
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_cv_outputs_application_id
    ON cv_outputs(application_id);

CREATE INDEX IF NOT EXISTS idx_cv_outputs_version
    ON cv_outputs(application_id, version DESC);

-- ============================================================
-- Cluster 6: QC lookup per iterasi
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_qc_results_application_id
    ON qc_results(application_id);

CREATE INDEX IF NOT EXISTS idx_qc_results_application_cv_iter
    ON qc_results(application_id, cv_version, iteration);

CREATE INDEX IF NOT EXISTS idx_qc_overall_scores_application_id
    ON qc_overall_scores(application_id);

-- ============================================================
-- Tier & Billing
-- ============================================================

-- Admin melihat pending upgrade requests
CREATE INDEX IF NOT EXISTS idx_upgrade_requests_status
    ON upgrade_requests(status);

CREATE INDEX IF NOT EXISTS idx_upgrade_requests_user_id
    ON upgrade_requests(user_id);

-- ============================================================
-- Workflow concurrency check
-- Partial index — hanya row yang sedang aktif, sangat kecil
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_applications_workflow_active
    ON applications(user_id, is_workflow_active)
    WHERE is_workflow_active = TRUE;
