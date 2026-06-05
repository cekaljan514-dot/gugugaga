FROM php:8.3-apache

# Instalace PHP extenzí pro MySQL (PDO i klasické mysqli)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Povolení mod_rewrite pro Apache (vhodné pro čistá URL / routery)
RUN a2enmod rewrite

# Kopírování zdrojových kódů do kontejneru
COPY src/ /var/www/html/

# Nastavení správných práv pro webový server
RUN chown -R www-data:www-data /var/www/html