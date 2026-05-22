-- Active: 1779180796409@@127.0.0.1@5432
-- Active: 1772540042326@@localhost@5432-- Active: 1772540042326@@localhost@5432

CREATE SCHEMA IF NOT EXISTS staging;

-- 1. Création de la table brute
CREATE TABLE IF NOT EXISTS staging.annonces_raw (
    annonce_id TEXT,
    date_publication TEXT,
    titre TEXT,
    ville TEXT,
    quartier TEXT,
    type_bien TEXT,
    transaction TEXT,
    prix TEXT,
    surface TEXT,
    nb_chambres TEXT,
    nb_salles_bain TEXT,
    etage TEXT,
    annee_construction TEXT,
    source_file TEXT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Création de la table de log
CREATE TABLE IF NOT EXISTS staging.load_log (
    log_id SERIAL PRIMARY KEY,
    source_file TEXT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rows_loaded INT,
    status TEXT,
    message TEXT
);

-- 3. Vider la table avant nouveau chargement
TRUNCATE TABLE staging.annonces_raw;

-- 4. Charger le CSV
copy staging.annonces_raw (
    annonce_id,
    date_publication,
    titre,
    ville,
    quartier,
    type_bien,
    transaction,
    prix,
    surface,
    nb_chambres,
    nb_salles_bain,
    etage,
    annee_construction
)
FROM 'C:/Users/user/Documents/New project/data/raw/darkom_listings.csv'
DELIMITER ','
CSV HEADER;

-- 5. Mettre à jour les colonnes techniques
UPDATE staging.annonces_raw
SET source_file = 'darkom_listings.csv'
WHERE source_file IS NULL;

-- 6. Enregistrer le chargement dans les logs
INSERT INTO staging.load_log (
    source_file,
    rows_loaded,
    status,
    message
)
VALUES (
    'darkom_listings.csv',
    (SELECT COUNT(*) FROM staging.annonces_raw),
    'SUCCESS',
    'Chargement du fichier CSV dans staging.annonces_raw'
);

-- 7. Vérifications
SELECT COUNT(*) AS total_rows
FROM staging.annonces_raw;

SELECT *
FROM staging.annonces_raw
LIMIT 10;

SELECT COUNT(*) AS null_annonce_id
FROM staging.annonces_raw
WHERE annonce_id IS NULL;

SELECT annonce_id, COUNT(*) AS nb_occurrences
FROM staging.annonces_raw
GROUP BY annonce_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_ville
FROM staging.annonces_raw
WHERE ville IS NULL;

SELECT COUNT(*) AS null_prix
FROM staging.annonces_raw
WHERE prix IS NULL;