FROM ruby:3.1.0 

WORKDIR /app

# install node 16
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler  &&\
  bundle config set path /usr/local/bundle/
RUN bundle install

# install node modules
COPY package.json yarn.lock ./
RUN yarn install 

COPY run.sh ./
RUN chmod +x run.sh

COPY . ./

EXPOSE 3000 3000

CMD ["./run.sh", "server"]
