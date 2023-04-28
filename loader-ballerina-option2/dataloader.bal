type DataLoader object {
    isolated function load(anydata id, function (anydata[] data) returns anydata callbackFunction);
    isolated function dispatch();
};

isolated class DefaultDataLoader {
    *DataLoader;

    private final anydata[] ids = [];
    private final function (anydata[] data) returns any callbackFunction;
    private final function (anydata[] ids) returns anydata[][]|error loaderFunction;

    isolated function init(function (anydata[] ids) returns anydata[][]|error loaderFunction) {
        self.loaderFunction = loaderFunction;
    }

    isolated function load(anydata id, function (anydata[] data) returns any|any[] callbackFunction) {
        lock {
            self.ids.push(id.clone());
            self.callbackFunction = callbackFunction;
        }
    }

    isolated function dispatch() {
        // call the loaderFunction function
        // and do the required logic
    }
}
