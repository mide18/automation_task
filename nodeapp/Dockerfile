# Base image
FROM node:14
# working directory in the container
WORKDIR /usr/app
# copy the file to present working directory
COPY package.json .
# install dependencies
RUN npm install
# copy all files from app to docker image
COPY . .
# expose port 8080
EXPOSE 8080
# run the cmd 
CMD [ "node", "app.js" ]
