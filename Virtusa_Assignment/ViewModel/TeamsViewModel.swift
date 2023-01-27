//
//  TeamsViewModel.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

class TeamsViewModel: NSObject {
    
    private var teamService: TeamsServiceProtocol
    
    var reloadTabelView: (() -> Void)?
    
    var teams = Teams()
    
    var selectedTeam = ""

    var teamCellViewModels = [TeamCellViewModel]() {
        didSet {
            reloadTabelView?()
        }
    }
    
    init(teamService: TeamsServiceProtocol = TeamsService()) {
        self.teamService = teamService
    }
    
    // MARK: - Get teams data methods
    func getTeamsDetails(_ completion: @escaping (() -> Void)) {
        self.teamService.getTeams { success, results, error in
            if success, let teamsResultData = results {
                self.fetchData(teamsResultData: teamsResultData)
            } else {
                print(error?.description ?? "")
            }
            completion()
        }
    }
    
    func fetchData(teamsResultData: TeamModel) {
        teams = teamsResultData.teams
        teamCellViewModels.removeAll()
        for teamData in teams {
            teamCellViewModels.append(createCellModel(team: teamData))
        }
        let teams = DatabaseHandler.shared.fetch(TeamsData.self)
        if teams.count == 0 {
            teamCellViewModels.forEach { $0.store()}
        }
    }

    func createCellModel(team: Team) -> TeamCellViewModel {
        let id = team.id
        let name = team.name
        let logo = team.logo
        return TeamCellViewModel(id: id, name: name, logo: logo)
    }
    
    // MARK: - Get teams data from database methods
    func getDataFromDatabase(teams: [TeamsData], _ completion: () -> Void) {
        teamCellViewModels.removeAll()
        teams.forEach { teamData in
            teamCellViewModels.append(createCellModelFromDatabase(team: teamData))
        }
        completion()
    }
    
    func createCellModelFromDatabase(team: TeamsData) -> TeamCellViewModel {
        let id = team.id
        let name = team.name
        let logo = team.logo
        return TeamCellViewModel(id: id, name: name, logo: logo)
    }
    
    // MARK: - select team
    func selectTeamAt(index: Int) {
        guard index < teamCellViewModels.count else{return}
        selectedTeam = self.teamCellViewModels[index].name == selectedTeam ? "" : self.teamCellViewModels[index].name
    }
}
