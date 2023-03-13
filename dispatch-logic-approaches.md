Instead of exposing the dispatch function to the user, we could enable batch dispatch using one of the following two methods:

1. Allow the user to configure batch size and/or time interval:
    Instead of requiring the user to manually call the dispatch function, we could allow them to configure a batch size and/or time interval in the DataLoader configuration. When the batch size is reached or the time interval elapses, the batch is automatically dispatched. If both a batch size and time interval are configured, the dispatch is triggered by whichever condition is met first. However, this approach has limitations since it may not always be possible for the user to optimally configure the batch size or timer, leading to longer execution times.

2. Allow the user to register the DataLoader in the GraphQL context and automatically call the dispatch function before resolving future (selection/field) values:
    Alternatively, we could allow the user to register the DataLoader in the GraphQL context and call the dispatch function automatically within the GraphQL engine before resolving selection/field values. 
    
    Here's an example of how the user write ballerina code for the 2nd approach:
```ballerina
@graphql:ServiceConfig {
    contextInit: isolated function(http:RequestContext requestContext, http:Request request)
    returns graphql:Context|error {
        graphql:Context context = new;
        context.registerDataLoader("author", new DataLoader(getAuthor));
        return context;
    }
}
service /graphql on new graphql:Listener(9090) {
    resource function get authors(graphql:Context ctx, int[] ids) returns Author[] {
        DataLoader authorLoader = ctx.getDataloader("author");
        AuthorRow[] authorRows = check wait authorLoader.loadMany(ids);
        Author[] authors = map(authorRows);
        return authors;
    }
}
```

here the dispatch logic is hidden from the user and that is automatically handled by the graphql engine.

limitation: But stand will get blocked permenently, if the enging starts the execution of dispatch before the stand start executing (ie.  load() or loadMany() method doesn't get invoked before dispatch).

