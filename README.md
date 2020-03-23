# NetworkSecurity

# Application overview
## Server (on RPI4B)
On the server side, we choose Nginx as HTTP Server and this is hosted on the RPI4B.Nginx is a web server which can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.
## Client (on VM)
For the client side, we used privoxy as a forward proxy client, which routes the traffic from the user to HTTP Server.Privoxy is a non-caching web proxy with advanced filtering capabilities for enhancing privacy, modifying web page data and HTTP headers, controlling access, and removing ads and other obnoxious Internet junk. Privoxy has a flexible configuration and can be customized to suit individual needs and tastes. It has application for both stand-alone systems and multi-user networks
# Build environments
## Server (on VM)
* Instructions for building Docker container
  * We need to selet the Ubuntu 18.04 base image
  * Need to update and upgrade using the commands `RUN apt-get update RUN apt-get upgrade -y`
  * To build nginx from the sources, we need to copy the build_nginx script to the destination folder.
  * Final Dockerfile is available [Dockerfile](Server/Build/Dockerfile)
* Instructions for running build scripts in container
  * Build nginx script can be found [here](Server/build_nginx.sh)
  * Step 1 is to install all dependencies including `binutils, build-essential, curl, dirmngr, libssl-dev`
  * Step 2 is to install OpenPGP Keys for custom source installation.
  * Next, download the nginx sources from the official website.
  * For all the tarballs, extract into respective directories.
  * Create directories for nginx cache in `/var/cache/nginx/` folder.
  * If nginx user is not created, we need to create and add to the default users.
  * Next, we can build the nginx using `./configure` command with various flags enabled or disabled.
  * To make, we need to run `make &&  make install`
  * This installs nginx, we can optionally add this as a service, which comes up whenever the system reboots.
## Client (on VM)
* Instructions for building Docker container
  * We need to selet the Ubuntu 18.04 base image
  * Need to update and upgrade using the commands `RUN apt-get update RUN apt-get upgrade -y`
  * To build privoxy from the sources, we need to copy the build_privoxy script to the destination folder.
  * Final Dockerfile is available [Dockerfile](Client/Build/Dockerfile)
* Instructions for running build scripts in container
  * Build privoxy script can be found [here](Client/build_privoxy.sh)
  * Step 1 is to install all dependencies including `binutils, build-essential, curl, dirmngr, libssl-dev`
  * Step 2 is to install OpenPGP Keys for custom source installation.
  * Next, download the privoxy sources from the official website.
  * For privoxy tarballs, extract into respective directory created.
  * One of the must needed step in privoxy building is to create privoxy user `useradd privoxy`
  * Now we need to run `autoconf` command before executing the main build commands.
  * Next, we can build the privoxy using `./configure` command with no additional flags.
  * To make, we need to run `make &&  make -n install`
  * If the above step fails, we can modify the command to look like this `make install USER=privoxy GROUP=privoxy`.
# Runtime environments
## Server (on RPI4B)
* Instructions for building Docker container
* Instructions for running setup scripts in container
## Client (on VM)
* Instructions for building Docker container
* Instructions for running setup scripts in container
