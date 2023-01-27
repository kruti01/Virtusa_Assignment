//
//  Team.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

typealias Teams = [Team]

// MARK: - Welcome
struct TeamModel: Codable {
    let teams: [Team]
}

// MARK: - Team
struct Team: Codable {
    let id, name: String
    let logo: String
}
