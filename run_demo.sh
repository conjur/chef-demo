#!/bin/bash -x
RC_LOCATION=/home/vagrant
export ENDPOINT=https://conjur/api
export CONJURRC=$RC_LOCATION/.conjurrc
export CERT=$RC_LOCATION/conjur-dev.pem

echo "Setting Conjur config for environment"
export CONJUR_ACCOUNT="dev"
export CONJUR_AUTHN_LOGIN=host/tomcat1
export CONJUR_APPLIANCE_URL="$ENDPOINT"
export CONJUR_SSL_CERTIFICATE_PATH="$CERT"
export CONJUR_HOST_IDENTITY="tomcat1"

export CONJUR_HOST_FACTORY_TOKEN=$(conjur hostfactory tokens create --duration-days 7 webapp1/tomcat_factory | jq -r '.[] | .token')
printf "\nHF token is: %s\n\n" $CONJUR_HOST_FACTORY_TOKEN
conjur authn logout

export CONJUR_AUTHN_API_KEY=$(curl -s --cacert $CERT \
         --request POST \
         -H "Content-Type: application/json" \
         -H "Authorization: Token token=\"$CONJUR_HOST_FACTORY_TOKEN\"" \
         $ENDPOINT/host_factories/hosts?id=$CONJUR_HOST_IDENTITY \
         | jq -r '.api_key')
printf "\nAPI key is: %s\n\n" $CONJUR_AUTHN_API_KEY

sudo chef-solo -c solo.rb -j web.json

exit

printf "\n\nRevoking (deleting) HF token so it can no longer be used...\n"
conjur hostfactory token revoke $CONJUR_HOST_FACTORY_TOKEN
