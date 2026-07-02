export function Logo({ size = 40 }: { size?: number }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 48 48"
      fill="none"
      aria-hidden
    >
      <defs>
        <linearGradient id="lg" x1="0" y1="0" x2="48" y2="48">
          <stop offset="0" stopColor="#22B8CF" />
          <stop offset="1" stopColor="#FF7A3C" />
        </linearGradient>
      </defs>
      <circle cx="24" cy="24" r="22" stroke="url(#lg)" strokeWidth="2.5" />
      {/* vague */}
      <path
        d="M8 30c4 0 4-3 8-3s4 3 8 3 4-3 8-3 4 3 8 3"
        stroke="#22B8CF"
        strokeWidth="2.2"
        strokeLinecap="round"
      />
      {/* pinces / homard stylisé */}
      <path
        d="M18 20c-2-3-6-3-7-1M30 20c2-3 6-3 7-1"
        stroke="#FF7A3C"
        strokeWidth="2.2"
        strokeLinecap="round"
      />
      <circle cx="24" cy="18" r="3.2" fill="#FF7A3C" />
    </svg>
  );
}

export function Brand({ compact = false }: { compact?: boolean }) {
  return (
    <div className="flex items-center gap-3">
      <Logo size={compact ? 32 : 40} />
      <div className="leading-tight">
        <div className="font-display text-lg font-700 tracking-tight text-ecume">
          CAP HOMARD
        </div>
        {!compact && (
          <div className="text-xs font-medium uppercase tracking-[0.2em] text-lagon">
            Beach Volley · 974
          </div>
        )}
      </div>
    </div>
  );
}
