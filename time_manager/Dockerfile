# FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim AS builder

# RUN apt-get update -y && apt-get install -y build-essential git make \
#     && apt-get clean && rm -f /var/lib/apt/lists/*_*

# WORKDIR /app

# RUN mix local.hex --force && mix local.rebar --force

# ENV MIX_ENV="prod"

# COPY mix.exs mix.lock ./
# RUN mix deps.get --only $MIX_ENV


# RUN mkdir config

# COPY config/config.exs config/${MIX_ENV}.exs config/
# RUN mix deps.clean bcrypt_elixir && mix deps.get --only $MIX_ENV
# RUN mix deps.compile

# COPY priv priv
# COPY lib lib

# RUN mix compile

# RUN mix release

# # Ajout d'une commande pour déboguer
# RUN ls -la /app/_build/prod/rel/

# FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim

# RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates postgresql-client \
#     && apt-get clean && rm -f /var/lib/apt/lists/*_*

# RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# WORKDIR "/app"

# ENV MIX_ENV="prod"

# RUN mix local.hex --force && mix local.rebar --force

# COPY --from=builder /app/_build/prod/rel/ ./

# CMD ["/app/bin/server"]

# Phase 1: Builder
FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim AS builder

# Installer make, gcc, libgmp-dev et d'autres outils nécessaires
RUN apt-get update -y && apt-get install -y build-essential git make gcc libgmp-dev \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Vérifier que 'make' est bien installé
RUN which make

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV="prod"

#COPY mix.exs mix.lock ./
COPY mix.exs ./
RUN mix deps.get --only $MIX_ENV

# Ajouter les fichiers de configuration
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/

# Nettoyer et compiler bcrypt_elixir
#RUN mix deps.clean bcrypt_elixir && mix deps.compile bcrypt_elixir

# Compiler le projet
COPY priv priv
COPY lib lib
RUN mix compile

# Générer la release
RUN mix release

# Debug: lister les fichiers dans la release
RUN ls -la /app/_build/prod/rel/

# Phase 2: Runner
FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-bullseye-20230612-slim

# Installer make et d'autres dépendances nécessaires
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates postgresql-client \
    build-essential make \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Vérifier que 'make' est bien installé dans cette phase également
RUN which make

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"

ENV MIX_ENV="prod"

RUN mix local.hex --force && mix local.rebar --force

COPY --from=builder /app/_build/prod/rel/ ./

CMD ["/app/bin/server"]
