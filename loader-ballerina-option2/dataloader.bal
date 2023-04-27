type DataLoader object {
    isolated function load(anydata id, function f) returns ();
};

isolated class DefaultDataLoader {
    *DataLoader;

    private anydata[] ids = [];
    private function? f = ();
    private function batchLoadFunction;

    isolated function init(function batchLoadFunction) {
        self.batchLoadFunction = batchLoadFunction;
    }

    isolated function load(anydata id, function f) {
        lock {
            self.ids.push(id.clone());
            self.f = f;
        }
    }
}
