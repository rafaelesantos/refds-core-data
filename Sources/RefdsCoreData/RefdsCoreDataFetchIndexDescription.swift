import CoreData

public struct RefdsCoreDataFetchIndexDescription {
    public struct Element {
        public enum Property {
            case property(name: String)
            case expression(type: String)
        }

        public static func property(
            name: String,
            type: NSFetchIndexElementType = .binary,
            ascending: Bool = true
        ) -> Element {
            Element(
                property: .property(name: name),
                type: type,
                ascending: ascending
            )
        }

        public var property: Property
        public var type: NSFetchIndexElementType
        public var ascending: Bool
    }

    public static func index(name: String, elements: [Element]) -> RefdsCoreDataFetchIndexDescription {
        RefdsCoreDataFetchIndexDescription(name: name, elements: elements)
    }

    public var name: String
    public var elements: [Element]
}
