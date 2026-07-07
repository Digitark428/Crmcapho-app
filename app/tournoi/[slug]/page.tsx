import { createClient } from "@/lib/supabase/server";
import { InscriptionForm } from "@/components/InscriptionForm";
import { Brand } from "@/components/Brand";
import { LIBELLE_TYPE, type TypeTournoi } from "@/lib/types";

export const dynamic = "force-dynamic";

export default async function PageInscription({
  params,
}: {
  params: { slug: string };
}) {
  const supabase = createClient();
  const { data } = await supabase
    .rpc("tournoi_public", { p_slug: params.slug })
    .maybeSingle();

  const tournoi = data as
    | {
        id: string;
        nom: string;
        type: TypeTournoi;
        date_tournoi: string | null;
        tarif_par_joueur: number;
        statut: string;
        is_historique: boolean;
      }
    | null;

  if (!tournoi) {
    return (
      <Enveloppe>
        <div className="card p-8 text-center">
          <h1 className="font-display text-2xl font-700">Tournoi introuvable</h1>
          <p className="mt-2 text-brume">
            Ce lien d&apos;inscription n&apos;existe pas ou a expiré.
          </p>
        </div>
      </Enveloppe>
    );
  }

  const ferme = tournoi.statut !== "ouvert" || tournoi.is_historique;
  const dateFmt = tournoi.date_tournoi
    ? new Date(tournoi.date_tournoi).toLocaleDateString("fr-FR", {
        weekday: "long",
        day: "numeric",
        month: "long",
        year: "numeric",
      })
    : null;

  return (
    <Enveloppe>
      <div className="mb-6 text-center">
        <p className="mb-2 text-xs font-semibold uppercase tracking-[0.25em] text-lagon">
          {LIBELLE_TYPE[tournoi.type] ?? "Tournoi"} · Inscription
        </p>
        <h1 className="font-display text-3xl font-700 leading-tight text-ecume">
          {tournoi.nom}
        </h1>
        {dateFmt && <p className="mt-2 capitalize text-brume">{dateFmt}</p>}
      </div>

      {ferme ? (
        <div className="card p-8 text-center">
          <h2 className="font-display text-xl font-700 text-corail">
            Inscriptions fermées
          </h2>
          <p className="mt-2 text-brume">
            Les inscriptions pour ce tournoi ne sont plus ouvertes.
          </p>
        </div>
      ) : (
        <InscriptionForm
          slug={params.slug}
          tarifParJoueur={Number(tournoi.tarif_par_joueur)}
        />
      )}
    </Enveloppe>
  );
}

function Enveloppe({ children }: { children: React.ReactNode }) {
  return (
    <main className="mx-auto min-h-screen max-w-lg px-4 py-10">
      <div className="mb-8 flex justify-center">
        <Brand />
      </div>
      {children}
      <footer className="mt-10 text-center text-xs text-brume/50">
        CAP HOMARD BEACH VOLLEY 974
      </footer>
    </main>
  );
}
