"use client";

import { TextareaHTMLAttributes, useId } from "react";

interface TextareaProps
  extends Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, "id"> {
  label?: string;
  error?: string;
  helperText?: string;
  showCounter?: boolean;
}

export function Textarea({
  label,
  error,
  helperText,
  showCounter = false,
  rows = 4,
  maxLength,
  value,
  disabled,
  className = "",
  ...props
}: TextareaProps) {
  const id = useId();
  const current = typeof value === "string" ? value.length : 0;
  const describedBy = error
    ? `${id}-error`
    : helperText
      ? `${id}-helper`
      : undefined;

  return (
    <div className="flex flex-col gap-1">
      {label && (
        <label htmlFor={id} className="text-sm font-medium text-gray-700">
          {label}
        </label>
      )}
      <div className="relative">
        <textarea
          {...props}
          id={id}
          rows={rows}
          maxLength={maxLength}
          value={value}
          disabled={disabled}
          aria-invalid={!!error}
          aria-describedby={describedBy}
          className={[
            "w-full rounded-md border px-3 py-2 text-sm shadow-sm transition-colors resize-y",
            "placeholder:text-gray-400",
            "focus:outline-none focus:ring-2 focus:ring-offset-1",
            error
              ? "border-red-500 focus:ring-red-400"
              : "border-gray-300 focus:ring-blue-500 focus:border-blue-500",
            disabled ? "bg-gray-50 cursor-not-allowed opacity-60" : "bg-white",
            showCounter && maxLength ? "pb-6" : "",
            className,
          ].join(" ")}
        />
        {showCounter && maxLength !== undefined && (
          <span className="absolute bottom-2 right-3 text-xs text-gray-400 pointer-events-none">
            {current}/{maxLength}
          </span>
        )}
      </div>
      {error && (
        <p id={`${id}-error`} className="text-xs text-red-600">
          {error}
        </p>
      )}
      {!error && helperText && (
        <p id={`${id}-helper`} className="text-xs text-gray-500">
          {helperText}
        </p>
      )}
    </div>
  );
}
