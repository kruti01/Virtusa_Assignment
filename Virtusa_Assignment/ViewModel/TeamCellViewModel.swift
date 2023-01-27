//
//  TeamCellViewModel.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

struct TeamCellViewModel: Codable, Hashable {
    let id, name: String
    let logo: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    static func ==(lhs: TeamCellViewModel, rhs: TeamCellViewModel) -> Bool {
        return lhs.name == rhs.name
    }
    static let database = DatabaseHandler.shared
    func store() {
        guard let team = TeamCellViewModel.database.add(TeamsData.self) else {return}
        team.id = id
        team.name = name
        team.logo = logo
        
        TeamCellViewModel.database.save()
    }
}
