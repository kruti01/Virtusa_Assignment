//
//  MatchesService.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 24/01/23.
//

import Foundation

protocol MatchesServiceProtocol {
    func getMatchesDetails(completion: @escaping (_ success: Bool, _ results: MatchModel?, _ error: String?) -> ())
}

class MatchesService: MatchesServiceProtocol {
    func getMatchesDetails(completion: @escaping (Bool, MatchModel?, String?) -> ()) {
        HttpRequestHelper().GET(url: URLIdentifier.baseURL + URLIdentifier.matchesURL, params: ["": ""], httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(MatchModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Teams to model")
                }
            } else {
                completion(false, nil, "Error: Teams GET Request failed")
            }
        }
    }
}
