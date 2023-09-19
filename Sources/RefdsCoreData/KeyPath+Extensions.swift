import Foundation

extension KeyPath {
    var rootType: Any.Type {
        return Root.self
    }

    var unwrappedType: Any.Type {
        guard let optionalType = Value.self as? OptionalProtocol.Type else {
            return Value.self
        }

        return optionalType.wrappedType
    }
    
    var destinationType: Any.Type {
        let unwrapped = unwrappedType

        guard let toManyType = unwrapped.self as? ToManyProtocol.Type else {
            return unwrapped
        }

        return toManyType.elementType
    }

    var stringValue: String {
        return NSExpression(forKeyPath: self).keyPath
    }

    var isToMany: Bool {
        return unwrappedType is ToManyProtocol.Type
    }

    var isOptional: Bool {
        return Value.self is OptionalProtocol.Type
    }
}

protocol OptionalProtocol {
    static var wrappedType: Any.Type { get }
}

extension Optional: OptionalProtocol {
    static var wrappedType: Any.Type {
        return Wrapped.self
    }
}

protocol ToManyProtocol {
    static var elementType: Any.Type { get }
}

extension Set: ToManyProtocol {
    static var elementType: Any.Type {
        return Element.self
    }
}
