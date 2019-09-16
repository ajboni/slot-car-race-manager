### Customization:

## Client

apollo.js has info about the hasura server url

## DEV

Export postgre metadata

curl -XPOST -H 'x-hasura-admin-secret: scram' -H "Content-type: application/json" -d '{
"opts": ["-O", "-x", "--schema-only", "--schema", "public"],
"clean_output": true
}' 'http://localhost:10000/v1alpha1/pg_dump'

curl -XPOST -H 'x-hasura-admin-secret: scram' -H "Content-type: application/json" -d '{
"opts": ["-O", "-x", "--data-only", "--schema", "public"],
"clean_output": true
}' 'http://localhost:10000/v1alpha1/pg_dump'
