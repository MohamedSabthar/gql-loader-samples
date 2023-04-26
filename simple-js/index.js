import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { getAuthors, getBooks } from "./utils.js";

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
    authors: (_, { ids }) => getAuthors(ids),
  },
  Author: {
    books: (author) => getBooks(author.id),
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  listen: { port: 9090 },
});

console.log(`🚀  Server ready at: ${url}`);
