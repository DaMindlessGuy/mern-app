# Step 1: Use an official Node.js image for the frontend
FROM node:16-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json
COPY package*.json ./

# Step 4: Install dependencies for React app
RUN npm install

# Step 5: Copy the rest of the frontend application code into the container
COPY . .

# Step 6: Build the React application for production
RUN npm run build

# Step 7: Install a lightweight HTTP server to serve the built React app
RUN npm install -g serve

# Step 8: Expose port 3000 (default port for React app)
EXPOSE 3000

# Step 9: Start the server to serve the React app. Hardcoded copy of /.env because lazy
ENV REACT_APP_YOUR_HOSTNAME="http://localhost:5000" 
CMD ["serve", "-s", "build", "-l", "3000"]
