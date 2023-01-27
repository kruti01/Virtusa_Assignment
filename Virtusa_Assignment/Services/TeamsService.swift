//
//  TeamsService.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

protocol TeamsServiceProtocol {
    func getTeams(completion: @escaping (_ success: Bool, _ results: TeamModel?, _ error: String?) -> ())
}

class TeamsService: TeamsServiceProtocol {
    func getTeams(completion: @escaping (Bool, TeamModel?, String?) -> ()) {
        HttpRequestHelper().GET(url: URLIdentifier.baseURL+URLIdentifier.teamsURL, params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(TeamModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse matches to model")
                }
            } else {
                completion(false, nil, "Error: Matches GET Request failed")
            }
        }
    }
}
