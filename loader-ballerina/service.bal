// import ballerina/graphql;
// import ballerina/sql;
// import ballerina/io;

// service on new graphql:Listener(9090) {
//     resource function get authors(int[] ids) returns Author[]|error {
//         sql:ParameterizedQuery query = sql:queryConcat(`SELECT * FROM authors WHERE id IN (`,
//                                                         sql:arrayFlattenQuery(ids),
//                                                         `)`);
//         io:println(query);
//         stream<AuthorRow, sql:Error?> authorStream = dbClient->query(query);
//         return from AuthorRow authorRow in authorStream
//             select new Author(authorRow);
//     }
// }

// isolated distinct service class Author {
//     private final readonly & AuthorRow author;

//     isolated function init(AuthorRow author) {
//         self.author = author.cloneReadOnly();
//     }

//     isolated resource function get name() returns string {
//         return self.author.name;
//     }

//     isolated resource function get books() returns Book[]|error {
//         int authorId = self.author.id;
//         sql:ParameterizedQuery query = sql:queryConcat(`SELECT * FROM books WHERE author = ${authorId}`);
//         io:println(query);
//         stream<BookRow, sql:Error?> bookStream = dbClient->query(query);
//         return from BookRow bookRow in bookStream
//             select new Book(bookRow);
//     }
// }

// isolated distinct service class Book {
//     private final readonly & BookRow book;

//     isolated function init(BookRow book) {
//         self.book = book.cloneReadOnly();
//     }

//     isolated resource function get id() returns int {
//         return self.book.id;
//     }

//     isolated resource function get title() returns string {
//         return self.book.title;
//     }

//     isolated resource function get author() returns Author|error {
//         int authorId = self.book.author;
//         sql:ParameterizedQuery query = `SELECT * FROM authors WHERE id = ${authorId}`;
//         AuthorRow authorRow = check dbClient->queryRow(query);
//         io:println(query);
//         return new Author(authorRow);
//     }

//     isolated resource function get publisher() returns Publisher|error {
//         int publisherId = self.book.publisher;
//         sql:ParameterizedQuery query = `SELECT * FROM publishers WHERE id = ${publisherId}`;
//         PublisherRow publisherRow = check dbClient->queryRow(query);
//         io:println(query);
//         return new Publisher(publisherRow);
//     }
// }

// isolated distinct service class Publisher {
//     private final readonly & PublisherRow publisher;

//     isolated function init(PublisherRow publisher) {
//         self.publisher = publisher.cloneReadOnly();
//     }

//     isolated resource function get id() returns int {
//         return self.publisher.id;
//     }

//     isolated resource function get name() returns string {
//         return self.publisher.name;
//     }

//     isolated resource function get email() returns string {
//         return self.publisher.email;
//     }
// }
