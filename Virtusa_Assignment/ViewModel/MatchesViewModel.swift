//
//  MatchesViewModel.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

enum TeamType {
    case all
    case filtered
}
class MatchesViewModel: NSObject {
    
    private var matchService: MatchesServiceProtocol
    
    var reloadCollectionView: (() -> Void)?
    
    var selectedTeam = ""
    
    var previousMatches = PreviousMatches()
    var upcomingMatches = UpcomingMatches()
    
    var selectedPreviousMatches = PreviousMatches()
    var selectedUpcomingMatches = UpcomingMatches()
    
    var previousMatchCellViewModels = [MatchCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    var upcomingMatchCellViewModels = [MatchCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    init(matchService: MatchesServiceProtocol = MatchesService()) {
        self.matchService = matchService
    }

    // MARK: - Get matches data methods
    func getMatchesDetails(_ completion: @escaping (() -> Void)) {
        matchService.getMatchesDetails { success, results, error in
            if success, let matchesResult = results {
                self.fetchData(matchesResult: matchesResult)
            } else {
                print(error?.description ?? "")
            }
            completion()
        }
    }
    
    func fetchData(matchesResult: MatchModel) {
        previousMatches = matchesResult.matches.previous
        upcomingMatches = matchesResult.matches.upcoming
       
        previousMatchCellViewModels.removeAll()
        upcomingMatchCellViewModels.removeAll()
      
        previousMatches.forEach { previousMatchData in
            previousMatchCellViewModels.append(createCellModelforPreviousMatches(match: previousMatchData))
        }
        upcomingMatches.forEach { upcomingMatchData in
            upcomingMatchCellViewModels.append(createCellModelforUpcomingMatches(match: upcomingMatchData))
        }
        
        let matches = DatabaseHandler.shared.fetch(MatchesData.self)
        if matches.count == 0 {
            previousMatchCellViewModels.forEach { $0.store()}
            upcomingMatchCellViewModels.forEach { $0.store()}
        }
    }
    
    func createCellModelforPreviousMatches(match: Previous) -> MatchCellViewModel {
        let description = match.description
        let home = match.home
        let away = match.away
        let winner = match.winner.isEmpty ? "" : match.winner
        let highlights = match.highlights.isEmpty ? "" : match.highlights
        
        return MatchCellViewModel(description: description, home: home, away: away, winner: winner, highlights: highlights, matchType: .previous)
    }
    
    func createCellModelforUpcomingMatches(match: Upcoming) -> MatchCellViewModel {
        let description = match.description
        let home = match.home
        let away = match.away
        
        return MatchCellViewModel(description: description, home: home, away: away, winner: "", highlights: "", matchType: .upcoming)
    }
    
    // MARK: - Show all matches data method
    func showAllTeamsMatches() {
        if previousMatches.count > 0 {
            previousMatchCellViewModels.removeAll()
        }
        if upcomingMatches.count > 0 {
            upcomingMatchCellViewModels.removeAll()
        }
        previousMatches.forEach { previousMatchData in
            previousMatchCellViewModels.append(createCellModelforPreviousMatches(match: previousMatchData))
        }
        upcomingMatches.forEach { upcomingMatchData in
            upcomingMatchCellViewModels.append(createCellModelforUpcomingMatches(match: upcomingMatchData))
        }
    }
    
    // MARK: - Show selected team's matches data method
    func showSelectedTeamMatches(selectedTeam: String) {
        self.selectedTeam = selectedTeam

        selectedPreviousMatches = previousMatches.filter({ previousMatch in
            previousMatch.home == selectedTeam || previousMatch.away == selectedTeam
        })
        selectedUpcomingMatches = upcomingMatches.filter({ upcomingMatch in
            upcomingMatch.home == selectedTeam || upcomingMatch.away == selectedTeam
        })

        previousMatchCellViewModels.removeAll()
        upcomingMatchCellViewModels.removeAll()
        
        selectedPreviousMatches.forEach { previousMatch in
            previousMatchCellViewModels.append(createCellModelforPreviousMatches(match: previousMatch))
        }
        selectedUpcomingMatches.forEach { upcomingMatch in
            upcomingMatchCellViewModels.append(createCellModelforUpcomingMatches(match: upcomingMatch))
        }
    }
    
    // MARK: - Get matches data from database methods
    func getDataFromDatabase(matches: [MatchesData], _ completion: () -> Void) {
        previousMatchCellViewModels.removeAll()
        upcomingMatchCellViewModels.removeAll()
            matches.forEach { match in
                if !(match.highlights?.isEmpty ?? true) {
                    previousMatchCellViewModels.append(createCellModelforDatabaseMatches(match: match))
                } else {
                    upcomingMatchCellViewModels.append(createCellModelforDatabaseMatches(match: match))
                }
            }
        completion()
    }
    
    func createCellModelforDatabaseMatches(match: MatchesData) -> MatchCellViewModel {
        let description = match.matchDescription
        let home = match.home
        let away = match.away
        let winner = match.winner?.isEmpty ?? true ? "" : match.winner
        let highlights = match.highlights?.isEmpty ?? true ? "" : match.highlights
        
        return MatchCellViewModel(description: description, home: home, away: away, winner: winner, highlights: highlights, matchType: !(match.highlights?.isEmpty ?? true) ? .previous : .upcoming)
    }
}
