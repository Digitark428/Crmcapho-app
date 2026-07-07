import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { LIBELLE_TYPE, type TypeTournoi } from "@/lib/types";
import { calculerFinances, formatEuro } from "@/lib/finance";

export const dynamic = "force-dynamic";

export default async function HistoriqueDetail({
  params,
}: {
  params: { id: string };
}) {
  const supabase = createClient();
  const { data: t } = await supabase
    .from("tournois")
    .select("*")
    .eq("id", params.id)
    .maybeSingle();
  if (!t) notFound();

  const [{ data: equipes }, { data: achats }, { data: frais }] =
    await Promise.all([
      supabase.from("equipes").select("*").eq("tournoi_id", params.id).order("nom"),
      supabase.from("achats_divers").select("*").eq("tournoi_id", params.id).order("position"),
      supabase.from("frais_association").select("*").eq("tournoi_id", params.id).order("position"),
    ]);

  const f = calculerFinances({
    rentreeInscriptions: Number(t.rentree_inscriptions_manuelle ?? 0),
    rentreeBuvette: Number(t.rentree_buvette),
    depenseBuvette: Number(t.depense_buvette),
    achatsDivers: (achats ?? []).map((a: any) => ({ description: a.description, montant: a.montant })),
    fraisAssociation: (frais ?? []).map((a: any) => ({ description: a.description, montant: a.montant })),
  });

  return (
    <div className="print-area">
      <Link href="/admin/historique" className="no-print mb-4 inline-block text-sm text-brume hover:text-ecume">
        ← Retour à l&apos;historique
      </Link>

      <div className="mb-6 flex items-start justify-between">
        <div>
          <span className="chip mb-2 bg-lagon/15 text-lagon ring-1 ring-lagon/30">
            {LIBELLE_TYPE[t.type as TypeTournoi]} · Archivé
          </span>
          <h1 className="font-display text-2xl font-700 text-ecume">{t.nom}</h1>
        </div>
      </div>

      <div className="grid gap-5 lg:grid-cols-2">
        {/* Bilan financier */}
        <div className="card p-5">
          <h2 className="mb-4 font-display text-lg font-600 text-ecume">Bilan financier</h2>
          <Row label="Rentrée inscriptions" value={formatEuro(f.rentreeInscriptions)} />
          <Row label="Rentrée buvette" value={formatEuro(f.rentreeBuvette)} />
          <Row label="Total recettes" value={formatEuro(f.totalRecettes)} accent="paye" bold />
          <div className="my-3 border-t border-bordure" />
          <Row label="Dépense buvette" value={formatEuro(f.depenseBuvette)} />
          <Row label="Total achats divers" value={formatEuro(f.totalAchatsDivers)} />
          <Row label="Total frais association" value={formatEuro(f.totalFraisAssociation)} />
          <Row label="Total dépenses" value={formatEuro(f.totalDepenses)} accent="nonpaye" bold />
          <div className="my-3 border-t border-bordure" />
          <Row
            label="Bénéfice net"
            value={formatEuro(f.beneficeNet)}
            accent={f.beneficeNet >= 0 ? "paye" : "nonpaye"}
            bold
            big
          />
        </div>

        {/* Détail dépenses */}
        <div className="space-y-5">
          <DetailListe titre="Achats divers" lignes={achats ?? []} />
          <DetailListe titre="Frais association" lignes={frais ?? []} avecFonction />
        </div>
      </div>

      {/* Équipes */}
      <div className="card mt-5 p-5">
        <h2 className="mb-3 font-display text-lg font-600 text-ecume">
          Équipes ({equipes?.length ?? 0})
        </h2>
        <div className="grid gap-1.5 sm:grid-cols-2 lg:grid-cols-3">
          {(equipes ?? []).map((e: any) => (
            <div
              key={e.id}
              className="flex items-center justify-between rounded-lg border border-bordure bg-abysse/40 px-3 py-2 text-sm"
            >
              <span className="truncate text-ecume">{e.nom}</span>
              {e.montant_historique != null && (
                <span className="ml-2 shrink-0 text-brume">
                  {formatEuro(Number(e.montant_historique))}
                </span>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function Row({
  label,
  value,
  accent,
  bold,
  big,
}: {
  label: string;
  value: string;
  accent?: "paye" | "nonpaye";
  bold?: boolean;
  big?: boolean;
}) {
  const color =
    accent === "paye" ? "text-paye" : accent === "nonpaye" ? "text-nonpaye" : "text-ecume";
  return (
    <div className="flex items-center justify-between py-1">
      <span className={bold ? "font-semibold text-ecume" : "text-brume"}>{label}</span>
      <span className={`font-display ${big ? "text-2xl" : ""} ${bold ? "font-700" : "font-600"} ${color}`}>
        {value}
      </span>
    </div>
  );
}

function DetailListe({
  titre,
  lignes,
  avecFonction,
}: {
  titre: string;
  lignes: any[];
  avecFonction?: boolean;
}) {
  return (
    <div className="card p-5">
      <h3 className="mb-3 text-sm font-semibold uppercase tracking-wide text-brume">
        {titre}
      </h3>
      {lignes.length === 0 ? (
        <p className="text-sm text-brume/60">Aucune ligne.</p>
      ) : (
        <div className="space-y-1.5 text-sm">
          {lignes.map((l) => (
            <div key={l.id} className="flex items-center justify-between gap-2">
              <div className="min-w-0">
                <div className="truncate text-ecume">{l.description || "—"}</div>
                {avecFonction && l.fonction && (
                  <div className="truncate text-xs text-brume/60">{l.fonction}</div>
                )}
              </div>
              <span className="shrink-0 text-brume">
                {formatEuro(Number(l.montant))}
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
