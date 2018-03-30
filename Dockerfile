FROM brainbeanapps/base-build-environment:latest

LABEL maintainer="devops@brainbeanapps.com"

WORKDIR /opt
COPY . .

# Install nvm and multiple Node.js/npm versions
ENV NVM_DIR /opt/nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && source "${NVM_DIR}/nvm.sh" \
  && nvm install lts/* \
  && nvm install lts/argon \
  && nvm install lts/boron \
  && nvm install lts/carbon \
  && nvm install node \
  && nvm use node

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
