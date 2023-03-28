import ballerina/graphql;
import ballerina/http;
import ballerina/sql;

@graphql:ServiceConfig {
    contextInit,
    cors: {
        allowOrigins: ["*"]
    }
}
service on new graphql:Listener(9090) {
    resource function get authors(int[] ids) returns Author[]|error {
        var query = sql:queryConcat(`SELECT * FROM authors WHERE id IN (`, sql:arrayFlattenQuery(ids), `)`);
        stream<AuthorRow, sql:Error?> authorStream = dbClient->query(query);
        return from AuthorRow authorRow in authorStream
            select new Author(authorRow);
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
}

isolated function contextInit(http:RequestContext requestContext, http:Request request) returns graphql:Context {
    clearCachePerRequest();
    return new;
}

isolated function clearCachePerRequest() {
    _ = booksLoader.clearAll();
    _ = authorLoader.clearAll();
}
