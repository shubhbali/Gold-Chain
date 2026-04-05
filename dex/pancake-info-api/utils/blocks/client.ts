import { ApolloClient, HttpLink, InMemoryCache } from "@apollo/client/core";
import fetch from "cross-fetch";

export const blockClient = new ApolloClient({
  link: new HttpLink({
    fetch,
    uri: process.env.BLOCKS_SUBGRAPH_URL || process.env.GOLD_CHAIN_BLOCKS_SUBGRAPH_URL || "http://localhost:8000/subgraphs/name/gold-chain/blocks",
  }),
  cache: new InMemoryCache(),
});
