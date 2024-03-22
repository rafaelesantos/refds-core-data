import CoreData

public struct RefdsCoreDataModelDescription {
    public var entities: [RefdsCoreDataEntityDescription]

    public init(entities: [RefdsCoreDataEntityDescription]) {
        self.entities = entities
    }

    public func makeModel(byMerging model: NSManagedObjectModel = NSManagedObjectModel()) -> NSManagedObjectModel {
        let entitiesDescriptions = self.entities
        let entities: [NSEntityDescription]
        var entityNameToEntity: [String: NSEntityDescription] = [:]
        var configurationNameToEntities: [String: Array<NSEntityDescription>] = [:]
        var entityNameToPropertyNameToProperty: [String: [String: NSPropertyDescription]] = [:]

        for entityDescription in entitiesDescriptions {
            let entity = NSEntityDescription()
            entity.name = entityDescription.name
            entity.managedObjectClassName = entityDescription.managedObjectClassName
            entity.isAbstract = entityDescription.isAbstract

            var propertyNameToProperty: [String: NSPropertyDescription] = [:]

            for attributeDescription in entityDescription.attributes {
                let attribute = attributeDescription.makeAttribute()
                propertyNameToProperty[attribute.name] = attribute
            }

            for fetchedPropertyDescription in entityDescription.fetchedProperties {
                let fetchedProperty = fetchedPropertyDescription.makeFetchedProperty()
                propertyNameToProperty[fetchedProperty.name] = fetchedProperty
            }

            entity.properties = Array(propertyNameToProperty.values)
            entity.uniquenessConstraints = [entityDescription.constraints]

            entityNameToEntity[entityDescription.name] = entity

            if let configurationName = entityDescription.configuration {
                var configurationEntities = configurationNameToEntities[configurationName] ?? []
                configurationEntities.append(entity)
                configurationNameToEntities[configurationName] = configurationEntities
            }

            entityNameToPropertyNameToProperty[entityDescription.name] = propertyNameToProperty
        }

        var relationshipsWithInverse: [(RefdsCoreDataRelationshipDescription, NSRelationshipDescription)] = []

        for entityDescription in entitiesDescriptions {
            let entity = entityNameToEntity[entityDescription.name]!

            var propertyNameToProperty: [String: NSPropertyDescription] = [:]

            for relationshipDescription in entityDescription.relationships {
                let relationship = NSRelationshipDescription()
                relationship.name = relationshipDescription.name
                relationship.maxCount = relationshipDescription.maxCount
                relationship.minCount = relationshipDescription.minCount
                relationship.isOrdered = relationshipDescription.ordered
                relationship.deleteRule = relationshipDescription.deleteRule
                relationship.isOptional = relationshipDescription.optional

                var destinationEntity = entityNameToEntity[relationshipDescription.destination]
                if destinationEntity == nil {
                    destinationEntity = model.entitiesByName[relationshipDescription.destination]
                }
                assert(destinationEntity != nil, "Can not find destination entity: '\(relationshipDescription.destination)', in relationship '\(relationshipDescription.name)', for entity: '\(entityDescription.name)'")
                relationship.destinationEntity = destinationEntity

                if let _ = relationshipDescription.inverse {
                    relationshipsWithInverse.append((relationshipDescription, relationship))
                }

                propertyNameToProperty[relationshipDescription.name] = relationship
                entityNameToPropertyNameToProperty[entityDescription.name]![relationshipDescription.name] = relationship
            }

            entity.properties += Array(propertyNameToProperty.values)

            if let parentName = entityDescription.parentEntity {
                let parentEntity = entityNameToEntity[parentName]
                assert(parentEntity != nil, "Can not find parent entity: '\(parentName)', for entity: '\(entityDescription.name)'")
                parentEntity?.subentities += [entity]
            }
        }

        for el in relationshipsWithInverse {
            let relationshipDescription = el.0
            let relationship = el.1

            let inverseRelationshipName = relationshipDescription.inverse!
            let inverseRelationship = relationship.destinationEntity!.propertiesByName[inverseRelationshipName] as? NSRelationshipDescription

            assert(inverseRelationship != nil, "Can not find inverse relationship '\(inverseRelationshipName)', for relationship: '\(relationshipDescription.name)', for entity: '\(relationship.entity.name ?? "nil")', destination entity: '\(relationship.destinationEntity!.name ?? "nil")'")

            relationship.inverseRelationship = inverseRelationship
        }

        entities = Array(entityNameToEntity.values)

        for entityDescription in entitiesDescriptions {
            let entity = entityNameToEntity[entityDescription.name]!
            let propertyNameToProperty = entityNameToPropertyNameToProperty[entityDescription.name] ?? [:]

            entity.indexes = entityDescription.indexes.map { indexDescription in
                let elements: [NSFetchIndexElementDescription] = indexDescription.elements.compactMap { elementDescription in
                    switch elementDescription.property {
                        case .property(let name):
                            guard let property = propertyNameToProperty[name] else {
                                assertionFailure("Can not find attribute, fetched property, or relationship with name: \(name).")
                                return nil
                            }

                            return NSFetchIndexElementDescription(property: property, collationType: elementDescription.type)

                        case .expression:
                            assertionFailure("Expression indexes are not supported yet")
                            return nil
                        }
                    }

                return NSFetchIndexDescription(name: indexDescription.name, elements: elements)
            }
        }
        
        model.entities.append(contentsOf: entities)

        for (configurationName, entities) in configurationNameToEntities {
            model.setEntities(entities, forConfigurationName: configurationName)
        }
        
        return model
    }
}
