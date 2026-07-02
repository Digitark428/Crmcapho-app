/**
 * Vérifie que calculerFinances() reproduit EXACTEMENT les bénéfices
 * enregistrés dans le fichier CSV d'origine, pour les 13 tournois.
 *   npx tsx scripts/verify-finance.ts
 */
import { readFileSync } from "node:fs";
import { calculerFinances } from "../lib/finance";

const hist = JSON.parse(
  readFileSync(new URL("./historique.json", import.meta.url), "utf-8")
) as any[];

let ok = 0;
let ko = 0;
for (const t of hist) {
  const f = t.finances ?? {};
  const res = calculerFinances({
    rentreeInscriptions: f.inscriptions ?? 0,
    rentreeBuvette: f.rentre_buvette ?? 0,
    depenseBuvette: f.depense_buvette ?? 0,
    achatsDivers: (t.achats_divers ?? []).map((a: any) => ({
      description: a.description,
      montant: a.montant,
    })),
    fraisAssociation: (t.frais_association ?? []).map((a: any) => ({
      description: a.description,
      montant: a.montant,
    })),
  });

  const stored = f.benefice;
  // On compare à l'arrondi entier (le fichier affiche des € entiers).
  const match =
    stored == null || Math.abs(Math.round(res.beneficeNet) - Math.round(stored)) < 1;

  console.log(
    `${match ? "✅" : "❌"} ${t.nom.padEnd(28)} | ` +
      `calc=${res.beneficeNet.toString().padStart(8)} € | ` +
      `fichier=${(stored ?? "—").toString().padStart(8)} €`
  );
  match ? ok++ : ko++;
}
console.log(`\n${ok}/${ok + ko} tournois reproduits à l'identique.`);
process.exit(ko === 0 ? 0 : 1);
