type DataLoader object {
    isolated function load(anydata id);
    isolated function get(anydata id, typedesc<any> t = <>) returns t|error;
    isolated function dispatch();
};

isolated class DefaultDataLoader {
    *DataLoader;

    private final anydata[] ids = [];
    private final (isolated function (anydata[] ids) returns anydata[][]|error) loaderFunction;
    isolated function init(isolated function (anydata[] ids) returns anydata[][]|error loadFunction) {
        self.loaderFunction = loadFunction;
    }

    isolated function load(anydata id) {
        lock {
            self.ids.push(id.clone());
        }
    }

    isolated function get(anydata id, typedesc<any> t = <>) returns t|error = external;

    isolated function dispatch() {
        lock {
            anydata[][]|error loaderFunctionResult = self.loaderFunction(self.ids.clone());
            // implement rest of the logic
        }
    }
}
