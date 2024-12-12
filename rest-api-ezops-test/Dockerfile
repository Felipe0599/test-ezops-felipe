# Build from a official Node image
FROM node:14

#Defines the working directory
WORKDIR /usr/src/app

#Copy .json inside the container
COPY package*.json ./

#Install Dependecies
RUN npm install

#Copy the rest of the files 
COPY . .

# Expose the port 
EXPOSE 3000

# Command to start the server
CMD ["node", "server/server.js"]
