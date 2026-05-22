CREATE SCHEMA IF NOT EXISTS bi_schema;

DROP TABLE IF EXISTS bi_schema.fact_annonces CASCADE;
DROP TABLE IF EXISTS bi_schema.dim_date CASCADE;
DROP TABLE IF EXISTS bi_schema.dim_localisation CASCADE;
DROP TABLE IF EXISTS bi_schema.dim_bien CASCADE;
DROP TABLE IF EXISTS bi_schema.dim_transaction CASCADE;

CREATE TABLE bi_schema.dim_date (
    date_id SERIAL PRIMARY KEY,
    date_publication DATE,
    annee INT,
    mois INT,
    trimestre INT
);

CREATE TABLE bi_schema.dim_localisation (
    localisation_id SERIAL PRIMARY KEY,
    ville TEXT,
    quartier TEXT
);

CREATE TABLE bi_schema.dim_bien (
    bien_id SERIAL PRIMARY KEY,
    type_bien TEXT,
    nb_chambres NUMERIC,
    nb_salles_bain NUMERIC,
    etage NUMERIC,
    annee_construction NUMERIC,
    age_bien NUMERIC,
    categorie_surface TEXT
);

CREATE TABLE bi_schema.dim_transaction (
    transaction_id SERIAL PRIMARY KEY,
    transaction TEXT,
    categorie_prix TEXT
);

CREATE TABLE bi_schema.fact_annonces (
    fact_id SERIAL PRIMARY KEY,
    annonce_id TEXT,
    date_id INT REFERENCES bi_schema.dim_date(date_id),
    localisation_id INT REFERENCES bi_schema.dim_localisation(localisation_id),
    bien_id INT REFERENCES bi_schema.dim_bien(bien_id),
    transaction_id INT REFERENCES bi_schema.dim_transaction(transaction_id),
    prix NUMERIC(14,2),
    surface NUMERIC(10,2),
    prix_m2 NUMERIC(14,2)
);