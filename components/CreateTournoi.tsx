"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { slugify } from "@/lib/slug";
import { LIBELLE_TYPE, type TypeTournoi } from "@/lib/types";

const TYPES: TypeTournoi[] = ["4x4", "3x3", "mixte", "beach_camp", "autre"];

export function CreateTournoi() {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [nom, setNom] = useState("");
  const [slug, setSlug] = useState("");
  const [slugTouche, setSlugTouche] = useState(false);
  const [type, setType] = useState<TypeTournoi>("4x4");
  const [date, setDate] = useState("");
  const [tarif, setTarif] = useState("10");
  const [loading, setLoading] = useState(false);
  const [erreur, setErreur] = useState<string | null>(null);

  const slugFinal = slugTouche ? slug : slugify(nom);

  async function creer() {
    setErreur(null);
    if (!nom.trim() || !slugFinal) {
      setErreur("Le nom du tournoi est obligatoire.");
      return;
    }
    setLoading(true);
    const supabase = createClient();
    const { data, error } = await supabase
      .from("tournois")
      .insert({
        nom: nom.trim(),
        slug: slugFinal,
        type,
        date_tournoi: date || null,
        tarif_par_joueur: Number(tarif) || 10,
        statut: "ouvert",
        is_historique: false,
      })
      .select("id")
      .single();

    if (error || !data) {
      setLoading(false);
      setErreur(
        error?.code === "23505"
          ? "Ce lien (slug) est déjà utilisé, choisissez-en un autre."
          : error?.message ?? "Erreur lors de la création."
      );
      return;
    }

    // Pré-remplir les frais association par défaut
    await supabase.from("frais_association").insert([
      {
        tournoi_id: data.id,
        description: "Assurance camion",
        montant: 0,
        fonction: "Transport / stockage du matériel",
        position: 1,
      },
      {
        tournoi_id: data.id,
        description: "Assurance responsabilité civile",
        montant: 0,
        fonction: "Protection des participants",
        position: 2,
      },
    ]);

    setLoading(false);
    setOpen(false);
    router.push(`/admin/tournoi/${data.id}`);
    router.refresh();
  }

  return (
    <>
      <button className="btn-accent" onClick={() => setOpen(true)}>
        + Nouveau tournoi
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-end justify-center bg-black/60 p-0 sm:items-center sm:p-6"
          onClick={() => setOpen(false)}
        >
          <div
            className="card w-full max-w-lg p-6 sm:rounded-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="mb-5 font-display text-xl font-700 text-ecume">
              Nouveau tournoi
            </h2>
            <div className="space-y-4">
              <div>
                <label className="label">Nom du tournoi</label>
                <input
                  className="input"
                  placeholder="Ex : Fourman du 19 juillet"
                  value={nom}
                  onChange={(e) => setNom(e.target.value)}
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="label">Format</label>
                  <select
                    className="input"
                    value={type}
                    onChange={(e) => setType(e.target.value as TypeTournoi)}
                  >
                    {TYPES.map((t) => (
                      <option key={t} value={t}>
                        {LIBELLE_TYPE[t]}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="label">Date</label>
                  <input
                    type="date"
                    className="input"
                    value={date}
                    onChange={(e) => setDate(e.target.value)}
                  />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="label">Tarif / joueur (€)</label>
                  <input
                    type="number"
                    min="0"
                    step="0.5"
                    className="input"
                    value={tarif}
                    onChange={(e) => setTarif(e.target.value)}
                  />
                </div>
                <div>
                  <label className="label">Lien d&apos;inscription</label>
                  <input
                    className="input"
                    value={slugFinal}
                    onChange={(e) => {
                      setSlugTouche(true);
                      setSlug(slugify(e.target.value));
                    }}
                  />
                </div>
              </div>
              <p className="text-xs text-brume/70">
                URL publique : <span className="text-lagon">/tournoi/{slugFinal || "…"}</span>
              </p>
              {erreur && (
                <p className="rounded-xl bg-nonpaye/10 px-4 py-2.5 text-sm text-nonpaye ring-1 ring-nonpaye/30">
                  {erreur}
                </p>
              )}
            </div>
            <div className="mt-6 flex gap-3">
              <button className="btn-ghost flex-1" onClick={() => setOpen(false)}>
                Annuler
              </button>
              <button
                className="btn-primary flex-1"
                onClick={creer}
                disabled={loading}
              >
                {loading ? "Création…" : "Créer le tournoi"}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
