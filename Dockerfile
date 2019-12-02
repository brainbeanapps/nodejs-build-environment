FROM brainbeanapps/base-linux-build-environment:v3.0.0

LABEL maintainer="devops@brainbeanapps.com"

# Switch to root
USER root

# Set shell as non-interactive during build
# NOTE: This is discouraged in general, yet we're using it only during image build
ARG DEBIAN_FRONTEND=noninteractive

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g npm@latest

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Switch to user
USER user
WORKDIR /home/user

# Install nvm and multiple Node.js/npm versions
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash \
  && source "/home/user/.nvm/nvm.sh" \
  && nvm install lts/* && npm install -g npm@latest \
  && nvm install lts/argon && npm install -g npm@latest \
  && nvm install lts/boron && npm install -g npm@latest \
  && nvm install lts/carbon && npm install -g npm@latest \
  && nvm install lts/dubnium && npm install -g npm@latest \
  && nvm install lts/erbium && npm install -g npm@latest \
  && nvm install stable && npm install -g npm@latest \
  && nvm install node && npm install -g npm@latest \
  && nvm use --lts node
