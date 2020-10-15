#!/bin/bash

docker stop keycloak

# load master realm

docker run -d --rm --name keycloak -v $(pwd):/tmp -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 jboss/keycloak:11.0.2&
sleep 60
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user spring --password spring123 && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create -x "client-scopes" -r master -s name=TEST -s protocol=openid-connect && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create clients -r master -s clientId=spring-without-test-scope -s enabled=true -s clientAuthenticatorType=client-secret -s secret=f6fc369d-49ce-4132-8282-5b5d413eba23 -s 'redirectUris=["*"]' && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create clients -r master -s clientId=spring-with-test-scope -s enabled=true -s clientAuthenticatorType=client-secret -s secret=c6480137-1526-4c3e-aed3-295aabcb7609  -s 'redirectUris=["*"]' -s 'defaultClientScopes=["TEST", "web-origins", "profile", "roles", "email"]'
# JQ=/.
# curl https://stedolan.github.io/jq/download/linux64/jq > $JQ && chmod +x $JQ
# CLIENT_ID1=`/opt/jboss/keycloak/bin/kcadm.sh get clients -r master | ./jq '.[] | select(.clientId == "spring-without-test-scope") | .id'| sed -r 's/^"|"$//g'`
# CLIENT_ID2=`/opt/jboss/keycloak/bin/kcadm.sh get clients -r master | ./jq '.[] | select(.clientId == "spring-with-test-scope") | .id'| sed -r 's/^"|"$//g'`


# http://localhost:8888

docker logs keycloak -f
# docker exec -it keycloak bash

docker stop keycloak

# http://localhost:8060/login

# /opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user spring --password spring123
# /opt/jboss/keycloak/bin/kcadm.sh update realms/master -f /opt/jboss/keycloak/imports/realm-master.json
# /opt/jboss/keycloak/bin/kcadm.sh get realms/test > realm-test.json
# /opt/jboss/keycloak/bin/kcadm.sh create -r master partialImport -s ifResourceExists=SKIP -f /opt/jboss/keycloak/imports/realm-master.json

# /opt/jboss/keycloak/bin/kcadm.sh update clients/$CLIENT_ID2 -r master --body "{\"clientId\" : \"$CLIENT_ID2\", \"defaultClientScopes\": [\"TEST\"]}"
# /opt/jboss/keycloak/bin/kcadm.sh update clients/$CLIENT_ID2 -r master -s 'defaultClientScopes=["web-origins", "TEST"]'
# /opt/jboss/keycloak/bin/kcadm.sh get -x "default-default-client-scopes/$CLIENT_ID2"
# /opt/jboss/keycloak/bin/kcadm.sh get clients/$CLIENT_ID2

# /opt/jboss/keycloak/bin/kcadm.sh get -x "client-scopes" -r master
# /opt/jboss/keycloak/bin/kcadm.sh get clients -r master --fields id,clientId
# /opt/jboss/keycloak/bin/kcadm.sh delete -r master clients/$CLIENT_ID1
# /opt/jboss/keycloak/bin/kcadm.sh delete -r master clients/$CLIENT_ID2

# import test reaml
# docker run -d --rm --name keycloak -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 -e KEYCLOAK_MIGRATION_STRATEGY=OVERWRITE_EXISTING -e KEYCLOAK_IMPORT=/opt/jboss/keycloak/imports/realm-test.json -v $(pwd):/opt/jboss/keycloak/imports jboss/keycloak:11.0.2

