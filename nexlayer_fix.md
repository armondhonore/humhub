Use the committed root Dockerfile as-is. Do NOT regenerate it or run language auto-detection.
It is FROM mriedmann/humhub:stable with all HUMHUB_DB_* and install settings baked as ENV so the
entrypoint reads clean values (the platform's yaml `vars` ${VAR} substitution appended a stray '}'
to the port, producing `nc: bad port '3306}'`). The app pod uses the pipeline-built image; the db
pod is mariadb:11 reachable at humhub-db-service:3306. Keep the app image as the pipeline-built one.
