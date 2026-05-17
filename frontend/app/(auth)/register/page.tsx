import Link from "next/link";
import { RegisterForm } from "@/components/auth/RegisterForm";

export const metadata = {
  title: "Daftar — lamar.ai",
};

export default function RegisterPage() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-gray-50 px-4">
      <div className="mb-8 text-center">
        <h1 className="text-3xl font-bold text-blue-600">lamar.ai</h1>
        <p className="mt-1 text-sm text-gray-500">CV yang dipersonalisasi untuk setiap lamaran</p>
      </div>

      <div className="w-full max-w-sm rounded-xl bg-white shadow-sm border border-gray-200 px-8 py-8">
        <h2 className="mb-6 text-xl font-semibold text-gray-800">Buat akun baru</h2>
        <RegisterForm />
      </div>

      <p className="mt-6 text-sm text-gray-500">
        Sudah punya akun?{" "}
        <Link href="/login" className="font-medium text-blue-600 hover:underline">
          Masuk di sini
        </Link>
      </p>
    </main>
  );
}
