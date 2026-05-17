"use client";

import { useState, FormEvent } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Input } from "@/components/ui/Input";
import { Button } from "@/components/ui/Button";
import { useAuthContext } from "@/lib/context/AuthContext";
import { ApiError } from "@/lib/api";

export function LoginForm() {
  const { login } = useAuthContext();
  const router = useRouter();
  const searchParams = useSearchParams();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showResendVerification, setShowResendVerification] = useState(false);

  async function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    setShowResendVerification(false);

    try {
      await login(email, password);
      const returnUrl = searchParams.get("return_url") ?? "/dashboard";
      router.push(returnUrl);
    } catch (err) {
      if (err instanceof ApiError) {
        if (err.status === 403) {
          setShowResendVerification(true);
          setError("Email Anda belum diverifikasi. Cek kotak masuk atau kirim ulang email verifikasi.");
        } else if (err.status === 401) {
          setError("Email atau password tidak tepat.");
        } else {
          setError("Terjadi kesalahan. Silakan coba lagi.");
        }
      } else {
        setError("Terjadi kesalahan. Silakan coba lagi.");
      }
    } finally {
      setIsLoading(false);
    }
  }

  async function handleResendVerification() {
    // Placeholder — endpoint resend belum ada di API contract v1
    // Implementasikan saat endpoint tersedia
    alert("Fitur kirim ulang email verifikasi belum tersedia.");
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-5">
      <Input
        label="Email"
        type="email"
        placeholder="nama@email.com"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        disabled={isLoading}
        required
        autoComplete="email"
      />
      <Input
        label="Password"
        type="password"
        placeholder="Masukkan password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        disabled={isLoading}
        required
        autoComplete="current-password"
      />

      {error && (
        <div className="rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">
          <p>{error}</p>
          {showResendVerification && (
            <button
              type="button"
              onClick={handleResendVerification}
              className="mt-2 font-medium underline hover:no-underline focus:outline-none"
            >
              Kirim ulang email verifikasi
            </button>
          )}
        </div>
      )}

      <Button type="submit" isLoading={isLoading} disabled={isLoading} size="lg" className="w-full">
        Masuk
      </Button>
    </form>
  );
}
