#!/bin/bash
set -euo pipefail

nifi_version=1.23.2
nifi_archive="/vagrant/resources/software/nifi-${nifi_version}-bin.zip"
nifi_install_dir="/usr/local/nifi-${nifi_version}"

echo "NIFI: Starting"
echo "NIFI: Installing Apache NiFi"
apt-get install -y unzip

if systemctl list-unit-files nifi.service >/dev/null 2>&1; then
  systemctl stop nifi.service || true
fi

if [[ ! -f "$nifi_archive" ]]; then
  echo "NiFi archive not found: $nifi_archive" >&2
  exit 1
fi

security_initialized=false
if [[ -f "$nifi_install_dir/conf/keystore.p12" && -f "$nifi_install_dir/conf/truststore.p12" ]]; then
  security_initialized=true
fi

if [[ ! -d "$nifi_install_dir" ]]; then
  unzip -q "$nifi_archive" -d /usr/local
fi
[[ -x "$nifi_install_dir/bin/nifi.sh" ]]
ln -sfn "$nifi_install_dir" /usr/local/nifi

echo "NIFI: Generating Startup scripts"
printf '%s\n' \
  'export NIFI_HOME=/usr/local/nifi' \
  'export PATH=${NIFI_HOME}/bin:${PATH}' \
  > /etc/profile.d/nifi.sh

echo "NIFI: Copying Configuration Files"
for config_file in /vagrant/resources/nifi/config/*; do
  config_name=$(basename "$config_file")
  if [[ "$security_initialized" == true && ( "$config_name" == nifi.properties || "$config_name" == login-identity-providers.xml ) ]]; then
    continue
  fi
  cp -f "$config_file" /usr/local/nifi/conf/
done

# Retain generated security values on reprovision while enforcing the public endpoint.
sed -i \
  -e 's/^nifi.web.http.host=.*/nifi.web.http.host=/' \
  -e 's/^nifi.web.http.port=.*/nifi.web.http.port=/' \
  -e 's/^nifi.web.https.host=.*/nifi.web.https.host=node1/' \
  -e 's/^nifi.web.https.port=.*/nifi.web.https.port=8443/' \
  /usr/local/nifi/conf/nifi.properties

echo "NIFI: Creating working directories"
install -d -o vagrant -g vagrant -m 0755 \
  /usr/local/nifi/logs \
  /usr/local/nifi/run \
  /usr/local/nifi/work
chown -R vagrant:vagrant "$nifi_install_dir"

echo "NIFI: Task Completed Successfully"

