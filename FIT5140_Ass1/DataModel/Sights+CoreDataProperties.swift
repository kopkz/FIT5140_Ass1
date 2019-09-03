//
//  Sights+CoreDataProperties.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 1/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//
//

import Foundation
import CoreData


extension Sights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sights> {
        return NSFetchRequest<Sights>(entityName: "Sights")
    }

    @NSManaged public var descripution: String?
    @NSManaged public var iconName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var shortDesscripution: String?
    @NSManaged public var sightImages: NSSet?

}

// MARK: Generated accessors for sightImages
extension Sights {

    @objc(addSightImagesObject:)
    @NSManaged public func addToSightImages(_ value: Images)

    @objc(removeSightImagesObject:)
    @NSManaged public func removeFromSightImages(_ value: Images)

    @objc(addSightImages:)
    @NSManaged public func addToSightImages(_ values: NSSet)

    @objc(removeSightImages:)
    @NSManaged public func removeFromSightImages(_ values: NSSet)

}
