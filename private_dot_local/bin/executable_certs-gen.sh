#!/bin/sh

DEST="./certs"
#DEST=${1:-./certs}

usage() {
    cat <<EOF
Generates test certificates: CA, intermediate CA, server and client.
Both server and client certificates are signed by intermediate CA (if used).

Flags:
    -d <destination directory>
        default ./certs
    -a <DNS:fqdn|IP:0.0.0.0>
        default DNS:localhost,IP:127.0.0.1
        key may be used multiple times
    -i create intermediate CA
EOF
    exit 0
}

# adds Subject Alternative Names
add_san() {
    case "$1" in
        DNS:*|IP:*)
            if [ -z "$ALTNAMES" ]; then
                ALTNAMES="$1"
            else
                ALTNAMES="$ALTNAMES,$1"
            fi
            ;;
        *)
            echo "use DNS:fqdn or IP:x.x.x.x as Subject Alternative Name" >&2
            exit 1
            ;;
    esac
}

while getopts "d:a:ih" OPT; do
    case $OPT in
        d) DEST=$OPTARG ;;
        a) add_san "$OPTARG" ;;
        i) ICA="true" ;;
        h) usage ;;
        *) usage ;;
    esac
done

[ -z "$ALTNAMES" ] && ALTNAMES=DNS:localhost,IP:127.0.0.1

mkdir -p "$DEST" || { echo "Unable to create destination directory $DEST"; exit 1; }

# we don't need libreSSL
for e in $(which -a openssl); do
    if "$e" version | grep -qi '^openssl'; then
        alias openssl='$e'
        break
    fi
done

# root CA
openssl req \
    -subj "/CN=root CA" -out "$DEST"/ca.crt \
    -newkey rsa:4096 -nodes -keyout "$DEST"/ca.key\
    -x509 -days 365 \
    -addext basicConstraints=critical,CA:TRUE \
    -addext subjectKeyIdentifier=hash \
    -addext authorityKeyIdentifier=keyid:always \
    -addext keyUsage=critical,digitalSignature,cRLSign,keyCertSign

SIGN_CERT="$DEST"/ca.crt
SIGN_KEY="$DEST"/ca.key

if [ "$ICA" = "true" ]; then
# intermediate CA
openssl req \
    -subj "/CN=intermediate CA" -out "$DEST"/ca-int.crt \
    -newkey rsa:4096 -nodes -keyout "$DEST"/ca-int.key \
    -x509 -days 365 -CA "$SIGN_CERT" -CAkey "$SIGN_KEY" \
    -addext basicConstraints=critical,CA:TRUE,pathlen:0 \
    -addext subjectKeyIdentifier=hash \
    -addext authorityKeyIdentifier=keyid:always \
    -addext keyUsage=critical,digitalSignature,cRLSign,keyCertSign

SIGN_CERT="$DEST"/ca-int.crt
SIGN_KEY="$DEST"/ca-int.key
fi

# server certificate
openssl req \
    -subj "/CN=server certificate" -out "$DEST"/server.crt \
    -newkey rsa:4096 -nodes -keyout "$DEST"/server.key \
    -x509 -days 180 -CA "$SIGN_CERT" -CAkey "$SIGN_KEY" \
    -addext subjectAltName=$ALTNAMES \
    -addext basicConstraints=critical,CA:FALSE \
    -addext subjectKeyIdentifier=hash \
    -addext authorityKeyIdentifier=keyid:always \
    -addext keyUsage=critical,nonRepudiation,digitalSignature,keyEncipherment \
    -addext extendedKeyUsage=serverAuth

# client certificate
openssl req \
    -subj "/CN=client certificate" -out "$DEST"/client.crt \
    -newkey rsa:4096 -nodes -keyout "$DEST"/client.key \
    -x509 -days 180 --CA "$SIGN_CERT" -CAkey "$SIGN_KEY" \
    -addext basicConstraints=critical,CA:FALSE \
    -addext subjectKeyIdentifier=hash \
    -addext authorityKeyIdentifier=keyid:always \
    -addext keyUsage=critical,nonRepudiation,digitalSignature,keyEncipherment \
    -addext extendedKeyUsage=clientAuth,emailProtection

# generate supplementary files
if [ "$ICA" = "true" ]; then
cd "$DEST"
cat server.crt ca-int.crt > server-fullchain.pem
cat client.crt ca-int.crt > client-fullchain.pem
cat ca.crt ca-int.crt > ca-all.pem
fi
