# client/Dockerfile
FROM node:20-alpine AS build
WORKDIR /app

# Build-time API base (Create React App reads REACT_APP_* at build time)
ARG REACT_APP_YOUR_HOSTNAME
ENV REACT_APP_YOUR_HOSTNAME=${REACT_APP_YOUR_HOSTNAME}

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Serve the static build
FROM node:20-alpine
WORKDIR /app
RUN npm i -g serve
COPY --from=build /app/build ./build
ENV PORT=3000
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
