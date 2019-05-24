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
                                                                                                           
if [ -n "${1}" ]; then                                                                                     
  zipcode="${1}"                                                                                           
fi                                                                                                         
                                                                                                           
ip="$(curl --silent "${if_config_url}")"                                                                   
ip_json="$(curl --silent "${ip_api_url}${ip}")"                                                            
lat="$(echo "${ip_json}" | jq '.lat')"                                                                     
lon="$(echo "${ip_json}" | jq '.lon')"                                                                     
echo "$ip $ip_json"                                                                                        
echo "$lat $lon"                                                                                           
solunar_json="$(curl --silent "${solunar_url}${lat},${lon},$(date '+%Y%m%d'),-4")"                         
major1="$(echo "${solunar_json}" | jq '.major1Start, .major1Stop' | tr  -d '\n')"                          
major1_dec="$(echo "${solunar_json}" | jq '.major1StartDec, .major1StopDec' | tr -d '\n')"                 
                                                                                                           
major2="$(echo "${solunar_json}" | jq '.major2Start, .major2Stop' | tr  -d '\n')"                          
major2_dec="$(echo "${solunar_json}" | jq '.major2StartDec, .major2StopDec' | tr -d '\n')"                 
                                                                                                           
minor1="$(echo "${solunar_json}" | jq '.minor1Start, .minor1Stop' | tr -d '\n')"                           
minor1_dec="$(echo "${solunar_json}" | jq '.minor1StartDec, .minor1StopDec' | tr -d '\n')"                 
                                                                                                           
minor2="$(echo "${solunar_json}" | jq '.minor2Start, .minor2Stop' | tr -d '\n')"                           
minor2_dec="$(echo "${solunar_json}" | jq '.minor2StartDec, .minor2StopDec' | tr -d '\n')"                 
                                                                                                           
echo "Major 1 ${major1} and Major 2 ${major2}"                                                             
echo "Minor 1 ${minor1} and Minor 2 ${minor2}"                                                             
