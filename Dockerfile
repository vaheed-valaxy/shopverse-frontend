# ------------------------------------------------------
# Stage: 1  Build the React App
# ------------------------------------------------------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install

COPY . .

ARG VITE_API_URL=""
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# ------------------------------------------------------
# Stage: 2  Copy the Built artifact
# ------------------------------------------------------
FROM nginx:stable-alpine
RUN apk upgrade --no-cache

# Remove default index and default server
RUN rm -f \
    /usr/share/nginx/html/index.html \
    /etc/nginx/conf.d/default.conf 

# Prepare directories for non-root nginx
RUN mkdir -p \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    /run \
    /etc/nginx/ssl \
  && chown -R nginx:nginx \
    /var/cache/nginx \
    /var/log/nginx \
    /etc/nginx \
    /run \
  && chmod -R 755 /etc/nginx
  
# Copy dist folder contents
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# Copy custom NGINX config
COPY conf/shopverse.conf /etc/nginx/conf.d/shopverse.conf

# Ensure config file permissions
RUN chmod 644 /etc/nginx/conf.d/*.conf

EXPOSE 8080

# UID: 101 for 'nginx' user
USER nginx      

CMD ["nginx", "-g", "daemon off;"]
