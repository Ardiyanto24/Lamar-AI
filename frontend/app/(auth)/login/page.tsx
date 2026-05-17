import Link from "next/link";
import { Suspense } from "react";
import { LoginForm } from "@/components/auth/LoginForm";

export const metadata = {
  title: "Masuk — lamar.ai",
};

export default function LoginPage() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-gray-50 px-4">
      <div className="mb-8 text-center">
        <h1 className="text-3xl font-bold text-blue-600">lamar.ai</h1>
        <p className="mt-1 text-sm text-gray-500">CV yang dipersonalisasi untuk setiap lamaran</p>
      </div>

      <div className="w-full max-w-sm rounded-xl bg-white shadow-sm border border-gray-200 px-8 py-8">
        <h2 className="mb-6 text-xl font-semibold text-gray-800">Masuk ke akun Anda</h2>
        <Suspense>
          <LoginForm />
        </Suspense>
      </div>

      <p className="mt-6 text-sm text-gray-500">
        Belum punya akun?{" "}
        <Link href="/register" className="font-medium text-blue-600 hover:underline">
          Daftar sekarang
        </Link>
      </p>
    </main>
  );
}
