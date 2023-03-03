import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { bookLoader, authorLoader, publisherLoader} from "./utils.js"

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
        authors: (_, {ids}) => authorLoader.loadMany(ids)
    },
    Author: {
        books: ({id}) => bookLoader.load(id)
    },
    Book: {
        author: ({author}) => authorLoader.load(author),
        publisher: ({publisher}) => publisherLoader.load(publisher)
    }
};

const server = new ApolloServer({
    typeDefs,
    resolvers,
});

const { url } = await startStandaloneServer(server, {
    listen: { port: 9090 },
});

console.log(`🚀  Server ready at: ${url}`);
