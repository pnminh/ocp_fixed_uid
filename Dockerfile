FROM registry.redhat.io/ubi7/ubi
# Add the user UID:1000, GID:1000, home at /app
ENV HOME=/app \
    APP_ROOT=/app
WORKDIR ${HOME}
RUN useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
  chown -R 1001:0 ${APP_ROOT}
USER 1001