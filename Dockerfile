FROM elixir:1.9.1-alpine

ARG destination=/opt/app-root
ARG scripts=/usr/local/s2i
ENV scripts_path=${scripts}
ENV src_path=${destination}
ENV MIX_HOME=${destination}

LABEL maintainer="Sepehr Ansaripour <sansaripour@ata-llc.com>" \
      io.k8s.description="Platform for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"

# Install node/npm
RUN apk add --update npm

# Configure s2i
LABEL io.openshift.s2i.scripts-url=image://${scripts} \
      io.openshift.s2i.destination="${destination}"

# Create the app dir
RUN mkdir -p  ${destination}/src && adduser -S default -u 1001 -G root -h ${destination} && chown -R default:root ${destination}

# Copy scripts
COPY --chown=default:root ./s2i/bin/ ${scripts}

# Set permissions
RUN chmod a+x -R /usr/local/s2i && chmod a+rwx -R ${destination}

USER 1001

EXPOSE 4000

WORKDIR ${destination}/src

CMD ["${scripts}/usage"]
