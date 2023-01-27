//
//  TeamsData+CoreDataProperties.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 27/01/23.
//
//

import Foundation
import CoreData


extension TeamsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamsData> {
        return NSFetchRequest<TeamsData>(entityName: "TeamsData")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var logo: String

}

extension TeamsData : Identifiable {

}
