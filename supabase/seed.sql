-- Seed historique CAP HOMARD — généré depuis GESTION_Tournoi_CAP_HOMARD_.csv
-- 13 tournois, 422 équipes. À exécuter APRÈS schema.sql.
begin;

-- 4VS4 MIXTE 16 FEVRIER
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('4VS4 MIXTE 16 FEVRIER', '4vs4-mixte-16-fevrier', 'mixte', null, 10, 'cloture', true, 0, 500.0, 912.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'TEAM VALOU', 32.0),
  ((select id from tt), 'KABOMARD', 24.0),
  ((select id from tt), 'L''AIGLES ET SES MOUETTES', 24.0),
  ((select id from tt), 'DEPUIS LE TEMPS QUE J''ATTENDAIS ÇA', 32.0),
  ((select id from tt), 'BEACH BEACH ON FIRE', 24.0),
  ((select id from tt), 'LES TIPIOCOCOS', 32.0),
  ((select id from tt), 'LES SAUTÉ MINES', 32.0),
  ((select id from tt), 'LE RETOUR DE TONI', 32.0),
  ((select id from tt), 'ROUGAIL DAKATINE', 32.0),
  ((select id from tt), 'LES TCHOUPAPENSES', 32.0),
  ((select id from tt), 'TOUT SUR LE ROUGE', 32.0),
  ((select id from tt), 'ON EST PAS DES MANGUES A TERRE', 48.0),
  ((select id from tt), 'TEAM CHARLES', 32.0),
  ((select id from tt), 'team paye pas', 16.0),
  ((select id from tt), 'LES HOMARDS ET FRED', 32.0),
  ((select id from tt), 'LES SPORTIFS DU DIMANCHE', 32.0),
  ((select id from tt), 'TO THE au fond a gauche', 32.0),
  ((select id from tt), '#UNPEUPRESVOLLEYBALL', 32.0),
  ((select id from tt), 'LES AIGLES TOUS TOUS', 40.0),
  ((select id from tt), 'TEAM QUENTIN METISSE', 32.0),
  ((select id from tt), 'ENCHANTIER JE MA PELLETEUSE', 32.0),
  ((select id from tt), 'FC MOINS 1M80', 32.0),
  ((select id from tt), 'les escrevisse de cap homard', 32.0),
  ((select id from tt), 'TORTUE NIGGAZ', 32.0),
  ((select id from tt), 'HOMARD GOD', 32.0),
  ((select id from tt), 'DE DERNIERE MINUTES', 32.0),
  ((select id from tt), 'LES ROULOUSORS', 32.0),
  ((select id from tt), 'BRICE TES MORT!', 32.0),
  ((select id from tt), 'Les choupettes', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Vidéaste', 200.0, 1),
  ((select id from tt), 'Repas Staff', 0, 2),
  ((select id from tt), 'Aprés tournoi Apero', 0, 3)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 600.0, 'Transport / stockage', 6)
  returning id)
select 1;

-- 3VS3 MIXTE 16 MARS
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('3VS3 MIXTE 16 MARS', '3vs3-mixte-16-mars', '3x3', null, 10, 'cloture', true, 136.0, 0, 1000.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'LES SMARTIES', 24.0),
  ((select id from tt), 'O IDEES', 24.0),
  ((select id from tt), '3.2.1 REQUIN', 24.0),
  ((select id from tt), '6 PARTOUT', 16.0),
  ((select id from tt), 'LA TEAM K TA PEUR - 2', 16.0),
  ((select id from tt), 'LA TABLE D''ARTHUR', 16.0),
  ((select id from tt), 'TTB', 24.0),
  ((select id from tt), 'VODKA ANNANAS - 2 EUROS + 8 EUROS', 24.0),
  ((select id from tt), 'ESCANOR - CENTRAL', 16.0),
  ((select id from tt), 'LE RETOUR DU ROI', 24.0),
  ((select id from tt), 'ON MONTE EN DEMIE', 16.0),
  ((select id from tt), 'TEAM LE DUFF', 24.0),
  ((select id from tt), 'LOS GRINGOS - CENTRAL', 24.0),
  ((select id from tt), 'BALLES PERDUES - 6 EUROS', 24.0),
  ((select id from tt), 'MASTEWAN -', 24.0),
  ((select id from tt), 'NOA ET LES AUTRES - 2', 24.0),
  ((select id from tt), 'CHIKCHIK', 24.0),
  ((select id from tt), 'LES BRAS CASSÉ', 24.0),
  ((select id from tt), 'TEAM BAGARRE', 24.0),
  ((select id from tt), 'LES VISIONNAIRES + 8EURO', 24.0),
  ((select id from tt), 'TEAM CHIEN MAIGRE', 24.0),
  ((select id from tt), 'MATHIS PRIME', 16.0),
  ((select id from tt), 'KABOMARD - 2', 24.0),
  ((select id from tt), '3 BEACHEUR - 3', 24.0),
  ((select id from tt), 'FAIT VRILLER - 4 EUROS', 16.0),
  ((select id from tt), 'ZOMBILENIUM', 16.0),
  ((select id from tt), 'PASSEUR TITULAIRE', 24.0),
  ((select id from tt), 'SAUCE AU GALETS', 16.0),
  ((select id from tt), 'LES CROUSTIBAT', 24.0),
  ((select id from tt), '2 GARS UNE FILLE', 24.0),
  ((select id from tt), 'JACQUELINE', 32.0),
  ((select id from tt), 'ATTEND PAS PATRICK', 24.0),
  ((select id from tt), 'GABARRIVE', 24.0),
  ((select id from tt), '3 GRAMMES', 24.0),
  ((select id from tt), 'SNCF - 2', 24.0),
  ((select id from tt), 'LE CHIEN LA VOLE MON BARQUETTE 6 EUROS', 24.0),
  ((select id from tt), 'LES BRONZÉ - 4 EUROS', 32.0),
  ((select id from tt), 'LES RANDOMS', 24.0),
  ((select id from tt), 'TEAM PAS PAYE', 24.0),
  ((select id from tt), 'POP UP BDP', 50.0),
  ((select id from tt), 'POP UP GAYA', 35.0),
  ((select id from tt), 'POP UP GARDIENNA', 35.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Medailles', 0, 1),
  ((select id from tt), 'Repas Staff', 0, 2),
  ((select id from tt), 'Aprés tournoi Apero', 0, 3),
  ((select id from tt), 'Dette Juju', 0, 4),
  ((select id from tt), 'VIDEASTE', 0, 5),
  ((select id from tt), 'KEVIN ESSENCE', 25.0, 6),
  ((select id from tt), 'KEVIN DIVERS', 25.0, 7),
  ((select id from tt), 'KEVIN AVANCE BOISSON', 50.0, 8),
  ((select id from tt), 'Sac poubelles ,piles, gobelet', 9.66, 9),
  ((select id from tt), 'petit dej payant', 39.67, 10),
  ((select id from tt), 'RUban', 6.5, 11),
  ((select id from tt), 'gobelet + baguette', 24.8, 12),
  ((select id from tt), 'sandiwch', 31.14, 13),
  ((select id from tt), 'CB', 8.9, 14)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 160.0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 600.0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 75.0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 80.0, '', 8)
  returning id)
select 1;

-- 4VS4 MIXTE  11 MAI
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('4VS4 MIXTE  11 MAI', '4vs4-mixte-11-mai', 'mixte', null, 10, 'cloture', true, 414.0, 0, 1512.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), '4 3 2 1 REQUIN - MANQUE ENZO', 32.0),
  ((select id from tt), 'LES SAUTÉ MINE', 16.0),
  ((select id from tt), 'LA NASA', 32.0),
  ((select id from tt), 'CREME SOLAIRE - TERRAIN 4', 32.0),
  ((select id from tt), 'KEVIN ET LES MINIMOYS - Terrain 1', 32.0),
  ((select id from tt), 'TRALALA', 16.0),
  ((select id from tt), 'LES TOUTOU DE MARIE', 32.0),
  ((select id from tt), 'LOS PEGUES', 24.0),
  ((select id from tt), 'LA CHARETTE ET SES BOEUFS', 32.0),
  ((select id from tt), 'PINCE MI SMASH MOI', 32.0),
  ((select id from tt), 'TU VA NOUS MANQUER MIMI -', 32.0),
  ((select id from tt), 'CHUPA', 32.0),
  ((select id from tt), 'MILO PASSEUR 3000 - MANQUE 2 - TERRAIN 4', 24.0),
  ((select id from tt), 'LA MINETTE ET SES MINETS', 32.0),
  ((select id from tt), 'I LOVE SKINNY SURPRISE', 32.0),
  ((select id from tt), 'LES SEGPA  - TERRAIN 4', 40.0),
  ((select id from tt), 'YOMARDGOD', 32.0),
  ((select id from tt), 'LA TEAM TEAM', 32.0),
  ((select id from tt), 'VOLLEY & FEMMES', 32.0),
  ((select id from tt), 'BOMBOCLAT', 32.0),
  ((select id from tt), 'TUNG TUNG TUNG SAHUR', 32.0),
  ((select id from tt), 'Les 4 PARALYMPIQUES - TERRAIN 4', 32.0),
  ((select id from tt), 'HOMARD HEUUUUU', 32.0),
  ((select id from tt), 'RACHEL A LA PASSE', 32.0),
  ((select id from tt), 'TEAM SOUCOUPE', 32.0),
  ((select id from tt), 'LE PETIT NOUS SURVEILLE', 32.0),
  ((select id from tt), 'SUR LE FIL', 32.0),
  ((select id from tt), 'TOUT SUR LE ROUGE', 32.0),
  ((select id from tt), 'LA RAFALE', 32.0),
  ((select id from tt), 'LES 4 MERGUEZ', 32.0),
  ((select id from tt), 'TOINIQUETAM HAÏR', 16.0),
  ((select id from tt), 'LES BEACHEURS', 32.0),
  ((select id from tt), 'WOUAF WOAUF LE MEC A CAMILLE', 32.0),
  ((select id from tt), 'BOB L''EPONGE', 16.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Aprés tournoi Apero', 30.0, 1),
  ((select id from tt), 'COURSE Kevin ( Avance)', 361.0, 2),
  ((select id from tt), 'Glacon', 7.0, 3),
  ((select id from tt), 'Protege feuille', 10.0, 4),
  ((select id from tt), 'Course du matin', 30.0, 5)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 242.0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 600.0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 150.0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 3VS3 OPEN 22 JUIN
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('3VS3 OPEN 22 JUIN', '3vs3-open-22-juin', '3x3', null, 10, 'cloture', true, 0, 0, 1384.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'SARCIVES MANIOC', 24.0),
  ((select id from tt), 'LES 3 FOIS MIEUX', 24.0),
  ((select id from tt), 'VOIN VOIN VOIN', 24.0),
  ((select id from tt), 'ÇA BOUDE PAS ICI', 24.0),
  ((select id from tt), 'SMASH THAT BEACH', 24.0),
  ((select id from tt), 'MAISON BLANCHE', 24.0),
  ((select id from tt), 'LES BAGUETTES', 24.0),
  ((select id from tt), 'LES TUNDERS', 24.0),
  ((select id from tt), 'LES MALAGACHES', 24.0),
  ((select id from tt), 'LES NEUILLES DU VOLLEY', 24.0),
  ((select id from tt), 'TIC TAC TOE', 24.0),
  ((select id from tt), 'TEAM FE VRILLER', 24.0),
  ((select id from tt), 'LA MOUKATE LO CHIEN', 24.0),
  ((select id from tt), 'LES POULET LE FRIT', 24.0),
  ((select id from tt), 'TEAM MARIE', 24.0),
  ((select id from tt), 'LE TROIS TOIS', 24.0),
  ((select id from tt), 'TEAM FRED', 24.0),
  ((select id from tt), 'TEAM PRÉSIDENT', 16.0),
  ((select id from tt), 'LES TCHOUPAPENSE', 24.0),
  ((select id from tt), '40 GT', 24.0),
  ((select id from tt), 'DAKA TEAM', 24.0),
  ((select id from tt), 'YERO ET SES ZÉROS', 24.0),
  ((select id from tt), 'EVA PRIME', 24.0),
  ((select id from tt), 'JAI PRIS TA COPINE ANTCHOUAY', 24.0),
  ((select id from tt), 'CHIEN MAIGRE', 24.0),
  ((select id from tt), 'BOMBOCLAT', 24.0),
  ((select id from tt), 'TEAM ANTONIO', 24.0),
  ((select id from tt), 'TEAM MANASA', 24.0),
  ((select id from tt), 'FILET MIGNON', 24.0),
  ((select id from tt), 'LE STAGIAIRE ET LE DESCO', 24.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'REMBOURSEMENT KEVIN DEMARREUR', 150.0, 1),
  ((select id from tt), 'REMBOURSEMENT BOISSON KEVIN', 80.0, 2)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 180.0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 400.0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 75.0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 4VS4 27 JUILLET
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('4VS4 27 JUILLET', '4vs4-27-juillet', '4x4', '2025-07-27', 10, 'cloture', true, 0, 0, 1480.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'HALLUX CASSÉ', 32.0),
  ((select id from tt), 'TEAM CHAUTARD', 32.0),
  ((select id from tt), 'ZAVIRONS', 32.0),
  ((select id from tt), 'LES COCOTTES', 32.0),
  ((select id from tt), 'BOMBOCLAT', 32.0),
  ((select id from tt), 'UNE PAS DEUX', 32.0),
  ((select id from tt), 'LES REKINS DE BOUCAN', 32.0),
  ((select id from tt), 'KASS ET SES PETASSES', 16.0),
  ((select id from tt), 'KISS CAM COLD PLAY', 16.0),
  ((select id from tt), 'ALIBABA ET LES 40 CHEVEUX', 32.0),
  ((select id from tt), 'ZOZO ET SES LOULOU', 32.0),
  ((select id from tt), 'TEAM FOR MEOK', 32.0),
  ((select id from tt), 'APERO BEACH', 32.0),
  ((select id from tt), 'ET C''EST OK', 32.0),
  ((select id from tt), 'LA TAM CFU ET MATHIS', 32.0),
  ((select id from tt), 'LES CRABES SABLÉS', 32.0),
  ((select id from tt), 'IPOPO SVP', 32.0),
  ((select id from tt), 'FILET MIGNON', 32.0),
  ((select id from tt), 'ASSON BATIMENTS', 32.0),
  ((select id from tt), 'COU TUPIK', 32.0),
  ((select id from tt), 'TCHOUPAPENSE', 32.0),
  ((select id from tt), 'GROS CERVEAU', 32.0),
  ((select id from tt), 'TEAM PETCHY', 32.0),
  ((select id from tt), 'ICH AN ICH AN', 32.0),
  ((select id from tt), 'BEACH PLEASE', 32.0),
  ((select id from tt), 'LOVE ET COMPAGNIE', 32.0),
  ((select id from tt), 'RECEP TETE', 32.0),
  ((select id from tt), 'TEAM ELIO', 16.0),
  ((select id from tt), 'FIBULA', 32.0),
  ((select id from tt), 'FIRE FOX', 32.0),
  ((select id from tt), 'LE PETIT BOUT QUI DEPASSE', 32.0),
  ((select id from tt), 'CHACHA', 32.0),
  ((select id from tt), 'AIR FRANCE', 32.0),
  ((select id from tt), 'LES FRAPPÉS', 32.0),
  ((select id from tt), 'TI MAX MATHÉ', 32.0),
  ((select id from tt), 'TCHOPPEUR ARRÊTE DE CHOPER', 24.0),
  ((select id from tt), 'SHATTA TEAM', 32.0),
  ((select id from tt), 'ANNA ET SES LANGOUSTINES', 32.0),
  ((select id from tt), 'SOYONS FOUS', 32.0),
  ((select id from tt), 'TEAM FUN', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'JUJU buvette', 160.0, 1),
  ((select id from tt), 'JUJU avant', 80.0, 2),
  ((select id from tt), 'Securité', 160.0, 3)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 360.0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 600.0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 75.0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 4VS4 27 JUILLET
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('4VS4 27 JUILLET', '4vs4-27-juillet-2', '4x4', '2025-07-27', 10, 'cloture', true, 0, 0, 1617.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'THUNDERS', 32.0),
  ((select id from tt), 'APERO BEACH', 32.0),
  ((select id from tt), 'SANS RESEAU', 32.0),
  ((select id from tt), 'J''AI PRIS TA COPINE ANTCHOUAY', 32.0),
  ((select id from tt), 'LES FOUFOU DE SOCHEAUX', 32.0),
  ((select id from tt), 'ZOZO ET SES ZOUOU', 32.0),
  ((select id from tt), 'FC CHILL', 32.0),
  ((select id from tt), 'SANS PERMIS', 32.0),
  ((select id from tt), 'STRAP ET DOLIPRANE', 32.0),
  ((select id from tt), 'CONSOLENTE', 32.0),
  ((select id from tt), 'TEAM MAAF', 32.0),
  ((select id from tt), 'TEAM TESSA', 32.0),
  ((select id from tt), 'POLE EMPLOIE', 32.0),
  ((select id from tt), 'LES THON TONIQUE', 32.0),
  ((select id from tt), 'LES LOUCHE DE LEO', 32.0),
  ((select id from tt), 'TEAM AXEL BERIRI', 32.0),
  ((select id from tt), 'LES BILLES DE SAINT SUCRÉ', 32.0),
  ((select id from tt), 'TEAM KLEIN', 32.0),
  ((select id from tt), 'SARDINE I BEK PAS', 32.0),
  ((select id from tt), 'BJKL', 32.0),
  ((select id from tt), 'LES PETIT COCO', 32.0),
  ((select id from tt), 'TIC TAC BOUM ACE', 32.0),
  ((select id from tt), 'LE PORK', 32.0),
  ((select id from tt), 'YAV BOU', 32.0),
  ((select id from tt), 'On c''est trouver', 32.0),
  ((select id from tt), 'TEAM QUENTIN', 32.0),
  ((select id from tt), 'TEAM ELIO', 32.0),
  ((select id from tt), 'TEAM PRESDIENT', 24.0),
  ((select id from tt), 'BEACH PLEASE', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'JUJU buvette', 100.0, 1),
  ((select id from tt), 'JUJU avant', 0, 2),
  ((select id from tt), 'Securité', 140.0, 3),
  ((select id from tt), 'Assurance Camion + Civil', 480.0, 4),
  ((select id from tt), 'Ballon Eric', 150.0, 5)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 21 SEPTEMNBRE 2025
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('21 SEPTEMNBRE 2025', '21-septemnbre-2025', 'autre', '2025-09-21', 10, 'cloture', true, 0, 0, 1715.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'A NOU MEME LA FORCE', 32.0),
  ((select id from tt), 'TEAM BOUCHAREINE', 32.0),
  ((select id from tt), 'ZIP SUR YVETTE', 32.0),
  ((select id from tt), 'TEAM APERO BEACH', 32.0),
  ((select id from tt), 'NOSY ET LES AUTRES', 24.0),
  ((select id from tt), 'DREAM TEAM - MANQUE 16', 16.0),
  ((select id from tt), 'LE GEANTS ET LES PETITS', 32.0),
  ((select id from tt), 'LE PROJET', 32.0),
  ((select id from tt), 'PAS PLUS HAUT QUE THIBAULT', 32.0),
  ((select id from tt), 'HOMARD SALÉ', 32.0),
  ((select id from tt), 'LE V TRIPLE R - MANQUE 8', 24.0),
  ((select id from tt), 'LES MINETTE ET LES MINETS', 32.0),
  ((select id from tt), 'LES CRACOTTE DE LEXTREME', 32.0),
  ((select id from tt), 'LES PEPETTES ET LA FOOTABALLEUSE', 32.0),
  ((select id from tt), 'OBJECTIF DES FÊTES', 32.0),
  ((select id from tt), 'NATHAN AIRLINES A CAP HO', 32.0),
  ((select id from tt), 'LES BRAS CASSÉ DE SAINT LEU', 32.0),
  ((select id from tt), 'L''EQUIPE L''EQUIPE', 40.0),
  ((select id from tt), 'L''ENFANT PRODIGE', 16.0),
  ((select id from tt), 'LOU ET LES AUTRES', 32.0),
  ((select id from tt), 'LES DALLEUX', 32.0),
  ((select id from tt), '321 REQUIN + MATHIS ET NOA', 32.0),
  ((select id from tt), 'ANNA LA PLUS BELLE', 33.0),
  ((select id from tt), 'TIM DEMI AU CENTRE', 32.0),
  ((select id from tt), 'TÊTE D''AFFICHE MYGYM', 32.0),
  ((select id from tt), 'LA COLLOC ET SON INTRU', 32.0),
  ((select id from tt), 'TRISO DESSUS DE BLOC', 8.0),
  ((select id from tt), 'TORTUE NIGGAZ', 40.0),
  ((select id from tt), 'SI DIEU LE VEU', 32.0),
  ((select id from tt), 'LES OPTIMISTES', 32.0),
  ((select id from tt), 'BOMBA LATINA', 16.0),
  ((select id from tt), 'LES CHAVESSE', 32.0),
  ((select id from tt), '50/50', 8.0),
  ((select id from tt), 'LES INDESTRUCTIBLES', 32.0),
  ((select id from tt), 'MAGIK MIKE', 32.0),
  ((select id from tt), 'TEAM SCUM', 32.0),
  ((select id from tt), 'Bikini', 50.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'JUJU buvette', 0, 1),
  ((select id from tt), 'JUJU avant', 0, 2),
  ((select id from tt), 'Securité', 0, 3),
  ((select id from tt), 'Assurance Camion + Civil', 300.0, 4),
  ((select id from tt), 'Camion Crédit', 500.0, 5)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 23 Novembre 2025 4MAN
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('23 Novembre 2025 4MAN', '23-novembre-2025-4man', '4x4', '2025-11-23', 10, 'cloture', true, 0, 0, 1354.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'karasuNON', 28.0),
  ((select id from tt), '3 blancs et 1 noir', 28.0),
  ((select id from tt), 'D''jocolinis', 28.0),
  ((select id from tt), 'ISAAC TOUJOURS PLUS HAUT', 28.0),
  ((select id from tt), 'TEAM CONSTANT', 28.0),
  ((select id from tt), 'R2D2', 28.0),
  ((select id from tt), 'NOUVELLE ECOLE', 28.0),
  ((select id from tt), 'LES ''4 GRAINES', 28.0),
  ((select id from tt), 'AUCUNE IDÉE', 28.0),
  ((select id from tt), 'TRIOFFENSIF', 16.0),
  ((select id from tt), 'TEAM CREMOS', 16.0),
  ((select id from tt), 'AIR FRANCE 1 euros julien', 28.0),
  ((select id from tt), 'BOMBOCLAT 2 euros valentin', 28.0),
  ((select id from tt), 'LES QUATRE PREDATEUR  ( MANSUE PAIEMENT ENTIER', 28.0),
  ((select id from tt), 'SAINT LOUIS ZOO (', 16.0),
  ((select id from tt), 'MORT DANS LE FILM MANQUE UN JOUEUR', 28.0),
  ((select id from tt), 'LES INGENIEURS', 28.0),
  ((select id from tt), 'IL MANQUE DEUX JOUEURS ( DOIT DONNER 6', 28.0),
  ((select id from tt), 'LUDODODO', 0.0),
  ((select id from tt), 'TEAM DUGAIN', 28.0),
  ((select id from tt), 'TEAM AFAG', 28.0),
  ((select id from tt), 'FAUX DE FAUX', 28.0),
  ((select id from tt), '"TEAM HYPOLITE "" PAS SUR """', 28.0),
  ((select id from tt), 'aller fe careess a ou ( Deux euros )', 28.0),
  ((select id from tt), 'LES INCOVENIENTS', 26.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Assurance Camion + Civil', 350.0, 1),
  ((select id from tt), 'Camion Crédit', 350.0, 2)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6),
  ((select id from tt), 'PAIEMENT COACH MARKA', 0, 'BEACH CAMP', 7),
  ((select id from tt), 'DECOUVERT', 0, '', 8)
  returning id)
select 1;

-- 25-janv-26
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('25-janv-26', '25-janv-26', 'autre', '2026-01-25', 10, 'cloture', true, 0, 0, 1608.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'TEAM ELIO', 24.0),
  ((select id from tt), 'JOWEL', 32.0),
  ((select id from tt), 'SARA DEL CAP HO', 24.0),
  ((select id from tt), 'VANILLE 3 CHOCOLATS', 32.0),
  ((select id from tt), 'JEAN CLANCHE', 32.0),
  ((select id from tt), 'IMPROBABLE', 32.0),
  ((select id from tt), 'MAISON BLANCHE PRIME', 32.0),
  ((select id from tt), 'AICE', 32.0),
  ((select id from tt), 'ON EST PAS NUL C''EST LE VENT manque 24', 32.0),
  ((select id from tt), 'AMERICAN POULET BRASIL', 32.0),
  ((select id from tt), 'A NOUS MEME LA FORCE 4 euros romain', 32.0),
  ((select id from tt), 'LES MANGEURS DE SABLES', 32.0),
  ((select id from tt), 'RASENGAN', 32.0),
  ((select id from tt), 'CROQUE MOI', 32.0),
  ((select id from tt), 'MAXIME TITU', 32.0),
  ((select id from tt), 'SURIMIX', 32.0),
  ((select id from tt), '2 BLACK AND 2 WHITE', 32.0),
  ((select id from tt), 'BOSS LADYYYYYY', 32.0),
  ((select id from tt), 'LES SEXE SONT D''ASSAUT', 32.0),
  ((select id from tt), 'CLAUDETTE ET SES GARCONS', 32.0),
  ((select id from tt), 'KD COLE', 32.0),
  ((select id from tt), 'TACOTACO', 32.0),
  ((select id from tt), 'GALINETTE', 32.0),
  ((select id from tt), 'LA OSTIA', 32.0),
  ((select id from tt), 'EN MODE MIGNON', 32.0),
  ((select id from tt), 'VOLCAN LA PETÉ', 32.0),
  ((select id from tt), 'ALEXI ET SES DROLES DAMES', 32.0),
  ((select id from tt), 'DERNIERE MINUTE', 32.0),
  ((select id from tt), 'CHINESE GANG', 32.0),
  ((select id from tt), 'TEAM CLOCLO', 32.0),
  ((select id from tt), 'PAS DE BEACH SANS FEU', 32.0),
  ((select id from tt), 'ARTHUR JOELLLLL', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Titi RCO', 200.0, 1),
  ((select id from tt), 'Assurance Camion + Civil', 400.0, 2),
  ((select id from tt), 'Camion Crédit', 150.0, 3),
  ((select id from tt), 'Divers', 250.0, 4)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6)
  returning id)
select 1;

-- 01-mars-26
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('01-mars-26', '01-mars-26', 'autre', '2026-03-01', 10, 'cloture', true, 0, 160.0, 1656.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'LES CHOUCHOU PRIM', 32.0),
  ((select id from tt), 'QLL QUE LA LOOSE - MANQUE 2 - mail envoyé', 16.0),
  ((select id from tt), 'ZORA ZOREIL', 32.0),
  ((select id from tt), 'ENTRE DEUX BONNE MAIN - MANQUE DEUX', 32.0),
  ((select id from tt), 'SMASHSMALLOW - MA,NQUE 1 EUROS', 32.0),
  ((select id from tt), 'MET CASQUE - Manque deux envoyé', 16.0),
  ((select id from tt), 'TEAM CREMOS - QUENTIN  envoyé', 8.0),
  ((select id from tt), 'KARASOUNOUN', 32.0),
  ((select id from tt), 'LES AGITÉ  DU FILET MIGNON', 32.0),
  ((select id from tt), 'LES 4 FANTASTIQUE', 32.0),
  ((select id from tt), 'LES RAZMOKET', 32.0),
  ((select id from tt), 'TEAM ELIO', 16.0),
  ((select id from tt), 'BEACH PLEASE', 32.0),
  ((select id from tt), 'SHARK DEFENSE', 32.0),
  ((select id from tt), 'TEAM PREMIER DEGRÉS - BOISSON OFFERT', 32.0),
  ((select id from tt), 'IPANEMA BEACH CLUB', 24.0),
  ((select id from tt), 'C''EST PAS NOUS C''EST LE SPOT', 32.0),
  ((select id from tt), 'DERIERE TOI MON COEUR', 32.0),
  ((select id from tt), 'LES STEPHS', 24.0),
  ((select id from tt), 'LES PITCHOUNE MOUSTACHU', 24.0),
  ((select id from tt), 'RCSG1 - MANQUE 1 ANNAEL', 24.0),
  ((select id from tt), 'LES DODOS VOLANTS', 32.0),
  ((select id from tt), 'LES DISSIPÉ', 32.0),
  ((select id from tt), 'WINTEAM -', 32.0),
  ((select id from tt), 'TORTUE MALGACHE', 32.0),
  ((select id from tt), 'SKIBIDI CHIEN PRANKEUR', 24.0),
  ((select id from tt), 'A L''AIDE', 32.0),
  ((select id from tt), 'LES 4 HOMARDS', 32.0),
  ((select id from tt), 'AIR FRANCE', 32.0),
  ((select id from tt), 'SMASH OR PASS', 32.0),
  ((select id from tt), 'TEAM BREDE', 32.0),
  ((select id from tt), 'LES PTI FILOU', 32.0),
  ((select id from tt), 'RCSG2', 32.0),
  ((select id from tt), 'LES INDÉCIS', 32.0),
  ((select id from tt), 'LES CHOUBIDOUX', 24.0),
  ((select id from tt), 'BOUCANÉ POULET', 24.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Revision Camion', 200.0, 1),
  ((select id from tt), 'DECOUVERT', 160.0, 2),
  ((select id from tt), 'Titi RCO', 200.0, 3),
  ((select id from tt), 'Assurance Camion + Civil', 150.0, 4),
  ((select id from tt), 'Videaste', 175.0, 5),
  ((select id from tt), 'Divers', 10.0, 6),
  ((select id from tt), 'Elio glacon etc', 25.0, 7),
  ((select id from tt), 'Biere fin', 20.0, 8),
  ((select id from tt), 'Maco Kev', 20.0, 9),
  ((select id from tt), 'Repas midi', 15.0, 10)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6)
  returning id)
select 1;

-- 28-mars-26
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('28-mars-26', '28-mars-26', 'autre', '2026-03-28', 10, 'cloture', true, 0, 0, 1776.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'LA TANTE ET LES TONTONS ( TERRAINS 1 )', 40.0),
  ((select id from tt), 'MAELLE ET LES 3 NAINS', 32.0),
  ((select id from tt), 'ON REVIENDRA', 24.0),
  ((select id from tt), 'DERIERE TOI MON COEUR', 32.0),
  ((select id from tt), 'CROQUER LA POMMES', 16.0),
  ((select id from tt), 'LUCCAS TU FAIS QUOI', 24.0),
  ((select id from tt), 'INSHALAH BLOC EN 2', 32.0),
  ((select id from tt), 'CHOUCHOU PRIME', 32.0),
  ((select id from tt), 'BEACHKINEBOTTOM', 32.0),
  ((select id from tt), 'PETITPOIDS', 32.0),
  ((select id from tt), 'ARRETE MENTIR', 32.0),
  ((select id from tt), 'MINIPOUSS', 32.0),
  ((select id from tt), 'LA MIXI TEAM', 16.0),
  ((select id from tt), 'LA GLACIERE', 32.0),
  ((select id from tt), 'IPENEMA BEACH TEAM', 32.0),
  ((select id from tt), 'orea double COUCHE', 32.0),
  ((select id from tt), 'SMASHSMALLOW', 32.0),
  ((select id from tt), 'CHUCK', 32.0),
  ((select id from tt), 'NORRIS', 32.0),
  ((select id from tt), 'LA CITÉ', 32.0),
  ((select id from tt), 'THE LAST ONE', 32.0),
  ((select id from tt), 'BAD GIRL', 32.0),
  ((select id from tt), 'SUSHISSON SEC', 32.0),
  ((select id from tt), 'NONO SOUS DEFRISSAGE', 32.0),
  ((select id from tt), 'HERTINE GARS FAIB', 32.0),
  ((select id from tt), 'HOMARD ET CHAMPAGNE', 32.0),
  ((select id from tt), 'BOOMBOCLAT', 32.0),
  ((select id from tt), 'LES MALGACHE MULTI COLORE', 32.0),
  ((select id from tt), 'LES PLI DANZÉREUX', 32.0),
  ((select id from tt), 'TEAM MASSON', 24.0),
  ((select id from tt), 'LES PRESQUE PROS', 32.0),
  ((select id from tt), 'AIR MAURITUS', 32.0),
  ((select id from tt), 'MILO PASSE A NANA', 32.0),
  ((select id from tt), 'LES CALAMARS', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Titi', 200.0, 1),
  ((select id from tt), 'Assurance Camion + Civil', 150.0, 2),
  ((select id from tt), 'CAMERAMN', 100.0, 3),
  ((select id from tt), 'ELIOT ( avance)', 30.0, 4),
  ((select id from tt), 'decouvert', 160.0, 5),
  ((select id from tt), 'Achat repas + boisson STAFF Samedi et dimanche soir', 160.0, 6),
  ((select id from tt), 'Achat buvette', 170.0, 7)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6)
  returning id)
select 1;

-- 01-mai-26
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('01-mai-26', '01-mai-26', 'autre', '2026-05-01', 10, 'cloture', true, 0, 0, 1656.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'pa la ek ou mwin', 32.0),
  ((select id from tt), 'FRAISITA LA TANA', 32.0),
  ((select id from tt), 'GUIGUI PRIME', 32.0),
  ((select id from tt), 'LA KIFFANCE', 32.0),
  ((select id from tt), 'reste branché', 32.0),
  ((select id from tt), 'winx', 32.0),
  ((select id from tt), 'au hasard', 32.0),
  ((select id from tt), 'LES IMPROBLABLE', 32.0),
  ((select id from tt), 'RESTE BRANCHÉ', 32.0),
  ((select id from tt), 'TEAM AGNES', 32.0),
  ((select id from tt), 'LES ZOUAVES', 32.0),
  ((select id from tt), 'LES CREVETTES', 32.0),
  ((select id from tt), 'FILET GARNI', 32.0),
  ((select id from tt), 'TEAM SAUSSEAU', 32.0),
  ((select id from tt), 'CABOTS SAUTEUR', 32.0),
  ((select id from tt), 'GRYFONDOR', 32.0),
  ((select id from tt), 'LA FRAPPE', 32.0),
  ((select id from tt), 'OBJECTIF BOUGIE', 32.0),
  ((select id from tt), 'TITI A LA PASSE', 32.0),
  ((select id from tt), 'ENTRE DE BONNE MAINS', 32.0),
  ((select id from tt), 'MOINEAU BLANC', 32.0),
  ((select id from tt), 'TEAM DUBUISSON', 32.0),
  ((select id from tt), 'LES IMPROVISÉ', 32.0),
  ((select id from tt), 'TEAM MALLET', 32.0),
  ((select id from tt), 'BOUCAN EN PETARD', 32.0),
  ((select id from tt), 'TEAM KIARA', 32.0),
  ((select id from tt), 'LA BAGARRE', 32.0),
  ((select id from tt), 'TWO BOY ISA CUP', 32.0),
  ((select id from tt), 'DOUNG THUG', 32.0),
  ((select id from tt), 'TRIPLE MENACE AU FILET', 32.0),
  ((select id from tt), 'RUSKY PRIME', 32.0),
  ((select id from tt), 'LES PETITS CHATS', 32.0),
  ((select id from tt), 'MAMIE ET LES GOSS', 32.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Achat buvette', 120.0, 1),
  ((select id from tt), 'Assurance Camion + Civil', 150.0, 2),
  ((select id from tt), 'PETITBOOTJ', 80.0, 3),
  ((select id from tt), 'AIDE ELIOT', 50.0, 4)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6)
  returning id)
select 1;

-- 01/05/2026 4MAN 4WOMAN
with tt as (
  insert into public.tournois (nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)
  values ('01/05/2026 4MAN 4WOMAN', '01-05-2026-4man-4woman', '4x4', '2026-05-01', 10, 'cloture', true, 0, 0, 840.0)
  returning id
)
, ins_eq as (
  insert into public.equipes (tournoi_id, nom, montant_historique) values
  ((select id from tt), 'Polo dans le sac à dos', 40.0),
  ((select id from tt), 'dave et ses poulets', 40.0),
  ((select id from tt), 'les bronzer font du beach', 40.0),
  ((select id from tt), 'tu sens l''aura', 40.0),
  ((select id from tt), 'backbakebouda', 40.0),
  ((select id from tt), 'entre debonne mains', 40.0),
  ((select id from tt), 'isac i vole', 40.0),
  ((select id from tt), '1 noir 3 blanc', 40.0),
  ((select id from tt), 'les planteurs de choux', 40.0),
  ((select id from tt), 'LES DELIDELO', 40.0),
  ((select id from tt), 'OPÉE', 40.0),
  ((select id from tt), 'LBERTÉ EGALITÉ MBAPPE', 40.0),
  ((select id from tt), 'FC CHOMMEUR', 40.0),
  ((select id from tt), 'SAUTÉ MINES', 40.0),
  ((select id from tt), '4 PTIT PIPES', 40.0),
  ((select id from tt), 'ACE ANGELS', 40.0),
  ((select id from tt), 'OREO MAX', 40.0),
  ((select id from tt), 'TEAM PROJET', 40.0),
  ((select id from tt), 'SALADE DE FRUITS', 40.0),
  ((select id from tt), 'TU FAUTES TU TWERK', 40.0),
  ((select id from tt), 'LES POUFIASSES', 40.0)
  returning id), ins_ac as (
  insert into public.achats_divers (tournoi_id, description, montant, position) values
  ((select id from tt), 'Achat buvette', 0, 1),
  ((select id from tt), 'Assurance Camion + Civil', 0, 2),
  ((select id from tt), 'PETITBOOTJ', 0, 3),
  ((select id from tt), 'AIDE ELIOT', 0, 4)
  returning id), ins_fr as (
  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values
  ((select id from tt), 'Assurance Camion + Civil', 0, 'Camion + Protection participants', 1),
  ((select id from tt), 'Abonnement Canva', 0, 'Création des visuel de l''association', 2),
  ((select id from tt), 'Abonnement Cap cut', 0, 'Montage video pour communication', 3),
  ((select id from tt), 'Abonnement CHAT GPT', 0, 'Analyse, creation de texte, conseil', 4),
  ((select id from tt), 'Abonnement KREA.AI', 0, 'Outil IA pour visuel, photos.', 5),
  ((select id from tt), 'Camion Crédit', 0, 'Transport / stockage', 6)
  returning id)
select 1;

commit;