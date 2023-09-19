import Foundation
import CoreData

public extension NSManagedObject {
    func get<Value>(_ key: String) -> Value? {
        willAccessValue(forKey: key)
        defer { didAccessValue(forKey: key) }
        return primitiveValue(forKey: key) as? Value
    }
    
    func set<Value>(_ key: String, newValue: Value?) {
        willChangeValue(forKey: key)
        defer { didChangeValue(forKey: key) }
        guard let value = newValue else {
            setPrimitiveValue(nil, forKey: key)
            return
        }
        setPrimitiveValue(value, forKey: key)
    }
}
