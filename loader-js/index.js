import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { getAuthors, batchBooks } from "./utils.js";
import DataLoader from "dataloader";

const typeDefs = `#graphql
  type Query {
    authors: [Author!]!
  }
  
  type Book {
    id: Int!
    title: String!
  }
  
  type Author {
    name: String!
    books: [Book!]!
  }
`;

const resolvers = {
  Query: {
    authors: () => getAuthors(),
  },
  Author: {
    books: ({ id }, _, { bookLoader }) => bookLoader.load(id),
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  listen: { port: 9090 },

  context: () => {
    return {
      bookLoader: new DataLoader((keys) => batchBooks(keys)),
    };
  },
});

console.log(`🚀  Server ready at: ${url}`);
