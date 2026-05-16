-- Migration 007: Triggers
-- Membuat trigger yang otomatis membuat record di public.users
-- setiap kali user baru register via Supabase Auth.
--
-- Trigger ini KRITIS — tanpa ini, user yang berhasil register
-- tidak akan punya record di public.users dan tidak bisa menggunakan sistem.

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, name, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
        NEW.email
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- DROP dulu jika sudah ada agar idempoten saat dijalankan ulang
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();
