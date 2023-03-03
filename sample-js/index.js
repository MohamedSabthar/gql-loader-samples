import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { getAuthors, getBooks, getAuthor, getPublisher} from "./utils.js"

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
        authors: (_, {ids}) => getAuthors(ids)
    },
    Author: {
        books: (author) => getBooks(author.id)
    },
    Book: {
        author: (book) => getAuthor(book.author),
        publisher: (book) => getPublisher(book.publisher)
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
