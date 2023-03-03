import ballerina/graphql;
import ballerina/http;

@graphql:ServiceConfig {
    contextInit,
    cors: {
        allowOrigins: ["*"]
    }
}
service on new graphql:Listener(9090) {
    resource function get authors(int[] ids) returns Author[]|error {
        (readonly & any|error)[] authorRows = check wait authorLoader.loadMany(ids);
        Author[] authors = [];
        from any|error row in authorRows
        do {
            AuthorRow authorRow = check row.ensureType();
            authors.push(new (authorRow));
        };
        return authors;
    }
}

isolated distinct service class Author {
    private final readonly & AuthorRow author;

    isolated function init(AuthorRow author) {
        self.author = author.cloneReadOnly();
    }

    isolated resource function get name() returns string {
        return self.author.name;
    }

    isolated resource function get books() returns Book[]|error {
        int authorId = self.author.id;
        (readonly & any|error) result = check wait booksLoader.load(authorId);
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

    isolated resource function get author() returns Author|error {
        int authorId = self.book.author;
        (readonly & any|error) result = check wait authorLoader.load(authorId);
        readonly & AuthorRow authorRow = check result.ensureType();
        return new Author(authorRow);
    }

    isolated resource function get publisher() returns Publisher|error {
        int publisherId = self.book.publisher;
        (readonly & any|error) result = check wait publisherLoader.load(publisherId);
        readonly & PublisherRow publisherRow = check result.ensureType();
        return new Publisher(publisherRow);
    }
}

isolated distinct service class Publisher {
    private final readonly & PublisherRow publisher;

    isolated function init(PublisherRow publisher) {
        self.publisher = publisher.cloneReadOnly();
    }

    isolated resource function get id() returns int {
        return self.publisher.id;
    }

    isolated resource function get name() returns string {
        return self.publisher.name;
    }

    isolated resource function get email() returns string {
        return self.publisher.email;
    }
}

isolated function contextInit(http:RequestContext requestContext, http:Request request) returns graphql:Context {
    clearCachePerRequest();
    return new;
}

isolated function clearCachePerRequest() {
    _ = booksLoader.clearAll();
    _ = authorLoader.clearAll();
    _ = publisherLoader.clearAll();
}
