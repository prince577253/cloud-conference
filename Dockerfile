# Use official lightweight Nginx image
FROM nginx:alpine

# Copy custom Nginx configuration if needed
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copy static website files to the default Nginx public folder
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Add a basic healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O /dev/null http://localhost:80/ || exit 1

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
