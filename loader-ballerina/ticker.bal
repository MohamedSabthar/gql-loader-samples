import ballerina/task;
import ballerina/io;
import mohamedsabthar/dataloader as dl;

class DispatcherJob {
    *task:Job;
    private final dl:DataLoader loader;

    isolated function init(dl:DataLoader loader) {
        self.loader = loader;
    }

    public function execute() {
        error? err = self.loader.dispatch();
        if err is error {
            io:println("Error while dispatching: ", err.detail(), err);

        }
    }
}

var a = check task:scheduleJobRecurByFrequency(new DispatcherJob(authorLoader), 0.02);
var b = check task:scheduleJobRecurByFrequency(new DispatcherJob(booksLoader), 0.05);
var c = check task:scheduleJobRecurByFrequency(new DispatcherJob(publisherLoader), 1);
