# IDP configurations
export IDP_TOKEN_ENDPOINT=http://keycloak:8080/realms/cp/protocol/openid-connect/token
export IDP_JWKS_ENDPOINT=http://keycloak:8080/realms/cp/protocol/openid-connect/certs
export IDP_EXPECTED_ISSUER=http://keycloak:8080/realms/cp
export IDP_AUTH_ENDPOINT=http://keycloak:8080/realms/cp/protocol/openid-connect/auth
export IDP_DEVICE_AUTH_ENDPOINT=http://keycloak:8080/realms/cp/protocol/openid-connect/auth/device
export SUB_CLAIM_NAME=clientId
export GROUP_CLAIM_NAME=groups
export EXPECTED_AUDIENCE=account

# Client configurations
export APP_GROUP_NAME='/app_group1'

export SUPERUSER_CLIENT_ID=superuser_client_app
export SUPERUSER_CLIENT_SECRET=superuser_client_app_secret

export SR_CLIENT_ID=sr_client_app
export SR_CLIENT_SECRET=sr_client_app_secret

export RP_CLIENT_ID=rp_client_app
export RP_CLIENT_SECRET=rp_client_app_secret

export CONNECT_CLIENT_ID=connect_client_app
export CONNECT_CLIENT_SECRET=connect_client_app_secret

export CONNECT_SECRET_PROTECTION_CLIENT_ID=connect_sr_client_app
export CONNECT_SECRET_PROTECTION_CLIENT_SECRET=connect_sr_client_app_secret

export KSQL_CLIENT_ID=ksql_client_app
export KSQL_CLIENT_SECRET=ksql_client_app_secret

export C3_CLIENT_ID=c3_client_app
export C3_CLIENT_SECRET=c3_client_app_secret

export CLIENT_APP_ID=client_app1
export CLIENT_APP_SECRET=client_app1_secret

export SSO_CLIENT_ID=c3_sso_login
export SSO_CLIENT_SECRET=c3_sso_login_secret

export SSO_SUPER_USER_GROUP=g1
export SSO_USER_GROUP=g2

