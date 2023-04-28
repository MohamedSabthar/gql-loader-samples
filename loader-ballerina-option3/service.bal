import ballerina/graphql;
import ballerina/sql;

@graphql:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service on new graphql:Listener(9090) {
    resource function get authors(int[] ids) returns Author[]|error {
        var query = sql:queryConcat(`SELECT * FROM authors WHERE id IN (`, sql:arrayFlattenQuery(ids), `)`);
        stream<AuthorRow, sql:Error?> authorStream = dbClient->query(query);
        return from AuthorRow authorRow in authorStream
            select new (authorRow);
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

    isolated resource function get books(DataLoader bookloader) returns Book[]|error {
        BookRow[] bookrows = check bookloader.get(self.author.id);
        return from BookRow bookRow in bookrows select new Book(bookRow);
    }

    @Loader {
        batchFuntion: bookLoaderFunction
    }
    isolated resource function get loadBooks(DataLoader bookLoader) {
        bookLoader.load(self.author.id);
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

function (anydata[] ids) returns anydata[][]|error bookLoaderFunction = function (anydata[] ids) returns BookRow[][]|error {
    var query = sql:queryConcat(`SELECT * FROM books WHERE id IN (`, sql:arrayFlattenQuery(<int[]>ids), `)`);
    stream<BookRow, sql:Error?> bookStream = dbClient->query(query);
    map<BookRow[]> authorsBooks = {};
    checkpanic from BookRow bookRow in bookStream
            do {
                string key = bookRow.author.toString();
                if !authorsBooks.hasKey(key) {
                    authorsBooks[key] = [];
                }
                authorsBooks.get(key).push(bookRow);
            };
    return ids.'map(key => authorsBooks.hasKey(key.toString()) ? authorsBooks.get(key.toString()) : []);
};

