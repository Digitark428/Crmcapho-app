import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { CreateTournoi } from "@/components/CreateTournoi";
import { LIBELLE_TYPE, type TypeTournoi } from "@/lib/types";
import { formatEuro } from "@/lib/finance";

export const dynamic = "force-dynamic";

export default async function AdminHome() {
  const supabase = createClient();
  const { data: tournois } = await supabase
    .from("tournois")
    .select(
      "id, nom, slug, type, date_tournoi, tarif_par_joueur, statut, equipes(id, joueurs(id, paye))"
    )
    .eq("is_historique", false)
    .order("created_at", { ascending: false });

  const liste = (tournois ?? []) as any[];

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-700 text-ecume">
            Tournois en cours
          </h1>
          <p className="text-sm text-brume">
            {liste.length} tournoi{liste.length > 1 ? "s" : ""} actif
            {liste.length > 1 ? "s" : ""}
          </p>
        </div>
        <CreateTournoi />
      </div>

      {liste.length === 0 ? (
        <div className="card p-10 text-center">
          <p className="text-brume">
            Aucun tournoi pour l&apos;instant. Créez votre premier tournoi pour
            générer son lien d&apos;inscription.
          </p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {liste.map((t) => {
            const nbEquipes = t.equipes?.length ?? 0;
            const nbJoueurs =
              t.equipes?.reduce(
                (a: number, e: any) => a + (e.joueurs?.length ?? 0),
                0
              ) ?? 0;
            const nbPayes =
              t.equipes?.reduce(
                (a: number, e: any) =>
                  a + (e.joueurs?.filter((j: any) => j.paye).length ?? 0),
                0
              ) ?? 0;
            const encaisse = nbPayes * Number(t.tarif_par_joueur);
            return (
              <Link
                key={t.id}
                href={`/admin/tournoi/${t.id}`}
                className="card group p-5 transition hover:border-lagon/50 hover:shadow-lueur"
              >
                <div className="mb-3 flex items-center justify-between">
                  <span className="chip bg-lagon/15 text-lagon ring-1 ring-lagon/30">
                    {LIBELLE_TYPE[t.type as TypeTournoi]}
                  </span>
                  <span
                    className={`chip ${
                      t.statut === "ouvert"
                        ? "bg-paye/15 text-paye"
                        : "bg-brume/15 text-brume"
                    }`}
                  >
                    {t.statut === "ouvert" ? "Ouvert" : "Clôturé"}
                  </span>
                </div>
                <h2 className="font-display text-lg font-600 leading-tight text-ecume group-hover:text-lagonClair">
                  {t.nom}
                </h2>
                {t.date_tournoi && (
                  <p className="mt-1 text-sm capitalize text-brume">
                    {new Date(t.date_tournoi).toLocaleDateString("fr-FR", {
                      day: "numeric",
                      month: "long",
                      year: "numeric",
                    })}
                  </p>
                )}
                <div className="mt-4 grid grid-cols-3 gap-2 border-t border-bordure pt-4 text-center">
                  <Stat v={nbEquipes} l="Équipes" />
                  <Stat v={nbJoueurs} l="Joueurs" />
                  <Stat v={formatEuro(encaisse)} l="Encaissé" />
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}

function Stat({ v, l }: { v: string | number; l: string }) {
  return (
    <div>
      <div className="font-display text-base font-700 text-ecume">{v}</div>
      <div className="text-[11px] uppercase tracking-wide text-brume">{l}</div>
    </div>
  );
}
