import { ReactNode } from "react";

interface CardProps {
  children: ReactNode;
  className?: string;
  header?: ReactNode;
  footer?: ReactNode;
}

export function Card({ children, className = "", header, footer }: CardProps) {
  return (
    <div
      className={[
        "rounded-lg border border-gray-200 bg-white shadow-sm",
        className,
      ].join(" ")}
    >
      {header && (
        <div className="border-b border-gray-200 px-4 py-3">{header}</div>
      )}
      <div className="px-4 py-4">{children}</div>
      {footer && (
        <div className="border-t border-gray-200 px-4 py-3">{footer}</div>
      )}
    </div>
  );
}
