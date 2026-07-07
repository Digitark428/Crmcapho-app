"use client";

import { Suspense, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Brand } from "@/components/Brand";

function LoginForm() {
  const router = useRouter();
  const params = useSearchParams();
  const redirect = params.get("redirect") || "/admin";

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [erreur, setErreur] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setErreur(null);
    setLoading(true);
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    });
    setLoading(false);
    if (error) {
      setErreur("Identifiants incorrects.");
      return;
    }
    router.push(redirect);
    router.refresh();
  }

  return (
    <div className="card p-7">
      <h1 className="mb-1 font-display text-2xl font-700 text-ecume">
        Espace organisateur
      </h1>
      <p className="mb-6 text-sm text-brume">
        Connectez-vous pour gérer vos tournois.
      </p>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="label" htmlFor="email">
            E-mail
          </label>
          <input
            id="email"
            type="email"
            autoComplete="email"
            className="input"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label className="label" htmlFor="password">
            Mot de passe
          </label>
          <input
            id="password"
            type="password"
            autoComplete="current-password"
            className="input"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        {erreur && (
          <p className="rounded-xl bg-nonpaye/10 px-4 py-2.5 text-sm text-nonpaye ring-1 ring-nonpaye/30">
            {erreur}
          </p>
        )}
        <button type="submit" disabled={loading} className="btn-primary w-full py-3">
          {loading ? "Connexion…" : "Se connecter"}
        </button>
      </form>
    </div>
  );
}

export default function LoginPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6">
      <div className="mb-8 flex justify-center">
        <Brand />
      </div>
      <Suspense
        fallback={
          <div className="card p-7 text-center text-brume">Chargement…</div>
        }
      >
        <LoginForm />
      </Suspense>
      <p className="mt-4 text-center text-xs text-brume/60">
        Les comptes organisateurs se créent dans le tableau de bord Supabase
        (Authentication → Users).
      </p>
    </main>
  );
}
