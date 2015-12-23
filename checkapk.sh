#!/bin/bash
# Check that two Android APKs are signed with the same key.

CERT1=$(unzip -p "${1}" META-INF/CERT.RSA | keytool -printcert)
CERT2=$(unzip -p "${2}" META-INF/CERT.RSA | keytool -printcert)

HASH1=$(echo -e "${CERT1}" | grep SHA256 | grep -oE '([0-9A-F]{2}:?)+$')
HASH2=$(echo -e "${CERT2}" | grep SHA256 | grep -oE '([0-9A-F]{2}[:]?)+$')
if [[ ! "${HASH1}" == "${HASH2}" ]]; then
    echo "No match, ${HASH1} and ${HASH2}"
    exit 1
fi
