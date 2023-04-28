type DataLoader object {
    isolated function load(anydata id, isolated function (anydata[] data) returns any callbackFunction);
    isolated function dispatch();
    isolated function execute();
};

isolated class DefaultDataLoader {
    *DataLoader;

    private final anydata[] ids = [];
    private final (isolated function (anydata[] ids) returns anydata[][]|error) loaderFunction;
    private (function (anydata[] data) returns any)? callbackFunction = ();

    isolated function init(isolated function (anydata[] ids) returns anydata[][]|error loaderFunction) {
        self.loaderFunction = loaderFunction;
    }

    isolated function load(anydata id, isolated function (anydata[] data) returns any callbackFunction) {
        lock {
            self.ids.push(id.clone());
            self.callbackFunction = callbackFunction;
        }
    }

    isolated function dispatch() {
        lock {
            anydata[][]|error loaderFunctionResult = self.loaderFunction(self.ids.clone());
            // implement rest of the logic
        }
    }

    isolated function execute() {
        lock {
            if self.callbackFunction is (function (anydata[] data) returns any) {
                self.callbackFunction([1, 1]);
            }
        }
    }
}
