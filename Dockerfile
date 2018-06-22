FROM brainbeanapps/base-linux-build-environment:latest

LABEL maintainer="devops@brainbeanapps.com"

# Switch to root
USER root

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
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
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash - \
  && source "/home/user/.nvm/nvm.sh" \
  && nvm install lts/* && npm install -g npm@latest \
  && nvm install lts/argon && npm install -g npm@latest \
  && nvm install lts/boron && npm install -g npm@latest \
  && nvm install lts/carbon && npm install -g npm@latest \
  && nvm install node && npm install -g npm@latest \
  && nvm use node
