# BASE IMAGE (HUB-STORE)
FROM node:12.2.0

# INSTALL CHROME FOR PROTRACTOR TESTS
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -yq google-chrome-stable

# SET WORKING DIRECTORY
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH   

# INSTALL & CACHE APP DEPENDANCIES
COPY package.json /app/package.json
RUN npm install
RUN npm install @angular/cli@7.3.9

# MOVE APPLICATION TO (HUB-IMAGE)
COPY . /app

# START DOCKER COMMANDS
# CMD ng serve --host localhost
# CMD ng serve --host localhost --port 4200 --disableHostCheck=true --poll 100  
# CMD ng lint

CMD ["ng","serve","--host", "localhost"]

 # EXPOSE 2500
# ###################################################################################################################
