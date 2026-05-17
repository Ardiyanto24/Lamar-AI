# lamar.ai — Development Progress Tracker

> This file is auto-updated by Claude Code at the end of every session via the Stop hook.
> It can also be edited manually at any time — manual edits take precedence.
> Do NOT put architecture or design decisions here — those belong in docs/.
> This file tracks only: what is done, what is in progress, and what was decided during coding.
>
> **Team:**
> - **Backend:** Backend, AI pipeline, database — Railway + Supabase
> - **Frontend:** Frontend, UI, desain web — Vercel

---

## Current Focus

Auth pages selesai (`/login`, `/register`, auth layout, `LoginForm`, `RegisterForm`). Build production berhasil tanpa error TypeScript. Lanjut ke: `useTier` hook, lalu halaman `/dashboard`.

---

## Team Coordination Log

<!-- Sinyal antar Backend dan Frontend -->
<!-- Format: [date] Backend→Frontend atau Frontend→Backend — pesan -->

---

## Implementation Status

### Foundation

| Component | Status | Owner | Notes |
|---|---|---|---|
| Monorepo structure              | [x] Done | Backend+Frontend | Semua subdirektori + `__init__.py` / `.gitkeep` dibuat |
| Backend entry point (`main.py`) | [ ] Not started | Backend | CORS, rate limiter, Sentry, routers |
| `backend/config.py` (Settings)  | [ ] Not started | Backend | pydantic-settings, semua env var |
| `backend/requirements.txt`      | [x] Done | Backend | 18 dependency |
| Frontend entry point (Next.js)  | [x] Done | Frontend | `create-next-app` TypeScript + Tailwind + App Router; boilerplate dibersihkan; semua folder + placeholder page.tsx dibuat |
| Environment variables setup     | [x] Done | Backend+Frontend | `.env.example` lengkap 31 var, `.gitignore` dikonfigurasi |
| `backend/scripts/seed_dev_data.py` | [ ] Not started | Backend | Isi profil dummy + 1 lamaran sample untuk dev/test tanpa input manual |
| `backend/scripts/test_workflow.py` | [ ] Not started | Backend | CLI script full workflow end-to-end — verifikasi BE mandiri tanpa FE |

### Database Migrations

| File | Status | Owner | Notes |
|---|---|---|---|
| `001_initial_schema.sql` | [~] Written | Backend | users, 7 Master Data, applications, job_postings, job_requirements |
| `002_gap_analysis_schema.sql`   | [~] Written | Backend | gap_analysis_results, gap_analysis_scores |
| `003_strategy_schema.sql`       | [~] Written | Backend | cv_strategy_briefs, selected_content_packages, revision_history |
| `004_cv_output_schema.sql`        | [~] Written | Backend | cv_outputs, qc_results, qc_overall_scores |
| `005_tier_and_billing.sql`        | [~] Written | Backend | ALTER users (tier), upgrade_requests |
| `006_rls_policies.sql`        | [~] Written | Backend | RLS Pola A (10 tabel user_id) + Pola B (10 tabel via application_id) |
| `007_triggers.sql`        | [~] Written | Backend | handle_new_user(), on_auth_user_created |
| `008_indexes.sql`        | [~] Written | Backend | 22 index semua cluster + partial index workflow_active |
| `009_langgraph_checkpoint.sql`        | [~] Written | Backend | ⚠️ Wajib ada sebelum backend pertama kali dijalankan |
| `010_contact_and_qc.sql`        | [~] Written | Backend | ADD COLUMN IF NOT EXISTS — phone_number, linkedin_url, github_url, section_approvals, is_workflow_active |

> [WARNING] Only mark a migration as [x] Done after it has been successfully applied to the local Supabase instance.

### Backend — Infrastructure

| Component | Status | Owner | Notes |
|---|---|---|---|
| Supabase client (`db/supabase.py`) | [ ] Not started | Backend | |
| LangChain ChatModel factory (`models/llm.py`) | [ ] Not started | Backend | |
| Model router (`models/router.py`) | [ ] Not started | Backend | |
| LangGraph state schema (`workflow/state.py`) | [ ] Not started | Backend | |
| LangGraph graph definition (`workflow/graph.py`) | [ ] Not started | Backend | |
| JWT middleware (`middleware/auth.py`) | [ ] Not started | Backend | |
| Rate limit middleware (`middleware/rate_limit.py`) | [ ] Not started | Backend | |

### Backend — Routers

| Router | Status | Owner | Notes |
|---|---|---|---|
| `auth.py` | [ ] Not started | Backend | POST /register, POST /login, POST /logout, GET /me, POST /refresh |
| `profile.py` | [ ] Not started | Backend | 7 komponen CRUD + inferred-skills |
| `applications.py` | [ ] Not started | Backend | CRUD lamaran + tier check |
| `workflow.py` | [ ] Not started | Backend | start, resume, status, stream (SSE) |
| `output.py` | [ ] Not started | Backend | render, download — **Frontend tidak bisa mulai /download sebelum ini selesai** |
| `admin.py` | [ ] Not started | Backend | PATCH tier, GET/PATCH upgrade-requests |
| `settings.py` | [ ] Not started | Backend | PATCH /settings/profile, POST /settings/change-password |
| `upgrade.py` | [ ] Not started | Backend | POST /upgrade/request |

### Backend — Agents

| Agent | Cluster | Status | Prompt Written | Unit Test | Notes |
|---|---|---|---|---|---|
| `profile_ingestion.py` | C1 | [ ] Not started | [ ] | [ ] | |
| `parser.py` | C2 | [ ] Not started | [ ] | [ ] | |
| `gap_analyzer.py` | C3 | [ ] Not started | [ ] | [ ] | |
| `scoring.py` | C3 | [ ] Not started | [ ] | [ ] | |
| `planner.py` | C4 | [ ] Not started | [ ] | [ ] | |
| `selection.py` | C4 | [ ] Not started | [ ] | [ ] | |
| `revision_handler.py` | C4 | [ ] Not started | [ ] | [ ] | Pure Python — no LLM |
| `content_writer.py` | C5 | [ ] Not started | [ ] | [ ] | |
| `skills_grouping.py` | C5 | [ ] Not started | [ ] | [ ] | |
| `summary_writer.py` | C5 | [ ] Not started | [ ] | [ ] | Selalu dipanggil terakhir di Phase 2 |
| `ats_scoring.py` | C6 | [ ] Not started | [ ] | [ ] | |
| `semantic_reviewer.py` | C6 | [ ] Not started | [ ] | [ ] | Parallel dengan ATS |

### Backend — Renderer

| Component | Status | Owner | Notes |
|---|---|---|---|
| `document_renderer.py` | [ ] Not started | Backend | |
| `pdf_renderer.py` | [ ] Not started | Backend | WeasyPrint |
| `docx_renderer.py` | [ ] Not started | Backend | python-docx |
| CV template — Indonesian (`cv_id.html` + `cv_id.docx`) | [ ] Not started | Backend | Lihat `15_cv_template_specification.md` |
| CV template — English (`cv_en.html` + `cv_en.docx`) | [ ] Not started | Backend | |

### Frontend — UI Components (`components/ui/`)

| Component | Status | Notes |
|---|---|---|
| `Button.tsx` | [x] Done | variant: primary/secondary/destructive; size: sm/md/lg; isLoading spinner; disabled |
| `Input.tsx` | [x] Done | label, error (border merah), helperText, aria-invalid + aria-describedby |
| `Textarea.tsx` | [x] Done | Sama dengan Input + showCounter ({current}/{maxLength} pojok kanan bawah), rows, maxLength |
| `Card.tsx` | [x] Done | optional header (border-b) + footer (border-t) |
| `Badge.tsx` | [x] Done | variant: success/warning/error/neutral/info |
| `Modal.tsx` | [x] Done | overlay backdrop, tutup via klik overlay atau Escape, role="dialog" aria-modal |
| `index.ts` | [x] Done | Re-export semua 6 komponen |
| `Toast` | [ ] Not started | |
| `Skeleton` | [ ] Not started | |

### Frontend — Pages

| Page | Status | Owner | Notes |
|---|---|---|---|
| `/login` | [ ] Not started | Frontend | |
| `/register` | [ ] Not started | Frontend | |
| `/dashboard` | [ ] Not started | Frontend | |
| `/profile` | [ ] Not started | Frontend | |
| `/settings` | [ ] Not started | Frontend | Butuh `settings.py` router dari Backend |
| `/upgrade` | [ ] Not started | Frontend | Butuh `upgrade.py` router dari Backend |
| `/apply/new` | [ ] Not started | Frontend | |
| `/apply/[id]/gap` — Interrupt 1 | [ ] Not started | Frontend | Bisa dimulai setelah BE-4 checkpoint |
| `/apply/[id]/brief` — Interrupt 2 | [ ] Not started | Frontend | Bisa dimulai setelah BE-4 checkpoint |
| `/apply/[id]/cv` — Interrupt 3 | [ ] Not started | Frontend | Bisa dimulai setelah BE-4 checkpoint |
| `/apply/[id]/download` | [ ] Not started | Frontend | **Menunggu sinyal Backend: output.py + renderer selesai** |

### Frontend — Core

| Component | Status | Owner | Notes |
|---|---|---|---|
| API client (`lib/api.ts`) | [x] Done | Frontend | ApiError class, apiClient dengan interceptor 401 (refresh→retry→redirect) dan 403 TIER_LIMIT_REACHED (dispatch event), helper api.get/post/patch/delete |
| Supabase client (`lib/supabase.ts`) | [x] Done | Frontend | Singleton createBrowserClient via @supabase/ssr; env var NEXT_PUBLIC_SUPABASE_URL + ANON_KEY |
| `useAuth` hook | [x] Done | Frontend | `lib/hooks/useAuth.ts` — User interface, login/logout, GET /auth/me saat mount; 401 ditangani diam-diam |
| `AuthContext` | [x] Done | Frontend | `lib/context/AuthContext.tsx` — AuthProvider + useAuthContext; dipasang di `app/layout.tsx` |
| `useTier` hook | [ ] Not started | Frontend | |
| `useWorkflowStream` hook | [ ] Not started | Frontend | SSE hook untuk progress workflow |
| Route protection (`proxy.ts`) | [x] Done | Frontend | ⚠️ Next.js 16 breaking change: `middleware.ts` → `proxy.ts`, fungsi `middleware` → `proxy`; proteksi route via @supabase/ssr createServerClient; redirect ke /login?return_url=... jika no session |

---

## Open Technical Decisions

<!-- Decisions made during coding that are not yet in docs/ -->
<!-- Format: [date] topic — decision made — reason -->

---

## Known Issues & Gotchas

<!-- Bugs found, workarounds applied, things that behaved unexpectedly -->
<!-- Format: [date] file/component — what happened — how it was resolved or current status -->
[2026-05-17] Next.js 16 — `middleware.ts` deprecated, diganti `proxy.ts` dengan fungsi `proxy` (bukan `middleware`). File dibuat sebagai `frontend/proxy.ts`. Jika menggunakan nama lama, Next.js 16 akan mengabaikannya tanpa error.

---

## Session Log

<!-- Auto-appended by Stop hook at the end of each session -->
<!-- Format: [date] — summary of what was done -->
[2026-05-17 05:25] — Session with no file writes (planning, review, or Q&A).
[2026-05-17 05:26] — Session with no file writes (planning, review, or Q&A).
[2026-05-17 05:30] — Session with no file writes (planning, review, or Q&A).
[2026-05-17 05:31] — Session with no file writes (planning, review, or Q&A).
[2026-05-17 05:34] — Session with no file writes (planning, review, or Q&A).
[2026-05-17] — Wave 1 fondasi selesai: monorepo structure (31 files, `__init__.py` + `.gitkeep`), `.gitignore`, `.env.example` (31 var, 11 blok), `railway.toml`, `backend/requirements.txt` (18 dep), `.github/workflows/ci.yml` (3 jobs, TODO steps), git init + push ke GitHub (`Ardiyanto24/Lamar-AI`), branch `main` dan `develop` aktif di remote.
[2026-05-17] — Seluruh 10 file migration SQL ditulis di `backend/db/migrations/`: 001 (users + 7 Master Data + applications + job_postings + job_requirements), 002 (gap_analysis_results + gap_analysis_scores), 003 (cv_strategy_briefs + selected_content_packages + revision_history), 004 (cv_outputs + qc_results + qc_overall_scores), 005 (ALTER users tier + upgrade_requests), 006 (RLS Pola A & B — 20 tabel), 007 (trigger on_auth_user_created), 008 (22 index semua cluster), 009 (LangGraph checkpoint tables), 010 (ADD COLUMN IF NOT EXISTS — phone_number, linkedin_url, github_url, section_approvals, is_workflow_active). Belum dijalankan ke Supabase.
[2026-05-17] — Frontend foundation selesai: scaffold Next.js 14 (TypeScript + Tailwind + App Router) via create-next-app; boilerplate dibersihkan (page.tsx → redirect /dashboard, globals.css → hanya Tailwind import, SVG public/ dihapus); semua folder app/ + components/ + lib/hooks/ dibuat dengan placeholder page.tsx; install @supabase/supabase-js + @supabase/ssr; buat frontend/lib/supabase.ts (singleton createBrowserClient); buat frontend/lib/api.ts (ApiError, apiClient dengan interceptor 401/403, helper api.get/post/patch/delete); buat frontend/.env.local.example.
[2026-05-17] — Auth layer + UI dasar selesai: buat `lib/hooks/useAuth.ts` (User interface, login/logout, GET /auth/me on mount, 401 ditangani diam-diam); buat `lib/context/AuthContext.tsx` (AuthProvider + useAuthContext); pasang AuthProvider di `app/layout.tsx`; buat `proxy.ts` (Next.js 16: middleware.ts → proxy.ts, proteksi route via @supabase/ssr, redirect /login?return_url=... jika no session); buat 6 komponen `components/ui/` (Button, Input, Textarea, Card, Badge, Modal) + index.ts barrel export.