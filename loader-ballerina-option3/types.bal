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
    function batchFuntion;
};
public annotation LoaderRecord Loader on function;