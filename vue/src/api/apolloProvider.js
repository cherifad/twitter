import {
  ApolloClient,
  createHttpLink,
  InMemoryCache,
  split,
} from "@apollo/client/core";
import { getMainDefinition } from "@apollo/client/utilities";
import { WebSocketLink } from "@apollo/client/link/ws";
import { onError } from "@apollo/client/link/error"

const baseIp = "10.103.60.24:8080";

// HTTP connection to the API
const httpLink = createHttpLink({
  // You should use an absolute URL here
  uri: "http://" + baseIp + "/v1/graphql",
});

// Create a WebSocket link:
const wsLink = new WebSocketLink({
  uri: "ws://" + baseIp + "/v1/graphql",
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
