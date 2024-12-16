#Build from a official Node image 
FROM node:14 AS build 

#Defines the working directory
WORKDIR /app

#Copy .json inside the container
COPY package*.json ./

#Install Dependecies
RUN npm install     

#Copy the rest of the files 
COPY . .

#Compiling the app
RUN npm run build 

# Serving the static files with Nginx 
FROM nginx:alpine

# Copy the build files to the default nginx directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the default nginx port
EXPOSE 80

# Command to start the nginx server and not let it run in the background
CMD ["nginx", "-g", "daemon off;"]