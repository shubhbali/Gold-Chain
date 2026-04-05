import { ApolloClient, HttpLink, InMemoryCache } from "@apollo/client/core";
import fetch from "cross-fetch";

export const client = new ApolloClient({
  link: new HttpLink({
    fetch,
    uri: process.env.SUBGRAPH_URL || process.env.GOLD_CHAIN_SUBGRAPH_URL || "http://localhost:8000/subgraphs/name/gold-chain/v2",
  }),
  cache: new InMemoryCache(),
});
