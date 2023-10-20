import CoreData
import RefdsCore

public extension NSPersistentCloudKitContainer {
    static func make(
        name: String = "ApplicationEntity",
        model: NSManagedObjectModel,
        store: String,
        cloudContainerId: String
    ) -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: name, managedObjectModel: model)
        guard let storeURL = try? URL.storeURL(for: store, databaseName: name) else {
            fatalError("Unresolved error: store url")
        }
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: cloudContainerId)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }
    
    static func make(
        name: String = "ApplicationEntity",
        model: NSManagedObjectModel
    ) -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: name, managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("FakePersistentContainer: Falha ao carregar persistent store \(error)")
            }
        }
        return container
    }
}
