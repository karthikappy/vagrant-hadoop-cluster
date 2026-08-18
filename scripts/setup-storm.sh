#!/bin/bash
set -euo pipefail

storm_version=2.6.4
storm_archive="/vagrant/resources/software/apache-storm-${storm_version}.tar.gz"
storm_install_dir="/usr/local/apache-storm-${storm_version}"

echo "STORM: Starting"
echo "STORM: Copying Files"

if [[ ! -f "$storm_archive" ]]; then
  echo "Storm archive not found: $storm_archive" >&2
  exit 1
fi
tar -xzf "$storm_archive" -C /usr/local
[[ -x "$storm_install_dir/bin/storm" ]]
ln -sfn "$storm_install_dir" /usr/local/storm

echo "STORM: Generating Startup scripts"
printf '%s\n' \
  'export STORM_HOME=/usr/local/storm' \
  'export PATH=${STORM_HOME}/bin:${PATH}' \
  > /etc/profile.d/storm.sh

echo "STORM: Copying Configuration Files"
cp -f /vagrant/resources/storm/conf/* /usr/local/storm/conf

echo "STORM: Creating working directories"
install -d -o vagrant -g vagrant -m 0755 /var/lib/storm /var/log/storm

echo "STORM: Task Completed Successfully"
