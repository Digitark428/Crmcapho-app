"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { slugify } from "@/lib/slug";
import { exporterExcel } from "@/lib/export";
import { StatutBadge } from "@/components/StatutBadge";
import {
  calculerFinances,
  formatEuro,
  montantDu,
  montantPaye,
  montantRestant,
  rentreeInscriptionsAuto,
  statsTournoi,
  statutEquipe,
  type Equipe,
} from "@/lib/finance";
import { LIBELLE_TYPE, type EquipeRow, type LigneFinance, type Tournoi } from "@/lib/types";

type Tab = "apercu" | "equipes" | "finances";

interface Props {
  tournoi: Tournoi;
  equipesInit: EquipeRow[];
  achatsInit: LigneFinance[];
  fraisInit: LigneFinance[];
  baseUrl: string;
}

export function TournoiDashboard({
  tournoi: tournoiInit,
  equipesInit,
  achatsInit,
  fraisInit,
  baseUrl,
}: Props) {
  const router = useRouter();
  const supabase = createClient();

  const [tab, setTab] = useState<Tab>("apercu");
  const [tournoi, setTournoi] = useState(tournoiInit);
  const [equipes, setEquipes] = useState<EquipeRow[]>(equipesInit);
  const [achats, setAchats] = useState<LigneFinance[]>(achatsInit);
  const [frais, setFrais] = useState<LigneFinance[]>(fraisInit);

  const tarif = Number(tournoi.tarif_par_joueur);

  // Adaptateur EquipeRow -> Equipe (type finance)
  const equipesCalc: Equipe[] = useMemo(
    () =>
      equipes.map((e) => ({
        id: e.id,
        nom: e.nom,
        joueurs: (e.joueurs ?? []).map((j) => ({ nom: j.nom, paye: j.paye })),
      })),
    [equipes]
  );

  const stats = useMemo(
    () => statsTournoi(equipesCalc, tarif),
    [equipesCalc, tarif]
  );

  const rentreeInscriptions = rentreeInscriptionsAuto(equipesCalc, tarif);
  const finances = useMemo(
    () =>
      calculerFinances({
        rentreeInscriptions,
        rentreeBuvette: Number(tournoi.rentree_buvette),
        depenseBuvette: Number(tournoi.depense_buvette),
        achatsDivers: achats.map((a) => ({ description: a.description, montant: a.montant })),
        fraisAssociation: frais.map((f) => ({ description: f.description, montant: f.montant })),
      }),
    [rentreeInscriptions, tournoi.rentree_buvette, tournoi.depense_buvette, achats, frais]
  );

  /* ---------------- Mutations ---------------- */

  async function toggleJoueur(equipeId: string, joueurId: string, paye: boolean) {
    setEquipes((prev) =>
      prev.map((e) =>
        e.id === equipeId
          ? { ...e, joueurs: e.joueurs.map((j) => (j.id === joueurId ? { ...j, paye } : j)) }
          : e
      )
    );
    await supabase.from("joueurs").update({ paye }).eq("id", joueurId);
  }

  async function supprimerEquipe(equipeId: string) {
    if (!confirm("Supprimer cette équipe ? Cette action est définitive.")) return;
    setEquipes((prev) => prev.filter((e) => e.id !== equipeId));
    await supabase.from("equipes").delete().eq("id", equipeId);
  }

  async function majTournoi(champ: keyof Tournoi, valeur: any) {
    setTournoi((prev) => ({ ...prev, [champ]: valeur }));
    await supabase.from("tournois").update({ [champ]: valeur }).eq("id", tournoi.id);
  }

  async function dupliquer() {
    const nouveauNom = `${tournoi.nom} (copie)`;
    const { data, error } = await supabase
      .from("tournois")
      .insert({
        nom: nouveauNom,
        slug: `${slugify(tournoi.nom)}-${Date.now().toString(36)}`,
        type: tournoi.type,
        date_tournoi: null,
        tarif_par_joueur: tarif,
        statut: "ouvert",
        is_historique: false,
      })
      .select("id")
      .single();
    if (error || !data) {
      alert("Erreur lors de la duplication.");
      return;
    }
    // Copier les lignes de frais (sans les équipes)
    if (frais.length > 0) {
      await supabase.from("frais_association").insert(
        frais.map((f, i) => ({
          tournoi_id: data.id,
          description: f.description,
          montant: f.montant,
          fonction: f.fonction ?? "",
          position: i + 1,
        }))
      );
    }
    router.push(`/admin/tournoi/${data.id}`);
    router.refresh();
  }

  const lienPublic = `${baseUrl}/tournoi/${tournoi.slug}`;

  return (
    <div>
      {/* En-tête */}
      <div className="mb-5 flex flex-wrap items-start justify-between gap-4">
        <div>
          <span className="chip mb-2 bg-lagon/15 text-lagon ring-1 ring-lagon/30">
            {LIBELLE_TYPE[tournoi.type]}
          </span>
          <h1 className="font-display text-2xl font-700 text-ecume sm:text-3xl">
            {tournoi.nom}
          </h1>
          {tournoi.date_tournoi && (
            <p className="mt-1 capitalize text-brume">
              {new Date(tournoi.date_tournoi).toLocaleDateString("fr-FR", {
                weekday: "long",
                day: "numeric",
                month: "long",
                year: "numeric",
              })}
            </p>
          )}
        </div>
        <div className="no-print flex flex-wrap gap-2">
          <button
            className="btn-ghost"
            onClick={() =>
              exporterExcel(tournoi, equipes, achats, frais)
            }
          >
            Export Excel
          </button>
          <button className="btn-ghost" onClick={() => window.print()}>
            Export PDF
          </button>
          <button className="btn-ghost" onClick={dupliquer}>
            Dupliquer
          </button>
        </div>
      </div>

      {/* Onglets */}
      <div className="no-print mb-6 inline-flex rounded-xl border border-bordure bg-recif/40 p-1">
        {(
          [
            ["apercu", "Aperçu"],
            ["equipes", `Équipes (${equipes.length})`],
            ["finances", "Finances"],
          ] as [Tab, string][]
        ).map(([id, label]) => (
          <button
            key={id}
            onClick={() => setTab(id)}
            className={`rounded-lg px-4 py-2 text-sm font-semibold transition ${
              tab === id ? "bg-lagon text-abysse" : "text-brume hover:text-ecume"
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {tab === "apercu" && (
        <Apercu
          tournoi={tournoi}
          stats={stats}
          finances={finances}
          lienPublic={lienPublic}
          onToggleStatut={() =>
            majTournoi("statut", tournoi.statut === "ouvert" ? "cloture" : "ouvert")
          }
          onTarif={(v: number) => majTournoi("tarif_par_joueur", v)}
          tarif={tarif}
        />
      )}

      {tab === "equipes" && (
        <EquipesTab
          equipes={equipes}
          setEquipes={setEquipes}
          tarif={tarif}
          tournoiId={tournoi.id}
          onToggleJoueur={toggleJoueur}
          onSupprimer={supprimerEquipe}
        />
      )}

      {tab === "finances" && (
        <FinancesTab
          tournoi={tournoi}
          rentreeInscriptions={rentreeInscriptions}
          finances={finances}
          achats={achats}
          setAchats={setAchats}
          frais={frais}
          setFrais={setFrais}
          onBuvette={(champ: keyof Tournoi, v: number) => majTournoi(champ, v)}
        />
      )}
    </div>
  );
}

/* ============================================================
 *  Aperçu
 * ============================================================ */
function Apercu({
  tournoi,
  stats,
  finances,
  lienPublic,
  onToggleStatut,
  onTarif,
  tarif,
}: any) {
  const [copie, setCopie] = useState(false);
  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
        <StatCard label="Équipes" value={stats.nbEquipes} />
        <StatCard label="Joueurs" value={stats.nbJoueurs} />
        <StatCard
          label="Inscriptions"
          value={formatEuro(stats.montantTotalInscriptions)}
          hint="dû (tous joueurs)"
        />
        <StatCard
          label="Encaissé"
          value={formatEuro(stats.montantEncaisse)}
          tone="paye"
        />
        <StatCard
          label="Bénéfice estimé"
          value={formatEuro(finances.beneficeNet)}
          tone={finances.beneficeNet >= 0 ? "paye" : "nonpaye"}
        />
      </div>

      <div className="grid gap-3 sm:grid-cols-3">
        <StatCard label="Équipes payées" value={stats.equipesPayees} tone="paye" />
        <StatCard
          label="Paiement partiel"
          value={stats.equipesPartielles}
          tone="partiel"
        />
        <StatCard
          label="Non payées"
          value={stats.equipesNonPayees}
          tone="nonpaye"
        />
      </div>

      {/* Lien d'inscription */}
      <div className="card no-print p-5">
        <h3 className="mb-1 font-display text-lg font-600 text-ecume">
          Lien d&apos;inscription public
        </h3>
        <p className="mb-3 text-sm text-brume">
          Partagez ce lien aux équipes. Elles s&apos;ajoutent automatiquement ici.
        </p>
        <div className="flex flex-col gap-2 sm:flex-row">
          <input readOnly value={lienPublic} className="input font-mono text-sm" />
          <button
            className="btn-primary shrink-0"
            onClick={() => {
              navigator.clipboard.writeText(lienPublic);
              setCopie(true);
              setTimeout(() => setCopie(false), 1500);
            }}
          >
            {copie ? "Copié ✓" : "Copier"}
          </button>
        </div>
      </div>

      {/* Réglages */}
      <div className="card no-print p-5">
        <h3 className="mb-4 font-display text-lg font-600 text-ecume">Réglages</h3>
        <div className="flex flex-wrap items-end gap-6">
          <div>
            <label className="label">Tarif par joueur (€)</label>
            <input
              type="number"
              min="0"
              step="0.5"
              defaultValue={tarif}
              onBlur={(e) => onTarif(Number(e.target.value) || 0)}
              className="input w-32"
            />
          </div>
          <div>
            <label className="label">Inscriptions</label>
            <button
              onClick={onToggleStatut}
              className={tournoi.statut === "ouvert" ? "btn-ghost" : "btn-primary"}
            >
              {tournoi.statut === "ouvert"
                ? "Ouvertes — cliquer pour fermer"
                : "Fermées — cliquer pour ouvrir"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function StatCard({
  label,
  value,
  hint,
  tone,
}: {
  label: string;
  value: string | number;
  hint?: string;
  tone?: "paye" | "partiel" | "nonpaye";
}) {
  const color =
    tone === "paye"
      ? "text-paye"
      : tone === "partiel"
        ? "text-partiel"
        : tone === "nonpaye"
          ? "text-nonpaye"
          : "text-ecume";
  return (
    <div className="card p-4">
      <div className="text-[11px] font-semibold uppercase tracking-wide text-brume">
        {label}
      </div>
      <div className={`mt-1 font-display text-2xl font-700 ${color}`}>{value}</div>
      {hint && <div className="text-[11px] text-brume/60">{hint}</div>}
    </div>
  );
}

/* ============================================================
 *  Équipes
 * ============================================================ */
function EquipesTab({
  equipes,
  setEquipes,
  tarif,
  tournoiId,
  onToggleJoueur,
  onSupprimer,
}: {
  equipes: EquipeRow[];
  setEquipes: React.Dispatch<React.SetStateAction<EquipeRow[]>>;
  tarif: number;
  tournoiId: string;
  onToggleJoueur: (equipeId: string, joueurId: string, paye: boolean) => void;
  onSupprimer: (id: string) => void;
}) {
  const supabase = createClient();
  const [q, setQ] = useState("");
  const [expand, setExpand] = useState<string | null>(null);
  const [ajout, setAjout] = useState(false);

  const filtrees = useMemo(() => {
    const tri = [...equipes].sort((a, b) =>
      a.nom.localeCompare(b.nom, "fr", { sensitivity: "base" })
    );
    if (!q.trim()) return tri;
    const s = q.toLowerCase();
    return tri.filter(
      (e) =>
        e.nom.toLowerCase().includes(s) ||
        e.joueurs.some((j) => j.nom.toLowerCase().includes(s))
    );
  }, [equipes, q]);

  async function ajouterEquipe(nom: string, joueurs: string[]) {
    const { data, error } = await supabase
      .from("equipes")
      .insert({ tournoi_id: tournoiId, nom })
      .select("id")
      .single();
    if (error || !data) {
      alert("Erreur lors de l'ajout.");
      return;
    }
    const rows = joueurs.map((n, i) => ({
      equipe_id: data.id,
      nom: n,
      position: i + 1,
      paye: false,
    }));
    const { data: js } = await supabase.from("joueurs").insert(rows).select();
    setEquipes((prev) => [
      ...prev,
      {
        id: data.id,
        tournoi_id: tournoiId,
        nom,
        montant_historique: null,
        created_at: new Date().toISOString(),
        joueurs: (js as any[]) ?? [],
      },
    ]);
    setAjout(false);
  }

  return (
    <div>
      <div className="no-print mb-4 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <input
          className="input sm:max-w-xs"
          placeholder="Rechercher une équipe ou un joueur…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
        />
        <button className="btn-accent" onClick={() => setAjout(true)}>
          + Ajouter une équipe
        </button>
      </div>

      {ajout && (
        <AjoutEquipe
          onCancel={() => setAjout(false)}
          onSave={ajouterEquipe}
        />
      )}

      <div className="space-y-2">
        {filtrees.map((e) => {
          const eq: Equipe = {
            id: e.id,
            nom: e.nom,
            joueurs: e.joueurs.map((j) => ({ nom: j.nom, paye: j.paye })),
          };
          const st = statutEquipe(eq);
          const ouvert = expand === e.id;
          return (
            <div key={e.id} className="card overflow-hidden">
              <button
                onClick={() => setExpand(ouvert ? null : e.id)}
                className="flex w-full items-center gap-3 p-4 text-left transition hover:bg-recif2/40"
              >
                <span
                  className="h-9 w-1.5 shrink-0 rounded-full"
                  style={{
                    background:
                      st === "paye"
                        ? "#22C55E"
                        : st === "partiel"
                          ? "#F59E0B"
                          : "#EF4444",
                  }}
                />
                <div className="min-w-0 flex-1">
                  <div className="truncate font-display font-600 text-ecume">
                    {e.nom}
                  </div>
                  <div className="text-xs text-brume">
                    {e.joueurs.length} joueur{e.joueurs.length > 1 ? "s" : ""} ·{" "}
                    {formatEuro(montantPaye(eq, tarif))} / {formatEuro(montantDu(eq, tarif))}
                  </div>
                </div>
                <StatutBadge statut={st} />
                <span className="text-brume">{ouvert ? "▲" : "▼"}</span>
              </button>

              {ouvert && (
                <div className="border-t border-bordure p-4">
                  <div className="mb-3 grid grid-cols-2 gap-2 sm:grid-cols-2">
                    {e.joueurs.map((j) => (
                      <label
                        key={j.id}
                        className="flex cursor-pointer items-center gap-2.5 rounded-lg border border-bordure bg-abysse/40 px-3 py-2"
                      >
                        <input
                          type="checkbox"
                          checked={j.paye}
                          onChange={(ev) =>
                            onToggleJoueur(e.id, j.id, ev.target.checked)
                          }
                          className="h-4 w-4 accent-paye"
                        />
                        <span
                          className={`text-sm ${j.paye ? "text-ecume" : "text-brume"}`}
                        >
                          {j.nom}
                        </span>
                      </label>
                    ))}
                  </div>
                  <div className="flex flex-wrap items-center justify-between gap-3 border-t border-bordure pt-3 text-sm">
                    <div className="text-brume">
                      Payé{" "}
                      <span className="font-semibold text-paye">
                        {formatEuro(montantPaye(eq, tarif))}
                      </span>{" "}
                      · Restant{" "}
                      <span className="font-semibold text-corail">
                        {formatEuro(montantRestant(eq, tarif))}
                      </span>
                    </div>
                    <button
                      className="text-sm text-nonpaye hover:underline"
                      onClick={() => onSupprimer(e.id)}
                    >
                      Supprimer l&apos;équipe
                    </button>
                  </div>
                </div>
              )}
            </div>
          );
        })}
        {filtrees.length === 0 && (
          <div className="card p-8 text-center text-brume">
            Aucune équipe {q ? "ne correspond à la recherche" : "inscrite pour l'instant"}.
          </div>
        )}
      </div>
    </div>
  );
}

function AjoutEquipe({
  onCancel,
  onSave,
}: {
  onCancel: () => void;
  onSave: (nom: string, joueurs: string[]) => void;
}) {
  const [nom, setNom] = useState("");
  const [joueurs, setJoueurs] = useState<string[]>(["", "", "", ""]);
  const nbRemplis = joueurs.filter((j) => j.trim()).length;
  const ok = nom.trim() && nbRemplis >= 4;
  return (
    <div className="card mb-4 p-5">
      <div className="mb-3">
        <label className="label">Nom de l&apos;équipe</label>
        <input className="input" value={nom} onChange={(e) => setNom(e.target.value)} />
      </div>
      <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
        {joueurs.map((j, i) => (
          <input
            key={i}
            className="input"
            placeholder={`Joueur ${i + 1}${i < 4 ? " *" : ""}`}
            value={j}
            onChange={(e) =>
              setJoueurs((p) => p.map((x, idx) => (idx === i ? e.target.value : x)))
            }
          />
        ))}
      </div>
      <div className="mt-3 flex flex-wrap gap-2">
        {joueurs.length < 8 && (
          <button
            className="btn-ghost"
            onClick={() => setJoueurs((p) => [...p, ""])}
          >
            + Joueur
          </button>
        )}
        <div className="flex-1" />
        <button className="btn-ghost" onClick={onCancel}>
          Annuler
        </button>
        <button
          className="btn-primary"
          disabled={!ok}
          onClick={() =>
            onSave(nom.trim(), joueurs.map((j) => j.trim()).filter(Boolean))
          }
        >
          Ajouter
        </button>
      </div>
    </div>
  );
}

/* ============================================================
 *  Finances
 * ============================================================ */
function FinancesTab({
  tournoi,
  rentreeInscriptions,
  finances,
  achats,
  setAchats,
  frais,
  setFrais,
  onBuvette,
}: any) {
  const supabase = createClient();

  async function addLigne(
    table: "achats_divers" | "frais_association",
    setter: any,
    liste: LigneFinance[]
  ) {
    const { data } = await supabase
      .from(table)
      .insert({
        tournoi_id: tournoi.id,
        description: "",
        montant: 0,
        position: liste.length + 1,
      })
      .select()
      .single();
    if (data) setter((prev: LigneFinance[]) => [...prev, data]);
  }

  async function updLigne(
    table: "achats_divers" | "frais_association",
    setter: any,
    id: string,
    patch: Partial<LigneFinance>
  ) {
    setter((prev: LigneFinance[]) =>
      prev.map((l) => (l.id === id ? { ...l, ...patch } : l))
    );
    await supabase.from(table).update(patch).eq("id", id);
  }

  async function delLigne(
    table: "achats_divers" | "frais_association",
    setter: any,
    id: string
  ) {
    setter((prev: LigneFinance[]) => prev.filter((l) => l.id !== id));
    await supabase.from(table).delete().eq("id", id);
  }

  return (
    <div className="print-area space-y-5">
      {/* RECETTES */}
      <section className="card p-5">
        <h3 className="mb-4 font-display text-lg font-600 text-lagon">Recettes</h3>
        <LigneBilan
          label="Rentrée inscriptions"
          hint="joueurs payés × tarif (auto)"
          value={formatEuro(rentreeInscriptions)}
        />
        <div className="mt-3 flex items-center justify-between gap-3">
          <label className="label mb-0">Rentrée buvette</label>
          <MoneyInput
            value={Number(tournoi.rentree_buvette)}
            onCommit={(v) => onBuvette("rentree_buvette", v)}
          />
        </div>
        <div className="mt-4 flex items-center justify-between border-t border-bordure pt-3">
          <span className="font-semibold text-ecume">Total recettes</span>
          <span className="font-display text-lg font-700 text-paye">
            {formatEuro(finances.totalRecettes)}
          </span>
        </div>
      </section>

      {/* DÉPENSES */}
      <section className="card p-5">
        <h3 className="mb-4 font-display text-lg font-600 text-corail">Dépenses</h3>

        <div className="mb-4 flex items-center justify-between gap-3">
          <label className="label mb-0">Dépense buvette</label>
          <MoneyInput
            value={Number(tournoi.depense_buvette)}
            onCommit={(v) => onBuvette("depense_buvette", v)}
          />
        </div>

        {/* Achats divers */}
        <TableauLignes
          titre="Achats divers"
          lignes={achats}
          total={finances.totalAchatsDivers}
          onAdd={() => addLigne("achats_divers", setAchats, achats)}
          onUpd={(id, patch) => updLigne("achats_divers", setAchats, id, patch)}
          onDel={(id) => delLigne("achats_divers", setAchats, id)}
          labelAjout="+ Ajouter une dépense"
        />

        {/* Frais association */}
        <div className="mt-6">
          <TableauLignes
            titre="Frais association"
            lignes={frais}
            total={finances.totalFraisAssociation}
            onAdd={() => addLigne("frais_association", setFrais, frais)}
            onUpd={(id, patch) => updLigne("frais_association", setFrais, id, patch)}
            onDel={(id) => delLigne("frais_association", setFrais, id)}
            labelAjout="+ Ajouter un frais"
            avecFonction
          />
        </div>

        <div className="mt-4 flex items-center justify-between border-t border-bordure pt-3">
          <span className="font-semibold text-ecume">Total dépenses</span>
          <span className="font-display text-lg font-700 text-corail">
            {formatEuro(finances.totalDepenses)}
          </span>
        </div>
      </section>

      {/* BÉNÉFICE */}
      <section
        className={`card p-6 ${
          finances.beneficeNet >= 0 ? "ring-1 ring-paye/40" : "ring-1 ring-nonpaye/40"
        }`}
      >
        <div className="flex items-center justify-between">
          <div>
            <div className="text-sm uppercase tracking-wide text-brume">
              Bénéfice net du tournoi
            </div>
            <div className="text-xs text-brume/60">
              Recettes − Dépenses
            </div>
          </div>
          <div
            className={`font-display text-3xl font-700 ${
              finances.beneficeNet >= 0 ? "text-paye" : "text-nonpaye"
            }`}
          >
            {formatEuro(finances.beneficeNet)}
          </div>
        </div>
      </section>
    </div>
  );
}

function LigneBilan({
  label,
  value,
  hint,
}: {
  label: string;
  value: string;
  hint?: string;
}) {
  return (
    <div className="flex items-center justify-between">
      <div>
        <div className="text-ecume">{label}</div>
        {hint && <div className="text-xs text-brume/60">{hint}</div>}
      </div>
      <div className="font-display font-600 text-ecume">{value}</div>
    </div>
  );
}

function MoneyInput({
  value,
  onCommit,
}: {
  value: number;
  onCommit: (v: number) => void;
}) {
  const [v, setV] = useState(String(value ?? 0));
  return (
    <div className="relative w-40">
      <input
        type="number"
        step="0.01"
        min="0"
        value={v}
        onChange={(e) => setV(e.target.value)}
        onBlur={() => onCommit(Number(v) || 0)}
        className="input pr-7 text-right"
      />
      <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-brume">
        €
      </span>
    </div>
  );
}

function TableauLignes({
  titre,
  lignes,
  total,
  onAdd,
  onUpd,
  onDel,
  labelAjout,
  avecFonction,
}: {
  titre: string;
  lignes: LigneFinance[];
  total: number;
  onAdd: () => void;
  onUpd: (id: string, patch: Partial<LigneFinance>) => void;
  onDel: (id: string) => void;
  labelAjout: string;
  avecFonction?: boolean;
}) {
  return (
    <div>
      <div className="mb-2 flex items-center justify-between">
        <h4 className="text-sm font-semibold uppercase tracking-wide text-brume">
          {titre}
        </h4>
        <span className="font-display font-600 text-ecume">{formatEuro(total)}</span>
      </div>
      <div className="space-y-2">
        {lignes.map((l) => (
          <div key={l.id} className="flex flex-wrap items-center gap-2">
            <input
              className="input flex-1"
              placeholder="Description"
              defaultValue={l.description}
              onBlur={(e) => onUpd(l.id, { description: e.target.value })}
            />
            {avecFonction && (
              <input
                className="input flex-1 text-sm"
                placeholder="Fonction (optionnel)"
                defaultValue={l.fonction ?? ""}
                onBlur={(e) => onUpd(l.id, { fonction: e.target.value })}
              />
            )}
            <div className="relative w-28">
              <input
                type="number"
                step="0.01"
                className="input pr-6 text-right"
                defaultValue={l.montant}
                onBlur={(e) => onUpd(l.id, { montant: Number(e.target.value) || 0 })}
              />
              <span className="pointer-events-none absolute right-2.5 top-1/2 -translate-y-1/2 text-xs text-brume">
                €
              </span>
            </div>
            <button
              className="no-print px-2 text-nonpaye hover:opacity-80"
              onClick={() => onDel(l.id)}
              aria-label="Supprimer la ligne"
            >
              ✕
            </button>
          </div>
        ))}
      </div>
      <button className="btn-ghost no-print mt-2 text-sm" onClick={onAdd}>
        {labelAjout}
      </button>
    </div>
  );
}
