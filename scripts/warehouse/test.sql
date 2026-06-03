SELECT COUNT(*) FROM bi_schema.dim_date;
SELECT COUNT(*) FROM bi_schema.dim_localisation;
SELECT COUNT(*) FROM bi_schema.dim_bien;
SELECT COUNT(*) FROM bi_schema.dim_transaction;
SELECT COUNT(*) FROM bi_schema.fact_annonces;


SELECT COUNT(*)
FROM bi_schema.fact_annonces f
LEFT JOIN bi_schema.dim_date d ON f.date_id = d.date_id
LEFT JOIN bi_schema.dim_localisation l ON f.localisation_id = l.localisation_id
LEFT JOIN bi_schema.dim_bien b ON f.bien_id = b.bien_id
LEFT JOIN bi_schema.dim_transaction t ON f.transaction_id = t.transaction_id
WHERE d.date_id IS NULL
   OR l.localisation_id IS NULL
   OR b.bien_id IS NULL
   OR t.transaction_id IS NULL;

   SELECT *
FROM bi_schema.fact_annonces
WHERE prix <= 0
   OR surface <= 0
   OR prix_m2 <= 0;

   SELECT COUNT(*) FROM clean.annonces_clean;
SELECT COUNT(*) FROM bi_schema.fact_annonces;