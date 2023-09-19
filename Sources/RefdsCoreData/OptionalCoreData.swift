import Foundation
import CoreData

@propertyWrapper struct OptionalCoreData<Value> {
    private let key: String
    private let object: NSManagedObject

    public var wrappedValue: Value? {
        get {
            object.willAccessValue(forKey: key)
            defer { object.didAccessValue(forKey: key) }
            return object.primitiveValue(forKey: key) as? Value
        }
        set {
            object.willChangeValue(forKey: key)
            defer { object.didChangeValue(forKey: key) }
            guard let value = newValue else {
                object.setPrimitiveValue(nil, forKey: key)
                return
            }
            object.setPrimitiveValue(value, forKey: key)
        }
    }
    
    public init(_ key: String, _ object: NSManagedObject) {
        self.key = key
        self.object = object
    }
}
