### STAGE 1: Build ###
#################################################################################################################
# # We label our stage as ‘builder’
# FROM node:10-alpine as builder
# COPY package.json package-lock.json ./
# ## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
# RUN npm ci 
# RUN mkdir /demococker 
# RUN mv ./node_modules ./demococker

# WORKDIR /demococker
# COPY . .

# ## Build the angular app in production mode and store the artifacts in dist folder
# RUN npm run ng build -- --prod --output-path=dist
#################################################################################################################
# ### STAGE 2: Setup ###
# FROM nginx:1.14.1-alpine
# ## Copy our default nginx config
# COPY nginx/default.conf /etc/nginx/conf.d/
# ## Remove default nginx website
# RUN rm -rf /usr/share/nginx/html/*
# ## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
# COPY --from=builder /demococker/dist /usr/share/nginx/html

# #CMD ["nginx", "-g", "daemon off;"]
#################################################################################################################
# # base image
# FROM node:12.2.0

# # install chrome for protractor tests
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
# RUN apt-get update && apt-get install -yq google-chrome-stable

# # set working directory
# WORKDIR /app

# # add `/app/node_modules/.bin` to $PATH
# ENV PATH /app/node_modules/.bin:$PATH

# # install and cache app dependencies
# COPY package.json /app/package.json
# RUN npm install
# RUN npm install -g @angular/cli@7.3.9

# # add app
# COPY . /app

# # start app
# CMD ng serve --host 0.0.0.0
#################################################################################################################
# FROM debian:stable-slim

# RUN apt-get update
# RUN apt-get install -yy wget curl gnupg
# RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
# 	apt-get update && apt-get install -y nodejs && \
#   npm i -g npm@6

# RUN node -v && npm -v

# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#   echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
#   apt-get update && \
#   apt-get install -y google-chrome-stable xvfb
# RUN npm -v
# RUN apt update && apt install -y procps
# RUN apt clean
# RUN rm -rf /var/lib/apt/lists/*
# CMD ng serve --host 0.0.0.0
#################################################################################################################
# base image
FROM node:12.2.0

# install chrome for protractor tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -yq google-chrome-stable

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install
RUN npm install -g @angular/cli@7.3.9

# add app
COPY . /app

# start app
CMD ng serve --host 0.0.0.0
#################################################################################################################