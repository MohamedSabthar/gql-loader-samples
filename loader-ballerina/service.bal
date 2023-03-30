import ballerina/graphql;
import ballerina/sql;
import ballerina/io;
import mohamedsabthar/dataloader as ldr;

@graphql:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service on new graphql:Listener(9090) {
    resource function get authors() returns Author[]|error {
        var query = sql:queryConcat(`SELECT * FROM authors`);
        io:println(query);
        stream<AuthorRow, sql:Error?> authorStream = dbClient->query(query);
        AuthorRow[] authorRows = check from var authorRow in authorStream
            select authorRow;
        final ldr:DataLoader booksLoader = new (batchBooks, batchSize = authorRows.length());
        return from AuthorRow authorRow in authorRows
            select new Author(authorRow, booksLoader);
    }
}

isolated distinct service class Author {
    private final readonly & AuthorRow author;
    final ldr:DataLoader booksLoader;

    isolated function init(AuthorRow author, ldr:DataLoader booksLoader) {
        self.author = author.cloneReadOnly();
        self.booksLoader = booksLoader;
    }

    isolated resource function get name() returns string {
        return self.author.name;
    }

    isolated resource function get books() returns Book[]|error {
        int authorId = self.author.id;
        (readonly & any|error) result = check wait self.booksLoader.load(authorId);
        readonly & BookRow[] bookRows = check result.ensureType();
        return from BookRow bookRow in bookRows
            select new (bookRow);
    }
}

isolated distinct service class Book {
    private final readonly & BookRow book;

    isolated function init(BookRow book) {
        self.book = book.cloneReadOnly();
    }

    isolated resource function get id() returns int {
        return self.book.id;
    }

    isolated resource function get title() returns string {
        return self.book.title;
    }
}
