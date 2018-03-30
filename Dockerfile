FROM ubuntu:xenial

LABEL maintainer="devops@brainbeanapps.com"

WORKDIR /opt
COPY . .

# Use bash instead of sh (see https://github.com/eromoe/docker/commit/7dccc72bb24c715f176e4980ab59fd7aeb149a5f)
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# There's no terminal attached
ARG DEBIAN_FRONTEND=noninteractive

# Base tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils wget curl zip build-essential ca-certificates apt-transport-https \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN apt-get update \
  && apt-get install -y --no-install-recommends locales \
  && apt-get install -y --no-install-recommends locales-all \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN update-locale LANG=en_US.UTF-8

# Extra tools
RUN mkdir -p /opt/bin
ENV PATH="/opt/bin:${PATH}"

# Install repo tool
RUN mkdir -p /opt/bin \
  && wget https://storage.googleapis.com/git-repo-downloads/repo -O /opt/bin/repo -q \
  && chmod +x /opt/bin/repo

# Install nvm and multiple Node.js/npm versions
ENV NVM_DIR /opt/nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && source "${NVM_DIR}/nvm.sh" \
  && nvm install node \
  && nvm install lts/* \
  && nvm install lts/argon \
  && nvm install lts/boron \
  && nvm install lts/carbon \
  && nvm use node

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
