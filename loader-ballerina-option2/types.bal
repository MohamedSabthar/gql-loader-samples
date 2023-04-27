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

public type ReturnTypeRecord record {
    typedesc<any> returnType;
};
public annotation ReturnTypeRecord ReturnType on return;