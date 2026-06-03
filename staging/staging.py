import pandas as pd
import psycopg2
import logging
import os
import traceback
from sqlalchemy import create_engine, text

# Création du dossier logs
os.makedirs("logs", exist_ok=True)

logging.basicConfig(
    filename="logs/staging.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# Paramètres PostgreSQL
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("POSTGRES_DB", "darkom_dwh")
DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "assia123")
DB_PORT = os.getenv("DB_PORT", "5432")

try:
    # Création de l'engine
    engine = create_engine(
        f"postgresql+psycopg2://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )

    # Test de connexion
    with engine.connect() as conn:
        print("Connexion PostgreSQL OK")

        result = conn.execute(text("SELECT current_database();"))
        print("Base de données :", result.fetchone()[0])

        schema_check = conn.execute(text("""
            SELECT schema_name
            FROM information_schema.schemata
            WHERE schema_name = 'staging'
        """))

        if schema_check.fetchone() is None:
            raise Exception("Le schéma 'staging' n'existe pas dans la base de données.")

    # Chargement du fichier CSV
    file_path = "darkom-annonces.csv"

    if not os.path.exists(file_path):
        raise FileNotFoundError(file_path)

    df = pd.read_csv(file_path)

    print(f"CSV chargé avec succès : {len(df)} lignes")

    logging.info(f"CSV chargé : {file_path}")
    logging.info(f"Nombre de lignes : {len(df)}")

    # Insertion dans PostgreSQL
    df.to_sql(
        name="annonces_raw",
        con=engine,
        schema="staging",
        if_exists="append",
        index=False
    )

    print("Insertion terminée avec succès")
    logging.info("Insertion réussie dans staging.annonces_raw")

except FileNotFoundError as e:
    print(f"Fichier introuvable : {e}")
    logging.error(f"Fichier introuvable : {e}")

except psycopg2.Error as e:
    print("Erreur PostgreSQL :")
    print(repr(e))
    logging.exception(e)

except Exception as e:
    print("Erreur :")
    traceback.print_exc()
    logging.exception(e)