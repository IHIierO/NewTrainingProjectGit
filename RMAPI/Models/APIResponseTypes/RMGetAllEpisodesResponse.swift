//
//  RMGetAllEpisodesResponse.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 27.01.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let preview: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
