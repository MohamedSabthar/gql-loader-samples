import ballerina/http;
import mohamedsabthar/dataloader as ldr;
import ballerina/task;

service class RequestInterceptor {
    *http:RequestInterceptor;
    resource function 'default [string... path](http:RequestContext ctx) returns http:NextService|error? {
        ldr:DataLoader bookLoader = new (batchBooks);
        ldr:DataLoader authorLoader = new (batchAuthors);
        ldr:DataLoader publisherLoader = new (batchPublisher);
        ctx.set("bookLoader", bookLoader);
        ctx.set("authorLoader", authorLoader);
        ctx.set("publisherLoader", publisherLoader);

        task:JobId authorJob = check task:scheduleJobRecurByFrequency(new DispatcherJob(authorLoader), 0.02);
        task:JobId booksJob = check task:scheduleJobRecurByFrequency(new DispatcherJob(bookLoader), 0.05);
        task:JobId publisherJob = check task:scheduleJobRecurByFrequency(new DispatcherJob(publisherLoader), 1);
        readonly & task:JobId[] jobs = [booksJob, authorJob, publisherJob];
        ctx.set("jobs", jobs);

        return ctx.next();
    }
}

service class ResponseInterceptor {
    *http:ResponseInterceptor;
    remote function interceptResponse(http:RequestContext ctx, http:Response res) returns http:NextService|error? {
        readonly & task:JobId[] jobs = check ctx.get("jobs").ensureType();
        foreach task:JobId job in jobs {
            check task:unscheduleJob(job);
        }
        return ctx.next();
    }
}
