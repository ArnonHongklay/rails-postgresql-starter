FROM ubuntu:20.04
FROM ruby:2.7.0
RUN apt-get update -qq && apt-get install -y build-essential software-properties-common sudo libpq-dev nodejs

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo add-apt-repository ppa:chris-lea/redis-server
RUN apt update -y && apt install yarn -y
RUN sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars
RUN exec $SHELL
RUN rbenv install 2.7.0
RUN rbenv global 2.7.0
RUN ruby -v
RUN gem install bundler
RUN gem install bundler -v 1.17.3
RUN bundle -v

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update
RUN apt-get install -y nginx-extras libnginx-mod-http-passenger
RUN if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
RUN ls /etc/nginx/conf.d/mod-http-passenger.conf
