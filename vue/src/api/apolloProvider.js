import {
  ApolloClient,
  createHttpLink,
  InMemoryCache,
  split,
} from "@apollo/client/core";
import { getMainDefinition } from "@apollo/client/utilities";
import { WebSocketLink } from "@apollo/client/link/ws";
import { onError } from "@apollo/client/link/error"

// HTTP connection to the API
const httpLink = createHttpLink({
  // You should use an absolute URL here
  uri: "http://10.103.252.17:8080/v1/graphql",
});

// Create a WebSocket link:
const wsLink = new WebSocketLink({
  uri: "ws://10.103.252.17:8080/v1/graphql",
  options: {
    reconnect: true,
    lazy: true,
    timeout: 30000,
    inactivityTimeout: 30000,
  },
});

const errorLink = onError((error) => {
  
})

// Cache implementation
const cache = new InMemoryCache();

// Create the apollo client
export const apolloProvider = new ApolloClient({
  link: errorLink.concat(
    split(
      // split based on operation type
      ({ query }) => {
        const definition = getMainDefinition(query);
        return (
          definition.kind === "OperationDefinition" &&
          definition.operation === "subscription"
        );
      },
      wsLink,
      httpLink
    )
  ),
  cache,
});
