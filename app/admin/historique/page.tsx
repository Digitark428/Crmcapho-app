import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { LIBELLE_TYPE, type TypeTournoi } from "@/lib/types";
import { calculerFinances, formatEuro } from "@/lib/finance";

export const dynamic = "force-dynamic";

export default async function HistoriquePage() {
  const supabase = createClient();
  const { data } = await supabase
    .from("tournois")
    .select(
      "id, nom, type, date_tournoi, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle, equipes(id), achats_divers(montant), frais_association(montant)"
    )
    .eq("is_historique", true)
    .order("date_tournoi", { ascending: true, nullsFirst: true });

  const liste = (data ?? []) as any[];

  const total = liste.reduce((acc, t) => {
    const f = calculerFinances({
      rentreeInscriptions: Number(t.rentree_inscriptions_manuelle ?? 0),
      rentreeBuvette: Number(t.rentree_buvette),
      depenseBuvette: Number(t.depense_buvette),
      achatsDivers: (t.achats_divers ?? []).map((a: any) => ({ description: "", montant: a.montant })),
      fraisAssociation: (t.frais_association ?? []).map((a: any) => ({ description: "", montant: a.montant })),
    });
    return acc + f.beneficeNet;
  }, 0);

  return (
    <div>
      <div className="mb-6 flex items-end justify-between">
        <div>
          <h1 className="font-display text-2xl font-700 text-ecume">
            Historique des tournois
          </h1>
          <p className="text-sm text-brume">
            {liste.length} tournois archivés depuis le fichier de l&apos;association
          </p>
        </div>
        <div className="card px-5 py-3 text-right">
          <div className="text-[11px] uppercase tracking-wide text-brume">
            Bénéfice cumulé
          </div>
          <div
            className={`font-display text-xl font-700 ${
              total >= 0 ? "text-paye" : "text-nonpaye"
            }`}
          >
            {formatEuro(total)}
          </div>
        </div>
      </div>

      <div className="overflow-hidden rounded-2xl border border-bordure">
        <table className="w-full text-sm">
          <thead className="bg-recif/60 text-left text-xs uppercase tracking-wide text-brume">
            <tr>
              <th className="px-4 py-3">Tournoi</th>
              <th className="px-4 py-3">Format</th>
              <th className="hidden px-4 py-3 sm:table-cell">Date</th>
              <th className="px-4 py-3 text-center">Équipes</th>
              <th className="px-4 py-3 text-right">Bénéfice</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-bordure">
            {liste.map((t) => {
              const f = calculerFinances({
                rentreeInscriptions: Number(t.rentree_inscriptions_manuelle ?? 0),
                rentreeBuvette: Number(t.rentree_buvette),
                depenseBuvette: Number(t.depense_buvette),
                achatsDivers: (t.achats_divers ?? []).map((a: any) => ({ description: "", montant: a.montant })),
                fraisAssociation: (t.frais_association ?? []).map((a: any) => ({ description: "", montant: a.montant })),
              });
              return (
                <tr key={t.id} className="bg-recif/30 transition hover:bg-recif2/40">
                  <td className="px-4 py-3">
                    <Link
                      href={`/admin/historique/${t.id}`}
                      className="font-600 text-ecume hover:text-lagon"
                    >
                      {t.nom}
                    </Link>
                  </td>
                  <td className="px-4 py-3 text-brume">
                    {LIBELLE_TYPE[t.type as TypeTournoi]}
                  </td>
                  <td className="hidden px-4 py-3 text-brume sm:table-cell">
                    {t.date_tournoi
                      ? new Date(t.date_tournoi).toLocaleDateString("fr-FR")
                      : "—"}
                  </td>
                  <td className="px-4 py-3 text-center text-brume">
                    {t.equipes?.length ?? 0}
                  </td>
                  <td
                    className={`px-4 py-3 text-right font-600 ${
                      f.beneficeNet >= 0 ? "text-paye" : "text-nonpaye"
                    }`}
                  >
                    {formatEuro(f.beneficeNet)}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
