//
//  MatchCellViewModel.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

struct MatchCellViewModel : Hashable {
    let description, home, away: String
    let winner: String?
    let highlights: String?
    let matchType: MatchType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(home)
    }
    static func ==(lhs: MatchCellViewModel, rhs: MatchCellViewModel) -> Bool {
        return lhs.home == rhs.home
    }
    
    static let database = DatabaseHandler.shared
    func store() {
        guard let match = MatchCellViewModel.database.add(MatchesData.self) else {return}
        match.matchDescription = description
        match.home = home
        match.away = away
        match.highlights = highlights
        match.winner = winner
        MatchCellViewModel.database.save()
    }
    
}
