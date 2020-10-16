#!/bin/bash

docker stop keycloak

#docker run -d --rm --name keycloak -v $(pwd):/tmp -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 -e KEYCLOAK_MIGRATION_STRATEGY=SKIP_EXISTING -e KEYCLOAK_IMPORT=/tmp/realm-master.json jboss/keycloak:11.0.2

#docker run -d --rm --name keycloak -v $(pwd):/tmp -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 jboss/keycloak:11.0.2&
#sleep 40
#docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user spring --password spring123 && \
#docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh update realms/master -f /tmp/realm-master.json

# /opt/jboss/keycloak/bin/kcadm.sh get realms/test > realm-test.json
#docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create -r master partialImport -s ifResourceExists=SKIP -f /tmp/realm-master.json

# /opt/jboss/keycloak/bin/kcadm.sh update clients/$CLIENT_ID2 -r master --body "{\"clientId\" : \"$CLIENT_ID2\", \"defaultClientScopes\": [\"TEST\"]}"
# /opt/jboss/keycloak/bin/kcadm.sh update clients/$CLIENT_ID2 -r master -s 'defaultClientScopes=["web-origins", "TEST"]'
# /opt/jboss/keycloak/bin/kcadm.sh get -x "default-default-client-scopes/$CLIENT_ID2"
# /opt/jboss/keycloak/bin/kcadm.sh get clients/$CLIENT_ID2

# /opt/jboss/keycloak/bin/kcadm.sh get -x "client-scopes" -r master
# /opt/jboss/keycloak/bin/kcadm.sh get clients -r master --fields id,clientId
# /opt/jboss/keycloak/bin/kcadm.sh delete -r master clients/$CLIENT_ID1
# /opt/jboss/keycloak/bin/kcadm.sh delete -r master clients/$CLIENT_ID2

# import test realm
docker run -d --rm --name keycloak -v $(pwd):/tmp -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 -e KEYCLOAK_MIGRATION_STRATEGY=SKIP_EXISTING -e KEYCLOAK_IMPORT=/tmp/realm-test.json jboss/keycloak:11.0.2

# http://localhost:8888

docker logs keycloak -f

docker stop keycloak

