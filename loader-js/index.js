import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { batchAuthors, batchBooks } from "./utils.js";
import DataLoader from "dataloader";

const typeDefs = `#graphql
  type Query {
    authors(ids: [Int!]!): [Author!]!
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
    authors: (_, { ids }, { authorLoader }) => authorLoader.loadMany(ids),
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
      authorLoader: new DataLoader((keys) => batchAuthors(keys)),
      bookLoader: new DataLoader((keys) => batchBooks(keys)),
    };
  },
});

console.log(`🚀  Server ready at: ${url}`);
