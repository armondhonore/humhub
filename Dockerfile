FROM mriedmann/humhub:stable
ENV HUMHUB_DB_HOST=humhub-db-service \
    HUMHUB_DB_PORT=3306 \
    HUMHUB_DB_NAME=humhub \
    HUMHUB_DB_USER=root \
    HUMHUB_DB_PASSWORD=humhubRootPass2026 \
    HUMHUB_AUTO_INSTALL=true \
    HUMHUB_PROTO=https \
    HUMHUB_HOST=relaxed-weasel-humhub.cloud.nexlayer.ai \
    HUMHUB_ADMIN_LOGIN=admin \
    HUMHUB_ADMIN_EMAIL=admin@example.com \
    HUMHUB_ADMIN_PASSWORD=NexlayerAdmin2026 \
    INTEGRITY_CHECK=0 \
    WAIT_FOR_DB=1
