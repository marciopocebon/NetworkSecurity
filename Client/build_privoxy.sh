#!/usr/bin/env bash
# Run as root or with sudo
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

# Make script exit if a simple command fails and
# Make script print commands being executed
set -e -x

# Ensure curl is installed
apt-get update && apt-get install curl -y

# Set URLs to the source directories
source_pcre=https://ftp.pcre.org/pub/pcre/
source_zlib=https://zlib.net/
source_openssl=https://www.openssl.org/source/
source_nginx=https://nginx.org/download/

# Look up latest versions of each package
version_pcre=$(curl -sL ${source_pcre} | grep -Eo 'pcre\-[0-9.]+[0-9]' | sort -V | tail -n 1)
version_zlib=$(curl -sL ${source_zlib} | grep -Eo 'zlib\-[0-9.]+[0-9]' | sort -V | tail -n 1)
version_openssl=$(curl -sL ${source_openssl} | grep -Eo 'openssl\-[0-9.]+[a-z]?' | sort -V | tail -n 1)
version_nginx=$(curl -sL ${source_nginx} | grep -Eo 'nginx\-[0-9.]+[13579]\.[0-9]+' | sort -V | tail -n 1)

# Set OpenPGP keys used to sign downloads
opgp_pcre=45F68D54BBE23FB3039B46E59766E084FB0F43D8
opgp_zlib=5ED46A6721D365587791E2AA783FCD8E58BCAFBA
opgp_openssl=8657ABB260F056B1E5190839D9C4D26D0E604491
opgp_nginx=B0F4253373F8F6F510D42178520A9993A1C052F8

# Set where OpenSSL and NGINX will be built
bpath=$(pwd)/build

# Make a "today" variable for use in back-up filenames later
today=$(date +"%Y-%m-%d")

# Clean out any files from previous runs of this script
rm -rf \
  "$bpath" \
  /etc/nginx-default
mkdir "$bpath"

# Ensure the required software to compile NGINX is installed
apt-get -y install \
  binutils \
  build-essential \
  curl \
  dirmngr \
  libssl-dev

# Download the source files
curl -L "${source_pcre}${version_pcre}.tar.gz" -o "${bpath}/pcre.tar.gz"
curl -L "${source_zlib}${version_zlib}.tar.gz" -o "${bpath}/zlib.tar.gz"
curl -L "${source_openssl}${version_openssl}.tar.gz" -o "${bpath}/openssl.tar.gz"
curl -L "${source_nginx}${version_nginx}.tar.gz" -o "${bpath}/nginx.tar.gz"

# Download the signature files
curl -L "${source_pcre}${version_pcre}.tar.gz.sig" -o "${bpath}/pcre.tar.gz.sig"
curl -L "${source_zlib}${version_zlib}.tar.gz.asc" -o "${bpath}/zlib.tar.gz.asc"
curl -L "${source_openssl}${version_openssl}.tar.gz.asc" -o "${bpath}/openssl.tar.gz.asc"
curl -L "${source_nginx}${version_nginx}.tar.gz.asc" -o "${bpath}/nginx.tar.gz.asc"

# Verify the integrity and authenticity of the source files through their OpenPGP signature
cd "$bpath"
GNUPGHOME="$(mktemp -d)"
export GNUPGHOME
( gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$opgp_pcre" "$opgp_zlib" "$opgp_openssl" "$opgp_nginx" \
|| gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$opgp_pcre" "$opgp_zlib" "$opgp_openssl" "$opgp_nginx")
gpg --batch --verify pcre.tar.gz.sig pcre.tar.gz
gpg --batch --verify zlib.tar.gz.asc zlib.tar.gz
gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz
gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz

curl -L "https://astuteinternet.dl.sourceforge.net/project/ijbswa/Sources/3.0.28%20%28stable%29/privoxy-3.0.28-stable-src.tar.gz" -o "${bpath}/privoxy-3.0.28-stable-src.tar.gz"

# Expand the source files
cd "$bpath"
for archive in ./*.tar.gz; do
  tar xzf "$archive"
done

# Clean up source files
rm -rf \
  "$GNUPGHOME" \
  "$bpath"/*.tar.*

useradd privoxy
#groupadd privoxy
#usermod -a -G prixoxy privoxy

cd privoxy-3.0.28-stable/
autoheader
 autoconf
 ./configure      # (--help to see options)
 make             # (the make from GNU, sometimes called gmake)
 su               # Possibly required
 make -n install  # (to see where all the files will go)
 #make -s install  # (to really install, -s to silence output)echo "All done.";
 make install USER=privoxy GROUP=privoxy
