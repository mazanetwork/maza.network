# Run maza web from IPFS web gateway

## Letsencrypt SSL Certificate
This uses letsencrypt's certbot docker image and nginx to acquire 
an SSL certificate for your site

We include a single-use nginx site config to get the first SSL cert if 
you don't have one from LE




## IPFS
the docker-compose.yml includes an ipfs node 
we use this to provide a secure gateway from nginx to ipfs


## nginx 

   - Change the hostname in 5 places  in conf.d/default.conf
   - change hostname in conf.nossl/default.conf

 
