#!/bin/sh

if [ -z "$(command -v curl)" ] || [ -z "$(command -v jq)" ]; then
  echo 'curl, jq commands are required to be install'
  exit 1
fi

if ! ping -c 3 'google.com' > /dev/null; then
  echo 'no internet connection'
  exit 2
fi

if_config_url='https://ifconfig.me'
ip_api_url='http://ip-api.com/json/'
solunar_url='https://api.solunar.org/solunar/'

ip="$(curl --silent "${if_config_url}")"
ip_json="$(curl --silent "${ip_api_url}${ip}")"
lat="$(echo "${ip_json}" | jq '.lat')"
lon="$(echo "${ip_json}" | jq '.lon')"

solunar_json="$(curl --silent "${solunar_url}${lat},${lon},$(date '+%Y%m%d'),35")"
echo "$solunar_json"
