# server/Dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
ENV PORT=5000 NODE_ENV=production
EXPOSE 5000
# The app should read ATLAS_URI from env and start on PORT
CMD ["node", "server.js"]
