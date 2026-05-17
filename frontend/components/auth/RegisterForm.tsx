"use client";

import { useState, FormEvent } from "react";
import { Input } from "@/components/ui/Input";
import { Button } from "@/components/ui/Button";
import { api, ApiError } from "@/lib/api";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

interface FieldErrors {
  name?: string;
  email?: string;
  password?: string;
}

export function RegisterForm() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [fieldErrors, setFieldErrors] = useState<FieldErrors>({});
  const [isSuccess, setIsSuccess] = useState(false);
  const [registeredEmail, setRegisteredEmail] = useState("");

  function validate(): FieldErrors {
    const errs: FieldErrors = {};
    if (!name.trim()) errs.name = "Nama wajib diisi.";
    if (!email.trim()) {
      errs.email = "Email wajib diisi.";
    } else if (!EMAIL_REGEX.test(email)) {
      errs.email = "Format email tidak valid.";
    }
    if (!password) {
      errs.password = "Password wajib diisi.";
    } else if (password.length < 8) {
      errs.password = "Password minimal 8 karakter.";
    }
    return errs;
  }

  async function handleSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError(null);

    const errs = validate();
    if (Object.keys(errs).length > 0) {
      setFieldErrors(errs);
      return;
    }
    setFieldErrors({});
    setIsLoading(true);

    try {
      await api.post("/auth/register", { name: name.trim(), email: email.trim(), password });
      setRegisteredEmail(email.trim());
      setIsSuccess(true);
    } catch (err) {
      if (err instanceof ApiError) {
        if (err.status === 422) {
          setFieldErrors({ email: "Email ini sudah terdaftar." });
        } else if (err.status === 400) {
          setError("Data tidak lengkap atau tidak valid. Periksa kembali isian Anda.");
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

  if (isSuccess) {
    return (
      <div className="rounded-md bg-green-50 border border-green-200 px-4 py-5 text-sm text-green-800">
        <p className="font-semibold mb-1">Pendaftaran berhasil!</p>
        <p>
          Email verifikasi sudah dikirim ke{" "}
          <span className="font-medium">{registeredEmail}</span>. Cek inbox (dan
          folder spam) lalu klik link verifikasinya.
        </p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-5" noValidate>
      <Input
        label="Nama lengkap"
        type="text"
        placeholder="Nama Anda"
        value={name}
        onChange={(e) => setName(e.target.value)}
        disabled={isLoading}
        error={fieldErrors.name}
        autoComplete="name"
      />
      <Input
        label="Email"
        type="email"
        placeholder="nama@email.com"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        disabled={isLoading}
        error={fieldErrors.email}
        autoComplete="email"
      />
      <Input
        label="Password"
        type="password"
        placeholder="Minimal 8 karakter"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        disabled={isLoading}
        error={fieldErrors.password}
        autoComplete="new-password"
      />

      {error && (
        <div className="rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">
          {error}
        </div>
      )}

      <Button type="submit" isLoading={isLoading} disabled={isLoading} size="lg" className="w-full">
        Daftar
      </Button>
    </form>
  );
}
