-- Migration 005: Tier and Billing
-- Menambahkan kolom tier ke users dan membuat tabel upgrade_requests
-- Depends on: 001_initial_schema.sql

-- ============================================================
-- TIER — tambah ke tabel users yang sudah ada
-- ============================================================
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS tier            VARCHAR(10) NOT NULL DEFAULT 'free'
        CHECK (tier IN ('free', 'pro')),
    ADD COLUMN IF NOT EXISTS tier_updated_at TIMESTAMP;

-- ============================================================
-- UPGRADE REQUESTS
-- Form request upgrade ke Pro. Admin memverifikasi secara manual.
-- FK ke users, bukan applications.
-- ============================================================
CREATE TABLE IF NOT EXISTS upgrade_requests (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID            NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message         TEXT,
    status          VARCHAR(20)     NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'approved', 'rejected')),
    processed_at    TIMESTAMP,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);
