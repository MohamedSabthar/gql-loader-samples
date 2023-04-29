public type  AuthorRow record {
    int id;
    string name;
};

public type  BookRow record {
    int id;
    string title;
    int author;
    int publisher;
};

public type PublisherRow record {
    int id;
    string name;
    string email;
};

public type LoaderRecord record {
    string id?; // if not provided, Listener will generate one
    function (anydata[] ids) returns anydata[][]|error batchFuntion;
};
public annotation LoaderRecord Loader on function;