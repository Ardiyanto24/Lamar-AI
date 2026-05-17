const BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

export class ApiError extends Error {
  status: number;
  code: string;

  constructor(status: number, code: string, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
  }
}

async function parseErrorBody(res: Response): Promise<{ code: string; message: string }> {
  try {
    const body = await res.json();
    const err = body?.error ?? body;
    return {
      code: err?.code ?? "UNKNOWN_ERROR",
      message: err?.message ?? res.statusText,
    };
  } catch {
    return { code: "UNKNOWN_ERROR", message: res.statusText };
  }
}

async function apiClient<T>(path: string, options: RequestInit = {}): Promise<T> {
  const url = `${BASE_URL}${path}`;

  const headers = new Headers(options.headers);
  if (!headers.has("Content-Type") && !(options.body instanceof FormData)) {
    headers.set("Content-Type", "application/json");
  }

  const res = await fetch(url, {
    ...options,
    headers,
    credentials: "include",
  });

  if (res.ok) {
    if (res.status === 204) return undefined as T;
    return res.json() as Promise<T>;
  }

  // 401 — try refresh then retry once
  if (res.status === 401) {
    const refreshRes = await fetch(`${BASE_URL}/auth/refresh`, {
      method: "POST",
      credentials: "include",
    });

    if (refreshRes.ok) {
      const retryRes = await fetch(url, {
        ...options,
        headers,
        credentials: "include",
      });

      if (retryRes.ok) {
        if (retryRes.status === 204) return undefined as T;
        return retryRes.json() as Promise<T>;
      }

      const { code, message } = await parseErrorBody(retryRes);
      throw new ApiError(retryRes.status, code, message);
    }

    // Refresh failed — redirect to login
    if (typeof window !== "undefined") {
      const returnUrl = encodeURIComponent(window.location.pathname + window.location.search);
      window.location.href = `/login?return_url=${returnUrl}`;
    }

    const { code, message } = await parseErrorBody(res);
    throw new ApiError(res.status, code, message);
  }

  const { code, message } = await parseErrorBody(res);

  // 403 TIER_LIMIT_REACHED — dispatch event for modal, still throw
  if (res.status === 403 && code === "TIER_LIMIT_REACHED") {
    if (typeof window !== "undefined") {
      window.dispatchEvent(new CustomEvent("tier-limit-reached"));
    }
  }

  throw new ApiError(res.status, code, message);
}

export const api = {
  get<T>(path: string, options?: RequestInit): Promise<T> {
    return apiClient<T>(path, { ...options, method: "GET" });
  },
  post<T>(path: string, body?: unknown, options?: RequestInit): Promise<T> {
    return apiClient<T>(path, {
      ...options,
      method: "POST",
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  },
  patch<T>(path: string, body?: unknown, options?: RequestInit): Promise<T> {
    return apiClient<T>(path, {
      ...options,
      method: "PATCH",
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  },
  delete<T>(path: string, options?: RequestInit): Promise<T> {
    return apiClient<T>(path, { ...options, method: "DELETE" });
  },
};
