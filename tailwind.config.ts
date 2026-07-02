import type { Config } from "tailwindcss";

/**
 * Identité CAP HOMARD BEACH VOLLEY 974
 * Direction : océan profond de La Réunion la nuit — fond bleu nuit,
 * accent turquoise "lagon", accent soleil "corail/homard" pour l'action.
 */
const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Fonds
        abysse: "#081422", // fond principal (bleu nuit océan)
        recif: "#0F2338", // surfaces / cartes
        recif2: "#16324F", // surfaces surélevées / hover
        bordure: "#1E3A5C",
        // Accents
        lagon: "#22B8CF", // turquoise principal (boutons, liens)
        lagonClair: "#5FD3E0",
        corail: "#FF7A3C", // orange soleil / homard (accent action)
        corailClair: "#FF9E6B",
        // Statuts
        paye: "#22C55E",
        partiel: "#F59E0B",
        nonpaye: "#EF4444",
        // Texte
        ecume: "#F4FAFF", // blanc cassé
        brume: "#93AEC9", // texte secondaire
      },
      fontFamily: {
        display: ["var(--font-display)", "system-ui", "sans-serif"],
        sans: ["var(--font-body)", "system-ui", "sans-serif"],
      },
      fontWeight: {
        "500": "500",
        "600": "600",
        "700": "700",
      },
      boxShadow: {
        carte: "0 1px 0 0 rgba(255,255,255,0.03) inset, 0 8px 30px -12px rgba(0,0,0,0.6)",
        lueur: "0 0 0 1px rgba(34,184,207,0.4), 0 8px 24px -8px rgba(34,184,207,0.35)",
      },
      borderRadius: {
        xl: "0.9rem",
        "2xl": "1.25rem",
      },
    },
  },
  plugins: [],
};
export default config;
