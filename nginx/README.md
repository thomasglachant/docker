# Images nginx

Image basée sur l'image nginx permettant d'utiliser un PHP-fpm.

On peut modifier (ou surcharger) les fichiers de configuration suivants : 
* nginx.conf : fichier de configuration général
* symfony.conf : fichier contenant les bases d'un virtualhost symfony 2/3

## Pré-requis 

* Pour fonctionner on doit donner en lien à cette image un container php-fpm nommé : "fpm"
* On doit faire pointer la racine du site internet dans : "/var/www/symfony/web"

## Usage

Exemple de configuration docker-compose :
```
nginx:
    image: "thomasglachant/docker:nginx1.11"
    depends_on:
       - web
    ports:
        - "8000:80"
    links:
        - web:fpm
    volumes:
        - "./:/var/www/symfony/web"
```
