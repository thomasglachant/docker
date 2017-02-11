FROM nginx:1.11

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/symfony.conf /etc/nginx/conf.d/symfony.conf

# Set user for permissions
RUN usermod -u 1000 www-data
