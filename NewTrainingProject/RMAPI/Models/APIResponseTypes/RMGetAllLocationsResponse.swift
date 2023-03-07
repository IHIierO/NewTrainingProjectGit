//
//  RMGetAllLocationsResponce.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.02.2023.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let preview: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
