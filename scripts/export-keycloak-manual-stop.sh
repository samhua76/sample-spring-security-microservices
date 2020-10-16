#!/bin/bash

# https://hub.docker.com/r/jboss/keycloak/
# https://github.com/keycloak/keycloak-containers/tree/master/server
# https://github.com/keycloak/keycloak-documentation/blob/master/server_admin/topics/admin-cli.adoc
# http://www.mastertheboss.com/jboss-frameworks/keycloak/keycloak-oauth2-example-with-rest-application
# https://github.com/dschwank/keycloak-nodejs-admin-client/tree/feature/client_scopes-protocol_mappers-build

# Run fresh instance of Keycloak by uncommenting block below or attach to existing instance
# docker stop keycloak
# docker run -d --rm --name keycloak -p 8888:8080 -e KEYCLOAK_USER=spring -e KEYCLOAK_PASSWORD=spring123 -v $(pwd):/tmp jboss/keycloak:11.0.2&
# sleep 60

# enter realm data in http://localhost:8888/
# then run following docker command

CURRENT_DATETIME=$(date '+%Y-%m-%d-%H%M%S')
echo $CURRENT_DATETIME

# or attach to existing instance
# export master realm
# docker exec -it keycloak bash
docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=master -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/realm-master-$CURRENT_DATETIME.json

# export test realm
# docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=test -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/realm-test-$CURRENT_DATETIME.json

# docker stop keycloak