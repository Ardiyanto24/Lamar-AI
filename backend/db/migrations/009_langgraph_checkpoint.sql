-- Migration 009: LangGraph Checkpoint Tables
-- Tabel yang dibutuhkan PostgresSaver milik LangGraph untuk menyimpan workflow state.
-- WAJIB dijalankan sebelum backend pertama kali dijalankan — backend crash saat startup
-- jika tabel ini belum ada.
--
-- LangGraph mengelola tabel ini secara internal.
-- Kode aplikasi tidak pernah query atau menulis ke tabel ini secara langsung.

-- Tabel utama checkpoint — menyimpan state LangGraph per thread
CREATE TABLE IF NOT EXISTS checkpoints (
    thread_id               TEXT        NOT NULL,
    checkpoint_ns           TEXT        NOT NULL DEFAULT '',
    checkpoint_id           TEXT        NOT NULL,
    parent_checkpoint_id    TEXT,
    type                    TEXT,
    checkpoint              JSONB       NOT NULL,
    metadata                JSONB       NOT NULL DEFAULT '{}',
    created_at              TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (thread_id, checkpoint_ns, checkpoint_id)
);

-- Tabel write operations — menyimpan intermediate writes per node
CREATE TABLE IF NOT EXISTS checkpoint_writes (
    thread_id       TEXT        NOT NULL,
    checkpoint_ns   TEXT        NOT NULL DEFAULT '',
    checkpoint_id   TEXT        NOT NULL,
    task_id         TEXT        NOT NULL,
    idx             INTEGER     NOT NULL,
    channel         TEXT        NOT NULL,
    type            TEXT,
    value           JSONB,
    PRIMARY KEY (thread_id, checkpoint_ns, checkpoint_id, task_id, idx)
);

-- Tabel blob storage — untuk state yang terlalu besar untuk JSONB
CREATE TABLE IF NOT EXISTS checkpoint_blobs (
    thread_id       TEXT        NOT NULL,
    checkpoint_ns   TEXT        NOT NULL DEFAULT '',
    channel         TEXT        NOT NULL,
    version         TEXT        NOT NULL,
    type            TEXT        NOT NULL,
    blob            BYTEA,
    PRIMARY KEY (thread_id, checkpoint_ns, channel, version)
);

-- Index untuk lookup cepat per thread
CREATE INDEX IF NOT EXISTS idx_checkpoints_thread_id
    ON checkpoints(thread_id);

CREATE INDEX IF NOT EXISTS idx_checkpoint_writes_thread_id
    ON checkpoint_writes(thread_id);

-- Checkpoint lama tidak otomatis terhapus. Contoh query cleanup manual
-- untuk checkpoint orphan (thread_id tidak punya lamaran aktif, lebih dari 30 hari):
--
-- DELETE FROM checkpoints
-- WHERE thread_id NOT IN (SELECT id::text FROM applications)
-- AND created_at < NOW() - INTERVAL '30 days';
