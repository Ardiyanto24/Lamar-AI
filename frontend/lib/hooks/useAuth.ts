"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { api, ApiError } from "@/lib/api";

export interface User {
  id: string;
  name: string;
  email: string;
  tier: "free" | "pro";
  avatar_url?: string | null;
  phone_number?: string | null;
  linkedin_url?: string | null;
  github_url?: string | null;
}

interface LoginResponse {
  user: User;
}

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    api
      .get<User>("/auth/me")
      .then(setUser)
      .catch((err) => {
        if (err instanceof ApiError && err.status === 401) {
          setUser(null);
        }
      })
      .finally(() => setIsLoading(false));
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    const data = await api.post<LoginResponse>("/auth/login", { email, password });
    setUser(data.user);
  }, []);

  const logout = useCallback(async () => {
    await api.post("/auth/logout");
    setUser(null);
    router.push("/login");
  }, [router]);

  return { user, isLoading, login, logout };
}
