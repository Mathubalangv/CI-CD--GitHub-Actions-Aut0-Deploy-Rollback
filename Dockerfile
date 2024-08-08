# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json from myapp directory
COPY myapp/package*.json ./

RUN npm install

# Copy source code and static files from myapp directory
COPY myapp/src/ src/
COPY myapp/public/ public/

# Build the React app
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the built app from the build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

