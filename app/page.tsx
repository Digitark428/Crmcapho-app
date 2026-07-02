import Link from "next/link";
import { Brand, Logo } from "@/components/Brand";

export default function Home() {
  return (
    <main className="relative mx-auto flex min-h-screen max-w-3xl flex-col items-center justify-center px-6 text-center">
      <div className="mb-8">
        <Logo size={72} />
      </div>
      <p className="mb-3 text-xs font-semibold uppercase tracking-[0.3em] text-lagon">
        Beach Volley · La Réunion 974
      </p>
      <h1 className="font-display text-4xl font-700 leading-tight text-ecume sm:text-5xl">
        CAP HOMARD
        <br />
        <span className="bg-gradient-to-r from-lagon to-corail bg-clip-text text-transparent">
          Gestion des tournois
        </span>
      </h1>
      <p className="mt-5 max-w-md text-brume">
        Inscriptions en ligne, suivi des paiements et bilans financiers de nos
        tournois — le tout au même endroit.
      </p>

      <div className="mt-9 flex flex-col gap-3 sm:flex-row">
        <Link href="/login" className="btn-primary">
          Espace organisateur
        </Link>
      </div>

      <p className="mt-10 max-w-md text-sm text-brume/70">
        Vous êtes une équipe ? Utilisez le lien d&apos;inscription qui vous a été
        transmis pour votre tournoi.
      </p>

      <footer className="absolute bottom-6 text-xs text-brume/50">
        <Brand compact />
      </footer>
    </main>
  );
}
