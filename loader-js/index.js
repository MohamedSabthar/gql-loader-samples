import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { batchAuthors, batchBooks, batchPublishers } from "./utils.js";
import DataLoader from "dataloader";

const typeDefs = `#graphql
  type Query {
    authors(ids: [Int!]!): [Author!]!
  }
  
  type Publisher {
    id: Int!
    name: String!
    email: String!
  }
  
  type Book {
    id: Int!
    title: String!
    author: Author!
    publisher: Publisher!
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
  Book: {
    author: ({ author }, _, { authorLoader }) => authorLoader.load(author),
    publisher: ({ publisher }, _, { publisherLoader }) => publisherLoader.load(publisher),
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
      publisherLoader: new DataLoader((keys) => batchPublishers(keys)),
    };
  },
});

console.log(`🚀  Server ready at: ${url}`);
