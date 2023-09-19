import CoreData

@available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
public struct CoreDataFetchIndexDescription {
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

    public static func index(name: String, elements: [Element]) -> CoreDataFetchIndexDescription {
        CoreDataFetchIndexDescription(name: name, elements: elements)
    }

    public var name: String
    public var elements: [Element]
}
