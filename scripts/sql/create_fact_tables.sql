-- Active: 1779180796409@@127.0.0.1@5432@darkom_dwh
-- Active: 1772540042326@@localhost@5432-- Active: 1772540042326@@localhost@5432-- Active: 1772540042326@@localhost@5432
INSERT INTO bi_schema.fact_annonces (
    annonce_id,
    date_id,
    localisation_id,
    bien_id,
    transaction_id,
    prix,
    surface,
    prix_m2
)
SELECT
    c.annonce_id,
    d.date_id,
    l.localisation_id,
    b.bien_id,
    t.transaction_id,
    c.prix,
    c.surface,
    c.prix_m2
FROM clean.annonces_clean c
JOIN bi_schema.dim_date d
    ON c.date_publication = d.date_publication
JOIN bi_schema.dim_localisation l
    ON c.ville = l.ville
   AND c.quartier = l.quartier
JOIN bi_schema.dim_bien b
    ON c.type_bien = b.type_bien
   AND c.nb_chambres = b.nb_chambres
   AND c.nb_salles_bain = b.nb_salles_bain
   AND c.etage = b.etage
   AND c.annee_construction = b.annee_construction
   AND c.age_bien = b.age_bien
   AND c.categorie_surface = b.categorie_surface
JOIN bi_schema.dim_transaction t
    ON c.transaction = t.transaction
   AND c.categorie_prix = t.categorie_prix;

CREATE INDEX idx_fact_annonces_annonce_id
ON bi_schema.fact_annonces (annonce_id);

CREATE INDEX idx_fact_annonces_date_id
ON bi_schema.fact_annonces (date_id);

CREATE INDEX idx_fact_annonces_localisation_id
ON bi_schema.fact_annonces (localisation_id);

CREATE INDEX idx_fact_annonces_bien_id
ON bi_schema.fact_annonces (bien_id);

CREATE INDEX idx_fact_annonces_transaction_id
ON bi_schema.fact_annonces (transaction_id);


