INSERT INTO bi_schema.dim_date (date_publication, annee, mois, trimestre)
SELECT DISTINCT
    date_publication,
    annee_publication,
    mois_publication,
    trimestre_publication
FROM clean.annonces_clean;

INSERT INTO bi_schema.dim_localisation (ville, quartier)
SELECT DISTINCT
    ville,
    quartier
FROM clean.annonces_clean;


INSERT INTO bi_schema.dim_bien (
    type_bien,
    nb_chambres,
    nb_salles_bain,
    etage,
    annee_construction,
    age_bien,
    categorie_surface
)
SELECT DISTINCT
    type_bien,
    nb_chambres,
    nb_salles_bain,
    etage,
    annee_construction,
    age_bien,
    categorie_surface
FROM clean.annonces_clean;

INSERT INTO bi_schema.dim_transaction (
    transaction,
    categorie_prix
)
SELECT DISTINCT
    transaction,
    categorie_prix
FROM clean.annonces_clean;

SELECT COUNT(*) FROM bi_schema.dim_date;
SELECT COUNT(*) FROM bi_schema.dim_localisation;
SELECT COUNT(*) FROM bi_schema.dim_bien;
SELECT COUNT(*) FROM bi_schema.dim_transaction;



CREATE INDEX IF NOT EXISTS idx_dim_date_date_publication
ON bi_schema.dim_date (date_publication);

CREATE INDEX IF NOT EXISTS idx_dim_localisation_ville
ON bi_schema.dim_localisation (ville);

CREATE INDEX IF NOT EXISTS idx_dim_localisation_quartier
ON bi_schema.dim_localisation (quartier);

CREATE INDEX IF NOT EXISTS idx_dim_bien_type_bien
ON bi_schema.dim_bien (type_bien);

CREATE INDEX IF NOT EXISTS idx_dim_transaction_transaction
ON bi_schema.dim_transaction (transaction);