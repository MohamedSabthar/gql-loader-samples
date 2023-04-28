type DataLoader object {
    isolated function load(anydata id);
    isolated function get(anydata id, typedesc<any> t = <>) returns t|error;
    isolated function dispatch() returns error?;
};

isolated class DefaultDataLoader {
    *DataLoader;

    private final anydata[] ids = [];
    private anydata[][] loaderResult = [];
    private final (isolated function (anydata[] ids) returns anydata[][]|error) loaderFunction;
    isolated function init(isolated function (anydata[] ids) returns anydata[][]|error loadFunction) {
        self.loaderFunction = loadFunction;
    }

    isolated function load(anydata id) {
        lock {
            self.ids.push(id.clone());
        }
    }

    // using the loadedResult array, return the result for the given id
    isolated function get(anydata id, typedesc<any> t = <>) returns t|error = external;

    isolated function dispatch() returns error? {
        lock {
            self.loaderResult = check self.loaderFunction(self.ids.clone());
            // implement rest of the logic
        }
    }
}
