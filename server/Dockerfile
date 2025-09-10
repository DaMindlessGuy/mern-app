# Step 1: Use an official Node.js image as the base image
FROM node:16-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to the container
COPY package*.json ./

# Step 4: Install the dependencies inside the container
RUN npm install

# Step 5: Copy all files from the local directory to the container
COPY . .

# Step 6: Expose the API port (5000)
EXPOSE 5000

# Step 7: Set environment variables. TODO is to make this automatic here and for the client
ENV PORT=5000
ENV NODE_ENV=production
ENV ATLAS_URI="mongodb://root:password@mongo:27017/database?authSource=admin"

# Step 8: Start the API server
CMD ["npm", "start"]
