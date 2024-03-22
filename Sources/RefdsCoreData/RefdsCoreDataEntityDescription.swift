import CoreData

public struct RefdsCoreDataEntityDescription {
    public static func entity(
        name: String,
        managedObjectClass: NSManagedObject.Type = NSManagedObject.self,
        parentEntity: String? = nil,
        isAbstract: Bool = false,
        attributes: [RefdsCoreDataAttributeDescription] = [],
        fetchedProperties: [RefdsCoreDataFetchedPropertyDescription] = [],
        relationships: [RefdsCoreDataRelationshipDescription] = [],
        indexes: [RefdsCoreDataFetchIndexDescription] = [],
        constraints: [Any] = [],
        configuration: String? = nil
    ) -> RefdsCoreDataEntityDescription {
        RefdsCoreDataEntityDescription(
            name: name,
            managedObjectClassName: NSStringFromClass(managedObjectClass),
            parentEntity: parentEntity,
            isAbstract: isAbstract,
            attributes: attributes,
            fetchedProperties: fetchedProperties,
            relationships: relationships,
            indexes: indexes,
            constraints: constraints,
            configuration: configuration
        )
    }
    
    public var name: String
    public var managedObjectClassName: String
    public var parentEntity: String?
    public var isAbstract: Bool
    public var attributes: [RefdsCoreDataAttributeDescription]
    public var fetchedProperties: [RefdsCoreDataFetchedPropertyDescription]
    public var relationships: [RefdsCoreDataRelationshipDescription]
    public var indexes: [RefdsCoreDataFetchIndexDescription]
    public var constraints: [Any]
    public var configuration: String?
}
