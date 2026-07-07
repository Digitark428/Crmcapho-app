import { LIBELLE_STATUT, type StatutPaiement } from "@/lib/finance";

const STYLES: Record<StatutPaiement, string> = {
  non_paye: "bg-nonpaye/15 text-nonpaye ring-1 ring-nonpaye/40",
  partiel: "bg-partiel/15 text-partiel ring-1 ring-partiel/40",
  paye: "bg-paye/15 text-paye ring-1 ring-paye/40",
};

export function StatutBadge({ statut }: { statut: StatutPaiement }) {
  return (
    <span className={`chip ${STYLES[statut]}`}>
      <span
        className="inline-block h-1.5 w-1.5 rounded-full"
        style={{
          background:
            statut === "paye"
              ? "#22C55E"
              : statut === "partiel"
                ? "#F59E0B"
                : "#EF4444",
        }}
      />
      {LIBELLE_STATUT[statut]}
    </span>
  );
}
