#!/bin/bash

# Send a test alert to prometheus-alertmanager

name=testAlert-$RANDOM
url='http://localhost:9093/api/v1/alerts'
bold=$(tput bold)
normal=$(tput sgr0)

generate_post_data() {
  cat <<EOF
[{
  "status": "$1",
  "labels": {
    "alertname": "${name}",
    "service": "my-service",
    "severity":"critical",
    "instance": "${name}.example.net",
    "namespace": "default"
  },
  "annotations": {
    "summary": "Test alert message!"
  },
  "generatorURL": "http://local-example-alert/$name"
  $2
  $3
}]
EOF
}

echo "${bold}Firing alert ${name} ${normal}"
printf -v startsAt ',"startsAt" : "%s"' $(node -e 'console.log(new Date().toISOString())')
POSTDATA=$(generate_post_data 'firing' "${startsAt}")
curl $url --data "$POSTDATA"
echo -e "\n"

echo "${bold}Press enter to resolve alert ${name} ${normal}"
read

echo "${bold}Sending resolved ${normal}"
printf -v endsAt ',"endsAt" : "%s"' $(node -e 'console.log(new Date().toISOString())')
POSTDATA=$(generate_post_data 'firing' "${startsAt}" "${endsAt}")
curl $url --data "$POSTDATA"
echo -e "\n"
