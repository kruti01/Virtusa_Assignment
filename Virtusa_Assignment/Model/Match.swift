//
//  Match.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

typealias PreviousMatches = [Previous]
typealias UpcomingMatches = [Upcoming]

enum MatchType {
    case previous
    case upcoming
}

// MARK: - Welcome
struct MatchModel: Codable {
    let matches: Matches
}

// MARK: - Matches
struct Matches: Codable {
    let previous: [Previous]
    let upcoming: [Upcoming]
}

// MARK: - Previous
struct Previous: Codable {
    let date, description, home, away: String
    let winner: String
    let highlights: String
}

// MARK: - Upcoming
struct Upcoming: Codable {
    let date, description, home, away: String
}
