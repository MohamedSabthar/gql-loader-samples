import mohamedsabthar/dataloader as ldr;
import ballerina/sql;
import ballerina/io;

function batchBooks(ldr:Key[] keys) returns future<(readonly & any|error)[]> {
    worker booksWorker returns (readonly & BookRow[]|error)[] {
        if keys.length() == 0 {
            return [];
        }
        sql:ParameterizedQuery query = sql:queryConcat(`SELECT * FROM books WHERE author IN (`,
            sql:arrayFlattenQuery(keys), `)`);
        io:println(query);
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
        return keys.'map(key => authorsBooks.hasKey(key.toString()) ? authorsBooks.get(key.toString()) : []).cloneReadOnly();
    }
    return booksWorker;
};
