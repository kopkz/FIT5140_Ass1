//
//  Images+CoreDataProperties.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 1/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var imageOfSight: NSSet?

}

// MARK: Generated accessors for imageOfSight
extension Images {

    @objc(addImageOfSightObject:)
    @NSManaged public func addToImageOfSight(_ value: Sights)

    @objc(removeImageOfSightObject:)
    @NSManaged public func removeFromImageOfSight(_ value: Sights)

    @objc(addImageOfSight:)
    @NSManaged public func addToImageOfSight(_ values: NSSet)

    @objc(removeImageOfSight:)
    @NSManaged public func removeFromImageOfSight(_ values: NSSet)

}
