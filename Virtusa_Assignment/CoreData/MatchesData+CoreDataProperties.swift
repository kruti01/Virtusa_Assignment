//
//  MatchesData+CoreDataProperties.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 26/01/23.
//
//

import Foundation
import CoreData


extension MatchesData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchesData> {
        return NSFetchRequest<MatchesData>(entityName: "MatchesData")
    }

    @NSManaged public var away: String
    @NSManaged public var highlights: String?
    @NSManaged public var home: String
    @NSManaged public var matchDescription: String
    @NSManaged public var winner: String?

}

extension MatchesData : Identifiable {

}
