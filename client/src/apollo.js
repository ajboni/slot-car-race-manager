import ApolloClient from "apollo-boost";

export const client = new ApolloClient({
  uri: "http://localhost:10000/v1/graphql",
  headers: {
    "x-hasura-admin-secret": "scram"
  }
});
