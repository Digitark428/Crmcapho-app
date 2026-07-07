"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { formatEuro } from "@/lib/finance";

interface Props {
  slug: string;
  tarifParJoueur: number;
}

export function InscriptionForm({ slug, tarifParJoueur }: Props) {
  const [nomEquipe, setNomEquipe] = useState("");
  const [joueurs, setJoueurs] = useState<string[]>(["", "", "", ""]);
  const [loading, setLoading] = useState(false);
  const [erreur, setErreur] = useState<string | null>(null);
  const [succes, setSucces] = useState(false);

  const nbRemplis = joueurs.filter((j) => j.trim() !== "").length;
  const nomOk = nomEquipe.trim() !== "";
  const peutValider = nomOk && nbRemplis >= 4 && !loading;

  function setJoueur(i: number, v: string) {
    setJoueurs((prev) => prev.map((j, idx) => (idx === i ? v : j)));
  }
  function ajouterJoueur() {
    if (joueurs.length < 8) setJoueurs((prev) => [...prev, ""]);
  }
  function retirerJoueur(i: number) {
    if (joueurs.length > 4)
      setJoueurs((prev) => prev.filter((_, idx) => idx !== i));
  }

  async function handleSubmit() {
    setErreur(null);
    if (!peutValider) return;
    setLoading(true);
    const supabase = createClient();
    const { error } = await supabase.rpc("inscrire_equipe", {
      p_slug: slug,
      p_nom_equipe: nomEquipe.trim(),
      p_joueurs: joueurs.map((j) => j.trim()).filter(Boolean),
    });
    setLoading(false);
    if (error) {
      setErreur(error.message || "Une erreur est survenue. Réessayez.");
      return;
    }
    setSucces(true);
  }

  if (succes) {
    return (
      <div className="card p-8 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-full bg-paye/15 ring-1 ring-paye/40">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
            <path
              d="M5 13l4 4L19 7"
              stroke="#22C55E"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>
        <h2 className="font-display text-2xl font-700 text-ecume">
          Équipe inscrite !
        </h2>
        <p className="mt-2 text-brume">
          « {nomEquipe.trim()} » est bien enregistrée. Rendez-vous sur le sable 🏐
        </p>
        <p className="mt-4 text-sm text-brume/70">
          Pensez au règlement de {formatEuro(nbRemplis * tarifParJoueur)} (
          {nbRemplis} joueurs × {formatEuro(tarifParJoueur)}).
        </p>
      </div>
    );
  }

  return (
    <div className="card p-6 sm:p-8">
      <div className="mb-6">
        <label className="label" htmlFor="nom-equipe">
          Nom de l&apos;équipe <span className="text-corail">*</span>
        </label>
        <input
          id="nom-equipe"
          className="input"
          placeholder="Ex : Les Homards Déchaînés"
          value={nomEquipe}
          onChange={(e) => setNomEquipe(e.target.value)}
          maxLength={80}
        />
      </div>

      <div className="space-y-3">
        {joueurs.map((j, i) => {
          const obligatoire = i < 4;
          return (
            <div key={i}>
              <label className="label" htmlFor={`joueur-${i}`}>
                Joueur {i + 1}{" "}
                {obligatoire ? (
                  <span className="text-corail">*</span>
                ) : (
                  <span className="text-brume/50">(optionnel)</span>
                )}
              </label>
              <div className="flex gap-2">
                <input
                  id={`joueur-${i}`}
                  className="input"
                  placeholder={`Prénom Nom du joueur ${i + 1}`}
                  value={j}
                  onChange={(e) => setJoueur(i, e.target.value)}
                  maxLength={80}
                />
                {!obligatoire && (
                  <button
                    type="button"
                    onClick={() => retirerJoueur(i)}
                    className="btn-ghost px-3"
                    aria-label={`Retirer le joueur ${i + 1}`}
                  >
                    ✕
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {joueurs.length < 8 && (
        <button
          type="button"
          onClick={ajouterJoueur}
          className="btn-ghost mt-4 w-full"
        >
          + Ajouter un joueur ({joueurs.length}/8)
        </button>
      )}

      <div className="mt-6 flex items-center justify-between rounded-xl border border-bordure bg-abysse/50 px-4 py-3">
        <span className="text-sm text-brume">Montant de l&apos;inscription</span>
        <span className="font-display text-lg font-700 text-lagon">
          {formatEuro(nbRemplis * tarifParJoueur)}
        </span>
      </div>

      {erreur && (
        <p className="mt-4 rounded-xl bg-nonpaye/10 px-4 py-3 text-sm text-nonpaye ring-1 ring-nonpaye/30">
          {erreur}
        </p>
      )}

      <button
        onClick={handleSubmit}
        disabled={!peutValider}
        className="btn-accent mt-6 w-full py-3 text-base"
      >
        {loading ? "Envoi en cours…" : "Valider l'inscription"}
      </button>
      {!peutValider && !loading && (
        <p className="mt-3 text-center text-xs text-brume/60">
          {!nomOk
            ? "Renseignez le nom de l'équipe"
            : `Ajoutez au moins ${4 - nbRemplis} joueur${4 - nbRemplis > 1 ? "s" : ""} de plus`}
        </p>
      )}
    </div>
  );
}
