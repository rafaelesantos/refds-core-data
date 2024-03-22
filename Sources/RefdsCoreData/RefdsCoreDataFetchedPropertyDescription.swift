import CoreData

public struct RefdsCoreDataFetchedPropertyDescription {
    public static func fetchedProperty(
        name: String,
        fetchRequest: NSFetchRequest<NSFetchRequestResult>,
        isOptional: Bool = false
    ) -> RefdsCoreDataFetchedPropertyDescription {
        return RefdsCoreDataFetchedPropertyDescription(
            name: name,
            fetchRequest: fetchRequest,
            isOptional: isOptional
        )
    }

    public var name: String
    public var fetchRequest: NSFetchRequest<NSFetchRequestResult>
    public var isOptional: Bool

    public func makeFetchedProperty() -> NSFetchedPropertyDescription {
        let fetchedProperty = NSFetchedPropertyDescription()
        fetchedProperty.name = name
        fetchedProperty.fetchRequest = fetchRequest
        fetchedProperty.isOptional = isOptional

        return fetchedProperty
    }
}
