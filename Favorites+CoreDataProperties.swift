//
//  Favorites+CoreDataProperties.swift
//  Pote
//
//  Created by macbook on 10.11.20.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var image: String?

}

extension Favorites : Identifiable {

}
