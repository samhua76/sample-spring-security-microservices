[![test](https://github.com/AndriyKalashnykov/sample-spring-security-microservices/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/AndriyKalashnykov/sample-spring-security-microservices/actions/workflows/test.yml)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FAndriyKalashnykov%2Fsample-spring-security-microservices&count_bg=%2333CD56&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
# Spring Cloud Gateway OAuth2 with Keycloak

Original article and sources code - [SPRING CLOUD GATEWAY OAUTH2 WITH
KEYCLOAK](https://piotrminkowski.com/2020/10/09/spring-cloud-gateway-oauth2-with-keycloak/)
by Piotr Minkowski. I've automated Keycloak population with Clients and Client
Scopes and introduced further changes. 

## Clone source code 

```shell
git@github.com:AndriyKalashnykov/sample-spring-security-microservices.git

cd sample-spring-security-microservices
```

## Configure and Run Keycloak

Script will run Keycloak Docker container and create Client Scope `TEST` along
with Clients: `spring-with-test-scope` and `spring-without-test-scope`

```shell
./scripts/run-keycloak.sh
```

### The automation magic

```shell
# removed for brevity
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user spring --password spring123 && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create -x "client-scopes" -r master -s name=TEST -s protocol=openid-connect && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create clients -r master -s clientId=spring-without-test-scope -s enabled=true -s clientAuthenticatorType=client-secret -s secret=f6fc369d-49ce-4132-8282-5b5d413eba23 -s 'redirectUris=["*"]' && \
docker exec -it keycloak /opt/jboss/keycloak/bin/kcadm.sh create clients -r master -s clientId=spring-with-test-scope -s enabled=true -s clientAuthenticatorType=client-secret -s secret=c6480137-1526-4c3e-aed3-295aabcb7609  -s 'redirectUris=["*"]' -s 'defaultClientScopes=["TEST", "web-origins", "profile", "roles", "email"]'
# removed for brevity
```

Clients are created with same values of `client-secret` as in `./gateway/src/manin/java/resources/application.yaml`

```yaml
spring:
  security:
    oauth2:
      client:
        ...
        registration:
          keycloak-with-test-scope:
            ...
            client-id: spring-with-test-scope
            client-secret: c6480137-1526-4c3e-aed3-295aabcb7609
          keycloak-without-test-scope:
            ...
            client-id: spring-without-test-scope
            client-secret: f6fc369d-49ce-4132-8282-5b5d413eba23
```
Now you can log into Keycloak web UI at `http://localhost:8888/` user : `spring` password: `spring123`

## Run `callme` service

```bash
cd ./callme/
mvn clean package -DskipTests spring-boot:run
```

## Run `gateway` service

```bash
cd ./gateway/
mvn clean package -DskipTests spring-boot:run
```

## Log into `gateway` service

Now you can log into `gateway` service Keycloak web UI at `http://localhost:8060/` user : `spring` password: `spring123`
