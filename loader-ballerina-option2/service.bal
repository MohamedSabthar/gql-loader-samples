import ballerina/graphql;
import ballerina/sql;

type BookArray Book[];

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

    isolated resource function get books() returns @ReturnType{returnType: BookArray} DataLoader {
        lock {
            bookLoader.load(self.author.id, isolated function(anydata[] bookraws) returns BookArray {
                return from BookRow bookRow in <BookRow[]>bookraws select new Book(bookRow);
            });
            return bookLoader;
        }
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

var bookLoaderFunction = isolated function (anydata[] ids) returns BookRow[][]|error {
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

    map<BookRow[]> & readonly _authorsBooks = authorsBooks.cloneReadOnly();
    return ids.'map(isolated function (anydata key) returns BookRow[] {
        lock {
            return _authorsBooks.hasKey(key.toString()) ? _authorsBooks.get(key.toString()) : [];
        }
    });
};
DefaultDataLoader bookLoader = new (bookLoaderFunction);

